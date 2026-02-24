-- Object: VIEW dbo.vw_file_io_stats_deltas
-- Server: 10.253.33.231 | DB: DBA_Admin
--------------------------------------------------


CREATE VIEW [dbo].[vw_file_io_stats_deltas]
WITH SCHEMABINDING 
AS
WITH RowDates as ( 
	SELECT ROW_NUMBER() OVER (ORDER BY [collection_time_utc]) ID, [collection_time_utc]
	FROM [dbo].[file_io_stats] 
	--WHERE [collection_time_utc] between @start_time and @end_time
	GROUP BY [collection_time_utc]
)
, collection_time_utcs as
(	SELECT ThisDate.collection_time_utc, LastDate.collection_time_utc as Previouscollection_time_utc
    FROM RowDates ThisDate
    JOIN RowDates LastDate
    ON ThisDate.ID = LastDate.ID + 1
)
, [t_DiskDrives] AS 
(	select ds.disk_volume
	from dbo.disk_space ds
	where ds.collection_time_utc = (select max(i.collection_time_utc) from dbo.disk_space i)
)
--select * from collection_time_utcs
SELECT s.collection_time_utc, s.database_name, dv.disk_volume, s.[file_logical_name], s.[file_location],
		[sample_ms_delta] = s.sample_ms - sPrior.sample_ms,
		[elapsed_seconds] = DATEDIFF(ss, sPrior.collection_time_utc, s.collection_time_utc),
		[read_write_bytes_delta] = ( (s.[num_of_bytes_read]+s.[num_of_bytes_written]) - (sPrior.[num_of_bytes_read]+sPrior.[num_of_bytes_written]) ),
		[read_writes_delta] = ( (s.[num_of_reads]+s.[num_of_writes]) - (sPrior.[num_of_reads]+sPrior.[num_of_writes]) ),  
		[read_bytes_delta] = s.[num_of_bytes_read] - sPrior.[num_of_bytes_read],
		[writes_bytes_delta] = s.[num_of_bytes_read] - sPrior.[num_of_bytes_read],
		[num_of_reads_delta] = s.[num_of_reads] - sPrior.[num_of_reads],
		[num_of_writes_delta] = s.[num_of_writes] - sPrior.[num_of_writes],
		[io_stall_delta] = s.[io_stall]- sPrior.[io_stall]
FROM [dbo].[file_io_stats] s
INNER JOIN collection_time_utcs Dates
	ON Dates.collection_time_utc = s.collection_time_utc
INNER JOIN [dbo].[file_io_stats] sPrior 
	ON s.[database_name] = sPrior.[database_name] 
	AND s.[file_logical_name] = sPrior.[file_logical_name] 
	AND Dates.Previouscollection_time_utc = sPrior.collection_time_utc
OUTER APPLY (
			select top 1 dd.disk_volume
			from [t_DiskDrives] dd
			where s.file_location like (dd.disk_volume+'%')
			order by len(dd.disk_volume) desc
		) dv
WHERE [s].[io_stall] >= [sPrior].[io_stall]
--ORDER BY s.collection_time_utc, wait_time_ms_delta desc

GO
