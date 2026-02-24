-- Object: TABLE dbo.HostConnectionsCount
-- Server: 10.253.33.231 | DB: DBA_Admin
--------------------------------------------------

CREATE TABLE [dbo].[HostConnectionsCount]
(
    [CaptureDateTime] DATETIME NULL,
    [databasename] NVARCHAR(128) NULL,
    [text] NVARCHAR(MAX) NULL,
    [host_name] NVARCHAR(128) NULL,
    [connections] INT NULL
);

GO
