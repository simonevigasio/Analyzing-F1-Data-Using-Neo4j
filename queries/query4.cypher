// Constructor Championship for Each Season
MATCH (s:Season)-[:PLAN]->(r:Race)<-[cs:CONSTRUCTOR_STAND]-(c:Constructor)
WITH s, c.name AS constructorName, MAX(cs.points) AS totalPoints
ORDER BY totalPoints DESC
WITH s, COLLECT({constructor: constructorName, points: totalPoints}) AS standsPerYear
WITH s, standsPerYear[0] AS champPerYear 
RETURN s.year AS Season,
       champPerYear.constructor AS constructor,
       champPerYear.points AS points
ORDER BY Season DESC
