select database();
use my_db;

# テーブル作成
create table people(
	id int primary key,
	name varchar(50),
	birth_day date default "1990-01-01"
);

# insert1
insert into people values(1, "Taro", "2001-01-01");
select * from people;

# insert2
insert into people(id, name) values(2, "Jiro");
select * from people;

#　シングルコーテーション
insert into people(id, name) values(3, 'Saburo');
select * from people;

insert into people values(4, 'John''s son', "2021-01-01");
select * from people;


