-- Object: TABLE dbo.file_io_stats
-- Server: 10.253.33.227 | DB: DBA_Admin
--------------------------------------------------

CREATE TABLE [dbo].[file_io_stats]
(
    [collection_time_utc] DATETIME2 NOT NULL,
    [database_name] NVARCHAR(128) NOT NULL,
    [database_id] INT NOT NULL,
    [file_logical_name] NVARCHAR(128) NOT NULL,
    [file_id] INT NOT NULL,
    [file_location] NVARCHAR(260) NOT NULL,
    [sample_ms] BIGINT NOT NULL,
    [num_of_reads] BIGINT NOT NULL,
    [num_of_bytes_read] BIGINT NOT NULL,
    [io_stall_read_ms] BIGINT NOT NULL,
    [io_stall_queued_read_ms] BIGINT NOT NULL,
    [num_of_writes] BIGINT NOT NULL,
    [num_of_bytes_written] BIGINT NOT NULL,
    [io_stall_write_ms] BIGINT NOT NULL,
    [io_stall_queued_write_ms] BIGINT NOT NULL,
    [io_stall] BIGINT NOT NULL,
    [size_on_disk_bytes] BIGINT NOT NULL,
    [io_pending_count] BIGINT NULL DEFAULT ((0)),
    [io_pending_ms_ticks_total] BIGINT NULL DEFAULT ((0)),
    [io_pending_ms_ticks_avg] BIGINT NULL DEFAULT ((0)),
    [io_pending_ms_ticks_max] BIGINT NULL DEFAULT ((0)),
    [io_pending_ms_ticks_min] BIGINT NULL DEFAULT ((0))
);

GO
