use my_db;

# 全レコード、全カラム
select * from people;

# 一部のカラムを取得
select name, id from people;
select id as "番号", name as "名前" from people;

# where句での絞り込み
select * from people where id <= 2;


# update文
update people set birth_day="1900-01-01";
select * from people;

# update where
update people set name="Taro", birth_day="2000-01-01" where id = 3
select * from people;

update people set name="Jiro" where id <= 2;
select * from people;


# delete文
delete from people where id=2;
select * from people;

# 全削除
delete from people;
select * from people;
