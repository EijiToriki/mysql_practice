show databases

use day_10_14_db

show tables

select * from employees

select * from departments


-- 通常のJOIN
select
	*
from 
	employees as em
	inner join
		departments as dp 
	on
		em.department_id = dp.id
		
		
-- 特定のカラムを取り出す
select
	em.id, em.first_name , em.last_name , dp.id as department_id, dp.name as department_name
from 
	employees as em
	inner join
		departments as dp 
	on
		em.department_id = dp.id
		
		
-- 複数のレコードで紐づける
select * from students as std
inner join
users as usr 
on std.first_name = usr.first_name  and std.last_name = usr.last_name 


-- = 以外で紐づける
select * from employees as em
inner join
students as std
on em.id < std.id 



-- LEFT join 
select
	em.id, em.first_name , em.last_name , coalesce(dp.id, "該当なし") as department_id, dp.name as department_name
from 
	employees as em
	left join
		departments as dp 
	on
		em.department_id = dp.id

		
select * from students as s
left join
enrollments as e 
on s.id = e.student_id 
left join
classes as c
on e.class_id = c.id 

-- right join 
select * from students as s
right join
enrollments as e 
on s.id = e.student_id 
right join
classes as c
on e.class_id = c.id 



-- full join(両方から取り出して、取得できないものはnull)
select * from students as s
left join
enrollments as e 
on s.id = e.student_id 
left join
classes as c
on e.class_id = c.id 
union 
select * from students as s
right join
enrollments as e 
on s.id = e.student_id 
right join
classes as c
on e.class_id = c.id 



-- customers, orders, items, stores を紐づける
-- customers.id で並べ替える（order by)


select
	cs.id, cs.last_name , od.item_id, od.order_amount , od.order_price ,od.order_date ,it.name ,st.name 
from customers as cs
	inner join orders as od 
		on cs.id = od.customer_id 
	inner join items as it
		on od.item_id = it.id 
	inner join stores as st
		on it.store_id = st.id  
order by cs.id 



-- customers, orders, items, stores を紐づける
-- customers.id で並べ替える（order by)
-- customer.id が10で、orders.order_dateが2020-08-01より後に絞り込む（WHERE)

select
	cs.id, cs.last_name , od.item_id, od.order_amount , od.order_price ,od.order_date ,it.name ,st.name 
from customers as cs
	inner join orders as od 
		on cs.id = od.customer_id 
	inner join items as it
		on od.item_id = it.id 
	inner join stores as st
		on it.store_id = st.id  
where 
	cs.id = 10
and 
	od.order_date >= '2020-08-01'
order by od.order_date 


-- サブクエリ化
select
	cs.id, cs.last_name , od.item_id, od.order_amount , od.order_price ,od.order_date ,it.name ,st.name 
from 
	(select * from customers where id=10) as cs
	inner join (select * from orders where order_date >= '2020-08-01') as od 
		on cs.id = od.customer_id 
	inner join items as it
		on od.item_id = it.id 
	inner join stores as st
		on it.store_id = st.id  
order by od.order_date 


-- group by の紐づけ
select
	*
from 
	customers as cs
inner join
	(select 
		customer_id, sum(order_amount * order_price) as summary_price
	from 
		orders
	group by 
		customer_id 
	) as order_summary
on cs.id = order_summary.customer_id


-- self join 

select 
	concat(e1.last_name, e1.first_name) as '部下の名前',
	e1.age as '部下の年齢',
	coalesce(concat(e2.last_name, e2.first_name), '該当なし') as '上司の名前' ,
	e2.age as '上司の年齢'
from employees as e1
	left join 
		employees as e2
	on 
		e1.manager_id = e2.id
		
		
-- cross join 

select * from employees as e1, employees as e2
where e1.id = 1


select * from employees as e1
cross join employees as e2
on e1.id < e2.id


-- 計算結果とCASEで紐づけ
select 
	*,
	case 
		when cs.age > summary_customers.avg_age then 'o'
		else 'x'
	end as '平均年齢より年齢が高いか？'
from customers as cs
cross join (
	select avg(age) as avg_age from customers
) as summary_customers




select
	em.id, 
	case 
		when avg(payment) >= summary.avg_payment then 'o'
		else 'x'
	end as '平均月収より高いか？'
from
	employees as em
inner join salaries as sa
on em.id = sa.employee_id
cross join(
	select avg(payment) as avg_payment from salaries
) as summary
group by em.id, summary.avg_payment






