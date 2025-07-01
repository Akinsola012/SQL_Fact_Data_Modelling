-- Incremental update of hosts_cumulated
WITH last_processed_date AS (
  SELECT COALESCE(MAX(date), (SELECT MIN(DATE(event_time)) FROM events)) AS max_date
  FROM hosts_cumulated
),
today_data AS (
  SELECT 
    host,
    DATE(event_time) AS event_date
  FROM events
  WHERE DATE(event_time) = (SELECT max_date FROM last_processed_date) + INTERVAL '1 day'
  GROUP BY host, DATE(event_time)
),
yesterday_data AS (
  SELECT * 
  FROM hosts_cumulated 
  WHERE date = (SELECT max_date FROM last_processed_date)
)
INSERT INTO hosts_cumulated (host, host_activity_datelist, date)
SELECT 
  COALESCE(y.host, t.host) AS host,
  CASE
    WHEN y.host_activity_datelist IS NULL THEN ARRAY[t.event_date]
    WHEN t.event_date IS NULL THEN y.host_activity_datelist
    ELSE y.host_activity_datelist || t.event_date
  END AS host_activity_datelist,
  (SELECT max_date FROM last_processed_date) + INTERVAL '1 day' AS date
FROM yesterday_data y
FULL OUTER JOIN today_data t ON y.host = t.host;