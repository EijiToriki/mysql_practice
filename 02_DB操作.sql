## DBに関する操作
# DB一覧を表示
show databases;

# my_db という名前のDBを作成
create database my_db;

# DBの削除
drop database my_db;

# DBの切り替え
use performance_schema;

# 利用中のDBの表示
select database();

# my_dbの切り替え
use my_db;

