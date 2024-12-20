// Most Starts in Pole Position Without Winning
MATCH (d:Driver)-[:DELIVER]->(r:Result)
WHERE r.startingPosition = 1 AND r.positionOrder <> 1
RETURN  d.forename AS driverName,
        d.surname AS driverSurname,
        COUNT(r) AS Value
ORDER BY Value DESC
