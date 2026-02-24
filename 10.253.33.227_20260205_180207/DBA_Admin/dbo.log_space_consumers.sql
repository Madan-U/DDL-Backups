-- Object: TABLE dbo.log_space_consumers
-- Server: 10.253.33.227 | DB: DBA_Admin
--------------------------------------------------

CREATE TABLE [dbo].[log_space_consumers]
(
    [collection_time] DATETIME2 NOT NULL,
    [database_name] NVARCHAR(128) NOT NULL,
    [recovery_model] VARCHAR(20) NOT NULL,
    [log_reuse_wait_desc] VARCHAR(125) NOT NULL,
    [log_size_mb] DECIMAL(20, 2) NOT NULL,
    [log_used_mb] DECIMAL(20, 2) NOT NULL,
    [exists_valid_autogrowing_file] BIT NULL,
    [log_used_pct] DECIMAL(10, 2) NOT NULL,
    [log_used_pct_threshold] DECIMAL(10, 2) NOT NULL,
    [log_used_gb_threshold] DECIMAL(20, 2) NULL,
    [spid] INT NULL,
    [transaction_start_time] DATETIME NULL,
    [login_name] NVARCHAR(128) NULL,
    [program_name] NVARCHAR(128) NULL,
    [host_name] NVARCHAR(128) NULL,
    [host_process_id] INT NULL,
    [command] VARCHAR(16) NULL,
    [additional_info] VARCHAR(255) NULL,
    [action_taken] VARCHAR(100) NULL,
    [sql_text] VARCHAR(MAX) NULL,
    [is_pct_threshold_valid] BIT NOT NULL,
    [is_gb_threshold_valid] BIT NOT NULL,
    [threshold_condition] VARCHAR(5) NOT NULL,
    [thresholds_validated] BIT NOT NULL
);

GO
