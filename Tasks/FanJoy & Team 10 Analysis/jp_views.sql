
-- View of all Jake line items
CREATE VIEW kevin_ip.fld_jakepaul AS
  (
    SELECT name
    FROM fanjoy_lineitems_data fld
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
    FROM fanjoy_orders_data fod
    WHERE fod.order_number IN
          (
            SELECT DISTINCT order_number
            FROM kevin_ip.fld_jakepaul
          )
  )
;
