
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
ORDER BY A.total_sales DESC
LIMIT 10
;





------------------------------------------------------------
------------------------------------------------------------



SELECT
  CASE
    WHEN total_sales = 0 then '0'
    WHEN total_sales > 0 and total_sales <= 500 then '500'
    WHEN total_sales > 500 and total_sales <= 1000 then '1000'
    WHEN total_sales > 1000 and total_sales <= 1500 then '1500'
    WHEN total_sales > 1500 then '1500+'
  END AS total_sales_dist,
  COUNT(*) as num_countries
FROM (
  SELECT
    country,
    sum(total_sales) AS total_sales
  FROM qtr_sales_jake
  WHERE qtr = 1 and year = 2018
  GROUP BY 1
) D
GROUP BY 1
ORDER BY 1;



SELECT
  A.country,
--   A.city,
  B.sum as q1_17,
  A.sum as q1_18
--   (SUM(A.total_sales)-SUM(B.total_sales))/SUM(B.total_sales) + 1 as gr
FROM
  (
  -- Q1 2018 sales
  SELECT
    country,
--     city,
    sum(total_sales) as sum
  FROM qtr_sales_jake
  WHERE year = 2018 and qtr = 1
  GROUP BY 1
  ) A
  JOIN (
  -- Q1 2017 sales
  SELECT
    country,
--     city,
    sum(total_sales) AS sum
  FROM qtr_sales_jake
  WHERE year = 2017 and qtr = 1
  GROUP BY 1
  ) B
  ON A.country = B.country
--      AND A.city = B.city
-- WHERE
--   A.country ilike '%united%states%'
-- GROUP BY 1
ORDER BY A.sum DESC
LIMIT 20
;





select
country,
sum(total_sales) as total_sales
from kevin_ip.qtr_sales_jake
where year in (2018) and qtr=1
group by 1
order by total_sales DESC;