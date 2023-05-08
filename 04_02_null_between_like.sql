select database();

describe customers;

-- is null でnull値を取り出す
select * from customers where name is null;
select * from customers where name is not null;

-- 空白の取り出し方とnullの取り出し方は異なる
select * from prefectures;
select * from prefectures where name is null;
select * from prefectures where name = ""



-- between 
select * from users where age not between 5 and 10;

-- like
select * from users where name like "村%";	-- 前方一致

select * from users where name like "%郎";	-- 後方一致

select * from users where name like "%d%";	-- 中間一致

select * from prefectures where name like "福_県" order by name ;	-- _ は任意の1文字