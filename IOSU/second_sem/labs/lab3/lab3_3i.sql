-- Основная задача - заключение сделок
create or replace view work_with_agreement as
select * from agreement
where to_number(to_char(sysdate, 'D')) between 2 and 6
and to_number(to_char(sysdate, 'HH24')) between 8 and 23
with check option constraint check_date;