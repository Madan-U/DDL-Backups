-- Object: PROCEDURE dbo.usp_mimansa_ucc_nse_cm_client_data_fetch_modification_process
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------







CREATE proc

	[dbo].[usp_mimansa_ucc_nse_cm_client_data_fetch_modification_process] 
as

/*
	exec sp_ucc_nse_cm_client_data_fetch 'N'
	exec sp_ucc_nse_cm_client_data_fetch 'Y'
*/

set nocount on

delete
	mimansa_angel_ucc_nse_cm_client_data_modification_process
from
	--tbl_ucc_banned_pan bp
	--[196.1.115.239].inhouse.dbo.AllSebiBannedEntities bp with (nolock)
	INTRANET.mimansa.dbo.UCC_AllSebiBannedEntities bp with (nolock)
where
	ltrim(rtrim(replace(isnull(mimansa_angel_ucc_nse_cm_client_data_modification_process.pan, ''), ',', ''))) = ltrim(rtrim(isnull(bp.panno, '')))
	and len(bp.panno)=10	


select distinct
	segment
	,client_code
	,client_name =
		case 
			when len(ltrim(rtrim(dbo.strip_non_alpha_without_space( client_name )))) = 0 
			then 'NA'
			else ltrim(rtrim(dbo.strip_non_alpha_without_space( client_name )))
		end
	,category
	,pan
	,client_email_id
	,client_address_1
	,client_address_2
	,client_address_3
	,city = 
		case 
			when len(ltrim(rtrim(dbo.strip_non_alpha( city )))) = 0 
			then 'NA'
			else ltrim(rtrim(dbo.strip_non_alpha( city )))
		end
	,state = 
		case 
			when len(ltrim(rtrim(dbo.strip_non_alpha( state )))) = 0 
			then 'NA'
			else ltrim(rtrim(dbo.strip_non_alpha( state )))
		end
	,country = 
		case 
			when len(ltrim(rtrim(dbo.strip_non_alpha( country )))) = 0 
			then 'NA'
			else ltrim(rtrim(dbo.strip_non_alpha( country )))
		end
	,pin_code
	,isd_code
	,std_code
	,telephone_number
	,mobile_number
	,date_of_birth_incorporation
	,client_agreement_date
	,registration_no_of_client
	,registering_authority
	,place_of_registration
	,date_of_registration
	,bank_name
	,bank_branch_address
	,bank_account_type
	,bank_account_no
	,depository_id
	,depository_name
	,beneficiary_account_no	
	,proof_type
	,proof_number
	,issue_place_of_proof
	,issue_date_of_proof
	,name_of_contact_person_1
	,designation_of_contact_person_1
	,pan_of_contact_person_1
	,address_of_contact_person_1
	,telephone_no_of_contact_person_1
	,email_id_of_contact_person_1
	,name_of_contact_person_2
	,designation_of_contact_person_2
	,pan_of_contact_person_2
	,address_of_contact_person_2
	,telephone_no_of_contact_person_2
	,email_id_of_contact_person_2
	,name_of_contact_person_3
	,designation_of_contact_person_3
	,pan_of_contact_person_3
	,address_of_contact_person_3
	,contact_of_contact_person_3
	,email_id_of_contact_person_3
	,inperson_verification
	,UPDATIONFLAG
	,RELATIONSHIP
	,MASTERPAN
	,TYPEOFFACILITY 
	,CIN
	,flag

from
	mimansa_angel_ucc_nse_cm_client_data_modification_process with(nolock)

where
	len(ltrim(rtrim(isnull(pan, '')))) > 0 and
	isnull(pan, '' ) <> 'NA'

GO
