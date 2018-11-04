SELECT Equipment.EquipmentID, Equipment.Make, Equipment.Model ,Equipment.Description FROM Equipment LEFT JOIN EquipmentLoan ON EquipmentLoan.EquipmentID = Equipment.EquipmentID WHERE (Equipment.Damaged = 0) AND (`EquipmentLoan`.`Current` = 0 OR EquipmentLoan.Current IS NULL) AND (Equipment.Type LIKE "%video%" OR Description LIKE "%video%");

SELECT `Employee`.`EmployeeID`, `Employee`.`FirstName`, `Employee`.`LastName` FROM `Employee` INNER JOIN `Contract` ON `Employee`.`EmployeeID` = `Contract`.`EmployeeID` WHERE (`Employee`.`Current` =1 AND `Contract`.`DueFinish` LIKE '%2019%');

SELECT `Project`.`Title`, SUM(Amount) AS Expense FROM `Project` LEFT JOIN `Expense` ON `Project`.`ProjectID` = `Expense`.`ProjectID` GROUP BY Project.`ProjectID`;

SELECT DISTINCT Employee.FirstName, Employee.LastName, Employee.Email, Grade.Title FROM Employee INNER JOIN EmployeeSkill ON Employee.EmployeeID = EmployeeSkill.EmployeeID INNER JOIN Skill ON Skill.SkillID = EmployeeSkill.SkillID INNER JOIN Grade ON Grade.GradeID=Employee.GradeID Where Skill.Title LIKE "%video%";

SELECT Project.Title, COUNT(*) AS 'Number of Employees' FROM Project JOIN Assignment ON Project.ProjectID = Assignment.ProjectID JOIN Employee ON Assignment.EmployeeID = Employee.EmployeeID WHERE Employee.Current =1 AND Project.Internal = 0 GROUP BY Project.Title HAVING COUNT(*) > 2;

SELECT `Employee`.`EmployeeID`, `Employee`.`FirstName`, `Employee`.`LastName` FROM `Employee` LEFT JOIN `Assignment` on `Employee`.`EmployeeID` = `Assignment`.`EmployeeID` WHERE `Assignment`.`EmployeeID` is null;

SELECT Skill.Title, COUNT(*) AS 'Number of Skilled Employees' FROM Skill   JOIN EmployeeSkill ON Skill.SkillID = EmployeeSkill.SkillID GROUP BY Skill.Title;

SELECT Employee.EmployeeID, COUNT(CASE EquipmentLoan.Current when 1 then 1 else null end) AS 'Currently on Loan' FROM Employee JOIN EquipmentLoan ON Employee.EmployeeID = EquipmentLoan.EmployeeID GROUP BY EquipmentLoan.EmployeeID HAVING COUNT(CASE EquipmentLoan.Current when 1 then 1 else null end) > 0;

SELECT Employee.EmployeeID, COUNT(*) AS 'All Time Loans' FROM Employee JOIN EquipmentLoan ON Employee.EmployeeID = EquipmentLoan.EmployeeID GROUP BY Employee.EmployeeID;

SELECT Payslip.EmployeeID, Payslip.PayslipID FROM Payslip LEFT JOIN Employee ON Employee.EmployeeID = Payslip.EmployeeID LEFT JOIN Contract ON Contract.EmployeeID = Payslip.EmployeeID WHERE Payslip.Payday BETWEEN "2017-01-01" AND "2017-12-31" AND Contract.EmployeeID is NULL;
