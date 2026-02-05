-- Object: TABLE dbo.performance_counters
-- Server: 10.253.78.187 | DB: DBA_Admin
--------------------------------------------------

CREATE TABLE [dbo].[performance_counters]
(
    [collection_time_utc] DATETIME2 NOT NULL,
    [host_name] VARCHAR(255) NOT NULL,
    [object] VARCHAR(255) NOT NULL,
    [counter] VARCHAR(255) NOT NULL,
    [value] NUMERIC(38, 10) NULL,
    [instance] VARCHAR(255) NULL
);

GO
