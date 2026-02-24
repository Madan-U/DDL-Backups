-- Object: TABLE dbo.sql_agent_job_stats
-- Server: 10.253.33.227 | DB: DBA_Admin
--------------------------------------------------

CREATE TABLE [dbo].[sql_agent_job_stats]
(
    [JobName] VARCHAR(255) NOT NULL,
    [Instance_Id] BIGINT NULL,
    [Last_RunTime] DATETIME2 NULL,
    [Last_Run_Duration_Seconds] INT NULL,
    [Last_Run_Outcome] VARCHAR(50) NULL,
    [Last_Successful_ExecutionTime] DATETIME2 NULL,
    [Running_Since] DATETIME2 NULL,
    [Running_StepName] VARCHAR(250) NULL,
    [Running_Since_Min] BIGINT NULL,
    [Session_Id] INT NULL,
    [Blocking_Session_Id] INT NULL,
    [Next_RunTime] DATETIME2 NULL,
    [Total_Executions] BIGINT NULL DEFAULT ((0)),
    [Total_Success_Count] BIGINT NULL DEFAULT ((0)),
    [Total_Stopped_Count] BIGINT NULL DEFAULT ((0)),
    [Total_Failed_Count] BIGINT NULL DEFAULT ((0)),
    [Continous_Failures] INT NULL DEFAULT ((0)),
    [<10-Min] BIGINT NOT NULL DEFAULT ((0)),
    [10-Min] BIGINT NOT NULL DEFAULT ((0)),
    [30-Min] BIGINT NOT NULL DEFAULT ((0)),
    [1-Hrs] BIGINT NOT NULL DEFAULT ((0)),
    [2-Hrs] BIGINT NOT NULL DEFAULT ((0)),
    [3-Hrs] BIGINT NOT NULL DEFAULT ((0)),
    [6-Hrs] BIGINT NOT NULL DEFAULT ((0)),
    [9-Hrs] BIGINT NOT NULL DEFAULT ((0)),
    [12-Hrs] BIGINT NOT NULL DEFAULT ((0)),
    [18-Hrs] BIGINT NOT NULL DEFAULT ((0)),
    [24-Hrs] BIGINT NOT NULL DEFAULT ((0)),
    [36-Hrs] BIGINT NOT NULL DEFAULT ((0)),
    [48-Hrs] BIGINT NOT NULL DEFAULT ((0)),
    [CollectionTimeUTC] DATETIME2 NULL DEFAULT (sysutcdatetime()),
    [UpdatedDateUTC] DATETIME2 NOT NULL DEFAULT (sysutcdatetime())
);

GO
