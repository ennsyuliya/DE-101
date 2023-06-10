-- create table orders


DROP TABLE IF EXISTS orders;
CREATE TABLE orders(  
   row_id        INT NOT NULL  PRIMARY KEY
  ,order_id      VARCHAR(14) NOT NULL
  ,order_date   VARCHAR(14) NOT NULL
  ,ship_date     VARCHAR(10) 
  ,ship_mode     VARCHAR(14) NOT NULL
  ,customer_id   VARCHAR(10)  NOT NULL
  ,customer_name VARCHAR(30) NOT NULL
  ,segment       VARCHAR(15) NOT NULL
  ,country       VARCHAR(30) NOT NULL
  ,city          VARCHAR(30) NOT NULL
  ,state         VARCHAR(30) NOT NULL
  ,postal_code   VARCHAR(30) 
  ,region        VARCHAR(10) NOT NULL
  ,product_id    VARCHAR(20) NOT null 
  ,category      VARCHAR(20) NOT NULL
  ,subcategory   VARCHAR(20) NOT NULL
  ,product_name  VARCHAR(200) NOT NULL
  ,sales         NUMERIC(9,4) NOT NULL
  ,quantity      INT  NOT NULL
  ,discount      NUMERIC(4,2) NOT NULL
  ,profit        NUMERIC(21,16) NOT null
   
);

-- create table people


DROP TABLE IF EXISTS people;
CREATE TABLE people(
   person VARCHAR(30) PRIMARY KEY
  ,region VARCHAR(10) 
);

INSERT INTO people(Person,Region) VALUES ('Anna Andreadi','West');
INSERT INTO people(Person,Region) VALUES ('Chuck Magee','East');
INSERT INTO people(Person,Region) VALUES ('Kelly Williams','Central');
INSERT INTO people(Person,Region) VALUES ('Cassandra Brandow','South');


-- create table returns

DROP TABLE IF EXISTS returns;

CREATE TABLE returns(
   Returned VARCHAR(5) 
   ,Order_ID VARCHAR(14)  PRIMARY KEY

);
