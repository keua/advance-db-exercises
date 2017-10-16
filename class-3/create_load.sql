CREATE DATABASE "infoh415-kubedaar-temporal";
USE "infoh415-kubedaar-temporal";
-- CREATE SCHEMA
GO
DROP TABLE IF EXISTS Employee
create table Employee
(
    SSN char(9) not null,
    FName varchar(15) not null,
    MInit char(1),
    LName varchar(15) not null,
    BirthDate smalldatetime null,
    Sex char(1),
    constraint PK_Employee primary key (SSN),
)
DROP TABLE IF EXISTS EmployeeLifecycle
create table EmployeeLifecycle
(
    SSN char(9) not null,
    FromDate smalldatetime not null default getdate(),
    ToDate smalldatetime not null default '2079-01-01',
    constraint PK_EmployeeLifecycle primary key (SSN,FromDate),
    constraint FK_EmployeeLifecycle_Employee foreign key (SSN) references Employee (SSN),
    constraint Period_EmployeeLifecycle check (FromDate < ToDate)
)
DROP TABLE IF EXISTS EmployeeSalary
create table EmployeeSalary
(
    SSN char(9) not null,
    Salary decimal(18,2),
    FromDate smalldatetime not null,
    ToDate smalldatetime not null default '2079-01-01',
    constraint PK_EmployeeSalary primary key (SSN,FromDate),
    constraint FK_EmployeeSalary_Employee foreign key (SSN) references Employee (SSN),
    constraint Period_EmployeeSalary check (FromDate < ToDate)
)
DROP TABLE IF EXISTS EmEmployeeAddress
create table EmployeeAddress
(
    SSN char(9) not null,
    Street varchar(20),
    City varchar(20),
    Zip varchar(10),
    State varchar(10),
    FromDate smalldatetime not null,
    ToDate smalldatetime not null default '2079-01-01',
    constraint PK_EmployeeAddress primary key (SSN,FromDate),
    constraint FK_EmployeeAddress_Employee foreign key (SSN) references Employee (SSN),
    constraint Period_EmployeeAddress check (FromDate < ToDate)
)
DROP TABLE IF EXISTS Supervision
create table Supervision
(
    SSN char(9) not null,
    SuperSSN char(9) not null,
    FromDate smalldatetime not null,
    ToDate smalldatetime not null default '2079-01-01',
    constraint PK_Supervision primary key (SSN,SuperSSN,FromDate),
    constraint FK_Supervision_Employee_Emp foreign key (SSN) references Employee (SSN),
    constraint FK_Supervision_Employee_Super foreign key (SuperSSN) references Employee (SSN),
    constraint Period_Supervision check (FromDate < ToDate)
)
DROP TABLE IF EXISTS Department
create table Department
(
    DNumber int not null,
    DName varchar(15) not null,
    MgrSSN char(9) not null,
    MgrStartDate smalldatetime,
    FromDate smalldatetime not null,
    ToDate smalldatetime not null default '2079-01-01',
    constraint PK_Department primary key (DNumber),
    constraint FK_Department_Employee foreign key (MgrSSN) references Employee (SSN) 
    on delete cascade on update cascade,
    constraint Period_Department check (FromDate < ToDate)
)
DROP TABLE IF EXISTS Affiliation
create table Affiliation
(
    SSN char(9) not null,
    DNumber int not null,
    FromDate smalldatetime not null,
    ToDate smalldatetime not null default '2079-01-01',
    constraint PK_Affiliation primary key (SSN,FromDate),
    constraint FK_Affiliation_Employee foreign key (SSN) references Employee (SSN),
    constraint FK_Affiliation_Department foreign key (DNumber) references Department (DNumber),
    constraint Period_Affiliation check (FromDate < ToDate)
)
DROP TABLE IF EXISTS DeptNbEmp
create table DeptNbEmp
(
    DNumber int not null,
    NbEmp int,
    FromDate smalldatetime not null,
    ToDate smalldatetime not null default '2079-01-01',
    constraint PK_DepartmentNbEmp primary key (DNumber,FromDate),
    constraint FK_DepartmentNbEmp_Department foreign key (DNumber) references Department (DNumber) 
    on delete cascade on update cascade,
    constraint Period_DeptNbEmp check (FromDate < ToDate)
)
DROP TABLE IF EXISTS DeptLocations
create table DeptLocations
(
    DNumber int not null,
    DLocation varchar(15) not null,
    FromDate smalldatetime not null,
    ToDate smalldatetime not null default '2079-01-01',
    constraint PK_DeptLocations primary key (DNumber,DLocation,FromDate),
    constraint FK_DeptLocations_Department foreign key (DNumber) references Department (DNumber),
    constraint Period_DeptLocations check (FromDate < ToDate)
)
DROP TABLE IF EXISTS Project
create table Project
(
    PNumber int not null,
    PName varchar(15) not null,
    PLocation varchar(15),
    FromDate smalldatetime not null,
    ToDate smalldatetime not null default '2079-01-01',
    constraint PK_Project primary key (PNumber),
    constraint Period_Project check (FromDate < ToDate)
)
DROP TABLE IF EXISTS Controls
create table Controls
(
    PNumber int not null,
    DNumber int not null,
    FromDate smalldatetime not null,
    ToDate smalldatetime not null default '2079-01-01',
    constraint PK_Controls primary key (PNumber,FromDate),
    constraint FK_Controls_Department foreign key (DNumber) references Department (DNumber),
    constraint Period_Controls check (FromDate < ToDate)
)
DROP TABLE IF EXISTS WorksOn
create table WorksOn
(
    SSN char(9) not null,
    PNumber int not null,
    Hours decimal(18,1) not null,
    FromDate smalldatetime not null,
    ToDate smalldatetime not null default '2079-01-01',
    constraint PK_WorksOn primary key (SSN,PNumber,FromDate),
    constraint FK_WorksOn_Employee foreign key (SSN) references Employee (SSN),
    constraint FK_WorksOn_Project foreign key (PNumber) references Project (PNumber),
    constraint Period_WorksOn check (FromDate < ToDate)
)

