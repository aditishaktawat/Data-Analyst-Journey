--- VIEWS IN SQL ---
-- View is a database object, created over an SQL Query.
-- It does not store any data , it just execute the underlying sql query 
-- View is like an virtual table but just shows data , doesnt store data

SELECT * from customer_data;
SELECT * from order_details;
SELECT * from product_info;

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

CREATE or REPLACE VIEW order_summary
as
SELECT o.order_id, o.date, p.prod_name, c.cust_name,
 (p.price * o.quantity) - (( p.price * o.quantity) * disc_percent ::float/100) AS cost
FROM customer_data c
JOIN order_details d ON o.cust_id = c.cust_id
JOIN product_info p ON p.prod_id = o.prod_id;

SELECT * FROM order_summary;

/* RULES 
1. CANNOT change the column name.
2. Cannot change the datatype of column
3. Cannot chnage the order of columns

View stores the structure of query. 

To modify the structure - Use ALTER VIEW

*/

ALTER VIEW order_summary rename columndate to order_date;

-- Only altered the view, not the underlying table

ALTER View order_summary rename to order_summary_2;

DROP View order_summary_2;

-- View doent not automatically capture the chnage in structure of database.
-- Need to refresh or replace view

create view expensive_products
as
Select * from product_info where price > 1000;

Select * from expensive_products;

ALTER table product_info add column prod_config varchar(100);

Insert into product_info
values ('P10', 'TEST', 'Test')  ---view takes latest data

--UPDATABLE VIEWS
-- 1. View should be created using 1 table/view only.
-- 2. Cannot have DISTINCT clause
-- 3. Cannot have GROUP BY clause.
-- 4. Cannot have WITH clause.
-- 5. Cannot have WINDOW clause.

-- WITH  CHECK option

-- Create a view for apple products 
Create view apple_products 
as
Select * from product_info where brand = 'Apple';

--Supplier adds a new product in this view
insert into apple_products
values ('P22', 'Note 20','Samsung', null);

Select * from product_info;  --added in the samsung category which was not allowed
Select * from apple_products;

-- To add extra check 
Create view apple_products 
as
Select * from product_info where brand = 'Apple'
with check option;

-- Now can only insert into where brand = 'Apple' will be successful
