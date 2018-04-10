

----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
/*
  Geo Breakdown by Country and City

  Table/View Dependencies:
    kevin_ip.fod/fld_{Team 10, Jake Paul, Team 10 excl. Jake}: Base data extract
    fanjoy_customers_data: Country and City extract
 */
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------


/*
  Geo Breakdown – All of Fanjoy
 */

SELECT
  trim(country) as country,
  trim(city) as city,
  sum(total_sales) as total_sales,
  count(distinct B.customer_id) as total_customers,
  count(distinct A.order_number) as total_orders
FROM
  -- Line items
  (
    SELECT
      order_number,
      SUM(price) as total_sales
    FROM fanjoy_lineitems_data
    GROUP BY order_number
  ) as A
  JOIN
  -- Orders data
  (
    SELECT
      order_number,
      customer_id
    FROM fanjoy_orders_data
  ) AS B
  ON A.order_number = B.order_number
  -- Customer data
  JOIN
  (
    SELECT
      id,
      country,
      city
    FROM fanjoy_customers_data
  ) AS C
  ON B.customer_id = C.id
GROUP BY
  country,
  city
;



/*
  Geo Breakdown – Team 10
 */

SELECT
  trim(country) as country,
  trim(city) as city,
  sum(total_sales) as total_sales,
  count(distinct B.customer_id) as total_customers,
  count(distinct A.order_number) as total_orders
FROM
  -- Line items
  (
    SELECT
      order_number,
      SUM(price) as total_sales
    FROM fld_team10
    GROUP BY order_number
  ) as A
  JOIN
  -- Orders data
  (
    SELECT
      order_number,
      customer_id
    FROM fod_team10
  ) AS B
  ON A.order_number = B.order_number
  -- Customer data
  JOIN
  (
    SELECT
      id,
      country,
      city
    FROM fanjoy_customers_data
  ) AS C
  ON B.customer_id = C.id
GROUP BY
  country,
  city
;

/*
  Geo Breakdown – Jake Paul
 */

SELECT
  trim(country) as country,
  trim(city) as city,
  sum(total_sales) as total_sales,
  count(distinct B.customer_id) as total_customers,
  count(distinct A.order_number) as total_orders
FROM
  -- Line items
  (
    SELECT
      order_number,
      SUM(price) as total_sales
    FROM fld_jakepaul
    GROUP BY order_number
  ) as A
  JOIN
  -- Orders data
  (
    SELECT
      order_number,
      customer_id
    FROM fod_jakepaul
  ) AS B
  ON A.order_number = B.order_number
  -- Customer data
  JOIN
  (
    SELECT
      id,
      country,
      city
    FROM fanjoy_customers_data
  ) AS C
  ON B.customer_id = C.id
GROUP BY
  country,
  city
;


/*
  Geo Breakdown – Team 10 excl. Jake Paul
 */

SELECT
  trim(country) as country,
  trim(city) as city,
  sum(total_sales) as total_sales,
  count(distinct B.customer_id) as total_customers,
  count(distinct A.order_number) as total_orders
FROM
  -- Line items
  (
    SELECT
      order_number,
      SUM(price) as total_sales
    FROM fld_team10_nojake
    GROUP BY order_number
  ) as A
  JOIN
  -- Orders data
  (
    SELECT
      order_number,
      customer_id
    FROM fod_team10_nojake
  ) AS B
  ON A.order_number = B.order_number
  -- Customer data
  JOIN
  (
    SELECT
      id,
      country,
      city
    FROM fanjoy_customers_data
  ) AS C
  ON B.customer_id = C.id
GROUP BY
  country,
  city
;