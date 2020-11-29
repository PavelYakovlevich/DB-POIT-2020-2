SELECT 
	ProdWO.WorkOrderID,
	ProdWO.ProductID,
	ProdWO.OrderQty,
	ProdWO.ScrappedQty,
	ProdWO.StockedQty,
	ProdWO.StartDate,
	ProdWO.EndDate,
	ProdWO.DueDate,
	ProdWO.ScrapReasonID,
	ProdWO.ModifiedDate,
	ProdSR.Name AS SCName,
	ProdSR.ModifiedDate AS PSRModifiedDate,
	ProdP.Name as ProductName
INTO #temp_table
FROM Production.WorkOrder AS ProdWO
INNER JOIN Production.ScrapReason AS ProdSR
ON	ProdWO.ScrapReasonID = ProdSR.ScrapReasonID
INNER JOIN Production.Product as ProdP
ON ProdP.ProductID = ProdWO.ProductID

DELETE 
FROM #temp_table
GO


select * from temp_view;

CREATE VIEW temp_view
WITH ENCRYPTION, SCHEMABINDING
AS
SELECT 
	ProdWO.WorkOrderID,
	ProdWO.ProductID,
	ProdWO.OrderQty,
	ProdWO.ScrappedQty,
	ProdWO.StockedQty,
	ProdWO.StartDate,
	ProdWO.EndDate,
	ProdWO.DueDate,
	ProdWO.ScrapReasonID,
	ProdWO.ModifiedDate,
	ProdSR.Name AS SCName,
	ProdSR.ModifiedDate AS PSRModifiedDate,
	ProdP.Name as ProductName
FROM Production.WorkOrder AS ProdWO
INNER JOIN Production.ScrapReason AS ProdSR
	ON	ProdWO.ScrapReasonID = ProdSR.ScrapReasonID
INNER JOIN Production.Product as ProdP
	ON ProdP.ProductID = ProdWO.ProductID
GO

CREATE UNIQUE CLUSTERED INDEX IDX_V1
   ON temp_view (WorkOrderID);
GO
---------------------------------------------------------

CREATE TRIGGER instead_of_insert
ON temp_view
INSTEAD OF INSERT
AS
	WITH DSR AS
	(
		SELECT DISTINCT
			SCR.Name
		FROM inserted as I
		LEFT JOIN Production.ScrapReason as SCR
			ON SCR.Name = I.SCName
		WHERE SCR.Name IS NULL
	)

	INSERT INTO Production.ScrapReason
	SELECT 
		DSR.Name,
		GETDATE()
	FROM DSR

	INSERT INTO Production.WorkOrder 
	SELECT 
		P.ProductID,
		I.OrderQty,
		I.ScrappedQty,
		I.StartDate,
		I.EndDate,
		I.DueDate,
		SR.ScrapReasonID,
		GETDATE()
	FROM inserted AS I
	INNER JOIN Production.Product AS P
		ON P.Name = I.ProductName
	INNER JOIN Production.ScrapReason AS SR
		ON SR.Name = I.SCName
GO	

CREATE TRIGGER instead_of_update
ON temp_view
INSTEAD OF UPDATE
AS
	UPDATE Production.WorkOrder
	SET ProductID = I.ProductID,
		ScrappedQty = I.ScrappedQty,
		DueDate = I.DueDate,
		ModifiedDate = GETDATE()
	FROM inserted AS I
	INNER JOIN Production.WorkOrder AS ProdWO
		ON I.ProductID = ProdWO.ProductID


	UPDATE Production.ScrapReason
	SET Name = I.SCName,
		ModifiedDate = GETDATE()
	FROM inserted AS I
	INNER JOIN Production.ScrapReason AS ProdSR
		ON I.ScrapReasonID = ProdSR.ScrapReasonID
	
GO

CREATE TRIGGER instead_of_delete
ON temp_view
INSTEAD OF DELETE
AS
	DELETE PWO
	FROM Production.WorkOrder as PWO
	INNER JOIN Production.Product as PP
		ON PWO.ProductID = PP.ProductID
	INNER JOIN deleted as D
		ON D.ProductName = PP.Name;

	DELETE PSR
	FROM Production.ScrapReason as PSR
	INNER JOIN Production.WorkOrder as PWO
		ON PWO.ScrapReasonID = PSR.ScrapReasonID 
	INNER JOIN Production.Product as PP
		ON PP.ProductID = PWO.ProductID 
	INNER JOIN deleted as D
		ON PP.Name = D.ProductName 
	where Not exists(select * from Production.WorkOrder as temp where temp.ScrapReasonID = PSR.ScrapReasonID);
GO

INSERT INTO temp_view
(
	WorkOrderID,
	ProductID,
	OrderQty,
	ScrappedQty,
	StartDate,
	EndDate,
	DueDate,
	ScrapReasonID,
	ModifiedDate,
	SCName,
	PSRModifiedDate,
	ProductName
)
VALUES
(
	8888888,
	2,
	8,
	8,
	GETDATE(),
	GETDATE(),
	GETDATE(),
	1,
	GETDATE(),
	'TEST13',
	GETDATE(),
	'Adjustable Race'
),
(
	8888889,
	2,
	8,
	8,
	GETDATE(),
	GETDATE(),
	GETDATE(),
	1,
	GETDATE(),
	'TEST13',
	GETDATE(),
	'Adjustable Race'
),
(
	8888890,
	2,
	8,
	8,
	GETDATE(),
	GETDATE(),
	GETDATE(),
	1,
	GETDATE(),
	'TEST13',
	GETDATE(),
	'Adjustable Race'
);


update temp_view
set
	ModifiedDate = GETDATE(),
	PSRModifiedDate = GETDATE()
where ProductName = 'Adjustable Race'

delete
from temp_view
where ProductName = 'Adjustable Race'

SELECT *
FROM Production.WorkOrder

SELECT * 
FROM Production.ScrapReason

select *
from Production.WorkOrder as p1
inner join Production.Product as p2
on p1.ProductID = p2.ProductID

select *
from temp_view
where ProductName = 'Adjustable Race'