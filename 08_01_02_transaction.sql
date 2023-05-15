show databases;

use day_4_9_db;

show tables;

select * from users;


-- transaction の開始
start transaction;

-- -- update処理
update users set name='嘉喜 遥香' where id=1;

select * from users;

-- ROLLBACK(トランザクション開始前に戻す)
ROLLBACK;

-- COMMIT(トランザクションをDBに反映)
COMMIT;


-- ROLLBACK(トランザクション開始前に戻す)
ROLLBACK;

select * from students;

-- -- id 300 を削除
delete from students where id=300;

-- AUTOCOMMIT 確認
show variables where variable_name='autocommit';

-- -- autocommit を無効に
set AUTOCOMMIT=1;

delete from students where id=299;

-- -- SQLの反映
Commit;