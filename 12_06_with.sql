-- with

-- departments から営業部の人を取り出して、employees を結合する

select
	*
from 
	employees as em
inner join
	departments as dt 
on
	em.department_id = dt.id 
where dt.name = '営業部'



with tmp_department as (
	select * from departments where name = '営業部'
)
select * from employees as em
inner join tmp_department
on em.department_id = tmp_department.id



-- stores テーブルからid 1,2,3のものを取り出す
-- itemsテーブルと紐づけ、itemsテーブルとordersテーブルを紐づける
-- ordersテーブルのorder_amount * order_priceの合計値をstoresテーブルのstore_name毎に集計する

with tmp_stores as(
	select * from stores where id in (1,2,3)
), tmp_items_orders as(
	select
		items.id as item_id, 
		tmp_stores.id as store_id,
		orders.id as order_id,
		orders.order_amount as order_amount,
		orders.order_price as order_price,
		tmp_stores.name as store_name
	from 
		tmp_stores
	inner join
		items 
	on
		tmp_stores.id = items.store_id 
	inner join 
		orders
	on 
		items.id = orders.item_id 
)
select store_name, sum(order_amount * order_price) from tmp_items_orders group by store_name


select 
	st.name,
	sum(od.order_amount * od.order_price)
from 
	stores as st
inner join 
	items as it
on
	st.id = it.store_id 
inner join 
	orders as od 
on
	od.item_id = it.id 
where 
	st.id in (1,2,3)
group by
	st.id
order by 
	st.id
