// Import Circuit Nodes
CREATE CONSTRAINT circuitIdConstraint FOR (c:Circuit) REQUIRE c.circuitId IS UNIQUE
LOAD CSV WITH HEADERS FROM "file:///circuits.csv" AS csvLine CREATE ( 
    c:Circuit { 
        circuitId: toInteger(csvLine.circuitId),
        circuitRef: csvLine.circuitRef,
        name: csvLine.name, 
        location: csvLine.location, 
        country: csvLine.country, 
        lat: csvLine.lat, 
        lng: csvLine.lng, 
        alt: csvLine.alt 
    } 
)
