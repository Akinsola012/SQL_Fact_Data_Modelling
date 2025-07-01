-- Insert daily fact data into host_activity_reduced
WITH last_processed_date AS (
  SELECT COALESCE(MAX(date), (SELECT MIN(DATE(event_time)) FROM events) - INTERVAL '1 day') AS max_date
  FROM host_activity_reduced
),
next_day AS (
  SELECT (max_date + INTERVAL '1 day')::DATE AS next_date
  FROM last_processed_date
),
daily_stats AS (
  SELECT 
    DATE_TRUNC('month', DATE(e.event_time)) AS month,
    e.host,
    DATE(e.event_time) AS event_date,
    COUNT(*) AS hits,
    COUNT(DISTINCT e.user_id) AS unique_visitors
  FROM events e, next_day nd
  WHERE DATE(e.event_time) = nd.next_date
  GROUP BY 1, 2, 3
),
existing_data AS (
  SELECT * 
  FROM host_activity_reduced
  WHERE date = (SELECT max_date FROM last_processed_date)
)
INSERT INTO host_activity_reduced (month, host, hit_array, unique_visitors_array, date)
SELECT 
  COALESCE(e.month, d.month) AS month,
  COALESCE(e.host, d.host) AS host,
  CASE
    WHEN e.host IS NULL THEN d.hit_array
    WHEN d.host IS NULL THEN ARRAY[e.hits]
    ELSE d.hit_array || e.hits
  END AS hit_array,
  CASE
    WHEN e.host IS NULL THEN d.unique_visitors_array
    WHEN d.host IS NULL THEN ARRAY[e.unique_visitors]
    ELSE d.unique_visitors_array || e.unique_visitors
  END AS unique_visitors_array,
  (SELECT next_date FROM next_day) AS date
FROM existing_data d
FULL OUTER JOIN daily_stats e 
  ON d.host = e.host AND d.month = e.month;