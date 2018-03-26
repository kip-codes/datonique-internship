-- query the fanjoy data and give me customers, orders, sales on a daily basis
-- for jake's merch items that have the string 'lambro' in them?
-- give it to me by merch item as well as daily


-- all entries
SELECT DISTINCT date_trunc('day',fod.created_at) AS date,
  fld.name as product_name,
  SUM(fld.price) AS total_sales,
  count(fod.customer_id) AS num_cust,
  count(fod.order_number) AS order_count
FROM kevin_ip.fod_team10 fod
  JOIN kevin_ip.fld_team10 fld
    ON fod.order_number = fld.order_number
      AND lower(fld.name) like '%lambro%'
-- WHERE fod.order_number IN
--       (
--         SELECT DISTINCT fld.order_number
--         FROM kevin_ip.fld_team10 fld
--         WHERE (lower(fld.name) like '%lambro%')
--       )
GROUP BY date_trunc('day',created_at), fld.name
ORDER BY date
LIMIT 15;


-- grouped by day only
SELECT DISTINCT date_trunc('day',fod.created_at) AS date,
  fld.name as product_name,
  SUM(fld.price) AS total_sales,
  count(DISTINCT fod.customer_id) AS num_cust,
  count(DISTINCT fod.order_number) AS order_count
FROM kevin_ip.fod_team10 fod
  JOIN kevin_ip.fld_team10 fld
    ON fod.order_number = fld.order_number
      AND lower(fld.name) like '%lambro%'
GROUP BY date_trunc('day',created_at), fld.name
ORDER BY date;

CREATE VIEW kevin_ip.lambro_sales AS
  (
    SELECT DISTINCT date_trunc('day',fod.created_at) AS date,
      fld.name as product_name,
      SUM(fld.price) AS total_sales,
      count(DISTINCT fod.customer_id) AS num_cust,
      count(DISTINCT fod.order_number) AS order_count
    FROM kevin_ip.fod_team10 fod
      JOIN kevin_ip.fld_team10 fld
        ON fod.order_number = fld.order_number
          AND lower(fld.name) like '%lambro%'
    GROUP BY date_trunc('day',created_at), fld.name
    ORDER BY date
  );