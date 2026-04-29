/* QUES- Find max salry department wise */
SELECT MAX(salary) AS max_salary   --this will give same max salary for all the employees
FROM employees
GROUP BY dept_name;    

/* QUES- Find max salary department wise and also other details of employee table

--USING WINDOW func with aggregation */

SELECT e.* ,
MAX(salary) OVER (PARTITION BY dept_name) AS max_salary  --this will create different max salary for each different department
FROM employees e;


--Some specific funcs used with WINDOW Functions
-- 1. ROW_NUMBER() - Assign unique value to each order of the table

SELECT e.*,
ROW_NUMBER() OVER () AS rn  -- 1 window created for all the orders and and unique row no assigned to them
FROM employees e;

SELECT e.*,
ROW_NUMBER() OVER (PARTITION BY dept_name) AS rn  -- Different windows created for all the orders and and unique row no assigned to them
FROM employees e;

/* QUES- Fetch the first 2 employees from each department to join the company.

1. Let's assume that the employee who joins before will have a smaller emp_id (eg: emp_id 101)
  and newer emp will be having ep_id (let say 143)
2. First partition the employee based on department and assigne row_nuber to them.
3. Row_number () asiigned in order of ASC order for every department. (becoz emp_id can be present in any order ie. not sorted)
*/


SELECT * FROM (  --The outer query treats the inner result like a normal table, 
                 -- so it CAN see 'rn' and filter it.

    -- Step 1: The inner query runs completely first. 
    -- It calculates the ROW_NUMBER() and creates the 'rn' column.
    SELECT e.*,
    ROW_NUMBER() OVER (PARTITION BY dept_name ORDER BY emp_id) AS rn  --data sorted based on emp_id
    FROM employees e 
) x
WHERE x.rn < 3;

--OR 

--Using CTE 
     ---- Calculate the window function first
WITH ranked_employees AS (
    SELECT e.*,
    ROW_NUMBER() OVER (PARTITION BY dept_name ORDER BY emp_id) AS rn
    FROM employees e
)
----Now filter the results
SELECT * 
FROM ranked_employees
WHERE rn <3;


--2. RANK() - Assign same rank to the duplicate values and skip the rank no for every duplictae value

/* QUES - Fetch the top 3 employees in each department earning the max salary. */

WITH ranked_employees (
    SELECT e.*,
    RANK() OVER ( PARTITION BY dept_name ORDER BY salary DESC) AS rnk
    FROM employees e;
)
SELECT * FROM ranked_employees
WHERE rnk < 4;

--3. DENSE_RANK() - Wont skip a value even when a duplictae record is found
WITH ranked_employees (
    SELECT e.*,
    RANK() OVER ( PARTITION BY dept_name ORDER BY salary DESC) AS rnk
    DENSE_RANK() OVER ( PARTITION BY dept_name ORDER BY salary DESC) AS dense_rnk
    FROM employees e;
)
SELECT * FROM ranked_employees
WHERE dense_rnk < 4;


/* 
DIFFERENCE BETWEEN RANK(), DENSE_RANK(), ROW_NUMBER()
ROW_NUMBER() - Assign unique value to each record irrespective of duplicate record or not

RANK() - Assign same value to the duplicate record but skip the no after every duplicate record

DENSE_RANK() - sign same value to the duplicate record but wont skip a no. even after duplicate record is found
*/

--4. LAG() - return records from the Previous rows

/* QUES- Fetch a query to display if the salary of an employee is higher, lower or equal to the previous one. */
SELECT e.*,
LAG(salary) OVER (PARTITION BY dept_name ORDER BY emp_id) AS prev_emp_sal
--this will create a colunm as prev_emp_sal and display the previous emp salary (as order by is emp_id)
FROM employees e 

--LAG(salary, 2, 0) -> do a lag funct on salry column and display the 2nd previous salary and if no previous record present - assign 0

--5. LEAD() - returns rows following the current record

SELECT e.*,
LEAD(salary) OVER (PARTITION BY dept_name ORDER BY emp_id) AS next_emp_sal --display next salary
FROM employees e 

