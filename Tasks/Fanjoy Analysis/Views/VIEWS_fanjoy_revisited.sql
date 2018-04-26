/*
  List of Views Created:
    fld_jakepaul
    fld_team10
    fld_team10_nojake
    fod_jakepaul
    fod_team10
    fod_team10_nojake
    first_orders_fanjoy
    qtr_sales_fanjoy
    qtr_sales_jake
    qtr_sales_team10
 */

-- Drop dependent views
DROP VIEW IF EXISTS kevin_ip.first_orders_fanjoy;
DROP VIEW IF EXISTS kevin_ip.qtr_sales_fanjoy;
DROP VIEW IF EXISTS kevin_ip.qtr_sales_jake;
DROP VIEW IF EXISTS kevin_ip.qtr_sales_team10;

-- Drop base views
DROP VIEW IF EXISTS kevin_ip.fod_jakepaul;
DROP VIEW IF EXISTS kevin_ip.fod_team10;
DROP VIEW IF EXISTS kevin_ip.fod_team10_nojake;
DROP VIEW IF EXISTS kevin_ip.fld_jakepaul;
DROP VIEW IF EXISTS kevin_ip.fld_team10;
DROP VIEW IF EXISTS kevin_ip.fld_team10_nojake;


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
    WHERE (
      fld.title ilike '%erika%'
      or fld.title ilike '%team%10%'
      or fld.title ILIKE '%team%ten%'
      or fld.title ilike '%chance%&%anthony%'
      or fld.title ilike '%nick%crompton%'
      or fld.title ilike '%jake%paul%'
      or fld.title ilike '%ben%hampton%'
      or fld.title ilike '%chad%tepper%'
      or fld.title ilike '%kade%speiser%'
      or fld.title ilike '%justin%roberts%'
      or fld.name ilike '%erika%'
      or fld.name ilike '%team%10%'
      or fld.name ilike '%team%ten%'
      or fld.name ilike '%chance%&%anthony%'
      or fld.name ilike '%nick%crompton%'
      or fld.name ilike '%jake%paul%'
      or fld.name ilike '%ben%hampton%'
      or fld.name ilike '%chad%tepper%'
      or fld.name ilike '%kade%speiser%'
      or fld.name ilike '%justin%roberts%'
      or fld.vendor ilike '%jake%paul%'
      or fld.vendor ilike '%team%10%'
      or fld.vendor ilike '%team%ten%'
    )
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


-- View of all Jake line items
CREATE VIEW kevin_ip.fld_jakepaul AS
  (
    SELECT *
    FROM fanjoy_lineitems_data fld
    WHERE
      (
        fld.title ilike '%jake%paul%'
        or fld.name ilike '%jake%paul%'
        or fld.vendor ilike '%jake%paul%'
      )
  )
;


-- View of all orders placed containing Jake line items
CREATE VIEW kevin_ip.fod_jakepaul AS
  (
    SELECT fod.*
    FROM fanjoy_orders_data fod
    WHERE fod.order_number IN (
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
        fld.title ilike '%erika%'
        or fld.title ilike '%team%10%' -- if spelled numerically
        or fld.title ilike '%team%ten%' -- if it's spelled literally
        or fld.title ilike '%chance%&%anthony%'
        or fld.title ilike '%nick%crompton%'
        or fld.title ilike '%ben%hampton%'
        or fld.title ilike '%chad%tepper%'
        or fld.title ilike '%kade%speiser%'
        or fld.title ilike '%justin%roberts%'
        or fld.name ilike '%erika%'
        or fld.name ilike '%team%10%'
        or fld.name ilike '%team%ten%'
        or fld.name ilike '%chance%&%anthony%'
        or fld.name ilike '%nick%crompton%'
        or fld.name ilike '%ben%hampton%'
        or fld.name ilike '%chad%tepper%'
        or fld.name ilike '%kade%speiser%'
        or fld.name ilike '%justin%roberts%'
        or fld.vendor ilike '%team%10%'
        or fld.vendor ilike '%team%ten%'
      )
      AND
      (
        fld.name NOT ILIKE '%jake%paul%'
        AND fld.title NOT ILIKE '%jake%paul%'
        AND fld.vendor NOT ILIKE '%jake%paul%'
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
        FROM kevin_ip.fod_team10
      ) AS A
      JOIN
      (
        SELECT
          order_number,
          SUM(price) AS sales
        FROM kevin_ip.fld_team10
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
        FROM kevin_ip.fod_jakepaul
      ) AS A
      JOIN
      (
        SELECT
          order_number,
          SUM(price) AS sales
        FROM kevin_ip.fld_jakepaul
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
