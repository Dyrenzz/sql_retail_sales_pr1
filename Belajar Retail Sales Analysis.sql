-- 
-- Belajar SQL part 2
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales 
				(
					transactions_id INT PRIMARY KEY,
					sale_date DATE,
					sale_time TIME,
					customer_id INT,
					gender VARCHAR(15),
					age INT,
					category VARCHAR(15),
					quantity INT,
					price_per_unit INT,
					cogs FLOAT,
					total_sale INT
				);

SELECT * FROM retail_sales
LIMIT 10;


-- Check null value
SELECT * FROM retail_sales
WHERE 
	transactions_id IS NULL 
	OR 
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantity IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL

-- Clear null values
DELETE FROM retail_sales
WHERE 
	transactions_id IS NULL 
	OR 
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantity IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

-- 
SELECT COUNT(*) FROM retail_sales;
SELECT * FROM retail_sales;


-- --------------------------------
-- Data Exploration
-- --------------------------------

-- How many sales we have?
SELECT COUNT(*) AS total_sale FROM retail_sales;

-- How many uniuque customers we have ?
SELECT COUNT(DISTINCT customer_id) as total_customer FROM retail_sales;

-- Which categories did we have?
SELECT DISTINCT category FROM retail_sales;



-- ----------------------------------------------------
-- Data Analysis & Business Key Problems & Answers
-- ----------------------------------------------------

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- 
SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05';


SELECT TO_CHAR(sale_date, 'MM-AAAA-DD') FROM retail_sales;
SELECT TO_CHAR(sale_date, 'MM-YYY-DD') FROM retail_sales;
SELECT TO_CHAR(sale_date, 'MM-YYYY-DD') FROM retail_sales;


-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of Nov-2022
-- 
SELECT * FROM retail_sales
WHERE category = 'Clothing' 
	AND quantity >= 4
	AND TO_CHAR(sale_date, 'MM-YYYY') = '11-2022';


-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- 
SELECT 
	category, 
	COUNT(total_sale) as total_sale
FROM retail_sales
GROUP BY 1;

SELECT 
	category, 
	SUM(total_sale) as total_sale
FROM retail_sales
GROUP BY 1;


-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- 
SELECT 
	category,
	AVG(age) as avg_age
FROM retail_sales
GROUP BY 1;


-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- 
SELECT * FROM retail_sales
WHERE total_sale > 1000;


-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- 
SELECT 
	category,
	gender,
	COUNT(gender) as total_customer
FROM retail_sales
GROUP BY 1, 2;


-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- 

SELECT 
	TO_CHAR(sale_date, 'YYYY-MM') as date,
	AVG(total_sale)
FROM retail_sales
GROUP BY 1
ORDER BY 2


SELECT 
	year,
	month,
	avg_sale,
	rank
FROM (
SELECT
	EXTRACT(YEAR FROM sale_date) as year,
	EXTRACT(MONTH FROM sale_date) as month,
	AVG(total_sale) as avg_sale,N
	RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) 
				ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY 1,2
) /* as t1 */
WHERE rank = 1;


-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- 
SELECT 
	customer,
	total, 
	rank
FROM (
SELECT 
	customer_id as customer,
	SUM(total_sale) as total,
	RANK() OVER(ORDER BY SUM(total_sale) DESC) AS rank
FROM retail_sales
GROUP BY 1
)
WHERE rank <= 5;

-- Alternative
-- 
SELECT
	customer_id,
	SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;


-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- 
SELECT 
	category,
	COUNT(DISTINCT customer_id) as unique_customer
FROM retail_sales
GROUP BY category;


-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
-- 
SELECT  
	CASE 
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 1 AND 11 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END as shift,
	COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1

-- Alternative
-- 
WITH table1
AS
(
SELECT *, 
	CASE 
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 1 AND 11 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END as shift
FROM retail_sales
)
SELECT * FROM table1
-- 

WITH hourly_sale
AS
(
SELECT *, 
	CASE 
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 1 AND 11 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift


-- END PROJECT!