-- Object: TABLE dbo.BlitzIndex_Mode4
-- Server: 10.253.78.187 | DB: DBA_Admin
--------------------------------------------------

CREATE TABLE [dbo].[BlitzIndex_Mode4]
(
    [id] BIGINT IDENTITY(1,1) NOT NULL,
    [run_id] UNIQUEIDENTIFIER NULL,
    [run_datetime] DATETIME NOT NULL DEFAULT (getdate()),
    [server_name] NVARCHAR(128) NULL,
    [priority] INT NULL,
    [finding] NVARCHAR(4000) NULL,
    [database_name] NVARCHAR(128) NULL,
    [details] NVARCHAR(MAX) NULL,
    [index_definition] NVARCHAR(MAX) NULL,
    [secret_columns] NVARCHAR(MAX) NULL,
    [index_usage_summary] NVARCHAR(MAX) NULL,
    [index_size_summary] NVARCHAR(MAX) NULL,
    [more_info] NVARCHAR(MAX) NULL,
    [url] NVARCHAR(MAX) NULL,
    [create_tsql] NVARCHAR(MAX) NULL,
    [sample_query_plan] XML NULL,
    [total_forwarded_fetch_count] BIGINT NULL
);

GO
