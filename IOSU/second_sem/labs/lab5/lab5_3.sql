-- Написать системный триггер добавляющий запись во вспомогательную таблицу LOG3,
-- когда пользователь подключается или отключается. В таблицу логов записывается имя пользователя (USER),
-- тип активности (LOGON или LOGOFF), дата (SYSDATE), количество записей в основной таблице БД.

create table log3 (
  id number(5) primary key,
  username varchar2(10),
  change_type varchar2(6) check(change_type in ('LOGON', 'LOGOFF')),
  datelog date default sysdate,
  timelog varchar2(10) default to_char(sysdate, 'hh24:mi:ss'),
  records_count number
);

create sequence log3_sequence;

create or replace trigger create_log3_id
before insert on log3
for each row
begin
  select log3_sequence.nextval
  into :new.id
  from dual;
end;
/

create or replace trigger system_logoff_trigger
before logoff on database
when (user != 'SYS')
declare
  v_records_count number;
begin
  select count(*) into v_records_count from agreement;
  insert into log3 (username, change_type, records_count)
  values (user, ora_sysevent, v_records_count);
end;
/

create or replace trigger system_logon_trigger
after logon on database
when (user != 'SYS')
declare
  v_records_count number;
begin
  select count(*) into v_records_count from agreement;
  insert into log3 (username, change_type, records_count)
  values (user, ora_sysevent, v_records_count);
end;
/