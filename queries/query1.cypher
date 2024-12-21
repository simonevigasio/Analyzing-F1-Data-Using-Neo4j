// Driver Championship Final Rank by Year
MATCH (s:Season)-[:PLAN]->(:Race)<-[ds:DRIVER_STAND]-(d:Driver)
WHERE s.year = 2023
RETURN DISTINCT d.forename AS driverName, d.surname AS driverSurname, MAX(ds.points) AS points
ORDER BY points DESC
