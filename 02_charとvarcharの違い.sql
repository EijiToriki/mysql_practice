use my_db;
select database();

# STUDENTS テーブルの作成
create table students(
	id int primary key,
	name char(10)
)


# char型は末尾のスペースが削除される
insert into students values(1, 'ABCDEF ');
select * from students;

# char => varchar
ALTER TABLE students MODIFY name varchar(10);
insert into students values(2, "ABCDEF ");
select * from students;

# name, nameの文字の数を表示
# verchar はスペースも文字として格納される
select name, character_length(name) from students; 