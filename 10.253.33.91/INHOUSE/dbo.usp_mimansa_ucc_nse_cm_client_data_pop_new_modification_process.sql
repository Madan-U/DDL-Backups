-- Object: PROCEDURE dbo.usp_mimansa_ucc_nse_cm_client_data_pop_new_modification_process
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------



CREATE proc

	[dbo].[usp_mimansa_ucc_nse_cm_client_data_pop_new_modification_process]

as
begin
	set nocount on
	--exec usp_mimansa_ucc_nse_cm_client_data_pop_new_modification_process 


	/*************Fetch Adress Details*************/
		select
		party_code = ltrim(rtrim(c2.party_code)),
		Cl_Code=ltrim(rtrim(isnull(c1.Cl_Code,''))),
		Short_Name=ltrim(rtrim(isnull(Short_Name,''))),
		Long_Name=ltrim(rtrim(isnull(Long_Name,''))),
		L_Address1=ltrim(rtrim(isnull(L_Address1,''))),
		L_Address2=ltrim(rtrim(isnull(L_Address2,''))),
		L_Address3=ltrim(rtrim(isnull(L_Address3,''))),
		L_city=dbo.strip_non_alpha(ltrim(rtrim(isnull(L_city,'')))),
		L_State=dbo.strip_non_alpha_without_space(ltrim(rtrim(isnull(L_State,'')))),
		L_State_For_Other=dbo.strip_non_alpha_without_space(ltrim(rtrim(isnull(L_State,'')))),
		L_Nation=dbo.strip_non_alpha(ltrim(rtrim(isnull(L_Nation,'')))),
		L_Zip=replace(ltrim(rtrim(isnull(L_Zip,''))), ' ', ''),
		Res_Phone1=dbo.strip_non_digit(ltrim(rtrim(isnull(Res_Phone1,'')))),
		Res_Phone2=dbo.strip_non_digit(ltrim(rtrim(isnull(Res_Phone2,'')))),
		STDcode_Residence1=isnull(Res_phone1_std,''),
		STDcode_Residence2=isnull(Res_phone1_std,''),
		Off_Phone1=dbo.strip_non_digit(ltrim(rtrim(isnull(Off_Phone1,'')))),
		Off_Phone2=dbo.strip_non_digit(ltrim(rtrim(isnull(Off_Phone2,'')))),
		STDcode_Office1=isnull(Off_phone1_std,''),
		STDcode_Office2=isnull(off_phone2_std,''),
		--Email=ltrim(rtrim(isnull(Email,''))),
		Cl_type=ltrim(rtrim(isnull(Cl_type,''))),
		Cl_Status=ltrim(rtrim(isnull(Cl_Status,''))),
		--Mobile_Pager=dbo.strip_non_digit(ltrim(rtrim(isnull(Mobile_Pager,'')))),
		P_address1=ltrim(rtrim(isnull(P_address1,''))),
		P_address2=ltrim(rtrim(isnull(P_address2,''))),
		P_address3=ltrim(rtrim(isnull(P_address3,''))),
		P_City=dbo.strip_non_alpha(ltrim(rtrim(isnull(P_City,'')))),
		P_State=dbo.strip_non_alpha(ltrim(rtrim(isnull(P_State,'')))),
		P_State_For_Other=dbo.strip_non_alpha(ltrim(rtrim(isnull(P_State,'')))),
		P_nation=dbo.strip_non_alpha(ltrim(rtrim(isnull(P_nation,'')))),
		P_zip=replace(ltrim(rtrim(isnull(P_zip,''))), ' ', ''),
		P_Len=case when len(P_address1)>0 and len(P_address2)>0 and len(P_address3)>0 and len(P_City)>0 and len(P_State)>0 and len(P_nation)>0 and len(P_zip)>0
			  then 'N' else 'Y' end	,
		pan_gir_no=ltrim(rtrim(isnull(c1.pan_gir_no,''))),
		Gender=ltrim(rtrim(isnull(sex,'')))
	into #temp_Client1	
	from 
		--AngelNseCM.msajag.dbo.client1 c1 with(nolock),
		msajag.dbo.Client_Details c1 with(nolock),
		AngelNseCM.msajag.dbo.client2 c2 with(nolock),
		mimansa_tbl_ucc_nse_cm_trade_new_modification_process t with(nolock)
	where 
		c1.cl_code = c2.cl_code and 
		c2.party_code = t.party_code 

	/**************Update STATE************/
	update 
	#temp_Client1 
	set 
	L_State= dbo.fn_state_countary_value(l_state,'STATE'),
	P_State=dbo.fn_state_countary_value(P_state,'STATE'),
	L_nation=dbo.fn_state_countary_value(L_Nation,'NATION'),
	P_Nation=dbo.fn_state_countary_value(P_Nation,'NATION')

	/*******Final Result*******/
	select 
		Segment='C',
		party_code=UPPER(n1.party_code),
		Gender='',
		Fathers_Husbands_Guardians_Name='',
		Marital_status='',
		Nationality='',
		Nationality_Other='',
		Client_Email_Id=email,
		
		/*Correspondence_Client_Address_line_1='',
		Correspondence_Client_Address_City='',
		Correspondence_Client_Address_State='',
		Correspondence_Client_Address_State_Others='',
		Correspondence_Client_Address_Country='',
		Correspondence_Client_Address_Pin_code='',*/
		--Flag_Indicating_if_Correspondence_Address_is_same_as_Permanent_Address='',
		
		Correspondence_Client_Address_line_1 = left(c1_b.l_address1 +' '+ c1_b.l_address2 +' '+ c1_b.l_address3, 255),
		
		
		Correspondence_Client_Address_City = left(c1_b.l_city, 50),
		Correspondence_Client_Address_State = c1_b.l_state,
		Correspondence_Client_Address_State_Others=case when c1_b.l_state='99' then c1_b.L_State_For_Other else '' end,
		Correspondence_Client_Address_Country = left(c1_b.l_nation, 50),
		Correspondence_Client_Address_Pin_code = 
		case when c1_b.cl_status in ('1','2','3','4','5','6','7','8','9','10','15','16','19') then
				case
					when len(c1_b.l_zip) <> 6 then ''
					when len(c1_b.l_zip) = 0 then ''
					else c1_b.l_zip
				end
		else
			c1_b.l_zip
		end		,
		Flag_Indicating_if_Correspondence_Address_is_same_as_Permanent_Address=c1_b.P_Len,	
		Permanent_Client_Address_line_1 =case when c1_b.P_Len='N' then left(c1_b.P_address1 +' '+ c1_b.P_address2 +' ' + c1_b.P_address3, 255) else '' end,				
		Permanent_Client_Address_City =case when c1_b.P_Len='N' then left(c1_b.P_city, 50) else '' end,
		Permanent_Client_Address_State =case when c1_b.P_Len='N' then c1_b.P_State else '' end ,
		Permanent_Client_Address_State_Others  =case when c1_b.P_Len='N' and c1_b.P_state='99' then c1_b.P_State_For_Other else '' end,
		Permanent_Client_Address_Country =case when c1_b.P_Len='N' then left(c1_b.P_nation, 50) else '' end,
		Permanent_Client_Address_Pin_code =
		case when c1_b.P_Len='N' then 
			case when c1_b.cl_status in ('1','2','3','4','5','6','7','8','9','10','15','16','19') then
				case
					when len(c1_b.l_zip) <> 6 then ''
					when len(c1_b.l_zip) = 0 then ''
					else c1_b.l_zip
				end
			else
				c1_b.l_zip
			end
		else ''				 
		end,
		/*Permanent_Client_Address_line_1='',
		Permanent_Client_Address_City='',
		Permanent_Client_Address_State='',
		Permanent_Client_Address_State_Others='',
		Permanent_Client_Address_Country='',
		Permanent_Client_Address_Pin_code='',*/

		STD_code_Residence='',
		Telephone_Number_Residence='',
		Mobile_Pager=case when len(ltrim(rtrim(Mobile_Pager)))>10 then right(ltrim(rtrim(Mobile_Pager)),10) else ltrim(rtrim(Mobile_Pager)) end,/*Added on 26 Mar 2014*/
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
		mimansa_tbl_ucc_nse_cm_trade_new_modification_process n1 with(nolock) , AngelNseCM.msajag.dbo.client1 c1 with(nolock)
		,#temp_Client1 c1_b with(nolock)
	where 
		n1.party_code=c1.cl_code
		and n1.party_code=c1_b.party_code



		

	update
			#temp_nse_modification_Clients
		set
			UPDATIONFLAG=case when c1.UPDATIONFLAG = 'Y' then 'Y' else '' end,
			TYPEOFFACILITY=ISNULL(c1.TYPEOFFACILITY,'')
		from
			AngelNseCM.msajag.dbo.CLIENT_MASTER_UCC_DATA c1 with(nolock)
		where
			#temp_nse_modification_Clients.party_code = c1.party_code
			and len(isnull(#temp_nse_modification_Clients.party_code, '')) > 0
			and len(isnull(c1.party_code, '')) > 0		

	
			
	select * from #temp_nse_modification_Clients order by party_code

			
	drop table #temp_nse_modification_Clients
	set nocount off
end

GO
