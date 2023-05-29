use day_10_14_db

show tables

## 違うSQLとして認識される
select * from customers where id = 1
select * from customers where id = 2
select * from customers where id = 3


## バインド変数
## ## 1回実行したら、ID変えても、ソフトパースになるぜ
set @customer_id=6
select * from customers where id = @customer_id