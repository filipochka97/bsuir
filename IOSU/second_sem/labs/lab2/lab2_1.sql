-- 1
select (city || ', ' || street || ', ' || tel_no) as info
from branch
where city in ('Минск', 'Гродно');

--2
select fname, lname, tel_no
from staff, objects
where staff.bno = objects.bno and rooms = 3;

--3
select sex, avg(salary) "Средняя ЗП", sum(salary) "Суммарная ЗП"
from staff
group by sex;

--4

