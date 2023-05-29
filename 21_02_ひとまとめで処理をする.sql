use day_19_21_db

create table tmp(
	id int primary key,
	name varchar(50)
)

-- マルチインサート
insert into tmp values
(1, 'A'),
(2, 'B'),
(3, 'C')

select * from tmp 


-- 激重SQL
select ct.id, sum(sh.sales_amount) from customers as ct
inner join sales_history as sh
on ct.id = sh.customer_id 
group by ct.id

### 夜間バッチ用に書き換える -> ワークテーブルに一旦保存しておく
create table customer_summary as
select ct.id, sum(sh.sales_amount) from customers as ct
inner join sales_history as sh
on ct.id = sh.customer_id 
group by ct.id