/* QUES- Fetch a query to display if the salary of an employee is higher, lower or equal to the previous one. */
SELECT e.*,
LAG(salary) OVER (PARTITION BY dept_name ORDER BY emp_id) AS prev_emp_sal 
CASE WHEN e.salary > LAG(salary) OVER (PARTITION BY dept_name ORDER BY emp_id ) THEN 'Higher than previous employee'
     WHEN e.salary < LAG(salary) OVER (PARTITION BY dept_name ORDER BY emp_id ) THEN 'Lower than previous employee'
     WHEN e.salary = LAG(salary) OVER (PARTITION BY dept_name ORDER BY emp_id ) THEN 'Equal to previous employee'
     END sal_range
FROM employees e ;


--6. FIRST_VALUE() - extract first column value from the partition set

/* QUES - Fetch the most expensive product under each category (corresponding to each record) */

SELECT * ,
FIRST_VALUE(product_name) OVER (PARTITION BY product_category ORDER BY price DESC) AS most_exp_prod
FROM product;


--7. LAST_VALUE() - Fetch last record from the partition

/* QUES- Write query to display the least expensive product under each category (corresponding to each record) */

SELECT *,
LAST_VALUE(product_name) OVER (PARTITION BY product_category ORDER BY price DESC) as least_exp_prod
FROM product;  
 ---not giving the right ans due to default FRAME clause


-- FRAME CLAUSE- 
-- Default frame clause -- RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
  
/* RANGE- What is the range of products that this function(last_value) needs to consider
   UNBOUNDED - From the very first row of the partition
   PRECEDING - rowd before it
   CURRENT ROW - till the current record

Functions afftected by frame clause are- 
Last_value() , ntile() , aggregate func

--Default frame adjusted into 

-- RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
can also modify as - 
ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
ROWS - what are the differnt rows we need to consider

-Difference betweem rows and range -
For duplicate records - 
range --- row - range will consider  full frame and all the duplicate data and then will print the last _value
row - row - row will not think of duplicate data and consider only upto current row

- More specification-
 range between 2 proceeding and 2 following - means consider 2 rows prior the current row and 2 rows after the current row
*/

SELECT *,
LAST_VALUE(product_name)
    OVER (PARTITION BY product_category ORDER BY price DESC
     --   RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)  --becoz of this last_value() will return wrong anse for the every row
        RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)  --now right ans can be extracted
        as least_exp_prod
FROM product;


SELECT *,
LAST_VALUE(product_name)
    OVER (PARTITION BY product_category ORDER BY price DESC
       -- RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)  --now right ans can be extracted
        ROW BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
    as least_exp_prod
FROM product;


--ALternate way of writing WINDOW func- 

/* QUES -Write query to display the least expensive product , most expensive product
 under 'PHONE' category (corresponding to each record) */

SELECT * ,
FIRST_VALUE (product_name)
   OVER ( PARTITION BY product_category ORDER BY price)
    as most_exp_prod,
LAST_VALUE (product_name) 
   OVER ( PARTITION BY product_category ORDER BY price
   RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
    as least_exp_prod
FROM products
WHERE product_category = 'Phone';


--taking lot of space
SELECT * ,
FIRST_VALUE (product_name)
   OVER w as most_exp_prod,
LAST_VALUE (product_name) 
   OVER w as least_exp_prod
FROM products
WHERE product_category = 'Phone';
WINDOW  w AS ( PARTITION BY product_category ORDER BY price DESC
             RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)


--8. NTH_VALUE() - Fetch a value from any nth position we specify

--QUES- Write a query to display third most expensive product under each category.
SELECT * ,
FIRST_VALUE (product_name) OVER w as most_exp_prod,
NTH_VALUE(product_name, 3) OVER w as second_most_exp_prod
-- if the nth row doesnt exist, it will return NULL 

FROM products
WHERE product_category = 'Phone';
WINDOW  w AS ( PARTITION BY product_category ORDER BY price DESC
             RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) --imp to specify for nth_value