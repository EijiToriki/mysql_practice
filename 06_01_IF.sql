use day_4_9_db

select database()

show tables;

-- IF(条件式、真の値、偽の値)
select if(10 < 20, 'A', 'B')
select * from users;
select *, IF(birth_place='日本', '日本人', 'その他') as '国籍' from users;
select name, age, IF(age < 20, "未成年", "成人") from users;
select name, if(name LIKE "%田%", "名前に田を含む", "その他") as name_check from users;


select * from students;
select *, IF(class_no=6 and height > 170, "6組の170cm以上", "その他") from students;

