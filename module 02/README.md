# Домашнее задание курс DE-101 (модуль 2)

## Задачи 2.1
1. Вам необходимо установить Postgres базу данных к себе на компьютер. 
2. Установить клиент SQL для подключения базы данных.
3. Создайте 3 таблицы и загрузите данные из Superstore Excel файл в вашу базу данных. Сохраните в вашем GitHub скрипт загрузки данных и создания таблиц. Вы можете использовать готовый пример sql файлов.
4. Напишите запросы, чтобы ответить на вопросы из Модуля 01. Сохраните в вашем GitHub скрипт загрузки данных и создания таблиц.


--Sales and Profit 
SELECT
	EXTRACT(YEAR FROM order_date) year_date,
	EXTRACT(MONTH FROM order_date) month_date,
	SUM(sales),
	SUM(profit)
FROM orders o 
GROUP BY EXTRACT(YEAR FROM order_date), EXTRACT(MONTH FROM order_date)
ORDER BY year_date, month_date ;


--Sales and Profit (Category)

SELECT DISTINCT 
	segment ,
	category ,
	SUM(sales) sales,
	SUM(profit) profit
FROM orders o
GROUP BY segment , category  
ORDER BY segment ; 


--KPI

SELECT round(sum(o.Profit)) as "Profit_$",
   round(sum(o.Sales)) as "Sales_$",
   round((sum(o.Sales)/sum(o.Quantity)),2) as "AVG_$",
   round((avg(o.Discount)),2)*100 as "Discont_%"
FROM orders o

--Returns by category
select EXTRACT(YEAR FROM order_date) year_date,
	EXTRACT(MONTH FROM order_date) month_date,
     Count(r.returned) as returned,
     category
from orders o join returns r on o.order_id=r.order_id  
GROUP BY EXTRACT(YEAR FROM order_date), EXTRACT(MONTH FROM order_date), category,returned
ORDER BY year_date, month_date;

--Sales and Profit (region)

SELECT DISTINCT 
	segment ,
	region  ,
	SUM(sales) sales,
	SUM(profit) profit
FROM orders o
GROUP BY segment , region  
ORDER BY segment ; 

## Задачи 2.2


## Нарисовать модель данных
1. Логистическая модель данных


![alt text](https://github.com/ennsyuliya/DE-101/blob/hw/module%2002/Логическая%20модель.png?raw=true)

2. Физическая модель

![alt text](https://github.com/ennsyuliya/DE-101/blob/hw/module%2002/Физическая%20модель.png?raw=true)
    




