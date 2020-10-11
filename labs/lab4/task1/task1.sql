CREATE TABLE Production.WorkOrderHst(
	ID				INT IDENTITY(1,1) NOT NULL,
	Action			NVARCHAR(6)		  NOT NULL,
	ModifiedDafe	DATETIME		  NOT NULL,
	SourceId		INT				  NOT NULL,
	UserName		NVARCHAR(50)	  NOT NULL,
	PRIMARY KEY(ID, SourceId)
);



select * from Production.WorkOrder

update Production.WorkOrder
set ModifiedDate = GETDATE()
WHERE WorkOrderId = 3;

select * from sys.trigger_events

select * from AdventureWorks2012.sys.trigger_events


GO


CREATE TRIGGER AFTER_INSERT_SECOND
ON Production.WorkOrder
AFTER INSERT, UPDATE, DELETE
AS
	DECLARE @action_name NVARCHAR(30);
	DECLARE @now DATETIME;
	SET @now = GETDATE();
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
	111111,
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
WHERE WorkOrderId = 111111;

DELETE FROM All_colums
WHERE WorkOrderID = 111111;