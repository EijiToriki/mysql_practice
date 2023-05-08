-- in句
select * from users where age in(12, 24, 36) order by age ;

select * from users where birth_place in ("France", "Germany", "Italy");

-- select + in 
select * from customers where id in(select customer_id from receipts);
select * from customers where id not in(select customer_id from receipts where id < 10);


-- ALL, ANY
select * from users where age > ALL(select age from employees where salary > 5000000);
select * from users where age = ANY(select age from employees where salary > 5000000);


-- AND, OR 
select * from employees where department = " 営業部 " and name like "%田%"

select * from employees where department = " 営業部 " and name like "%田%" and age < 35;

select * from employees where department = " 営業部 " and (name like "%田%" or name like "%西%") and age < 35;

select * from employees where department = " 営業部 " or department = " 開発部 ";
select * from employees where department in (" 営業部 ", " 開発部 ");

-- Not
select * from employees where not department = " 営業部 ";