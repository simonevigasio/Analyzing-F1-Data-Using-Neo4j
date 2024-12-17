// DRIVER CHAMPIONSHIP FINAL RANK BY YEAR
MATCH (s:Season)-[:PLAN]->(:Race)<-[ds:DRIVER_STAND]-(d:Driver)
WHERE s.year = 2023
RETURN DISTINCT d.forename, d.surname, MAX(ds.points) 
ORDER BY MAX(ds.points) DESC

// CONSTRUCTOR CHAMPIONSHIP FINAL RANK BY YEAR
MATCH (s:Season)-[:PLAN]->(:Race)<-[cs:CONSTRUCTOR_STAND]-(c:Constructor)
WHERE s.year = 2023
RETURN DISTINCT c.name, MAX(cs.points)
ORDER BY MAX(cs.points) DESC

// CONSTRUCTOR CHAMPIONSHIP FOR EACH SEASON
MATCH (s:Season)-[:PLAN]->(r:Race)<-[cs:CONSTRUCTOR_STAND]-(c:Constructor)
WITH s, c.name AS constructorName, MAX(cs.points) AS totalPoints
ORDER BY totalPoints DESC
WITH s, COLLECT({constructor: constructorName, points: totalPoints}) AS standsPerYear
WITH s, standsPerYear[0] AS champPerYear 
RETURN s.year AS Season,
       champPerYear.constructor AS constructorChamp,
       champPerYear.points AS points
ORDER BY Season DESC

// DRIVER CHAMPIONSHIP FOR EACH SEASON
MATCH (s:Season)-[:PLAN]->(r:Race)<-[ds:DRIVER_STAND]-(d:Driver)
WITH s, d.forename AS driverForename, d.surname AS driverSurname, MAX(ds.points) AS totalPoints
ORDER BY totalPoints DESC
WITH s, COLLECT({driverForename: driverForename, driverSurname: driverSurname, points: totalPoints}) AS standsPerYear
WITH s, standsPerYear[0] AS champPerYear 
RETURN s.year AS Season,
       champPerYear.driverForename AS driverForenameChamp,
       champPerYear.driverSurname AS driverSurnameChamp,
       champPerYear.points AS points
ORDER BY Season DESC

// NUMBER CHAMPIONSHIP PER DRIVER
MATCH (s:Season)-[:PLAN]->(r:Race)<-[ds:DRIVER_STAND]-(d:Driver)
WITH s, d.forename AS driverForename, d.surname AS driverSurname, MAX(ds.points) AS totalPoints
ORDER BY totalPoints DESC
WITH s, COLLECT({driverForename: driverForename, driverSurname: driverSurname, points: totalPoints}) AS standsPerYear
WITH standsPerYear[0] AS champPerYear  
RETURN champPerYear.driverForename AS forename, 
       champPerYear.driverSurname AS surname, 
       COUNT(*) AS championships
ORDER BY championships DESC
