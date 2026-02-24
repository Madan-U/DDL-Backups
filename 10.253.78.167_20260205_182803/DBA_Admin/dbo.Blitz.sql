-- Object: TABLE dbo.Blitz
-- Server: 10.253.78.167 | DB: DBA_Admin
--------------------------------------------------

CREATE TABLE [dbo].[Blitz]
(
    [ID] BIGINT IDENTITY(1,1) NOT NULL,
    [ServerName] NVARCHAR(128) NULL,
    [CheckDate] DATETIME NOT NULL DEFAULT (getdate()),
    [Priority] TINYINT NULL,
    [FindingsGroup] VARCHAR(50) NULL,
    [Finding] VARCHAR(200) NULL,
    [DatabaseName] NVARCHAR(128) NULL,
    [URL] VARCHAR(200) NULL,
    [Details] NVARCHAR(4000) NULL,
    [QueryPlan] XML NULL,
    [QueryPlanFiltered] NVARCHAR(MAX) NULL,
    [CheckID] INT NULL
);

GO
