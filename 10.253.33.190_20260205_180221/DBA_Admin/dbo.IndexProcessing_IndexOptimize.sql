-- Object: TABLE dbo.IndexProcessing_IndexOptimize
-- Server: 10.253.33.190 | DB: DBA_Admin
--------------------------------------------------

CREATE TABLE [dbo].[IndexProcessing_IndexOptimize]
(
    [ID] BIGINT IDENTITY(1,1) NOT NULL,
    [DbName] VARCHAR(125) NOT NULL,
    [SchemaName] VARCHAR(125) NOT NULL,
    [TableName] VARCHAR(125) NOT NULL,
    [IndexName] VARCHAR(125) NULL,
    [IndexType] VARCHAR(50) NOT NULL,
    [TotalPages] BIGINT NOT NULL,
    [TotalRows] BIGINT NOT NULL,
    [AvgFragmentationPcnt] NUMERIC(28, 2) NOT NULL,
    [Defrag] BIT NOT NULL DEFAULT ((1)),
    [EntryTime] DATETIME NULL DEFAULT (getdate()),
    [IsProcessed] BIT NULL DEFAULT ((0))
);

GO
