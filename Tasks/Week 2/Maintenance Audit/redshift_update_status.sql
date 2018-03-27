SELECT 'fanjoy_customers_data' as table_name
  , count(*) as num_rows
  , MAX(created_at) AT TIME ZONE 'PST' as last_updated
FROM public.fanjoy_customers_data

UNION

SELECT 'fanjoy_lineitems_data' as table_name
  , count(*) as num_rows
  , CURRENT_DATE AT TIME ZONE 'PST' as last_updated
FROM public.fanjoy_lineitems_data

UNION

SELECT 'fanjoy_orders_data' as table_name
  , count(*) as num_rows
  , MAX(created_at) AT TIME ZONE 'PST' as last_updated
FROM public.fanjoy_orders_data
UNION

SELECT 'ga_event_data' as table_name
  , count(*) as num_rows
  , MAX(date) AT TIME ZONE 'PST' as last_updated
FROM public.ga_event_data
UNION

SELECT 'ga_pagetracking_data' as table_name
  , count(*) as num_rows
  , MAX(date) AT TIME ZONE 'PST' as last_updated
FROM public.ga_pagetracking_data
UNION

SELECT 'ga_session_data' as table_name
  , count(*) as num_rows
  , MAX(date) AT TIME ZONE 'PST' as last_updated
FROM public.ga_session_data
UNION

SELECT 'ga_transaction_data' as table_name
  , count(*) as num_rows
  , MAX(date) AT TIME ZONE 'PST' as last_updated
FROM ga_transaction_data
UNION


SELECT 'ga_user_data' as table_name
  , count(*) as num_rows
  , MAX(date) AT TIME ZONE 'PST' as last_updated
FROM ga_user_data
UNION


SELECT 'ga_user_demo_data' as table_name
  , count(*) as num_rows
  , MAX(date) AT TIME ZONE 'PST' as last_updated
FROM ga_user_demo_data
UNION


SELECT 'klaviyo_orders_data' as table_name
  , count(*) as num_rows
  , MAX(order_datetime)::timestamp as last_updated
FROM klaviyo_orders_data

UNION

SELECT 'klaviyo_profiles_data' as table_name
  , count(*) as num_rows
  , MAX(last_import) AT TIME ZONE 'PST' as last_updated
FROM klaviyo_profiles_data
UNION


SELECT 'replyyes' as table_name
  , count(*) as num_rows
  , current_date AT TIME ZONE 'PST' as last_updated
FROM survey.replyyes
UNION


SELECT 'survey_answers' as table_name
  , count(*) as num_rows
  , current_date AT TIME ZONE 'PST' as last_updated
FROM survey.survey_answers
UNION


SELECT 'survey_questions' as table_name
  , count(*) as num_rows
  , current_date AT TIME ZONE 'PST' as last_updated
FROM survey.survey_questions
UNION


SELECT 'survey_responses' as table_name
  , count(*) as num_rows
  , current_date AT TIME ZONE 'PST' as last_updated
FROM survey.survey_responses
UNION

SELECT 'surveys_sent' as table_name
  , count(*) as num_rows
  , MAX(sent_on) AT TIME ZONE 'PST' as last_updated
FROM survey.surveys_sent
UNION


SELECT 'thanked' as table_name
  , count(*) as num_rows
  , CURRENT_DATE AT TIME ZONE 'PST' as last_updated
FROM survey.thanked
UNION


SELECT 'unsubscribed' as table_name
  , count(*) as num_rows
  , current_date AT TIME ZONE 'PST' as last_updated
FROM survey.unsubscribed
UNION


SELECT 'facebook_page_data' as table_name
  , count(*) as num_rows
  , MAX(created_at) AT TIME ZONE 'PST' as last_updated
FROM unicorn_social_media.facebook_page_data
UNION


SELECT 'facebook_post_data' as table_name
  , count(*) as num_rows
  , MAX(created_at)::TIMESTAMP AT TIME ZONE 'PST' as last_updated
FROM unicorn_social_media.facebook_post_data
UNION


SELECT 'instagram_metrics_data' as table_name
  , count(*) as num_rows
  , MAX(created_at)::TIMESTAMP AT TIME ZONE 'PST' as last_updated
FROM unicorn_social_media.instagram_metrics_data
UNION


SELECT 'instagram_user_detail' as table_name
  , count(*) as num_rows
  , MAX(created_at)::TIMESTAMP AT TIME ZONE 'PST' as last_updated
FROM unicorn_social_media.instagram_user_detail
UNION


SELECT 'twitter_followers_data' as table_name
  , count(*) as num_rows
  , MAX(created_at)::timestamp AT TIME ZONE 'PST' as last_updated
FROM unicorn_social_media.twitter_followers_data
UNION


SELECT 'twitter_tweets_data' as table_name
  , count(*) as num_rows
  , MAX(created_at)::timestamp AT TIME ZONE 'PST' as last_updated
FROM unicorn_social_media.twitter_tweets_data
UNION


SELECT 'youtube_metrics_data' as table_name
  , count(*) as num_rows
  , MAX(created_at)::timestamp AT TIME ZONE 'PST' as last_updated
FROM unicorn_social_media.youtube_metrics_data
UNION


SELECT 'youtube_video_details' as table_name
  , count(*) as num_rows
  , MAX(created_at)::timestamp AT TIME ZONE 'PST' as last_updated
FROM unicorn_social_media.youtube_video_details;


SELECT max(timestamp), max(order_datetime), max(processed_at), max(updated_at)
FROM klaviyo_orders_data;