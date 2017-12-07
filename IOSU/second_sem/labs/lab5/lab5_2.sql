-- Написать DDL триггер, протоколирующий действия пользователей по созданию,
-- изменению и удалению таблиц в схеме во вспомогательную таблицу LOG2 в определенное время
-- и запрещающий эти действия в другое время.

create table log2 (
  id number(5) primary key,
  change_type char(1) check(change_type in ('C', 'A', 'D')),
  dateoper date default sysdate
);

create sequence log2_sequence;

create or replace trigger create_log2_id
before insert on log2
for each row
begin
  select log2_sequence.nextval
  into :new.id
  from dual;
end;
/

create or replace trigger register_changes2
before create or alter or drop on database
declare
  change_type log2.change_type%type;
begin
  if to_char(sysdate, 'hh24') between 9 and 16
  then
    case ora_sysevent
      when 'CREATE'
        then change_type := 'C';
      when 'ALTER'
        then change_type := 'A';
      when 'DROP'
        then change_type := 'D';
      else
        null;
      end case;
    insert into log2 (change_type) values (change_type);
  else
    raise_application_error(-20000, 'Database can''t be changed at this time');
  end if;
end;
/
