explain analyze select * from customers

/*
EXPLAIN                                                                                            |
---------------------------------------------------------------------------------------------------+
-> Table scan on customers  (cost=52756 rows=497786) (actual time=0.0735..418 rows=500000 loops=1)¶|
*/


explain analyze select * from customers where id = 1

/*
EXPLAIN                                                                                          |
-------------------------------------------------------------------------------------------------+
-> Rows fetched before execution  (cost=0..0 rows=1) (actual time=200e-6..200e-6 rows=1 loops=1)¶|
*/

explain analyze select * from customers where id < 10

/*
EXPLAIN                                                                                                                                                                                                                          |
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
-> Filter: (customers.id < 10)  (cost=2.06 rows=9) (actual time=0.0233..0.0441 rows=9 loops=1)¶    -> Index range scan on customers using PRIMARY over (id < 10)  (cost=2.06 rows=9) (actual time=0.0218..0.0419 rows=9 loops=1)¶| 
*/

explain analyze select * from customers where first_name = "Olivia"

/*
EXPLAIN                                                                                                                                                                                                                 |
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
-> Filter: (customers.first_name = 'Olivia')  (cost=50524 rows=49779) (actual time=0.0759..302 rows=503 loops=1)¶    -> Table scan on customers  (cost=50524 rows=497786) (actual time=0.0736..264 rows=500000 loops=1)¶|
*/


create index idx_customer_first_name on customers(first_name)

explain analyze select * from customers where first_name = "Olivia"

/*
EXPLAIN                                                                                                                                          |
-------------------------------------------------------------------------------------------------------------------------------------------------+
-> Index lookup on customers using idx_customer_first_name (first_name='Olivia')  (cost=176 rows=503) (actual time=0.386..2.65 rows=503 loops=1)¶|
*/


explain analyze select * from customers where gender = 'F'

/*
EXPLAIN                                                                                                                                                                                                          |
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
-> Filter: (customers.gender = 'F')  (cost=50524 rows=49779) (actual time=0.063..330 rows=250065 loops=1)¶    -> Table scan on customers  (cost=50524 rows=497786) (actual time=0.0607..279 rows=500000 loops=1)¶|
*/

create index idx_customers_gender on customers(gender);

-- インデックスを付けたことによって遅くなる例
explain analyze select * from customers where gender = 'F'

/*
EXPLAIN                                                                                                                                                                                     |
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
-> Index lookup on customers using idx_customers_gender (gender='F'), with index condition: (customers.gender = 'F')  (cost=27124 rows=248893) (actual time=0.788..731 rows=250065 loops=1)¶|
*/

-- ヒント句
explain analyze select /*+ NO_INDEX(ct) */ * from customers as ct where ct.gender = "F"

/*
 EXPLAIN                                                                                                                                                                                              |
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
-> Filter: (ct.gender = 'F')  (cost=50524 rows=497786) (actual time=0.0587..329 rows=250065 loops=1)¶    -> Table scan on ct  (cost=50524 rows=497786) (actual time=0.0568..277 rows=500000 loops=1)¶|
*/


drop index idx_customer_first_name on customers
drop index idx_customers_gender on customers

