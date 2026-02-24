-- Object: TABLE dbo.MonitorLongRunningJobs
-- Server: 10.253.33.190 | DB: DBA_Admin
--------------------------------------------------

CREATE TABLE [dbo].[MonitorLongRunningJobs]
(
    [job_id] NVARCHAR(100) NULL,
    [JobName] NVARCHAR(100) NULL,
    [StartTime] DATETIME NULL,
    [StopTime] DATETIME NULL,
    [Avg_Run_Time] TIME NULL,
    [CurrentRunTime] TIME NULL,
    [ActualRunTime] INT NULL,
    [JobRun] NVARCHAR(100) NULL,
    [JobRunning] NVARCHAR(100) NULL
);

GO
