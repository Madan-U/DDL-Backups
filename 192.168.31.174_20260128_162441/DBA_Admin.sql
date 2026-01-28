-- DDL Export
-- Server: 192.168.31.174
-- Database: DBA_Admin
-- Exported: 2026-01-28T16:24:45.568750

USE DBA_Admin;
GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.disk_space
-- --------------------------------------------------
ALTER TABLE [dbo].[disk_space] ADD CONSTRAINT [pk_disk_space] PRIMARY KEY ([collection_time_utc], [host_name], [disk_volume])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.sql_agent_job_stats
-- --------------------------------------------------
ALTER TABLE [dbo].[sql_agent_job_stats] ADD CONSTRAINT [pk_sql_agent_job_stats] PRIMARY KEY ([JobName])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.sql_agent_job_thresholds
-- --------------------------------------------------
ALTER TABLE [dbo].[sql_agent_job_thresholds] ADD CONSTRAINT [pk_sql_agent_job_thresholds] PRIMARY KEY ([JobName])

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_UpdateServerInventory
-- --------------------------------------------------

-- Create or Alter the procedure
CREATE   PROCEDURE dbo.usp_UpdateServerInventory
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CPU_Cores INT;
    DECLARE @RAM_GB DECIMAL(10, 2);

    -- Fetch CPU and RAM details from DMV
    SELECT @CPU_Cores = cpu_count FROM sys.dm_os_sys_info;
    SELECT @RAM_GB = CAST(physical_memory_kb / 1024.0 / 1024.0 AS DECIMAL(10, 2)) FROM sys.dm_os_sys_info;

    -- Insert gathered data into the table
    INSERT INTO dbo.Server_Inventory
    (
        Collection_Date,
        Host_Name,
        SQL_Instance,
        SQL_Version,
        CPU_Cores,
        Physical_RAM_GB
    )
    VALUES
    (
        GETDATE(),
        CAST(SERVERPROPERTY('MachineName') AS NVARCHAR(128)),
        @@SERVERNAME,
        @@VERSION,
        @CPU_Cores,
        @RAM_GB
    );
END;

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_UpdateServerInventoryVolatileInfo
-- --------------------------------------------------

/*
===============================================================================
Procedure Name : usp_UpdateServerInventoryVolatileInfo
Created On     : 2026-01-25
Purpose        : Collect server hardware, SQL Server instance info, and store
                 it in the ServerInventoryVolatileInfo table.
===============================================================================
*/

CREATE   PROCEDURE [dbo].[usp_UpdateServerInventoryVolatileInfo]
AS
BEGIN
    SET NOCOUNT ON;

    ---------------------------------------------------------------------------
    -- Variable declarations
    ---------------------------------------------------------------------------
    DECLARE 
        @CPU_Cores     INT,
        @RAM_GB        DECIMAL(10,2),
        @Host_IP       NVARCHAR(50),
        @Host_Name     NVARCHAR(128),
        @Instance_Name NVARCHAR(128),
        @SQL_Version   NVARCHAR(MAX);

    ---------------------------------------------------------------------------
    -- Step 1: Get CPU cores and Physical RAM
    ---------------------------------------------------------------------------
    SELECT 
        @CPU_Cores = cpu_count,
        @RAM_GB = CAST(physical_memory_kb / 1024.0 / 1024.0 AS DECIMAL(10,2))
    FROM sys.dm_os_sys_info;

    ---------------------------------------------------------------------------
    -- Step 2: Get Host IP (first non-local connection)
    ---------------------------------------------------------------------------
    SELECT TOP 1 @Host_IP = local_net_address
    FROM sys.dm_exec_connections
    WHERE local_net_address IS NOT NULL
      AND local_net_address NOT IN ('127.0.0.1', '::1')
    ORDER BY session_id;

    -- Fallback to localhost if no IP found
    SET @Host_IP = ISNULL(@Host_IP, '127.0.0.1');

    ---------------------------------------------------------------------------
    -- Step 3: Get Host and Instance names
    ---------------------------------------------------------------------------
    SET @Host_Name     = CAST(SERVERPROPERTY('MachineName') AS NVARCHAR(128));
    SET @Instance_Name = CAST(ISNULL(SERVERPROPERTY('InstanceName'), 'MSSQLSERVER') AS NVARCHAR(128));

    ---------------------------------------------------------------------------
    -- Step 4: Get SQL Server version and edition
    ---------------------------------------------------------------------------
    SET @SQL_Version = CAST(SERVERPROPERTY('ProductVersion') AS NVARCHAR(100)) 
                       + ' - ' + CAST(SERVERPROPERTY('Edition') AS NVARCHAR(100));

    ---------------------------------------------------------------------------
    -- Step 5: Insert collected information into inventory table
    ---------------------------------------------------------------------------
    INSERT INTO dbo.ServerInventoryVolatileInfo
    (
        Collection_Date,
        Server_IP,
        Host_Name,
        Instance_Name,
        SQL_Instance,
        SQL_Version,
        CPU_Cores,
        Physical_RAM_GB
    )
    VALUES
    (
        GETDATE(),
        @Host_IP,
        @Host_Name,
        @Instance_Name,
        @@SERVERNAME,
        @SQL_Version,
        @CPU_Cores,
        @RAM_GB
    );
END;

GO

-- --------------------------------------------------
-- TABLE dbo.disk_space
-- --------------------------------------------------
CREATE TABLE [dbo].[disk_space]
(
    [collection_time_utc] DATETIME2 NOT NULL,
    [host_name] VARCHAR(125) NOT NULL,
    [disk_volume] VARCHAR(255) NOT NULL,
    [label] VARCHAR(125) NULL,
    [capacity_mb] DECIMAL(20, 2) NOT NULL,
    [free_mb] DECIMAL(20, 2) NOT NULL,
    [block_size] INT NULL,
    [filesystem] VARCHAR(125) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.sql_agent_job_stats
-- --------------------------------------------------
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

-- --------------------------------------------------
-- TABLE dbo.sql_agent_job_thresholds
-- --------------------------------------------------
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

