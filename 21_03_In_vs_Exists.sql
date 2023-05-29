use day_19_21_db


select count(*) from prefectures

select count(*) from customers

create index idx_customers_prefecture_code on customers(prefecture_code)

-- prefectures < customers
-- exists 
explain analyze
select * from prefectures as pr
where exists (select 1 from customers as ct where pr.prefecture_code = ct.prefecture_code) 

/*
-> Nested loop semijoin  (cost=56522 rows=556553) (actual time=7.5..13.6 rows=41 loops=1)
    -> Table scan on pr  (cost=4.95 rows=47) (actual time=0.0286..0.0685 rows=47 loops=1)
    -> Covering index lookup on ct using idx_customers_prefecture_code (prefecture_code=pr.prefecture_code)  (cost=515473 rows=11842) (actual time=0.288..0.288 rows=0.872 loops=47)
*/

-- in 
explain analyze
select * from prefectures
where prefecture_code in (select prefecture_code from customers)

/*
-> Nested loop semijoin  (cost=56522 rows=556553) (actual time=0.064..0.851 rows=41 loops=1)
    -> Table scan on prefectures  (cost=4.95 rows=47) (actual time=0.0264..0.0355 rows=47 loops=1)
    -> Covering index lookup on customers using idx_customers_prefecture_code (prefecture_code=prefectures.prefecture_code)  (cost=515473 rows=11842) (actual time=0.0172..0.0172 rows=0.872 loops=47)
*/


