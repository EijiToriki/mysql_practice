use day_10_14_db

show tables

select * from employees 

-- windows 関数
select *, avg(age) over(), count(*) over() 
from employees


-- partition by : 分割してその中で集計する
select 
	*, 
	avg(age) over(partition by department_id) as avg_age, 
	count(*) over(partition by department_id) as count_department
from 
	employees e 
	

select
	distinct
	concat(count(*) over(partition by floor(age/10)), "人") as age_count,
	concat(floor(age/10) * 10, "代")
from employees e 



select
	distinct 
	date_format(order_date, "%Y/%m"),
	SUM(order_amount*order_price) over(partition by date_format(order_date, "%Y/%M"))
from 
	orders o 
order by
	date_format(order_date, "%Y/%m")
	
	
-- order by 

select
	*,
	count(*) over(order by age) as tmp_count
from
	employees e 
	
	
select
	*, 
	sum(order_price) over(order by order_date, customer_id)
from 
	orders o 
	
	
select
	floor(age / 10),
	count(*) over(order by floor(age / 10))
from 
	employees e 
	
	
-- partition + order by

select 
	*, 
	MIN(age) over(partition by department_id order by age) as count_value
from 
	employees e 
	

-- 人毎の、最大の収入
select 
	*,
	max(payment) over(partition by emp.id)
from 
	employees as emp
inner join 
	salaries as sa
on
	emp.id = sa.employee_id 

	
-- 月毎の、合計をemployeesのIDで昇順に並べ替える
select 
	*,
	SUM(payment) over(partition by sa.paid_date order by emp.id)
from 
	employees as emp
inner join 
	salaries as sa
on
	emp.id = sa.employee_id 
	
	
	
-- salesテーブルの order_price * order_amountの合計値の7日間平均を求める
-- 1. 日付ごとの合計値を求める
-- 2. 7日の平均を求める
select 
	*,
	sum(order_price*order_amount) over(order by order_date rows between 6 preceding and current row) 
from 
	orders 


select
	*,
	sum(summary_salary.payment) over(order by age range between 3 preceding and current row) as p_summary
from 
	employees as emp
inner join
	(
		select
			employee_id,
			sum(payment) as payment
		from salaries
		group by employee_id 
	) as summary_salary
on emp.id = summary_salary.employee_id 

	
with daily_summary as(
	select
		order_date,
		sum(order_price*order_amount) as sale
	from
		orders
	group by
		order_date 
)
select 
	*,
	AVG(sale) over(order by order_date rows between 6 preceding and current row)	-- 6行前から現在の行の平均
from 
	daily_summary

	
-- ROW_NUMBER, RANK, DENSE_RANK
	
select 
	*,
	row_number() over(order by age) as row_num ,
	rank() over(order by age) as row_rank ,
	dense_rank() over(order by age) as row_dense
from 
	employees e 


-- CUME_DIST, PERCENT_RANK
select 
	age,
	rank() over(order by age) as row_rank ,
	count(*) over() as cnt,
	percent_rank() over(order by age) as p_age,		-- (RANK-1) / (行数-1)
	cume_dist() over(order by age) as c_age			-- 現在の行の値以下の行の割合
from 
	employees e 

	
-- LAG, LEAD
select
	age,
	LAG(age) over(order by age),		-- 直前
	LAG(age, 3, 0) over(order by age),	-- 3つ前、ない場合は0
	LEAD(age) over(order by age),		-- 直後
	LEAD(age, 2, 0) over(order by age)	-- 2つ後、ない場合は0
from
	customers c 

	
-- FIRST_VALUE, LAST_VALUE

select
	*,
	first_value(first_name) over(partition by department_id order by age),
	last_value(first_name) over(partition by department_id order by age range between unbounded preceding and unbounded following)
from 
	employees e 

	
-- NTILE
select
	age,
	ntile(7) over(order by age)
from
	employees e 
-- エラー
-- where 
-- 	ntile(7) over(order by age) = 5


-- 副問い合わせならOK
select 
	*
from (
	select
		age,
		ntile(7) over(order by age) as ntile_value
	from
		employees e 
) as tmp
where tmp.ntile_value = 5