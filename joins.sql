-- self join
-- Find staff name and manager names.


SELECT
    -- *
    CONCAT(s1.first_name, ' ', s1.last_name) as manager_name,
    CONCAT(s2.first_name, ' ', s2.last_name) as staff_name
FROM sales.staffs s1
JOIN sales.staffs s2
    ON s1.staff_id = s2.manager_id;


select
    *
from sales.customers sc
cross join sales.orders so
where (sc.customer_id = 1 and so.customer_id = 1)
    or (sc.customer_id = 2 and so.customer_id = 2)
    or (sc.customer_id = 3 and so.customer_id = 3)
order by 2 desc;


-- Find total staffs, total orders and total customers by manager.

SELECT
    CONCAT(s1.first_name, ' ', s1.last_name) as manager_name,
    COUNT(DISTINCT s2.staff_id) as total_staffs,
    COUNT(DISTINCT so.order_id) as total_orders,
    COUNT(DISTINCT sc.customer_id) as total_customers
FROM sales.staffs s1
JOIN sales.staffs s2
ON s1.staff_id = s2.manager_id
JOIN sales.orders so
ON s1.staff_id = so.staff_id
JOIN sales.customers sc
ON sc.customer_id = so.customer_id
GROUP BY CONCAT(s1.first_name, ' ', s1.last_name);

-- left join
select
    *
from sales.staffs s1
left join sales.staffs s2
on s1.staff_id = s2.manager_id;

-- Right join
select
    *
from sales.staffs s1
right join sales.staffs s2
on s1.staff_id = s2.manager_id;

-- Outer join
select
    *
from sales.staffs s1
full outer join sales.staffs s2
on s1.staff_id = s2.manager_id;

-- Natural join
select
    *
from sales.customers sc,
sales.orders so,
sales.order_items soi
where sc.customer_id = so.customer_id
and so.order_id = soi.order_id;

