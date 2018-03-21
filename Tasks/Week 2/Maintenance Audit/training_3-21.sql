SELECT 'fanjoy_customers_data' as table_name
  , count(*) as num_rows
  , MAX(updated_at)
FROM public.fanjoy_customers_data;


SELECT 'fanjoy_lineitems_data' as table_name
  , count(*) as num_rows
  , NULL as date
FROM public.fanjoy_lineitems_data;


SELECT 'fanjoy_orders_data' as table_name
  , count(*) as num_rows
  , MAX(updated_at) as date
FROM public.fanjoy_orders_data;


SELECT 'ga_event_data' as table_name
  , count(*) as num_rows
  , MAX(date) as date
FROM public.ga_event_data;


SELECT 'ga_pagetracking_data' as table_name
  , count(*) as num_rows
  , MAX(date) as date
FROM public.ga_pagetracking_data;


SELECT 'ga_session_data' as table_name
  , count(*) as num_rows
  , MAX(date) as date
FROM public.ga_session_data;


SELECT 'ga_transaction_data' as table_name
  , count(*) as num_rows
  , MAX(date) as date
FROM ga_transaction_data;


SELECT 'ga_user_data' as table_name
  , count(*) as num_rows
  , MAX(date) as date
FROM ga_user_data;


SELECT 'ga_user_demo_data' as table_name
  , count(*) as num_rows
  , MAX(date) as date
FROM ga_user_demo_data;


SELECT 'klaviyo_orders_data' as table_name
  , count(*) as num_rows
  , MAX(updated_at) as date
FROM klaviyo_orders_data;


SELECT 'klaviyo_profiles_data' as table_name
  , count(*) as num_rows
  , MAX(last_import) as date
FROM klaviyo_profiles_data;


SELECT 'replyyes' as table_name
  , count(*) as num_rows
  , NULL as date
FROM survey.replyyes;


SELECT 'survey_answers' as table_name
  , count(*) as num_rows
  , NULL as date
FROM survey.survey_answers;


SELECT 'survey_questions' as table_name
  , count(*) as num_rows
  , NULL as date
FROM survey.survey_questions;


SELECT 'survey_responses' as table_name
  , count(*) as num_rows
  , NULL as date
FROM survey.survey_responses;


SELECT 'surveys_sent' as table_name
  , count(*) as num_rows
  , MAX(sent_on) as date
FROM survey.surveys_sent;


SELECT 'thanked' as table_name
  , count(*) as num_rows
  , NULL as date
FROM survey.thanked;


SELECT 'unsubscribed' as table_name
  , count(*) as num_rows
  , NULL as date
FROM survey.unsubscribed;


SELECT 'facebook_page_data' as table_name
  , count(*) as num_rows
  , MAX(updated_at) as date
FROM unicorn_social_media.facebook_page_data;


SELECT 'facebook_post_data' as table_name
  , count(*) as num_rows
  , MAX(updated_at) as date
FROM unicorn_social_media.facebook_post_data;


SELECT 'instagram_metrics_data' as table_name
  , count(*) as num_rows
  , MAX(updated_at) as date
FROM unicorn_social_media.instagram_metrics_data;


SELECT 'instagram_user_detail' as table_name
  , count(*) as num_rows
  , MAX(updated_at) as date
FROM unicorn_social_media.instagram_user_detail;


SELECT 'twitter_followers_data' as table_name
  , count(*) as num_rows
  , MAX(updated_at) as date
FROM unicorn_social_media.twitter_followers_data;


SELECT 'twitter_tweets_data' as table_name
  , count(*) as num_rows
  , MAX(updated_at) as date
FROM unicorn_social_media.twitter_tweets_data;


SELECT 'youtube_metrics_data' as table_name
  , count(*) as num_rows
  , MAX(updated_at) as date
FROM unicorn_social_media.youtube_metrics_data;


SELECT 'youtube_video_details' as table_name
  , count(*) as num_rows
  , MAX(updated_at) as date
FROM unicorn_social_media.youtube_video_details;