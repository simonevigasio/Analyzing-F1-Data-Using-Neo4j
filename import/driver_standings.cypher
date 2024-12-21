// Import Driver Standing Relationships
CREATE CONSTRAINT ds FOR ()-[ds:DRIVER_STAND]-() REQUIRE ds.driverStandingId IS UNIQUE
LOAD CSV WITH HEADERS FROM "file:///driver_standings.csv" AS csvLine
MATCH (d:Driver {driverId: toInteger(csvLine.driverId)})
MATCH (r:Race {raceId: toInteger(csvLine.raceId)})
MERGE (d)-[ds:DRIVER_STAND]->(r)
SET ds.driverStandingId = toInteger(csvLine.driverStandingId),
    ds.points = toInteger(csvLine.points),
    ds.position = toInteger(csvLine.position),
    ds.positionText = csvLine.positionText,
    ds.wins = toInteger(csvLine.wins)
    