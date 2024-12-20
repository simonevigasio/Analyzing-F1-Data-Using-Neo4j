// TOP 10 MOST RACES WITH A SINGLE CONSTRUCTOR
MATCH (d:Driver)-[:DELIVER]->(r:Result)<-[:DELIVER]-(c:Constructor)
WHERE r.positionOrder = 1
RETURN d.forename AS driverForename, d.surname AS drivesurname, c.name AS constructor, COUNT(r) AS wins
ORDER BY wins DESC
LIMIT 10
