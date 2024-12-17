// TOP 10 DRIVERS WITH MOST WINS
MATCH (r:rResult) WHERE r.positionOrder = 1
WITH r
MATCH (d:Driver)-[:DELIVER]->(r)
RETURN d.surname AS driverSurname, 
       d.driverId AS driverId, 
       d.forename AS driverForename,
       d.nationality AS driverNationality, 
       COUNT(r) AS wins
ORDER BY wins DESC
LIMIT 10
