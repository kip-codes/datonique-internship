
/*
  Analyze quarterly (Q1 to Q4) growth in sales by Country and City.
  Then, compare Q1 to Q4 of previous year.
 */


-- All of Fanjoy
CREATE VIEW kevin_ip.qtr_sales_fanjoy AS
  (
    SELECT
      country,
      city,
      extract(QUARTER FROM date) AS qtr,
      extract(YEAR FROM date)    AS year,
      sum(sales)                 AS total_sales
    FROM
      (
        SELECT DISTINCT
          order_number,
          created_at AS date,
          customer_id
        FROM fanjoy_orders_data
      ) AS A
      JOIN
      (
        SELECT
          order_number,
          SUM(price) AS sales
        FROM fanjoy_lineitems_data
        GROUP BY order_number
      ) AS B
        ON A.order_number = B.order_number
      JOIN
      (
        SELECT DISTINCT
          id,
          initcap(trim(country)) as country,
          initcap(trim(city)) as city
        FROM fanjoy_customers_data
        WHERE
          country IS NOT NULL
          AND city IS NOT NULL
      ) AS C
        ON A.customer_ID = C.id
    GROUP BY 1, 2, 3, 4
    ORDER BY country, city, year, qtr
);



-- Team 10
-- Pull from all Fanjoy orders if fod does not capture
CREATE VIEW kevin_ip.qtr_sales_team10 AS
  (
    SELECT
      country,
      city,
      extract(QUARTER FROM date) AS qtr,
      extract(YEAR FROM date)    AS year,
      sum(sales)                 AS total_sales
    FROM
      (
        SELECT DISTINCT
          order_number,
          created_at AS date,
          customer_id
        FROM fod_team10
      ) AS A
      JOIN
      (
        SELECT
          order_number,
          SUM(price) AS sales
        FROM fld_team10
        GROUP BY order_number
      ) AS B
        ON A.order_number = B.order_number
      JOIN
      (
        SELECT DISTINCT
          id,
          initcap(trim(country)) as country,
          initcap(trim(city)) as city
        FROM fanjoy_customers_data
        WHERE
          country IS NOT NULL
          AND city IS NOT NULL
      ) AS C
        ON A.customer_ID = C.id
    GROUP BY 1, 2, 3, 4
    ORDER BY year, qtr
);


-- Jake Paul only
-- Pull from all Fanjoy orders if fod does not capture
CREATE VIEW kevin_ip.qtr_sales_jake AS
  (
    SELECT
      country,
      city,
      extract(QUARTER FROM date) AS qtr,
      extract(YEAR FROM date)    AS year,
      sum(sales)                 AS total_sales
    FROM
      (
        SELECT DISTINCT
          order_number,
          created_at AS date,
          customer_id
        FROM fod_jakepaul
      ) AS A
      JOIN
      (
        SELECT
          order_number,
          SUM(price) AS sales
        FROM fld_jakepaul
        GROUP BY order_number
      ) AS B
        ON A.order_number = B.order_number
      JOIN
      (
        SELECT DISTINCT
          id,
          initcap(trim(country)) as country,
          initcap(trim(city)) as city
        FROM fanjoy_customers_data
        WHERE
          country IS NOT NULL
          AND city IS NOT NULL
      ) AS C
        ON A.customer_ID = C.id
    GROUP BY 1, 2, 3, 4
    ORDER BY year, qtr
)


