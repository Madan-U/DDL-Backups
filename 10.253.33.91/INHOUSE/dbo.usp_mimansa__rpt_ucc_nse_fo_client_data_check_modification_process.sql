-- Object: PROCEDURE dbo.usp_mimansa__rpt_ucc_nse_fo_client_data_check_modification_process
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------

CREATE proc

	[dbo].[usp_mimansa__rpt_ucc_nse_fo_client_data_check_modification_process]

as

	declare @strPAN_Invalid_Reasons varchar(2000)

	select distinct
		client_code = client_code,
		client_name = client_name,
		pan = pan,
		pan_orig,
		pan_err = 
			case 
				when isnull(pan_orig, 'NA') = 'NA'
				then 'NO PAN'
				when len(isnull(pan_orig, '')) = 0
				then 'NO PAN'
				when not (
					isnumeric(left(isnull(pan_orig, ''), 5)) = 0 and
					isnumeric(substring(isnull(pan_orig, ''), 6, 4)) = 1 and
					isnumeric(right(isnull(pan_orig, ''), 1)) = 0 and
					len(isnull(pan_orig, ''))= 10
				)
				then 'INVALID PAN'
			end,

		pan_length = len(isnull(pan_orig, '')),
		telephone_number = telephone_number,
		client_address_1 = client_address_1

	from
		mimansa_angel_ucc_nse_cm_client_data_modification_process

	where
		isnull(pan, 'NA') = 'NA'

	order by
		pan_err, 
		client_code

GO
