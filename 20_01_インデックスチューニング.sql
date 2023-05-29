use day_19_21_db

select * from customers

explain analyze select * from customers where first_name = 'Olivia'

/*
-> Filter: (customers.first_name = 'Olivia')  (cost=50524 rows=49779) (actual time=0.076..319 rows=503 loops=1)
    -> Table scan on customers  (cost=50524 rows=497786) (actual time=0.0729..281 rows=500000 loops=1)
*/


-- first_name に index 追加
create index idx_customers_first_name on customers(first_name)

explain analyze select * from customers where first_name = 'Olivia'

/*
-> Index lookup on customers using idx_customers_first_name (first_name='Olivia')  (cost=176 rows=503) (actual time=0.464..2.02 rows=503 loops=1)
*/


explain analyze select * from customers where age=41

/*
-> Filter: (customers.age = 41)  (cost=50524 rows=49779) (actual time=0.097..343 rows=10100 loops=1)
    -> Table scan on customers  (cost=50524 rows=497786) (actual time=0.0791..317 rows=500000 loops=1)
*/

create index idx_customers_age on customers(age)

explain analyze select * from customers where age=41

/*
 -> Index lookup on customers using idx_customers_age (age=41)  (cost=3245 rows=10100) (actual time=0.294..31.3 rows=10100 loops=1)
*/

explain analyze select * from customers where first_name = 'Olivia' and age=41

/*
-> Filter: ((customers.age = 41) and (customers.first_name = 'Olivia'))  (cost=35.6 rows=10) (actual time=4.11..8.57 rows=8 loops=1)
    -> Intersect rows sorted by row ID  (cost=35.6 rows=10.2) (actual time=4.1..8.55 rows=8 loops=1)
        -> Index range scan on customers using idx_customers_first_name over (first_name = 'Olivia')  (cost=24.9 rows=503) (actual time=1.01..1.44 rows=503 loops=1)
        -> Index range scan on customers using idx_customers_age over (age = 41)  (cost=7.16 rows=10100) (actual time=0.066..6.06 rows=10094 loops=1)
*/

explain analyze select * from customers where first_name = 'Olivia' or age=41

/*
-> Filter: ((customers.first_name = 'Olivia') or (customers.age = 41))  (cost=4436 rows=10593) (actual time=0.0665..45.4 rows=10595 loops=1)
    -> Deduplicate rows sorted by row ID  (cost=4436 rows=10593) (actual time=0.0648..43.5 rows=10595 loops=1)
        -> Index range scan on customers using idx_customers_first_name over (first_name = 'Olivia')  (cost=75.2 rows=503) (actual time=0.0403..0.318 rows=503 loops=1)
        -> Index range scan on customers using idx_customers_age over (age = 41)  (cost=1017 rows=10100) (actual time=0.0126..4.23 rows=10100 loops=1)
*/


-- 複合インデックス
drop index idx_customers_first_name on customers
drop index idx_customers_age on customers

create index idx_customers_first_name_age on customers(first_name, age)

explain analyze select * from customers where first_name = 'Olivia' and age=41

/*
-> Index lookup on customers using idx_customers_first_name_age (first_name='Olivia', age=41)  (cost=2.8 rows=8) (actual time=0.416..0.441 rows=8 loops=1)
*/

explain analyze select * from customers where age=41	-- age だけはフルスキャン
explain analyze select * from customers where first_name = 'Olivia' or age=41	-- or もスキャンになる




-- order by, gropu by : 処理時間がかかる。実行前にwhereで絞り込む
drop index idx_customers_first_name_age on customers

explain analyze select * from customers order by first_name 

/*
-> Sort: customers.first_name  (cost=50524 rows=497786) (actual time=746..804 rows=500000 loops=1)
    -> Table scan on customers  (cost=50524 rows=497786) (actual time=0.0751..273 rows=500000 loops=1)
*/

