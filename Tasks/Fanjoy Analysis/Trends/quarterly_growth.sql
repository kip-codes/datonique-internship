
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
);



-----------------------------------------------------------------
/*
  ALL OF FANJOY
 */
-----------------------------------------------------------------

-- Q1 2018 sales
SELECT
  country,
  city,
  total_sales
FROM qtr_sales_fanjoy
WHERE year = 2018 and qtr = 1
;

-- Q4 2017 sales
SELECT
  country,
  city,
  total_sales
FROM qtr_sales_fanjoy
WHERE year = 2017 and qtr = 4
;


-- join Q1 '18 with Q4 '17
SELECT
  A.country,
  A.city,
  E.total_sales as sales_Q1_17,
  D.total_sales as sales_Q2_17,
  C.total_sales as sales_Q3_17,
  B.total_sales as sales_Q4_17,
  A.total_sales as sales_Q1_18
FROM (
  -- Q1 2018 sales
  SELECT
    country,
    city,
    total_sales
  FROM qtr_sales_fanjoy
  WHERE year = 2018 and qtr = 1
) A
JOIN (
  -- Q4 2017 sales
  SELECT
    country,
    city,
    total_sales
  FROM qtr_sales_fanjoy
  WHERE year = 2017 and qtr = 4
) B
  ON A.country = B.country
  AND A.city = B.city
JOIN (
  -- Q3 2017 sales
  SELECT
    country,
    city,
    total_sales
  FROM qtr_sales_fanjoy
  WHERE year = 2017 and qtr = 3
) C
  ON A.country = C.country
  AND A.city = C.city
JOIN (
  -- Q2 2017 sales
  SELECT
    country,
    city,
    total_sales
  FROM qtr_sales_fanjoy
  WHERE year = 2017 and qtr = 2
) D
  ON A.country = D.country
  AND A.city = D.city
JOIN (
  -- Q1 2017 sales
  SELECT
    country,
    city,
    total_sales
  FROM qtr_sales_fanjoy
  WHERE year = 2017 and qtr = 1
) E
  ON A.country = E.country
  AND A.city = E.city
;


-----------------------------------------------------------------
/*
  TEAM 10
 */
-----------------------------------------------------------------

-- join Q1 '18 with Q4 '17
SELECT
  A.country,
  A.city,
  E.total_sales as sales_Q1_17,
  D.total_sales as sales_Q2_17,
  C.total_sales as sales_Q3_17,
  B.total_sales as sales_Q4_17,
  A.total_sales as sales_Q1_18
FROM (
  -- Q1 2018 sales
  SELECT
    country,
    city,
    total_sales
  FROM qtr_sales_team10
  WHERE year = 2018 and qtr = 1
) A
JOIN (
  -- Q4 2017 sales
  SELECT
    country,
    city,
    total_sales
  FROM qtr_sales_team10
  WHERE year = 2017 and qtr = 4
) B
  ON A.country = B.country
  AND A.city = B.city
JOIN (
  -- Q3 2017 sales
  SELECT
    country,
    city,
    total_sales
  FROM qtr_sales_team10
  WHERE year = 2017 and qtr = 3
) C
  ON A.country = C.country
  AND A.city = C.city
JOIN (
  -- Q2 2017 sales
  SELECT
    country,
    city,
    total_sales
  FROM qtr_sales_team10
  WHERE year = 2017 and qtr = 2
) D
  ON A.country = D.country
  AND A.city = D.city
JOIN (
  -- Q1 2017 sales
  SELECT
    country,
    city,
    total_sales
  FROM qtr_sales_team10
  WHERE year = 2017 and qtr = 1
) E
  ON A.country = E.country
  AND A.city = E.city
;

-----------------------------------------------------------------
/*
  JAKE PAUL, ONLY
 */
-----------------------------------------------------------------

-- join Q1 '18 with Q4 '17
SELECT
  A.country,
  A.city,
  E.total_sales as sales_Q1_17,
  D.total_sales as sales_Q2_17,
  C.total_sales as sales_Q3_17,
  B.total_sales as sales_Q4_17,
  A.total_sales as sales_Q1_18
FROM (
  -- Q1 2018 sales
  SELECT
    country,
    city,
    total_sales
  FROM qtr_sales_jake
  WHERE year = 2018 and qtr = 1
) A
JOIN (
  -- Q4 2017 sales
  SELECT
    country,
    city,
    total_sales
  FROM qtr_sales_jake
  WHERE year = 2017 and qtr = 4
) B
  ON A.country = B.country
  AND A.city = B.city
JOIN (
  -- Q3 2017 sales
  SELECT
    country,
    city,
    total_sales
  FROM qtr_sales_jake
  WHERE year = 2017 and qtr = 3
) C
  ON A.country = C.country
  AND A.city = C.city
JOIN (
  -- Q2 2017 sales
  SELECT
    country,
    city,
    total_sales
  FROM qtr_sales_jake
  WHERE year = 2017 and qtr = 2
) D
  ON A.country = D.country
  AND A.city = D.city
JOIN (
  -- Q1 2017 sales
  SELECT
    country,
    city,
    total_sales
  FROM qtr_sales_jake
  WHERE year = 2017 and qtr = 1
) E
  ON A.country = E.country
  AND A.city = E.city
;