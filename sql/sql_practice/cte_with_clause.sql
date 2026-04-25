--- WITHG CLAUSE---  

/* QUES- Fetch employees who earn more than average salary of all employees */
SELECT *
FROM employees
WHERE salary > (SELECT AVG(salary)
                FROM employees)

--writing using WITH clause
WITH average_salary (avg_sal) AS    --temporary avg salary table created
        (SELECT cast(avg(salary), int) FROM employees)
SELECT * 
FROM employees e, average_salary av
WHERE e.salary > av.avg_sal;

/* 
QUES - Find stores who's sales where better than the average sales across all stores

--using subquery
-- 1.find total sales for each store. --Total_Sales

-- 2. find avg sales with respect all stores --Avg sales

-- 3. Find stores where Total_sales > Avg_sales of all the stores
*/
-- 1.
SELECT store_name, SUM(cost ) AS total_sales_per_store
FROM sales 
GROUP BY store_name

-- 2.
SELECT cast(AVG(total_sales) as int) AS avg_sales_for_all_stores
FROM (SELECT store_name, SUM(cost * quantity) AS total_sales_per_store
      FROM sales 
      GROUP BY store_name) AS x

-- 3.
SELECT * 
FROM (SELECT store_name, SUM(cost)
      FROM sales 
      GROUP BY store_name)  AS total_sales
JOIN (SELECT cast(AVG(total_sales) as int) AS avg_sales_for_all_stores
      FROM (SELECT store_name, SUM(cost * quantity) AS total_sales_per_store
      FROM sales 
      GROUP BY store_name) AS x)  AS avg_sales
ON total_sales.total_sales_per_store > avg_sales.avg_sales_for_all_stores

/* Not a good way of writing a query as
  -Difiiculty in reading a query like this
  - using same piece of code again and again
  - performance decreses
*/

--writing above query using WITH clause

WITH total_sales (store_id, total_sales_per_store) AS   --with clause to find total sales of each store
      ( SELECT s.store_name, SUM(cost) AS total_sales_per_store
        FROM sales s
        GROUP BY s.store_name ),

      avg_sales (avg_sales_for_all_stores) AS  --with clause to find avg sales across all store
      (SELECT cast(AVG(total_sales_per_store), int) AS avg_sales_for_all_stores
      FROM total_sales)

SELECT *       -- required condition 
FROM total_sales ts 
JOIN avg_sales as
ON ts.total_sales_per_store > as.avg_sales_for_all_stores

/*
 --- BUSINESS INSIGHT ---: 
These stores are our 'Benchmark' locations.
ACTION: We should study why these specific stores are beating the average—is it their location, their staff, or the products they stock?
Let's try to copy their 'Playbook' for the stores that are currently below average. 
*/


/* 
ADVANTAGES OF USING WITH CLAUSE
- Readability increases
- performance increases - Firstly the query inside WITH clause is executed and 
stored in the temporarily table and then can be fetched in the main memory from anywhere.
-Useful in Recursive queries

WHEN to use WITH clause
- when particularly using the subquery multiple times in the statement
- when writing big/complex query
- when working on millions of data and want to work on only 1000s of data from it.
