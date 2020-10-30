ALTER TABLE dbo.Address
ADD AddressType NVARCHAR(50);

CREATE TYPE MyType AS TABLE(
	AddressID	INT	NOT NULL,
	AddressLine1 NVARCHAR(60) NOT NULL,
	AddressLine2 NVARCHAR(60) NULL,
	City		NVARCHAR(20) NULL,
	StateProvinceID	INT	NOT NULL,
	PostalCode	NVARCHAR(15) NOT NULL,
	ModifiedDate	DATETIME NOT NULL,
	AddressType	NVARCHAR(50) NULL,
	PRIMARY KEY(StateProvinceID, PostalCode)
);

DECLARE @temp MyType;

INSERT INTO @temp (
	   AddressID, 
	   AddressLine1, 
	   AddressLine2, 
	   City,
	   StateProvinceID, 
	   PostalCode, 
	   ModifiedDate, 
	   AddressType
)
SELECT dboAddr.AddressID, 
	   AddressLine1, 
	   AddressLine2, 
	   City,
	   StateProvinceID, 
	   PostalCode, 
	   ModifiedDate, 
	   Name AS AddressType
FROM dbo.Address dboADDR
INNER JOIN (
	SELECT AddressID,
		   Name
	FROM Person.AddressType AT
	INNER JOIN Person.BusinessEntityAddress as BEA
	ON AT.AddressTypeID = BEA.AddressTypeID
) AS TEMP
ON dboADDR.AddressID = TEMP.AddressID;

UPDATE dbo.Address
SET AddressType = (
		SELECT AddressType
		FROM @temp AS A
		WHERE A.AddressID = dbo.Address.AddressID
	),
	AddressLine2 = (
		SELECT AddressLine1
		FROM @temp AS A
		WHERE dbo.Address.AddressLine2 is NULL AND
			  dbo.Address.AddressID = A.AddressID
	);
	
DELETE dboA FROM dbo.Address AS dboA
	INNER JOIN (
	SELECT AddressType,
		   MAX(AddressId) as MaxID
	FROM dbo.Address
	GROUP BY(AddressType)
) AS A
ON A.AddressType = dboA.AddressType
WHERE dboA.AddressID != A.MaxID

ALTER TABLE dbo.Address
DROP CONSTRAINT PK_Address, PC_CONSTR;

ALTER TABLE dbo.Address
DROP COLUMN AddressType;

SELECT *
FROM AdventureWorks2012.INFORMATION_SCHEMA.
WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'Address';

SELECT
    default_constraints.name
FROM 
    sys.all_columns

        INNER JOIN
    sys.tables
        ON all_columns.object_id = tables.object_id

        INNER JOIN 
    sys.schemas
        ON tables.schema_id = schemas.schema_id

        INNER JOIN
    sys.default_constraints
        ON all_columns.default_object_id = default_constraints.object_id

WHERE 
        schemas.name = 'dbo'
    AND tables.name = 'Address'
    AND all_columns.name = 'columnname'


ALTER TABLE Persons
ALTER COLUMN City DROP DEFAULT;

DROP TABLE dbo.Address;




