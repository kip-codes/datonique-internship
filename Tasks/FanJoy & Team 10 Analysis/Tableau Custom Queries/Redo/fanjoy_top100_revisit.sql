/*
2. Identify Jake/Team 10's biggest buyer(s) -- maybe we should do this on a quarterly basis.
Would be good to see who the biggest purchasers are (maybe we split this into a geo infographic)
 */

/*
  FANJOY TALENT:

    1. Jake Paul DONE
    2. Erika Costell DONE
    3. Nick Crompton DONE
    4. Ben Hampton
    5. Chance & Anthony

 */


-- Fanjoy lifetime Top 100, Revisit
SELECT DISTINCT
  B.id,
  B.name,
  B.email,
  B.country,
  B.city,
  count(distinct A.order_number) as "Number of Orders",
  sum(C.sales) as "Total Sales"
FROM
  (
    (
      SELECT
        order_number,
        customer_id
      FROM fanjoy_orders_data
    ) AS A
    JOIN
    (
      SELECT
        id,
        initcap(first_name) + ' ' + initcap(last_name) AS name,
        email,
        initcap(country) as country,
        initcap(city) as city
      FROM fanjoy_customers_data
    ) AS B
      ON A.customer_id = B.id
    JOIN
    (
      SELECT
        order_number,
        sum(price) AS sales
      FROM fanjoy_lineitems_data
      GROUP BY order_number
    ) AS C
      ON A.order_number = C.order_number
  )
WHERE
    customer_id IS NOT NULL
    AND customer_id > 0
    AND email IS NOT NULL
    AND country IS NOT NULL
    AND city IS NOT NULL
GROUP BY id, name, email, country, city
ORDER BY "Total Sales" DESC
LIMIT 100
;


-- Team 10 Lifetime Top 100, Revisit
SELECT DISTINCT
  B.id,
  B.name,
  B.email,
  B.country,
  B.city,
  count(distinct A.order_number) as "Number of Orders",
  sum(C.sales) as "Total Sales"
FROM
  (
    (
      SELECT
        order_number,
        customer_id
      FROM fod_team10
    ) AS A
    JOIN
    (
      SELECT
        id,
        initcap(first_name) + ' ' + initcap(last_name) AS name,
        email,
        country,
        city
      FROM fanjoy_customers_data
    ) AS B
      ON A.customer_id = B.id
    JOIN
    (
      SELECT
        order_number,
        sum(price) AS sales
      FROM fld_team10
      GROUP BY order_number
    ) AS C
      ON A.order_number = C.order_number
  )
WHERE customer_id IS NOT NULL and customer_id > 0 AND email IS NOT NULL
GROUP BY id, name, email, country, city
ORDER BY "Total Sales" DESC
LIMIT 100
;


-- Jake Paul Lifetime Top 100, Revisit
SELECT DISTINCT
  B.id,
  B.name,
  B.email,
  B.country,
  B.city,
  count(distinct A.order_number) as "Number of Orders",
  sum(C.sales) as "Total Sales"
FROM
  (
    (
      SELECT
        order_number,
        customer_id
      FROM fod_jakepaul
    ) AS A
    JOIN
    (
      SELECT
        id,
        initcap(first_name) + ' ' + initcap(last_name) AS name,
        email,
        country,
        city
      FROM fanjoy_customers_data
    ) AS B
      ON A.customer_id = B.id
    JOIN
    (
      SELECT
        order_number,
        sum(price) AS sales
      FROM fld_jakepaul
      GROUP BY order_number
    ) AS C
      ON A.order_number = C.order_number
  )
WHERE customer_id IS NOT NULL and customer_id > 0 AND email IS NOT NULL
GROUP BY id, name, email, country, city
ORDER BY "Total Sales" DESC
LIMIT 100
;

-- take from Team 10 Orders table to catch all
-- Erika Costell Lifetime Top 100, Revisit
SELECT DISTINCT
  B.id,
  B.name,
  B.email,
  B.country,
  B.city,
  count(distinct A.order_number) as "Number of Orders",
  sum(C.sales) as "Total Sales"