-- LOAD DATA
GO
set dateformat dmy
insert Employee
    (FName, MInit, LName, SSN, BirthDate, Sex)
values('John', 'B', 'Smith', '123456789', '09-05-1955', 'M')
insert Employee
    (FName, MInit, LName, SSN, BirthDate, Sex)
values('Franklin', 'T', 'Wong', '333445555', '08-12-1945', 'M')
insert Employee
    (FName, MInit, LName, SSN, BirthDate, Sex)
values('Alicia', 'J', 'Zelaya', '999887777', '19-07-1958', 'F')
insert Employee
    (FName, MInit, LName, SSN, BirthDate, Sex)
values('Jennifer', 'S', 'Wallace', '987654321', '20-06-1931', 'F')
insert Employee
    (FName, MInit, LName, SSN, BirthDate, Sex)
values('Ramesh', 'K', 'Narayan', '666884444', '15-09-1952', 'M')
insert Employee
    (FName, MInit, LName, SSN, BirthDate, Sex)
values('Joyce', 'A', 'English', '453453453', '31-07-1962', 'F')
insert Employee
    (FName, MInit, LName, SSN, BirthDate, Sex)
values('Ahmad', 'V', 'Jabbar', '987987987', '29-03-1959', 'M')
insert Employee
    (FName, MInit, LName, SSN, BirthDate, Sex)
values('James', 'A', 'Borg', '888665555', '10-11-1927', 'M')

insert EmployeeSalary
    (SSN, Salary, FromDate, ToDate)
values('123456789', 30000, '01-01-1985', '01-01-2079')
insert EmployeeSalary
    (SSN, Salary, FromDate, ToDate)
values('333445555', 40000, '01-01-1982', '01-01-1983')
insert EmployeeSalary
    (SSN, Salary, FromDate, ToDate)
values('333445555', 45000, '01-01-1983', '01-01-2079')
insert EmployeeSalary
    (SSN, Salary, FromDate, ToDate)
values('999887777', 25000, '01-01-1985', '01-01-2079')
insert EmployeeSalary
    (SSN, Salary, FromDate, ToDate)
