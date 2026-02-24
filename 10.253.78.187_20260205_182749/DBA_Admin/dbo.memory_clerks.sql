-- Object: TABLE dbo.memory_clerks
-- Server: 10.253.78.187 | DB: DBA_Admin
--------------------------------------------------

CREATE TABLE [dbo].[memory_clerks]
(
    [collection_time_utc] DATETIME2 NOT NULL DEFAULT (sysutcdatetime()),
    [memory_clerk] VARCHAR(255) NOT NULL,
    [name] VARCHAR(255) NOT NULL,
    [size_mb] BIGINT NOT NULL
);

GO
