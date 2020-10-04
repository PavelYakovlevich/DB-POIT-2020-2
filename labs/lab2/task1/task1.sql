SELECT Emp.BusinessEntityID, Emp.JobTitle, Dep.DepartmentID, Dep.Name
FROM HumanResources.EmployeeDepartmentHistory AS EmpDepHist
	INNER JOIN HumanResources.Employee AS Emp
	ON Emp.BusinessEntityID = EmpDepHist.BusinessEntityID
	INNER JOIN HumanResources.Department AS Dep
	ON Dep.DepartmentID = EmpDepHist.DepartmentID
WHERE EmpDepHist.EndDate is NULL;	

SELECT Dep.DepartmentID, Dep.Name, COUNT(*) as EmpCount
FROM HumanResources.EmployeeDepartmentHistory AS EmpDepHist
	INNER JOIN HumanResources.Employee AS Emp
	ON Emp.BusinessEntityID = EmpDepHist.BusinessEntityID
	INNER JOIN HumanResources.Department AS Dep
	ON Dep.DepartmentID = EmpDepHist.DepartmentID
GROUP BY Dep.DepartmentID, Dep.Name;

SELECT Emp.JobTitle, EmpPayHist.Rate, EmpPayHist.RateChangeDate, 
	FORMATMESSAGE('The rate for %s was set to %s at %s', 
		Emp.JobTitle, 
		CONVERT(VARCHAR, EmpPayHist.Rate), 
		CONVERT(VARCHAR, EmpPayHist.RateChangeDate))
FROM HumanResources.Employee AS Emp
	INNER JOIN HumanResources.EmployeePayHistory AS EmpPayHist
	ON EmpPayHist.BusinessEntityID = Emp.BusinessEntityID;