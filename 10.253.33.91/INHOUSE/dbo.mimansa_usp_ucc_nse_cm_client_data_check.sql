-- Object: PROCEDURE dbo.mimansa_usp_ucc_nse_cm_client_data_check
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------


CREATE proc

	[dbo].[mimansa_usp_ucc_nse_cm_client_data_check]

as

	declare @strPAN_Invalid_Reasons varchar(2000)

	select distinct
		client_code = ltrim(rtrim(client_code)),
		client_name = ltrim(rtrim(client_name)),
		pan = ltrim(rtrim(pan)),
		pan,
		pan_err = 
			case 
				when ltrim(rtrim(isnull(pan, 'NA'))) = 'NA'
				then 'NO PAN'
				when len(ltrim(rtrim(isnull(pan, '')))) = 0
				then 'NO PAN'
				when not (
					isnumeric(left(ltrim(rtrim(isnull(pan, ''))), 5)) = 0 and
					isnumeric(substring(ltrim(rtrim(isnull(pan, ''))), 6, 4)) = 1 and
					isnumeric(right(ltrim(rtrim(isnull(pan, ''))), 1)) = 0 and
					len(ltrim(rtrim(isnull(pan, '')))) = 10
				)
				then 'INVALID PAN'
			end,

		pan_length = len(ltrim(rtrim(isnull(pan, '')))),
		telephone_number = ltrim(rtrim(TelephoneNumber_Residence)),
		client_address_1 = ltrim(rtrim(CorrespondenceClientAddressline1))

	from
		--mimansa_angel_ucc_nse_cm_client_data with(nolock)
		mimansa_angel_ucc_nse_cm_client_data_new_changes with(nolock)
	where
		ltrim(rtrim(isnull(pan, 'NA'))) = 'NA'

	order by
		pan_err, 
		client_code

GO
