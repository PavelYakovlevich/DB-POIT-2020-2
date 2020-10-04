SELECT DepartmentID, Name 
FROM HumanResources.Department
WHERE SUBSTRING(NAME, 1, 1) = 'P';

SELECT BusinessEntityID, JobTitle, Gender, VacationHours, SickLeaveHours
FROM HumanResources.Employee
WHERE VacationHours BETWEEN 10 AND 13;

SELECT TOP 5 * 
FROM (
	SELECT BusinessEntityID, JobTitle, Gender, BirthDate, HireDate
	FROM HumanResources.Employee
	WHERE MONTH(HireDate) = 7 AND DAY(HireDate) = 1
	ORDER BY BusinessEntityID ASC
	OFFSET 3 ROWS
) AS INNER_SELECT;