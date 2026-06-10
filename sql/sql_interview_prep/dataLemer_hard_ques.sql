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