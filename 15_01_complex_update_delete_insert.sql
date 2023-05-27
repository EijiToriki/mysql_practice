show databases

use day_10_14_db


select * from employees

-- update 更新したいテーブル set 更新したい列 = 更新する値
update employees set age = age+1 where id = 1


select 
	*
from
	employees as emp
where 
	emp.department_id = (
		select id from departments where name = '営業部'
	)
	

-- 営業部の人の年齢を + 2する
update
	employees as emp
set 
	emp.age = emp.age+2
where 
	emp.department_id = (
		select id from departments where name = '営業部'
	)


-- join を用いて update
select * from employees 

alter table employees 
add department_name VARCHAR(255)


-- left join
select
	emp.*, coalesce(dt.name, '不明')
from 
	employees as emp
left join
	departments as dt 
on
	emp.department_id = dt.id 

	
	
update
	employees as emp
left join
	departments as dt 
on
	emp.department_id = dt.id 
set emp.department_name = coalesce(dt.name, '不明')



-- with を使った update 

select * from stores s 

alter table stores add all_sales int

with tmp_sales as(
	select 
		it.store_id ,
		sum(od.order_amount*od.order_price) as summary
	from 
		items as it
	inner join
		orders as od 
	on
		it.id = od.item_id 
	group by
		it.store_id 
)
update
	stores as st
inner join
	tmp_sales as ts 
on
	st.id = ts.store_id
set 
	st.all_sales = ts.summary
	

select * from stores


-- DELETEの応用

delete from employees
where department_id in (
	select id from departments where name = "開発部"
)


select * from employees e 


-- insert の応用

select * from customers c 

select * from orders o 

create table customr_orders(
	name varchar(255),
	order_date date,
	sales int,
	total_sales int
)


insert into customr_orders 
select 
	concat(ct.last_name, ct.first_name), 
	od.order_date ,
	od.order_amount*od.order_price ,
	sum(od.order_amount*od.order_price) over(partition by concat(ct.last_name, ct.first_name) order by od.order_date)
from customers as ct
inner join orders as od 
on ct.id = od.customer_id 


select * from customr_orders 