FROM
  (
    (
      SELECT
        order_number,
        customer_id
      FROM fod_team10
    ) AS A
    JOIN
    (
      SELECT
        id,
        initcap(first_name) + ' ' + initcap(last_name) AS name,
        email,
        country,
        city
      FROM fanjoy_customers_data
    ) AS B
      ON A.customer_id = B.id
    JOIN
    (
      SELECT
        order_number,
        sum(price) AS sales
      FROM fld_team10_nojake
      WHERE
        title ilike '%erika%'
        or name ilike '%erika%'
      GROUP BY order_number
    ) AS C
      ON A.order_number = C.order_number
  )
WHERE customer_id IS NOT NULL and customer_id > 0 AND email IS NOT NULL
GROUP BY id, name, email, country, city
ORDER BY "Total Sales" DESC
LIMIT 100
;


-- take from Team 10 Orders table to catch all
-- Nick Crompton Lifetime Top 100, Revisit
SELECT DISTINCT
  B.id,
  B.name,
  B.email,
  B.country,
  B.city,
  count(distinct A.order_number) as "Number of Orders",
  sum(C.sales) as "Total Sales"
FROM
  (
    (
      SELECT
        order_number,
        customer_id
      FROM fod_team10
    ) AS A
    JOIN
    (
      SELECT
        id,
        initcap(first_name) + ' ' + initcap(last_name) AS name,
        email,
        country,
        city
      FROM fanjoy_customers_data
    ) AS B
      ON A.customer_id = B.id
    JOIN
    (
      SELECT
        order_number,
        sum(price) AS sales
      FROM fld_team10_nojake
      WHERE
        title ilike '%nick%crompton%'
        or name ilike '%nick%crompton%'
      GROUP BY order_number
    ) AS C
      ON A.order_number = C.order_number
  )
WHERE customer_id IS NOT NULL and customer_id > 0 AND email IS NOT NULL
GROUP BY id, name, email, country, city
ORDER BY "Total Sales" DESC
LIMIT 100
;


-- take from Team 10 Orders table to catch all
-- Ben Hampton Lifetime Top 100, Revisit
SELECT DISTINCT
  B.id,
  B.name,
  B.email,
  B.country,
  B.city,
  count(distinct A.order_number) as "Number of Orders",
  sum(C.sales) as "Total Sales"
FROM
  (
    (
      SELECT
        order_number,
        customer_id
      FROM fod_team10
    ) AS A
    JOIN
    (
      SELECT
        id,
        initcap(first_name) + ' ' + initcap(last_name) AS name,
        email,
        country,
        city
      FROM fanjoy_customers_data
    ) AS B
      ON A.customer_id = B.id
    JOIN
    (
      SELECT
        order_number,
        sum(price) AS sales
      FROM fld_team10_nojake
      WHERE
        title ilike '%ben%hampton%'
        or name ilike '%ben%hampton%'
      GROUP BY order_number
    ) AS C
      ON A.order_number = C.order_number
  )
WHERE customer_id IS NOT NULL and customer_id > 0 AND email IS NOT NULL
GROUP BY id, name, email, country, city
ORDER BY "Total Sales" DESC
LIMIT 100
;


-- take from Team 10 Orders table to catch all
-- Chance & Anthony Lifetime Top 100, Revisit
SELECT DISTINCT
  B.id,
  B.name,
  B.email,
  B.country,
  B.city,
  count(distinct A.order_number) as "Number of Orders",
  sum(C.sales) as "Total Sales"
FROM
  (
    (
      SELECT
        order_number,
        customer_id
      FROM fod_team10
    ) AS A
    JOIN
    (
      SELECT
        id,
        initcap(first_name) + ' ' + initcap(last_name) AS name,
        email,
        country,
        city
      FROM fanjoy_customers_data
    ) AS B
      ON A.customer_id = B.id
    JOIN
    (
      SELECT
        order_number,
        sum(price) AS sales
      FROM fld_team10_nojake
      WHERE
        title ilike '%chance%&%anthony%'
        or name ilike '%chance%&%anthony%'
      GROUP BY order_number
    ) AS C
      ON A.order_number = C.order_number
  )
WHERE customer_id IS NOT NULL and customer_id > 0 AND email IS NOT NULL
GROUP BY id, name, email, country, city
ORDER BY "Total Sales" DESC
LIMIT 100
;

