
# SQL Data Breach Investigation (Keiko Corp Case Study)

## Overview
This project simulates a real-world data breach investigation using SQL. The goal was to identify the individual responsible by analyzing ride-sharing activity and cross-referencing it with employee data.

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

## Key SQL Example

```sql
SELECT DISTINCT
    srn.first_name,
    srn.last_name
FROM suspected_rider_names srn
JOIN dblink(
  'dbname=Employees',
  'SELECT first_name, last_name FROM employees'
) AS e(first_name TEXT, last_name TEXT)
ON srn.first_name = e.first_name
AND srn.last_name = e.last_name;
