-- Object: TABLE dbo.xevent_metrics_queries
-- Server: 10.253.33.227 | DB: DBA_Admin
--------------------------------------------------

CREATE TABLE [dbo].[xevent_metrics_queries]
(
    [row_id] BIGINT NOT NULL,
    [start_time] DATETIME2 NOT NULL,
    [event_time] DATETIME2 NOT NULL,
    [sql_text] VARCHAR(MAX) NULL
);

GO
