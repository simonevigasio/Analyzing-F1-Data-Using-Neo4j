// Import Sprint Result Nodes and Their Relationships with Drivers, Constructors, and Races
CREATE CONSTRAINT sprintResultIdConstraint FOR (sr:SprintResult) REQUIRE sr.resultId IS UNIQUE
LOAD CSV WITH HEADERS FROM "file:///sprint_results.csv" AS csvLine
MERGE (sr: SprintResult {resultId: toInteger(csvLine.resultId)})
SET sr.raceId = toInteger(csvLine.raceId),
    sr.driverId = toInteger(csvLine.driverId),
    sr.constructorId = toInteger(csvLine.constructorId),
    sr.number = toInteger(csvLine.number),
    sr.grid = toInteger(csvLine.grid),
    sr.position = (
        CASE
            WHEN csvLine.position = '\\N' THEN 0
            ELSE toInteger(csvLine.position)
        END
    ),
    sr.positionText = csvLine.positionText,
    sr.positionOrder = toInteger(csvLine.positionOrder),
    sr.points = toInteger(csvLine.points),
    sr.laps = toInteger(csvLine.laps),
    sr.time = (
        CASE 
            WHEN csvLine.time = '\\N' THEN '0.0'
            ELSE csvLine.time
        END
    ),
    sr.milliseconds = (
        CASE 
            WHEN csvLine.milliseconds = '\\N' THEN 0
            ELSE toInteger(csvLine.milliseconds)
        END
    ),
    sr.fastestLap = (
        CASE 
            WHEN csvLine.fastestLap = '\\N' THEN 0
            ELSE toInteger(csvLine.fastestLap)
        END
    ),
    sr.fastestLapTime = (
        CASE 
            WHEN csvLine.fastestLapTime = '\\N' THEN '0.0'
            ELSE csvLine.fastestLapTime
        END
    ),
    sr.fastestLapMilliseconds = (
        CASE
            WHEN csvLine.fastestLapTime = '\\N' THEN 0
            ELSE toInteger((toInteger(split(csvLine.fastestLapTime, ':')[0]) * 60 + toFloat(split(csvLine.fastestLapTime, ':')[1])) * 1000)   
        END
    ),
    sr.statusId = csvLine.statusId
WITH sr, csvLine
MATCH (d:Driver {driverId: toInteger(csvLine.driverId)})
MERGE (d)-[:DELIVER]->(sr)
WITH sr, csvLine
MATCH (c:Constructor {constructorId: toInteger(csvLine.constructorId)})
MERGE (c)-[:DELIVER]->(sr)
WITH sr, csvLine
MATCH (race:Race {raceId: toInteger(csvLine.raceId)})
MERGE (sr)-[:TAKE_PLACE]->(race)
