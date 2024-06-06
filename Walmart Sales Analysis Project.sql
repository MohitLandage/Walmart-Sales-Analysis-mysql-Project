
/**************************** MySQL Project -  Wallmart Sales Analysis ********************************/



CREATE DATABASE IF NOT EXISTS Wallmart_Sales_Analysis;
USE Wallmart_Sales_Analysis;

CREATE TABLE IF NOT EXISTS sales(
invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
branch VARCHAR(15) NOT NULL,
city VARCHAR(30) NOT NULL,
customer_type VARCHAR(30) NOT NULL,
gender VARCHAR(10) NOT NULL,
product_line VARCHAR(100) NOT NULL,
unit_price DECIMAL(10,2) NOT NULL,
quantity INT NOT NULL,
VAT FLOAT (6,4) NOT NULL,
total  DECIMAL(10,2) NOT NULL,
date DATETIME NOT NULL,
time TIMESTAMP,
payment VARCHAR(15) NOT NULL,
cogs DECIMAL(10,2) NOT NULL,
gross_margin_pct FLOAT(11,9),
gross_income DECIMAL (12,4) NOT NULL,
rating FLOAT(2,1)
);

SELECT * FROM sales;

-- alter table sales change "product line" product_line varchar(100);

/*   Data Wrangling */



/************************************   FEATRURE ENGINEERING  ***************************/


SELECT 	time,
			(CASE 
				WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
                WHEN time BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
                ELSE "Evening"
                END 
			) AS time_of_day
FROM sales;

-- Add new column "Time_of_day"

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);


-- ADDING / INSERTING THE DATA IN THE NEW COLUMN;

UPDATE sales
SET time_of_day = (CASE 
				WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
                WHEN time BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
                ELSE "Evening"
                END);
                
SELECT * FROM sales;
-- ------------------------------------------------------------------------------------------------

-- Adding new column "Day_name"

SELECT date,
		dayname(date)
FROM sales;
                
ALTER TABLE sales ADD COLUMN day_name varchar(20);


-- select date_format(date,"%Y/%m/%d") from sales;

-- ADDING / INSERTING THE DATA IN THE NEW COLUMN;
UPDATE sales
SET day_name = DAYNAME(date);

-- ------------------------------------------------------------------------------------------------

-- Adding new column "Month_name"

SELECT date, MONTHNAME(date) AS month_name
FROM SALES;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(20);

-- -- ADDING / INSERTING THE DATA IN THE NEW COLUMN "month_name";

UPDATE sales
SET month_name =  MONTHNAME(date) ;

SELECT * FROM sales;

-- ------------------------------------------------------------------------------------------------

/* EDA - Exploratory Data Analysis */

-- ------------------------------------------------------------------------------------------------
/************************ Generic Question *************************/

-- 1. How many unique cities does the data have?
SELECT DISTINCT city FROM sales;

-- 2. In which city is each branch?
SELECT * FROM sales;

-- In which city particular branch is located :
SELECT DISTINCT city , branch 
FROM sales;

-- ---------------------------------------------------------------------------------

/************************ Product Question *************************/

-- 1. How many unique product lines does the data have?

SELECT  DISTINCT product_line FROM sales;

SELECT COUNT(DISTINCT product_line) AS count_of_product_line FROM sales;  

-- 2. What is the most common payment method?
SELECT payment, COUNT(payment)
FROM sales
GROUP BY payment
ORDER BY COUNT(payment) DESC
LIMIT 1;

-- 3. What is the most selling product line?
SELECT product_line, COUNT(product_line) AS count_of_product_line FROM sales
GROUP BY product_line
ORDER BY count_of_product_line DESC
LIMIT 1
; 

-- 4. What is the total revenue by month?
SELECT SUM(total) as total_revenue , month_name FROM sales
GROUP BY month_name;

-- 5. What month had the largest COGS?
SELECT month_name, MAX(cogs) FROM sales
GROUP BY month_name;

-- 6. What product line had the largest revenue?
SELECT product_line , round(sum(total)) as revenue FROM sales 
GROUP BY product_line
ORDER BY revenue desc;

