-- Object: TABLE dbo.xevent_metrics_Processed_XEL_Files
-- Server: 10.253.78.187 | DB: DBA_Admin
--------------------------------------------------

CREATE TABLE [dbo].[xevent_metrics_Processed_XEL_Files]
(
    [file_path] VARCHAR(2000) NOT NULL,
    [collection_time_utc] DATETIME2 NOT NULL DEFAULT (sysutcdatetime()),
    [is_processed] BIT NOT NULL DEFAULT ((0)),
    [is_removed_from_disk] BIT NOT NULL DEFAULT ((0))
);

GO
