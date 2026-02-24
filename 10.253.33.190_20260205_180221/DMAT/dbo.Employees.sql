-- Object: TABLE dbo.Employees
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE TABLE [dbo].[Employees]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [FirstName] NVARCHAR(50) NULL,
    [LastName] NVARCHAR(50) NULL,
    [Gender] NVARCHAR(50) NULL,
    [Salary] INT NULL,
    [DepartmentId] INT NULL
);

GO
