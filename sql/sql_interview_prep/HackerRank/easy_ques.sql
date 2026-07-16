SELECT name
FROM employee
WHERE salary > 2000 AND months < 10
ORDER BY employee_id;

-- SYMMETRIC PAIRS 
-- REVISIT
SELECT f1.x, f1.y
from functions f1
JOIN functions f2 ON f1.x = f2.y AND f1.y = f2.x
GROUP by f1.x, f1.y
HAVING f1.x < f1.y OR ( f1.x = f1.y AND count(*)>1)
ORDER BY f1.x;

-- Interview 
-- Revisit

-- Step 1: Sum up submissions per challenge by itself
WITH aggregate_submissions AS (
    SELECT challenge_id, 
           SUM(total_submissions) AS total_subs, 
           SUM(total_accepted_submissions) AS total_accepted_subs
    FROM submission_stats
    GROUP BY challenge_id
),

-- Step 2: Sum up views per challenge by itself
aggregate_views AS (
    SELECT challenge_id, 
           SUM(total_views) AS total_vws, 
           SUM(total_unique_views) AS total_uniq_vws
    FROM view_stats
    GROUP BY challenge_id
)

-- Step 3: Join everything together safely using LEFT JOINs
SELECT c.contest_id,
       c.hacker_id,
       c.name,
       SUM(COALESCE(s.total_subs, 0)) AS total_submissions,
       SUM(COALESCE(s.total_accepted_subs, 0)) AS total_accepted_submissions,
       SUM(COALESCE(v.total_vws, 0)) AS total_views,
       SUM(COALESCE(v.total_uniq_vws, 0)) AS total_unique_views
FROM contests c 
LEFT JOIN colleges cg ON c.contest_id = cg.contest_id
LEFT JOIN challenges ch ON cg.college_id = ch.college_id
LEFT JOIN aggregate_submissions s ON ch.challenge_id = s.challenge_id
LEFT JOIN aggregate_views v ON ch.challenge_id = v.challenge_id
GROUP BY c.contest_id, c.hacker_id, c.name
HAVING (SUM(COALESCE(s.total_subs, 0)) + 
        SUM(COALESCE(s.total_accepted_subs, 0)) + 
        SUM(COALESCE(v.total_vws, 0)) + 
        SUM(COALESCE(v.total_uniq_vws, 0))) > 0
ORDER BY c.contest_id;