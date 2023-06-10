--creating a table
drop table if exists product;
CREATE TABLE products
(
  prod_id      int generated always as identity,
  product_id VARCHAR(20) NOT NULL,
  category VARCHAR(40) NOT NULL,
  subcategory VARCHAR(40) NOT NULL,
  product_name VARCHAR(250) NOT NULL,
  CONSTRAINT PK_products PRIMARY KEY ( prod_id )
);

TRUNCATE TABLE products;

INSERT INTO products
(product_id, product_name, category, subcategory)
SELECT DISTINCT
	product_id,
	product_name,
	category,
	subcategory
FROM
	orders;	

-- checking
SELECT 	*, 	count(*) over()
FROM  products
ORDER by product_id;




--creating a table
drop table if exists ship ;
CREATE TABLE ship
(
  ship_id SERIAL NOT NULL,
  ship_mode VARCHAR(14) NOT NULL,
  
  CONSTRAINT PK_ship PRIMARY KEY (ship_id)
);

-- deleting rows
TRUNCATE TABLE ship;

-- inserting data from orders
INSERT INTO ship (ship_mode)
SELECT distinct ship_mode
from orders;

-- checking
select 	* FROM  ship;


--CUSTOMER
drop table if exists customers;
CREATE TABLE customers
(
  cust_id   	   int generated always as identity,
  customer_id VARCHAR(10) NOT NULL,
  customer_name VARCHAR(30) NOT NULL,
  segment VARCHAR(15) NOT NULL,
  CONSTRAINT PK_customers PRIMARY KEY (cust_id)
);


-- deleting rows
TRUNCATE TABLE customers;

-- inserting data from orders
INSERT INTO customers (customer_id, customer_name, segment)
SELECT DISTINCT
	customer_id,	
	customer_name,
	segment
from orders;

-- checking
SELECT	*, 	count(*) over ()
FROM  customers
order by cust_id;



--GEOGRAPHY
drop table if exists region;
CREATE TABLE region (
 geo_id      int GENERATED ALWAYS AS IDENTITY,
 country VARCHAR(30) NOT NULL,
  city VARCHAR(30) NOT NULL,
  state VARCHAR(30) NOT NULL,
  postal_code VARCHAR(30) NOT NULL,
  region VARCHAR(10) NOT NULL,
  person VARCHAR(30),
  manager_name varchar(50) NOT NULL,
  CONSTRAINT PK_region PRIMARY KEY ( geo_id )

);


-- deleting rows
TRUNCATE TABLE region;

-- inserting data from orders and people tables
INSERT INTO region
	(country, city, state, postal_code, region, manager_name)
SELECT DISTINCT  
	o.country,
	o.city,
	o.state,
	o.postal_code,
	o.region,
	p.person
from public.orders AS o
JOIN
	public.people AS p
USING
	(region);

--data quality check
select * FROM  region
WHERE 
	country IS NULL OR 	city IS NULL OR postal_code IS NULL;

-- City Burlington, Vermont postal code is missing. There are 5 zip codes for this area, we'll use the zip code for the most populated area.
UPDATE
	region 
SET 
	postal_code = '05401'
WHERE 
	city = 'Burlington' 
	AND
	state = 'Vermont'
	AND
	postal_code IS NULL;	

--updating source data (otherwise, joins won't work as intended)
update orders  
SET postal_code = '05401'
WHERE 
	city = 'Burlington' and state = 'Vermont' and postal_code IS NULL;	

-- checking
select * FROM 
	region
ORDER BY city;





--CALENDAR use function instead 
-- examplehttps://tapoueh.org/blog/2017/06/postgresql-and-the-calendar/

--creating a table
drop table if exists calendar;
CREATE TABLE calendar
(
dateid integer  NOT NULL,
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
truncate table calendar;
--
insert into calendar
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


SELECT 	*  FROM  calendar;



--9994 row
select count(*)  from orders ;




DROP TABLE IF EXISTS sales;
CREATE TABLE sales
(
   row_id        INT NOT null,
   sales         NUMERIC(9,4) NOT NULL, 
   profit        NUMERIC(21,16) NOT null, 
   quantity      INT  NOT null,
   discount      NUMERIC(4,2) NOT null,
   ship_date     VARCHAR(10),
   order_id      VARCHAR(14) NOT null,
   postal_code   VARCHAR(30) ,
   cust_id       INT, 
   ship_id       INT, 
	prod_id       INT, 
	geo_id     INT,
 CONSTRAINT PK_sales PRIMARY KEY ( row_id )
 
);




INSERT INTO sales 
	(row_id, sales, profit, quantity, discount, ship_date,order_id, postal_code,cust_id, /*Returned,*/ ship_id, prod_id, geo_id  )
SELECT DISTINCT 
	o.row_id, 
	o.sales, 
	o.profit, 
	o.quantity, 
	o.discount, 
	o.ship_date, 
	o.order_id, 
	o.postal_code,
	c.cust_id, 
	--r.Returned, 
	s.ship_id, 
	p.prod_id, 
	g.geo_id
from orders AS o 
inner join ship s on o.ship_mode = s.ship_mode
inner join region g on o.postal_code = g.postal_code and g.country=o.country and g.city = o.city and o.state = g.state 
inner join products p on o.product_name = p.product_name  and o.subcategory=p.subcategory and o.category=p.category and o.product_id=p.product_id 
inner join customers c on c.customer_id=o.customer_id and c.customer_name=o.customer_name and o.segment=c.segment; 






-- checking 9994
select count(*) from sales sl
inner join ship s on sl.ship_id=s.ship_id
inner join region r on sl.geo_id=r.geo_id
inner join products p on sl.prod_id=p.prod_id
inner join customers cd on sl.cust_id=cd.cust_id;




