-- Object: PROCEDURE dbo.usp_mimansa_ucc_nse_cm_get_latest_file_number_modification_process
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------

CREATE proc
	[dbo].[usp_mimansa_ucc_nse_cm_get_latest_file_number_modification_process] (
		@file_date varchar(11)
	)
as

/*
	sp_ucc_nse_cm_get_latest_file_number 'Aug 25 2008'
	select * from tbl_ucc_nse_cm_file_count
	----------sp_ucc_nse_cm_update_latest_file_number 'Aug 25 2008'
	----------truncate table tbl_ucc_nse_cm_file_count
*/

set nocount on

declare
	@file_number bigint

declare @Fromfile_date datetime
declare @Tofile_date datetime

set @Fromfile_date=@file_date + ' 00:00'
set @Tofile_date=@file_date + ' 23:59'

	
select
	 @file_number=isnull(max(file_number), 0)
from
	mimansa_angel_tbl_ucc_nse_cm_file_count_modification_process with (tablockx)
where
	time_stamp >= @Fromfile_date
	and time_stamp <= @Tofile_date

--select
--	@file_number = isnull(max(file_number), 0)
--from
--	mimansa_angel_tbl_ucc_nse_cm_file_count_modification_process with (tablockx)
--where
--	time_stamp like @file_date + '%'

if @file_number = 99 begin
	select
		@file_number = -1
end

if @file_number = 0 begin
	insert into
		mimansa_angel_tbl_ucc_nse_cm_file_count_modification_process with (tablockx) (
			file_number
			,time_stamp
		) values (
			@file_number
			,getdate()
		)
end		/*if @file_number = 1*/

select
	latest_file_number = @file_number + 1

GO
