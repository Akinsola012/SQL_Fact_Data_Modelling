-- Create table for tracking host activity
CREATE TABLE IF NOT EXISTS hosts_cumulated (
  host VARCHAR NOT NULL,
  host_activity_datelist DATE[] NOT NULL,
  date DATE NOT NULL,
  PRIMARY KEY (host, date)
);