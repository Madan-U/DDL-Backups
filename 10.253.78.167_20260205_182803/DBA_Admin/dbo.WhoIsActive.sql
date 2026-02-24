-- Object: TABLE dbo.WhoIsActive
-- Server: 10.253.78.167 | DB: DBA_Admin
--------------------------------------------------

CREATE TABLE [dbo].[WhoIsActive]
(
    [collection_time] DATETIME NOT NULL,
    [session_id] SMALLINT NOT NULL,
    [program_name] NVARCHAR(128) NULL,
    [login_name] NVARCHAR(128) NOT NULL,
    [database_name] NVARCHAR(128) NULL,
    [CPU] BIGINT NULL,
    [used_memory] BIGINT NOT NULL,
    [open_tran_count] SMALLINT NULL,
    [status] VARCHAR(30) NOT NULL,
    [wait_info] NVARCHAR(4000) NULL,
    [sql_command] NVARCHAR(MAX) NULL,
    [blocked_session_count] SMALLINT NULL,
    [blocking_session_id] SMALLINT NULL,
    [sql_text] NVARCHAR(MAX) NULL,
    [avg_elapsed_time] INT NULL,
    [physical_io] BIGINT NULL,
    [reads] BIGINT NULL,
    [physical_reads] BIGINT NULL,
    [writes] BIGINT NULL,
    [tempdb_allocations] BIGINT NULL,
    [tempdb_current] BIGINT NULL,
    [context_switches] BIGINT NULL,
    [max_used_memory] BIGINT NULL,
    [requested_memory] BIGINT NULL,
    [granted_memory] BIGINT NULL,
    [tasks] SMALLINT NULL,
    [tran_start_time] DATETIME NULL,
    [tran_log_writes] NVARCHAR(4000) NULL,
    [implicit_tran] NVARCHAR(3) NULL,
    [query_plan] XML NULL,
    [percent_complete] REAL NULL,
    [host_name] NVARCHAR(128) NULL,
    [additional_info] XML NULL,
    [memory_info] XML NULL,
    [start_time] DATETIME NOT NULL,
    [login_time] DATETIME NULL,
    [request_id] INT NULL
);

GO
