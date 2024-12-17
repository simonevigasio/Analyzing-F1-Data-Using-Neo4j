// MOST WINS AT A SINGLE CIRCUIT
MATCH (c:Circuit)-[:HOLD]->(r:Race)<-[ds:DRIVER_STAND]-(d:Driver)
WHERE ds.position = 1
RETURN c.name AS Circuit, d.surname AS Driver, COUNT(d) AS Wins
ORDER BY Wins DESC
LIMIT 10
