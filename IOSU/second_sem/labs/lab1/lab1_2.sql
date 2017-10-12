create synonym objects for property_for_rent;

create sequence Staff_seq
increment by 5
start with 10;

insert into branch values (3, 'Гепы, 95', 'Минск', '+375 29 9876542');
insert into branch values (4, 'Кульман, 1', 'Минск', '+375 29 1111114');

insert into staff
values (Staff_seq.NEXTVAL, 'Евгений', 'Филиппович', 'Садовая, 13', '+375 29 9795925', 'QA', 'male', to_date('2011/04/22', 'yy/mm/dd'), 1200, 1);

insert into renter
values (2, 'Андрей', 'Орсич', 'Минск, Кульман 1', '+375 29 9876543',  'h', 100, 3);

insert into owner
select sno, fname, lname, address, tel_no from staff;

insert into objects
values (1, ' Звезды, 95', 'Гродно', 'h', 5, 200, 120, 1, 120);

insert into viewing
values (2, 1, to_date('2017/09/28', 'yyyy/mm/dd'), 'Great!!');