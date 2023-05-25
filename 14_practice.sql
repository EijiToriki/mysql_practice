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


	