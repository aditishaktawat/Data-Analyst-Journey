SELECT * FROM  products;
SELECT * FROM  customers;
SELECT * FROM  employees;
SELECT * FROM  sales_order;

-- 1. Identift total no. of products sold
SELECT SUM(quantity) AS total_sold_products
FROM sales_order;

-- 2. Other than Completed, display the available delievery status
SELECT status
FROM sales_order
WHERE status != 'Completed';  -- can use <> also
-- or to make it work irrespective of case
SELECT status
FROM sales_order
WHERE lower(status) != 'completed'; --all status will be converted into lower case and matched with 'completed'


-- 3.Display the order id, order date and product name for all completed order.
SELECT s.order_id, s.order_date, p.product_name
FROM products AS p
INNER JOIN sales_order AS s ON p.id = s.prod_id
WHERE s.lower(status) = 'completed';  --to handle all the cases , in built func lower is used


-- 4. Solve the above query to show the earliest oredrs at the top.
--  Also display the customer who purchaseed these orders.
SELECT s.order_id, s.order_date, p.product_name, c.name
FROM products AS p
INNER JOIN sales_order AS s ON p.id = s.prod_id
INNER JOIN customers as c ON s.customer_id = c.id
WHERE s.lower(status) = 'completed'
ORDER BY s.order_date ASC;

-- 5. Display the total no. of orders corresponding to each delievery status
SELECT COUNT(order_id) AS total_orders, status
FROM sales_order
GROUP BY status;

-- if only asked to display all unique types of status- can be done using distinct 
SELECT DISTINCT(status)
FROM sales_order;  
-- but GROUP BY is used to find extra informatiomn alsong witn unique values


/*  ---BUISNESS INSIGHTS---

*/

-- 6.For orders purchasing more than 1 item, how many are still not completed ?
SELECT count(product_id) AS not_completed
FROM sales_order
WHERE quantity > 1 AND lower(status) != 'comleted';


/*  ---BUISNESS INSIGHTS---
Incomplete multi-item orders are high-risk "Fulfillment Bottlenecks."
Delays here lead to Revenue Leakage (cancellations) and increased Customer Churn.
Priority should be placed on clearing these to protect the company’s Brand Reputation. 
*/


-- 7.Find thr total no of orders corresponding to each deleivery status by ignoring the case on delevery status.
-- Status with highest no of orders shoukd be at the top.

--using case statement insde subquerry
SELECT updated_status, COUNT(*) AS total_orders
FROM (SELECT status,
 CASE WHEN status = 'completed'  -- to convert the case of different order status
        THEN 'Completed'
      ELSE status
 END WITH updated_status
FROM sales_order) AS sq
GROUP BY updated_status 
ORDER BY total_orders DESC;

-- OR

SELECT lower(status), COUNT(*) AS total_orders
FROM  sales_order
GROUP BY lower(status)
ORDER BY total_orders DESC;

-- 8. Write a query to identify the total products purchased by each customer.
SELECT c.name, SUM(sq.quantity) AS Total_products_purchased
FROM sales_order AS sq 
INNER JOIN customers AS c ON sq.customer_id = c.id
GROUP BY c.name   --becoz we want to find for each customer


-- 9.Display the total sales and average sales done for each day.

-- TOTAl SALES= SUM(PRICE * QUANTITY)
SELECT sq.order_date, SUM(p.price * so.quantity) AS Total_sales,   --SUM(price) - gices only total price but we want toal sales
 AVG(p.price *so.quantity) AS Average_sales
FROM sales_order sq 
JOIN products p ON sq.prod_id = p.id
GROUP BY order_date   --for each day group by order-date
ORDER BY order_date;


-- 10. Display the customer name, employee name and total sale amount of all orders which are either on hold or pending.

SELECT c.name AS customer_name,
 SUM(p.price * so.quantity) AS Total_sales,
 e.name AS employee_name
FROM sales_order so 
JOIN employees e ON so.emp_id = e.id 
JOIn customers c ON so.customer_id = c.id
JOIN products p ON so.prod_id = p.id
WHERE so.status IN('On hold', 'Pending')
GROUP BY c.name , e.name;

-- 11. Fetch all the orders which are neither completed/pending OR were handled by the employee Abrar.
  --  Also, display employee name and all details of order.

SELECT e.name, so.*
FROM sales_order so
JOIN employees e ON so.emp_id = e.id
WHERE lower(so.status) NOT IN ('completed', 'pending') 
  OR lower(e.name) LIKE '%abrar%';   --we want either condition to be true

-- 12. Fetch the orders which cost more than 2000 but did not include the macbook pro.
    -- Print the total sale amount as well.

SELECT (so.quantity * p.price) AS Total_sales , so.*
FROM sales_order so 
JOIN products p ON so.prod_id = p.id
WHERE lower(p.name) NOT LIKE '%macbook pro%'
  AND  (so.quantity * p.price) > 2000;

