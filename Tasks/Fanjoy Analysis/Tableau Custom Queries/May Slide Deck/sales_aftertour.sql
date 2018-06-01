/*
  Get sales of each influencer in the last month
 */
SELECT
  A.order_number,
  trim(initcap(C.city)),
  C.country,
  A.orderdate,
  B.influencer,
  B.sales
FROM
(
  (
    SELECT
      order_number,
      customer_id,
      date_trunc('day', created_at) as orderdate
    FROM kevin_ip.fod_team10
  ) A
  JOIN
  (
    SELECT
      order_number,
      CASE
        WHEN title ilike '%erika%' or name ilike '%erika%' then 'Erika Costell'
        WHEN title ilike '%chance%anthony%' or name ilike '%chance%anthony%' then 'Chance & Anthony'
        WHEN title ilike '%nick%crompton%' or name ilike '%nick%crompton%' then 'Nick Crompton'
        WHEN title ilike '%ben%hampton%' or name ilike '%ben%hampton%' then 'Ben Hampton'
        WHEN title ilike '%chad%tepper%' or name ilike '%chad%tepper%' then 'Chad Tepper'
        WHEN title ilike '%kade%speiser%' or name ilike '%kade%speiser%' then 'Kade Speiser'
        WHEN title ilike '%justin%roberts%' or name ilike '%justin%roberts%' then 'Justin Roberts'
        WHEN title ilike '%jake%paul%' or name ilike '%jake%paul%' then 'Jake Paul'
        WHEN title ilike '%team%10%' or title ilike '%team%ten%' or name ilike '%team%10%' or name ilike '%team%ten%' then 'General Team 10'
        else 'Miscellaneous'
      END as influencer,
      sum(price) as sales
    FROM kevin_ip.fld_team10
    group by 1,2
  ) B
  ON A.order_number = B.order_number
  JOIN
  (
    SELECT
      id,
      city,
      country
    FROM fanjoy_customers_data
  ) C
  on A.customer_id = C.id
)
WHERE
  date_trunc('day', orderdate) >= '2018-05-01'
  AND date_trunc('day', orderdate) <= '2018-05-29'
order by orderdate DESC
;


------------------------------------------------------------
------------------------------------------------------------


select
  a.order_number,
  a.created_at,
  b.sales
FROM (
  select
    order_number,
    created_at
  from fanjoy_orders_data
) a
JOIN
  (
    select
      order_number,
      sum(price) as sales
    from fanjoy_lineitems_data
    group by 1
    ) b
  on a.order_number = b.order_number
ORDER BY a.created_at DESC
;