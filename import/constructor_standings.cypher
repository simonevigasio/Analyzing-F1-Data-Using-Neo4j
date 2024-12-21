// Import Constructor Standings Relationships
CREATE CONSTRAINT cs FOR ()-[cs:CONSTRUCTOR_STAND]-() REQUIRE cs.constructorStandingId IS UNIQUE
LOAD CSV WITH HEADERS FROM "file:///constructor_standings.csv" AS csvLine
MATCH (c:Constructor {constructorId: toInteger(csvLine.constructorId)})
MATCH (r:Race {raceId: toInteger(csvLine.raceId)})
MERGE (c)-[cs:CONSTRUCTOR_STAND]->(r)
SET cs.constructorId = toInteger(csvLine.constructorId),
    cs.points = toInteger(csvLine.points),
    cs.position = toInteger(csvLine.position),
    cs.positionText = csvLine.positionText,
    cs.wins = toInteger(csvLine.wins)
