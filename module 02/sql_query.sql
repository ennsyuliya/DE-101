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




