-- create database day_4_9_db;
use day_4_9_db;

show tables;

-- usersの定義
describe users 

select * from users limit 10;

# = での絞り込み
select * from users where name = "奥村 成美";
select * from users where birth_place = "日本";

# from → where → order by → limit
select * from users where birth_place <> "日本" order by age;

# <, >, <=, >=, <>
select * from users where age >= 50 limit 10;

-- 日付の取り出し
select * from users where birth_day >= "2011-04-03";

-- tinyint 1 or 0
select * from users where is_admin = 0;


-- Updata
update users set name="奥山 成美" where id='1';
select * from users where id='1';

-- delete
select * from users order by id desc;

delete from users where id = 200;

select * from users order by id desc;
