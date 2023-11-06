SELECT * FROM walmart.`walmartsalesdata.csv`;

-- FEATURE ENGINEERING--
-- ADD TIME ZONES --
SELECT time,
CASE 
    WHEN time BETWEEN "0:0:0" AND "12:00:00" THEN "MORNING"
    WHEN time BETWEEN "12:00:00" AND "16:00:00" THEN "AFTERNOON"
    ELSE "EVENING"
END AS time_of_date
FROM walmart.`walmartsalesdata.csv`;

ALTER TABLE walmart.`walmartsalesdata.csv`
ADD COLUMN time_of_day VARCHAR(20); 

SET SQL_SAFE_UPDATES = 0;

UPDATE walmart.`walmartsalesdata.csv`
SET time_of_day = (
CASE 
    WHEN time BETWEEN "0:0:0" AND "12:00:00" THEN "MORNING"
    WHEN time BETWEEN "12:00:00" AND "16:00:00" THEN "AFTERNOON"
    ELSE "EVENING"
END );
 
 -- ADD DAY NAME --
SELECT date,dayname(date) FROM walmart.`walmartsalesdata.csv`;

ALTER TABLE walmart.`walmartsalesdata.csv`
ADD COLUMN day_name VARCHAR(10);

UPDATE walmart.`walmartsalesdata.csv`
SET day_name = dayname(date);

-- ADD MONTH NAME-- 
 
SELECT date,MONTHNAME(date) FROM walmart.`walmartsalesdata.csv`;

ALTER TABLE walmart.`walmartsalesdata.csv`
ADD COLUMN month_name VARCHAR(10);

UPDATE walmart.`walmartsalesdata.csv`
SET month_name= monthname(DATE);

-- How many unique cities does the data have? --

SELECT DISTINCT city FROM walmart.`walmartsalesdata.csv`;

-- In which city is each branch? --

SELECT DISTINCT city,Branch FROM walmart.`walmartsalesdata.csv`;

--  How many unique product lines does the data have? --

 SELECT DISTINCT product_line FROM walmart.`walmartsalesdata.csv`;
 
 -- What is the most common payment method? --
 
SELECT payment,count(payment) FROM  walmart.`walmartsalesdata.csv`
group by payment;
 
 -- What is the most selling product line? --
 
 SELECT product_line ,count(quantity) FROM walmart.`walmartsalesdata.csv`
 GROUP BY Product_line
 ORDER BY count(quantity) DESC;
 
 -- What is the total revenue by month? --
 
 SELECT 
 month_name as month,
 sum(Total) as revenue FROM walmart.`walmartsalesdata.csv` 
 GROUP BY month_name;
 
 -- What month had the largest COGS?--
 
 SELECT 
 month_name as month,
 sum(cogs) as total_cogs FROM walmart.`walmartsalesdata.csv` 
 GROUP BY month;
 
 -- What product line had the largest revenue? --
 
 SELECT 
 product_line as product,
 sum(Total) as revenue FROM walmart.`walmartsalesdata.csv` 
 GROUP BY Product
 ORDER BY revenue DESC;
 
 -- What is the city with the largest revenue? --
 
 SELECT 
 city ,
 sum(Total) as revenue FROM walmart.`walmartsalesdata.csv` 
 GROUP BY city
 ORDER BY revenue DESC;

-- What product line had the largest VAT? --

 SELECT 
 product_line as product,
 sum(gross_income) as revenue FROM walmart.`walmartsalesdata.csv` 
 GROUP BY product_line
 ORDER BY revenue DESC;

-- Which branch sold more products than average product sold --

 SELECT 
     Branch,
     sum(quantity) as qty
FROM walmart.`walmartsalesdata.csv`
GROUP BY Branch
HAVING SUM(Quantity) >= (SELECT AVG(quantity) FROM walmart.`walmartsalesdata.csv`);

-- What is the most common product line by gender? --

