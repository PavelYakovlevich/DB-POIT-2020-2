CREATE PROC dbo.MY_PROC 
	@params	NVARCHAR(100)
AS
BEGIN
	DECLARE @sql NVARCHAR(MAX);
	SET @sql = '
SELECT  *
FROM
(
	SELECT 
		PS.Name,
		PP.Class,
		PP.ListPrice
	FROM Production.Product AS PP
	INNER JOIN	Production.ProductSubcategory AS PS
	ON PS.ProductCategoryID = PP.ProductSubcategoryID
) AS P
PIVOT
(
	AVG(ListPrice) 
	FOR Class IN 
	(
		' + @params + ' 
	)
) AS pivot_table '

	EXEC sp_executesql @sql;
END;
GO

EXEC dbo.MY_PROC '[H],[L],[M]'
GO 


