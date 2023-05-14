use day_4_9_db;

select * from customers;

-- 問1
select 
	name, age 
from 
	customers
where 
	age >= 28 and age < 40
and 
	name like '%子'
order by age desc
limit 5


-- 問2
insert into receipts(id, customer_id, store_name, price) values(301, 100, 'StoreX', 10000);
select * from receipts;


-- 問3
delete from receipts where id = 301
select * from receipts;


-- 問4
delete from prefectures where name = '' or name is null;
select * from prefectures;


-- 問5
select * from customers order by age;
select age+1 from customers where age between 20 and 50;

update customers set age=age+1 where age between 20 and 50;
select * from customers order by age;


-- 問6
select * from students where class_no = 6;
update students set class_no = ceil(5*rand()) where class_no = 6;


-- 問7
select 
	* 
from 
	students 
where
	class_no = 1
and
	height < ALL(select height+10 from students where class_no in (3, 4));


-- 問8
update employees set department=trim(department);
select * from employees;


-- 問9
select IF(salary>=5000000, round(salary*0.9), round(salary*1.1)) from employees;
update employees set salary=IF(salary>=5000000, round(salary*0.9), round(salary*1.1));
select * from employees;


-- 問10
select curdate();
select * from customers ;

insert into customers(id, name, age, birth_day) values(101, '名無権兵衛', 0, curdate())
select * from customers ;


-- 問11
alter table customers add name_length int;

select *, char_length(replace(name, ' ', '')) from customers;

update customers set name_length=char_length(replace(name, ' ', ''))

select * from customers;


-- 問12 → 模解は coalesec を使う
alter table tests_score add score INT

select
	case 
		when test_score_1 is not null then test_score_1 
		when test_score_2 is not null then test_score_2 
		when test_score_3 is not null then test_score_3
		else 0
	end as 'すこあ'
from 
	tests_score;

-- -- score を挿入
update 
	tests_score 
set 
	score = case 
				when test_score_1 is not null then test_score_1 
				when test_score_2 is not null then test_score_2 
				when test_score_3 is not null then test_score_3
				else 0
			end
		
			
-- -- score の倍率アップデート
select 
	*, 
	case 
		when score >= 900 then floor(score*1.2)
		when score <= 600 then ceil(score*0.8)
		else score 
	end	
from
	tests_score
			
update 
	tests_score 
set 
	score = case 
				when score >= 900 then floor(score*1.2)
				when score <= 600 then ceil(score*0.8)
				else score 
			end

			
select * from tests_score ts 


-- 問13
select
	*
from
	employees 
order by case 
			when department='マーケティング部' then 1
			when department='研究部' then 2
			when department='開発部' then 3
			when department='総務部' then 4
			when department='営業部' then 5
			when department='経理部' then 6
			else 0
		end


