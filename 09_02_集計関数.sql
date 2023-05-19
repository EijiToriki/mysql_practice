select * from customers where name is null

-- count
select count(*) from customers c 	-- 何行データが入っているか？？主キーの方が高速な場合もある
select count(name) from customers c2 -- 列指定：NULLはカウントしない

select count(name) from customers where id > 80

-- MAX, MIN
select max(age), min(age) from users where birth_place = '日本'

select max(birth_day), min(birth_day) from users

-- SUM,AVG
select SUM(salary) from employees
select avg(salary) from employees

-- AVG:nullの場合が面倒
create table tmp_count(
	num INT
)

show tables

insert into tmp_count values(1)
insert into tmp_count values(2)
insert into tmp_count values(3)
insert into tmp_count values(NULL)

select * from tmp_count

select avg(num) from tmp_count	-- NULLは飛ばされる

select avg(coalesce(num, 0)) from tmp_count	-- NULLを0として扱う