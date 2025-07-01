-- Verify latest activity
SELECT 
  h.month,
  h.host,
  h.hit_array[array_length(h.hit_array, 1)] AS latest_day_hits,
  h.unique_visitors_array[array_length(h.unique_visitors_array, 1)] AS latest_day_visitors,
  h.date
FROM host_activity_reduced h
WHERE h.date = (SELECT MAX(date) FROM host_activity_reduced)
ORDER BY latest_day_hits DESC;