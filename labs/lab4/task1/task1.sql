CREATE TABLE Production.WorkOrderHst(
	ID				INT IDENTITY(1,1) NOT NULL,
	Action			NVARCHAR(6)		  NOT NULL,
	ModifiedDafe	DATETIME		  NOT NULL,
	SourceId		INT				  NOT NULL,
	UserName		NVARCHAR(50)	  NOT NULL,
	PRIMARY KEY(ID, SourceId)
)
GO

DROP TRIGGER AFTER_INSERT_DEL_UPD;
GO

CREATE TRIGGER AFTER_INSERT_DEL_UPD
ON Production.WorkOrder
AFTER INSERT, UPDATE, DELETE
AS
	DECLARE @action_name NVARCHAR(6);
	DECLARE @src_id INT;

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

	SELECT @src_id = A.WorkOrderID
	FROM (
		SELECT WorkOrderID
		FROM inserted
		UNION 
		SELECT WorkOrderID
		FROM deleted
	) AS A

	INSERT 
	INTO Production.WorkOrderHst
	(
		Action,
		ModifiedDafe,
		SourceId,
		UserName
	)
	VALUES(
		@action_name,
		GETDATE(),
		@src_id,
		'pyakovlevich'
	)
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
	111411,
	456,
	8,
	0,
	GETDATE(),
	GETDATE(),
	GETDATE(),
	NULL,
	GETDATE()
)

UPDATE All_colums
SET ModifiedDate = GETDATE()
WHERE WorkOrderId = 111411;

DELETE FROM All_colums
WHERE WorkOrderID = 111211;

SELECT * FROM Production.WorkOrderHst