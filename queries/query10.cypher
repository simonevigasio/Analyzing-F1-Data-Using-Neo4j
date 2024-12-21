// Circuit with the Highest Win Rate Starting from Pole Position
MATCH (c:Circuit)-[:HOLD]->(r:Race)<-[:TAKE_PLACE]-(res:Result)
WHERE res.startingPosition = 1
WITH c, 
     COUNT(res) AS totalRaces, 
     SUM(CASE WHEN res.startingPosition = 1 AND res.position = 1 THEN 1 ELSE 0 END) AS winsFromPole
WHERE totalRaces >= 15
RETURN c.name AS Circuit, 
       winsFromPole * 1.0 / totalRaces AS WinPercentage
ORDER BY WinPercentage DESC
