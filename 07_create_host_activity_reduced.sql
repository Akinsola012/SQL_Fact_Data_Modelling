-- Create reduced fact table for host activity
CREATE TABLE host_activity_reduced (
  month DATE NOT NULL,
  host VARCHAR NOT NULL,
  hit_array INTEGER[] NOT NULL,
  unique_visitors_array INTEGER[] NOT NULL,
  date DATE NOT NULL,
  PRIMARY KEY (month, host, date)
);