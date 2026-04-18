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
WHERE s.lower(status) = 'completed';
