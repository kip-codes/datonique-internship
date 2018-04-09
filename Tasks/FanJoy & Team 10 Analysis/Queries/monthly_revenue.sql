/*

can you run the revenue for Team 10 and Nick Crompton over the last 12 months and give me the revenue by month
as well as the average monthly revenue for Team 10 and Nick Crompton separately?

*/

SELECT
  extract(year from created_at) as year,
  extract(month from created_at) as month,
  SUM(total_price_usd)
FROM kevin_ip.fod_team10
WHERE
  created_at <= current_timestamp
  and created_at >= current_timestamp - INTEGER '365'
GROUP BY extract(year from created_at),
  extract(month from created_at)
ORDER BY extract(year from created_at) DESC,
  extract(month from created_at) DESC
;

SELECT
  SUM(total_price_usd) / 12 as avg_monthly_revenue
FROM kevin_ip.fod_team10
WHERE
  created_at <= current_timestamp
  and created_at >= current_timestamp - INTEGER '365'
;


SELECT
  extract(year from created_at) as year,
  extract(month from created_at) as month,
  SUM(total_price_usd)
FROM kevin_ip.fod_team10 fod
WHERE
  fod.order_number IN
  (
    SELECT DISTINCT order_number
    FROM kevin_ip.fld_team10 fld
    WHERE lower(fld.name) like '%nick%crompton%'
  )
  and created_at <= current_timestamp
  and created_at >= current_timestamp - INTEGER '365'
GROUP BY extract(year from created_at),
  extract(month from created_at)
ORDER BY extract(year from created_at) DESC,
  extract(month from created_at) DESC
;

SELECT SUM(total_price_usd) / 12 as avg
FROM kevin_ip.fod_team10 fod
WHERE
  fod.order_number IN
  (
    SELECT DISTINCT order_number
    FROM kevin_ip.fld_team10 fld
    WHERE lower(fld.name) LIKE '%nick%crompton%'
  )
  and created_at <= current_timestamp
  and created_at >= current_timestamp - INTEGER '365'
;



SELECT
  extract(year from created_at) as year,
  extract(month from created_at) as month,
  SUM(total_price_usd)
FROM kevin_ip.fod_team10 fod
WHERE
  fod.order_number IN
  (
    SELECT DISTINCT fld.order_number
    FROM kevin_ip.fld_team10 fld
    WHERE lower(fld.name) LIKE '%jake%paul%'
  )
  and created_at <= current_timestamp
  and created_at >= current_timestamp - INTEGER '365'
GROUP BY extract(year from created_at),
  extract(month from created_at)
ORDER BY extract(year from created_at) DESC,
  extract(month from created_at) DESC
;

SELECT SUM(total_price_usd) / 12 as avg
FROM kevin_ip.fod_team10 fod
WHERE
  fod.order_number IN
  (
    SELECT DISTINCT fld.order_number
    FROM kevin_ip.fld_team10 fld
    WHERE lower(fld.name) LIKE '%jake%paul%'
  )
  and created_at <= current_timestamp
  and created_at >= current_timestamp - INTEGER '365'
;


SELECT
  extract(year from created_at) as year,
  extract(month from created_at) as month,
  SUM(total_price_usd)
FROM kevin_ip.fod_team10 fod
WHERE
  fod.order_number NOT IN
  (
    SELECT DISTINCT fld.order_number
    FROM kevin_ip.fld_team10 fld
    WHERE lower(fld.name) LIKE '%jake%paul%'
  )
  and created_at <= current_timestamp
  and created_at >= current_timestamp - INTEGER '365'
GROUP BY extract(year from created_at),
  extract(month from created_at)
ORDER BY extract(year from created_at) DESC,
  extract(month from created_at) DESC
;

SELECT
  SUM(total_price_usd) / 12 as avg_monthly_revenue
FROM kevin_ip.fod_team10 fod
WHERE
  fod.order_number NOT IN
  (
    SELECT DISTINCT fld.order_number
    FROM kevin_ip.fld_team10 fld
    WHERE lower(fld.name) LIKE '%jake%paul%'
  )
  and created_at <= current_timestamp
  and created_at >= current_timestamp - INTEGER '365'
;




------------------------------------------------------------------------
------------------------------------------------------------------------

/*

can you run the revenue for Team 10 and Nick Crompton over the last 12 months and give me the revenue by month
as well as the average monthly revenue for Team 10 and Nick Crompton separately?

*/

-- All of Team 10 Revenue
SELECT
  fld.title as title,
  SUM(fld.quantity) as qty,
  SUM(price) as total_price
FROM fld_team10 fld
GROUP BY
  fld.title
ORDER BY
  total_price DESC
;
-- $18M vs Shopify $28M

-- Nick Crompton only Revenue
SELECT
  fld.title as title,
  sum(fld.quantity) as qty,
  SUM(price) as total_price
FROM fld_team10 fld
WHERE
      lower(fld.title) LIKE '%nick%crompton%'
GROUP BY fld.title
ORDER BY total_price DESC
;
-- $50K vs Shopify $48k



-- Team 10, excl. Jake Paul Revenue
SELECT
  fld.title as title,
  sum(fld.quantity) as qty,
  sum(price) as total_price
FROM fld_team10_nojake fld
GROUP BY fld.title
ORDER BY total_price DESC
;


-- Jake Paul only
SELECT
  fld.title as title,
  sum(fld.quantity) as qty,
  sum(price) as total_price
FROM fld_team10 fld
WHERE lower(fld.title) LIKE '%jake%paul%'
GROUP BY fld.title
ORDER BY total_price DESC
;

SELECT
  fld.title as title,
  sum(fld.quantity) as qty,
  sum(price) as total_price
FROM fld_jakepaul fld
GROUP BY fld.title
ORDER BY total_price DESC