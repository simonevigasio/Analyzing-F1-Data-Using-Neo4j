// CONSTRUCTOR CHAMPIONSHIP FINAL RANK BY YEAR
MATCH (s:Season)-[:PLAN]->(:Race)<-[cs:CONSTRUCTOR_STAND]-(c:Constructor)
WHERE s.year = 2023
RETURN DISTINCT c.name, MAX(cs.points)
ORDER BY MAX(cs.points) DESC