-- Object: PROCEDURE dbo.mimansa_usp_ucc_nse_cm_client_data_pop_new_changes_bak
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------





CREATE proc

	[dbo].[mimansa_usp_ucc_nse_cm_client_data_pop_new_changes_bak]

as

	set nocount on

	/*******************FETCH DATA**************************/

	truncate table mimansa_angel_ucc_nse_cm_client_data_new_changes

	set implicit_transactions off
	set transaction isolation level read uncommitted
		
	select
		--party_code = ltrim(rtrim(c2.party_code)),
		--c1.*
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
		L_Zip=ltrim(rtrim(isnull(L_Zip,''))),
		--Fax=ltrim(rtrim(isnull(Fax,''))),
		Res_Phone1=dbo.strip_non_digit(ltrim(rtrim(isnull(Res_Phone1,'')))),
		Res_Phone2=dbo.strip_non_digit(ltrim(rtrim(isnull(Res_Phone2,'')))),
		STDcode_Residence1=isnull(Res_phone1_std,''),
		STDcode_Residence2=isnull(Res_phone2_std,''),
		Off_Phone1=dbo.strip_non_digit(ltrim(rtrim(isnull(Off_Phone1,'')))),
		Off_Phone2=dbo.strip_non_digit(ltrim(rtrim(isnull(Off_Phone2,'')))),
		STDcode_Office1=isnull(Off_phone1_std,''),
		STDcode_Office2=isnull(off_phone2_std,''),
		Email=ltrim(rtrim(isnull(Email,''))),
		--Branch_cd=ltrim(rtrim(isnull(Branch_cd,''))),
		--Credit_Limit=ltrim(rtrim(Credit_Limit)),
		Cl_type=ltrim(rtrim(isnull(Cl_type,''))),
		Cl_Status=ltrim(rtrim(isnull(Cl_Status,''))),
		--Gl_Code=ltrim(rtrim(isnull(Gl_Code,''))),
		--Fd_Code=ltrim(rtrim(isnull(Fd_Code,''))),
		--Family=ltrim(rtrim(isnull(Family,''))),
		--Penalty=ltrim(rtrim(Penalty)),
		--Sub_Broker=ltrim(rtrim(isnull(Sub_Broker,''))),
		--Confirm_fax=ltrim(rtrim(isnull(Confirm_fax,''))),
		--PhoneOld=ltrim(rtrim(isnull(PhoneOld,''))),
		Mobile_Pager=dbo.strip_non_digit(ltrim(rtrim(isnull(Mobile_Pager,'')))),
		pan_gir_no=ltrim(rtrim(isnull(pan_gir_no,''))),
		--trader=ltrim(rtrim(isnull(trader,''))),
		--Ward_No=ltrim(rtrim(isnull(Ward_No,''))),
		--Region=ltrim(rtrim(isnull(Region,''))),
		--Area=ltrim(rtrim(isnull(Area,''))),
		--Clrating=ltrim(rtrim(isnull(Clrating,'')))
		P_address1=ltrim(rtrim(isnull(c1.P_address1,''))),
		P_address2=ltrim(rtrim(isnull(c1.P_address2,''))),
		P_address3=ltrim(rtrim(isnull(c1.P_address3,''))),
		P_City=dbo.strip_non_alpha(ltrim(rtrim(isnull(c1.P_City,'')))),
		P_State=dbo.strip_non_alpha(ltrim(rtrim(isnull(c1.P_State,'')))),
		P_State_For_Other=dbo.strip_non_alpha_without_space(ltrim(rtrim(isnull(c1.P_State,'')))),
		P_nation=dbo.strip_non_alpha(ltrim(rtrim(isnull(c1.P_nation,'')))),
		P_zip=replace(ltrim(rtrim(isnull(c1.P_zip,''))), ' ', ''),
		P_Len=case when len(c1.P_address1)>0 and len(c1.P_address2)>0 and len(c1.P_address3)>0 and 
						len(c1.P_City)>0 and len(c1.P_State)>0 and len(c1.P_nation)>0 and len(c1.P_zip)>0
				then 'N' else 'Y' end	,
		Gender=ltrim(rtrim(isnull(c1.sex,''))),
		BirthDate=upper(ltrim(rtrim(isnull(replace(convert(varchar(11), c1.dob, 113),' ','-'),'')))),
		ActiveFrom=t.Active_From,
		InactiveFrom='',
		GrossAnnualIncomeasonDate=upper(ltrim(rtrim(isnull(replace(convert(varchar(11), t.Active_From, 113),' ','-'),'')))),
		bank_name = ltrim(rtrim(isnull(c1.bank_name, ''))),
		bank_address = ltrim(rtrim(isnull(c1.branch_name, ''))),
		bank_account_type = ltrim(rtrim(isnull(c1.ac_type, ''))),
		bank_account_no = ltrim(rtrim(isnull(c1.ac_num, ''))),
		dp_id1 = ltrim(rtrim(isnull(c1.dpid1, ''))),
		dp_name1 = ltrim(rtrim(isnull(c1.depository1, ''))),
		depository_participant1 = '',
		demat_id_of_client1 = ltrim(rtrim(isnull(c1.cltdpid1, ''))),
		dp_id2 = ltrim(rtrim(isnull(c1.dpid2, ''))),
		dp_name2 = ltrim(rtrim(isnull(c1.depository2, ''))),
		depository_participant2 = '',
		demat_id_of_client2 = ltrim(rtrim(isnull(c1.cltdpid2, ''))),
		dp_id3 = ltrim(rtrim(isnull(c1.dpid3, ''))),
		dp_name3 = ltrim(rtrim(isnull(c1.depository3, ''))),
		depository_participant3 = '',
		demat_id_of_client3 = ltrim(rtrim(isnull(c1.cltdpid3, '')))
	into #temp_Client1	
	from 
		anand1.msajag.dbo.Client_Details c1 with(nolock),
		mimansa_angel_tbl_ucc_nse_cm_trade_new_changes t with (nolock)
	where 
		c1.cl_code = t.party_code 

	update 
		#temp_Client1 
	set 
	L_State= dbo.fn_state_countary_value(l_state,'STATE'),
	P_State=dbo.fn_state_countary_value(P_state,'STATE'),
	L_nation=dbo.fn_state_countary_value(L_Nation,'NATION'),
	P_Nation=dbo.fn_state_countary_value(P_Nation,'NATION'),
	bank_account_type=case 
				when bank_account_type='S' then 'SAVING'
				when bank_account_type='C' then 'CURRENT'
				else bank_account_type end,			
	cl_status=case
				/*INDIVIDUAL/PROPRIETORSHIP FIRMS*/
				when cl_status = 'IND' then '1'		/*INDIVIDUAL*/

				/*PARTNERSHIP FIRM*/
				when cl_status = 'PF' or cl_status='LLP' then '2'		/*PARTNERSHIP FIRMS*/

				/*HUF*/
				when cl_status = 'HUF' then '3'		/*HINDU UNDIVIDED FAMILY*/

				/*PUBLIC & PRIVATE COMPANIES / BODIES CORPORATE*/
				when cl_status = 'PPB' then '4'		/*PUB. PVT COMP/BODIES CORP*/
				when cl_status = 'BCP' then '4'		/*BODY CORPORATE*/

				/*TRUST / SOCIETY*/
				when cl_status = 'TS' then '5'		/*TRUST / SOCIETY*/

				/*MUTUAL FUND*/
				when cl_status = 'MF' then '6'		/*MUTUAL FUNDS*/
				when cl_status = 'MFF' then '6'		/*MUTUAL FUND (MF)*/

				/*DOMESTIC FINANCIAL INSTITUTIONS (OTHER THAN BANKS & INSURANCE)*/
				when cl_status = 'IFI' then '7'		/*INDIAN FINANCIAL INSTI*/
				when cl_status = 'DFI' then '7'		/*DOMESTIC FIN. INST.*/

				/*BANK*/
				when cl_status = 'BA' then ' 8'		/*BANKS*/
				when cl_status = 'BNK' then '8'		/*BANK*/

				/*INSURANCE*/
				when cl_status = 'IC' then ' 9'		/*INSURANCE COMPANIES*/

				/*STATUTORY BODIES*/
				when cl_status = 'SB' then ' 10'		/*STATUTORY BODIES*/

				/*NRI*/
				when cl_status = 'NRI' or cl_status='NRE' or cl_status='NRO' then '11'		/*NON RESIDENT INDIAN*/

				/*FII*/
				when cl_status = 'FII' then '12'		/*FOREIGN INSTIT INVESTORS*/

				/*OCB*/
				when cl_status = 'OCB' then '13'		/*OVERSEAS CORPORATE BODIES*/

				/*FOREIGN DIRECT INVESTMENTS (FDI) / FOREIGN VENTURE CAPITAL FUNDS (VC)*/
				when cl_status = 'DFN' then '14'		/*DIRECT FOREIGN INVESTMENTS*/

				when cl_status = 'QFI' then '17'       /*Qualified foreign investors*/
				
				/*FVC*/
				when cl_status = 'FVC' then '20'		/*FOREIGN VENTURE CAPITAL FUNDS*/
			else
				'1'		/*INDIVIDUAL*/
			end
	

	
	/*******************END - FETCH DATA**************************/

	insert into
		mimansa_angel_ucc_nse_cm_client_data_new_changes
		
	select
		segment = 'C',
		client_code = c1_b.cl_code,
		client_name = left(c1_b.long_name, 150),
		category =cl_status,
		pan =dbo.fn_validate_pan (c1_b.pan_gir_no, 'NA'),
		Gender=c1_b.Gender,
		Fathers_Husbands_GuardiansName ='',
		Maritalstatus='',
		Nationality ='',
		Nationality_Other='', 
		ClientEmailId = left(email, 60),
		CorrespondenceClientAddressline1 = left(
			case
				when len(c1_b.l_address1) = 0
				then ''
				else ltrim(rtrim(isnull(c1_b.l_address1, '')))
				end
			+
			case
				when len(c1_b.l_address2) = 0
				then ''
				else ltrim(rtrim(isnull(c1_b.l_address2, '')))
				end
			+
			case
				when len(c1_b.l_address3) = 0
				then ''
				else ltrim(rtrim(isnull(c1_b.l_address3, '')))
				end, 255
			),

		CorrespondenceClientAddressline2 = '',
		CorrespondenceClientAddressline3 = '',
		CorrespondenceClientAddress_City = left(c1_b.l_city, 50),
		CorrespondenceClientAddress_State = c1_b.l_state,
		CorrespondenceClientAddress_State_Others=case when c1_b.l_state='99' then c1_b.L_State_For_Other else '' end,
		CorrespondenceClientAddress_Country = left(c1_b.l_nation, 50),
		CorrespondenceClientAddress_Pincode = 
		case when c1_b.cl_status in ('1','2','3','4','5','6','7','8','9','10','15','16','19') then
				case
					when len(c1_b.l_zip) <> 6 then ''
					when len(c1_b.l_zip) = 0 then ''
					else c1_b.l_zip
				end
		else
			c1_b.l_zip
		end		,
		FlagIndicatingifCorrespondenceAddressissameasPermanentAddress=c1_b.P_Len,	
		PermanentClientAddressline1 =case when c1_b.P_Len='N' then left(c1_b.P_address1, 255) else '' end,
		PermanentClientAddressline2 =case when c1_b.P_Len='N' then left(c1_b.P_address2, 255) else '' end,
		PermanentClientAddressline3 =case when c1_b.P_Len='N' then left(c1_b.P_address3, 255) else '' end,
		PermanentClientAddress_City =case when c1_b.P_Len='N' then left(c1_b.P_city, 50) else '' end,
		PermanentClientAddress_State =case when c1_b.P_Len='N' then c1_b.P_State else '' end ,
		PermanentClientAddress_StateOthers  =case when c1_b.P_Len='N' and c1_b.P_state='99' then c1_b.P_State_For_Other else '' end,
		PermanentClientAddress_Country =case when c1_b.P_Len='N' then left(c1_b.P_nation, 50) else '' end,
		PermanentClientAddress_Pincode =
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
		ISDcode_Residence ='',
		STDcode_Residence =case 
							when len(STDcode_Residence1)>0 then STDcode_Residence1
							when len(STDcode_Residence2)>0 then STDcode_Residence2
						   else '' end,		 
		TelephoneNumber_Residence = 
			left(	case 
						when len(isnull(c1_b.res_phone1, '')) > 0 then isnull(c1_b.res_phone1, '')
						when len(isnull(c1_b.res_phone2, '')) > 0 then isnull(c1_b.res_phone2, '')
					else 
						'' 
					end
				, 60
				),
		Mobilenumber =left(c1_b.mobile_pager, 10),
		ISDcode_Office ='',
		STDcode_Office =case 
							when len(STDcode_Office1)>0 then STDcode_Office1
							when len(STDcode_Office2)>0 then STDcode_Office2
						   else '' end,	
		TelephoneNumber_Office=
			left(	case 
						when len(isnull(c1_b.off_phone1, '')) > 0 then isnull(c1_b.off_phone1, '')
						when len(isnull(c1_b.off_phone2, '')) > 0 then isnull(c1_b.off_phone2, '')
					else 
						'' 
					end
				, 60
				),
		DateofBirth_Incorporation = case when c1_b.BirthDate='01-JAN-1900' then '' else c1_b.BirthDate end ,
		UIDNUMBER='',

	
		BankName1 =bank_name,
		BankBranchAddress1=case when len(bank_address)>0 then 'Branch Address '+ bank_address else '' end , 
		BankAccountNo1 =bank_account_no,
		BankAccountType1 =case 
							when bank_account_type = 'SAVING' then '10'
							when bank_account_type = 'CURRENT' then '11'
							when bank_account_type = 'OTHER' then '99' 
						  else ''
							end ,
		BankName2 ='',
		BankBranchAddress2 ='',
		BankAccountNo2 ='',
		BankAccountType2 ='',
		BankName3 ='',
		BankBranchAddress3 ='',
		BankAccountNo3 ='',
		BankAccountType3 ='',
		
		DepositoryName1 = dp_name1,
		DepositoryID1 = case when dp_name1='NSDL' then dp_id1 else '' end,
		BeneficialOwnerAccountNo1 =demat_id_of_client1,
		
		DepositoryName2 =dp_name2,
		DepositoryID2 =case when dp_name2='NSDL' then dp_id2 else '' end,
		BeneficialOwnerAccountNo2 =demat_id_of_client2,

		DepositoryName3 =dp_name3,
		DepositoryID3 =case when dp_name3='NSDL' then dp_id3 else '' end,
		BeneficialOwnerAccountNo3 =demat_id_of_client3,

		CorporateIdentitynumber_CIN='',
		GrossAnnualIncomeRange ='',
		GrossAnnualIncomeasonDate =case when c1_b.GrossAnnualIncomeasonDate='01-JAN-1900' then '' else c1_b.GrossAnnualIncomeasonDate end ,
		NetWorth_InRs ='',
		NetWorthasonDate ='',
		PoliticallyExposedPerson_PEP='0', 
		PlaceofIncorporation ='',
		Occupation ='',
		OccupationDetails_Forothers='', 
		Dateofcommencementofbusiness ='',
		CustodialParticipantCodeoftheclient ='',
		RegistrationNoofClient ='',
		RegisteringAuthority ='',
		PlaceofRegistration ='',
		DateofRegistration ='',
		InpersonVerification ='Y',
		ClientAgreementDate ='',
		UniqueClientCodeallottedbyNSCCL_BSE ='',
		UpdationFlag_for_SMS_and_Email_facility='', 
		Relationship ='',
		TypeofFacility_for_SMS_and_Email_facility ='',
		ProofType ='',
		ProofNumber ='',
		IssuePlaceofProof='', 
		IssueDateofProof ='',
		ClientStatus ='A',
		Remarks ='',
		ClientType_Corporate='', 
		NameofcontactPerson_1 ='',
		DesignationofContactPerson_1 ='',
		PANofcontactPerson_1 ='',
		AddressofcontactPerson_1 ='',
		ContactdetailsofcontactPerson_1 ='',
		DINofcontactPerson_1 ='',
		UIDofcontactPerson_1 ='',
		EmailIdofcontactPerson_1 ='',
		NameofcontactPerson_2  ='',
		DesignationofcontactPerson_2 ='',
		PANofcontactPerson_2 ='',
		AddressofcontactPerson_2 ='',
		ContactdetailsofcontactPerson_2='', 
		DINofcontactPerson_2 ='',
		UIDofcontactPerson_2 ='',
		EmailIdofcontactPerson_2 ='',
		NameofcontactPerson_3 ='',
		DesignationofcontactPerson_3='', 
		PANofcontactPerson_3 ='',
		AddressofcontactPerson_3 ='',
		ContactdetailsofcontactPerson_3='', 
		DINofcontactPerson_3 ='',
		UIDofcontactPerson_3 ='',
		EmailIdofcontactPerson_3 ='',
		NameofcontactPerson_4 ='',
		DesignationofcontactPerson_4='', 
		PANofcontactPerson_4 ='',
		AddressofcontactPerson_4 ='',
		ContactdetailsofcontactPerson_4 ='',
		DINofcontactPerson_4 ='',
		UIDofcontactPerson_4 ='',
		EmailIdofcontactPerson_4 ='',
		NameofcontactPerson_5 ='',
		DesignationofcontactPerson_5 ='',
		PANofcontactPerson_5 ='',
		AddressofcontactPerson_5 ='',
		ContactdetailsofcontactPerson_5='', 
		DINofcontactPerson_5 ='',
		UIDofcontactPerson_5 ='',
		EmailIdofcontactPerson_5 ='',
		NameofcontactPerson_6 ='',
		DesignationofcontactPerson_6='', 
		PANofcontactPerson_6 ='',
		AddressofcontactPerson_6 ='',
		ContactdetailsofcontactPerson_6='', 
		DINofcontactPerson_6 ='',
		UIDofcontactPerson_6 ='',
		EmailIdofcontactPerson_6 ='',
		NameofcontactPerson_7 ='',
		DesignationofcontactPerson_7='', 
		PANofcontactPerson_7 ='',
		AddressofcontactPerson_7 ='',
		ContactdetailsofcontactPerson_7='', 
		DINofcontactPerson_7 ='',
		UIDofcontactPerson_7 ='',
		EmailIdofcontactPerson_7 ='',
		NameofcontactPerson_8 ='',
		DesignationofcontactPerson_8 ='',
		PANofcontactPerson_8 ='',
		AddressofcontactPerson_8 ='',
		ContactdetailsofcontactPerson_8 ='',
		DINofcontactPerson_8 ='',
		UIDofcontactPerson_8 ='',
		EmailIdofcontactPerson_8 ='',
		NameofcontactPerson_9 ='',
		DesignationofcontactPerson_9='', 
		PANofcontactPerson_9 ='',
		AddressofcontactPerson_9 ='',
		ContactdetailsofcontactPerson_9='', 
		DINofcontactPerson_9 ='',
		UIDofcontactPerson_9 ='',
		EmailIdofcontactPerson_9 ='',
		NameofcontactPerson_10 ='',
		DesignationofcontactPerson_10='', 
		PANofcontactPerson_10 ='',
		AddressofcontactPerson_10 ='',
		ContactdetailsofcontactPerson_10='', 
		DINofcontactPerson_10 ='',
		UIDofcontactPerson_10 ='',
		EmailIdofcontactPerson_10 ='',
		NameofcontactPerson_11 ='',
		DesignationofcontactPerson_11='', 
		PANofcontactPerson_11 ='',
		AddressofcontactPerson_11 ='',
		ContactdetailsofcontactPerson_11='', 
		DINofcontactPerson_11 ='',
		UIDofcontactPerson_11 ='',
		EmailIdofcontactPerson_11 ='',
		NameofcontactPerson_12 ='',
		DesignationofcontactPerson_12='', 
		PANofcontactPerson_12 ='',
		AddressofcontactPerson_12 ='',
		ContactdetailsofcontactPerson_12='', 
		DINofcontactPerson_12 ='',
		UIDofcontactPerson_12 ='',
		EmailIdofcontactPerson_12 ='',
		NameofcontactPerson_13 ='',
		DesignationofcontactPerson_13 ='',
		PANofcontactPerson_13 ='',
		AddressofcontactPerson_13 ='',
		ContactdetailsofcontactPerson_13 ='',
		DINofcontactPerson_13 ='',
		UIDofcontactPerson_13 ='',
		EmailIdofcontactPerson_13 ='',
		NameofcontactPerson_14 ='',
		DesignationofcontactPerson_14 ='',
		PANofcontactPerson_14 ='',
		AddressofcontactPerson_14 ='',
		ContactdetailsofcontactPerson_14 ='',
		DINofcontactPerson_14 ='',
		UIDofcontactPerson_14 ='',
		EmailIdofcontactPerson_14 ='',
		NameofcontactPerson_15 ='',
		DesignationofcontactPerson_15 ='',
		PANofcontactPerson_15 ='',
		AddressofcontactPerson_15 ='',
		ContactdetailsofcontactPerson_15='', 
		DINofcontactPerson_15 ='',
		UIDofcontactPerson_15 ='',
		EmailIdofcontactPerson_15 ='',
		NameofcontactPerson_16 ='',
		DesignationofcontactPerson_16='', 
		PANofcontactPerson_16 ='',
		AddressofcontactPerson_16 ='',
		ContactdetailsofcontactPerson_16='', 
		DINofcontactPerson_16 ='',
		UIDofcontactPerson_16 ='',
		EmailIdofcontactPerson_16 ='',
		NameofcontactPerson_17 ='',
		DesignationofcontactPerson_17='', 
		PANofcontactPerson_17 ='',
		AddressofcontactPerson_17 ='',
		ContactdetailsofcontactPerson_17='', 
		DINofcontactPerson_17 ='',
		UIDofcontactPerson_17 ='',
		EmailIdofcontactPerson_17 ='',
		NameofcontactPerson_18 ='',
		DesignationofcontactPerson_18='', 
		PANofcontactPerson_18 ='',
		AddressofcontactPerson_18 ='',
		ContactdetailsofcontactPerson_18='', 
		DINofcontactPerson_18 ='',
		UIDofcontactPerson_18 ='',
		EmailIdofcontactPerson_18 ='',
		NameofcontactPerson_19 ='',
		DesignationofcontactPerson_19='', 
		PANofcontactPerson_19 ='',
		AddressofcontactPerson_19 ='',
		ContactdetailsofcontactPerson_19='', 
		DINofcontactPerson_19 ='',
		UIDofcontactPerson_19 ='',
		EmailIdofcontactPerson_19 ='',
		NameofcontactPerson_20 ='',
		DesignationofcontactPerson_20='', 
		PANofcontactPerson_20 ='',
		AddressofcontactPerson_20 ='',
		ContactdetailsofcontactPerson_20='', 
		DINofcontactPerson_20 ='',
		UIDofcontactPerson_20 ='',
		EmailIdofcontactPerson_20 ='',
		Flag='E'
		
	from
		--(
			--select
			--	c1.*,
			--	b.bank_name, b.bank_address, b.bank_account_type, b.bank_account_no, b.dp_id, b.dp_name, b.depository_participant, b.demat_id_of_client
			--from
			--	#temp_Client1 c1 with (nolock)
			--		left outer join
			--	#temp_client_bank b with (nolock)
			--		on ltrim(rtrim(c1.party_code)) = ltrim(rtrim(b.party_code))
		--) c1_b,
		--#temp_Client2 c2 with (nolock),
		--#temp_Client5 c5 with (nolock)
		#temp_Client1 c1_b with (nolock)

	--where
	--	ltrim(rtrim(c1_b.party_code)) = ltrim(rtrim(c2.party_code)) and
	--	ltrim(rtrim(c2.party_code)) = ltrim(rtrim(c5.party_code)) and
	--	ltrim(rtrim(left(c2.party_code,2))) <> '98'

	order by c1_b.cl_code

	--update
	--	mimansa_angel_ucc_nse_cm_client_data
	--set
	--	client_name = ltrim(rtrim(isnull(addemailid, '')))
	--from
	--	anand1.msajag.dbo.client_details
	--where
	--	ltrim(rtrim(client_code)) = ltrim(rtrim(party_code))
	--	and len(ltrim(rtrim(isnull(client_code, '')))) > 0
	--	and len(ltrim(rtrim(isnull(party_code, '')))) > 0
	--	and len(ltrim(rtrim(isnull(addemailid, '')))) > 0
		
	update
		mimansa_angel_ucc_nse_cm_client_data_new_changes
	set
		UpdationFlag_for_SMS_and_Email_facility=isnull(c1.UPDATIONFLAG,''),
	    RELATIONSHIP=ISNULL(c1.RELATIONSHIP,''),
	    --MASTERPAN=ISNULL(c1.MASTERPAN,''),
	    TypeofFacility_for_SMS_and_Email_facility=ISNULL(c1.TYPEOFFACILITY,''),
		--Gender=isnull(c1.Gender,''),
		Fathers_Husbands_GuardiansName=isnull(c1.FATHERNAME,''),
		Maritalstatus=
			case when mimansa_angel_ucc_nse_cm_client_data_new_changes.category in ('1','11','18') then
					case 
						when isnull(c1.MARITALSTATUS,'')='01' then 'S' 
						when isnull(c1.MARITALSTATUS,'')='02' then 'M'
						else 'S' 
					end
			else
				''
			end			,
		Nationality=
					case when mimansa_angel_ucc_nse_cm_client_data_new_changes.category in ('1','11','18') then  right(isnull(c1.Nationality,'1'),1) else '' end, 
		NATIONALITY_OTHER=case when isnull(c1.Nationality,'1')=2 then isnull(c1.NATIONALITY_OTHER,'') else '' end,
		GrossAnnualIncomeRange=case 
					when c1.Gross_Income ='01' then '1'
					when c1.Gross_Income ='02' then '2'
					when c1.Gross_Income ='03' then '3'
					when c1.Gross_Income ='04' then '4'
					when c1.Gross_Income ='05' then '5'
					when c1.Gross_Income ='06' then '6'
					when c1.Gross_Income ='07' then '7'
					else '' end, 
		NetWorth_InRs=isnull(case when c1.Net_worth > 0 then cast(c1.Net_worth as varchar) else '' end  ,''),
		NetWorthasonDate=case when upper(ltrim(rtrim(isnull(replace(convert(varchar(11), c1.Net_worth_Date, 113),' ','-'),''))))='01-JAN-1900' then ''
						else upper(ltrim(rtrim(isnull(replace(convert(varchar(11), c1.Net_worth_Date, 113),' ','-'),'')))) end,
		PoliticallyExposedPerson_PEP=case 
				when c1.PEP='01' or c1.pep ='PEP' then '01' 
				when c1.PEP='02' or c1.pep ='RPEP' then '02'
				else '0' end,
		Occupation=case 
				when c1.Occupation='01' then '01'
				when c1.Occupation='02' then '02'
				when c1.Occupation='03' then '04'
				when c1.Occupation='04' then '05'
				when c1.Occupation='05' then '06'
				when c1.Occupation='06' then '07'
				when c1.Occupation='07' then '08'
				when c1.Occupation='08' then '09'
				when c1.Occupation='10' then '03'
				else '99' end,
		OccupationDetails_Forothers=isnull(Occupation_Other,''),
		UIDNUMBER=isnull(c1.AADHAR_UID,'')
	from
		anand1.msajag.dbo.CLIENT_MASTER_UCC_DATA c1 with(nolock)
	where
		client_code = party_code
		and len(isnull(client_code, '')) > 0
		and len(isnull(party_code, '')) > 0	

	update 
		mimansa_angel_ucc_nse_cm_client_data_new_changes 
	set 
		GrossAnnualIncomeasonDate='',
		NetWorth_InRs='',
		NetWorthasonDate=''
	where len(GrossAnnualIncomeRange)=0 

	--Added by prasanna on Jun 19 2012 for adding CIN column in Ucc Nsecm file as suggested in circular. 	
	update
		mimansa_angel_ucc_nse_cm_client_data_new_changes
	set
		mimansa_angel_ucc_nse_cm_client_data_new_changes.CorporateIdentitynumber_CIN=isnull(c1.cin,'')
	from
		anand1.msajag.dbo.CLIENT_MASTER_NOMINEE_DATA c1 with(nolock)
	where
		client_code = party_code
		and len(isnull(client_code, '')) > 0
		and len(isnull(party_code, '')) > 0	
		and mimansa_angel_ucc_nse_cm_client_data_new_changes.category=4	


	insert into mimansa_angel_ucc_nse_cm_client_data_new_changes_log select *,'','',getdate() from mimansa_angel_ucc_nse_cm_client_data_new_changes

	set nocount off

GO
