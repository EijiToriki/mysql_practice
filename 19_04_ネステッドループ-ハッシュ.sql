explain analyze
select
	*
from 
	customers as ct
inner join
	prefectures as pr
on
	ct.prefecture_code = pr.prefecture_code 

/*
-> Nested loop inner join  (cost=224749 rows=497786) (actual time=0.906..755 rows=500000 loops=1)
    -> Filter: (ct.prefecture_code is not null)  (cost=50524 rows=497786) (actual time=0.856..320 rows=500000 loops=1)
        -> Table scan on ct  (cost=50524 rows=497786) (actual time=0.854..293 rows=500000 loops=1)
    -> Single-row index lookup on pr using PRIMARY (prefecture_code=ct.prefecture_code)  (cost=0.25 rows=1) (actual time=745e-6..764e-6 rows=1 loops=500000)
*/
	
	
	
explain analyze
select /*+ NO_INDEX(pr) */
	*
from 
	customers as ct
inner join
	prefectures as pr
on
	ct.prefecture_code = pr.prefecture_code 
	
/*
-> Inner hash join (ct.prefecture_code = pr.prefecture_code)  (cost=2.34e+6 rows=2.34e+6) (actual time=0.207..390 rows=500000 loops=1)
    -> Table scan on ct  (cost=122 rows=497786) (actual time=0.0582..283 rows=500000 loops=1)
    -> Hash
        -> Table scan on pr  (cost=4.95 rows=47) (actual time=0.0361..0.0448 rows=47 loops=1)
*/
	
	
