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

--QUES:  [] 
-- STATUS: 
-- TIME:



--QUES:  [] 
-- STATUS: 
-- TIME:



--QUES:  [] 
-- STATUS: 
-- TIME: