// HOW MANY CHAMPIONSHIPS THE FERRARI CONSTRUCTOR HAS WON

// NB: In the 2007 Formula 1 season, McLaren-Mercedes scored a total of 218 points in the Constructors' Championship.
// However, due to their involvement in the "Spygate" controversy, the team was disqualified from the Constructors' Championship, and their points were not officially counted in the final standings.

MATCH (s:Season)-[:PLAN]->(r:Race)<-[cs:CONSTRUCTOR_STAND]-(c:Constructor)
WITH s, c.name AS constructorName, MAX(cs.points) AS totalPoints
ORDER BY totalPoints DESC
WITH s, COLLECT({constructor: constructorName, points: totalPoints}) AS standsPerYear
WITH s, standsPerYear[0] AS champPerYear  
WHERE champPerYear.constructor = 'Ferrari'
WITH s, champPerYear AS ferrariChampionYear
RETURN s.year AS Season,
       ferrariChampionYear.constructor AS ConstructorChamp,
       ferrariChampionYear.points AS Points
ORDER BY Season DESC
