-- Написать DML триггер, регистрирующий изменение данных (вставку, обновление, удаление)
-- в одной из таблиц БД. Во вспомогательную таблицу LOG1 записывать кто, когда (дата и время)
-- и какое именно изменение произвел, для одного из столбцов сохранять старые и новые значения.

create table log1 (
  id number(5) primary key,
  username varchar2(20),
  dateoper date default sysdate,
  change_type char(1) check (change_type in ('I', 'U', 'D')),
  table_name varchar(20),
  column_name varchar2(20),
  old_value varchar2(200),
  new_value varchar2(200)
);

create sequence log1_sequence;

create or replace trigger create_log1_id
before insert on log1
for each row
begin
  select log1_sequence.nextval
  into :new.id
  from dual;
end;
/

create or replace trigger register_changes
after insert or update or delete
on material
for each row
declare
  change_type log1.change_type%type;
  old_value log1.old_value%type;
  new_value log1.new_value%type;
begin
  case
    when inserting
      then change_type := 'I';
    when updating
      then change_type := 'U';
    when deleting
      then change_type := 'D';
  else
    null;
  end case;

  old_value := :old.provider;
  new_value := :new.provider;

  insert into log1 (username, dateoper, change_type, table_name, column_name, old_value, new_value)
  values(user, sysdate, change_type, 'material', 'provider', old_value, new_value);
end;
/
