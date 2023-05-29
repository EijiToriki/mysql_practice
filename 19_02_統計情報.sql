show databases

create database day_19_21_db

show tables

-- 統計情報を見る
select * from mysql.innodb_table_stats where database_name = 'day_19_21_db'	-- 周期的に更新される（すぐには更新されない）

select * from prefectures p 

insert into prefectures values("48", "unknown")

-- -- 統計情報の手動更新
analyze table prefectures 

delete from prefectures where prefecture_code = '48' and name = 'unknown'


-- 200件表示
select * from customers c 

-- SQLを実行せずに実行計画だけ表示し
explain select * from customers c 

-- SQLを実行せずに実行計画だけ表示し
explain analyze select * from customers c 
/*
 * Limit: 200 row(s)  (cost=52756 rows=200) (actual time=0.0672..0.171 rows=200 loops=1)¶    -> Table scan on c  (cost=52756 rows=497786) (actual time=0.0665..0.163 rows=200 loops=1)¶|
 */

select * from customers c 