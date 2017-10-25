desc [tablename];

select constraint_name, constraint_type from user_constraints
where table_name = 'OWNER';

-- with appropriate field name
select constraint_name, column_name from user_cons_columns
where table_name='OWNER';