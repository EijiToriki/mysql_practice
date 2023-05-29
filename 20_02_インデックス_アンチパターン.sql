select * from customers limit 10

-- index なし
select * from customers where upper(first_name) = "JOSEPH" 


-- index あり
create index idx_customers_first_name on customers(first_name)

explain analyze select * from customers where upper(first_name) = "JOSEPH" 

/*
テーブルスキャンになっている
-> Filter: (upper(customers.first_name) = 'JOSEPH')  (cost=50524 rows=497786) (actual time=0.0651..351 rows=4712 loops=1)
    -> Table scan on customers  (cost=50524 rows=497786) (actual time=0.0611..284 rows=500000 loops=1)
*/

create index idx_customers_upper_first_name on customers((upper(first_name)))

explain analyze select * from customers where upper(first_name) = "JOSEPH" 

/*
大した早くならない
-> Index lookup on customers using idx_customers_upper_first_name (upper(first_name)='JOSEPH')  (cost=1649 rows=4712) (actual time=0.264..22.7 rows=4712 loops=1)
*/

explain analyze select * from customers where first_name in ("JOSEPH", "Joseph", "JOSEPH") 

/*
-> Index range scan on customers using idx_customers_first_name over (first_name = 'JOSEPH'), with index condition: (customers.first_name in ('JOSEPH','Joseph','JOSEPH'))  (cost=2121 rows=4712) (actual time=0.0659..27.4 rows=4712 loops=1)
*/

drop index idx_customers_upper_first_name on customers

create index idx_customers_age on customers(age)

explain analyze select * from customers where age = 25

/*
-> Index lookup on customers using idx_customers_age (age=25)  (cost=3264 rows=10286) (actual time=0.512..58.4 rows=10286 loops=1)
*/

explain analyze select * from customers where age+2 = 25

/*
テーブルスキャンになる
-> Filter: ((customers.age + 2) = 25)  (cost=50480 rows=497345) (actual time=0.206..375 rows=10197 loops=1)
    -> Table scan on customers  (cost=50480 rows=497345) (actual time=0.0675..340 rows=500000 loops=1)
*/


-- 文字列と数値の比較
create index idx_customers_prefecture_code on customers(prefecture_code)
explain analyze select * from customers c  where prefecture_code = 21

/*
-> Filter: (c.prefecture_code = 21)  (cost=50480 rows=49735) (actual time=0.0655..323 rows=12192 loops=1)
    -> Table scan on c  (cost=50480 rows=497345) (actual time=0.0591..282 rows=500000 loops=1)
*/

explain analyze select * from customers c  where prefecture_code = "21"

/*
-> Index lookup on c using idx_customers_prefecture_code (prefecture_code='21'), with index condition: (c.prefecture_code = '21')  (cost=4429 rows=21942) (actual time=0.829..147 rows=12192 loops=1)
*/


-- 前方一致、後方一致、中間一致
drop index idx_customers_first_name on customers
create index idx_customers_first_name on customers(first_name)

explain analyze select * from customers where first_name like "Jo%"

/*
レンジスキャン
-> Index range scan on customers using idx_customers_first_name over ('Jo' <= first_name <= 'Jo􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿􏿿'), with index condition: (customers.first_name like 'Jo%')  (cost=23498 rows=52218) (actual time=0.241..214 rows=24521 loops=1)
*/

explain analyze select * from customers where first_name like "%A"

/*
フルスキャン
-> Filter: (customers.first_name like '%A')  (cost=50480 rows=55255) (actual time=0.0826..360 rows=92504 loops=1)
    -> Table scan on customers  (cost=50480 rows=497345) (actual time=0.08..290 rows=500000 loops=1)

*/


explain analyze select * from customers where first_name like "%Jo%"

/*
フルスキャン
-> Filter: (customers.first_name like '%Jo%')  (cost=50480 rows=55255) (actual time=0.0644..328 rows=24521 loops=1)
    -> Table scan on customers  (cost=50480 rows=497345) (actual time=0.061..269 rows=500000 loops=1)
*/


explain analyze select * from customers where first_name like "%Jo%" LIMIT 50000

/*
-> Limit: 50000 row(s)  (cost=50480 rows=50000) (actual time=0.0613..359 rows=24521 loops=1)
    -> Filter: (customers.first_name like '%Jo%')  (cost=50480 rows=55255) (actual time=0.0606..358 rows=24521 loops=1)
        -> Table scan on customers  (cost=50480 rows=497345) (actual time=0.057..294 rows=500000 loops=1)
*/

explain analyze select * from (select * from customers limit 50000) as tmp where first_name like "%Jo%"

/*
-> Filter: (tmp.first_name like '%Jo%')  (cost=55471..5628 rows=5555) (actual time=53.9..64.3 rows=2423 loops=1)
    -> Table scan on tmp  (cost=55480..56107 rows=50000) (actual time=53.9..59.4 rows=50000 loops=1)
        -> Materialize  (cost=55480..55480 rows=50000) (actual time=53.9..53.9 rows=50000 loops=1)
            -> Limit: 50000 row(s)  (cost=50480 rows=50000) (actual time=0.0902..28 rows=50000 loops=1)
                -> Table scan on customers  (cost=50480 rows=497345) (actual time=0.0895..26.2 rows=50000 loops=1)
*/


show index from customers

drop index idx_customers_age on customers
drop index idx_customers_prefecture_code on customers
drop index idx_customers_first_name on customers
