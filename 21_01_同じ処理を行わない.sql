use day_19_21_db

show index from customers

drop index idx_customers_age on customers

select 
	*
from 
	customers 
where 
	prefecture_code in (select prefecture_code from prefectures where name = '東京都')
or 
	prefecture_code in (select prefecture_code from prefectures where name = '大阪府')

-- 無駄な処理を1つに
select 
	*
from 
	customers 
where 
	prefecture_code in (select prefecture_code from prefectures where name in ('東京都', '大阪府'))

	
-- select 内副問い合わせをやめる

explain analyze
select
	*, (select name from prefectures as pr where pr.prefecture_code = ct.prefecture_code)
from 
	customers as ct
	
	

-- 2016 年度日ごとの集計カラムを追加
select sales_day, sum(sales_amount)
from sales_history
where sales_day between '2016-01-01' and '2016-12-31'
group by sales_day
	
	
	
select
	*
from 
	sales_history 
left join
(
select sales_day, sum(sales_amount) as sales_daily_amount
from sales_history
where sales_day between '2016-01-01' and '2016-12-31'
group by sales_day
) as sales_summary
on sales_history.sales_day = sales_summary.sales_day
where sales_day between '2016-01-01' and '2016-12-31'	-- めっちゃ時間かかる（無駄な二回の絞り込み）


select
	sh.*,
	sum(sh.sales_amount) over(partition by sh.sales_day)
	
from 
	sales_history as sh
where sh.sales_day between '2016-01-01' and '2016-12-31'




	
	
	