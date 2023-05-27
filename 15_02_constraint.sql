show databases

create database day_15_18_db

use day_15_18_db


show tables

-- 非ヌル制約
create table users(
	id int primary key,
	first_name varchar(255), 
	last_name varchar(255) default '' not null
)	

insert into users(id) values(1);

select * from users


create table users_2(
	id int primary key,
	first_name varchar(255), 
	last_name varchar(255) not null,
	age int default 0
)	

insert into users_2(id, first_name) values(1, "Taro")
-- last_name にデフォルト値がないのでエラー

insert into users_2(id, first_name, last_name) values(1, "Taro", "Yamashita")

select * from users_2


insert into users_2 values(2, "Jiro", "Kaki", null)
-- age には null を入れて OK



-- UNIQUE制約
create table login_users(
	id int primary key,
	name varchar(255) not null,
	email varchar(255) not null unique
)


insert into login_users values(1, "Shingo", "abc@gmail.com")
insert into login_users values(2, "Shingo", "abc@gmail.com")	-- メアド重複でエラー


create table tmp_users(
	name varchar(255) unique
)

insert into tmp_users values('たろう')
insert into tmp_users values('たろう')		-- 重複のため当然エラー

insert into tmp_users values(null)		-- nullは何回でも実行できてしまう

select * from tmp_users



-- check 制約
create table customers(
	id int primary key,
	name varchar(255),
	age int check(age>=20)
)

insert into customers values(1, "Taro", 21)
insert into customers values(2, "Jiro", 12)		-- 大人になってからね♡


-- 複数カラムに対する check 制約
create table students(
	id int primary key,
	name varchar(255),
	age int,
	gender char(1),
	constraint chk_students check((age >= 15 and age <= 20) and (gender = 'M' or gender = 'F'))
)


insert into students values(1, "Taro", 18, "M")

insert into students values(2, "Taro", 18, "U")		-- 謎の性別ではじく

insert into students values(2, "Sachiko", 18, "F")

insert into students values(3, "Sachiko", 14, "F")	-- 年齢制限ではじく


create table employees(
	company_id int,
	employee_code char(8),
	name varchar(255),
	age int,
	primary key(company_id, employee_code)
)


insert into employees values(1, "00000001", "Taro", 19)

insert into employees values(null, "00000001", "Taro", 19)	-- エラー

insert into employees values(2, "00000001", "Taro", 19)	-- 組み合わせが重複しなければOK


-- ※ uniqueでも同様のことができる
create table employees_unique(
	company_id int,
	employee_code char(8),
	name varchar(255),
	age int,
	unique(company_id, employee_code)
)
