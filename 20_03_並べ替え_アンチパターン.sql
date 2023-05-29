use day_19_21_db

-- 無駄な group by

explain analyze
select 
age, count(*)
from customers
group by age

/*
-> Table scan on <temporary>  (actual time=220..220 rows=49 loops=1)
    -> Aggregate using temporary table  (actual time=220..220 rows=49 loops=1)
        -> Table scan on customers  (cost=50480 rows=497345) (actual time=0.135..129 rows=500000 loops=1)

*/


explain analyze
select 
age, count(*)
from customers
group by age
having age < 30

/*
 -> Filter: (customers.age < 30)  (actual time=244..244 rows=8 loops=1)
    -> Table scan on <temporary>  (actual time=244..244 rows=49 loops=1)
        -> Aggregate using temporary table  (actual time=244..244 rows=49 loops=1)
            -> Table scan on customers  (cost=50480 rows=497345) (actual time=0.0774..143 rows=500000 loops=1)
*/


## 無駄なhavingをwhereで書き換えることで処理が高速になる
create index idx_customers_age on customers(age)

explain analyze
select 
age, count(*)
from customers
where age < 30
group by age

/*
-> Group aggregate: count(0)  (cost=48687 rows=45) (actual time=5.1..44.9 rows=8 loops=1)
    -> Filter: (customers.age < 30)  (cost=32491 rows=161958) (actual time=0.0405..41.3 rows=82096 loops=1)
        -> Covering index range scan on customers using idx_customers_age over (NULL < age < 30)  (cost=32491 rows=161958) (actual time=0.0382..36.2 rows=82096 loops=1)
*/


-- MAX, MIN はインデックスを利用する

explain analyze
select max(age), min(age) from customers c 

/*
-> Rows fetched before execution  (cost=0..0 rows=1) (actual time=300e-6..400e-6 rows=1 loops=1)
*/


explain analyze
select sum(age), avg(age) from customers c 

/*
-> Aggregate: sum(c.age), avg(c.age)  (cost=100214 rows=1) (actual time=214..214 rows=1 loops=1)
    -> Covering index scan on c using idx_customers_age  (cost=50480 rows=497345) (actual time=0.03..156 rows=500000 loops=1)
*/


-- distinct の代わりに exists 
explain analyze
select distinct pr.name from prefectures as pr
inner join customers as ct 
on pr.prefecture_code = ct.prefecture_code 

/*
-> Table scan on <temporary>  (cost=274285..280504 rows=497345) (actual time=812..812 rows=41 loops=1)
    -> Temporary table with deduplication  (cost=274285..274285 rows=497345) (actual time=812..812 rows=41 loops=1)
        -> Nested loop inner join  (cost=224550 rows=497345) (actual time=0.0504..657 rows=500000 loops=1)
            -> Filter: (ct.prefecture_code is not null)  (cost=50480 rows=497345) (actual time=0.0389..175 rows=500000 loops=1)
                -> Table scan on ct  (cost=50480 rows=497345) (actual time=0.0384..148 rows=500000 loops=1)
            -> Single-row index lookup on pr using PRIMARY (prefecture_code=ct.prefecture_code)  (cost=0.25 rows=1) (actual time=832e-6..851e-6 rows=1 loops=500000)
*/


## exists を使って高速化
explain analyze
select pr.name from prefectures as pr
where exists (
	select 1 from customers as ct where pr.prefecture_code = ct.prefecture_code
)

/*
-> Nested loop inner join  (cost=2.34e+6 rows=23.4e+6) (actual time=200..200 rows=41 loops=1)
    -> Table scan on pr  (cost=4.95 rows=47) (actual time=0.0564..0.0771 rows=47 loops=1)
    -> Single-row index lookup on <subquery2> using <auto_distinct_key> (prefecture_code=pr.prefecture_code)  (cost=100214..100214 rows=1) (actual time=4.25..4.25 rows=0.872 loops=47)
        -> Materialize with deduplication  (cost=100214..100214 rows=497345) (actual time=200..200 rows=41 loops=1)
            -> Filter: (ct.prefecture_code is not null)  (cost=50480 rows=497345) (actual time=0.0435..133 rows=500000 loops=1)
                -> Table scan on ct  (cost=50480 rows=497345) (actual time=0.043..109 rows=500000 loops=1)
*/


-- union -> union all 
explain analyze
select * from customers where age < 30
union 
select * from customers where age > 40

/*
-> Table scan on <union temporary>  (cost=142022..147157 rows=410630) (actual time=3220..3853 rows=387766 loops=1)
    -> Union materialize with deduplication  (cost=142022..142022 rows=410630) (actual time=3219..3219 rows=387766 loops=1)
        -> Filter: (customers.age < 30)  (cost=50480 rows=161958) (actual time=0.0888..340 rows=82096 loops=1)
            -> Table scan on customers  (cost=50480 rows=497345) (actual time=0.0844..313 rows=500000 loops=1)
        -> Filter: (customers.age > 40)  (cost=50480 rows=248672) (actual time=0.0975..567 rows=305670 loops=1)
            -> Table scan on customers  (cost=50480 rows=497345) (actual time=0.0965..529 rows=500000 loops=1)
*/


explain analyze
select * from customers where age < 30
union all
select * from customers where age > 40

/*
-> Append  (cost=104089 rows=410630) (actual time=0.978..996 rows=387766 loops=1)
    -> Stream results  (cost=52044 rows=161958) (actual time=0.977..556 rows=82096 loops=1)
        -> Filter: (customers.age < 30)  (cost=52044 rows=161958) (actual time=0.969..517 rows=82096 loops=1)
            -> Table scan on customers  (cost=52044 rows=497345) (actual time=0.966..494 rows=500000 loops=1)
    -> Stream results  (cost=52044 rows=248672) (actual time=0.0895..424 rows=305670 loops=1)
        -> Filter: (customers.age > 40)  (cost=52044 rows=248672) (actual time=0.0857..298 rows=305670 loops=1)
            -> Table scan on customers  (cost=52044 rows=497345) (actual time=0.085..272 rows=500000 loops=1)

*/
