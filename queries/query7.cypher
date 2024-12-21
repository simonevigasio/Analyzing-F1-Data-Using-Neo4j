// Driver Champions with the Minimum Gap to the Second Place from 2010 Onwards
MATCH (s:Season)-[:PLAN]->(r:Race)<-[ds:DRIVER_STAND]-(d:Driver)
WHERE r.year >= 2010
WITH s, d.forename AS driverForename, d.surname AS driverSurname, MAX(ds.points) AS totalPoints
ORDER BY totalPoints DESC
WITH s, collect({driverForename: driverForename, driverSurname: driverSurname, points: totalPoints}) AS standsPerYear
WITH s, standsPerYear[0] AS champion, standsPerYear[1] AS runnerUp
RETURN s.year AS season,
       champion.driverForename + " " + champion.driverSurname AS champion,
       runnerUp.driverForename + " " + runnerUp.driverSurname AS runnerUp,
       champion.points - runnerUp.points AS pointsGap
ORDER BY pointsGap ASC
