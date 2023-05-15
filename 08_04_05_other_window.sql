use day_4_9_db;

update customers set age=44 where id=14;

select * from customers c 

update customers set age=44 where id=2


select * from customers where id=1 for share
update customers set age=44 where id=1

select * from customers;
update customers set age=42 where id=1


start transaction
-- -- users → customers
update users set age=12 where id=1

update customers set age=40 where id=1

-- mysql はデッドロックが起きたら片方が強制rollback
