show databases

use day_19_21_db


-- レンジパーティション
create table users_partitioned(
	name varchar(50),
	age int
)
partition by range(age)(
	partition p0 values less than(20),
	partition p1 values less than(40),
	partition p2 values less than(60)
)


insert into users_partitioned values("Taro", 18)
insert into users_partitioned values("Jiro", 28)
insert into users_partitioned values("Saburo", 38)
insert into users_partitioned values("Yoshiro", 48)

select * from users_partitioned 

select * from users_partitioned partition(p1)

explain select * from users_partitioned where age < 20


insert into users_partitioned values("Goro", 98)		-- パーティションないのでエラー

alter table users_partitioned 
partition by range(age)(
	partition p0 values less than(20),
	partition p1 values less than(40),
	partition p2 values less than(60),
	partition p_max values less than(maxvalue)
)



show tables

show create table sales_history_partitioned 

/*
CREATE TABLE `sales_history_partitioned` (
  `id` mediumint unsigned NOT NULL AUTO_INCREMENT,
  `customer_id` mediumint unsigned DEFAULT NULL,
  `product_id` mediumint unsigned DEFAULT NULL,
  `sales_amount` mediumint unsigned DEFAULT NULL,
  `sales_day` date NOT NULL DEFAULT '1970-01-01',
  PRIMARY KEY (`id`,`sales_day`)
) ENGINE=InnoDB AUTO_INCREMENT=2500001 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
/*!50100 PARTITION BY RANGE (year(`sales_day`))
(PARTITION p0_lt_2016 VALUES LESS THAN (2016) ENGINE = InnoDB,
 PARTITION p1_lt_2017 VALUES LESS THAN (2017) ENGINE = InnoDB,
 PARTITION p2_lt_2018 VALUES LESS THAN (2018) ENGINE = InnoDB,
 PARTITION p3_lt_2019 VALUES LESS THAN (2019) ENGINE = InnoDB,
 PARTITION p4_lt_2020 VALUES LESS THAN (2020) ENGINE = InnoDB,
 PARTITION p5_lt_2021 VALUES LESS THAN (2021) ENGINE = InnoDB,
 PARTITION p6_lt_max VALUES LESS THAN MAXVALUE ENGINE = InnoDB) */
*/

select count(*) from sales_history_partitioned shp 	-- パーティション化されている

select count(*) from sales_history sh 	-- パーティション化されていない


select count(*) from sales_history sh 
where sales_day between '2016-01-01' and '2016-12-31'	-- 1.584s

select count(*) from sales_history_partitioned shp  
where sales_day between '2016-01-01' and '2016-12-31'	-- 0.223s


-- リストパーティション

create table shops(
	id int,
	name varchar(50),
	shop_type int
)
partition by list(shop_type)(
	partition p0 values in(1,2,3),
	partition p1 values in(4,5),
	partition p2 values in(6,7)
)


insert into shops values
(1, "Shop A", 1),
(2, "Shop B", 2),
(3, "Shop C", 3),
(4, "Shop D", 4),
(5, "Shop E", 5),
(6, "Shop F", 6),
(7, "Shop G", 7)

select * from shops partition(p0, p1)

-- パーティション追加
alter table shops add partition
(partition p3 values in(8,9,10))

insert into shops values
(8, "Shop H", 8),
(9, "Shop I", 9),
(10, "Shop J", 10)

select * from shops partition(p3)


insert into shops values(9, 'shopH', 90)	-- パーティションに無いのでエラー



-- ハッシュパーティション
create table h_partition(
	name varchar(50),
	partition_key int
)
partition by hash(partition_key)
partitions 4

insert into h_partition values
('A', 1),
('B', 2),
('C', 3),
('D', 4),
('E', 5),
('F', 6),
('G', 7),
('H', 8),
('I', 9)

select * from h_partition partition(p1)



create table k_partition(
	id int primary key auto_increment,
	name varchar(59)
)
partition by key()
partitions 2

insert into k_partition(name) values
('A'),
('B'),
('C'),
('D'),
('E'),
('F'),
('G'),
('H'),
('I'),
('J')

select * from k_partition partition(p1)


-- サブパーティション
create table order_history(
	id int,
	amount int,
	order_date date
)
partition by range(year(order_date))
subpartition by hash(id)(
	partition p0 values less than(2010)(
		subpartition s0,
		subpartition s1
	),
	partition p1 values less than(2015)(
		subpartition s2,
		subpartition s3
	),
	partition p2 values less than(maxvalue)(
		subpartition s4,
		subpartition s5
	)
)


insert into order_history values
(1, 1000, "2008-01-01"),
(2, 1000, "2009-01-01"),
(3, 1000, "2008-11-01"),
(4, 1000, "2009-02-01"),
(5, 1000, "2018-01-01"),
(6, 1000, "2012-01-01")

select * from order_history partition(s1)

explain select * from order_history where order_date < '2009-01-01'

-- 統計情報の更新
alter table order_history analyze partition s0