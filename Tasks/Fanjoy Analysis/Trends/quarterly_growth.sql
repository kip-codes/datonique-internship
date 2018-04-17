
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