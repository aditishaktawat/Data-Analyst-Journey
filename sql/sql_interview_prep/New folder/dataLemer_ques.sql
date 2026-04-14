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


-- QUESTION: Laptop vs. Mobile Viewership [NY TIMES]
-- STATUS: DONE  
-- 3 min

