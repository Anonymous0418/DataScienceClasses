/*
SubQuery
---------------
1. Single Line SubQuery
    - If inner query provides with single row and single column data.
    - Comparison Operators: =, <, >, <=, >=, <>

2. Multi Line SubQuery
    - If inner query provides with multiple rows and single column data.
    - In(for discrete or categorical data), Any, All(for continuous data) operators can be used.

3. Correlated SubQuery
    - It is also used with multi row subquery.
    - If required use Exists.

syntax:
    SELECT * from table_name where column_name = (-- Outer Query
    select column_name from table_name where column_name = data -- Inner Query
    );
*/

-- Single Line SubQuery
-- Find all order item details whose list price is less than average list price.

SELECT AVG(list_price) FROM sales.order_items;


SELECT *
FROM sales.order_items WHERE list_price < (SELECT AVG(list_price) FROM sales.order_items);

-- Find third highest list price from order items table.

SELECT * FROM sales.order_items WHERE list_price = (
    SELECT MAX(list_price) FROM sales.order_items WHERE list_price < (
        SELECT MAX(list_price) FROM sales.order_items WHERE list_price < (
            SELECT MAX(list_price) FROM sales.order_items
        )
    )
);

-- Find 3rd day order from customer orders.
SELECT * FROM sales.orders WHERE order_date = (
    SELECT MIN(order_date) FROM sales.orders WHERE order_date > (
        SELECT MIN(order_date) FROM sales.orders WHERE order_date > (
            SELECT MIN(order_date) FROM sales.orders
        )
    )
);

-- Multi Line SubQuery
-- Find all the orders whose status is rejected or pending.

SELECT customer_id, first_name, last_name, email, state, street FROM sales.customers
WHERE customer_id IN(
    SELECT customer_id FROM sales.orders WHERE order_status IN(1, 3)
);

-- find customer details whose order status is rejected or pending.
-- Their total spent price must be more than 3000 and product model year of 2018.

-- SELECT customer_id, first_name, last_name, email, state, street FROM sales.customers
-- WHERE customer_id IN(
--     SELECT customer_id FROM sales.orders WHERE order_id IN(
--         select order_id FROM
--     )
-- );

SELECT
    CONCAT(sc.first_name, ' ', sc.last_name) AS customer_name,
    total_price
FROM(
    SELECT
        so.customer_id, so.order_id, so.order_status, so.order_date, soi.list_price
        AS order_price, soi.discount, soi.quantity, ((soi.list_price) *(soi.quantity)* (1-soi.discount))
        AS total_price, pp.product_id, pp.product_name, pp.model_year, pp.list_price AS product_price
    FROM sales.orders so
        JOIN sales.order_items soi ON so.order_id = soi.order_id
        JOIN production.products pp ON soi.product_id = pp.product_id
    WHERE so.order_status IN(1, 3)
    AND ((soi.list_price) *(soi.quantity)* (1-soi.discount)) > 3000
    AND pp.model_year = 2018
) AS data
JOIN sales.customers sc ON data.customer_id = sc.customer_id;

/*
    CTE(Common Table Expression)
    -----------------------------------
    Is CTE a temporary table or temporary data table?
    -> Temporary data table

    syntax:
        WITH cte_name AS(
            query...
        )
        SELECT * FROM cte_name;
*/

WITH cte_product_order AS(
    SELECT
        so.customer_id, so.order_id, so.order_status, so.order_date, soi.list_price
        AS order_price, soi.discount, soi.quantity, ((soi.list_price) *(soi.quantity)* (1-soi.discount))
        AS total_price, pp.product_id, pp.product_name, pp.model_year, pp.list_price AS product_price
    FROM sales.orders so
        JOIN sales.order_items soi ON so.order_id = soi.order_id
        JOIN production.products pp ON soi.product_id = pp.product_id
    WHERE so.order_status IN(1, 3)
    AND ((soi.list_price) *(soi.quantity)* (1-soi.discount)) > 3000
    AND pp.model_year = 2018
),
customer_total_spent AS(
    SELECT
        CONCAT(so.first_name, ' ', so.last_name) AS customer_name,
        total_price
    from cte_product_order po
    join sales.customers so ON po.customer_id = so.customer_id
)
select SUM(total_price) AS total_spent From customer_total_spent;


/*
Window Functions
----------------------------------
1. Row_Number() - To give each row unique identifying value, FInd and remove duplicate data
2. Rank() - ranking data - skips row number
3. Dense_Rank() - ranking data - does not skip row number. used to find nth highest data.

4. Ntile(num) - Divides data
5. Lag(col_name, offset(opt...)) - Previous value
6. Lead(col_name, offset(opt...)) - Next value
7. Running Sum -> Sum(col_name)
8. Moving Average -> Avg(col_name)

*/