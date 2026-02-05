-- Object: TABLE dbo.alert_categories
-- Server: 10.253.78.187 | DB: DBA_Admin
--------------------------------------------------

CREATE TABLE [dbo].[alert_categories]
(
    [error_number] INT NOT NULL,
    [error_severity] INT NULL,
    [category] VARCHAR(128) NOT NULL,
    [sub_category] VARCHAR(128) NULL,
    [alert_name] VARCHAR(255) NOT NULL,
    [remarks] NVARCHAR(500) NULL,
    [created_time] DATETIME2 NOT NULL DEFAULT (sysdatetime()),
    [created_by] NVARCHAR(128) NOT NULL DEFAULT (suser_name())
);

GO
