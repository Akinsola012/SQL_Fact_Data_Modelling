-- Initial load for user_devices_cumulated
INSERT INTO user_devices_cumulated (user_id, browser_type, dates_active, date)
SELECT 
  CAST(e.user_id AS NUMERIC) AS user_id,
  d.browser_type,
  ARRAY[DATE(e.event_time)] AS dates_active,
  DATE(e.event_time) AS date
FROM events e
JOIN devices d ON e.device_id = d.device_id
WHERE DATE(e.event_time) = (SELECT MIN(DATE(event_time)) FROM events)
  AND e.user_id IS NOT NULL
GROUP BY e.user_id, d.browser_type, DATE(e.event_time);