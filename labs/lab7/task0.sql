DECLARE @temp XML;

SET @temp = (
	SELECT 
		BusinessEntityID AS ID,
		FirstName,
		LastName
	FROM Person.Person as Person
	FOR XML AUTO, ROOT('Persons'), ELEMENTS
);

CREATE TABLE #temp_table
(
	ID				INT,
	FirstName		NVARCHAR(50),
	LastName		NVARCHAR(50)
);

INSERT #temp_table 
SELECT *
FROM (
	SELECT 
		Person.COL.value('(ID)[1]', 'INT') AS ID,
		Person.COL.value('(FirstName)[1]', 'NVARCHAR(50)') AS FirstName,
		Person.COL.value('(LastName)[1]', 'NVARCHAR(50)') AS LastName
	FROM @temp.nodes('Persons/Person') AS Person(COL)
) AS A;

SELECT * FROM #temp_table;