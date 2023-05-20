show tables

-- 従業員一覧
select * from employees

-- 部署一覧
select * from departments

-- IN で絞り込む
select * from employees where department_id IN(1,2)

-- 福問い合わせを使う
select 
	* 
from 
	employees 
where department_id not IN(
	select
		id
	from 
		departments
	where
		name in ("経営企画部", "営業部")
)


select * from students

select * from users


-- 複数カラムの福問い合わせ
select 
	* 
from 
	students 
where
	(first_name, last_name) in (
		select first_name, last_name from users
	)


-- 集計と福問い合わせ
select
	*
from 
	employees
where 
	age < (select avg(age) from employees)
	
	
-- FROMで副問い合わせ
select
	max(avg_age) as "部署ごとの平均年齢の最大",
	min(avg_age) as "部署ごとの平均年齢の最小"
from(
	select
		department_id, avg(age) as avg_age
	from
		employees
	group by
		department_id 
) as temp_emp


-- 年代の集計
select 
	max(age_count), min(age_count) 
from (
	select 
		floor(age/10), count(*) as age_count
	from employees
		group by floor(age/10) 
) as age_summary


-- selectの中に副問い合わせ
select
	*
from 
	customers

select
	*
from 
	orders
	

select
	cs.first_name,
	cs.last_name,
	(
		select max(order_date) from orders as order_max where cs.id = order_max.customer_id 
	) as "最近の注文日",
	(
		select sum(order_amount * order_price) from orders as tep_order where cs.id = tep_order.customer_id 
	) as "顧客ごとの注文合計"	
from
	customers as cs
where 
	cs.id < 10

	
select sum(order_amount * order_price) from orders


-- case と副問い合わせ
select
	emp.*,
	case 
		when emp.department_id = (select id from departments where name="経営企画部") then "経営層"
		else "その他"
	end as "役割"
from 
	employees as emp

	
	
select
	*
from 
	salaries
where 
	payment > (select avg(payment) from salaries)


select
	emp.*,
	case 
		when emp.id in(
			select
				distinct  employee_id 
			from 
				salaries
			where 
				payment > (select avg(payment) from salaries)
		) then 'o'
	else 'x'
	end as '給料が平均より高いか？'
from
	employees emp