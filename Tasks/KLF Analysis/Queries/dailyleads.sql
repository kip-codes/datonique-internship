/*
  Extract test entries from klf.contacts
 */

SELECT *
FROM klf.contacts
ORDER BY date_created DESC
LIMIT 300
;



/*

 */

SELECT
    date_created,
    CASE WHEN retainer_amount = '' or retainer_amount IS NULL THEN 0 ELSE retainer_amount::float END AS retainer_amount,
    CASE WHEN "where_did_you_find_us?" =  '' or "where_did_you_find_us?" IS NULL THEN 'Unknown' ELSE "where_did_you_find_us?" END as channel,
    salesperson
FROM klf.contacts
order by date_created desc
limit 50
;



SELECT
    date_created,
    salesperson,
    family_name,
    given_name
FROM klf.contacts
WHERE date_trunc('day', date_created) = '2018-05-05'
;



SELECT DISTINCT
    owner_id,
    count(owner_id)
FROM klf.contacts
where date_trunc('day', date_created) > '2018-05-01'
group by 1
order by owner_id DESC
