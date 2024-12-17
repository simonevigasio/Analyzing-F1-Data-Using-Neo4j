// Highest percentage of podium finishes in a season
MATCH (d:Driver)-[:DELIVER]->(res:Result)-[:TAKE_PLACE]->(r:Race)<-[:PLAN]-(s:Season)
WHERE res.positionOrder IN [1, 2, 3] 
WITH s, d, COUNT(res) AS podiumFinishes
MATCH (s:Season)-[:PLAN]->(r:Race)
WITH s, d, podiumFinishes, COUNT(r) AS totalRaces
WITH s, d, (toFloat(podiumFinishes) / totalRaces) * 100 AS podiumPercentage, podiumFinishes, totalRaces
RETURN 
    s.year AS seasonYear, 
    d.forename AS forename, 
    d.surname AS surname, 
    podiumPercentage, 
    podiumFinishes, 
    totalRaces
ORDER BY podiumPercentage DESC
LIMIT 10
