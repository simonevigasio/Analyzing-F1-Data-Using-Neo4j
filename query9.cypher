// MOST START IN 1 POSITION AND NOT WINNIGS
MATCH (d:Driver)- [:DELIVER]->(r:Result)
WHERE r.startingPosition = 1 AND r.positionOrder <> 1
RETURN  d.forename AS driverForename,
        d.surname AS driverSurname,
        COUNT(r) AS Value
ORDER BY Value DESC
LIMIT 10
