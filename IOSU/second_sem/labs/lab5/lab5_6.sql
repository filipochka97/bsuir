-- *Написать триггер INSTEAD OF для работы с необновляемым представлением.

create or replace view group_employees as
select occupation, category, count(occupation) employee_count from employee
group by occupation, category;

update group_employees
set category = 2
where occupation = 'carpenter';

create or replace trigger update_group_employees
instead of update on group_employees
for each row
begin
  update employee
  set category = :new.category
  where occupation = :old.occupation;
end;
/