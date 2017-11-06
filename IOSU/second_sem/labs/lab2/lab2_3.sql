-- Самостоятельно придумать и реализовать следующие запросы:
-- 1. с внутренним соединением таблиц, используя стандартный синтаксис SQL;
-- 2. с внешним соединением таблиц, используя FULL JOIN, LEFT JOIN или RIGHT JOIN;
-- 3. с использованием предиката IN с подзапросом;
-- 4. с использованием предиката ANY/ALL с подзапросом;
-- 5. с использованием предиката EXISTS/NOT EXISTS с подзапросом.

-- 1.
select distinct c.firstname, c.lastname, s.name from agreement a
join client c on a.id_client = c.id_client
join service s on a.id_service = s.id_service;

-- 2.
select distinct c.firstname, c.lastname, s.name from agreement a
right join client c on a.id_client = c.id_client
left join service s on a.id_service = s.id_service;

-- 3.
select * from agreement
where id_employee in (
  select id_employee from employee
  where experience > 2
);

-- 4. Вывести работников, стоимость услуг которых в договоре максимальна в сравнении с остальными работниками
select e.firstname || ' ' || e.lastname as info from agreement a
join employee e on a.id_employee = e.id_employee
join service s on a.id_service = s.id_service
where s.cost >= all (
  select cost from service
);

-- 5. Вывести работников, которые еще ни разу не были задействованы
select * from employee e
where not exists (
  select * from agreement a
  where a.id_employee = e.id_employee
);
