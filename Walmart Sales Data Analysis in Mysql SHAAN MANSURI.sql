CREATE DATABASE IF NOT EXISTS walmartSales;

use walmartSales;

CREATE TABLE IF NOT EXISTS sales (
    invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10 , 2 ) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6 , 4 ) NOT NULL,
    total DECIMAL(12 , 4 ) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10 , 2 ) NOT NULL,
    gross_margin_pct FLOAT(11 , 9 ),
    gross_income DECIMAL(12 , 4 ),
    rating FLOAT(2 , 1 )
);


-- -------------------------------- Feature Engineering:------------------------------------------ 
-- ------------------------------------------------------------------------------------------------  
SELECT
	time
FROM sales;

-- Add the time_of_day column---------------------------------------------

SELECT
	time,
	(CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END) AS time_of_day
FROM sales;

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);
 
-- update sales -----------------------------------------


UPDATE sales 
SET 
    time_of_day = (CASE
        WHEN `time` BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN `time` BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END);
    
    
-- Add day_name column------------------------------

select date,
dayname(date)
from sales;


alter table sales add column day_name varchar(10);

UPDATE sales
SET day_name = DAYNAME(date);





-- Add month_name column --------------------

SELECT
	date,
	MONTHNAME(date)
FROM sales;

alter table sales add column month_name varchar(10);

update sales
set month_name = monthname(date);


--  ---------------------------Generic Question -----------------------------


-- ----1. How many unique cities does the data have?---

select distinct city
from sales;

-- 2   which city is each branch? ---

select distinct city ,branch
from sales;

-- ------------------------------------Product----------------------------------------


-- 1 How many unique product lines does the data have? ----

select  count(distinct product_line) from sales;


--  2  What is the most common payment method? ----------

select payment, count(*) as total_count
from sales
group by payment
order by total_count desc;


-- 3 What is the most selling product line?-----

select product_line, count(product_line) as sellingproduct
from sales
group by product_line
order by  sellingproduct desc;



-- 4 What is the total revenue by month? ------

select
   month_name as month,
   sum(total) as total_revenue
from sales
group by month_name
order by total_revenue desc;


-- 5 What month had the largest COGS?----------
SELECT 
    month_name as month,
    sum(cogs) as cogs
from sales
group by month_name
order by cogs desc;

-- 6  What product line had the largest revenue?-----------------

select
     product_line,
     sum(total) as total_revenue
from sales
group by product_line
order by total_revenue desc;

-- 7  What is the city with the largest revenue?
SELECT
	branch,
	city,
	SUM(total) AS total_revenue
FROM sales
GROUP BY city, branch 
ORDER BY total_revenue desc;

-- 8 What product line had the largest tax_pct?
select
     product_line,
     AVG(tax_pct) as avg_tax
from sales
group by product_line
order by avg_tax ;
	

-- 10  Which branch sold more products than average product sold?

SELECT 
    branch, SUM(quantity) AS qty
FROM
    sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT 
        AVG(quantity)
    FROM
        sales);

-- 11  What is the most common product line by gender--

SELECT 
    gender, product_line, COUNT(gender) AS total_cnt
FROM
    sales
GROUP BY gender , product_line
ORDER BY total_cnt DESC;

-- 12  What is the average rating of each product line

SELECT 
    ROUND(AVG(rating), 2) AS ave_rating, product_line
FROM
    sales
GROUP BY product_line
ORDER BY ave_rating DESC;


-- ------------------------ Sales -----------------------------------------

 -- 1 Number of sales made in each time of the day per weekday ---------------------
 
 select
 time_of_day,
 count(*) as total_sales
 from sales
 group by time_of_day
 order by total_sales desc;
 
 
 
 -- 2  Which of the customer types brings the most revenue?
 
 SELECT 
    customer_type, SUM(total) AS total_revenue
FROM
    sales
GROUP BY customer_type
ORDER BY total_revenue;


-- 3  Which city has the largest tax/VAT percent?

SELECT 
    city, ROUND(AVG(tax_pct), 2) AS avg_tax_pct
FROM
    sales
GROUP BY city
ORDER BY avg_tax_pct DESC;

-- 4  Which customer type pays the most in VAT?
SELECT 
    customer_type, AVG(tax_pct) AS total_tax
FROM
    sales
GROUP BY customer_type
ORDER BY total_tax;


-- ----------------------Customer--------------------------------------------

--   1   How many unique customer types does the data have?------------------


SELECT DISTINCT
    customer_type
FROM
    sales;

 --   2   ------------
 -- How many unique payment methods does the data have?

SELECT DISTINCT
    payment
FROM
    sales;
 

-- 3 What is the most common customer_type?-- 

SELECT
	customer_type,
	count(*) as count
FROM sales
GROUP BY customer_type
ORDER BY count DESC;


 -- 4  Which customer type buys the most----
 
 
 SELECT 
    customer_type, COUNT(*) as total_count
FROM
    sales
GROUP BY customer_type;




--  5   What is the gender of most of the customers
SELECT 
    gender, COUNT(*) AS gender_count
FROM
    sales
GROUP BY gender
ORDER BY gender_count DESC;


-- 6 What is the gender distribution per branch?

SELECT 
    gender, COUNT(*) AS gender_cnt
FROM
    sales
WHERE
    branch = 'B'
GROUP BY gender
ORDER BY gender_cnt DESC;


--   7 Which time of the day do customers give most ratings? -----

SELECT 
    time_of_day, AVG(rating) AS avg_rating
FROM
    sales
GROUP BY time_of_day
ORDER BY avg_rating DESC;



-- 8  Which time of the day do customers give most ratings per branch?

SELECT 
    time_of_day, AVG(rating) AS avg_rating
FROM
    sales
WHERE
    branch = 'A'
GROUP BY time_of_day
ORDER BY avg_rating DESC;



-- 9  Which day fo the week has the best avg ratings?

SELECT 
    day_name, AVG(rating) AS avg_rating
FROM
    sales
GROUP BY day_name
ORDER BY avg_rating DESC;



-- 10  Which day of the week has the best average ratings per branch?
SELECT 
    day_name, COUNT(day_name) total_sales
FROM
    sales
WHERE
    branch = 'C'
GROUP BY day_name
ORDER BY total_sales DESC;




