-- Object: TABLE dbo.perfmon_files
-- Server: 10.253.78.167 | DB: DBA_Admin
--------------------------------------------------

CREATE TABLE [dbo].[perfmon_files]
(
    [host_name] VARCHAR(255) NOT NULL,
    [file_name] VARCHAR(255) NOT NULL,
    [file_path] VARCHAR(255) NOT NULL,
    [collection_time_utc] DATETIME2 NOT NULL DEFAULT (sysutcdatetime())
);

GO