-- 13. Identify the customers who have not purchased any product yet.
SELECT c.*
FROM customers c 
LEFT JOIN sales_order so ON so.customer_id = c.id
WHERE so.order_id IS NULL; -- NULL means unknown, hence cannot be comapred using = or !=

-- OR using subquerry

SELECT * 
FROM customers 
WHERE id NOT IN (SELECT DISTINCT(customer_id) 
                FROM sales_order);


-- 14. Write a query to identify the total products purchased by each customer.
--    Return all customers irrespective of whether they have made a purchase or not.
--    Sort the result with highest no of orders at the top.

SELECT c.name, coalesce(SUM(so.quantity), 0) AS tot_prod_purchased    --coalesce func to display null output as 0
FROM customers c
LEFT JOIN sales_order so so.customer_id = c.id
-- LEFT JOIN products p so.prod_id = p.id
GROUP BY name
ORDER BY  tot_prod_purchased  DESC;


-- 15. Corresponding to each employee, display the total sales they made of all the completed orders.
    -- Display total sales as 0 if an employee made no sales yet.
SELECT e.name AS employee, coalesce(SUM(so.quantity * p.price), 0) AS Total_sales
FROM employees e
LEFT JOIN sales_order so ON e.id = so.emp_id   --becoz we need all the employees in result
                       AND lower(status) = 'completed';   --need to mention the status in ON condition only otherwise the status not completed for the the employees will be rejected
LEFT JOIN products p ON so.prod_id = p.id 
GROUP BY e.name; 
 

-- 16. Re-wrte the above query so as to dispaly the total sales made by each employee
--     corresponding to each customer. If an employee has not served a customer yet then display "-"
--     under the customer.

SELECT e.name AS employee, coalesce(c.name, -) AS customer
        coalesce(SUM(so.quantity * p.price), 0) AS total_sales
FROM employee e 
LEFT JOIN sales_order so ON e.id = so.emp_id 
                            AND lower(status) = 'completed';
LEFT JOIN customers c ON c.id = so.customer_id 
LEFT JOIN products p ON so.prod_id = p.id
GROUP BY e.name, c.name
ORDER BY 1,2

-- 17.Rewrite the above query sa as to display only those records where the total sales is above 1000.
SELECT e.name AS employee, coalesce(c.name, -) AS customer
        coalesce(SUM(so.quantity * p.price), 0) AS total_sales
FROM employee e 
LEFT JOIN sales_order so ON e.id = so.emp_id 
                            AND lower(status) = 'completed';
LEFT JOIN customers c ON c.id = so.customer_id 
LEFT JOIN products p ON so.prod_id = p.id
GROUP BY e.name, c.name
HAVING coalesce(SUM(so.quantity * p.price), 0) > 1000; -- becoz sales data was coming after the group by clause so cant use where clause in it
ORDER BY 1,2;

-- 18.Identify employees who have served more than 2 customer.
SELECT e.name AS employee, COUNT(DISTINCT(c.name) AS customer
FROM employees e 
JOIN sales_order so ON so.emp_id = e.id
JOIN customers c ON so.customer_id = c.id
GROUP BY e.name 
HAVING COUNT(DISTINCT(c.name) > 2
ORDER BY e.name;

-- 19.Identify the customers who have purchased more than 5 products.
SELECT c.name AS customer, SUM(so.quantity) AS purchased_prod
FROM sales_order so 
JOIN customers c ON c.id = so.customer_id
GROUP BY c.name 
HAVING SUM(so.quantity) > 5;

-- 20.Identify the customers whose avg purchase cost exceeds avg sale of all the orders.

-- query to calucalte the total sales of all the products
SELECT AVG(so.quantity * p.price) AS total_sales
FROM sales_order so
JOIN products p ON so.prd_id = p.id

-- query to calculate the avg purchase cost by each customer
SELECT c.name, AVG(so.quantity * p.price) AS purchase_cost
FROM sales_order so
JOIN customers c ON c.id = so.customer_id
JOIN products p ON p.id = so.prod_id
GROUP BY c.name

-- Now we want to identify the customers whose avg purchase cost > avg sale of all the orders.
--SO We need to add the above 2 queries using subquerry

SELECT c.name, AVG(so.quantity * p.price) AS purchase_cost
FROM sales_order so
JOIN customers c ON c.id = so.customer_id
JOIN products p ON p.id = so.prod_id
GROUP BY c.name   --cant use where clause to write subquery as working on grouped data
HAVING AVG(so.quantity * p.price) > (SELECT AVG(so.quantity * p.price) AS total_sales
                                    FROM sales_order so
                                    JOIN products p ON so.prd_id = p.id )





 





    




