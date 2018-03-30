-- View of all Jake line items
CREATE VIEW kevin_ip.fld_team10_nojake AS
  (
    SELECT name
    FROM fanjoy_lineitems_data fld
    WHERE
      (
        lower(fld.name) like '%team%10%'
        or lower(fld.name) like '%erika%'
        or lower(fld.name) like '%chance%'
        or lower(fld.name) like '%anthony%'
        or lower(fld.name) like '%nick%crompton%'
        or lower(fld.name) like '%ben%hampton%'
        or lower(fld.vendor) like '%team%10%'
      )
  )
;


-- View of all orders placed containing Jake line items
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