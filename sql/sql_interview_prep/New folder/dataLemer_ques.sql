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







# SQL Logical Processing Order 🧠

Understanding how the database engine actually executes a query is the difference between a Junior and a Senior Analyst. 

### The Execution Sequence:
1. **FROM / JOIN**: The database first identifies the tables and combines them.
2. **WHERE**: Filter rows based on specific conditions *before* grouping.
3. **GROUP BY**: Collapse rows into groups (e.g., by `city` or `candidate_id`).
4. **HAVING**: Filter the *groups* created in the previous step.
5. **SELECT**: Pick the specific columns and calculate expressions (like `SUM` or `CASE`).
6. **DISTINCT**: Remove duplicate results.
7. **ORDER BY**: Sort the final output.
8. **LIMIT / OFFSET**: Restrict the number of rows returned.

---

### Key Interview Insight:
**Why can't you use an alias created in `SELECT` inside a `WHERE` clause?**
Because the `WHERE` clause is executed in Step 2, but the `SELECT` (where the alias is born) doesn't happen until Step 5. The database literally doesn't know the alias exists yet!

