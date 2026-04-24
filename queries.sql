-- ============================================================
-- Airline Operations Data Warehouse — Business Queries
-- Database: PostgreSQL
-- Schema: star schema (fact_flight + 4 dimension tables)
-- ============================================================


-- Q1: Country-level Passenger Demand
-- Which countries generate the highest volume of flight events?
-- ============================================================
SELECT
    dl.country_name,
    SUM(f.flight_count) AS total_passengers
FROM fact_flight f
JOIN dim_location dl
    ON f.location_id = dl.location_id
GROUP BY dl.country_name
ORDER BY total_passengers DESC;


-- Q2: Monthly Flight Volume Trends
-- How does total flight volume vary month by month?
-- ============================================================
SELECT
    d.month_name,
    SUM(f.flight_count) AS total_flights
FROM fact_flight f
JOIN dim_date d
    ON f.date_id = d.date_id
GROUP BY d.month, d.month_name
ORDER BY d.month;


-- Q3: Weekend vs Weekday Flight Patterns
-- Is there a measurable difference in flight volumes between weekdays and weekends?
-- ============================================================
SELECT
    CASE
        WHEN d.is_weekend = 1 THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type,
    SUM(f.flight_count) AS total_passengers
FROM fact_flight f
JOIN dim_date d
    ON f.date_id = d.date_id
GROUP BY day_type;


-- Q4: Airport-level Delay Performance
-- Which airports have the highest delay rates? (min 25 flights for statistical reliability)
-- ============================================================
SELECT
    dl.airport_name,
    SUM(f.flight_count)  AS total_flights,
    SUM(f.delay_flag)    AS total_delayed,
    ROUND(
        SUM(f.delay_flag)::numeric / SUM(f.flight_count),
        4
    ) AS delay_rate
FROM fact_flight f
JOIN dim_location dl
    ON f.location_id = dl.location_id
GROUP BY dl.airport_name
HAVING SUM(f.flight_count) > 25
ORDER BY delay_rate DESC;


-- Q5: Passenger Demographics and Flight Volumes
-- How do flight volumes vary by passenger gender?
-- ============================================================
SELECT
    dp.gender,
    SUM(f.flight_count) AS total_passengers
FROM fact_flight f
JOIN dim_passenger dp
    ON f.passenger_key = dp.passenger_key
GROUP BY dp.gender
ORDER BY total_passengers DESC;


-- Q6: Nationality-based Travel Analysis
-- Which nationalities account for the largest share of flight events?
-- ============================================================
SELECT
    dp.nationality,
    SUM(f.flight_count) AS total_passengers
FROM fact_flight f
JOIN dim_passenger dp
    ON f.passenger_key = dp.passenger_key
GROUP BY dp.nationality
ORDER BY total_passengers DESC;


-- Q7: Cancellation Rate by Airport
-- Which airports have the highest cancellation rates? (min 25 flights for statistical reliability)
-- ============================================================
SELECT
    dl.airport_name,
    SUM(f.flight_count)   AS total_flights,
    SUM(f.cancel_flag)    AS total_cancelled,
    ROUND(
        SUM(f.cancel_flag)::numeric / SUM(f.flight_count),
        4
    ) AS cancellation_rate
FROM fact_flight f
JOIN dim_location dl
    ON f.location_id = dl.location_id
GROUP BY dl.airport_name
HAVING SUM(f.flight_count) > 25
ORDER BY cancellation_rate DESC;
