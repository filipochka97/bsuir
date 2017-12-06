-- Рассчитывать общую сумму стоимости по договору, делая скидку клиентам
-- в зависимости от количества или общей суммы их заказов.

create or replace trigger total_cost
before insert or update on orders
for each row
declare
  agreement_record agreement%rowtype;
  service_record service%rowtype;
  n_expiration_date agreement.expiration_date%type;
  n_total_cost agreement.total_cost%type;
  n_discount agreement.discount%type;
begin
  select * into service_record from service
  where service.id_service = :new.id_service;

  begin
    select * into agreement_record from agreement
    where agreement.id_agreement = :new.id_agreement;
    exception
    when no_data_found
    then agreement_record.id_agreement := null;
  end;

  if agreement_record.id_agreement is not null
  then
    if agreement_record.expiration_date >= sysdate + service_record.max_term
    then n_expiration_date := agreement_record.expiration_date;
    else n_expiration_date := sysdate + service_record.max_term;
    end if;
    n_discount := 5;
    n_total_cost := (100 - n_discount) / 100 * (agreement_record.total_cost + service_record.cost);
    update agreement
    set expiration_date = n_expiration_date,
        order_date = sysdate,
        discount = n_discount,
        total_cost = n_total_cost
    where id_agreement = :new.id_agreement;
  else
    n_expiration_date := sysdate + service_record.max_term;
    n_total_cost := service_record.cost;
    insert into agreement (id_agreement, expiration_date, order_date, total_cost)
    values (:new.id_agreement, n_expiration_date, sysdate, n_total_cost);
  end if;
end;
/

---
insert into orders(id_agreement, id_service, id_material, material_amount, id_tool, tool_amount, id_employee, id_client)
values (2, 3, 1, 1, 1, 1, 3, 1);


-- Контролировать количество материала и продукции в наличии при заключении договора, не допускать
-- одновременного оказания одних и тех же услуг нескольким клиентам.

create or replace trigger check_mater_and_tools
before insert or update on orders
for each row
declare
  material_record material%rowtype;
  tool_record tool%rowtype;
  service_record service%rowtype;
begin
  select * into material_record from material
  where :new.id_material = material.id_material;

  select * into tool_record from tool
  where :new.id_tool = tool.id_tool;

  select * into service_record from service
  where :new.id_service = service.id_service;

  if :new.material_amount > material_record.amount or :new.tool_amount > tool_record.amount
  then raise_application_error(-20001, 'There is no so much material or tool, sorry');
  elsif service_record.completed = 'n'
  then raise_application_error(-20002, 'This service is already booked');
  else
    update material
    set amount = amount - :new.material_amount
    where id_material = :new.id_material;

    update tool
    set amount = amount - :new.tool_amount
    where id_tool = :new.id_tool;

    update service
    set completed = 'n'
    where id_service = :new.id_service;
  end if;
end;
/


-- Ежедневно вести учет договоров, по которым истечение сроков
-- исполнения произойдет менее чем через три дня.

create table registration (
  id_registration number(5) primary key,
  id_agreement references agreement,
  check_date date default sysdate
);

create sequence registration_seq;

create or replace trigger registration_id_trigger
before insert on registration
for each row
begin
  select registration_seq.nextval
  into :new.id_registration
  from dual;
end;
/

begin
  dbms_scheduler.create_job(
    job_name => 'system.daily_job',
    job_type => 'plsql_block',
    job_action => 'begin system.check_agreements(); end;',
    start_date => sysdate,
    repeat_interval => 'freq=daily',
    enabled => true
  );
end;
/

begin
dbms_scheduler.run_job(job_name => 'system.daily_job');
end;
/

begin
dbms_scheduler.drop_job('system.daily_job');
end;
/

create or replace procedure check_agreements is
begin
  for agreement_item in (select id_agreement, expiration_date from agreement)
  loop
    if agreement_item.expiration_date - sysdate <= 3
    then
      insert into registration (id_agreement) values(agreement_item.id_agreement);
    end if;
  end loop;
end;
/


