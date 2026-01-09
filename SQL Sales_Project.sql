create database sales_db;
use sales_db;
SET SQL_SAFE_UPDATES = 0;

-- create table 
create table Retail_sales (
transactions_id int primary key,
sale_date date ,
sale_time time, 
customer_id int,
gender varchar(15),
age int,
category varchar(25),
quantiy int,
price_per_unit float,
cogs float,
total_sale float
);

-- Data Cleaning
  
select *,count(*) from Retail_sales
where
 age is null
or 
 price_per_unit is null
or 
cogs is null
or 
total_sale is null
group by transactions_id;


select count(*) FROM Retail_sales;

delete from retail_sales
where quantiy is null
or
price_per_unit is null
or 
cogs is null
or 
total_sale is null;

-- Data Exploration 

-- How many sales we have?
select count(*) from  retail_sales;

-- How many unique customers we have?

select count(distinct(customer_id)) from retail_sales;


-- Data Analysis & Business Key Problems & Answers.

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)


-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
 SELECT 
    *
FROM
    retail_sales
WHERE
    sale_date = '2022-11-05';
 
 
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022


SELECT 
    *
FROM
    retail_sales
WHERE
    category = 'Clothing'
        AND sale_date >= '2022-11-01'
        AND sale_date < '2022-12-01'
        AND quantiy >= 2;
        
        
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT 
    category,
    SUM(total_sale) AS total_sales,
    COUNT(*) AS total_order
FROM
    retail_sales
GROUP BY category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT 
    category, ROUND(AVG(age), 2) AS avg_age
FROM
    retail_sales
WHERE
    category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT 
    transactions_id, total_sale
FROM
    retail_sales
WHERE
    total_sale > 1000;


-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT 
    category,
    gender,
    COUNT(transactions_id) AS total_transactions
FROM
    retail_sales
GROUP BY category , gender
ORDER BY 1 ;


-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

SELECT 
     YEAR,
     MONTH,
     avg_sales 
		FROM(
   SELECT 
        YEAR(sale_date) AS year,
		MONTH(sale_date) AS month ,
	    ROUND(AVG(total_sale),2) as avg_sales,
        RANK() OVER(PARTITION BY YEAR(sale_date) 
        order by avg(total_sale) DESC ) as rnk
      FROM retail_sales
GROUP BY  YEAR , MONTH
)t
WHERE rnk = 1
ORDER BY YEAR ;


-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales.

SELECT 
    customer_id, SUM(total_sale) AS total_sale
FROM
    retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;


-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
 
 select category, count(distinct customer_id) as cnt_unique_customer
 from retail_sales
 group by category;


-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
with hourly_sales
as(
select *,
case
when hour(sale_time) <12 then 'Morning'
when hour(sale_time) between 12 and 17 then 'Afternoon'
else 
' Evening'
end as Shift
from retail_sales
 ) select customer_id,Shift,count(transactions_id) as total_order from hourly_sales
 group by customer_id, Shift
 order by customer_id ;

-- End Of Project