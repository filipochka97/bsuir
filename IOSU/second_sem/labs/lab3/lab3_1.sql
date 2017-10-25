-- В учебной базе данных создать следующие представления:

-- 1   с информацией об офисах в Бресте;
-- 2   с информацией об объектах недвижимости минимальной стоимости;
-- 3   с информацией о количестве сделанных осмотров с комментариями;
-- 4   со сведениями об арендаторах, желающих арендовать 3-х комнатные квартиры в тех же городах, где они проживают;
-- 5   со сведениями об отделении с максимальным количеством работающих сотрудников;
-- 6   с информацией о сотрудниках и объектах, которые они предлагают в аренду в текущем квартале;
-- 7   с информацией о владельцах, чьи дома или квартиры осматривались потенциальными арендаторами более двух раз.


-- 1
create or replace view brest_branch as
select * from branch
where city = 'Брест';

--2
create or replace view min_rent as
select * from objects
where rent = (
    select min(rent) from objects
);

--3
create or replace view count_with_comment as
select count(comment_0) "Viewings with comments" from viewing;

--4
--later

--5
create or replace view info_max_employee
select * from branch
where bno in (
    select bno from staff
    group by bno
    having count(bno) in (
        select max(count_bno) from (
            select count(bno) count_bno from staff
            group by bno
        )
    )
);

--6
create or replace view info_current_q as
select staff.fname, staff.lname,  objects.city, objects.street, tb.comment_0
from objects
join (
    select * from viewing
	where to_char(date_o, 'Q') = (
		select to_char(sysdate,'Q') from dual
	)
) tb on objects.pno = tb.pno
join staff on staff.sno = objects.sno;

--7
create or replace view more_than_two as
select * from owner
where ono in (
    select ono from objects
    where pno in (
        select pno from viewing
        group by pno
        having count(pno) > 2
    )
);

