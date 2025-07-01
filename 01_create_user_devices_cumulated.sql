-- Create table for tracking user device activity
CREATE TABLE user_devices_cumulated (
  user_id NUMERIC NOT NULL,       -- changed from BIGINT to NUMERIC
  browser_type VARCHAR NOT NULL,
  dates_active DATE[] NOT NULL,
  date DATE NOT NULL,
  PRIMARY KEY (user_id, browser_type, date)
);