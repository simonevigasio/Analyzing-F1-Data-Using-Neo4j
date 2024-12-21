// Constructor Championship Final Rank by Year
MATCH (s:Season)-[:PLAN]->(:Race)<-[cs:CONSTRUCTOR_STAND]-(c:Constructor)
WHERE s.year = 2023
RETURN DISTINCT c.name AS constructor, MAX(cs.points) AS points
ORDER BY points DESC
