-- select table_name from user_tables
-- where tablespace_name = 'SYSTEM';
-- and rownum <= 4;

-- drop table branch cascade constraints;
-- drop synonym [name];
-- drop sequence Staff_seq;

update staff
set sex = 'female', fname = 'Даша', lname = 'Зыбко'
where sno = 40;
