-- Object: PROCEDURE dbo.usp_mimansa_ucc_nse_cm_clear_data_new_modification_process
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------


CREATE proc

	[dbo].[usp_mimansa_ucc_nse_cm_clear_data_new_modification_process]

as
begin
	truncate table mimansa_tbl_ucc_nse_cm_trade_new_modification_process
end

GO
