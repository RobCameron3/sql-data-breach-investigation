-- =========================================
-- SQL DATA BREACH INVESTIGATION (KEIKO CORP)
-- =========================================
-- Goal:
-- Identify the individual responsible for a data breach by analyzing
-- ride activity and cross-referencing rider data with employee records.
--
-- Steps:
-- 1. Filter rides by location and date
-- 2. Identify associated vehicles
-- 3. Investigate drivers (vehicle owners)
-- 4. Shift focus to riders
-- 5. Split rider names into first/last
-- 6. Cross-reference riders with employees (dblink)
--
-- Result:
-- Narrowed the suspect pool and identified the responsible employee
-- through cross-database analysis.
-- =========================================
-- STEP 1: Identify rides near incident location
-- =========================================

CREATE VIEW public.suspected_rides AS
SELECT *
FROM public.vehicle_location_histories AS vlh
WHERE vlh.city = 'New York'
  AND vlh.latitude BETWEEN 40.5 AND 40.6
  AND vlh.longitude BETWEEN -74.997 AND -74.9968
  AND DATE(vlh.timestamp) = '2020-06-23';

-- =========================================
-- STEP 2: Get unique vehicle IDs
-- =========================================

SELECT DISTINCT r.vehicle_id
FROM public.suspected_rides AS sr
JOIN public.rides AS r
  ON r.id = sr.ride_id;

-- =========================================
-- STEP 3: Get vehicle + owner info
-- =========================================

SELECT DISTINCT
    v.id AS vehicle_id,
    u.name AS owner_name,
    u.address,
    v.status,
    v.current_location
FROM public.suspected_rides AS sr
JOIN public.rides AS r
  ON r.id = sr.ride_id
JOIN public.vehicles AS v
  ON r.vehicle_id = v.id
JOIN public.users AS u
  ON v.owner_id = u.id;

-- =========================================
-- STEP 4: Identify riders
-- =========================================

SELECT DISTINCT
    u.id,
    u.name,
    u.address
FROM public.suspected_rides AS sr
JOIN public.rides AS r
  ON r.id = sr.ride_id
JOIN public.users AS u
  ON u.id = r.rider_id;

-- =========================================
-- STEP 5: Split rider names
-- =========================================

CREATE VIEW suspected_rider_names AS
SELECT DISTINCT
    split_part(u.name, ' ', 1) AS first_name,
    split_part(u.name, ' ', 2) AS last_name
FROM public.suspected_rides AS vlh
JOIN rides AS r
  ON r.id = vlh.ride_id
JOIN users AS u
  ON u.id = r.rider_id;

-- =========================================
-- STEP 6: Cross-reference with employee database
-- =========================================

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
