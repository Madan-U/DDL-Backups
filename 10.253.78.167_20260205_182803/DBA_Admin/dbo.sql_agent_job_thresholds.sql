-- Object: TABLE dbo.sql_agent_job_thresholds
-- Server: 10.253.78.167 | DB: DBA_Admin
--------------------------------------------------

CREATE TABLE [dbo].[sql_agent_job_thresholds]
(
    [JobName] VARCHAR(255) NOT NULL,
    [JobCategory] VARCHAR(255) NOT NULL,
    [Expected-Max-Duration(Min)] BIGINT NULL,
    [Continous_Failure_Threshold] INT NULL DEFAULT ((2)),
    [Successfull_Execution_ClockTime_Threshold_Minutes] BIGINT NULL,
    [StopJob_If_LongRunning] BIT NULL DEFAULT ((0)),
    [StopJob_If_NotSuccessful_In_ThresholdTime] BIT NULL DEFAULT ((0)),
    [RestartJob_If_NotSuccessful_In_ThresholdTime] BIT NULL DEFAULT ((0)),
    [RestartJob_If_Failed] BIT NULL DEFAULT ((0)),
    [Kill_Job_Blocker] BIT NULL DEFAULT ((0)),
    [Alert_When_Blocked] BIT NULL DEFAULT ((0)),
    [EnableJob_If_Found_Disabled] BIT NOT NULL DEFAULT ((0)),
    [IgnoreJob] BIT NOT NULL DEFAULT ((0)),
    [IsDisabled] BIT NOT NULL DEFAULT ((0)),
    [IsNotFound] BIT NOT NULL DEFAULT ((0)),
    [Include_In_MailNotification] BIT NULL DEFAULT ((0)),
    [Mail_Recepients] VARCHAR(2000) NULL DEFAULT NULL,
    [CollectionTimeUTC] DATETIME2 NULL DEFAULT (sysutcdatetime()),
    [UpdatedDateUTC] DATETIME2 NOT NULL DEFAULT (sysutcdatetime()),
    [UpdatedBy] VARCHAR(125) NOT NULL DEFAULT (suser_name()),
    [Remarks] VARCHAR(2000) NULL
);

GO
