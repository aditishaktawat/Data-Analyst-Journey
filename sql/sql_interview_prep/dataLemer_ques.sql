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