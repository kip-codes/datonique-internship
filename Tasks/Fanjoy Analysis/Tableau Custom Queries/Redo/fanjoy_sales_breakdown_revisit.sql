
------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
/*
  Customer Distribution for New vs. Existing Sales

  Table/View Dependencies:
    kevin_ip.fod_{Team10, Jake Paul, Team10 no Jake}: Base data extract
    kevin_ip.fld_{Team10, Jake Paul, Team10 no Jake}: Base data extract
    kevin_ip.first_orders_fanjoy: Used to determine the whether a particular order is a customer's first order placed.
 */
------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------

/*
  New vs. Existing – All of FanJoy
 */

SELECT
A.month,
A.total_customers,
A.total_orders,
A.total_sales,
B.new_customers,
B.new_orders,
B.new_sales,
(A.total_customers-B.new_customers) as existing_customers,
(A.total_orders-B.new_orders) as existing_orders,
(A.total_sales-B.new_sales) as existing_sales,
cast(B.new_customers as float)/A.total_customers as percent_new_customers,
cast(B.new_orders as float)/A.total_orders as percent_new_orders,
cast(B.new_sales as float)/A.total_sales as percent_new_sales

FROM
(
  SELECT
    sub_A1.month,
    COUNT(distinct sub_A1.customer_id) AS total_customers,
    COUNT(distinct sub_A2.order_number) as total_orders,
    SUM(sub_A2.total_sales) as total_sales
  FROM
    (
      SELECT
        date_trunc('month', created_at) as month,
        customer_id,
        order_number
      FROM fanjoy_orders_data
    ) as sub_A1
    JOIN
    (
      SELECT
        order_number,
        sum(price) as total_sales
      FROM fanjoy_lineitems_data
      GROUP BY order_number
    ) as sub_A2
    ON sub_A1.order_number = sub_A2.order_number
  GROUP BY sub_A1.month
) as A
JOIN
(
  SELECT
    sub_B1.month,
    COUNT(distinct sub_B1.customer_id) AS new_customers,
    COUNT(distinct sub_B2.order_number) as new_orders,
    SUM(sub_B2.total_sales) as new_sales
  FROM
    (
      SELECT
        date_trunc('month', created_at) as month,
        customer_id,
        order_number
      FROM fanjoy_orders_data
    ) as sub_B1
    JOIN
    (
      SELECT
        order_number,
        sum(price) as total_sales
      FROM fanjoy_lineitems_data
      GROUP BY order_number
    ) as sub_B2
      ON sub_B1.order_number = sub_B2.order_number -- link b1 to b2
    JOIN kevin_ip.first_orders_fanjoy
      ON sub_B1.customer_id = first_orders_fanjoy.customer_id -- link b1 to first orders by ID
        AND sub_B1.month = first_orders_fanjoy.first_order_month -- link b1 to first orders by month
  GROUP BY sub_B1.month
) as B
on A.month = B.month
ORDER BY A.month
;



/*
  New vs. Existing – Team 10
 */

SELECT
A.month,
A.total_customers,
A.total_orders,
A.total_sales,
B.new_customers,
B.new_orders,
B.new_sales,
(A.total_customers-B.new_customers) as existing_customers,
(A.total_orders-B.new_orders) as existing_orders,
(A.total_sales-B.new_sales) as existing_sales,
cast(B.new_customers as float)/A.total_customers as percent_new_customers,
cast(B.new_orders as float)/A.total_orders as percent_new_orders,
cast(B.new_sales as float)/A.total_sales as percent_new_sales

FROM
(
  SELECT
    sub_A1.month,
    COUNT(distinct sub_A1.customer_id) AS total_customers,
    COUNT(distinct sub_A2.order_number) as total_orders,
    SUM(sub_A2.total_sales) as total_sales
  FROM
    (
      SELECT
        date_trunc('month', created_at) as month,
        customer_id,
        order_number
      FROM fod_team10
    ) as sub_A1
    JOIN
    (
      SELECT
        order_number,
        sum(price) as total_sales
      FROM fld_team10
      GROUP BY order_number
    ) as sub_A2
    ON sub_A1.order_number = sub_A2.order_number
  GROUP BY sub_A1.month
) as A
JOIN
(
  SELECT
    sub_B1.month,
    COUNT(distinct sub_B1.customer_id) AS new_customers,
    COUNT(distinct sub_B2.order_number) as new_orders,
    SUM(sub_B2.total_sales) as new_sales
  FROM
    (
      SELECT
        date_trunc('month', created_at) as month,
        customer_id,
        order_number
      FROM fod_team10
    ) as sub_B1
    JOIN
    (
      SELECT
        order_number,
        sum(price) as total_sales
      FROM fld_team10
      GROUP BY order_number
    ) as sub_B2
      ON sub_B1.order_number = sub_B2.order_number -- link b1 to b2
    JOIN kevin_ip.first_orders_fanjoy
      ON sub_B1.customer_id = first_orders_fanjoy.customer_id -- link b1 to first orders by ID
        AND sub_B1.month = first_orders_fanjoy.first_order_month -- link b1 to first orders by month
  GROUP BY sub_B1.month
) as B
on A.month = B.month
ORDER BY A.month
;



/*
  New vs. Existing – Jake Paul
 */

SELECT
A.month,
A.total_customers,
A.total_orders,
A.total_sales,
B.new_customers,
B.new_orders,
B.new_sales,
(A.total_customers-B.new_customers) as existing_customers,
(A.total_orders-B.new_orders) as existing_orders,
(A.total_sales-B.new_sales) as existing_sales,
cast(B.new_customers as float)/A.total_customers as percent_new_customers,
cast(B.new_orders as float)/A.total_orders as percent_new_orders,
cast(B.new_sales as float)/A.total_sales as percent_new_sales

FROM
(
  SELECT
    sub_A1.month,
    COUNT(distinct sub_A1.customer_id) AS total_customers,
    COUNT(distinct sub_A2.order_number) as total_orders,
    SUM(sub_A2.total_sales) as total_sales
  FROM
    (
      SELECT
        date_trunc('month', created_at) as month,
        customer_id,
        order_number
      FROM fod_jakepaul
    ) as sub_A1
    JOIN
    (
      SELECT
        order_number,
        sum(price) as total_sales
      FROM fld_jakepaul
      GROUP BY order_number
    ) as sub_A2
    ON sub_A1.order_number = sub_A2.order_number
  GROUP BY sub_A1.month
) as A
JOIN
(
  SELECT
    sub_B1.month,
    COUNT(distinct sub_B1.customer_id) AS new_customers,
    COUNT(distinct sub_B2.order_number) as new_orders,
    SUM(sub_B2.total_sales) as new_sales
  FROM
    (
      SELECT
        date_trunc('month', created_at) as month,
        customer_id,
        order_number
      FROM fod_jakepaul
    ) as sub_B1
    JOIN
    (
      SELECT
        order_number,
        sum(price) as total_sales
      FROM fld_jakepaul
      GROUP BY order_number
    ) as sub_B2
      ON sub_B1.order_number = sub_B2.order_number -- link b1 to b2
    JOIN kevin_ip.first_orders_fanjoy
      ON sub_B1.customer_id = first_orders_fanjoy.customer_id -- link b1 to first orders by ID
        AND sub_B1.month = first_orders_fanjoy.first_order_month -- link b1 to first orders by month
  GROUP BY sub_B1.month
) as B
on A.month = B.month
ORDER BY A.month
;


