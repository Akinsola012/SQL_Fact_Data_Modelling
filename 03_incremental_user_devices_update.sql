-- Incremental update for user_devices_cumulated table
WITH last_processed_date AS (
  SELECT COALESCE(MAX(date), (SELECT MIN(DATE(event_time)) FROM events)) AS max_date
  FROM user_devices_cumulated
),
today_events AS (
  SELECT 
    e.user_id,
    d.browser_type,
    DATE(e.event_time) AS event_date
  FROM events e
  JOIN devices d ON e.device_id = d.device_id
  JOIN last_processed_date lpd ON DATE(e.event_time) = lpd.max_date + INTERVAL '1 day'
  WHERE e.user_id IS NOT NULL
  GROUP BY e.user_id, d.browser_type, DATE(e.event_time)
),
yesterday_data AS (
  SELECT * FROM user_devices_cumulated WHERE date = (SELECT max_date FROM last_processed_date)
),
combined AS (
  SELECT 
    COALESCE(y.user_id, t.user_id) AS user_id,
    COALESCE(y.browser_type, t.browser_type) AS browser_type,
    CASE
      WHEN y.dates_active IS NULL THEN ARRAY[t.event_date]
      WHEN t.event_date IS NULL THEN y.dates_active
      ELSE y.dates_active || t.event_date
    END AS dates_active,
    (SELECT max_date FROM last_processed_date) + INTERVAL '1 day' AS date
  FROM yesterday_data y
  FULL OUTER JOIN today_events t ON y.user_id = t.user_id AND y.browser_type = t.browser_type
)
INSERT INTO user_devices_cumulated (user_id, browser_type, dates_active, date)
SELECT user_id, browser_type, dates_active, date
FROM combined
-- Avoid inserting duplicates if data already exists for this date
WHERE (user_id, browser_type, date) NOT IN (
  SELECT user_id, browser_type, date FROM user_devices_cumulated WHERE date = (SELECT max_date FROM last_processed_date) + INTERVAL '1 day'
);