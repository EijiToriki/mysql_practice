select * from users;

select
	*,
	case birth_place
		when "日本" then "日本人"
		when "Iraq" then "イラク人"
	else "外国人"
	end as "国籍"
from
	users;
where
	id > 30;


select * from prefectures;

select
	name,
	case 
		when name IN('香川県','愛媛県','徳島県','高知県') THEN '四国'
	else 'その他'
	end as '地域名'
from 
	prefectures;


-- 計算
select 
	name ,
	birth_day ,
	case 
		when date_format(birth_day, "%Y") % 4 = 0 and date_format(birth_day, "%Y") % 100 <> 0 then "うるう年"
		else "うるう年でない"
	end as "うるう年か"
from 
	users;


select
	*,
	case 
		when student_id % 3 = 0 then test_score_1
		when student_id % 3 = 1 then test_score_2
		when student_id % 3 = 2 then test_score_3
	end	as score
from 
	tests_score

	
	
-- order by に case 
select 
	*,
	case 
		when name IN('香川県','愛媛県','徳島県','高知県') THEN '四国'
		when name IN('兵庫県', '大阪府', '京都府', '滋賀県', '奈良県', '三重県', '和歌山県') THEN '近畿'
		else 'その他'
	end as 地域名
from 
	prefectures
order by
	case 
		when name IN('香川県','愛媛県','徳島県','高知県') THEN 0
		when name IN('兵庫県', '大阪府', '京都府', '滋賀県', '奈良県', '三重県', '和歌山県') THEN 1
		else 2
	end;


-- update + case
select * from users

alter table users add birth_era varchar(2) after birth_day;

select *,
case 
	when birth_day < "1989-01-07" then "昭和"
	when birth_day < "2019-05-01" then "平成"
	when birth_day >= "2019-05-01" then "令和"
	else "不明"
end as "元号"
from
 users;


update 
	users
set 
	birth_era = case 
		when birth_day < "1989-01-07" then "昭和"
		when birth_day < "2019-05-01" then "平成"
		when birth_day >= "2019-05-01" then "令和"
		else "不明"
	end

select birth_era, count(birth_era)  from users
group by birth_era


-- NULL を使う場合
select *,
case
	when name is NULL then "不明"
	when name is not null then "null以外"
	else ""
	end as "null check"
from customers 

	