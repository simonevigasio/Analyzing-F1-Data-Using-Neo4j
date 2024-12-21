// Drivers with the Most Wins
MATCH (r:Result) WHERE r.positionOrder = 1
WITH r
MATCH (d:Driver)-[:DELIVER]->(r)
RETURN d.surname AS driverSurname, 
       d.forename AS driverForename,
       d.nationality AS driverNationality, 
       COUNT(r) AS wins
ORDER BY wins DESC
