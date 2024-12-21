// Import Driver Nodes
CREATE CONSTRAINT driverIdConstraint FOR (d:Driver) REQUIRE d.driverId IS UNIQUE
LOAD CSV WITH HEADERS FROM "file:///drivers.csv" AS csvLine CREATE ( 
    d:Driver { 
        driverId: toInteger(csvLine.driverId), 
        driverRef: csvLine.driverRef,
        number: (
            CASE 
                WHEN csvLine.number = '\\N' THEN 0
                ELSE toInteger(csvLine.number)
            END
        ),
        code: (
            CASE 
                WHEN csvLine.code = '\\N' THEN 'NOT_SET'
                ELSE csvLine.code
            END
        ),
        forename: csvLine.forename,
        surname: csvLine.surname,
        dob: date(csvLine.dob),
        nationality: csvLine.nationality
    } 
)
