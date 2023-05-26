show databases;
use day_10_14_db;

-- 問題1
select
	first_name , last_name , age 
from 
	employees
where 
	id < 10
union 
select 
	first_name , last_name , age 
from 
	customers
where 
	id < 10
	
	
-- 問題2
select 
	max(sa.payment) as "最高月収",
	min(sa.payment) as "最低月収",
	avg(sa.payment) as "平均月収",
	sum(sa.payment) as "給与合計"
from 
	employees as emp
inner join
	departments as dp
on
	emp.department_id = dp.id
inner join 
	salaries as sa
on
	emp.id = sa.employee_id 
where 
	dp.name = '営業部'

	
-- 問3
-- -- 自分で考えた答え
select 
	count(*)
from 
	classes as cl
inner join
	enrollments as er
on
	cl.id = er.class_id 
inner join 
	students as st
on
	st.id = er.student_id 
where 
	cl.id < 5
union 
select 
	count(*)
from 
	classes as cl
inner join
	enrollments as er
on
	cl.id = er.class_id 
inner join 
	students as st
on
	st.id = er.student_id 
where 
	cl.id >= 5

	
-- -- 模解
select 
	case
		when cl.id < 5 then 'クラス1'
		else 'クラス2'
	end as 'クラス分類',
	count(*) 
from 
	classes as cl
inner join
	enrollments as er
on
	cl.id = er.class_id 
inner join 
	students as st
on
	st.id = er.student_id 
group by
	case
		when cl.id < 5 then 'クラス1'
		else 'クラス2'
	end
	
-- 問4
select
	emp.id,
	emp.first_name ,
	emp.last_name ,
	sum(sa.payment) as '月収の合計値',
	avg(sa.payment) as '月収の平均値'
from 
	salaries as sa
inner join
	employees as emp
on
	emp.id = sa.employee_id 
where 
	emp.age < 40
group by 
	emp.id
having 
	avg(sa.payment) > 7000000


-- 問5
select
	cs.id, 
	concat(cs.last_name, ' ', cs.first_name) as '氏名',
	sum(od.order_amount) as '注文合計量'
from 
	customers as cs
inner join
	orders as od
on
	cs.id = od.customer_id 
group  by 
	cs.id 

	
-- -- 模解
select
	*,
	(select sum(order_amount) from orders as od where od.customer_id = cs.id) as sum_order_amount
from 
	customers as cs
	
	
-- 問6
with tmp_cs as (
	select * from customers where last_name like '%田%'
), tmp_od as(
	select * from orders where order_date >= '2020-12-01'
), tmp_st as(
	select * from stores where name = '山田商店'
)
select
	concat(cs.first_name, ' ', cs.last_name),
	count(*)
from
	tmp_cs as cs
inner join
	tmp_od as od
on
	cs.id = od.customer_id
inner join 
	items as it
on
	it.id = od.item_id
inner join 
	tmp_st as st
on
	st.id = it.store_id 	
group by 
	concat(cs.first_name, ' ', cs.last_name)
	

-- 問7
-- -- in 
select 
	* 
from 
	employees as emp
where 
	emp.id in (
		select employee_id from salaries where payment > 9000000
	)
	
-- -- inner join 
select
	distinct emp.*
from 
	employees as emp
inner join
	salaries as sl
on
	emp.id = sl.employee_id 
where 
	sl.payment > 9000000
	
-- -- exists
select
	*
from 
	employees as emp
where exists (
	select 1 from salaries as sl where emp.id = sl.employee_id and sl.payment > 9000000
)


-- 問8
-- -- in 
select
	*
from 
	employees
where 
	id not in (
		select employee_id from salaries
	)
	
-- -- LEFT JOIN
select
	emp.*
from 
	employees as emp
LEFT JOIN
	salaries as sl 
on
	emp.id = sl.employee_id 
where 
	sl.employee_id is null 
	
	
-- -- exists 
select 
	*
from 
	employees as emp
where not exists (
	select 1 from salaries as sl where emp.id = sl.employee_id 
)


-- 問9
with cs_age as (
	select
		min(age) as min_age,
		avg(age) as avg_age,
		max(age) as max_age
	from
		customers
)
select 
	*,
	case 
		when emp.age < ca.min_age then '最小未満'
		when ca.min_age <= emp.age and emp.age < ca.avg_age then '平均未満'
		when ca.avg_age <= emp.age and emp.age < ca.max_age then '最大未満'
		else 'その他'
	end as '年齢区分'
from 
	employees as emp
cross join
	cs_age as ca 
	


-- 問10
-- -- 自力無理
with dairy_sales as(
	select
		cs.id as id, 
		od.order_date as order_date,
		sum(od.order_amount * od.order_price) as sale 
	from 
		(
			select * from customers where age > 50
		) as cs
	inner join 
		orders as od 
	on
		cs.id = od.customer_id 
	group by cs.id, od.order_date 
	order by cs.id, od.order_date 
)
select
	id,
	order_date,
	AVG(sale) over(order by id rows between 6 preceding and current row),
	AVG(sale) over(order by id rows between 14 preceding and current row),
	AVG(sale) over(order by id rows between 30 preceding and current row)
from 
	dairy_sales
	
-- -- 模解
with tmp_cs as(
	select * from customers where age > 50
), tmp_cs_od as(
	select
		tc.id, 
		od.order_date ,
		sum(od.order_amount*od.order_price) as payment,
		row_number() over(partition by tc.id order by od.order_date) as row_num
	from 
		tmp_cs as tc
	inner join
		orders as od 
	on
		tc.id = od.customer_id
	group by 
		tc.id, od.order_date 
)
select 
	id, 
	order_date, 
	payment,
	case 
		when row_num < 7 then ""
		else avg(payment) over(partition by id order by order_date rows between 6 preceding and current row)
	end as '7日間平均',
	case 
		when row_num < 15 then ""
		else avg(payment) over(partition by id order by order_date rows between 14 preceding and current row)
	end as '15日間平均',
	case 
		when row_num < 30 then ""
		else avg(payment) over(partition by id order by order_date rows between 29 preceding and current row)
	end as '30日間平均'	 
from tmp_cs_od