values('987654321', 43000, '01-01-1982', '01-01-2079')
insert EmployeeSalary
    (SSN, Salary, FromDate, ToDate)
values('666884444', 38000, '01-01-1985', '01-01-2079')
insert EmployeeSalary
    (SSN, Salary, FromDate, ToDate)
values('453453453', 25000, '01-01-1985', '01-01-2079')
insert EmployeeSalary
    (SSN, Salary, FromDate, ToDate)
values('987987987', 25000, '01-01-1985', '01-01-2079')
insert EmployeeSalary
    (SSN, Salary, FromDate, ToDate)
values('888665555', 55000, '01-01-1980', '01-01-1981')
insert EmployeeSalary
    (SSN, Salary, FromDate, ToDate)
values('888665555', 58000, '01-01-1981', '01-01-2079')

insert EmployeeLifecycle
    (SSN, FromDate, ToDate)
values('123456789', '01-01-1985', '01-01-2079')
insert EmployeeLifecycle
    (SSN, FromDate, ToDate)
values('333445555', '01-01-1982', '01-01-2079')
insert EmployeeLifecycle
    (SSN, FromDate, ToDate)
values('999887777', '01-01-1985', '01-01-2079')
insert EmployeeLifecycle
    (SSN, FromDate, ToDate)
values('987654321', '01-01-1982', '01-01-2079')
insert EmployeeLifecycle
    (SSN, FromDate, ToDate)
values('666884444', '01-01-1985', '01-01-2079')
insert EmployeeLifecycle
    (SSN, FromDate, ToDate)
values('453453453', '01-01-1985', '01-01-2079')
insert EmployeeLifecycle
    (SSN, FromDate, ToDate)
values('987987987', '01-01-1985', '01-01-2079')
insert EmployeeLifecycle
    (SSN, FromDate, ToDate)
values('888665555', '01-01-1980', '01-01-2079')

insert EmployeeAddress
    (SSN, Street, City, Zip, State, FromDate, ToDate)
values('123456789', '731 Fondren', 'Houston', '1000', 'TX', '01-01-1985', '01-01-2079')
insert EmployeeAddress
    (SSN, Street, City, Zip, State, FromDate, ToDate)
values('333445555', '638 Voss', 'Houston', '1000', 'TX', '01-01-1982', '01-01-2079')
insert EmployeeAddress
    (SSN, Street, City, Zip, State, FromDate, ToDate)
values('999887777', '3321 Castle', 'Spring', '1000', 'TX', '01-01-1985', '01-01-2079')
insert EmployeeAddress
    (SSN, Street, City, Zip, State, FromDate, ToDate)
values('987654321', '291 Berry', 'Bellaire', '1000', 'TX', '01-01-1982', '01-01-2079')
insert EmployeeAddress
    (SSN, Street, City, Zip, State, FromDate, ToDate)
values('666884444', '975 Fire Oak', 'Humble', '1000', 'TX', '01-01-1985', '01-01-2079')
insert EmployeeAddress
    (SSN, Street, City, Zip, State, FromDate, ToDate)
values('453453453', '5631 Rice', 'Houston', '1000', 'TX', '01-01-1985', '01-01-2079')
insert EmployeeAddress
    (SSN, Street, City, Zip, State, FromDate, ToDate)
values('987987987', '980 Dallas', 'Houston', '1000', 'TX', '01-01-1985', '01-01-2079')
insert EmployeeAddress
    (SSN, Street, City, Zip, State, FromDate, ToDate)
values('888665555', '450 Stone', 'Houston', '1000', 'TX', '01-01-1980', '01-01-2079')

insert Supervision
    (SSN, SuperSSN, FromDate, ToDate)
values('123456789', '333445555', '01-01-1985', '01-01-2079')
insert Supervision
    (SSN, SuperSSN, FromDate, ToDate)
values('333445555', '888665555', '01-01-1982', '01-01-2079')
insert Supervision
    (SSN, SuperSSN, FromDate, ToDate)
values('999887777', '987654321', '01-01-1985', '01-01-2079')
insert Supervision
    (SSN, SuperSSN, FromDate, ToDate)
