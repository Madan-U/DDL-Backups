-- Object: PROCEDURE dbo.usp_mimansa_ucc_nse_cm_client_data_pop_new_modification_process_BAK_05MAR2014
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------













CREATE proc

	[dbo].[usp_mimansa_ucc_nse_cm_client_data_pop_new_modification_process]

as
begin
	set nocount on
	--exec usp_mimansa_ucc_nse_cm_client_data_pop_new_modification_process 
	select 
		Segment='C',
		party_code=UPPER(party_code),
		Gender='',
		Fathers_Husbands_Guardians_Name='',
		Marital_status='',
		Nationality='',
		Nationality_Other='',
		Client_Email_Id=email,
		Correspondence_Client_Address_line_1='',
		Correspondence_Client_Address_City='',
		Correspondence_Client_Address_State='',
		Correspondence_Client_Address_State_Others='',
		Correspondence_Client_Address_Country='',
		Correspondence_Client_Address_Pin_code='',
		Flag_Indicating_if_Correspondence_Address_is_same_as_Permanent_Address='',
		Permanent_Client_Address_line_1='',
		Permanent_Client_Address_City='',
		Permanent_Client_Address_State='',
		Permanent_Client_Address_State_Others='',
		Permanent_Client_Address_Country='',
		Permanent_Client_Address_Pin_code='',
		STD_code_Residence='',
		Telephone_Number_Residence='',
		Mobile_Pager,
		STD_code_Office='',
		Telephone_Number_Office='',
		Date_of_Birth_Incorporation='',
		Bank_Name_1='',
		Bank_Branch_Address_1='',
		Bank_Account_No_1='',
		Depository_Name_1='',
		Depository_ID_1='',
		Beneficial_Owner_Account_No_1='',
		Corporate_Identity_number_CIN='',
		Gross_Annual_Income_Range='',
		Gross_Annual_Income_as_on_Date='',
		Net_Worth_In_Rs='',
		Net_Worth_as_on_Date='',
		Politically_Exposed_Person_PE='',
		Occupation='',
		Occupation_Details_For_others='',
		Custodial_Participant_CP_Code_of_the_client='',
		UPDATIONFLAG='',
		Relationship='',
		TYPEOFFACILITY='',
		Client_Type_Corporate='',
		Name_of_contact_Person_1='',
		Designation_of_Contact_Person_1='',
		PAN_of_contact_Person_1='',
		Address_of_contact_Person_1='',
		Contact_details_of_contact_Person_1='',
		DIN_of_contact_Person_1='',
		UID__of_contact_Person_1='',
		Email_Id_of_contact_Person_1='',
		Name_of_contact_Person_2='',
		Designation_of_contact_Person_2='',
		PAN_of_contact_Person_2='',
		Address_of_contact_Person_2='',
		Contact_details_of_contact_Person_2='',
		DIN_of_contact_Person_2='',
		UID__of_contact_Person_2='',
		Email_Id_of_contact_Person_2='',
		EndRecordFlag='E'
	into
		#temp_nse_modification_Clients	
	from 
		mimansa_tbl_ucc_nse_cm_trade_new_modification_process n1 with(nolock) , anand1.msajag.dbo.client1 c1 with(nolock)
	where 
		n1.party_code=c1.cl_code
		
	update
			#temp_nse_modification_Clients
		set
			UPDATIONFLAG=case when c1.UPDATIONFLAG = 'Y' then 'Y' else '' end,
			TYPEOFFACILITY=ISNULL(c1.TYPEOFFACILITY,'')
		from
			anand1.msajag.dbo.CLIENT_MASTER_UCC_DATA c1 with(nolock)
		where
			#temp_nse_modification_Clients.party_code = c1.party_code
			and len(isnull(#temp_nse_modification_Clients.party_code, '')) > 0
			and len(isnull(c1.party_code, '')) > 0		
			
	select * from #temp_nse_modification_Clients order by party_code

			
	drop table #temp_nse_modification_Clients
	set nocount off
end

GO
