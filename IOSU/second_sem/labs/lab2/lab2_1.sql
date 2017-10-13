-- 1
select (city || ', ' || street || ', ' || tel_no) as info
from branch
where city in ('Минск', 'Гродно');

--2
select fname, lname, tel_no
from staff, objects
where staff.sno = objects.sno and rooms = 3;

--3
select sex, avg(salary) "Средняя ЗП", sum(salary) "Суммарная ЗП"
from staff
group by sex;

--4
select b.* from branch b, (
    select t1.bno, t1.women, t2.men
    from (
        select bno, count(bno) as women from staff
        where sex = 'female'
        group by bno
    ) t1
    left join (
        select bno, count(bno) as men from staff
        where sex = 'male'
        group by bno
    ) t2
    on t1.bno = t2.bno
) result
where result.bno = b.bno and (women > men or men is null);

