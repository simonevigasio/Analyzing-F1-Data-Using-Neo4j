// Number of Championships per Driver
MATCH (s:Season)-[:PLAN]->(r:Race)<-[ds:DRIVER_STAND]-(d:Driver)
WITH s, d.forename AS driverForename, d.surname AS driverSurname, MAX(ds.points) AS totalPoints
ORDER BY totalPoints DESC
WITH s, COLLECT({driverForename: driverForename, driverSurname: driverSurname, points: totalPoints}) AS standsPerYear
WITH standsPerYear[0] AS champPerYear  
RETURN champPerYear.driverForename AS forename, 
       champPerYear.driverSurname AS surname, 
       COUNT(*) AS championships
ORDER BY championships DESC
