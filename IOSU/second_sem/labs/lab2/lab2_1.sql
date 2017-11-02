-- Вариант 2

-- 1. Вывести в одном поле адреса и телефоны офисов, расположенных в Минске и Гродно.
-- 2. Вывести информацию о сотрудниках, которые предлагают для аренды 3-х комнатные квартиры.
-- 3. Вывести итоговый отчет о средней и суммарной заработных платах сотрудников в зависимости от их половой принадлежности.
-- Подписать вычисляемые поля как «Суммарная зарплата» и «Средняя зарплата».
-- 4. *Вывести информацию об отделениях, где работает больше женщин, чем мужчин.


-- 1
select (city || ', ' || street || ', ' || tel_no) as info
from branch
where city in ('Минск', 'Гродно');

--2
select fname, lname, tel_no from staff
where sno in (
  select staff.sno
  from staff, objects
  where staff.sno = objects.sno and rooms = 3
  group by staff.sno
);

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

