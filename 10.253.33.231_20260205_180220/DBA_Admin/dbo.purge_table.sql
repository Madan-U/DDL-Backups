-- Object: TABLE dbo.purge_table
-- Server: 10.253.33.231 | DB: DBA_Admin
--------------------------------------------------

CREATE TABLE [dbo].[purge_table]
(
    [table_name] NVARCHAR(128) NOT NULL,
    [date_key] NVARCHAR(128) NOT NULL,
    [retention_days] SMALLINT NOT NULL DEFAULT ((15)),
    [purge_row_size] INT NOT NULL DEFAULT ((100000)),
    [created_by] NVARCHAR(128) NOT NULL DEFAULT (suser_name()),
    [created_date] DATETIME2 NOT NULL DEFAULT (sysdatetime()),
    [reference] VARCHAR(255) NULL,
    [latest_purge_datetime] DATETIME2 NULL
);

GO
