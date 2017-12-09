-- *Самостоятельно или при консультации преподавателя составить задание на триггер,
-- который будет вызывать мутацию таблиц, и решить эту проблему двумя способами:
-- 1) при помощи переменных пакета и двух триггеров;
-- 2) при помощи COMPAUND триггера.

update agreement
set discount = 3
where discount is null;


-- 1 --
create or replace package my_package1 is
  procedure set_max_discount(max_discount in agreement.discount%type);
  function get_max_discount return agreement.discount%type;
end my_package1;
/

create or replace package body my_package1 is
  vmax_discount agreement.discount%type;

  procedure set_max_discount(max_discount in agreement.discount%type) is
  begin
    select max(discount) into my_package1.vmax_discount from agreement;
  end set_max_discount;

  function get_max_discount return agreement.discount%type is
  begin
    return my_package1.vmax_discount;
  end get_max_discount;
end;
/

create or replace trigger agreement_discount1
before update on agreement
declare
  max_discount agreement.discount%type;
begin
  select max(discount) into max_discount from agreement;
  my_package1.set_max_discount(max_discount);
end;
/

create or replace trigger agreement_discount2
before update on agreement
for each row
begin
  if :new.discount > my_package1.get_max_discount() then
    raise_application_error(-20003, 'Discount mustn''t be less than the minimal discount');
  end if;
end;
/



-- 2 --
create or replace trigger agreement_discount
for update of discount on agreement
compound trigger
max_discount agreement.discount%type;

before statement is
begin
  select max(discount) into max_discount from agreement;
end before statement;

before each row is
begin
  if :new.discount > max_discount then
    raise_application_error(-20003, 'Discount mustn''t be less than the minimal discount');
  end if;
end before each row;
end;
/


-- create or replace trigger agreement_discount
-- before update on agreement
-- for each row
-- declare
--   max_discount agreement.discount%type;
-- begin
--   select max(discount) into max_discount from agreement;
--   if :new.discount > max_discount then
--   raise_application_error(-20003, 'Discount mustn''t be less than the minimal discount');
--   end if;
-- end;
-- /