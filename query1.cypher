// DRIVER CHAMPIONSHIP FINAL RANK BY YEAR
MATCH (s:Season)-[:PLAN]->(:Race)<-[ds:DRIVER_STAND]-(d:Driver)
WHERE s.year = 2023
RETURN DISTINCT d.forename, d.surname, MAX(ds.points) 
ORDER BY MAX(ds.points) DESC

