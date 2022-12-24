/*
Codecademy - Analyse data with sql
Project assignment: Calculating churn rates
*/
--1. Viewing the data
SELECT * FROM subscriptions
LIMIT 100;

--2. Determine the range of months provided
SELECT MIN(subscription_start), MAX(subscription_start), MIN(subscription_end),MAX(subscription_end)
FROM subscriptions; 

--3. Create a temporary table for each month
WITH months AS (
  SELECT '2017-01-01' AS first_day, '2017-01-31' AS last_day
  UNION
  SELECT '2017-02-01' AS first_day, '2017-02-28' AS last_day
  UNION
  SELECT '2017-03-01' AS first_day, '2017-03-31' AS last_day
),
--4. cross join months table with subscriptions table
cross_join AS (
  SELECT * FROM subscriptions
  CROSS JOIN months
),
--5. and 6. temporary table for the status of each subscriber
status AS (
  SELECT id,
         first_day AS month,
         CASE WHEN subscription_start < first_day AND (subscription_end >= first_day OR subscription_end IS NULL) AND segment = 87
         THEN 1
         ELSE 0 
         END AS is_active_87,
         CASE WHEN subscription_start < first_day AND (subscription_end >= first_day OR subscription_end IS NULL) AND segment = 30
         THEN 1
         ELSE 0
         END AS is_active_30,
         CASE WHEN subscription_start < first_day AND (subscription_end BETWEEN first_day AND last_day) AND segment = 87
         THEN 1
         ELSE 0
         END AS is_canceled_87,
         CASE WHEN subscription_start < first_day AND (subscription_end BETWEEN first_day AND last_day) AND segment = 30
         THEN 1
         ELSE 0
         END AS is_canceled_30
FROM cross_join
),
--7. temporary table aggregating the active and canceled subscriptions
status_aggregate AS (
  SELECT month,
         SUM(is_active_87) AS sum_active_87,
         SUM(is_active_30) AS sum_active_30,
         SUM(is_canceled_87) AS sum_canceled_87,
         SUM(is_canceled_30) AS sum_canceled_30
  FROM status
  GROUP BY month
)

--8. Calculate the churn rates
SELECT month,
       1.0 * sum_canceled_87 / sum_active_87 AS churn_rate_87,
       1.0 * sum_canceled_30 / sum_active_30 AS churn_rate_30
FROM status_aggregate;