create index idx_customers_first_name on customers(first_name)

explain analyze select /*+ INDEX(customers) */* from customers order by first_name 	-- index あり

/*
-> Sort: customers.first_name  (cost=50524 rows=497786) (actual time=783..842 rows=500000 loops=1)
    -> Table scan on customers  (cost=50524 rows=497786) (actual time=0.0757..303 rows=500000 loops=1)
*/

/*
 * idx を付けたのに遅くなっている
-> Index scan on customers using idx_customers_first_name  (cost=174225 rows=497786) (actual time=1.35..1606 rows=500000 loops=1)
*/


explain analyze select * from customers order by id

/*
-> Index scan on customers using PRIMARY  (cost=50524 rows=497786) (actual time=0.102..281 rows=500000 loops=1)
*/


explain analyze select first_name, count(*) from customers group by first_name

/*
-> Group aggregate: count(0)  (cost=100302 rows=723) (actual time=0.535..158 rows=690 loops=1)
    -> Covering index scan on customers using idx_customers_first_name  (cost=50524 rows=497786) (actual time=0.0488..105 rows=500000 loops=1)
*/

create index idx_customers_age on customers(age)

explain analyze select age, count(*) from customers group by age

/*
-> Group aggregate: count(0)  (cost=100302 rows=47) (actual time=11.7..206 rows=49 loops=1)
    -> Covering index scan on customers using idx_customers_age  (cost=50524 rows=497786) (actual time=0.0553..187 rows=500000 loops=1)
*/

drop index idx_customers_first_name on customers
drop index idx_customers_age on customers


-- 複数のgruop by
create index idx_customers_name_age on customers(first_name, age)
explain analyze select first_name, age, count(*) from customers group by first_name ,age

/*
-> Group aggregate: count(0)  (cost=100302 rows=34101) (actual time=7.39..305 rows=32369 loops=1)
    -> Covering index scan on customers using idx_customers_name_age  (cost=50524 rows=497786) (actual time=7.37..244 rows=500000 loops=1)
*/

drop index idx_customers_name_age on customers


-- 外部キーにインデックス
explain analyze
select * from prefectures as pr
inner join customers as ct 
on pr.prefecture_code = ct.prefecture_code and pr.name = '北海道'

/*
-> Nested loop inner join  (cost=224749 rows=49779) (actual time=0.231..948 rows=12321 loops=1)
    -> Filter: (ct.prefecture_code is not null)  (cost=50524 rows=497786) (actual time=0.121..350 rows=500000 loops=1)
        -> Table scan on ct  (cost=50524 rows=497786) (actual time=0.12..319 rows=500000 loops=1)
    -> Filter: (pr.`name` = '北海道')  (cost=0.25 rows=0.1) (actual time=0.00112..0.00112 rows=0.0246 loops=500000)
        -> Single-row index lookup on pr using PRIMARY (prefecture_code=ct.prefecture_code)  (cost=0.25 rows=1) (actual time=870e-6..891e-6 rows=1 loops=500000)
*/


create index idx_customers_prefecture_code on customers(prefecture_code)

explain analyze
select * from prefectures as pr
inner join customers as ct 

/*
on pr.prefecture_code = ct.prefecture_code and pr.name = '北海道'
-> Nested loop inner join  (cost=16080 rows=55705) (actual time=8.14..45.6 rows=12321 loops=1)
    -> Filter: (pr.`name` = '北海道')  (cost=4.95 rows=4.7) (actual time=0.0336..0.0479 rows=1 loops=1)
        -> Table scan on pr  (cost=4.95 rows=47) (actual time=0.0312..0.0393 rows=47 loops=1)
    -> Index lookup on ct using idx_customers_prefecture_code (prefecture_code=pr.prefecture_code)  (cost=2487 rows=11852) (actual time=8.1..44.9 rows=12321 loops=1)
*/


drop index idx_customers_prefecture_code on customers