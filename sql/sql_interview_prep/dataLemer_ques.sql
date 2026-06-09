/* ==========================================================
PLATFORM: DataLemur (Easy)
QUESTION: Data Science Skills [LinkedIn]
STATUS: REVISIT (Needed hint for HAVING COUNT logic)
========================================================== */

SELECT candidate_id 
FROM candidates
WHERE skill IN ('Python', 'Tableau', 'PostgreSQL')
GROUP BY candidate_id
HAVING COUNT(skill) = 3
ORDER BY candidate_id;

-- QUESTION: Page With No Likes [Facebook]
-- STATUS: DONE  
-- 13 min
SELECT p.page_id
FROM pages as p 
LEFT JOIN page_likes as pl 
 ON p.page_id = pl.page_id
GROUP BY p.page_id HAVING count(user_id) = 0
ORDER BY p.page_id ASC;

-- Alternative with faster processing
SELECT p.page_id
FROM pages as p 
LEFT JOIN page_likes as pl    --left join will automatically eliminate the pages with likes
  ON p.page_id = pl.page_id
WHERE pl.page_id IS NULL
ORDER BY p.page_id ASC;

/* INSIGHTS: 
This helps to identify the dead pages and eliminate them.
*/

-- QUESTION: Unfinished Parts [Tesla]
-- STATUS: DONE  
-- 3 min

SELECT part, assembly_step
FROM parts_assembly
WHERE finish_date IS NULL;

/* BUISNESS INSIGHTS:
It helps in identifying the parts which are lagging behind and need a special attention to find if there's an internal issue. 
*/



-- QUESTION: Laptop vs. Mobile Viewership [NY TIMES]
-- STATUS: REVISIT (Needed hint for CASE SUM logic)  
-- 8 min

SELECT 
SUM(CASE WHEN device_type = 'laptop' THEN 1 ELSE 0 
    END) AS laptop_views,
SUM(CASE WHEN device_type IN ('phone', 'tablet') THEN 1 ELSE 0
   END) AS mobile_views
FROM viewership;

/* BUISNESS INSIGHTS:
"Analyzed device segmentation to drive ad-spend efficiency.
Knowing the exact mobile vs. laptop split allows the business to adjust Cost-Per-Click (CPC) bids for premium ad slots based on actual user traffic.
*/


-- QUESTION: Well Paid Employees [FAANG]
-- STATUS: REVISIT   
-- 5 min

SELECT e1.employee_id, e1.name AS employee_name
FROM employee e1
JOIN employee e2 ON e1.manager_id = e2.employee_id
WHERE e1.salary > e2.salary

/* BUISNESS INSIGHTS:
High-Impact Performers: These are the company's 'rainmakers.'
Whether through technical expertise or high sales commissions, their pay reflects their direct impact on revenue.
It’s a clear signal of who the department's most critical assets are.
*/

-- QUESTION: Second Day Confirmation [TikTok SQL]
-- STATUS: REVISIT   
-- 10 min

SELECT DISTINCT(e.user_id)
FROM emails e
JOIN texts t ON e.email_id = t.email_id
WHERE t.signup_action = 'Confirmed' 
  AND t.action_date = e.signup_date + INTERVAL '1 DAY';   --Interval func used to find 2nd day login

/* BUISNESS INSIGHTS:
A consistent 24-hour lag in the action_date strongly suggests our confirmation emails are being caught in spam filters,
or our SMS vendor is batching texts at the end of the day.
Engineering must audit deliverability rates to ensure real-time account activation.
*/


-- QUESTION: Average Review Ratings [AMAZON]
-- STATUS: DONE
-- 5 min

SELECT EXTRACT(MONTH FROM submit_date) AS mth,
 product_id, 
 ROUND(AVG(stars),2) AS avg_stars
FROM reviews
GROUP BY EXTRACT(MONTH FROM submit_date),  --cant use alias mth as Group by clause work before SELECT clause
product_id
ORDER BY mth, product_id;

/* BUISNESS INSIGHTS:
Monthly Sentiment Trends: By tracking average stars month-over-month, we can identify 'Product Fatigue.'
If a top-rated product's score drops during a high-volume month like December,
it suggests the logistics or packaging couldn't handle the scale, leading to customer frustration.
*/


-- QUESTION: Teams Power Users [MICROSOFT]
-- STATUS: REVISIT
-- 10 min

SELECT sender_id, COUNT(message_id) as message_count
FROM messages
WHERE sent_date >= '08/01/2022' AND sent_date < '08/03/2022' --less time complexity,performs Index Range Scan
 --EXTRACT(MONTH FROM sent_date)= '8' AND EXTRACT(YEAR FROM sent_date)= '2022' -- performs Full Table Scan
