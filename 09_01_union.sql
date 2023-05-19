show databases
use day_4_9_db

-- UNION は重複削除：処理時間長くなりがち
select * from new_students 
union
select * from students
order by id

-- UNION ALL は重複も残す
select * from new_students 
union all
select * from students
order by id


select * from students where id < 10
union all 
select * from students where id > 250


-- 型が一緒だったら結合可能
select id, name from students where id < 10
union all 
select age, name from users where id < 250
order by id	-- 1個目のselectのカラム

-- カラム数が合っていないのでエラー
select id, name, height from students
union
select age, name from users