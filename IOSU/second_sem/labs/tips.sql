desc [tablename];

select constraint_name, constraint_type from user_constraints
where table_name = 'STAFF';

-- with appropriate field name
select constraint_name, column_name from user_cons_columns
where table_name='OWNER';

select ucc.column_name, uc.constraint_type from user_constraints uc, user_cons_columns ucc
where ucc.table_name = 'OWNER' and uc.constraint_name = ucc.constraint_name;