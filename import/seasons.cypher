// Import Season Nodes and Their Relationships with Races
CREATE CONSTRAINT seasonIdConstraint FOR (s:Season) REQUIRE s.year IS UNIQUE
LOAD CSV WITH HEADERS FROM "file:///seasons.csv" AS csvLine 
MERGE (s:Season {year: toInteger(csvLine.year)}) 
WITH csvLine, s
MERGE (r:Race {year: toInteger(csvLine.year)}) 
MERGE (s)-[:PLAN]->(r)
