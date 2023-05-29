show databases

use day_15_18_db

show tables

drop table students 


create table schools(
	id int primary key, 
	name varchar(255)
)

create table students (
	id int primary key,
	name varchar(255),
	age int,
	school_id int,
	foreign key(school_id) references schools(id)
)

insert into schools values(1, "北高校")

insert into students values(1, "Taro", 18, 1)	-- ※ school_id に値がないとエラー

-- 参照整合性エラー
update schools set id = 2
delete from schools

update students set school_id = 3

drop table schools


-- 複数のカラムに外部キー
describe employees

create table salaries(
	id int primary key,
	company_id int,
	employee_code char(8),
	payment int,
	paid_date date,
	foreign key(company_id, employee_code) references employees(company_id, employee_code)
)

select * from employees e 


insert into salaries values(1, 1, "00000003", 1000, "2020-01-01")	-- 参照整合性エラー



-- onupdate, ondelete : cascade
describe students 
drop table students 


create table students (
	id int primary key,
	name varchar(255),
	age int,
	school_id int,
	foreign key(school_id) references schools(id)
	on delete cascade on update cascade
)

insert into students values(1, "Taro", 18, 1)

select * from students s 

select * from schools

update schools set id=3 where id=1	-- cascade により更新が可能

delete from schools	-- cascadeにより参照先も削除される



-- onupdate, ondelete : set null
describe students 
drop table students 


create table students (
	id int primary key,
	name varchar(255),
	age int,
	school_id int,
	foreign key(school_id) references schools(id)
	on delete set null on update set null
)

insert into schools values(2, "南高校")

insert into students values(2, "Taro", 16, 2)

select * from students s 

update schools set id=3 where id=1		-- students が null になる

update students set school_id=3 where school_id is null

delete from schools where id=3



-- onupdate, ondelete : set default
describe students 
drop table students 


create table students (
	id int primary key,
	name varchar(255),
	age int,
	school_id int default -1,
	foreign key(school_id) references schools(id)
	on delete set default on update set default
)


select * from schools
insert into schools values(1, "北高校")

insert into students values(1, "Taro", 17, 1)

select * from students s 

update schools set id=3 where id=1		-- エラーになる(set defaultはMySQLで利用されるinooDBでは使えない)