-- 7. Fetch each product line and add a column to those product line showing 
-- "Good", "Bad". Good if its greater than average sales

/******* Here we have to find the avg first and the asign value accordingly******/

SELECT ROUND(AVG(total),2) as avg_sales FROM sales;  -- avg_sale = 322.97 
SET @avg_sale = 322.97;

-- To add new column "sale_review"
ALTER TABLE sales ADD COLUMN sales_review VARCHAR(10);

-- To insert data  in column
UPDATE sales
SET sales_review = (CASE
						WHEN total > @avg_sale THEN "Good"
                        ELSE "Bad"
                        END);

SELECT * FROM sales;

-- 8. Which branch sold more products than average product sold?
SELECT branch, SUM(quantity) as qty_sold
FROM sales 
GROUP BY branch
HAVING SUM(quantity) > ( SELECT AVG(quantity) FROM sales)
ORDER BY qty_sold DESC;

-- 9. What is the most common product line by gender?
SELECT DISTINCT product_line, gender,count(gender) 
FROM sales
GROUP BY gender, product_line
ORDER BY count(gender) DESC;

-- 10. What is the city with the largest revenue?

SELECT city, max(total) as revenue FROM sales 
GROUP BY city
ORDER BY revenue desc;


-- 11. What is the average rating of each product line?

SELECT product_line, ROUND(AVG(rating),2) as avg_rating 
FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;

/******************************** Sales ************************************/

-- 1. Number of sales made in each time of the day per weekday
SELECT time_of_day, count(quantity) as  qty_sale
FROM sales
GROUP BY time_of_day
ORDER BY qty_sale DESC;

-- 2. Which of the customer types brings the most revenue?
SELECT customer_type, SUM(total) as total_revenue
FROM sales
GROUP BY customer_type ;

-- 3. Which city has the largest tax percent/ VAT (**Value Added Tax**)?

/*
SELECT city, sum(tax_5%) 
FROM sales 
GROUP BY city;
*/

-- 4. Which customer type pays the most in VAT?
/*
SELECT customer_type, sum(tax_5%) 
FROM sales 
GROUP BY customer_type;
*/


-- -----------------------------------------------------------------------------------
/********************************* Customers Questions *********************************/

-- 1. How many unique customer types does the data have?
SELECT COUNT(DISTINCT customer_type) 
FROM sales ;

-- 2. How many unique payment methods does the data have?

SELECT COUNT(DISTINCT payment )
FROM sales ;

-- 3. What is the most common customer type?
SELECT customer_type, COUNT(customer_type) AS count_customer_type
FROM sales
GROUP BY customer_type;

-- 4. Which customer type buys the most?
SELECT customer_type, ROUND(SUM(total),2) as total_sale
FROM sales
GROUP BY customer_type;

-- 5. What is the gender of most of the customers?
SELECT gender, count(*)
FROM sales
GROUP BY gender;

-- 6. What is the gender distribution per branch?
SELECT branch, gender, count(gender) 
FROM sales
GROUP BY branch, gender 
ORDER BY count(gender);

-- 7. Which time of the day do customers give most ratings?
SELECT time_of_day, rating, count(rating) as count_rating 
FROM sales
GROUP BY time_of_day,rating
ORDER BY rating DESC ;

-- 8. Which time of the day do customers give most ratings per branch?
SELECT time_of_day,branch , max(rating) as rating 
FROM sales
GROUP BY time_of_day,branch
;

-- 9. Which day fo the week has the best avg ratings?
SELECT * FROM SALES;

SELECT day_name , ROUND(avg(rating),2) as avg_rating 
FROM sales
GROUP BY day_name
ORDER BY avg_rating DESC;
-- 10. Which day of the week has the best average ratings per branch?

SELECT day_name , branch, ROUND(avg(rating),2) as avg_rating 
FROM sales
GROUP BY day_name, branch
ORDER BY avg_rating DESC;



				/*****************************************************  THE END  ***************************************************/