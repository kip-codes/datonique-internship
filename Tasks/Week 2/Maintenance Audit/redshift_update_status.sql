CREATE VIEW kevin_ip.redshift_status_report AS (
  SELECT
    'fanjoy_customers_data'            AS table_name,
    count(*)                           AS num_rows,
    to_char(MAX(created_at) :: TIMESTAMP AT TIME ZONE 'PST','mm/dd/yyyy HH24:MI:SS') AS last_updated
  FROM public.fanjoy_customers_data

  UNION

  SELECT
    'fanjoy_lineitems_data'         AS table_name,
    count(*)                        AS num_rows,
    to_char(CURRENT_DATE :: TIMESTAMP AT TIME ZONE 'PST','mm/dd/yyyy HH24:MI:SS') AS last_updated
  FROM public.fanjoy_lineitems_data

  UNION

  SELECT
    'fanjoy_orders_data'               AS table_name,
    count(*)                           AS num_rows,
    to_char(MAX(created_at) :: TIMESTAMP AT TIME ZONE 'PST','mm/dd/yyyy HH24:MI:SS') AS last_updated
  FROM public.fanjoy_orders_data
  UNION

  SELECT
    'ga_event_data'              AS table_name,
    count(*)                     AS num_rows,
    to_char(MAX(date) :: TIMESTAMP AT TIME ZONE 'PST','mm/dd/yyyy HH24:MI:SS') AS last_updated
  FROM public.ga_event_data
  UNION

  SELECT
    'ga_pagetracking_data'       AS table_name,
    count(*)                     AS num_rows,
    to_char(MAX(date) :: TIMESTAMP AT TIME ZONE 'PST','mm/dd/yyyy HH24:MI:SS') AS last_updated
  FROM public.ga_pagetracking_data
  UNION

  SELECT
    'ga_session_data'            AS table_name,
    count(*)                     AS num_rows,
    to_char(MAX(date) :: TIMESTAMP AT TIME ZONE 'PST','mm/dd/yyyy HH24:MI:SS') AS last_updated
  FROM public.ga_session_data
  UNION

  SELECT
    'ga_transaction_data'        AS table_name,
    count(*)                     AS num_rows,
    to_char(MAX(date) :: TIMESTAMP AT TIME ZONE 'PST','mm/dd/yyyy HH24:MI:SS') AS last_updated
  FROM public.ga_transaction_data
  UNION


  SELECT
    'ga_user_data'               AS table_name,
    count(*)                     AS num_rows,
    to_char(MAX(date) :: TIMESTAMP AT TIME ZONE 'PST','mm/dd/yyyy HH24:MI:SS') AS last_updated
  FROM public.ga_user_data
  UNION


  SELECT
    'ga_user_demo_data'          AS table_name,
    count(*)                     AS num_rows,
    to_char(MAX(date) :: TIMESTAMP AT TIME ZONE 'PST','mm/dd/yyyy HH24:MI:SS') AS last_updated
  FROM public.ga_user_demo_data
  UNION


  SELECT
    'klaviyo_orders_data'            AS table_name,
    count(*)                         AS num_rows,
    CASE
      WHEN to_char(MAX(order_datetime) :: TIMESTAMP AT TIME ZONE 'PST','mm/dd/yyyy HH24:MI:SS') IS NULL THEN to_char(current_date, 'mm/dd/yyyy HH24:MI:SS')
      ELSE to_char(MAX(order_datetime) :: TIMESTAMP AT TIME ZONE 'PST','mm/dd/yyyy HH24:MI:SS')
    END AS last_updated
  FROM public.klaviyo_orders_data

  UNION

  SELECT
    'klaviyo_profiles_data'             AS table_name,
    count(*)                            AS num_rows,
    to_char(MAX(last_import) AT TIME ZONE 'PST','mm/dd/yyyy HH24:MI:SS') AS last_updated
  FROM public.klaviyo_profiles_data
  UNION


  SELECT
    'replyyes'                      AS table_name,
    count(*)                        AS num_rows,
    to_char(current_date :: TIMESTAMP AT TIME ZONE 'PST','mm/dd/yyyy HH24:MI:SS') AS last_updated
  FROM survey.replyyes
  UNION


  SELECT
    'survey_answers'                AS table_name,
    count(*)                        AS num_rows,
    TO_CHAR(current_date :: TIMESTAMP AT TIME ZONE 'PST','mm/dd/yyyy HH24:MI:SS') AS last_updated
  FROM survey.survey_answers
  UNION


  SELECT
    'survey_questions'              AS table_name,
    count(*)                        AS num_rows,
    to_char(current_date :: TIMESTAMP AT TIME ZONE 'PST','mm/dd/yyyy HH24:MI:SS') AS last_updated
  FROM survey.survey_questions
  UNION


  SELECT
    'survey_responses'              AS table_name,
    count(*)                        AS num_rows,
    to_char(current_date :: TIMESTAMP AT TIME ZONE 'PST','mm/dd/yyyy HH24:MI:SS') AS last_updated
  FROM survey.survey_responses
  UNION

  SELECT
    'surveys_sent'                  AS table_name,
    count(*)                        AS num_rows,
    CASE
      WHEN MAX(sent_on) :: TIMESTAMP AT TIME ZONE 'PST' is not null then to_char(MAX(sent_on) :: TIMESTAMP AT TIME ZONE 'PST','mm/dd/yyyy HH24:MI:SS')
      ELSE to_char(current_date :: TIMESTAMP AT TIME ZONE 'PST','mm/dd/yyyy HH24:MI:SS')
    END AS last_updated
  FROM survey.surveys_sent
  UNION


  SELECT
    'thanked'                       AS table_name,
    count(*)                        AS num_rows,
    to_char(CURRENT_DATE :: TIMESTAMP AT TIME ZONE 'PST','mm/dd/yyyy HH24:MI:SS') AS last_updated
  FROM survey.thanked
  UNION


  SELECT
    'unsubscribed'                  AS table_name,
    count(*)                        AS num_rows,
    to_char(current_date :: TIMESTAMP AT TIME ZONE 'PST','mm/dd/yyyy HH24:MI:SS') AS last_updated
  FROM survey.unsubscribed
  UNION


  SELECT
    'facebook_page_data'               AS table_name,
    count(*)                           AS num_rows,
    to_char(MAX(created_at) :: TIMESTAMP AT TIME ZONE 'PST','mm/dd/yyyy HH24:MI:SS') AS last_updated
  FROM unicorn_social_media.facebook_page_data
  UNION


  SELECT
    'facebook_post_data'                            AS table_name,
    count(*)                                        AS num_rows,
    to_char(MAX(created_at) :: TIMESTAMP AT TIME ZONE 'PST','mm/dd/yyyy HH24:MI:SS') AS last_updated
  FROM unicorn_social_media.facebook_post_data
  UNION


  SELECT
    'instagram_metrics_data'                        AS table_name,
    count(*)                                        AS num_rows,
    to_char(MAX(created_at) :: TIMESTAMP AT TIME ZONE 'PST','mm/dd/yyyy HH24:MI:SS') AS last_updated
  FROM unicorn_social_media.instagram_metrics_data
  UNION


  SELECT
    'instagram_user_detail'                         AS table_name,
    count(*)                                        AS num_rows,
    to_char(MAX(created_at) :: TIMESTAMP AT TIME ZONE 'PST','mm/dd/yyyy HH24:MI:SS') AS last_updated
  FROM unicorn_social_media.instagram_user_detail
  UNION


  SELECT
    'twitter_followers_data'                        AS table_name,
    count(*)                                        AS num_rows,
    to_char(MAX(created_at) :: TIMESTAMP AT TIME ZONE 'PST','mm/dd/yyyy HH24:MI:SS') AS last_updated
  FROM unicorn_social_media.twitter_followers_data
  UNION


  SELECT
    'twitter_tweets_data'                           AS table_name,
    count(*)                                        AS num_rows,
    to_char(MAX(created_at) :: TIMESTAMP AT TIME ZONE 'PST','mm/dd/yyyy HH24:MI:SS') AS last_updated
  FROM unicorn_social_media.twitter_tweets_data
  UNION


  SELECT
    'youtube_metrics_data'                          AS table_name,
    count(*)                                        AS num_rows,
    to_char(MAX(created_at) :: TIMESTAMP AT TIME ZONE 'PST','mm/dd/yyyy HH24:MI:SS') AS last_updated
  FROM unicorn_social_media.youtube_metrics_data
  UNION


  SELECT
    'youtube_video_details'                         AS table_name,
    count(*)                                        AS num_rows,
    to_char(MAX(created_at) :: TIMESTAMP AT TIME ZONE 'PST','mm/dd/yyyy' 'HH24:MI:SS') AS last_updated
  FROM unicorn_social_media.youtube_video_details
);


SELECT max(timestamp), max(order_datetime), max(processed_at), max(updated_at)
FROM klaviyo_orders_data;