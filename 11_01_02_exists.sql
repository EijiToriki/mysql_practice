use day_10_14_db

select * from departments

select * from employees

-- exists (パフォーマンスがいい)
select * from employees as em
where exists (
	select 1 from departments as dp where em.department_id = dp.id 
)


-- in でもかける
select * from employees as em
where em.department_id in (select id from departments)


select * from employees as emp
where exists (
	select * from departments as dt where dt.name in ("営業部", "開発部") and emp.department_id = dt.id
)


select * from customers as ct
where not exists (select 1 from orders as od where ct.id = od.customer_id and od.order_date = "2020-12-31")


select * from employees as em1
where exists (
	select 1 from employees as em2 where em1.manager_id = em2.id
)