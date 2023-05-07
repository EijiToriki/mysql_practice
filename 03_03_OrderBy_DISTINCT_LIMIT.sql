show tables;

describe people;

alter table people add age int after name;

insert into people values(1, "John", 18, "2001-01-01")
insert into people values(2, "Alice", 15, "2003-01-01")
insert into people values(3, "Paul", 19, "2000-01-01")
insert into people values(4, "Chris", 17, "2002-01-01")
insert into people values(5, "Vette", 20, "2001-01-01")
insert into people values(6, "Tsuyoshi", 21, "2001-01-01")


select * from people;

# ageで昇順
select * from people order by age;

# ageで降順
select * from people order by age desc;

# name
select * from people order by name;

# 2つのカラムでソート
select * from people order by birth_day desc, name, age;


# DISTINCT
select distinct birth_day from people order by birth_day;
select distinct name, birth_day from people;	-- 両方とも一緒だと削除


# LIMITは最初の行だけ表示
select * from people limit 3;

# 飛ばして表示(3行飛ばして2行表示)
select * from people limit 3,2;

# 飛ばして表示(2行飛ばして2行表示)
select * from people limit 2 OFFSET2;


