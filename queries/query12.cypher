// Wins from the Furthest Back on the Starting Grid
MATCH (d:Driver)-[:DELIVER]->(r:Result)
WHERE r.positionOrder = 1  
WITH d, r.startingPosition - r.positionOrder AS gridGap, r.raceId AS races
MATCH (race:Race) WHERE race.raceId = races
RETURN d.forename AS driverName, d.surname AS driverSurname, gridGap, race.name AS race
ORDER BY gridGap DESC
