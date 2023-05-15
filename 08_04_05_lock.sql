use day_4_9_db;

start transaction;

show tables;

select * from customers;

-- 主キーでupdate(行ロック)
update customers set age=42 where id=1

rollback 


-- テーブル全体のロック
start transaction

update customers set age=42 where name='河野 文典'



-- delete 
start transaction

-- 行ロック
delete from customers where id=1
Commit;


-- insert 
start transaction

insert into customers values(1, "田中 正弘", 21, "2001-09-07")
select * from customers 

commit


-- select のロック
-- for share(共有ロック)
-- for update(排他ロック)

start transaction
select * from customers where id=1 for share

rollback 


start transaction
select * from customers where id=1 for update 


-- LOCK table read
lock table customers read
select * from customers;
update customers set age=42 where id=1

unlock tables;


-- LOCK table write
lock table customers write
select * from customers;
update customers set age=45 where id=1;

unlock tables;


-- deadlock
start transaction

-- -- customers → users
update customers set age=43 where id=1

update users set age=10 where id=1

rollback 