SELECT product_line , gender, count(gender) as total_cnt  FROM  walmart.`walmartsalesdata.csv`
GROUP BY product_line,gender
ORDER BY total_cnt DESC;

-- What is the average rating of each product line? --

SELECT product_line,avg(Rating) as rating FROM walmart.`walmartsalesdata.csv`
GROUP BY product_line;

-- Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales --

SELECT
rating,
CASE
     WHEN rating >= 8 THEN "GOOD"
     WHEN rating <=3  THEN "BAD"
     ELSE "AVG"
 END AS feedback
 FROM walmart.`walmartsalesdata.csv` ;
 
 ALTER TABLE walmart.`walmartsalesdata.csv`
 ADD COLUMN feedback VARCHAR(5);
 
 UPDATE walmart.`walmartsalesdata.csv`
 SET feedback = 
 (CASE
     WHEN rating >= 8 THEN "GOOD"
     WHEN rating <=3  THEN "BAD"
     ELSE "AVG"
 END);
 
 --  Number of sales made in each time of the day per weekday --
 
 SELECT time_of_day ,count(time_of_day) AS cnt FROM walmart.`walmartsalesdata.csv`
 WHERE day_name = "Sunday"
 GROUP BY time_of_day
 ORDER BY cnt DESC;
 
 -- Which of the customer types brings the most revenue? --

SELECT
	customer_type,
	SUM(total) AS total_revenue
FROM walmart.`walmartsalesdata.csv`
GROUP BY customer_type
ORDER BY total_revenue;

-- Which customer type pays the most in VAT? --
 
-- Which of the customer types brings the most revenue? -- 

SELECT Customer_type,count(*) as cnt FROM walmart.`walmartsalesdata.csv`
GROUP BY Customer_type;
 
-- How many unique customer types does the data have?

SELECT
	DISTINCT customer_type
FROM walmart.`walmartsalesdata.csv`;

-- How many unique payment methods does the data have? --

SELECT
	DISTINCT payment
FROM walmart.`walmartsalesdata.csv`;


-- What is the most common customer type? --

SELECT
	customer_type,
	count(*) as count
FROM walmart.`walmartsalesdata.csv`
GROUP BY customer_type
ORDER BY count DESC;

-- Which customer type buys the most? --

SELECT
	customer_type,
    COUNT(*)
FROM walmart.`walmartsalesdata.csv`
GROUP BY customer_type;


-- What is the gender of most of the customers? --

SELECT
	gender,
	COUNT(*) as gender_cnt
FROM walmart.`walmartsalesdata.csv`
GROUP BY gender
ORDER BY gender_cnt DESC;

-- What is the gender distribution per branch? --

SELECT
	gender,
	COUNT(*) as gender_cnt
FROM walmart.`walmartsalesdata.csv`
WHERE branch = "C"
GROUP BY gender
ORDER BY gender_cnt DESC;

-- Which time of the day do customers give most ratings? --

SELECT
	time_of_day,
	AVG(rating) AS avg_rating
FROM walmart.`walmartsalesdata.csv`
GROUP BY time_of_day
ORDER BY avg_rating DESC;

-- Which time of the day do customers give most ratings per branch? --

SELECT
	time_of_day,
	AVG(rating) AS avg_rating
FROM walmart.`walmartsalesdata.csv`
WHERE branch = "A"
GROUP BY time_of_day
ORDER BY avg_rating DESC;


-- Which day fo the week has the best avg ratings? --

SELECT
	day_name,
	AVG(rating) AS avg_rating
FROM walmart.`walmartsalesdata.csv`
GROUP BY day_name 
ORDER BY avg_rating DESC;

-- Which day of the week has the best average ratings per branch? --

SELECT 
	day_name,
	COUNT(day_name) total_sales
FROM walmart.`walmartsalesdata.csv`
WHERE branch = "C"
GROUP BY day_name
ORDER BY total_sales DESC;