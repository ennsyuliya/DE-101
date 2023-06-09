# Домашнее задание курс DE-101 (модуль 2)

## Задачи

### 1. Вам необходимо установить Postgres базу данных к себе на компьютер. 

### 2. Установить клиент SQL для подключения базы данных.

### 3. Создайте 3 таблицы и загрузите данные из Superstore Excel файл в вашу базу данных. Сохраните в вашем GitHub скрипт загрузки данных и создания таблиц. Вы можете использовать готовый пример sql файлов.

Установила PostgreSQL. Затем DBeaver. Создала базу данных Postgres. 
Создала таблицы Orders, Returns и People с помощью скрипта [create_tables.sql](https://github.com/ennsyuliya/DE-101/blob/hw/module%2002/create_tables.sql "more info"). C помощью функцию [Импорт данных](https://github.com/ennsyuliya/DE-101/blob/hw/module%2002/import_orders.png "more info") и в DBeaver импортировала данные в таблицы Orders, Returns файлы [orders.csv](https://github.com/ennsyuliya/DE-101/blob/hw/module%2002/orders.csv "more info") и [returns.csv](https://github.com/ennsyuliya/DE-101/blob/hw/module%2002/returns.csv "more info") Таблицу People запонила сразу, так как таблица маленькая и можно воспользоваться  скриптом с insert что выложили на курсе.

### 4. Напишите запросы, чтобы ответить на вопросы из Модуля 01. Сохраните в вашем GitHub скрипт загрузки данных и создания таблиц.


--Sales and Profit 

    SELECT
    EXTRACT(YEAR FROM order_date) year_date,
    EXTRACT(MONTH FROM order_date) month_date,
    SUM(sales),
    SUM(profit)
    FROM orders o 
    GROUP BY EXTRACT(YEAR FROM order_date), EXTRACT(MONTH FROM 
    order_date)
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




## 5. Нарисовать модель данных
1. Логическая модель данных
![alt text](https://github.com/ennsyuliya/DE-101/blob/hw/module%2002/Логическая.png?raw=true)
    



2. Физическая модель

![alt text](https://github.com/ennsyuliya/DE-101/blob/hw/module%2002/Физическая.png?raw=true)

Создание и заполнение данными таблиц [DLL.sql](https://github.com/ennsyuliya/DE-101/blob/hw/module%2002/DDL.sql "more info")


## 6. Визуализация в облачном сервисе

 В качестве сервиса визуализации данных использовала GOOGLE LOOKER STUDIO. Ранее не имея опыта работы с такими инструментами. Подключилась к облачной БД и создала [дашборд](https://lookerstudio.google.com/reporting/d1b9f6b6-8ff0-4d87-8133-627659efaecf/page/ZxyTD "more info").
![alt text](https://github.com/ennsyuliya/DE-101/blob/hw/module%2002/Dashboard.png?raw=true)