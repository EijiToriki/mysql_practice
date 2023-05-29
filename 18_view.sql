use day_10_14_db

show tables

-- view 作成
create view stores_items_view as
select st.name as store_name, it.name as item_name from stores as st
inner join items as it
on st.id = it.store_id 


select * from stores_items_view 

update items set name = "new Item 山田 1" where name = "Item 山田 1"

-- table と view の一覧
show tables

select * from information_schema.views where TABLE_SCHEMA = "day_10_14_db"

-- view の詳細
show create view stores_items_view


select * from stores_items_view where store_name = '山田商店'

select * from stores_items_view order by store_name

select store_name, count(*) from stores_items_view group by store_name order by store_name


-- view の削除
drop view stores_items_view 

-- view の定義変更
alter view stores_items_view as
select st.id as store_id, it.id as item_id, st.name as store_name, it.name as item_name from stores as st
inner join items as it
on st.id = it.store_id 


select * from stores_items_view 


-- view の名前変更
rename table stores_items_view to new_store_items_view

show tables