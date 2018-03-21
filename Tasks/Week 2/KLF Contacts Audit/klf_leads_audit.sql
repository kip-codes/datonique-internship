/*
Sample rows of data
 */
SELECT extract(year from date_created), extract(month from date_created)
FROM klf.contacts
LIMIT 2;

CREATE VIEW kevin_ip.lead_source_report AS (
    SELECT *
    FROM klf.contacts
    WHERE EXTRACT(year FROM date_created) = 2018 and EXTRACT(month from date_created) = 3
      AND (EXTRACT(day FROM date_created) >= 5 AND EXTRACT(day from date_created) <= 11)
);

SELECT
  given_name
  , family_name
  , phone1
  , SUM(retainer_amount) as retainer_amount
FROM kevin_ip.lead_source_report
GROUP BY family_name, phone1, retainer_amount, given_name
ORDER BY phone1 ASC ;

SELECT
  family_name
  , phone1
  , retainer_amount
  , date_created
  , date_retained
FROM klf.contacts
WHERE retainer_amount > 0 and EXTRACT(year FROM date_retained) = 2018 and EXTRACT(month from date_retained) = 3;


SELECT *
FROM kevin_ip.lead_source_report
