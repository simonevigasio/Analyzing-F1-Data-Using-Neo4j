// Most races before scoring a podium finish
MATCH (d:Driver)-[:DELIVER]->(res:Result)-[:TAKE_PLACE]->(r:Race)<-[:PLAN]-(s:Season)
WITH d, collect({race: r, result: res}) AS finishes
WHERE ANY(finish IN finishes WHERE finish.result.positionOrder IN [1, 2, 3])
UNWIND finishes AS finish
WITH d, finish.race AS race, finish.result.positionOrder AS positionOrder, finish.race.date AS raceDate
ORDER BY raceDate ASC 
WITH d, collect({race: race, positionOrder: positionOrder}) AS orderedRaces
WITH d, orderedRaces, 
     REDUCE(
        s = { val: 0, podium: 1 }, 
        r IN orderedRaces | 
        CASE 
            WHEN r.positionOrder IN [1, 2, 3] AND s.podium = 1 THEN 
                { val: s.val, podium: 0 }  
            ELSE 
                { val: s.val + s.podium * 1, podium: s.podium }  
        END
    ) AS racesBeforePodium

RETURN d.forename AS forename, d.surname AS surname, racesBeforePodium.val AS racesBeforePodium
ORDER BY racesBeforePodium DESC
