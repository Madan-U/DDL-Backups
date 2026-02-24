-- Object: PROCEDURE dbo.usp_mimansa_rpt_ucc_nse_cm_client_data_check_modification_process
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------





create proc

	[dbo].[usp_mimansa_rpt_ucc_nse_cm_client_data_check_modification_process]

as

	declare @strPAN_Invalid_Reasons varchar(2000)

	select distinct
		client_code = ltrim(rtrim(client_code)),
		client_name = ltrim(rtrim(client_name)),
		pan = ltrim(rtrim(pan)),
		pan_orig,
		pan_err = 
			case 
				when ltrim(rtrim(isnull(pan_orig, 'NA'))) = 'NA'
				then 'NO PAN'
				when len(ltrim(rtrim(isnull(pan_orig, '')))) = 0
				then 'NO PAN'
				when not (
					isnumeric(left(ltrim(rtrim(isnull(pan_orig, ''))), 5)) = 0 and
					isnumeric(substring(ltrim(rtrim(isnull(pan_orig, ''))), 6, 4)) = 1 and
					isnumeric(right(ltrim(rtrim(isnull(pan_orig, ''))), 1)) = 0 and
					len(ltrim(rtrim(isnull(pan_orig, '')))) = 10
				)
				then 'INVALID PAN'
			end,

		pan_length = len(ltrim(rtrim(isnull(pan_orig, '')))),
		telephone_number = ltrim(rtrim(telephone_number)),
		client_address_1 = ltrim(rtrim(client_address_1))

	from
		mimansa_angel_ucc_nse_cm_client_data_modification_process

	where
		ltrim(rtrim(isnull(pan, 'NA'))) = 'NA'

	order by
		pan_err, 
		client_code

GO