GROUP BY sender_id
ORDER BY message_count DESC
LIMIT 2;

/*
Power User Engagement:
This identifies our 'Power Users'—the top 0.1% of the population driving platform stickiness.
By identifying who sends the most messages, we can study their behavior to build 'Templates' or 'Quick Replies' that help average users reach the same level of engagement.
If these top users suddenly stop messaging, it’s an early warning for Churn among our most valuable cohort.
*/


-- QUESTION: Final Account Balance [PAYPAL]
-- STATUS: REVISIT
-- 8 min
SELECT account_id,
SUM(
CASE WHEN transaction_type = 'Deposit' THEN amount
ELSE -amount
End) AS final_balance
FROM transactions
Group BY account_Id;



-- QUESTION: IBM db2 Product Analytics [IBM]
-- STATUS: REVISIT
-- 18 min

WITH employee_queries AS (

SELECT e.employee_id, COALESCE(COUNT(DISTINCT (q.query_id)),0)as unique_queries
FROM employees as e 
LEFT JOIN queries as q ON e.employee_id = q.employee_id 
 AND q.query_starttime >= '07/01/2023 00:00:00' 
 AND q.query_starttime < '10/01/2023 00:00:00'
GROUP BY e.employee_id
)

SELECT unique_queries, Count(employee_id) AS emp_count
FROM employee_queries
GROUP BY unique_queries
Order By unique_queries;

/*
BUISNESS INSIGHTS:
This query measures tool adoption and identifies power users:
-The "0 Queries" Bucket: If this number is massive, it means we have an adoption problem.
We are paying for a tool (or paying employees) and it is sitting untouched.
It signals a need for better onboarding or training.

-The "Power Users" Bucket: If a small group of employees runs 50+ queries while everyone else runs 2,
those are our "power users."
The business can talk to them to understand what they are finding so valuable, and use those learnings to train the rest of the team.
*/


-- QUESTION: Pharmacy Analytics (Part 1) [CVS HEALTH]
-- STATUS: DONE
-- 8 min
SELECT drug,
(total_sales - cogs) as total_profit
FROM pharmacy_sales
order by total_profit desc
limit 3;

/* BUISNESS INSIGHTS:
Used to find the top 3 most profitable drugs we are selling.
*/


-- QUESTION: Pharmacy Analytics (Part 2) [CVS HEALTH]
-- STATUS: REVISIT
-- 10 min

/*1.Find total loss
 2. check condition for loss - cost > selling price
 3. Group by manufacturer
*/
SELECT manufacturer,
COUNT(drug) as drug_count,
SUM(cogs-total_sales) as total_loss
FROM pharmacy_sales
WHERE cogs>total_sales 
GROUP BY manufacturer
ORDER by total_loss desc;

/*  BUISNESS INSIGHTS- 
Identifies the manufacturers driving the highest financial losses and the count of unprofitable drugs they produce.
This data is critical for prioritizing reviews of pricing strategies, manufacturing costs (COGS), and potential supply chain inefficiencies.
*/

-- QUESTION: Cards Issued Difference [JP MORGAN]
-- STATUS: DONE
-- 4 min

SELECT card_name,
(MAX(issued_amount) - MIN(issued_amount)) as difference
FROM monthly_cards_issued
GROUP BY card_name
ORDER BY difference DESC;

/* BUISNESS INSIGHT -
Identifies which credit cards have the most unstable issuance rates by finding the difference between their best and worst performing months.
This helps marketing teams identify which credit cards are highly seasonal or driven by short-term promotional campaigns (high variance)
versus those with steady, organic growth (low variance).
*/

--SQL Math Practice Exercise: Big-Mover Months
--STATUS: REVISIT
-- 15 min
SELECT ticker,
COUNT(date) as count
FROM stock_prices
WHERE (close - open)/open > 0.10 OR (close - open)/open <-0.10
GROUP BY ticker
ORDER BY count desc;

/* BUISNESS INSIGHT -
Identifies the most volatile stocks by counting the frequency of extreme daily price swings (greater than 10%).
This is critical for risk management, allowing analysts to flag high-risk assets within a portfolio and which companies have the most unstable stock prices.
*/

-- Cities With Completed Trades [ Robinhood ]
--STATUS : DONE
-- 10 min

SELECT u.city,
  COUNT(t.order_id) as total_orders
FROM trades t
JOIN users u ON t.user_id = u.user_id 
WHERE status = 'Completed'
GROUP BY city 
Order BY total_orders DESC
LIMIT 3;

/* BUISNESS INSIGHT -
Identifies the top 3 cities with the highest transaction volume.
Helps marketing and operations teams target and allocate resources to our highest-demand urban markets.
*/
 