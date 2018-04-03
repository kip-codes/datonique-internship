
--------------------------------------------------------------------
--------------------------------------------------------------------
/*

  BASE VIEWS FOR LINE ITEMS AND ORDERS

 */



-- View of all Team 10 line items
CREATE VIEW kevin_ip.fld_team10 AS
  (
    SELECT *
    FROM fanjoy_lineitems_data fld
    WHERE (lower(fld.name) like '%erika%'
       or lower(fld.name) like '%team%10%'
       or lower(fld.name) like '%chance%'
       or lower(fld.name) like '%anthony%'
       or lower(fld.name) like '%nick%crompton%'
       or lower(fld.name) like '%jake%paul%'
       or lower(fld.name) like '%ben%hampton%'
       or lower(fld.vendor) like '%jake%paul%'
       or lower(fld.vendor) like '%team%10%')
  );


-- View of all orders placed containing Team 10 line items
CREATE VIEW kevin_ip.fod_team10 AS
  (
    SELECT fod.*
    FROM fanjoy_orders_data fod
    WHERE fod.order_number IN
          (
            SELECT DISTINCT fld_team10.order_number
            FROM kevin_ip.fld_team10
          )
  );


-- View of all customers linked to orders placed containing Jake line items
CREATE VIEW kevin_ip.fcd_team10 AS
  (
      SELECT fcd.*
      FROM fanjoy_customers_data fcd
      WHERE fcd.id IN
            (
              SELECT distinct fod_team10.customer_id
              FROM kevin_ip.fod_team10
            )
--       AND fcd.total_spent > 0
  );



-- View of all Jake line items
CREATE VIEW kevin_ip.fld_jakepaul AS
  (
    SELECT *
    FROM kevin_ip.fld_team10 fld
    WHERE
      (
        lower(fld.name) like '%jake%paul%'
        or lower(fld.vendor) like '%jake%paul%'
      )
  )
;


-- View of all orders placed containing Jake line items
CREATE VIEW kevin_ip.fod_jakepaul AS
  (
    SELECT fod.*
    FROM kevin_ip.fod_team10 fod
    WHERE fod.order_number IN
          (
            SELECT DISTINCT fld.order_number
            FROM kevin_ip.fld_jakepaul fld
          )
  )
;


-- View of all Team 10, no Jake line items
CREATE VIEW kevin_ip.fld_team10_nojake AS
  (
    SELECT *
    FROM kevin_ip.fld_team10 fld
    WHERE fld.order_number NOT IN
          (
            SELECT DISTINCT order_number
            FROM kevin_ip.fld_jakepaul
          )

  )
;


-- View of all orders placed containing Team 10, no Jake line items
CREATE VIEW kevin_ip.fod_team10_nojake AS
  (
    SELECT fod.*
    FROM kevin_ip.fod_team10 fod
    WHERE fod.order_number IN
          (
            SELECT DISTINCT order_number
            FROM kevin_ip.fld_team10_nojake
          )
  )
;

--------------------------------------------------------------------
--------------------------------------------------------------------
/*

  CUSTOMER DISTRIBUTION BY ORDER COUNT

 */



-- FanJoy Distribution, fixed
CREATE VIEW kevin_ip.dist_fanjoy AS
  (
    SELECT
      CASE
        WHEN cast(total_orders AS INT) = 1
          THEN '1'
        WHEN cast(total_orders AS INT) = 2
          THEN '2'
        WHEN cast(total_orders AS INT) = 3
          THEN '3'
        WHEN cast(total_orders AS INT) = 4
          THEN '4'
        ELSE '5+'
      END AS orders_count,
      COUNT(DISTINCT customer_id) AS customers,
      SUM(total_spent) AS total_spent,

      SUM(total_orders) AS total_orders,

      cast(cast(COUNT(DISTINCT fod_data.customer_id) AS FLOAT)
           /(SELECT COUNT(distinct fod.customer_id) FROM fanjoy_orders_data fod) AS DECIMAL(5, 4))
        AS percent_total_customers,

      cast(cast(SUM(total_spent) AS FLOAT)
           /(SELECT SUM(total_price_usd) FROM fanjoy_orders_data
           ) AS DECIMAL(5, 4)) AS percent_total_spent,
-- --
      cast(cast(SUM(total_orders) AS FLOAT)
           /(SELECT count(DISTINCT fod2.order_number) FROM fanjoy_orders_data fod2
          ) AS DECIMAL(5, 4)) AS percent_total_orders,
--
      cast(SUM(total_spent) / cast(SUM(total_orders) AS FLOAT) AS DECIMAL(5, 2)) AS avg_order_size
    FROM
      (
        SELECT
          customer_id,
          count(DISTINCT order_number) AS total_orders, -- all total orders
          sum(total_price_usd)         AS total_spent -- everything spent per customer
        FROM fanjoy_orders_data
        GROUP BY customer_id
        ORDER BY 3 DESC -- some orders have $0 spent
      ) AS fod_data
    GROUP BY 1
    ORDER BY 1
  );



