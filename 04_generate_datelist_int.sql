-- Add column and populate datelist_int for user_devices_cumulated
ALTER TABLE user_devices_cumulated
ADD COLUMN IF NOT EXISTS datelist_int BIGINT;

WITH max_date AS (
  SELECT MAX(date) AS date FROM user_devices_cumulated
),
date_series AS (
  SELECT generate_series(
    (SELECT date FROM max_date) - INTERVAL '30 day', 
    (SELECT date FROM max_date), 
    INTERVAL '1 day'
  )::DATE AS date
)
UPDATE user_devices_cumulated u
SET datelist_int = sub.datelist_int
FROM (
  SELECT 
    user_id,
    browser_type,
    (
      SELECT SUM(
        CASE WHEN u2.dates_active @> ARRAY[ds.date] 
        THEN POWER(2, 31 - (((SELECT date FROM max_date) - ds.date)::int)) 
        ELSE 0 END
      )::BIGINT
      FROM date_series ds
    ) AS datelist_int
  FROM user_devices_cumulated u2, max_date
  WHERE u2.date = (SELECT date FROM max_date)
) sub
WHERE u.user_id = sub.user_id
  AND u.browser_type = sub.browser_type
  AND u.date = (SELECT date FROM max_date);