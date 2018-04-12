SELECT
  customer_id,
  A.order_number,
  title,
  sales
FROM
  (
    SELECT
      customer_id,
      order_number
    FROM fod_team10
    where customer_id = 5894964680
  ) AS A
  JOIN
  (
    SELECT
      order_number,
      title,
      SUM(price) as sales
    FROM fld_team10
    WHERE title not ilike '%jake%' and title not ilike '%erika%'
    GROUP BY order_number, title
  ) AS B
  ON A.order_number = B.order_number
;