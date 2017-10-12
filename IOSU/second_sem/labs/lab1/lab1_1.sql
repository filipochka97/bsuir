create table branch (
    bno integer primary key,
    street varchar2(100),
    city varchar2(100),
    tel_no varchar2(100) unique
);

create table staff (
    sno integer primary key,
    fname varchar2(100),
    lname varchar2(100),
    address varchar2(100),
    tel_no varchar2(100),
    position varchar2(100),
    sex varchar2(10) check(sex in ('male', 'female')),
    dob date,
    salary integer,
    bno references branch
);

create table property_for_rent(
    pno integer primary key,
    street varchar2(100),
    city varchar2(100),
    type varchar2(5) check(type in ('h', 'f')),
    rooms integer,
    rent integer,
    sno references staff,
    bno references branch
);

create table renter(
    rno integer primary key,
    fname varchar2(100),
    lname varchar2(100),
    address varchar(100),
    tel_no varchar2(15),
    pref_type varchar2(5) check(pref_type in ('h', 'f')),
    max_rent integer,
    bno references branch
);

create table owner(
    ono integer primary key,
    fname varchar2(100),
    lname varchar2(100),
    address varchar2(100),
    tel_no varchar2(150)
);

alter table property_for_rent
add ono references owner;

create table viewing (
    rno references renter,
    pno references property_for_rent,
    date_o date,
    comment_0 varchar2(200),
    constraint viewing_pk
    primary key(rno, pno)
);