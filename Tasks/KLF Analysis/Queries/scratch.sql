-- Lifetime numbers in Las Vegas
SELECT
  calling_phone_number as phone,
  city,
  start_time_local
FROM klf.invoca_call_records
WHERE
  city ilike '%las%vegas%'
  or calling_phone_number like '702%'
;

select * from klf.invoca_call_records limit 25;

-- Numbers in Las Vegas from the last 6 months
SELECT
  calling_phone_number as phone,
  city,
  start_time_local
FROM klf.invoca_call_records
WHERE
  date_trunc('day', start_time_local) > (CURRENT_DATE - INTERVAL '6 MONTH')
  and (city ILIKE '%las%vegas%' OR calling_phone_number LIKE '702%')
;


select * from klf.contacts limit 25;

-- Infusionsoft clients in Las Vegas, lifetime
SELECT
  given_name as first_name,
  family_name as last_name,
  phone1,
  phone2,
  arrest_city,
  county_of_arrest,
  date_created,
  date_retained,
  retainer_amount,
  amount_paid
FROM klf.contacts
WHERE
  (phone1 like '(702)%'
  or phone2 like '(702)%')
  or arrest_city ilike '%las%vegas%'
;

-- Infusionsoft clients in Las Vegas, last 6 months
SELECT
  given_name as first_name,
  family_name as last_name,
  phone1,
  phone2,
  arrest_city,
  county_of_arrest,
  date_created,
  date_retained,
  retainer_amount,
  amount_paid
FROM klf.contacts
WHERE
  date_trunc('day', date_created) > current_date - interval '6 month'
  AND (phone1 like '(702)%' or phone2 like '(702)%')
  OR arrest_city ilike '%las%vegas%'
;



SELECT min(date_created)
from KLF.contacts
;


SELECT MIN(start_time_local)
FROM klf.invoca_call_records
;


SELECT *
from klf.leads_source_report
order by date_created DESC
limit 300;



SELECT DISTINCT arrest_state
FROM klf.contacts
;


SELECT *
FROM klf.contacts
LIMIT 100;


SELECT count(*), count(date_retained)
FROM klf.contacts
WHERE address_billing_locality = '';
--75840, 51

select count(*), count(date_retained)
FROM klf.contacts;
--90984, 10416


SELECT owner_id, family_name
FROM klf.contacts
WHERE id = 782090;




SELECT DISTINCT date_retained
FROM klf.contacts
ORDER BY date_retained desc;

