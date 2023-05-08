select * from customers;

-- in + null
select * from customers where name is null ;
select * from customers where name in ("河野 文典", "稲田 季雄") or name is null  ;

-- not in
select * from customers where name not in ("河野 文典", "稲田 季雄", null);	-- 何も出てこない
select * from customers where name not in ("河野 文典", "稲田 季雄") or name is not null;

-- ALL
-- customersテーブルからid < 10 の人の誕生日よりも古い誕生日の人をusersテーブルから取り出す
select * from users where birth_day <= ALL(select birth_day from customers where id < 10 and birth_day is not NULL)