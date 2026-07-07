/* ==========================================================
PLATFORM: DataLemur (Medium)
QUESTION: Card Launch Success [JP Morgan ]
STATUS: REVISIT 
TIME : 15m min
========================================================== */
with issued_amt as (
SELECT card_name, issued_amount,
 Concat(issue_month,issue_year) as issue_date,
 min(Concat(issue_month,issue_year))OVER( PARTITION BY card_name) as launch_date
 FROM monthly_cards_issued
 )
 
SELECT card_name, issued_amount
  FROM issued_amt
  WHERE issue_date = launch_date
  order BY 2 DESC;

/*BUISNESS INSIGHT -
Measures Launch Performance by ranking the volume of cards issued in each product's very first month.
This helps product and marketing teams evaluate the effectiveness of initial rollout campaigns, gauge immediate market interest, and identify which card types generated the highest "day-one" customer adoption.
*/


--QUES: Top 5 Artists [SPOTIFY]
-- STATUS: REVISIT
-- TIME: 20 min

WITH top_10 as (
  SELECT a.artist_name,
    Dense_rank() OVER( order by COUNT(g.song_id) desc) as artist_rank
  FROM artists a JOIN songs s ON a.artist_id = s.artist_id
    JOIN global_song_rank g ON s.song_id = g.song_id
  WHERE g.rank <= 10
   GROUP BY a.artist_name    --need to aggregate the data into totals
  )

SELECT artist_name, artist_rank
FROM top_10
WHERE artist_rank <6;

/*BUISNESS INSIGHT -
Identify who are the star performers who who dominate the global top 10 charts.
This data can be leveraged by marketing teams for high-profile promotional campaigns and advertisements to attract new users by showcasing our premium content catalog.
*/ 


--QUES: Histogram of Users and Purchases [Walmart] 
-- STATUS: REVISIT
-- TIME: 20 min
 With ranked_transaction as (
SELECT product_id, user_id, transaction_date,
rank() OVER (PARTITION by user_id order by transaction_date desc) as rnk
FROM user_transactions
)

SELECT count(product_id) as purchase_count, user_id,
  transaction_date
FROM ranked_transaction
WHERE rnk = 1
GROUP by user_id, transaction_date 
ORDER by transaction_date 

/*BUISNESS INSIGHT -
Analyzes basket size and purchasing volume during a user's most recent checkout event.
This helps identify whether retaining users are increasing their order sizes over time or if their final interactions show a decline in cart value.
*/


--QUES: Odd and Even Measurements [GOOGLE] 
-- STATUS: REVISIT
-- TIME: 10 min

-- 1. Ordering and partitioning
-- 2. Filtering and summation
With rank as
(
SELECT CAST(measurement_time as DATE) as measurement_day,
  measurement_value,
  Row_Number() OVER( PARTITION BY CAST(measurement_time as DATE) 
                ORDER BY measurement_time) as meas_rnk 
FROM measurements
) 

SELECT measurement_day,
SUM(CASE WHEN meas_rnk % 2 = 0 THEN measurement_value
 ELSE NULL
 END) as even_sum,
SUM(CASE WHEN meas_rnk % 2 != 0 THEN measurement_value
 ELSE NULL
 END) as odd_sum
FROM rank
GROUP BY measurement_day
ORDER by measurement_day;

/*BUISNESS INSIGHT -
Groups time-series sensor data into intervals (odd vs. even) to audit data transmission accuracy.
Comparing these two sums helps data engineers spot systemic patterns and anomalies between consecutive readings.
*/


--QUES: User's Third Transaction [UBER] 
-- STATUS: DONE
-- TIME: 3.5 min

with trans_rnk as (
SELECT user_id,
  spend, transaction_date,
  Row_Number() OVER ( PARTITION BY user_id Order By transaction_date )
    as rnk
FROM transactions
)

Select user_id, spend, transaction_date
FROM trans_rnk 
where rnk = 3;

/* BUISNESS INSIGHTS -
Identifies the exact moment a customer completes their 3rd purchase—the critical milestone for customer retention. 
This data feeds directly into our CRM, allowing marketing to automatically reward our newly converted "loyal" customers with targeted retention campaigns.
*/


--QUES: Second Highest Salary  [FAANG] 
-- STATUS: DONE
-- TIME: 4 min

with salary_rnk as (
SELECT salary,
  row_number() Over( ORDER by salary desc) 
    as rnk
FROM employee
)
SELECT salary
from salary_rnk 
where rnk = 2;

/* BUISNESS INSIGHTS -
Isolates the second-highest salary bracket. HR and Finance teams often use this to evaluate executive pay structures 
while excluding the top outlier (typically the CEO or Founder) to ensure equitable compensation among senior leadership.
*/

--QUES: Sending vs. Opening Snaps [SNAPCHAT] 
-- STATUS: REVISIT
-- TIME: 10 min
WITh activity_breakdowns as (
SELECT b.age_bucket,
  sum(time_spent) as total_time,
  SUM( CASE WHEN activity_type = 'send' THEN time_spent ELSE 0 END) as send_time,
  SUM( CASE WHEN activity_type = 'open' THEN time_spent ELSE 0 END) as open_time
FROM activities a 
JOIN age_breakdown b ON a.user_id = b.user_id
WHERE a.activity_type IN ('send', 'open')
group by b.age_bucket
)

SELECT age_bucket,
  ROUND( 100.0 * send_time / total_time,2) as send_perc,
  ROUND( 100.0 * open_time / total_time,2) as open_perc
FROM activity_breakdowns;

/* BUISNESS INSIGHT -
Breaks down platform engagement dynamics (sending vs. opening) across different age demographics. 
The Product Team uses this breakdown to identify "lurker" age groups (high open rates, low send rates) and target them with UX features—like prominent
 "Quick Reply" buttons or interactive filters—to seamlessly convert passive consumers into active content creators.
*/

--QUES: Tweets' Rolling Averages [Twitter]
-- STATUS: DONE
-- TIME: 5 min

SELECT 
  user_id,
  tweet_date,
  ROUND(AVG(tweet_count) OVER (
    PARTITION BY user_id
    ORDER BY tweet_date 
    ROWS BETWEEN 2 PRECEDING AND CURRENT ROW),2) as rolling_avg_3d
FROM tweets;

/* BUISNESS INSIGHT -
Calculates a 3-day rolling average of user tweet volume to track real-time engagement momentum.
This dual-purpose metric allows the Growth team to trigger targeted subscription offers when a user's activity naturally peaks, 
while simultaneously helping Trust & Safety instantly flag unnatural spikes that indicate bot or spam behavior.
*/

--QUES: Highest-Grossing Items [Amazon] 
-- STATUS: 
-- TIME:

With rnk_products as (
SELECT category,
  product,
  SUM(spend) as total_spend,
  ROW_NUMBER () OVER (
  PARTITION BY category ORDER BY SUM(spend) DESC) as rnk
FROM product_spend
WHERE  transaction_date >= '01/01/2022' AND transaction_date < '01/01/2023'
GROUP BY category, product
)

SELECT category,
  product,
  total_spend
FROM rnk_products 
WHERE rnk < 3
ORDER BY category, rnk;

/* BUISNESS INSIGHT -
Identifies the top two highest-grossing products within each category.
- The Supply Chain and Inventory Management teams use this ranking to forecast demand and prioritize restocking, 
ensuring that high-revenue "hero" items never experience costly stockouts.
- The Marketing team leverages this data to identify high-demand "anchor" products, 
using them as the focal point for targeted discount campaigns to drive maximum site traffic.
*/
