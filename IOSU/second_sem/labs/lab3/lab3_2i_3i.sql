-- горизонтальное обновляемое представление;
create or replace view expensive_cost as
select * from service
where cost >= 40
with check option constraint check_cost;

-- проверка обновляемости:
---- правильная инструкция
insert into expensive_cost(name, cost, max_term, guarantee_period)
values('Furniture assembly', '50', '15', '3 years');
---- неправильная конструкция
insert into expensive_cost(name, cost, max_term, guarantee_period)
values('Furniture assembly', '30', '15', '3 years');

-- вертикальное или смешанное необновляемое представление;
create or replace view group_employees as
select occupation, count(occupation) from employee
group by occupation;