-- Object: TABLE dbo.os_task_list
-- Server: 10.253.78.187 | DB: DBA_Admin
--------------------------------------------------

CREATE TABLE [dbo].[os_task_list]
(
    [collection_time_utc] DATETIME2 NOT NULL,
    [host_name] VARCHAR(255) NOT NULL,
    [task_name] NVARCHAR(100) NOT NULL,
    [pid] BIGINT NOT NULL,
    [session_name] VARCHAR(20) NULL,
    [memory_kb] BIGINT NULL,
    [status] VARCHAR(30) NULL,
    [user_name] VARCHAR(200) NOT NULL,
    [cpu_time] CHAR(14) NOT NULL,
    [cpu_time_seconds] BIGINT NOT NULL,
    [window_title] NVARCHAR(2000) NULL
);

GO
