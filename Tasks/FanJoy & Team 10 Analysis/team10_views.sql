-- Get all line items from Team10
SELECT name
FROM fanjoy_lineitems_data fld
WHERE (lower(fld.name) like '%erika%'
       or lower(fld.name) like '%team%10%'
       or lower(fld.name) like '%jake%paul%'
       or lower(fld.name) like '%ben%hampton%'
       or lower(fld.vendor) like '%jake%paul%'
       or lower(fld.vendor) like '%team%10%');


-- View of all Team 10 line items
CREATE VIEW kevin_ip.fld_team10 AS
  (
    SELECT *
    FROM fanjoy_lineitems_data fld
    WHERE (lower(fld.name) like '%erika%'
          or lower(fld.name) like '%team%10%'
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


------------------------------------------------------------------
-- RESULTS


-- GET total customers from Fanjoy
SELECT count(distinct id)
FROM fanjoy_customers_data;


-- GET total paying customers from Fanjoy
SELECT count(distinct id)
FROM fanjoy_customers_data
WHERE total_spent > 0;


-- GET total paying customers from Jake's line
SELECT count(distinct id)
FROM fcd_team10;



-- GET number of emails and phone numbers from all customers
SELECT count(DISTINCT email) AS "Count of Emails"
FROM fanjoy_customers_data
WHERE email IS NOT NULL;

SELECT count(distinct phone) as "Count of phones"
from fanjoy_customers_data
where phone is not null;

-- GET number of emails and phone numbers from customers FROM jake only
SELECT count(DISTINCT email) AS "# Emails for JP customers"
FROM fcd_team10
WHERE email IS NOT NULL;

SELECT count(DISTINCT phone) AS "# Phones for JP customers"
FROM fcd_team10
WHERE phone IS NOT NULL;


SELECT *
FROM fanjoy_lineitems_data
limit 15;