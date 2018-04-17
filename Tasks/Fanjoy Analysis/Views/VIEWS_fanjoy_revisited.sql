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
    WHERE (lower(fld.title) like '%erika%'
      or lower(fld.title) like '%team%10%'
      or fld.title ILIKE '%team%ten%'
      or lower(fld.title) like '%chance%&%anthony%'
      or lower(fld.title) like '%nick%crompton%'
      or lower(fld.title) like '%jake%paul%'
      or lower(fld.title) like '%ben%hampton%'
      or lower(fld.name) like '%erika%'
      or lower(fld.name) like '%team%10%'
      or fld.name ilike '%team%ten%'
      or lower(fld.name) like '%chance%&%anthony%'
      or lower(fld.name) like '%nick%crompton%'
      or lower(fld.name) like '%jake%paul%'
      or lower(fld.name) like '%ben%hampton%'
      or lower(fld.vendor) like '%jake%paul%'
      or lower(fld.vendor) like '%team%10%'
      or fld.vendor ilike '%team%ten%')
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



-- View of all customers linked to orders placed containing Team 10 line items
CREATE VIEW kevin_ip.fcd_team10 AS
  (
      SELECT fcd.*
      FROM fanjoy_customers_data fcd
      WHERE fcd.id IN
            (
              SELECT distinct fod_team10.customer_id
              FROM kevin_ip.fod_team10
            )
  );



-- View of all Jake line items
CREATE VIEW kevin_ip.fld_jakepaul AS
  (
    SELECT *
    FROM fanjoy_lineitems_data fld
    WHERE
      (
        lower(fld.title) like '%jake%paul%'
        or lower(fld.name) like '%jake%paul%'
        or lower(fld.vendor) like '%jake%paul%'
      )
  )
;


-- View of all orders placed containing Jake line items
CREATE VIEW kevin_ip.fod_jakepaul AS
  (
    SELECT fod.*
    FROM fanjoy_orders_data fod
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
    FROM fanjoy_lineitems_data fld
    WHERE
          (
            lower(fld.title) like '%erika%'
            or lower(fld.title) like '%team%10%'
            or fld.title ilike '%team%ten%'
            or lower(fld.title) like '%chance%&%anthony%'
            or lower(fld.title) like '%nick%crompton%'
            or lower(fld.title) like '%ben%hampton%'
            or lower(fld.name) like '%erika%'
            or lower(fld.name) like '%team%10%'
            or fld.name ilike '%team%ten%'
            or lower(fld.name) like '%chance%&%anthony%'
            or lower(fld.name) like '%nick%crompton%'
            or lower(fld.name) like '%ben%hampton%'
            or lower(fld.vendor) like '%team%10%'
            or fld.vendor ilike '%team%ten%'
          )
          AND
          (
            lower(fld.name) NOT LIKE '%jake%paul%'
            AND lower(fld.title) NOT LIKE '%jake%paul%'
            AND lower(fld.vendor) NOT LIKE '%jake%paul%'
          )
  )
;



-- View of all orders placed containing Team 10, no Jake line items
CREATE VIEW kevin_ip.fod_team10_nojake AS
  (
    SELECT fod.*
    FROM fanjoy_orders_data fod
    WHERE fod.order_number IN
          (
            SELECT DISTINCT order_number
            FROM kevin_ip.fld_team10_nojake
          )
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



----------------------------------------------------------------------------
----------------------------------------------------------------------------

/*
  Analyze quarterly (Q1 to Q4) growth in sales by Country and City.
  Then, compare Q1 to Q4 of previous year.
 */

----------------------------------------------------------------------------
----------------------------------------------------------------------------

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
