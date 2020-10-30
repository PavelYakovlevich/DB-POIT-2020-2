CREATE FUNCTION Purchasing.MY_SUM(
	@ID		INT
)
RETURNS MONEY AS
BEGIN
	DECLARE @res MONEY;

	SELECT @res = SUM(LineTotal)
	FROM Purchasing.PurchaseOrderDetail
	WHERE PurchaseOrderID = @id
	GROUP BY(PurchaseOrderID)

	RETURN @res;
END
GO

---------------------------------------------

CREATE FUNCTION Purchasing.GET_BEST_ORDERS(
	@id				INT,
	@lines_count	INT
)
RETURNS TABLE
AS
RETURN (
	SELECT TOP(@lines_count) *
	FROM Sales.SalesOrderHeader
	WHERE CustomerID = @id
	ORDER BY TotalDue DESC
);
GO

---------------------------------------------

SELECT SalesC.CustomerID, T.TotalDue
FROM Sales.Customer AS SalesC
CROSS APPLY(
	SELECT *
	FROM Purchasing.GET_BEST_ORDERS(SalesC.CustomerID,2) AS Y
) AS T

SELECT SalesC.CustomerID, T.TotalDue
FROM Sales.Customer AS SalesC
OUTER APPLY(
	SELECT *
	FROM Purchasing.GET_BEST_ORDERS(SalesC.CustomerID,2) AS Y
) AS T
GO
---------------------------------------------

CREATE FUNCTION Purchasing.GET_BEST_ORDERS2(
	@id				INT,
	@lines_count	INT
)
RETURNS 
@RESULT TABLE(
	CustomerID	INT,
	TotalDue	MONEY
)
AS
BEGIN
	INSERT INTO @RESULT 
	SELECT TOP(@lines_count) CustomerID, TotalDue
	FROM Sales.SalesOrderHeader
	WHERE CustomerID = @id
	ORDER BY TotalDue DESC

	RETURN
END

GO

---------------------------------------------

SELECT Purchasing.MY_SUM(2);
SELECT * FROM Purchasing.GET_BEST_ORDERS(29825,3)
SELECT * FROM Purchasing.GET_BEST_ORDERS2(29825,3)

SELECT * FROM Sales.SalesOrderHeader
WHERE CustomerID = 29825;
