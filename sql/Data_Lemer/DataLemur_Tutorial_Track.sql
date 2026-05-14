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









-- ==========================================
-- SECTION 3: ADVANCED QUERYING (Window Functions)
-- ==========================================