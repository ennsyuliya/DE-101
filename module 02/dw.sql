create schema dw;


--creating a table
drop table if exists dw.ship ;
CREATE TABLE dw.ship
(
 ship_id   serial NOT NULL,
 Ship_Mode varchar(14) NOT NULL,
 Ship_Date date NOT NULL,
 CONSTRAINT PK_1 PRIMARY KEY ( ship_id )
);

--deleting rows
truncate table dw.ship;

--generating ship_id and inserting ship_mode from orders
insert into dw.ship
select 100+row_number() over(), Ship_Mode, Ship_Date  from (select distinct Ship_Mode, Ship_Date from public.orders ) a;
--checking
select * from dw.ship sd; 

--GEOGRAPHY

drop table if exists dw.region;
CREATE TABLE dw.region (
 geo_id      serial NOT NULL,
 Postal_Code varchar(20) NOT NULL,
 Country     varchar(20) NOT NULL,
 State       varchar(20) NOT NULL,
 Region      varchar(7) NOT NULL,
 City        varchar(17) NOT NULL,

  CONSTRAINT PK_geo PRIMARY KEY (geo_id)
);

--deleting rows
truncate table dw.region;
--generating geo_id and inserting rows from orders
insert into dw.region
select 100+row_number() over(), Country, City, State, Region, Postal_Code from (select distinct Country, City, State, Region, Postal_Code from public.orders ) a;
--data quality check
select distinct Country, City, State,Region, Postal_Code from dw.region
where Country is null or City is null or Postal_Code is null;

-- City Burlington, Vermont doesn't have postal code
update dw.region
set Postal_Code = '05401'
where City = 'Burlington'  and Postal_Code is null;

--also update source file
update public.orders
set Postal_Code = '05401'
where City = 'Burlington'  and Postal_Code is null;


select * from dw.region
where City = 'Burlington'






--CUSTOMER

drop table if exists dw.customer;

CREATE TABLE dw.customer
(
 cust_id serial NOT NULL,
 Customer_ID  varchar(8) NOT NULL,
 Customer_Name varchar(22) NOT NULL,
 Segment       varchar(11) NOT NULL,

  CONSTRAINT PK_customer PRIMARY KEY ( cust_id )
);




--deleting rows
truncate table dw.customer;
--inserting
insert into dw.customer
select 100+row_number() over(), Customer_ID, Customer_Name, Segment  from (select distinct Customer_ID, Customer_Name, Segment from public.orders ) a;
--checking
select * from dw.customer cd;  



--PRODUCT

--creating a table
drop table if exists dw.product;
CREATE TABLE dw.product
(
 prod_id   serial NOT NULL,
 Product_ID   varchar(50) NOT NULL,
 Category     varchar(127) NOT NULL,
 SubCategory  varchar(50) NOT NULL,
 Product_Name varchar(127) NOT NULL,
 CONSTRAINT PK_3 PRIMARY KEY ( prod_id )
);

--deleting rows
truncate table dw.product;
--
insert into dw.product
select 100+row_number() over () as prod_id ,Product_ID, Product_Name, Category, SubCategory from (select distinct Product_ID, Product_Name, Category, SubCategory from public.orders ) a;
--checking
select * from dw.product cd; 




--CALENDAR use function instead 
-- examplehttps://tapoueh.org/blog/2017/06/postgresql-and-the-calendar/

--creating a table
drop table if exists dw.calendar;
CREATE TABLE dw.calendar
(
dateid serial  NOT NULL,
year        int NOT NULL,
quarter     int NOT NULL,
month       int NOT NULL,
week        int NOT NULL,
date        date NOT NULL,
week_day    varchar(20) NOT NULL,
leap  varchar(20) NOT NULL,
CONSTRAINT PK_calendar_dim PRIMARY KEY ( dateid )
);

--deleting rows
truncate table dw.calendar;
--
insert into dw.calendar
select 
to_char(date,'yyyymmdd')::int as date_id,  
       extract('year' from date)::int as year,
       extract('quarter' from date)::int as quarter,
       extract('month' from date)::int as month,
       extract('week' from date)::int as week,
       date::date,
       to_char(date, 'dy') as week_day,
       extract('day' from
               (date + interval '2 month - 1 day')
              ) = 29
       as leap
  from generate_series(date '2000-01-01',
                       date '2030-01-01',
                       interval '1 day')
       as t(date);
--checking
select * from dw.calendar; 


-- T.Staff
DROP TABLE IF EXISTS dw.staff;
CREATE TABLE dw.staff
(
 Region varchar(15) NOT NULL,
 Person varchar(50) NOT NULL,
 CONSTRAINT PK_5 PRIMARY KEY ( Region )
);
TRUNCATE TABLE dw.staff;
	insert into dw.staff
	select Region, Person
	from (select distinct Region, Person from public.people) a;
select * from dw.staff;


--METRICS

--creating a table
drop table if exists dw.sales;
CREATE TABLE dw.sales
(
 sales_id      serial NOT NULL,
 cust_id integer NOT NULL,
 Order_Date varchar(8) NOT NULL,
 ship_date_id date NOT NULL,
 prod_id   integer NOT NULL,
 ship_id     integer NOT NULL,
 geo_id      integer NOT NULL,
 Order_ID    varchar(25) NOT NULL,
 Sales       numeric(9,4) NOT NULL,
 Profit      numeric(21,16) NOT NULL,
 Quantity    int4 NOT NULL,
 Discount    numeric(4,2) NOT NULL,
 CONSTRAINT PK_sales_fact PRIMARY KEY ( sales_id ));

insert into dw.sales 
select
	 row_number() over() as row_id,
	 s.ship_id,
	 o.order_id,
	 o.ship_date,
	 o.order_date,
	 p.Product_ID,
	 cd.Customer_ID,
	 g.geo_id,
	 Sales,
	 Quantity,
	 Discount,
	 Profit
from public.orders o
inner join dw.ship s on o.Ship_Mode = s.Ship_Mode
inner join dw.product p on o.Product_Name = p.Product_Name and o.SubCategory=p.SubCategory and o.Category=p.Category
inner join dw.customer cd on cd.Customer_Name=o.Customer_Name and cd.Segment=o.Segment
inner join dw.region g on o.Postal_Code = g.Postal_Code and g.Region=o.Region and g.Country=o.Country and g.City = o.City and o.State = g.State


--do you get 9994rows?
select count(*) from dw.sales sf
inner join dw.ship s on sf.ship_id=s.ship_id
inner join dw.region g on sf.geo_id=g.geo_id
inner join dw.product p on sf.prod_id=p.prod_id
inner join dw.customer cd on sf.cust_id=cd.cust_id;





