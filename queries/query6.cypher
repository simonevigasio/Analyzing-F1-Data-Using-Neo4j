// Number of Championships Won by a Specific Constructor
MATCH (s:Season)-[:PLAN]->(r:Race)<-[cs:CONSTRUCTOR_STAND]-(c:Constructor)
WITH s, c.name AS constructorName, MAX(cs.points) AS totalPoints
ORDER BY totalPoints DESC
WITH s, COLLECT({constructor: constructorName, points: totalPoints}) AS standsPerYear
WITH s, standsPerYear[0] AS champPerYear  
WHERE champPerYear.constructor = 'Ferrari'
WITH s, champPerYear AS constructorChampYear
RETURN s.year AS Season,
       constructorChampYear.constructor AS ConstructorChamp,
       constructorChampYear.points AS Points
ORDER BY Season DESC
