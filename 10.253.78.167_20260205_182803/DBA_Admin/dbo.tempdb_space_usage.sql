-- Object: TABLE dbo.tempdb_space_usage
-- Server: 10.253.78.167 | DB: DBA_Admin
--------------------------------------------------

CREATE TABLE [dbo].[tempdb_space_usage]
(
    [collection_time] DATETIME2 NOT NULL,
    [data_size_mb] VARCHAR(100) NOT NULL,
    [data_used_mb] VARCHAR(100) NOT NULL,
    [data_used_pct] DECIMAL(5, 2) NOT NULL,
    [log_size_mb] VARCHAR(100) NOT NULL,
    [log_used_mb] VARCHAR(100) NULL,
    [log_used_pct] DECIMAL(5, 2) NULL,
    [version_store_mb] DECIMAL(20, 2) NULL,
    [version_store_pct] DECIMAL(20, 2) NULL
);

GO
