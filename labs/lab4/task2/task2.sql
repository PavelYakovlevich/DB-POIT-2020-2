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
CREATE TRIGGER insted_of_insert
ON	temp_view
INSTEAD OF INSERT
AS
	INSERT INTO Production.WorkOrder 
	SELECT 
		i.ProductID,
		i.OrderQty,
		i.ScrappedQty,
		i.StartDate,
		i.EndDate,
		i.DueDate,
		i.ScrapReasonID,
		i.ModifiedDate
	FROM inserted AS i

	INSERT INTO Production.ScrapReason
	SELECT 
		i.SCName,
		i.ModifiedDate
	FROM inserted AS i
GO	

drop trigger insted_of_update
CREATE TRIGGER insted_of_update
ON	temp_view
INSTEAD OF UPDATE
AS
	select * from inserted;

	IF(UPDATE(ProductID))
	BEGIN
		UPDATE Production.WorkOrder
		SET ProductID = I.ProductID,
			ModifiedDate = GETDATE()
		FROM inserted AS I
	END

	IF(UPDATE(ScrappedQty))
	BEGIN
		UPDATE Production.WorkOrder
		SET ScrappedQty = I.ScrappedQty,
			ModifiedDate = GETDATE()
		FROM inserted AS I
	END

	IF(UPDATE(StartDate))
	BEGIN
		UPDATE Production.WorkOrder
		SET StartDate = I.StartDate,
			ModifiedDate = GETDATE()
		FROM inserted AS I
	END

	IF(UPDATE(EndDate))
	BEGIN
		UPDATE Production.WorkOrder
		SET EndDate = I.EndDate,
			ModifiedDate = GETDATE()
		FROM inserted AS I
	END

	IF(UPDATE(DueDate))
	BEGIN
		UPDATE Production.WorkOrder
		SET DueDate = I.DueDate,
			ModifiedDate = GETDATE()
		FROM inserted AS I
	END
	 
	IF(UPDATE(ScrapReasonID))
	BEGIN
		UPDATE Production.WorkOrder
		SET ScrapReasonID = I.ScrapReasonID,
			ModifiedDate = GETDATE()
		FROM inserted AS I
	END

	IF(UPDATE(ScrapReasonID))
	BEGIN
		UPDATE Production.WorkOrder
		SET ScrapReasonID = I.ScrapReasonID,
			ModifiedDate = GETDATE()
		FROM inserted AS I
	END

	IF(UPDATE(SCName))
	BEGIN
		UPDATE Production.ScrapReason
		SET Name = I.SCName,
			ModifiedDate = GETDATE()
		FROM inserted AS I
	END
GO

CREATE TRIGGER insted_of_delete
ON	temp_view
INSTEAD OF DELETE
AS
	DELETE FROM Production.WorkOrder 
	WHERE WorkOrderID IN 
	(
		SELECT WorkOrderID
		FROM deleted
	)
	
	DELETE FROM Production.ScrapReason
	WHERE ScrapReasonID IN 
	(
		SELECT ScrapReasonID
		FROM deleted
	)
GO

INSERT INTO temp_view
VALUES
(
	2000001,
	1,
	1,
	123,
	123,
	GETDATE(),
	GETDATE(),
	GETDATE(),
	5,
	GETDATE(),
	'TEST1',
	GETDATE(),
	'Adjustable Race'
)

select * from temp_view

update temp_view
set
	DueDate = GETDATE()
where ProductName = 'Adjustable Race'

select * from Production.WorkOrder

SELECT * 
FROM Production.WorkOrder

SELECT * 
FROM Production.ScrapReason

SELECT TE.*  
FROM sys.trigger_events AS TE  
JOIN sys.triggers AS T ON T.object_id = TE.object_id  
WHERE T.parent_class = 0 AND T.name = 'safety';  
GO  