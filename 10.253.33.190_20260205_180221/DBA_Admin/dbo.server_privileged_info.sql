-- Object: TABLE dbo.server_privileged_info
-- Server: 10.253.33.190 | DB: DBA_Admin
--------------------------------------------------

CREATE TABLE [dbo].[server_privileged_info]
(
    [collection_time_utc] DATETIME2 NOT NULL DEFAULT (sysutcdatetime()),
    [host_name] VARCHAR(125) NOT NULL,
    [host_distribution] VARCHAR(200) NULL,
    [processor_name] VARCHAR(200) NULL,
    [fqdn] VARCHAR(255) NULL
);

GO
