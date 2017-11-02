create sequence seq_id_employee;
create sequence seq_id_service;
create sequence seq_id_material;
create sequence seq_id_tool;
create sequence seq_id_agreement;
create sequence seq_id_client;


create or replace trigger trg_id_employee
before insert on employee
for each row
begin
  select seq_id_employee.nextval
  into :new.id_employee
  from dual;
end;

create or replace trigger trg_id_service
before insert on service
for each row
begin
  select seq_id_service.nextval
  into :new.id_service
  from dual;
end;

create or replace trigger trg_id_material
before insert on material
for each row
begin
  select seq_id_material.nextval
  into :new.id_material
  from dual;
end;

create or replace trigger trg_id_tool
before insert on tool
for each row
begin
  select seq_id_tool.nextval
  into :new.id_tool
  from dual;
end;

create or replace trigger trg_id_agreement
before insert on agreement
for each row
begin
  select seq_id_agreement.nextval
  into :new.id_agreement
  from dual;
end;

create or replace trigger trg_id_client
before insert on client
for each row
begin
  select seq_id_client.nextval
  into :new.id_client
  from dual;
end;

create or replace table employee (
  id_employee number(3) primary key,
  firstname varchar2(20) not null,
  lastname varchar2(20) not null,
  occupation varchar(2) not null,
  category number(1) check(category between 1 and 6),
  experience number(2) check(experience between 1 and 50)
);

create or replace table service (
  id_service number(3) primary key,
  name varchar2(20) not null,
  cost number(5) check(cost >= 20),
  max_term number(2) check(number <= 30),
  guarantee_period varchar(20) not null
);

create or replace table material (
  id_material number(3) primary key,
  name vachar2(20) not null,
  country varchar2(20) check(country != 'China'),
  amount number(3),
  provider varchar2(20) not null
);

create or replace table tool (
  id_tool number(3) primary key,
  name varchar2(20) not null,
  amount number(3),
  provider varchar2(20) not null
);

create or replace table client (
  id_client number(3) primary key,
  pass_data varchar2(10) unique,
  firstname varchar2(20) not null,
  lastname varchar2(20) not null,
  mobile_tel varchar2(20) unique
)

create or replace table agreement (
  id_agreement number(3) primary key,
  order_date date default sysdate,
  id_client references client,
  id_service references service,
  id_employee references employee,
  id_material references material,
  id_tool references tool
);