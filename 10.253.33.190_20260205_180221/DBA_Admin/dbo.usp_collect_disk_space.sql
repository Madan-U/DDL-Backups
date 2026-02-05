-- Object: PROCEDURE dbo.usp_collect_disk_space
-- Server: 10.253.33.190 | DB: DBA_Admin
--------------------------------------------------


CREATE procedure [dbo].[usp_collect_disk_space]
	@verbose tinyint = 1
as
begin
/*	Created By:		Ajay Dwivedi (https://ajaydwivedi.com/go/sqlmonitor)
	Version:		1.0
	Modification:	2025-Jan-26 - First Draft

	exec dbo.[usp_collect_disk_space]
*/
	set nocount on;

	if @verbose > 0
		print 'Populate data into dbo.disk_space..';
	insert dbo.disk_space
	([collection_time_utc], [host_name], [disk_volume], [label], [capacity_mb], [free_mb], [block_size], [filesystem])
	select	distinct
			[collection_time_utc] = SYSUTCDATETIME(),
			[host_name] = convert(varchar(225),COALESCE(SERVERPROPERTY('ComputerNamePhysicalNetBIOS'),SERVERPROPERTY('ServerName'))),
			[disk_volume] = vs.volume_mount_point,
			[label] = null,
			[capacity_mb] = vs.total_bytes / 1048576,
			[free_mb] = vs.available_bytes / 1048576,
			[block_size] = null,
			[filesystem] = file_system_type
	from sys.master_files as mf
	cross apply sys.dm_os_volume_stats(mf.database_id, mf.file_id) as vs
	join sys.databases as db on db.database_id = mf.database_id;

end

GO
