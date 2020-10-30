ALTER TABLE dbo.Address
ADD CountryRegionCode NVARCHAR(3),
	TaxRate SMALLMONEY,
	DiffMin AS TaxRate - 5.00

SELECT  AddressID,
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

MERGE dbo.Address AS _target
	USING #Address AS _source
ON (_target.AddressID = _source.AddressID)
WHEN MATCHED
    THEN UPDATE SET
		_target.CountryRegionCode = _source.CountryRegionCode, 
		_target.TaxRate = _source.TaxRate
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
			_source.AddressID,
			_source.AddressLine1,
			_source.AddressLine2,
			_source.City,
			_source.StateProvinceID,
			_source.PostalCode,
			_source.ModifiedDate,
			_source.CountryRegionCode,
			_source.TaxRate
		 )
WHEN NOT MATCHED BY SOURCE THEN 
	DELETE; 