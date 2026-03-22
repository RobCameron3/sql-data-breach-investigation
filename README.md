
# SQL Data Breach Investigation (Keiko Corp Case Study)

## Overview
This project investigates a data breach by analyzing ride-sharing activity and cross-referencing it with employee data using SQL to identify the responsible individual.

---

## Objective
Determine who was present at Keiko Corp during the time of the data breach and identify connections between external users and internal employees.

---

## Key Skills Demonstrated
- SQL Joins (multi-table relationships)
- Filtering using timestamps and geolocation (latitude/longitude)
- Data deduplication using DISTINCT
- Data cleaning using `split_part`
- Creating reusable datasets with SQL views
- Cross-database querying using `dblink`
- Data matching and entity resolution across datasets
- Analytical problem solving

---

## Investigation Process

### Step 1: Identify rides near the incident location
Filtered ride data using latitude, longitude, and timestamp to isolate activity near Keiko Corp on the date of the breach.

### Step 2: Link rides to vehicles
Joined ride data to identify which vehicles were present.

### Step 3: Investigate drivers
Mapped vehicles to owners (drivers), but results were inconclusive.

### Step 4: Investigate riders
Shifted focus to riders and identified individuals associated with the suspicious rides.

### Step 5: Normalize rider names
Used `split_part` to separate first and last names from a single column.

### Step 6: Cross-reference with employee database
Used `dblink` to compare rider names against employee records across a separate database.

---

## Outcome
Narrowed the suspect pool and identified a confirmed match by linking ride activity with internal employee data.

---

## Tools Used
- PostgreSQL
- SQL
- Valentina Studio

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
