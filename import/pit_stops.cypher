// Import Pit Stop Relationships Between Drivers and Races
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
