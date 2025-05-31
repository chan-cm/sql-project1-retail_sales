-- sql retail sales Project
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);
SELECT * FROM retail_sales;

SELECT COUNT(*) FROM retail_sales;

SELECT COUNT (DISTINCT customer_id) FROM retail_sales;

SELECT DISTINCT category FROM retail_sales;
SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

DELETE FROM retail_sales 
WHERE 
	sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

-- Data Analysis:

-- 1. Write a SQL query to retrieve all columns for sales made on '2022-11-05


SELECT *FROM retail_sales WHERE sale_date = '2022-11-05';

-- 2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:

SELECT * FROM retail_sales 
WHERE 
	category = 'Clothing' 
	AND quantity >=4 
	AND TO_CHAR(sale_date, 'YYYY-MM')='2022-11';

-- 3. Write a SQL query to calculate the total sales (total_sale) for each category

SELECT 
category, SUM(total_sale) AS Net_sale,
COUNT(*) AS total_orders
FROM retail_sales 
GROUP BY category;

-- 4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT CATEGORY, ROUND(AVG(age),2) AS avg_age 
FROM retail_sales 
WHERE category='Beauty' 
GROUP BY CATEGORY;

-- 5. Write a SQL query to find all transactions where the total_sale is greater than 1000

SELECT * FROM retail_sales WHERE total_sale>1000;

-- 6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT 
category, gender,
COUNT(*) as total_no_transaction 
FROM retail_sales 
GROUP BY category, gender
ORDER BY category;

-- 7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:

SELECT 
sales_year,
sales_month,
avg_sale
FROM
(
SELECT 
	EXTRACT(YEAR FROM sale_date) as sales_year,
	EXTRACT(MONTH FROM sale_date) as sales_month,
	AVG(total_sale) as avg_sale,
	RANK() OVER (PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS rank 
FROM retail_sales
GROUP BY sales_year, sales_month) 
AS t1 WHERE RANK =1;

-- 8. Write a SQL query to find the top 5 customers based on the highest total sales 

SELECT customer_id, SUM(total_sale)AS highest_sale
FROM retail_sales
GROUP BY customer_id
ORDER BY highest_sa le DESC LIMIT 5;


-- 9. Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT category,
COUNT(DISTINCT customer_id) AS Unique_customers
FROM retail_sales
GROUP BY category;

-- 10.Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

WITH hourley_shift
AS
(SELECT *, 
CASE
	WHEN EXTRACT(HOUR FROM sale_time) <12 THEN 'Morning shift'
	WHEN EXTRACT (HOUR FROM sale_time) BETWEEN 12 AND 19 THEN 'Noon shift'
	ELSE
	'EVENING SHIFT'	
END as shift_slot
FROM retail_sales)

SELECT 
	shift_slot,
	COUNT(*) as total_orders
	FROM hourley_shift
	GROUP BY shift_slot 
	ORDER BY 2 DESC;

select * from retail_sales;

-- End of Project