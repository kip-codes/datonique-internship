
/*
  Get distribution of all Team 10 customers with 5+ orders
 */
select
  total_orders,
  count(customer_id) as num_cust,
  sum(total_sales) as sales
from
(
  select
  A.customer_id,
  count (B.order_number) as total_orders,
  sum(B.total_sales) as total_sales
  FROM
  (SELECT customer_id, order_number
    FROM fod_team10
  ) A
  JOIN
  (SELECT
    order_number,
    sum(price) as total_sales
    FROM fld_team10
    GROUP BY order_number
  ) B
  on A.order_number = B.order_number
  group by 1
) data
group by 1
;


/*
  Get distribution within 5+ orders based on unique customers per influencer
 */