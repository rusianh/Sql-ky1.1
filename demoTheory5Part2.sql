create view VW_Employee AS
SELECT Department.Name AS DepartmentName,Employee.Id EmployeeID, Employee.Name AS EmployeeName, Employee.YearOfBirth, SalaryRate.Rate
FROM   Department INNER JOIN
             Employee ON Department.Id = Employee.DepartmentId INNER JOIN
             SalaryRate ON Employee.SalaryRateId = SalaryRate.Id
;
SELECT Department.Name AS DepartmentName,Employee.Id EmployeeID, Employee.Name AS EmployeeName, Employee.YearOfBirth, SalaryRate.Rate
FROM   Department INNER JOIN
             Employee ON Department.Id = Employee.DepartmentId INNER JOIN
             SalaryRate ON Employee.SalaryRateId = SalaryRate.Id
Where Employee.YearOfBirth>=1995 and Department.Name='Sales'
;
select * from vw_employee where YearOfbirth>=1995 and DepartmentName='Sales';


create view VW_EmployeeSales AS
SELECT Department.Name AS DepartmentName,Employee.Id EmployeeID, Employee.Name AS EmployeeName, Employee.YearOfBirth, SalaryRate.Rate
FROM   Department INNER JOIN
             Employee ON Department.Id = Employee.DepartmentId INNER JOIN
             SalaryRate ON Employee.SalaryRateId = SalaryRate.Id
where Department.Name='Sales'
;

select * from VW_EmployeeSales where Rate<10000000;

create procedure DanhSachNhanVien
@PhongBan nvarchar(50),
@SoLuong int OUTPUT
AS
BEGIN
SELECT * FROM VW_Employee WHERE DepartmentName=@PhongBan;
SELECT @SoLuong=COUNT(1) FROM VW_Employee WHERE DepartmentName=@PhongBan;
END
;
Exec DanhSachNhanVien 'Legal';
Exec DanhSachNhanVien 'Accounting';
Exec DanhSachNhanVien 'Research and Development';
--drop procedure DanhSachNhanVien;
create procedure DanhSachNhanVien1
@PhongBan nvarchar(50),
@SoLuong int OUTPUT
AS
BEGIN
SELECT * FROM VW_Employee WHERE DepartmentName=@PhongBan;
SELECT @SoLuong=COUNT(1) FROM VW_Employee WHERE DepartmentName=@PhongBan;
END
;
DECLARE @SoLuong int;
Exec DanhSachNhanVien1 'Sales',@SoLuong=@SoLuong OUTPUT;
PRINT('So luong ban ghi: '+CAST(@SoLuong AS varchar));
EXEC sp_helptext DanhSachNhanVien;create table demoNumber(	Id int primary key identity,	SoNgauNhien int NOT NULL DEFAULT(0));select FLOOR(RAND()*1000);BEGIN TRANSACTION;DECLARE @soluong int = 0;WHILE @SoLuong<5000000BEGIN	INSERT INTO demoNumber(SoNgauNhien) VALUES (FLOOR(RAND()*1000));	SELECT @SoLuong = @SoLuong+1;END;COMMIT;select count(1) from demoNumber;select count(1) from demoNumber where SoNgauNhien>500;drop index idx_demoNumber on demoNumber ;create index idx_demoNumber on demoNumber(SoNgauNhien);select * from demoNumber where SoNgauNhien>500;