-- Object: TABLE dbo.BlitzFirst_WaitStats_Categories
-- Server: 10.253.78.167 | DB: DBA_Admin
--------------------------------------------------

CREATE TABLE [dbo].[BlitzFirst_WaitStats_Categories]
(
    [WaitType] NVARCHAR(60) NOT NULL,
    [WaitCategory] NVARCHAR(128) NOT NULL,
    [Ignorable] BIT NULL DEFAULT ((0)),
    [IgnorableOnPerCoreMetric] BIT NULL DEFAULT ((0)),
    [IgnorableOnDashboard] BIT NULL DEFAULT ((0))
);

GO
