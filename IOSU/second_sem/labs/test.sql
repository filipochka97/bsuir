select table_name from user_tables
where tablespace_name = 'SYSTEM';
-- and rownum <= 4;

-- drop table branch cascade constraints;
-- drop synonym [name];
-- drop sequence Staff_seq;

update staff
set sex = 'female', fname = 'Даша', lname = 'Зыбко'
where sno = 40;

insert into owner
values (20, 'Ольга', 'Прус', 'Пилипки, 10', '+ 375 25 2223344');

update viewing
set date_o = to_date('2017/10/20', 'yyyy/mm/dd')
where rno = 1 and pno = 1;

alter table renter
add city varchar2(30);

update renter
set city = 'Пуховичи'
where rno = 1;

select * from staff
where sno in (
  select s.sno from staff s, property_for_rent p
  where s.sno = p.sno and p.type = 'h'
  group by s.sno
  having count(p.pno) > (
    select count(p.pno) from property_for_rent p
    where s.sno = p.sno and p.type = 'f'
  )
);




