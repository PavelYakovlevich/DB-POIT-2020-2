SELECT AddressID, AddressLine1, AddressLine2, City, StateProvinceID, PostalCode, ModifiedDate
INTO dbo.Address
FROM Person.Address
WHERE 1 = 0;

ALTER TABLE dbo.Address
ADD CONSTRAINT PK_Address PRIMARY KEY(
	StateProvinceId, 
	PostalCode
);

ALTER TABLE dbo.Address
ADD CONSTRAINT PC_CONSTR 
CHECK(PostalCode LIKE '[0-9][0-9][0-9][0-9][0-9]');

ALTER TABLE dbo.Address
ADD CONSTRAINT MD_CONSTR DEFAULT CURRENT_TIMESTAMP FOR ModifiedDate;

INSERT INTO dbo.Address (
	   AddressID, 
	   AddressLine1, 
	   AddressLine2, 
	   City, 
	   PerAddr.StateProvinceID, 
	   PostalCode, 
	   PerAddr.ModifiedDate
)
SELECT AddressID,
	   AddressLine1, 
	   AddressLine2, 
	   City, 
	   StateProvinceID, 
	   PostalCode, 
	   ModifiedDate
FROM (
	SELECT AddressID, 
		   AddressLine1, 
		   AddressLine2, 
		   City, 
		   PerAddr.StateProvinceID, 
		   PostalCode, 
		   PerAddr.ModifiedDate,
		   MAX(AddressID) OVER (PARTITION BY PerAddr.StateProvinceID, PostalCode) AS AddrID
	FROM Person.Address AS PerAddr
	INNER JOIN Person.StateProvince AS StPr
	ON StPr.StateProvinceID = PerAddr.StateProvinceID 
	WHERE StPr.CountryRegionCode = 'US'
	AND PerAddr.PostalCode LIKE '[0-9][0-9][0-9][0-9][0-9]'
) AS A
WHERE A.AddressID = A.AddrID;

ALTER TABLE dbo.Address
ALTER COLUMN City NVARCHAR(20);
