use day_4_9_db;

-- 算術演算子
# +, -, *, /. %
select 1 + 1;
select name, age, age+3 as age_3 from users limit 10

select 10 - 5
select name, age, age-1 as age_1 from users limit 10

select birth_day, birth_day+2 from users limit 10

select 3*5
select department , name , salary , salary * 1.1 as salary_next_year from employees limit 10
select department , name , salary , salary * 0.9 as salary_next_year from employees limit 10

select 10/3
select salary / 10 from employees 

select 10%3
select age % 12 from users 

-- CONCAT(文字の連結) ※mySQL以外では || でも可能
select concat(department, ":", name) as "部署:名前" from employees limit 10
select concat(name, "(", age, ")") from users limit 10

-- NOW, CURDATE, DATE_FORMAT
select NOW()	-- 現在時刻
select NOW(), name, age from users

select curdate()

select date_format(now(), "%Y/%m/%d/%H") 