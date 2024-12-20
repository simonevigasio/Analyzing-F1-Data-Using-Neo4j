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
