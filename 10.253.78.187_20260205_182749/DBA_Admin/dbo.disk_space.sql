-- Object: TABLE dbo.disk_space
-- Server: 10.253.78.187 | DB: DBA_Admin
--------------------------------------------------

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
