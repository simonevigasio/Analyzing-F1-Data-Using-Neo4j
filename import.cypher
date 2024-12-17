// F1-DB: https://www.kaggle.com/datasets/rohanrao/formula-1-world-championship-1950-2020/data?select=constructors.csv

// IMPORT CIRCUIT NODES
CREATE CONSTRAINT circuitIdConstraint FOR (c:Circuit) REQUIRE c.circuitId IS UNIQUE
LOAD CSV WITH HEADERS FROM "file:///circuits.csv" AS csvLine CREATE ( 
    c:Circuit { 
        circuitId: toInteger(csvLine.circuitId),
        circuitRef: csvLine.circuitRef,
        name: csvLine.name, 
        location: csvLine.location, 
        country: csvLine.country, 
        lat: csvLine.lat, 
        lng: csvLine.lng, 
        alt: csvLine.alt 
    } 
)

// IMPORT DRIVER NODES
CREATE CONSTRAINT driverIdConstraint FOR (d:Driver) REQUIRE d.driverId IS UNIQUE
LOAD CSV WITH HEADERS FROM "file:///drivers.csv" AS csvLine CREATE ( 
    d:Driver { 
        driverId: toInteger(csvLine.driverId), 
        driverRef: csvLine.driverRef,
        number: (
            CASE 
                WHEN csvLine.number = '\\N' THEN 0
                ELSE toInteger(csvLine.number)
            END
        ),
        code: (
            CASE 
                WHEN csvLine.code = '\\N' THEN 'NOT_SET'
                ELSE csvLine.code
            END
        ),
        forename: csvLine.forename,
        surname: csvLine.surname,
        dob: date(csvLine.dob),
        nationality: csvLine.nationality
    } 
)

// IMPORT CONSTRUCTOR NODES
CREATE CONSTRAINT constructorIdConstraint FOR (c:Constructor) REQUIRE c.constructorId IS UNIQUE
LOAD CSV WITH HEADERS FROM "file:///constructors.csv" AS csvLine CREATE ( 
    c:Constructor { 
        constructorId: toInteger(csvLine.constructorId), 
        constructorRef: csvLine.constructorRef,
        name: csvLine.name,
        nationality: csvLine.nationality
    } 
)

// IMPORT RACE NODES AND RELATIONSHIPS WITH CIRCUITS
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

// IMPORT SEASON NODES AND RELATIONSHIPS WITH RACES
CREATE CONSTRAINT seasonIdConstraint FOR (s:Season) REQUIRE s.year IS UNIQUE
LOAD CSV WITH HEADERS FROM "file:///seasons.csv" AS csvLine 
MERGE (s:Season {year: toInteger(csvLine.year)}) 
WITH csvLine, s
MERGE (r:Race {year: toInteger(csvLine.year)}) 
MERGE (s)-[:PLAN]->(r)

// IMPORT RESULT NODES AND RELATIONSHIPS WITH DRIVERS, CONSTRUCTORS, AND RACES
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

// IMPORT QUALIFYING NODES AND RELATIONSHIPS WITH DRIVERS, CONSTRUCTORS, AND RACES
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

// IMPORT SPRINT_RESULT NODES AND RELATIONSHIPS WITH DRIVERS, CONSTRUCTORS, AND RACES
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

// IMPORT DRIVER STANDING REPATIONSHIPS
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

// IMPORT CONSTRUCTOR STANDINGS RELATIONSHIPS
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

// IMPORT PIT_STOP RELATIONSHIPS BETWEEN DRIVERS AND RACES
LOAD CSV WITH HEADERS FROM "file:///pit_stops.csv" AS csvLine
MATCH (d:Driver {driverId: toInteger(csvLine.driverId)})
MATCH (r:Race {raceId: toInteger(csvLine.raceId)})
CREATE (d)-[ps:PIT_STOP]->(r)
SET ps.driverId = toInteger(csvLine.driverId),
    ps.raceId = toInteger(csvLine.raceId),
    ps.stop = toInteger(csvLine.stop),
    ps.lap = toInteger(csvLine.lap),
    ps.time = time(csvLine.time),
    ps.duration = csvLine.duration,
    ps.milliseconds = toInteger(csvLine.milliseconds)
