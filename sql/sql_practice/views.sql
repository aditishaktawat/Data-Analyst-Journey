--- VIEWS IN SQL ---
-- View is a database object, created over an SQL Query.
-- It does not store any data , it just execute the underlying sql query 
-- View is like an virtual table but just shows data , doesnt store data


--QUES- Fetch the order summary (to be given to client/vendor )
--Need to provide - Order_id,date, product_name, customer who purchased it, cost

SELECT o.order_id, o.date, p.prod_name, c.cust_name,
 (p.price * o.quantity) - (( p.price * o.quantity) * disc_percent ::float/100) AS cost
FROM customer_data c
JOIN order_details d ON o.cust_id = c.cust_id
JOIN product_info p ON p.prod_id = o.prod_id;

--We need to give this code to client
Requiremnt- Client need to execute this report multiple times a day and see changes ever now and then.
Cant share as it it query becoz it has confidential information

--CREATE A VIEW FOR A QUERY
CREATE VIEW order_summary  --view created
AS 
SELECT o.order_id, o.date, p.prod_name, c.cust_name,
 (p.price * o.quantity) - (( p.price * o.quantity) * disc_percent ::float/100) AS cost
FROM customer_data c
JOIN order_details d ON o.cust_id = c.cust_id
JOIN product_info p ON p.prod_id = o.prod_id;

SELECT * FROM order_summary;  --not a table just a structure of view

--View doesnt improve the performance of query - as exactly same as calling a query
-- Materialized view can improve the performance.

/* Why use View, what is the main purpose of using a view /its advantages ?

1.- SECURITY
2.- TO SIMPLIFY COMPLEX QUERY

1. SECURITY - create a specific user who has been given specific priviledges in the database.
 - By hiding the query used to generate the view  */

CREATE role james
login
password 'james';

GRANT SELECT on order_summary to james;
 
/*
2.- TO SIMPLIFY COMPLEX QUERY -
- Sharing a View is better than sharing complex query
- Avoid re-writing same complex query multiple times 
*/


--Using CREATE or REPLACE & Modifying a View
