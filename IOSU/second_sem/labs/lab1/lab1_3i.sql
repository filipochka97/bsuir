create sequence seq_id_employee;
create sequence seq_id_service;
create sequence seq_id_material;
create sequence seq_id_tool;
create sequence seq_id_client;
create sequence seq_id_agreement;


create table employee (
  id_employee number(3) primary key,
  firstname varchar2(20) not null,
  lastname varchar2(20) not null,
  occupation varchar(20) not null,
  category number(1) check(category between 1 and 6),
  experience number(2) check(experience between 1 and 50)
);

create table service (
  id_service number(3) primary key,
  name varchar2(20) not null,
  cost number(5) check(cost >= 20),
  max_term number(2) check(max_term <= 30),
  guarantee_period varchar(20) not null
);

create table material (
  id_material number(3) primary key,
  name varchar2(20) not null,
  country varchar2(20) check(country != 'China'),
  amount number(3),
  provider varchar2(20) not null
);

create table tool (
  id_tool number(3) primary key,
  name varchar2(20) not null,
  amount number(3),
  provider varchar2(20) not null
);

create table client (
  id_client number(3) primary key,
  pass_data varchar2(10) unique,
  firstname varchar2(20) not null,
  lastname varchar2(20) not null,
  mobile_tel varchar2(20) unique
);

create table agreement (
  id_agreement number(3) primary key,
  order_date date default sysdate,
  id_client references client,
  id_service references service,
  id_employee references employee,
  id_material references material,
  id_tool references tool
);


create or replace trigger trg_id_employee
before insert on employee
for each row
begin
  select seq_id_employee.nextval
  into :new.id_employee
  from dual;
end;
/

create or replace trigger trg_id_service
before insert on service
for each row
begin
  select seq_id_service.nextval
  into :new.id_service
  from dual;
end;
/

create or replace trigger trg_id_material
before insert on material
for each row
begin
  select seq_id_material.nextval
  into :new.id_material
  from dual;
end;
/

create or replace trigger trg_id_tool
before insert on tool
for each row
begin
  select seq_id_tool.nextval
  into :new.id_tool
  from dual;
end;
/

create or replace trigger trg_id_client
before insert on client
for each row
begin
  select seq_id_client.nextval
  into :new.id_client
  from dual;
end;
/

create or replace trigger trg_id_agreement
before insert on agreement
for each row
begin
  select seq_id_agreement.nextval
  into :new.id_agreement
  from dual;
end;
/


create synonym e for employee;
create synonym s for service;
create synonym m for material;
create synonym t for tool;
create synonym c for client;
create synonym a for agreement;


create index employee_idx
on employee(experience);

create index service_idx
on service(cost);

create index material_idx
on material(country);

create index tool_idx
on tool(name);

create index client_idx
on client(firstname);

create index agreement_idx
on agreement(order_date);


insert all
  into employee(firstname, lastname, occupation, category, experience)
  values('Anton', 'Kuchumov', 'carpenter', '1', '1')
  into employee(firstname, lastname, occupation, category, experience)
  values('Ihar', 'Kovtun', 'woodworker', '2', '2')
  into employee(firstname, lastname, occupation, category, experience)
  values('Dima', 'Bilan', 'carver', '3', '3')
select * from dual;

insert all
  into service(name, cost, max_term, guarantee_period)
  values('Door installation', '20', '30', '1 year')
  into service(name, cost, max_term, guarantee_period)
  values('Windows installation', '30', '10', '3 years')
  into service(name, cost, max_term, guarantee_period)
  values('Laying laminate', '40', '20', '2 years')
select * from dual;

insert all
  into material(name, country, amount, provider)
  values('door', 'Belarus', 20, 'Pinskdrev')
  into material(name, country, amount, provider)
  values('window', 'Belgium', 30, 'Balterio')
  into material(name, country, amount, provider)
  values('laminate', 'Germany', 40, 'Classen')
select * from dual;

insert all
  into tool(name, amount, provider)
  values('screwdriver', 200, 'Titebond')
  into tool(name, amount, provider)
  values('perforator', 100, 'Burovik')
  into tool(name, amount, provider)
  values('hammer', 300, 'Mazservice')
select * from dual;

insert all
  into client(pass_data, firstname, lastname, mobile_tel)
  values('KH2179902', 'Zhenya', 'Filippovich', '+375 29 9795925')
  into client(pass_data, firstname, lastname, mobile_tel)
  values('KH2188803', 'Andrew', 'Orsich', '+375 25 9135180')
  into client(pass_data, firstname, lastname, mobile_tel)
  values('HK2450967', 'Alik', 'Franchmen', '+375 33 2834056')
select * from dual;

insert all
  into agreement(order_date, id_client, id_service, id_employee, id_material, id_tool)
  values(to_date('2017/09/01', 'yyyy/mm/dd'), 1, 3, 1, 1, 1)
  into agreement(order_date, id_client, id_service, id_employee, id_material, id_tool)
  values(to_date('2017/10/15', 'yyyy/mm/dd'), 2, 4, 2, 2, 2)
  into agreement(id_client, id_service, id_employee, id_material, id_tool)
  values(3, 5, 3, 3, 3)
select * from dual;