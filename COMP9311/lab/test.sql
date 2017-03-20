
-- Q3: convenor for the most courses

create or replace view Q3(name, ncourses)
as
SELECT ranking.name, ranking.count 
FROM (SELECT counter.name, counter.count, row_number() OVER 
(ORDER BY GREATEST(counter.count) DESC) as rn from (SELECT convenor.name, COUNT(convenor.course) 
FROM (SELECT people.id, people.name, course_staff.course 
FROM people INNER JOIN course_staff on (people.id = course_staff.staff)
WHERE role='1870' ORDER BY people.id) AS convenor GROUP BY convenor.name) AS counter) AS ranking WHERE rn = 1
;
