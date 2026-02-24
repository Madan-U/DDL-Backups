-- Object: PROCEDURE dbo.mimansa_usp_ucc_nse_cm_client_data_fetch_new_changes_temp_bak
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------



CREATE proc

	[dbo].[mimansa_usp_ucc_nse_cm_client_data_fetch_new_changes_temp_bak]
as

set nocount on

select distinct
Segment=segment, 
		Client_Code=replace(clientcode,'A99',''),
	client_name ='',
	category=''
	,pan=''
	,client_email_id=emailaddress
	,client_address_1=''
	,client_address_2=''
	,client_address_3=''
	,city  =''
		
	,state = ''
		
	,country 
		=''
	,pin_code=''
	,isd_code=''
	,std_code=''
	,telephone_number=''
	,mobile_number=''
	,date_of_birth_incorporation=''
	,client_agreement_date=''
	,registration_no_of_client=''
	,registering_authority=''
	,place_of_registration=''
	,date_of_registration=''
	,bank_name=''
	,bank_branch_address=''
	,bank_account_type=''
	,bank_account_no=''
	,depository_id=''
	,depository_name=''
	,beneficiary_account_no	=''
	,proof_type=''
	,proof_number=''
	,issue_place_of_proof=''
	,issue_date_of_proof=''
	,name_of_contact_person_1=''
	,designation_of_contact_person_1=''
	,pan_of_contact_person_1=''
	,address_of_contact_person_1=''
	,telephone_no_of_contact_person_1=''
	,email_id_of_contact_person_1=''
	,name_of_contact_person_2=''
	,designation_of_contact_person_2=''
	,pan_of_contact_person_2=''
	,address_of_contact_person_2=''
	,telephone_no_of_contact_person_2=''
	,email_id_of_contact_person_2=''
	,name_of_contact_person_3=''
	,designation_of_contact_person_3=''
	,pan_of_contact_person_3=''
	,address_of_contact_person_3=''
	,contact_of_contact_person_3=''
	,email_id_of_contact_person_3=''
	,inperson_verification=''
	,UPDATIONFLAG=''
	,RELATIONSHIP=''
	,MASTERPAN=''
	,TYPEOFFACILITY =''
	,CIN=''
	,flag='E'
		 
		
from
	mimansa.angelcs.dbo.UCC_NSE_DATA_3

GO
