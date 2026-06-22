-- ==========================================
-- SECTION 1: EASY SYNTAX WARM-UPS
-- ==========================================

-- WHERE clause
SELECT user_id,stars
FROM reviews
WHERE stars = 3;

--AND Operator
SELECT * 
FROM reviews
WHERE review_id > 2000 AND review_id <6000
AND stars >4 
AND user_id != 142;

--SQL WHERE AND OR
SELECT * 
FROM reviews
WHERE stars >2 AND stars <= 4
AND (user_id = 123 OR user_id=265 OR user_id=362);

--BETWEEN Clause
SELECT manufacturer, drug, 	units_sold
FROM pharmacy_sales
WHERE units_sold BETWEEN 100000 AND 105000
 AND manufacturer IN ('Biogen', 'AbbVie', 'Eli Lilly');

--SQL IN 
SELECT manufacturer, drug, units_sold
FROM pharmacy_sales
WHERE manufacturer IN ('Roche', 'Bayer', 'AstraZeneca')
AND units_sold NOT BETWEEN 55000 AND 550000;

--LIKE 
SELECT * FROM customers
WHERE customer_name LIKE 'F% %ck'
LIMIT 20;

SELECT * 
FROM customers
WHERE customer_name LIKE '_ee%';

--Filtering Review
SELECT * 
FROM customers 
WHERE age BETWEEN 18 AND 22 
AND state IN ('Victoria', 'Tasmania', 'Queensland')
AND gender != 'n/a'
AND (customer_name LIKE 'A%' OR customer_name LIKE 'B%');
--use () to club it as a single query wrt to other queries

--ORDER BY
SELECT * 
FROM callers
ORDER BY call_received DESC
OFFSET 10  --leave initial 10 
LIMIT 5;

-- ==========================================
-- SECTION 2: INTERMEDIATE LOGIC (CTEs & Joins)
-- ==========================================

-- AGGREGATE FUNCTIONS - SUM, COUNT, MIN, MAX, AVG
SELECT COUNT(*),SUM(total_sales)
FROM pharmacy_sales
WHERE manufacturer = 'Pfizer';

SELECT avg(open)
FROM stock_prices
WHERE ticker = 'GOOG';

SELECT MIN(open)
FROM stock_prices
WHERE ticker = 'MSFT';

SELECT MAX(open)
FROM stock_prices
WHERE ticker ='NFLX';

--GROUO BY Clause
SELECT ticker, MIN(open)
FROM stock_prices
GROUP BY ticker
order by min desc;

SELECT skill,count(candidate_id)
FROM candidates
GROUP by skill
order by count desc;

--HAVING Clause
SELECT ticker,min(open) as min_open
FROM stock_prices
Group by ticker having min(open) > 100
order by min_open desc;

SELECT candidate_id
FROM candidates
GROUP BY candidate_id HAVING Count(skill) > 2 ;

--DISTINCT Clause
SELECT category, Count(DISTINCT(product)) as count
FROM product_spend
Group by category;

--MATH Functions
SELECT drug,
  CEIL(total_sales / units_sold) as unit_cost
FROM pharmacy_sales
WHERE manufacturer ='Merck'
ORDER BY unit_cost;

--CASE 
SELECT actor, character, platform, avg_likes,
  CASE WHEN avg_likes >= 15000 THEN 'Super Likes'
      WHEN avg_likes >= 5000 AND avg_likes <= 14999 THEN 'Good Likes'
      ELSE 'Low Likes'
    END likes_category
FROM marvel_avengers 
ORDER BY avg_likes DESC;

--JOIN
SELECT * 
FROM trades 
JOIN users ON trades.user_id = users.user_id;



-- ==========================================
-- SECTION 3: ADVANCED QUERYING (Window Functions)
-- ==========================================

--CTE
With ranked_artist as (
  SELECT artist_name,
      genre, concert_revenue, number_of_members, 
      concert_revenue / number_of_members as revenue_per_band_member,
      Rank() OVER( PARTITION BY genre ORDER BY concert_revenue / number_of_members DESC)
       as rnk
  FROM concerts
)

SELECT artist_name,
       concert_revenue,genre, number_of_members, revenue_per_band_member
FROM ranked_artist
WHERE rnk = 1 
ORDER BY revenue_per_band_member DESC;


--SELF JOIN
SELECT e1.employee_id, e1.name AS employee_name
FROM employee e1
JOIN employee e2 ON e1.manager_id = e2.employee_id
WHERE e1.salary > e2.salary;