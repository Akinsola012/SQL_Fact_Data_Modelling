Fact Data Modeling


Welcome to my Fact Data Modeling SQL project! This repository contains SQL scripts that demonstrate key concepts used in data engineering and analytics, specifically fact data modeling.

What Is Fact Data Modeling?
Fact data modeling is a technique used in building data warehouses and analytics systems. It helps organize large amounts of data in a way that makes reporting, querying, and analysis efficient and accurate.

Facts are the measurable, quantitative data about events or transactions.

Dimensions are descriptive attributes related to facts, such as time, user, or location.

In this project, we focus on tracking user device activity and host activity over time — two examples of facts you might want to analyze in a real-world system.

Project Overview
1. User Devices Activity Model
Creates a table to track users' active days on different browsers (user_devices_cumulated).

Uses arrays and dates to store activity history cumulatively.

Includes a column converting date arrays into an integer format for faster querying (datelist_int).

2. Incremental Updates
Adds new daily activity data without rewriting entire tables.

Joins previous day’s data with the current day’s events.

Supports efficient, day-by-day data growth.

3. Host Activity Model
Similar to user devices but tracks host (website) activity.

Stores daily activity dates in arrays.

Aggregates monthly statistics including daily hits and unique visitors.

How This Benefits Organizations
Accurate Analytics: Deduplication and well-structured fact models ensure accurate reports, leading to better business decisions.

Efficient Queries: Organized data means queries run faster and use fewer resources, saving time and costs.

Scalability: Incremental updates allow the system to grow with new data daily without expensive full reloads.

Insightful Metrics: Tracking user and host activity over time helps businesses understand usage patterns, optimize resources, and improve user experience.

How to Use This Repository
Review each .sql file to see the DDL (table creation), data insertion, incremental updates, and verification queries.

Run the scripts step-by-step on your SQL database to see how the models build up work.

Modify the date parameters or source tables to adapt to your datasets.

Final Thoughts
This project gave me hands-on experience with essential data engineering concepts — organizing data for analysis and ensuring its quality. Understanding these fundamentals is crucial for building reliable data pipelines and insightful analytics systems.

If you have any questions or want to discuss these techniques further, feel free to reach out!

Thank you for checking out my project!