values('987654321', '888665555', '01-01-1982', '01-01-2079')
insert Supervision
    (SSN, SuperSSN, FromDate, ToDate)
values('666884444', '333445555', '01-01-1985', '01-01-2079')
insert Supervision
    (SSN, SuperSSN, FromDate, ToDate)
values('453453453', '333445555', '01-01-1985', '01-01-2079')
insert Supervision
    (SSN, SuperSSN, FromDate, ToDate)
values('987987987', '987654321', '01-01-1985', '01-01-2079')

insert Department
    (DName, DNumber, MgrSSN, MgrStartDate, FromDate, ToDate)
values('Headquarters', 1, '888665555', '19-06-1971', '01-01-1980', '01-01-2079')
insert Department
    (DName, DNumber, MgrSSN, MgrStartDate, FromDate, ToDate)
values('Administration', 4, '987654321', '01-01-1985', '01-01-1981', '01-01-2079')
insert Department
    (DName, DNumber, MgrSSN, MgrStartDate, FromDate, ToDate)
values('Research', 5, '333445555', '22-05-1978', '01-01-1982', '01-01-2079')

insert Affiliation
    (SSN, DNumber, FromDate, ToDate)
values('123456789', 1, '01-01-1985', '01-01-1986')
insert Affiliation
    (SSN, DNumber, FromDate, ToDate)
values('123456789', 5, '01-01-1986', '01-01-2079')
insert Affiliation
    (SSN, DNumber, FromDate, ToDate)
values('333445555', 4, '01-01-1982', '01-01-1984')
insert Affiliation
    (SSN, DNumber, FromDate, ToDate)
values('333445555', 5, '01-01-1984', '01-01-2079')
insert Affiliation
    (SSN, DNumber, FromDate, ToDate)
values('999887777', 4, '01-01-1985', '01-01-2079')
insert Affiliation
    (SSN, DNumber, FromDate, ToDate)
values('987654321', 4, '01-01-1982', '01-01-2079')
insert Affiliation
    (SSN, DNumber, FromDate, ToDate)
values('666884444', 5, '01-01-1985', '01-01-2079')
insert Affiliation
    (SSN, DNumber, FromDate, ToDate)
values('453453453', 5, '01-01-1985', '01-01-2079')
insert Affiliation
    (SSN, DNumber, FromDate, ToDate)
values('987987987', 4, '01-01-1985', '01-01-2079')
insert Affiliation
    (SSN, DNumber, FromDate, ToDate)
values('888665555', 1, '01-01-1980', '01-01-2079')

insert DeptNbEmp
    (DNumber, NbEmp, FromDate, ToDate)
values(5, 1, '01-01-1980', '01-01-2079')
insert DeptNbEmp
    (DNumber, NbEmp, FromDate, ToDate)
values(4, 3, '01-01-1981', '01-01-2079')
insert DeptNbEmp
    (DNumber, NbEmp, FromDate, ToDate)
values(1, 1, '01-01-1982', '01-01-2079')

insert DeptLocations
    (DNumber, DLocation, FromDate, ToDate)
values(1, 'Houston', '01-01-1980', '01-01-2079')
insert DeptLocations
    (DNumber, DLocation, FromDate, ToDate)
values(4, 'Stafford', '01-01-1980', '01-01-2079')
insert DeptLocations
    (DNumber, DLocation, FromDate, ToDate)
values(5, 'Bellaire', '01-01-1980', '01-01-2079')
insert DeptLocations
    (DNumber, DLocation, FromDate, ToDate)
values(5, 'Sugarland', '01-01-1980', '01-01-2079')
insert DeptLocations
    (DNumber, DLocation, FromDate, ToDate)
values(5, 'Houston', '01-01-1980', '01-01-2079')

insert Project
    (PName, PNumber, PLocation, FromDate, ToDate)
values('ProductX', 1, 'Bellaire', '01-01-1980', '01-01-2079')
insert Project
    (PName, PNumber, PLocation, FromDate, ToDate)
