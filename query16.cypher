// TOP 10 PERCENTAGE WINS (AT LEAST 15 STARTS)
MATCH (d:Driver)-[:DELIVER]->(result:Result)
WHERE result.startingPosition <> 0
WITH d, COUNT(result) AS raceForDriver
WHERE raceForDriver >= 15
MATCH (d)-[:DELIVER]->(result:Result)
WHERE result.positionOrder = 1
WITH d, raceForDriver, COUNT(result) AS wins
RETURN d.surname AS driverSurname, 
       d.forename AS driverForename, 
       wins, 
       raceForDriver, 
       (toFloat(wins) / raceForDriver) * 100 AS winPercentage
ORDER BY winPercentage DESC
LIMIT 10
