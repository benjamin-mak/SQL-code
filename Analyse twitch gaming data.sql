/*
Codecademy - Analyse data with sql
Analyse twitch gaming data project
*/

--1. View the data
SELECT * FROM stream
LIMIT 20;
SELECT * FROM chat
LIMIT 20;

--2. and 3. Find the unique games and channels
SELECT DISTINCT game 
FROM stream;

SELECT DISTINCT channel
FROM stream;

--4. Most popular games
SELECT game, COUNT(*)
FROM stream
GROUP BY game
ORDER BY COUNT(*) DESC;

--5. Number of viewers for LoL 
SELECT country, COUNT(*)
FROM stream
WHERE game = 'League of Legends'
GROUP BY country
ORDER BY COUNT(*) DESC;

--6. List of players and their number of streamers
SELECT player, COUNT(*)
FROM stream
GROUP BY 1
ORDER BY 2 DESC;

--7. Group games into their genres
SELECT game,
       CASE WHEN game = 'League of Legends' THEN 'MOBA'
       WHEN game = 'Dota 2' THEN 'MOBA'
       WHEN game = 'Heroes of the Storm' THEN 'MOBA'
       WHEN game = 'Counter-Strike: Global Offensive' THEN 'FPS'
       WHEN game = 'DayZ' THEN 'Survival'
       WHEN game = 'ARK: Survival Evolved' THEN 'Survival'
       ELSE 'Other'
       END AS 'genre',
       COUNT(*)
FROM stream
GROUP BY game
ORDER BY COUNT(*) DESC;

--8. and 9. Return formatted date
SELECT time FROM stream
LIMIT 10;

SELECT time, STRFTIME('%S', time)
FROM stream
GROUP by 1
LIMIT 20;


--10. Return hours and view count
SELECT STRFTIME('%H', time), 
      COUNT(*)
FROM stream
WHERE country ='SG'
GROUP BY 1;

--11. Join tables
SELECT * 
FROM stream
JOIN chat
ON stream.device_id = chat.device_id;
