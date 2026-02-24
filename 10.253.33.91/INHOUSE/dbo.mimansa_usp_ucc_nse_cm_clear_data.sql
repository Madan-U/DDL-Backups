-- Object: PROCEDURE dbo.mimansa_usp_ucc_nse_cm_clear_data
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------

CREATE proc

	[dbo].[mimansa_usp_ucc_nse_cm_clear_data]

as

	truncate table mimansa_angel_tbl_ucc_nse_cm_trade

	truncate table mimansa_angel_ucc_nse_cm_client_data
	
	truncate table mimansa_angel_ucc_nse_cm_client_data_new_changes

GO