-- Team 10 Distribution, fixed
CREATE VIEW kevin_ip.dist_team10 AS
  (
    SELECT
      CASE
        WHEN cast(total_orders AS INT) = 1
          THEN '1'
        WHEN cast(total_orders AS INT) = 2
          THEN '2'
        WHEN cast(total_orders AS INT) = 3
          THEN '3'
        WHEN cast(total_orders AS INT) = 4
          THEN '4'
        ELSE '5+'
      END AS orders_count,
      COUNT(DISTINCT customer_id) AS customers,
      SUM(total_spent) AS total_spent,

      SUM(total_orders) AS total_orders,

      cast(cast(COUNT(DISTINCT fod_data.customer_id) AS FLOAT)
           /(SELECT COUNT(distinct fod.customer_id) FROM kevin_ip.fod_team10 fod) AS DECIMAL(5, 4))
        AS percent_total_customers,

      cast(cast(SUM(total_spent) AS FLOAT)
           /(SELECT SUM(total_price_usd) FROM kevin_ip.fod_team10
           ) AS DECIMAL(5, 4)) AS percent_total_spent,
-- --
      cast(cast(SUM(total_orders) AS FLOAT)
           /(SELECT count(DISTINCT fod2.order_number) FROM kevin_ip.fod_team10 fod2
          ) AS DECIMAL(5, 4)) AS percent_total_orders,
--
      cast(SUM(total_spent) / cast(SUM(total_orders) AS FLOAT) AS DECIMAL(5, 2)) AS avg_order_size
    FROM
      (
        SELECT
          customer_id,
          count(DISTINCT order_number) AS total_orders, -- all total orders
          sum(total_price_usd)         AS total_spent -- everything spent per customer
        FROM kevin_ip.fod_team10
        GROUP BY customer_id
        ORDER BY 3 DESC -- some orders have $0 spent
      ) AS fod_data
    GROUP BY 1
    ORDER BY 1
  );


CREATE VIEW kevin_ip.dist_jakepaul AS
  (
    SELECT
      CASE
        WHEN cast(total_orders AS INT) = 1
          THEN '1'
        WHEN cast(total_orders AS INT) = 2
          THEN '2'
        WHEN cast(total_orders AS INT) = 3
          THEN '3'
        WHEN cast(total_orders AS INT) = 4
          THEN '4'
        ELSE '5+'
      END AS orders_count,
      COUNT(DISTINCT customer_id) AS customers,
      SUM(total_spent) AS total_spent,

      SUM(total_orders) AS total_orders,

      cast(cast(COUNT(DISTINCT fod_data.customer_id) AS FLOAT)
           /(SELECT COUNT(distinct fod.customer_id) FROM kevin_ip.fod_jakepaul fod) AS DECIMAL(5, 4))
        AS percent_total_customers,

      cast(cast(SUM(fod_data.total_spent) AS FLOAT)
           /(SELECT SUM(fod2.total_price_usd) FROM kevin_ip.fod_jakepaul fod2
           ) AS DECIMAL(5, 4)) AS percent_total_spent,
-- --
      cast(cast(SUM(fod_data.total_orders) AS FLOAT)
           /(SELECT count(DISTINCT fod3.order_number) FROM kevin_ip.fod_jakepaul fod3
          ) AS DECIMAL(5, 4)) AS percent_total_orders,
--
      cast(SUM(total_spent) / cast(SUM(total_orders) AS FLOAT) AS DECIMAL(5, 2)) AS avg_order_size
    FROM
      (
        SELECT
          customer_id,
          count(DISTINCT order_number) AS total_orders, -- all total orders
          sum(total_price_usd)         AS total_spent -- everything spent per customer
        FROM kevin_ip.fod_jakepaul
        GROUP BY customer_id
        ORDER BY 3 DESC -- some orders have $0 spent
      ) AS fod_data
    GROUP BY 1
    ORDER BY 1
  );