values('ProductY', 2, 'Sugarland', '01-01-1980', '01-01-2079')
insert Project
    (PName, PNumber, PLocation, FromDate, ToDate)
values('ProductZ', 3, 'Houston', '01-01-1980', '01-01-2079')
insert Project
    (PName, PNumber, PLocation, FromDate, ToDate)
values('Computerization', 10, 'Stafford', '01-01-1980', '01-01-2079')
insert Project
    (PName, PNumber, PLocation, FromDate, ToDate)
values('Reorganization', 20, 'Houston', '01-01-1980', '01-01-2079')
insert Project
    (PName, PNumber, PLocation, FromDate, ToDate)
values('Newbenefits', 30, 'Stafford', '01-01-1980', '01-01-2079')

insert Controls
    (PNumber, DNumber, FromDate, ToDate)
values(1, 5, '01-01-1980', '01-01-2079')
insert Controls
    (PNumber, DNumber, FromDate, ToDate)
values(2, 5, '01-01-1980', '01-01-2079')
insert Controls
    (PNumber, DNumber, FromDate, ToDate)
values(3, 5, '01-01-1980', '01-01-2079')
insert Controls
    (PNumber, DNumber, FromDate, ToDate)
values(10, 4, '01-01-1980', '01-01-2079')
insert Controls
    (PNumber, DNumber, FromDate, ToDate)
values(20, 1, '01-01-1980', '01-01-2079')
insert Controls
    (PNumber, DNumber, FromDate, ToDate)
values(30, 4, '01-01-1980', '01-01-2079')

insert WorksOn
    ( SSN, PNumber, Hours, FromDate, ToDate)
values('123456789', 1, 32.5, '01-01-1985', '01-01-2079')
insert WorksOn
    ( SSN, PNumber, Hours, FromDate, ToDate)
values('123456789', 2, 7.5, '01-01-1985', '01-01-2079')
insert WorksOn
    ( SSN, PNumber, Hours, FromDate, ToDate)
values('333445555', 1, 10, '01-01-1982', '01-01-2000')
insert WorksOn
    ( SSN, PNumber, Hours, FromDate, ToDate)
values('333445555', 2, 10, '01-01-1982', '01-01-2002')
insert WorksOn
    ( SSN, PNumber, Hours, FromDate, ToDate)
values('333445555', 3, 20, '01-01-2005', '01-01-2079')
insert WorksOn
    ( SSN, PNumber, Hours, FromDate, ToDate)
values('453453453', 1, 20, '01-01-1985', '01-01-2079')
insert WorksOn
    ( SSN, PNumber, Hours, FromDate, ToDate)
values('453453453', 2, 20, '01-01-1985', '01-01-2079')
insert WorksOn
    ( SSN, PNumber, Hours, FromDate, ToDate)
values('666884444', 3, 40, '01-01-1985', '01-01-2079')
insert WorksOn
    ( SSN, PNumber, Hours, FromDate, ToDate)
values('888665555', 20, 30, '01-01-1983', '01-01-2079')
insert WorksOn
    ( SSN, PNumber, Hours, FromDate, ToDate)
values('987654321', 10, 5, '01-01-1982', '01-01-2000')
insert WorksOn
    ( SSN, PNumber, Hours, FromDate, ToDate)
values('987654321', 20, 15, '01-01-1982', '01-01-2001')
insert WorksOn
    ( SSN, PNumber, Hours, FromDate, ToDate)
values('987654321', 30, 20, '01-01-1982', '01-01-2002')
insert WorksOn
    ( SSN, PNumber, Hours, FromDate, ToDate)
values('987987987', 10, 35, '01-01-1985', '01-01-2079')
insert WorksOn
    ( SSN, PNumber, Hours, FromDate, ToDate)
values('987987987', 30, 5, '01-01-1985', '01-01-2079')
insert WorksOn
    ( SSN, PNumber, Hours, FromDate, ToDate)
values('999887777', 10, 10, '01-01-1985', '01-01-2079')
insert WorksOn
    ( SSN, PNumber, Hours, FromDate, ToDate)
values('999887777', 30, 30, '01-01-1985', '01-01-2079')