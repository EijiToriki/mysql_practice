# 利用DBへ移動
use my_db;
select database();

# テーブル作成
create table users(
	id INT,
	name VARCHAR(10),		-- 可変長文字列
	age INT,
	phone_number CHAR(13),	-- 13文字固定
	message TEXT
)

# テーブル一覧を表示
show tables;

# テーブルの定義確認
describe users;

# テーブルを削除
drop table users;

# テーブル作成(主キー付き)
create table users(
	id INT PRIMARY KEY,
	name VARCHAR(10),		-- 可変長文字列
	age INT,
	phone_number CHAR(13),	-- 13文字固定
	message TEXT
)

describe users;


