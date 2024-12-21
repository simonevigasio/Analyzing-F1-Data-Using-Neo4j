// Drivers with the Most Consecutive Wins
MATCH (result:Result)-[:TAKE_PLACE]->(race:Race)
WHERE result.positionOrder = 1
WITH result, race
ORDER BY race.date
MATCH (driver:Driver)-[:DELIVER]->(result)
WITH collect({driver: driver, date: race.date}) AS results
WITH REDUCE(
    acc = {combined: [], currentStreak: 0, lastDriver: null}, 
    res IN results | 
    CASE 
        WHEN acc.lastDriver = res.driver THEN 
            { 
                combined: acc.combined[0..-1] + [{driver: acc.lastDriver, streak: acc.currentStreak + 1}], 
                currentStreak: acc.currentStreak + 1, 
                lastDriver: res.driver 
            }
        ELSE 
            { 
                combined: acc.combined + [{driver: res.driver, streak: 1}], 
                currentStreak: 1, 
                lastDriver: res.driver 
            }
    END
) AS result
WITH result.combined AS streaksWithDrivers
UNWIND streaksWithDrivers AS streakData
RETURN streakData.driver.driverId AS driverId, 
       streakData.driver.surname AS driverSurname,
       streakData.driver.forename AS driverForename,
       streakData.driver.nationality AS driverNationality, 
       streakData.streak AS streak
ORDER BY streak DESC
