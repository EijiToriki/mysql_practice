use day_15_18_db

show tables

select * from employees e 

describe employees 

alter table employees add constraint uniq_employees_name unique(name)		-- 既に重複しているのでエラー

update employees set name="Jiro" where company_id = 2
alter table employees add constraint uniq_employees_name unique(name)		-- unique 追加


-- 制約確認
select
	*
from 
	information_schema.key_column_usage
where 
	table_name="employees"
	
-- 制約削除
alter table employees drop constraint uniq_employees_name 

-- uniqueの追加
alter table employees add constraint uniq_employees_name unique(name, age)

select * from employees e 

insert into employees values(3, "000000002", "Taro", 19)		-- 重複のためエラー（uniqueじゃない！)


-- create文を確認
show create table employees 


-- default 追加
select * from customers c 

show create table customers 
-- check制約削除
alter table customers drop constraint customers_chk_1

describe customers 

-- set default 追加
alter table customers 
alter age set default 20


insert into customers(id, name) values(2, 'Jiro')

select * from customers c 


-- not null 追加
alter table customers modify name varchar(255) not null

insert into customers(id, name) values(3, NULL)		-- 非ヌル制約に引っ掛かる


-- check 制約の追加
alter table customers add constraint check_age check(age>20)	-- ageが20以下の人がいるのでエラー、、、
alter table customers add constraint check_age check(age>=20)



-- 主キーの削除
describe customers 

alter table customers drop primary key

-- 主キーの追加

alter table customers 
add constraint pk_customers primary key(id)


-- 外部キーの削除
describe students 

show create table students 

alter table students drop constraint students_ibfk_1

alter table students 
add constraint fk_schools_students
foreign key(school_id) references schools(id)



-- auto increment
create table animals(
	id int primary key auto_increment comment '主キーのID(int型)です',
	name varchar(50) not null comment '動物の名前です'
)


-- comment の確認
show full columns from animals


insert into animals values(null, 'dog')
insert into animals(name) values('cat')

select * from animals 

select auto_increment from information_schema.tables where TABLE_NAME = "animals"

insert into animals values(4, 'panda')		-- 3が飛ばされる
insert into animals(name) values('fish')


alter table animals auto_increment = 100

insert into animals(name) values('bird')
select * from animals 						-- 100に飛ぶ

-- 一気にinsert
insert into animals(name)
select "snake"
union all
select "dino"
union all
select "gibra"

select * from animals 


insert into animals(name)
select name from animals 

select * from animals 