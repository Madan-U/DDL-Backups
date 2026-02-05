-- Object: TABLE dbo.tempdb_space_consumers
-- Server: 10.253.78.167 | DB: DBA_Admin
--------------------------------------------------

CREATE TABLE [dbo].[tempdb_space_consumers]
(
    [collection_time] DATETIME2 NOT NULL,
    [usage_rank] TINYINT NOT NULL,
    [spid] INT NOT NULL,
    [login_name] NVARCHAR(128) NOT NULL,
    [program_name] NVARCHAR(128) NULL,
    [host_name] NVARCHAR(128) NULL,
    [host_process_id] INT NULL,
    [is_active_session] INT NULL,
    [open_transaction_count] INT NULL,
    [transaction_isolation_level] VARCHAR(15) NULL,
    [size_bytes] BIGINT NULL,
    [transaction_begin_time] DATETIME NULL,
    [is_snapshot] INT NOT NULL,
    [log_bytes] BIGINT NULL,
    [log_rsvd] BIGINT NULL,
    [action_taken] VARCHAR(100) NULL
);

GO
