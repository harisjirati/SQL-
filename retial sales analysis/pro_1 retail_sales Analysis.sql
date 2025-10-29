-- Data Cleaning
select * from retail_analysis
where
  transactions_id is null
  or
  sale_date is null
  or
  sale_time is null
  or
  customer_id is null
  or
  gender is null
  or
  category is null
  or
  quantiy is null
  or
  price_per_unit is null
  or
  cogs is null
  or
  total_sale is null;

-- deleting null values
delete from retail_analysis
where
  transactions_id is null
  or
  sale_date is null
  or
  sale_time is null
  or
  customer_id is null
  or
  gender is null
  or
  category is null
  or
  quantiy is null
  or
  price_per_unit is null
  or
  cogs is null
  or
  total_sale is null;

select count(*) from retail_analysis;

-- Data Exploration
-- 1. Total no. of sales ?
select count(*) as total_sale from retail_analysis; -- ANS: 1997

-- 2. How many unique customers we have ?
select count(distinct customer_id) as total_sale from retail_analysis; -- ANS: 155

-- 3. no. of category
select distinct category from retail_analysis; -- ANS: 3
----------------------------------------------------------------------------------------------------------------------------------------

-- DATA ANALYSIS & Bussiness Problem
-- My Analysis & Findings

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'

select * from retail_analysis where sale_date = '2022-11-05';                        -- ANS: 11 sales

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022

select * from retail_analysis
 where category ='Clothing'
 and to_char (sale_date,'yyyy-mm')= '2022-11'
 and quantiy >= 4;                                                                  -- ANS: 17

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

select 
 category,
 sum(total_sale) as net_sale,
 count(*) as total_orders
 from retail_analysis
 group by 1;                                                                      -- ANS: Electronic:313810
																					--		Clothing  :311070
																					--		Beauty    :286840
																					
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

select 
 round(avg (age),2) as avg_age
from retail_analysis
 where category ='Beauty';														  -- ANS: age= 40.42
 
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

select * from retail_analysis where total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

select
 category,gender,
 count(*) as total_trans
from retail_analysis 
 group by category,gender order by 1;
 
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

SELECT 
       year,
       month,
    avg_sale
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_analysis
GROUP BY 1, 2
) as t1
WHERE rank = 1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT 
    customer_id,
    SUM(total_sale) as total_sales
FROM retail_analysis
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

select 
 category, 
 count(distinct customer_id) as unique_id 
from retail_analysis 
 group by category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_analysis
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift;
 