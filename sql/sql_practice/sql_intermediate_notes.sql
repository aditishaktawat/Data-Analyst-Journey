--SUBQUERY IN SQL--

SELECT * FROM employees
SELECT * FROM departments

-- Find the employees who's salary is more than the average salary earned by all employees.
-- 1) Find avg salary
-- 2) Filter the employees based on the above result

SELECT AVG(salary) FROM employees   --5700

SELECT *   --ouetr query/ main query
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);  --subquery/inner query

-- Types of subquery - Scalar, multiple row , correlated subquery

--SCALAR SUBQUERY - always fetches 1 record and 1 column

SELECT e.*
FROM employee e 
JOIN (select avg(salary) sal from employee ) avg_sal
  ON e.salary > avg_sal.sal


--MULTIPLE ROW SUBQUERY - 
--subquery which return muiltiple column and multiple row
--subquery which return only 1 column and multiple rows.

/* Ques- Find the employees who earn the highest salary in each department */

SELECT dept_name, MAX(salary)
FROM employee
GROUP BY dept_name   --subquery

SELECT * 
FROM employee 
WHERE (dept_name, salary) IN (SELECT dept_name, MAX(salary)
                             FROM employee
                             GROUP BY dept_name )


--single column , multiple row subquery

/* Find department who do not have any employees */
SELECT *
FROM department
WHERE dept_name NOT IN ( SELECT DISTINCT(dept_name)
                         FROM employee);


3. --CORRELATED SUBQUERY--   
Subquery which is dependent on outer query.

/* QUES - Find the employees in each department who earn more than the average salary in that department */
SELECT * 
FROM employee e1
WHERE  salary > (SELECT AVG(salery)
                             FROM employee e2
                             WHERE e2.dept_name = e1.dept_name)
--subquery will be processed every 1 time for the every 1 time of the outer query 

/* Disadvantage of correlated subquery-
 If the outer query is going to process millions of records then correlated subquery will
 be procesed millions of times. */


/* QUES - Find department who do not have any employee. */
SELECT *
FROM department d
WHERE dept_name NOT EXISTS ( SELECT dept_name 
                        FROM employee e 
                         WHERE e.dept_name = d.dept_name) --subquery
-- when the subquery will nt return any value then not exists clause will become true and hence will include those columns in the final r
-- result

/* Correlated subquery used generally when we check between 2 table whether this exists or not. Checking condition */


----NESTED SUBQUERY----

/* QUES- Find stores who's sales were better than the average sales across all stores. 
1. find total sales for each store.
2. Find the avg sales for all the stores.
3. Compare 1 and 2
*/
SELECT *        --for comparing
FROM ( SELECT store_name, SUM(price) AS total_sales   --total sales of each store
       FROM sales
       GROUP BY store_name)  AS s1
JOIN (SELECT AVG(total_sales) AS avg_sales     --avg sales of all the stores
      FROM (SELECT store_name, SUM(price) AS total_sales   --total sales of each store
              FROM sales
              GROUP BY store_name)) AS s2
ON s1.total_sales > s2.avg_sales;

/* the way we wrote the above query is not the best way to write this subquery
 as we are using the same peice of code more than 1 time 
 SO we can USE WITH CLAUSE  */

-- Rewriting the above query using WITH clause 
WITH sales AS 
      (SELECT store_name, SUM(price) AS total_sales   --total sales of each store
       FROM sales
       GROUP BY store_name) 
SELECT *        --for comparing
FROM sales
JOIN (SELECT AVG(total_sales) AS avg_sales
       FROM sales) AS s2
ON sales.total_sales > s2.avg_sales;


/* DIFFERENT SQL CLAUSES WHERE SUBQUERY IS ALLOWED */
-SELECT 
-FROM 
-WHERE 
-HAVING

--USing a subquery in SELECT clause.
/* QUES- Fetch all employee details and add remarks to those employees who earn more than avg salary
  of all emloyees. */

SELECT * ,
 (CASE WHEN salary > (select avg(salary) from employee)
          THEN 'higher than average'
       ELSE null
 end ) AS remarks
FROM employee;

--not a good practice to use subquery inside select clause

--rewriting it using cross join
SELECT * ,
  (CASE WHEN salary > avg_sal.sal
          THEN 'higher than average'
       ELSE null
   end ) AS remarks
FROM employee
CROSS JOIN (select avg(salary) from employee) AS avg_sal;

--USing a subquery in HAVING clause.

--QUES- Find thes stores who have sold more units than the average units sold by all stores. 
1. Find the total quantity of each store
2. Find avg units sold by all stores


SELECT store_name, SUM(quantity) --total items sold by each store
FROM sales
GROUP BY store_name
HAVING SUM(quantity) > (select avg(quantity) from sales);


---SQL COMMANDS WHICH ALLOW SUBQUERY---
- SQL QUERY 
- INSERT
- UPDATE
- DELETE

-- INSERT

/* QUES: Insert data into employee history table. Make sure not insert duplicate recorde. */

--Requirement- The data is already present in some other tables and we want to just propagate it to this table.

INSERT into employee_history
 SELECT e.emp_id, e.emp_name, d.dept_name, e.salary, d.location
 FROM employee e
 JOIN department d ON e.emp_id = d.dept_id   --inserting data from empl and dept table into emp_history table
 WHERE NOT EXISTS(              --to check for duplicate data
                   SELECT 
                   FROM employee_history eh    
                   WHERE eh.emp_id = e.emp_id   
                  ) 
--if emp_id already present in emp_his table then this query will return some output which whill make the non exist condition false
--and hence the whole query will not run and nothing will be inserted in emp_his table.


-- UPDATE

/* QUES - Give 10% increment to all employees in Banglore location based on
  maximun salary earned by an emp in each dept. Only consider employees in emp_history table. */

UPDATE employee e  --outer query
SET salary = (Select MAX(salary) + (MAX(salary) * 0.1)  --corelateed subquery
              FROM employee_history eh
              WHERE eh.dept_name = e.dept_name)
WHERE e.dept_name IN ( SELECT dept_name   --multiple row subquery
                        FROM department 
                        WHERE location = 'Bangalore')
and emp_id in (select emp_id from employee_history);    --only consider empl in emp_history table


--DELETE
/* QUES - Delete all departments who do not have any employees. */

DELETE FROM department
WHERE dept_name IN (SELECT dept_name
                  FROM department d
                  WHERE NOT EXISTS ( SELECT 1 
                                    FROM employee e 
                                    WHERE e.emp_name = d.dept_name)
                                    );  











 
