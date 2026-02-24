-- Object: TABLE dbo.BlitzIndex_Mode1
-- Server: 10.253.33.227 | DB: DBA_Admin
--------------------------------------------------

CREATE TABLE [dbo].[BlitzIndex_Mode1]
(
    [id] BIGINT IDENTITY(1,1) NOT NULL,
    [run_id] UNIQUEIDENTIFIER NULL,
    [run_datetime] DATETIME NOT NULL DEFAULT (getdate()),
    [server_name] NVARCHAR(128) NULL,
    [database_name] NVARCHAR(128) NULL,
    [object_count] INT NULL,
    [reserved_gb] NUMERIC(29, 1) NULL,
    [reserved_lob_gb] NUMERIC(29, 1) NULL,
    [reserved_row_overflow_gb] NUMERIC(29, 1) NULL,
    [clustered_table_count] INT NULL,
    [clustered_table_gb] NUMERIC(29, 1) NULL,
    [nc_index_count] INT NULL,
    [nc_index_gb] NUMERIC(29, 1) NULL,
    [table_nc_index_ratio] NUMERIC(29, 1) NULL,
    [heap_count] INT NULL,
    [heap_gb] NUMERIC(29, 1) NULL,
    [partioned_table_count] INT NULL,
    [partioned_nc_count] INT NULL,
    [partioned_gb] NUMERIC(29, 1) NULL,
    [filtered_index_count] INT NULL,
    [indexed_view_count] INT NULL,
    [max_table_row_count] INT NULL,
    [max_table_gb] NUMERIC(29, 1) NULL,
    [max_nc_index_gb] NUMERIC(29, 1) NULL,
    [table_count_over_1gb] INT NULL,
    [table_count_over_10gb] INT NULL,
    [table_count_over_100gb] INT NULL,
    [nc_index_count_over_1gb] INT NULL,
    [nc_index_count_over_10gb] INT NULL,
    [nc_index_count_over_100gb] INT NULL,
    [min_create_date] DATETIME NULL,
    [max_create_date] DATETIME NULL,
    [max_modify_date] DATETIME NULL,
    [display_order] INT NULL,
    [total_forwarded_fetch_count] BIGINT NULL
);

GO
