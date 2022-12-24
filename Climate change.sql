/*
Codecademy - Analyse data with sql
Climate change project
*/

--1. View the data
SELECT * FROM state_climate
LIMIT 5;

--2. How the average temperature changes over time
SELECT state, year, tempf, tempc,
       AVG(tempc) OVER (
         PARTITION BY state
         ORDER BY year) AS running_avg_temp_c
FROM state_climate; 

--3. Find the lowest temperature for each state
SELECT state, year, tempc,
       FIRST_VALUE(tempc) OVER (
         PARTITION BY state
         ORDER BY tempc
       )
FROM state_climate; 


--4. Find the highest temperature
SELECT state, year, tempc,
       LAST_VALUE(tempc) OVER (
         PARTITION BY state
         ORDER BY tempc
         RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
       ) AS highest_temp
FROM state_climate; 

--5. How the temperature changes each year
SELECT state, year, tempc,
       tempc - LAG(tempc, 1, tempc) OVER (
         PARTITION BY state
         ORDER BY year
       ) AS change_in_temp
FROM state_climate 


--6. finding the rank of the temperature
SELECT RANK() OVER (
      ORDER BY tempc) AS coldest_rank,
       state, year, tempc
FROM state_climate 

--7. finding the rank of the temperature
SELECT RANK() OVER ( 
       PARTITION BY state
       ORDER BY tempc DESC) AS warmest_rank,
       state, year, tempc
FROM state_climate; 


--8. Find the average yearly temperature in quartiles
SELECT NTILE(4) OVER (PARTITION BY state 
       ORDER BY tempc) AS quartile,
       state, year, tempc
FROM state_climate;  

--9. Find the average yearly temperature in quintiles
SELECT NTILE(5) OVER (
  ORDER BY tempc
) AS quintile,
  state, year, tempc
FROM state_climate;