🗄️ SQL – Data Breach Investigation
(SQL Investigation Case Study)
🌎 Overview

This project investigates a simulated corporate data breach by analyzing ride-sharing activity and cross-referencing external transportation records with internal employee data. Using SQL, the investigation narrows potential suspects through relational database analysis and cross-database querying.

🎯 Objective

Determine who was present at Keiko Corp during the time of the security incident by linking ride activity with employee records and identifying overlapping individuals through SQL analysis.

❓ Business Challenge

Following a suspected data breach, investigators needed to determine which individuals were present near the company during the incident. The challenge was that the relevant data was distributed across multiple databases and required joining external ride-sharing information with internal employee records.

💡 Solution

Developed a SQL investigation workflow that filtered ride activity by time and location, linked rides to vehicles and passengers, cleaned and standardized data, and performed cross-database matching to identify individuals connected to both the transportation records and the company's employee database.

🛠️ Key Skills Demonstrated
🔗 Multi-table SQL joins and relational database analysis
📍 Filtering using timestamps and geographic coordinates
🧹 Data cleaning and normalization with split_part
🗂️ Data deduplication using DISTINCT
🏗️ SQL view creation for reusable datasets
🌐 Cross-database querying using dblink
🔍 Entity resolution and record matching
🧠 Analytical problem solving and investigative reasoning
⚙️ Investigation Process
📍 Step 1: Identify Rides Near the Incident

Filtered ride-sharing records by latitude, longitude, and timestamp to isolate activity surrounding Keiko Corp during the data breach.

🚗 Step 2: Link Rides to Vehicles

Joined transportation records to determine which vehicles were present at the incident location.

👤 Step 3: Investigate Drivers

Mapped vehicles to registered drivers to identify potential persons of interest.

🚕 Step 4: Investigate Riders

Expanded the investigation to passengers and identified individuals associated with the suspicious rides.

🧹 Step 5: Normalize Rider Data

Used SQL string functions to separate first and last names into standardized fields for reliable matching.

🌐 Step 6: Cross-Reference Employee Records

Used dblink to compare suspected riders against employee records stored in a separate database and identify confirmed matches.

✅ Outcome

Successfully narrowed the suspect pool by combining geospatial filtering, relational database joins, data cleaning, and cross-database analysis to identify an individual connected to both the ride-sharing records and the company's employee database.

💻 Tools Used
🐘 PostgreSQL
🗄️ SQL
💻 Valentina Studio

---

## Key SQL Example (Cross-Database Matching)

- This query demonstrates how cross-database matching was used to identify overlapping individuals between rider data and employee records.

```sql
SELECT DISTINCT
    CONCAT(t1.first_name, ' ', t1.last_name) AS employee,
    CONCAT(u.first_name, ' ', u.last_name) AS rider
FROM dblink(
    'dbname=Employees',
    'SELECT first_name, last_name FROM employees;'
) AS t1(first_name TEXT, last_name TEXT)
JOIN suspected_rider_names AS u
  ON t1.first_name = u.first_name
 AND t1.last_name = u.last_name
ORDER BY rider;
```
