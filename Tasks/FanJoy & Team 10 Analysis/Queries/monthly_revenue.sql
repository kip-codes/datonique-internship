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