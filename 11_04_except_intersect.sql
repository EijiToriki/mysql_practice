-- Except を Exists で書く
select * from customers
UNION
select * from customers_2


select * from customers as c1
where not exists (
	select * from customers_2 as c2
	where 
		c1.id = c2.id and 
		c1.first_name = c2.first_name and 
		c1.last_name = c2.last_name and 
		c1.phone_number or (c1.phone_number is null and c2.phone_number is null) = c2.phone_number and 
		c1.age = c2.age
)


-- intersect を exists で抽出
select * from customers as c1
where exists (
	select * from customers_2 as c2
	where 
		c1.id = c2.id and 
		c1.first_name = c2.first_name and 
		c1.last_name = c2.last_name and 
		c1.phone_number or (c1.phone_number is null and c2.phone_number is null) = c2.phone_number and 
		c1.age = c2.age
)