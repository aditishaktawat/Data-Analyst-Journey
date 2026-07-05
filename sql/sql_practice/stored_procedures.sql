/*
PROCEDURES -
It is a named block of code and stored in database.
Can be used to build complex logic*/

-- Syntax to create a  procedure

create or replace procedure pr_name (p_name varchar, p_age int)

language plpgsql
as $$
declare 
    variables
begin
    procedure_body - all logics
end;
$$

-- 1. Procedures without paramenters

/* QUES. For every 'Iphone 13 Pro MAx' sale, modify the database tables (sales, products) accordingly
   PRODUCTS (product_code, product_name, price, quantity_remaining, quantity_sold)
   SALES( order_id, order_date, product_code, quantity_ordered, sale_price)
*/

create or replace procedure pr_buy_products()
language plpgsql
as $$
declare   --declare those variable with their datatypes here
    v_product_code varchar(20);
    v_price float;
begin
    SELECT product_code, price        --data to fetch from query
    into v_product_code, v_price      --store that data into resp. varibales
    FROM products 
    WHERE product_name = 'Iphone 13 Pro Max';

    --insert data into sales table
    insert into sales (order_date, product_code,quantity_ordered, sale_price)
        values (current_date, v_product_code, 1, (v_price *1))
    
    --update products table
    update products
    set quantity_remaining = (quantity_remaining - 1) ,
        quantity_sold = (quantity_sold + 1)
    WHERE product_code = v_product_code;

    raise notice 'PRODUCT SOLD!';   --print statement for successful updation
end;
$$

-- calling a procedure
Call pr_buy_products();

SELECT * from sales;
SELECT * from products;

-- 2. Procedures with paramenters

/* QUES- For every given PRODUCT and the QUANTITY-
    1.Check if Product is available based on required Quantity    
    2. If available, then modify the database tables acccordingly.
*/

create or replace procedure pr_buy_products( p_product_name varchar, p_qantity int)
language plpgsql
as $$
declare
    v_count  int;
    v_price float;
    v_product_code varchar(20);

begin
    SELECT count(*)
    into v_count   ---store into variable
    FROM products 
    WHERE product_name = p_product_name
        and quantity_remaining = p_qantity;
    
    if v_count > 0 then
        SELECT product_code, price
        into v_product_code, v_price
        FROM products
        where product_name = p_product_name;

        insert into sales(order_date, product_code, quantity_ordered, sale_price)
            values ( current_date, v_product_code, p_qantity, (v_price* p_qantity) );
        
        update products
        set quantity_remaining = (quantity_remaining - p_qantity),
            quantity_sold = (quantity_sold + p_qantity)
        where product_code = v_product_code;

        raise notice 'PRODUCT SOLD!';
    else
        raise notice 'INSUFFICIENT QUANTITY!';
    end if;
end;
$$