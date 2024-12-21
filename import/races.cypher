// Import Race Nodes and Their Relationships with Circuits
CREATE CONSTRAINT raceIdConstraint FOR (r:Race) REQUIRE r.raceId IS UNIQUE
LOAD CSV WITH HEADERS FROM 'file:///races.csv' AS csvLine
MERGE (r:Race {raceId: toInteger(csvLine.raceId)})
SET r.year = toInteger(csvLine.year),
    r.round = toInteger(csvLine.round),
    r.circuitId = toInteger(csvLine.circuitId),
    r.name = csvLine.name, 
    r.date = date(csvLine.date)
WITH r, csvLine 
MATCH (c:Circuit {circuitId: toInteger(csvLine.circuitId)})
MERGE (c)-[:HOLD]->(r)
