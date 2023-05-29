use day_15_18_db

create table messages(
	name_code char(8),		-- 長さが決まっているもの
	name varchar(25),
	message text	-- 65535
)

insert into messages values('00000001', 'Yoshida Masataka', "こんにちは、しゅうです")

insert into messages values('00000001', 'Yoshida Masataka　Yoshida Masataka　Yoshida Masataka　Yoshida Masataka', "こんにちは、しゅうです")		-- 25文字以上ならエラー


-- int 系
create table patients(
	id smallint unsigned primary key auto_increment,	-- 0~65535
	name varchar(50),
	age tinyint unsigned default 0	-- 0~255
)

insert into patients(name, age) values("Sachiko", 34)

select * from patients 
insert into patients(name, age) values("Sachiko", 344)	-- tinyint の範囲を超えるためエラー

insert into patients(id, name) values(1000000, "Yoshio")	-- smallint の範囲を超えるためエラー

alter table patients modify id mediumint unsigned auto_increment	-- 0~16777215

show full columns from patients 


-- height カラム, weight カラムの追加
alter table patients add column(height float)
alter table patients add column(weight float)

select * from patients 

insert into patients (name, age, height, weight) values("Eiji", 24, 171.12345678901, 60.123456789)	-- 丸められる


create table tmp_float(
	num float
)

insert into tmp_float values(123456789)
insert into tmp_float values(1234.56789)

select * from tmp_float		-- 6桁目で丸められる


create table tmp_double(
	num double
)

insert into tmp_double values(123456789)
insert into tmp_double values(123456789.123)
insert into tmp_double values(123456789.123456)
insert into tmp_double values(123456789.123456789)

select * from tmp_double	-- float よりは桁数が保たれる


alter table patients add column score decimal(7, 3)	-- 整数が4, 小数が3

select * from patients 

insert into patients(name, age, score) values('jiro', 54, 32.456)


create table tmp_decimal(
	num_float float,
	num_double double,
	num_decimal decimal(20, 10)
)

insert into tmp_decimal values(1111111111.1111111111, 1111111111.1111111111, 1111111111.1111111111)

select * from tmp_decimal 	-- num_decimalに正確な値が入っている

insert into tmp_decimal values(1111111111.1111111111, 1111111111.1111111111, 31111111111.1111111111)	-- decimal の桁数オーバー

insert into tmp_decimal values(1111111111.1111111111, 1111111111.1111111111, 1111111111.11111111118)	-- 小数部の桁数オーバーは丸められる


-- boolean
create table managers(
	id int primary key auto_increment, 
	name varchar(50),
	is_superuser boolean
)

insert into managers(name, is_superuser) values("Taro", true)

insert into managers(name, is_superuser) values("Jiro", False)

select * from managers where is_superuser = True



-- DATE TIME

create table alerms(
	id int primary key auto_increment,
	alerm_day date,
	alerm_time time,
	create_at timestamp default current_timestamp,
	update_at timestamp default current_timestamp on update current_timestamp	
)

select current_timestamp, now(), current_date, current_time 	-- 現在時刻


insert into alerms(alerm_day, alerm_time) values("2019-01-01", "19:05:21")
insert into alerms(alerm_day, alerm_time) values("2019/01/15", "190521")

select * from alerms 

update alerms set alerm_time = current_time	where id = 1 

select hour(alerm_time), minute(alerm_time), second(alerm_time),alerm_time from alerms 

select year(alerm_day), month(alerm_day), day(alerm_day),alerm_day from alerms 


create table time_tmp(
	num time(5)
)

insert into time_tmp values("21:05:21.12345")


select * from time_tmp 


-- datetime, timestamp
create table tmp_datetime_timestamp(
	val_datetime datetime,
	val_timestamp timestamp,
	val_datetime_3 datetime(3),
	val_timestamp_3 timestamp(3)
)

insert into tmp_datetime_timestamp
values(current_timestamp, current_timestamp, current_timestamp, current_timestamp)

insert into tmp_datetime_timestamp
values("2019/01/01 09:08:07.4567", "2019/01/01 09:08:07.4567", "2019/01/01 09:08:07.6578", "2019/01/01 09:08:07.6578")

select * from tmp_datetime_timestamp 


-- timestamp の範囲を超えた値： 1969/01/01 00:00:01
insert into tmp_datetime_timestamp
values("1969/01/01 00:00:01", "1969/01/01 00:00:01", "1969/01/01 00:00:01", "1969/01/01 00:00:01")	-- エラー

-- timestamp の範囲を超えた値： 2039/01/01 00:00:01
insert into tmp_datetime_timestamp
values("2039/01/01 00:00:01", "2039/01/01 00:00:01", "2039/01/01 00:00:01", "2039/01/01 00:00:01")	-- エラー


insert into tmp_datetime_timestamp
values("2039/01/01 00:00:01", "2029/01/01 00:00:01", "2039/01/01 00:00:01", "2029/01/01 00:00:01")	-- エラー



show tables

select * from students s 

show index from students

create index idx_students_name on students(name)

explain select * from students where name = "Taro"

-- 関数インデックス
create index idx_students_lower_name on students((lower(name)))

explain select * from students where lower(name) = "taro" 



select * from users u 

create unique index idx_users_uniq_first_name on users(first_name)

insert into users(id, first_name) values(2, "Haruka")
insert into users(id, first_name) values(3, "Haruka")	-- ユニーク制約でエラー