// Import Qualifying Nodes and Their Relationships with Drivers, Constructors, and Races
CREATE CONSTRAINT qualifyingIdConstraint FOR (q:Qualifying) REQUIRE q.qualifyId IS UNIQUE
:auto LOAD CSV WITH HEADERS FROM "file:///qualifying.csv" AS csvLine
CALL (csvLine) {
    MERGE (q:Qualifying {qualifyId: toInteger(csvLine.qualifyId)})
    SET q.raceId = toInteger(csvLine.raceId),
        q.driverId = toInteger(csvLine.driverId),
        q.constructorId = toInteger(csvLine.constructorId),
        q.number = toInteger(csvLine.number),
        q.position = toInteger(csvLine.position),
        q.q1 = (
            CASE
                WHEN csvLine.q1 = '\\N' THEN '0.0'
                ELSE csvLine.q1
            END
        ),
        q.q1Milliseconds = (
            CASE 
                WHEN csvLine.q1 = '\\N' THEN 0.0
                ELSE toInteger((toInteger(split(csvLine.q1, ':')[0]) * 60 + toFloat(split(csvLine.q1, ':')[1])) * 1000)
            END
        ),
        q.q2 = (
            CASE
                WHEN csvLine.q2 = '\\N' THEN '0.0'
                ELSE csvLine.q2
            END
        ),
        q.q2Milliseconds = (
            CASE 
                WHEN csvLine.q2 = '\\N' THEN 0.0
                ELSE toInteger((toInteger(split(csvLine.q2, ':')[0]) * 60 + toFloat(split(csvLine.q2, ':')[1])) * 1000)
            END
        ),
        q.q3 = (
            CASE
                WHEN csvLine.q3 = '\\N' THEN '0.0'
                ELSE csvLine.q3
            END
        ),
        q.q3Milliseconds = (
            CASE 
                WHEN csvLine.q3 = '\\N' THEN 0.0
                ELSE toInteger((toInteger(split(csvLine.q3, ':')[0]) * 60 + toFloat(split(csvLine.q3, ':')[1])) * 1000)
            END
        )
    WITH q, csvLine
    MATCH (d:Driver {driverId: toInteger(csvLine.driverId)})
    MERGE (d)-[:DELIVER]->(q)
    WITH q, csvLine
    MATCH (c:Constructor {constructorId: toInteger(csvLine.constructorId)})
    MERGE (c)-[:DELIVER]->(q)
    WITH q, csvLine
    MATCH (race:Race {raceId: toInteger(csvLine.raceId)})
    MERGE (q)-[:TAKE_PLACE]->(race)
} IN TRANSACTIONS OF 1000 ROWS
