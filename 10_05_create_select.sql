-- create select insert

show tables;

create table tmp_students
select * from students

select * from tmp_students

describe tmp_students	-- 主キーは反映されていない

describe students 

drop table tmp_students


create table tmp_students
select * from students where id < 10

select * from tmp_students 


insert into tmp_students
select id+9 as id, first_name, last_name, 2 as grade from users


create table names
select first_name, last_name from students 
union
select first_name, last_name from employees
union
select first_name, last_name from customers 


select * from names 