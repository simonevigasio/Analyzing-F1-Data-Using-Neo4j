// Import Constructor Nodes
CREATE CONSTRAINT constructorIdConstraint FOR (c:Constructor) REQUIRE c.constructorId IS UNIQUE
LOAD CSV WITH HEADERS FROM "file:///constructors.csv" AS csvLine CREATE ( 
    c:Constructor { 
        constructorId: toInteger(csvLine.constructorId), 
        constructorRef: csvLine.constructorRef,
        name: csvLine.name,
        nationality: csvLine.nationality
    } 
)
