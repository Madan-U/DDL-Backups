-- Object: TABLE dbo.alert_history
-- Server: 10.253.78.187 | DB: DBA_Admin
--------------------------------------------------

CREATE TABLE [dbo].[alert_history]
(
    [collection_time_utc] DATETIME2 NOT NULL DEFAULT (sysutcdatetime()),
    [server_name] NVARCHAR(128) NULL,
    [database_name] NVARCHAR(128) NULL,
    [error_number] INT NULL,
    [error_severity] TINYINT NULL,
    [error_message] NVARCHAR(510) NULL,
    [host_instance] NVARCHAR(128) NULL,
    [collection_time] DATETIME2 NOT NULL DEFAULT (sysdatetime())
);

GO
