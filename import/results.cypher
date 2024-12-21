// Import Result Nodes and Their Relationships with Drivers, Constructors, and Races
CREATE CONSTRAINT resultIdConstraint FOR (r:Result) REQUIRE r.resultId IS UNIQUE
:auto LOAD CSV WITH HEADERS FROM "file:///results.csv" AS csvLine
CALL (csvLine) {
    MERGE (r:Result {resultId: toInteger(csvLine.resultId)})
    SET r.raceId = toInteger(csvLine.raceId),
        r.driverId = toInteger(csvLine.driverId),
        r.constructorId = toInteger(csvLine.constructorId),
        r.number = toInteger(csvLine.number),
        r.points = toFloat(csvLine.points),
        r.startingPosition = toInteger(csvLine.grid),
        r.positionOrder = toInteger(csvLine.positionOrder),
        r.position = (
            CASE 
                WHEN csvLine.position = '\\N' THEN 0
                ELSE toInteger(csvLine.position)
            END
        ),
        r.positionText = csvLine.positionText, 
        r.laps = toInteger(csvLine.laps),
        r.time = (
            CASE
                WHEN csvLine.time = '\\N' THEN '0.0'
                ELSE csvLine.time
            END
        ),
        r.milliseconds = (
            CASE             
                WHEN csvLine.milliseconds = '\\N' THEN 0
                ELSE toInteger(csvLine.milliseconds)
            END
        ),
        r.fastestLap = (
            CASE 
                WHEN csvLine.fastestLap = '\\N' THEN 0
                ELSE toInteger(csvLine.fastestLap)
            END
        ),
        r.fastestLapRank = (
            CASE
                WHEN csvLine.rank = '\\N' THEN 0
                ELSE toInteger(csvLine.rank)
            END
        ),
        r.fastestLapTime = (
            CASE 
                WHEN csvLine.fastestLapTime = '\\N' THEN '0.0'
                ELSE csvLine.fastestLapTime
            END
        ),
        r.fastestLapMilliseconds = (
            CASE 
                WHEN csvLine.fastestLapTime = '\\N' THEN 0
                ELSE toInteger((toInteger(split(csvLine.fastestLapTime, ':')[0]) * 60 + toFloat(split(csvLine.fastestLapTime, ':')[1])) * 1000)   
            END
        ),
        r.fastestLapMaxSpeed = (
            CASE 
                WHEN csvLine.fastestLapSpeed = '\\N' THEN 0.0
                ELSE toFloat(csvLine.fastestLapSpeed)
            END
        ),
        r.statusId = csvLine.statusId
    WITH r, csvLine
    MATCH (d:Driver {driverId: toInteger(csvLine.driverId)})
    MERGE (d)-[:DELIVER]->(r)
    WITH r, csvLine
    MATCH (c:Constructor {constructorId: toInteger(csvLine.constructorId)})
    MERGE (c)-[:DELIVER]->(r)
    WITH r, csvLine
    MATCH (race:Race {raceId: toInteger(csvLine.raceId)})
    MERGE (r)-[:TAKE_PLACE]->(race)
} IN TRANSACTIONS OF 1000 ROWS
