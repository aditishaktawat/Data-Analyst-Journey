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


