-- Object: PROCEDURE dbo.usp_mimansa_ucc_nse_cm_update_latest_file_number_modification_process
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------

create proc
	[dbo].[usp_mimansa_ucc_nse_cm_update_latest_file_number_modification_process] (
		@file_date varchar(11)
	)
as

set nocount on

update
	mimansa_angel_tbl_ucc_nse_cm_file_count_modification_process with (tablockx)
set
	file_number = (select file_number = max(file_number) + 1 from mimansa_angel_tbl_ucc_nse_cm_file_count_modification_process where time_stamp like @file_date + '%')
where
	time_stamp like @file_date + '%'

GO