CREATE VIEW kevin_ip.dist_team10_nojake AS
  (
    SELECT
      CASE
        WHEN cast(total_orders AS INT) = 1
          THEN '1'
        WHEN cast(total_orders AS INT) = 2
          THEN '2'
        WHEN cast(total_orders AS INT) = 3
          THEN '3'
        WHEN cast(total_orders AS INT) = 4
          THEN '4'
        ELSE '5+'
      END AS orders_count,
      COUNT(DISTINCT customer_id) AS customers,
      SUM(total_spent) AS total_spent,

      SUM(total_orders) AS total_orders,

      cast(cast(COUNT(DISTINCT fod_data.customer_id) AS FLOAT)
           /(SELECT COUNT(distinct fod.customer_id) FROM kevin_ip.fod_team10_nojake fod) AS DECIMAL(5, 4))
        AS percent_total_customers,

      cast(cast(SUM(fod_data.total_spent) AS FLOAT)
           /(SELECT SUM(fod2.total_price_usd) FROM kevin_ip.fod_team10_nojake fod2
           ) AS DECIMAL(5, 4)) AS percent_total_spent,
-- --
      cast(cast(SUM(fod_data.total_orders) AS FLOAT)
           /(SELECT count(DISTINCT fod3.order_number) FROM kevin_ip.fod_team10_nojake fod3
          ) AS DECIMAL(5, 4)) AS percent_total_orders,
--
      cast(SUM(total_spent) / cast(SUM(total_orders) AS FLOAT) AS DECIMAL(5, 2)) AS avg_order_size
    FROM
      (
        SELECT
          customer_id,
          count(DISTINCT order_number) AS total_orders, -- all total orders
          sum(total_price_usd)         AS total_spent -- everything spent per customer
        FROM kevin_ip.fod_team10_nojake
        GROUP BY customer_id
        ORDER BY 3 DESC -- some orders have $0 spent
      ) AS fod_data
    GROUP BY 1
    ORDER BY 1
  );


--------------------------------------------------------------------
--------------------------------------------------------------------
/*

  LIFETIME TO DATE STATS

 */


CREATE VIEW kevin_ip.ltd_fanjoy AS (
  SELECT count(DISTINCT customer_id) as total_customers,
    count(*) as total_orders,
    sum(total_price_usd) as total_sales,
    sum(total_price_usd) / count(*) as avg_order_size
  FROM fanjoy_orders_data
);

CREATE VIEW kevin_ip.ltd_team10 AS (
  SELECT count(DISTINCT customer_id) as total_customers,
    count(*) as total_orders,
    sum(total_price_usd) as total_sales,
    sum(total_price_usd) / count(*) as avg_order_size
  FROM fod_team10
);


CREATE VIEW kevin_ip.ltd_jakepaul AS (
  SELECT
    count(DISTINCT customer_id) as total_customers,
    count(*) as total_orders,
    sum(total_price_usd) as total_sales,
    sum(total_price_usd) / count(*) as avg_order_size
  FROM fod_jakepaul
)
;


CREATE VIEW kevin_ip.ltd_team10_nojake AS (
  SELECT count(DISTINCT customer_id) as total_customers,
    count(*) as total_orders,
    sum(total_price_usd) as total_sales,
    sum(total_price_usd) / count(*) as avg_order_size
  FROM fod_team10_nojake
)
;


----------------------------------------------------------------
----------------------------------------------------------------
/*

  FIRST ORDERS FOR ALL OF FANJOY
  No need for seperate views for subset, use entire Fanjoy set

 */

CREATE VIEW kevin_ip.first_orders_fanjoy AS (
  SELECT DISTINCT
    customer_id,
    MIN(date_trunc('month', created_at)) AS first_order_month
  FROM fanjoy_orders_data
  WHERE customer_id > 0 and customer_id IS NOT NULL
  GROUP BY customer_id
  ORDER BY customer_id
);
