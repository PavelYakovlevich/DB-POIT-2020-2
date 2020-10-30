DROP TABLE Production.WorkOrderHst

CREATE TABLE Production.WorkOrderHst(
	ID				INT IDENTITY(1,1) NOT NULL,
	Action			NVARCHAR(6)		  NOT NULL,
	ModifiedDafe	DATETIME		  NOT NULL,
	SourceId		INT				  NOT NULL,
	UserName		NVARCHAR(50)	  NOT NULL,
	PRIMARY KEY(ID, SourceId)
)
GO

CREATE TRIGGER AFTER_INSERT_DEL_UPD
ON Production.WorkOrder
AFTER INSERT, UPDATE, DELETE
AS
	DECLARE @action_name NVARCHAR(6);

	IF(NOT EXISTS(
		SELECT * 
		FROM deleted
	))
	BEGIN
		SET @action_name = 'Insert'
	END
	ELSE IF(NOT EXISTS(
		SELECT * 
		FROM inserted
	))
	BEGIN
		SET @action_name = 'Delete'
	END
	ELSE 
	BEGIN 
		SET @action_name = 'Update'
	END

	INSERT 
	INTO Production.WorkOrderHst
	(
		Action,
		ModifiedDafe,
		SourceId,
		UserName
	)
	SELECT 
		@action_name,
		GETDATE(),
		A.WorkOrderID,
		SYSTEM_USER
	FROM
	(
		SELECT DISTINCT WorkOrderID
		FROM inserted
		UNION 
		SELECT WorkOrderID
		FROM deleted
	) A
GO

DROP VIEW All_colums
GO

CREATE VIEW All_colums
AS 
	SELECT * 
	FROM Production.WorkOrder

GO

SET IDENTITY_INSERT Production.WorkOrder ON;

INSERT INTO All_colums (
	WorkOrderID,
	ProductID,
	OrderQty,
	ScrappedQty,
	StartDate,
	EndDate,
	DueDate,
	ScrapReasonID,
	ModifiedDate
)
VALUES(
	111454,
	456,
	8,
	255,
	GETDATE(),
	GETDATE(),
	GETDATE(),
	NULL,
	GETDATE()
)

INSERT INTO All_colums (
	WorkOrderID,
	ProductID,
	OrderQty,
	ScrappedQty,
	StartDate,
	EndDate,
	DueDate,
	ScrapReasonID,
	ModifiedDate
)
VALUES(
	111457,
	456,
	8,
	255,
	GETDATE(),
	GETDATE(),
	GETDATE(),
	NULL,
	GETDATE()
)

INSERT INTO All_colums (
	WorkOrderID,
	ProductID,
	OrderQty,
	ScrappedQty,
	StartDate,
	EndDate,
	DueDate,
	ScrapReasonID,
	ModifiedDate
)
VALUES(
	111456,
	456,
	8,
	255,
	GETDATE(),
	GETDATE(),
	GETDATE(),
	NULL,
	GETDATE()
)

UPDATE All_colums
SET ModifiedDate = GETDATE()
WHERE OrderQty = 8 AND ScrappedQty = 255;

SELECT * FROM All_colums
WHERE OrderQty = 8 AND ScrappedQty = 255;

DELETE FROM All_colums
WHERE WorkOrderID BETWEEN 4520 AND 4522;

SELECT * FROM Production.WorkOrderHst
