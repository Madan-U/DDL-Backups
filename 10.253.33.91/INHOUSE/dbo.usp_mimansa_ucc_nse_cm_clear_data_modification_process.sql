-- Object: PROCEDURE dbo.usp_mimansa_ucc_nse_cm_clear_data_modification_process
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------


CREATE proc

	[dbo].[usp_mimansa_ucc_nse_cm_clear_data_modification_process]

as

	truncate table mimansa_tbl_ucc_nse_cm_trade_modification_process

	truncate table mimansa_angel_ucc_nse_cm_client1_modification_process
	truncate table mimansa_angel_ucc_nse_cm_client2_modification_process
	truncate table mimansa_angel_ucc_nse_cm_client5_modification_process

	truncate table mimansa_angel_ucc_nse_cm_client_bank_modification_process

	truncate table mimansa_angel_ucc_nse_cm_client_data_modification_process

GO
