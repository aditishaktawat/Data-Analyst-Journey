/* ==========================================================
PLATFORM: DataLemur (Hard)
QUESTION: Advertiser Status [facebook]
STATUS: REVISIT 
TIME : 15m min
========================================================== */

SELECT COALESCE(a.user_id, d.user_id) AS user_id,
CASE WHEN d.paid IS NULL THEN 'CHURN'
   WHEN a.status = 'CHURN' AND d.paid IS NOT NULL THEN 'RESURRECT'
   WHEN a.status IS NULL AND d.paid is not NULL THEN 'NEW'
  ELSE 'EXISTING'
  End AS new_status
FROM advertiser a
FULL OUTER JOIN daily_pay d ON a.user_id = d.user_id
ORDER BY user_id ;

/* BUISNESS INSIGHTS-
Categorizes users into distinct lifecycle stages to track user base health and revenue stability.
This allows growth and marketing teams to identify if revenue changes are driven by acquiring new users, retaining existing ones, losing customers, or successfully winning back old ones.
*/


--QUESTION: Y-on-Y Growth Rate [Wayfair]
--STATUS: Done 
--TIME : 10 min

WITH yearly_sales AS (
  SELECT 
    EXTRACT(YEAR FROM transaction_date) as year,
    product_id,
    spend as curr_year_spend,
    LAG(spend) OVER( PARTITION by product_id ORDER BY EXTRACT(YEAR FROM transaction_date))
      as prev_year_spend
  FROM user_transactions
)
SELECT year,
       product_id,
       curr_year_spend,
       prev_year_spend,
       Round((curr_year_spend - prev_year_spend)/prev_year_spend*100,2) as as yoy_rate
FROM yearly_sales

/*BUISNESS INSIGHTS-
Tracks Year-over-Year (YoY) revenue growth at the individual product level.
This helps leadership quickly identify which products are gaining market traction and which are shrinking,
 allowing them to shift marketing budgets toward winning items.*/



--QUESTION: Maximize Prime Item Inventory [AMAZON]
--STATUS: Revisit
--TIME : 25 min

WITH summary as(
  SELECT item_type, Count(*)as item_count, sum(square_footage) as tot_sqrft
  FROM inventory
  GROUP by item_type
),
prime_occupied as (
  SELECT item_type, 
    tot_sqrft,
    Floor(500000/ tot_sqrft)* tot_sqrft as prime_space,
    Floor(500000/ tot_sqrft) * item_count as prime_item_count
  FROM summary
  WHERE item_type = 'prime_eligible'
 )
 
SELECT item_type,
  CASE  
    WHEN item_type = 'prime_eligible'
      THEN (SELECT prime_item_count FROM prime_occupied)
    When item_type = 'not_prime'
      THEN FLOOR((500000 - (SELECT prime_space FROM prime_occupied)) / tot_sqrft) *item_count
  END as item_cnt  
FROM summary
ORDER BY item_type desc;

/* Buisness Insight -
Optimizes warehouse space by locking in our high-priority "Prime" stock first, then packing the leftovers with standard items so we aren’t paying for empty floor space.
*/

