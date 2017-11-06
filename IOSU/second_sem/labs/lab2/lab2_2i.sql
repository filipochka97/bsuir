-- 1.Постоянные клиенты фирмы» (условная выборка)
-- 2.Прибыль по каждому виду услуги» (итоговый запрос)
-- 3.Продукция/услуги, реализованные на заданную сумму» (параметрический запрос)
-- 4.Общий список услуг с количеством договоров по каждой позиции» (запрос на объединение)
-- 5.Количество договоров по неделям года» (запрос по полю с типом дата)

-- 1.Постоянные клиенты фирмы» (условная выборка)
select * from client
where id_client in (
  select id_client from agreement
  group by id_client
  having count(id_client) >= 2
);

--2.Прибыль по каждому виду услуги» (итоговый запрос)
select name, cost*amount profit from service
join (
  select id_service, count(id_service) amount from agreement
  group by id_service
) t1 on service.id_service = t1.id_service;

-- 3.Продукция/услуги, реализованные на заданную сумму» (параметрический запрос)
select name, cost*amount profit from service
join (
  select id_service, count(id_service) amount from agreement
  group by id_service
) t1 on service.id_service = t1.id_service
where cost*amount >= &profit;

-- 4.Общий список услуг с количеством договоров по каждой позиции» (запрос на объединение)
select name, amount from (
  select id_service, count(id_service) amount from agreement
  group by agreement.id_service
) t1
join service on t1.id_service = service.id_service;

-- 5.Количество договоров по неделям года» (запрос по полю с типом дата)
select to_char(order_date, 'WW/YYYY') "Week of year", count(id_agreement) "Amount of agreements"
from agreement
group by to_char(order_date, 'WW/YYYY');