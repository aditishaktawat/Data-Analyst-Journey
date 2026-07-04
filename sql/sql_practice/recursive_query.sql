/* RECURSIVE Query 
 # syntax: 
 With recursive Cte_name as (
    Select query (Non Recursive query or Base Query)
    UNION / ALL
    Select query (Recursive query using Cte_name)
        [With Termination Condition]
 )
 Select * from cte_name;
*/

-- Q1. Display no. from 1 to 10 without using any inbuilt functions
WITH RECURSIVE numbers AS 
(
    SELECT 1 as n
    UNION
    SELECT n + 1
    FROM numbers WHERE n < 10
)
SELECT * FROM numbers;

-- Q2. Find hierarchy of employees under given manager 'Asha'
WITH RECURSIVE emp_hierarchy AS 
(
    SELECT id, name, manager_id, designation, 1 as lvl    --non recusrvie / base query
    FROM emp_details WHERE name = 'Asha'
    UNION
    SELECT E.id, E.name as emp_name, E.manager_id, H.lvl + 1 as lvl   --recursive query
    FROM emp_hierarchy H 
    JOIN emp_details E ON H.id = E.manager_id 
)
SELECT * FROM emp_hierarchy;  --outer query

-- Find name of manager also along with emp_name and id
WITH RECURSIVE emp_hierarchy AS 
(
    SELECT id, name, manager_id, designation, 1 as lvl    --non recusrvie / base query
    FROM emp_details WHERE name = 'Asha'
    UNION
    SELECT E.id, E.name as emp_name, E.manager_id, H.lvl + 1 as lvl   --recursive query
    FROM emp_hierarchy H 
    JOIN emp_details E ON H.id = E.manager_id 
)
SELECT H2.id as emp_id, H2.name AS emp_name, E2.name AS manager_name, h.lvl AS level   --base query modified
FROM emp_hierarchy H2 
JOIN emp_details E2 ON H2.manager_id = E2.id;


-- Q3. Find hierarchy of managers for given employee 'David'

WITH RECURSIVE emp_hierarchy AS 
(
    SELECT id, name, manager_id, 1 as lvl
    FROM emp_details WHERE name = 'David'
    UNION
    SELECT E.id, E.name, E.manager_id , H.lvl + 1 As lvl
    FROM emp_hierarchy H 
    JOIN emp_details E ON H.manager_id = E.id
)
Select
FROM emp_hierarchy H2
JOIN emp_details E2 ON H2.manager_id = E2.id;
