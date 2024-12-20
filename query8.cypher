// Most Wins at a Single Circuit by a Single Driver
MATCH (c:Circuit)-[:HOLD]->(r:Race)<-[ds:DRIVER_STAND]-(d:Driver)
WHERE ds.position = 1
WITH c.name AS circuit, d.surname AS driver, COUNT(d) AS wins
ORDER BY circuit, wins DESC
WITH circuit, MAX(wins) AS maxWins, COLLECT({driver: driver, wins: wins}) AS driverWins
UNWIND driverWins AS dw
WITH circuit, maxWins, dw
WHERE dw.wins = maxWins
RETURN circuit, dw.driver AS driver, dw.wins AS wins
ORDER BY wins DESC
