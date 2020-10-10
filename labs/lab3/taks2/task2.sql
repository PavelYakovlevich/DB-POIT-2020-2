ALTER TABLE dbo.Address
ADD CountryRegionCode NVARCHAR(3),
	TaxRate SMALLMONEY,
	DiffMin AS TaxRate - 5.00

	SELECT * FROM dbo.Address;

SELECT AddressID,
		AddressLine1,
		AddressLine2,
		City,
		StateProvinceID,
		PostalCode,
		ModifiedDate,
		CountryRegionCode,
		TaxRate
INTO #Address
FROM dbo.Address
WHERE 1 = 0;

ALTER TABLE #Address
ADD PRIMARY KEY(AddressID);

WITH TEMP 
AS(
	SELECT 
		AddressID
		AddressLine1,
		AddressLine2,
		City,
		dboA.StateProvinceID,
		PostalCode,
		dboA.ModifiedDate,
		personSP.StateProvinceCode,
		salesTR.TaxRate
	FROM dbo.Address AS dboA
	INNER JOIN Person.StateProvince AS personSP
	ON personSP.StateProvinceID = dboA.StateProvinceID
	INNER JOIN Sales.SalesTaxRate AS salesTR
	ON salesTR.StateProvinceID = dboA.StateProvinceID
	WHERE salesTR.TaxRate > 5.00
)

INSERT INTO #Address 
SELECT * FROM TEMP;

DELETE TOP(1)
FROM dbo.Address
WHERE StateProvinceID = 36

set identity_insert dbo.Address on;

MERGE dbo.Address AS dboA
	USING #Address AS tempA
ON (dboA.AddressID = tempA.AddressID)
WHEN MATCHED
    THEN UPDATE SET
		dboA.CountryRegionCode = tempA.CountryRegionCode, 
		dboA.TaxRate = tempA.TaxRate
WHEN NOT MATCHED BY TARGET
    THEN INSERT 
		 (
			AddressID,
			AddressLine1,
			AddressLine2,
			City,
			StateProvinceID,
			PostalCode,
			ModifiedDate,
			CountryRegionCode,
			TaxRate
		 )
		 VALUES
		 (
			tempA.AddressID,
			tempA.AddressLine1,
			tempA.AddressLine2,
			tempA.City,
			tempA.StateProvinceID,
			tempA.PostalCode,
			tempA.ModifiedDate,
			tempA.CountryRegionCode,
			tempA.TaxRate
		 )
WHEN NOT MATCHED BY SOURCE
    THEN DELETE;