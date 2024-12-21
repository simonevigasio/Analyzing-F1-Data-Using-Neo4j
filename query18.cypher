// Most Races Won with a Single Constructor
MATCH (d:Driver)-[:DELIVER]->(r:Result)<-[:DELIVER]-(c:Constructor)
WHERE r.positionOrder = 1
RETURN d.forename AS driverForename, d.surname AS drivesurname, c.name AS constructor, COUNT(r) AS wins
ORDER BY wins DESC
