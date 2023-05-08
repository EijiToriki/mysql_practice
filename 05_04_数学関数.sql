-- round, floor, ceiling
select round(13.14, -1)

select floor(3.14)
select floor(3.84)

select ceiling(3.14)


select rand()
select floor(rand() * 10)



-- power
select power(3,4)

select weight / power(height/100, 2) from students


-- COALESCE
select * from tests_score

select coalesce(NULL, NULL, "A", NULL, "B")

select coalesce(test_score_1, test_score_2, test_score_3) as score from tests_score ts 