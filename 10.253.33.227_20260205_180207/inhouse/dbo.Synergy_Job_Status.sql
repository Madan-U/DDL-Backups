-- Object: TABLE dbo.Synergy_Job_Status
-- Server: 10.253.33.227 | DB: inhouse
--------------------------------------------------

CREATE TABLE [dbo].[Synergy_Job_Status]
(
    [JobName] VARCHAR(50) NULL,
    [JobTime] VARCHAR(10) NULL,
    [Flag] CHAR(1) NULL,
    [StartTime] DATETIME NULL,
    [EndTime] DATETIME NULL,
    [JobStatus] NVARCHAR(4000) NULL
);

GO
