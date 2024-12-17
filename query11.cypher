// YOUGEST DRIVER CHAMPIONS LIST CONSIDERING THE LAST RACE OF THE SEASON
MATCH (s:Season)-[:PLAN]->(r:Race)
WITH s, MAX(r.date) AS lastRaceDate
MATCH (s)-[:PLAN]->(r:Race)<-[ds:DRIVER_STAND]-(d:Driver)
WITH s, d.forename AS driverForename, d.surname AS driverSurname, d.dob AS driverDob, MAX(ds.points) AS totalPoints, lastRaceDate
ORDER BY totalPoints DESC
WITH s, 
    COLLECT({ driverForename: driverForename, driverSurname: driverSurname, driverDob: driverDob, points: totalPoints}) AS standsPerYear,
    lastRaceDate
WITH s, standsPerYear[0] AS champPerYear, lastRaceDate
WITH s, champPerYear.driverForename AS forename, champPerYear.driverSurname AS surname, champPerYear.driverDob AS dob, 
    duration.between(champPerYear.driverDob, lastRaceDate).years AS ageAtWinYears,
    duration.between(champPerYear.driverDob, lastRaceDate).months AS ageAtWinMonths,
    duration.between(champPerYear.driverDob, lastRaceDate).days AS ageAtWinDays,
    champPerYear.points AS points
ORDER BY ageAtWinYears ASC, ageAtWinMonths ASC, ageAtWinDays ASC
RETURN forename, surname, dob, ageAtWinYears AS years, ageAtWinMonths AS months, ageAtWinDays AS days, points, s.year AS season
