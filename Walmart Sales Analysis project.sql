
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
unit_place DECIMAL(10,2) NOT NULL,
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



