SELECT * FROM klf.leads_source_report;


SELECT
  retainer_amount,
  substring(retainer_amount, 2),
  regexp_replace(substring(retainer_amount,2),'[^0-9]+', ''),
  replace(replace(retainer_amount, '$', ''), ',', '')
FROM klf.leads_source_report
WHERE owner ilike '%brendan%' and date_created_pst ilike '4%' and retainer_amount IS NOT NULL
;


select *
FROM klf.leads_source_report
where retainer_amount is not null
;


SELECT
  date_part('week', date_created_pst::date) as week,
  date_part('year', date_created_pst::date) as year,
  count(distinct(id)) as num_leads,
  sum(replace(replace(retainer_amount, '$', ''), ',', '')) as retainer_amt,
  count(replace(replace(retainer_amount, '$', ''), ',', '')) as num_retained,
  county_of_arrest
FROM klf.leads_source_report
GROUP BY
  date_part('week', date_created_pst::date),
  date_part('year', date_created_pst::date),
  county_of_arrest
order by
  date_part('week', date_created_pst::date),
  date_part('year', date_created_pst::date)




SELECT
  id,
  name,
  phone1,
  date_created_pst,
  owner,
  date_retained,
  replace(replace(retainer_amount, '$', ''), ',', '') as retainer_amt,
  replace(replace(downpay, '$', ''), ',', '') as downpay,
  type,
  channel,
  campaign,
  county_of_arrest,
  offense,
  radio_tv_internet
FROM klf.leads_source_report
;


SELECT
  retainer_amount
FROM klf.leads_source_report
where
  extract(year from date_created_pst) = 2018
  AND campaign ilike '%findlaw%'
  and retainer_amount != ''
;



select DISTINCT "where_did_you_find_us?" from klf.contacts;