-- Object: PROCEDURE dbo.mimansa_usp_ucc_nse_cm_client_data_pop
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------






CREATE proc

	[dbo].[mimansa_usp_ucc_nse_cm_client_data_pop]

as

	set nocount on

	/*******************FETCH DATA**************************/

	truncate table mimansa_angel_ucc_nse_cm_client_data

	set implicit_transactions off
	set transaction isolation level read uncommitted

	/*insert into 
		angel_ucc_nse_cm_client1*/
	select
		party_code = ltrim(rtrim(c2.party_code)),
		--c1.*
		Cl_Code=ltrim(rtrim(isnull(c1.Cl_Code,''))),Short_Name=ltrim(rtrim(isnull(Short_Name,''))),Long_Name=ltrim(rtrim(isnull(Long_Name,''))),
		L_Address1=ltrim(rtrim(isnull(L_Address1,''))),L_Address2=ltrim(rtrim(isnull(L_Address2,''))),L_city=dbo.strip_non_alpha(ltrim(rtrim(isnull(L_city,'')))),
		L_State=dbo.strip_non_alpha(ltrim(rtrim(isnull(L_State,'')))),L_Nation=dbo.strip_non_alpha(ltrim(rtrim(isnull(L_Nation,'')))),L_Zip=ltrim(rtrim(isnull(L_Zip,''))),
		Fax=ltrim(rtrim(isnull(Fax,''))),Res_Phone1=dbo.strip_non_digit(ltrim(rtrim(isnull(Res_Phone1,'')))),Res_Phone2=dbo.strip_non_digit(ltrim(rtrim(isnull(Res_Phone2,'')))),
		Off_Phone1=dbo.strip_non_digit(ltrim(rtrim(isnull(Off_Phone1,'')))),Off_Phone2=dbo.strip_non_digit(ltrim(rtrim(isnull(Off_Phone2,'')))),
		Email=ltrim(rtrim(isnull(Email,''))),Branch_cd=ltrim(rtrim(isnull(Branch_cd,''))),Credit_Limit=ltrim(rtrim(Credit_Limit)),
		Cl_type=ltrim(rtrim(isnull(Cl_type,''))),Cl_Status=ltrim(rtrim(isnull(Cl_Status,''))),Gl_Code=ltrim(rtrim(isnull(Gl_Code,''))),
		Fd_Code=ltrim(rtrim(isnull(Fd_Code,''))),Family=ltrim(rtrim(isnull(Family,''))),Penalty=ltrim(rtrim(Penalty)),
		Sub_Broker=ltrim(rtrim(isnull(Sub_Broker,''))),Confirm_fax=ltrim(rtrim(isnull(Confirm_fax,''))),PhoneOld=ltrim(rtrim(isnull(PhoneOld,''))),
		L_Address3=ltrim(rtrim(isnull(L_Address3,''))),Mobile_Pager=dbo.strip_non_digit(ltrim(rtrim(isnull(Mobile_Pager,'')))),
		pan_gir_no=ltrim(rtrim(isnull(pan_gir_no,''))),trader=ltrim(rtrim(isnull(trader,''))),Ward_No=ltrim(rtrim(isnull(Ward_No,''))),
		Region=ltrim(rtrim(isnull(Region,''))),Area=ltrim(rtrim(isnull(Area,''))),Clrating=ltrim(rtrim(isnull(Clrating,'')))
	into #temp_Client1	
	from 
		AngelNseCM.msajag.dbo.client1 c1 with(nolock),
		AngelNseCM.msajag.dbo.client2 c2 with(nolock),
		mimansa_angel_tbl_ucc_nse_cm_trade t with (nolock)
	where 
		c1.cl_code = c2.cl_code and 
		c2.party_code = t.party_code 

	/*insert into
		angel_ucc_nse_cm_client2*/
	select 
		--c2.*
		cl_code,party_code=c2.party_code
	into #temp_Client2	
	from 
		AngelNseCM.msajag.dbo.client2 c2 with(nolock),
		mimansa_angel_tbl_ucc_nse_cm_trade t with (nolock)
	where 
		c2.party_code = t.party_code
	
	/*insert into
		angel_ucc_nse_cm_client5*/
	select 
		party_code = ltrim(rtrim(t.party_code)),
		--c5.*
		cl_code=ltrim(rtrim(isnull(c5.cl_code,''))),BirthDate=ltrim(rtrim(isnull(c5.BirthDate,''))),
		ActiveFrom=ltrim(rtrim(isnull(c5.ActiveFrom,''))),InactiveFrom=ltrim(rtrim(isnull(c5.InactiveFrom,'')))
	into #temp_Client5	
	from 
		AngelNseCM.msajag.dbo.client5 c5 with(nolock),
		#temp_Client2 t with (nolock)
	where 
		c5.cl_code = t.cl_code

	select distinct
		party_code = ltrim(rtrim(c4.party_code)),
		bank_id = ltrim(rtrim(c4.bankid)),
		bank_name = ltrim(rtrim(isnull(b.bank_name, ''))),
		bank_address = ltrim(rtrim(isnull(b.address1, ''))) + space(1) + ltrim(rtrim(isnull(b.address2, ''))) + space(1) + ltrim(rtrim(isnull(b.city, ''))) + space(1) + ltrim(rtrim(isnull(b.state, ''))) + space(1) + ltrim(rtrim(isnull(b.nation, ''))),
		account_type = ltrim(rtrim(c4.depository)),
		account_no = ltrim(rtrim(c4.cltdpid))
	into
		#pobank
	from
		mimansa_angel_tbl_ucc_nse_cm_trade t with (nolock),
		AngelNseCM.msajag.dbo.client4 c4 with(nolock),
		AngelNseCM.msajag.dbo.pobank b with(nolock)
	where
		t.party_code = c4.party_code and
		c4.bankid = b.bankid and
		isnull(c4.depository, '') in ('SAVING', 'CURRENT', 'OTHER')

	select distinct
		party_code = ltrim(rtrim(c4.party_code)),
		bank_id = ltrim(rtrim(c4.bankid)),
		bank_name = ltrim(rtrim(isnull(b.bankname, ''))),
		bank_address = ltrim(rtrim(isnull(b.address1, ''))) + space(1) + ltrim(rtrim(isnull(b.address2, ''))) + space(1) + ltrim(rtrim(isnull(b.city, ''))),
		account_type = ltrim(rtrim(c4.depository)),
		account_no = ltrim(rtrim(c4.cltdpid))
	into
		#bank
	from
		mimansa_angel_tbl_ucc_nse_cm_trade t with (nolock),
		AngelNseCM.msajag.dbo.client4 c4 with(nolock),
		AngelNseCM.msajag.dbo.bank b with(nolock)
	where
		t.party_code = c4.party_code and
		c4.bankid = b.bankid and
		isnull(c4.depository, '') in ('CDSL', 'NSDL') and
		isnull(c4.defdp, '') = '1'

	/*insert into
		angel_ucc_nse_cm_client_bank*/
	select distinct
		party_code = ltrim(rtrim(case when po.party_code is null then b.party_code else po.party_code end)),
		bank_name = ltrim(rtrim(isnull(po.bank_name, ''))),
		bank_address = ltrim(rtrim(isnull(po.bank_address, ''))),
		bank_account_type = ltrim(rtrim(isnull(po.account_type, ''))),
		bank_account_no = ltrim(rtrim(isnull(po.account_no, ''))),

		dp_id = ltrim(rtrim(isnull(b.bank_id, ''))),
		dp_name = ltrim(rtrim(isnull(b.account_type, ''))),
		depository_participant = ltrim(rtrim(isnull(b.bank_name, ''))),
		demat_id_of_client = ltrim(rtrim(isnull(b.account_no, '')))
	into #temp_client_bank	
	from
		#pobank po full outer join #bank b on ltrim(rtrim(po.party_code)) = ltrim(rtrim(b.party_code))
	order by
		ltrim(rtrim(case when po.party_code is null then b.party_code else po.party_code end))


	/*******************END - FETCH DATA**************************/

	insert into
		mimansa_angel_ucc_nse_cm_client_data
	select
		segment = 'C',
		client_code = 
			left(
				isnull(
					replace(
						replace(
							replace(
								ltrim(rtrim(isnull(c2.party_code, 'NA'))), '%', ''
							), '|', ''
						), ',', ''
					), 'NA'
				), 10
			),
		client_name = left(c1_b.long_name, 150),

		category =
			case
				/*INDIVIDUAL/PROPRIETORSHIP FIRMS*/
				when c1_b.cl_status = 'IND' then '1'		/*INDIVIDUAL*/

				/*PARTNERSHIP FIRM*/
				when c1_b.cl_status = 'PF' then '2'		/*PARTNERSHIP FIRMS*/

				/*HUF*/
				when c1_b.cl_status = 'HUF' then '3'		/*HINDU UNDIVIDED FAMILY*/

				/*PUBLIC & PRIVATE COMPANIES / BODIES CORPORATE*/
				when c1_b.cl_status = 'PPB' then '4'		/*PUB. PVT COMP/BODIES CORP*/
				when c1_b.cl_status = 'BCP' then '4'		/*BODY CORPORATE*/

				/*TRUST / SOCIETY*/
				when c1_b.cl_status = 'TS' then ' 5'		/*TRUST / SOCIETY*/

				/*MUTUAL FUND*/
				when c1_b.cl_status = 'MF' then ' 6'		/*MUTUAL FUNDS*/
				when c1_b.cl_status = 'MFF' then '6'		/*MUTUAL FUND (MF)*/

				/*DOMESTIC FINANCIAL INSTITUTIONS (OTHER THAN BANKS & INSURANCE)*/
				when c1_b.cl_status = 'IFI' then '7'		/*INDIAN FINANCIAL INSTI*/
				when c1_b.cl_status = 'DFI' then '7'		/*DOMESTIC FIN. INST.*/

				/*BANK*/
				when c1_b.cl_status = 'BA' then ' 8'		/*BANKS*/
				when c1_b.cl_status = 'BNK' then '8'		/*BANK*/

				/*INSURANCE*/
				when c1_b.cl_status = 'IC' then ' 9'		/*INSURANCE COMPANIES*/

				/*STATUTORY BODIES*/
				when c1_b.cl_status = 'SB' then ' 10'		/*STATUTORY BODIES*/

				/*NRI*/
				when c1_b.cl_status = 'NRI' then '11'		/*NON RESIDENT INDIAN*/

				/*FII*/
				when c1_b.cl_status = 'FII' then '12'		/*FOREIGN INSTIT INVESTORS*/

				/*OCB*/
				when c1_b.cl_status = 'OCB' then '13'		/*OVERSEAS CORPORATE BODIES*/

				/*FOREIGN DIRECT INVESTMENTS (FDI) / FOREIGN VENTURE CAPITAL FUNDS (VC)*/
				when c1_b.cl_status = 'DFN' then '14'		/*DIRECT FOREIGN INVESTMENTS*/
				when c1_b.cl_status = 'FVC' then '14'		/*FOREIGN VENTURE CAPITAL FUNDS*/
			else
				'1'		/*INDIVIDUAL*/
			end,

		pan =dbo.fn_validate_pan (pan_gir_no, 'NA'),
		client_email_id = left(email, 60),
		client_address_1 = left(
			case
				when len(ltrim(rtrim(isnull(c1_b.l_address1, '')))) = 0
				then ''
				else ltrim(rtrim(isnull(c1_b.l_address1, '')))
				end
			+
			case
				when len(ltrim(rtrim(isnull(c1_b.l_address2, '')))) = 0
				then ''
				else ltrim(rtrim(isnull(c1_b.l_address2, '')))
				end
			+
			case
				when len(ltrim(rtrim(isnull(c1_b.l_address3, '')))) = 0
				then ''
				else ltrim(rtrim(isnull(c1_b.l_address3, '')))
				end, 255
			),

		client_address_2 = '',
		client_address_3 = '',
		city = left(
			case 
				when len(ltrim(rtrim(isnull(c1_b.l_city, '')))) = 0
				then 'NA'
				else ltrim(rtrim(isnull(c1_b.l_city, 'NA')))
				end, 50
			),
		state = left(
			case 
				when len(ltrim(rtrim(isnull(c1_b.l_state, '')))) = 0 then 'NA'
				else ltrim(rtrim(isnull(c1_b.l_state, 'NA')))
			end, 50
		),
		country = left(
			case 
				when len(ltrim(rtrim(isnull(c1_b.l_nation, '')))) = 0
				then 'NA'
				else ltrim(rtrim(isnull(c1_b.l_nation, 'NA')))
				end, 50
			),
		pin_code = left(
			replace(
				case
					when len(ltrim(rtrim(isnull(c1_b.l_zip, '')))) <> 6 then ''
					when len(ltrim(rtrim(isnull(c1_b.l_zip, '')))) = 0 then ''
					else ltrim(rtrim(isnull(c1_b.l_zip, '')))
				end, ' ', ''
			), 6
		),
		isd_code = left('', 14),
		std_code = left('', 10),
		telephone_number = 
			left(
					
						case 
							when len(isnull(c1_b.res_phone1, '')) > 0 then isnull(c1_b.res_phone1, '')
							when len(isnull(c1_b.res_phone2, '')) > 0 then isnull(c1_b.res_phone2, '')
							when len(isnull(c1_b.off_phone1, '')) > 0 then isnull(c1_b.off_phone1, '')
							when len(isnull(c1_b.off_phone2, '')) > 0 then isnull(c1_b.off_phone2, '')
						else 
							'' 
						end
												
						, 60
				),
		mobile_number =left(c1_b.mobile_pager, 10),
		date_of_birth_incorporation = '',
		client_agreement_date = '',
		registration_no_of_client = '',
		registering_authority = '',
		place_of_registration = '',
		date_of_registration = '',
		bank_name = '',
		bank_branch_address ='', 
		bank_account_type = '',
		bank_account_no = '',
		depository_id = '',
		depository_name ='',			
		beneficiary_account_no ='',
		proof_type = '',
		proof_number = '',
		issue_place_of_proof = '',
		issue_date_of_proof = '',
		name_of_contact_person_1 = '',
		designation_of_contact_person_1 = '',
		pan_of_contact_person_1 = '',
		address_of_contact_person_1 = '',
		telephone_no_of_contact_person_1 = '',
		email_id_of_contact_person_1 = '',
		name_of_contact_person_2 = '',
		designation_of_contact_person_2 = '',
		pan_of_contact_person_2 = '',
		address_of_contact_person_2 = '',
		telephone_no_of_contact_person_2 = '',
		email_id_of_contact_person_2 = '',
		name_of_contact_person_3 = '',
		designation_of_contact_person_3 = '',
		pan_of_contact_person_3 = '',
		address_of_contact_person_3 = '',
		contact_of_contact_person_3 = '',
		email_id_of_contact_person_3 = '',
		inperson_verification = 'Y',
		
		UPDATIONFLAG='',
	    RELATIONSHIP='',
	    MASTERPAN='',
	    TYPEOFFACILITY='', 
		
		flag = 'E',

		is_active = case when c5.inactivefrom > getdate() then 'Y' else 'N' end,
		pan_orig = pan_gir_no,
		client_code_orig = c2.party_code,
		time_stamp = getdate(),
		cin=''	




/******************************************************************************************************************************************************/


	from
		(
			select
				c1.*,
				b.bank_name, b.bank_address, b.bank_account_type, b.bank_account_no, b.dp_id, b.dp_name, b.depository_participant, b.demat_id_of_client
			from
				#temp_Client1 c1 with (nolock)
					left outer join
				#temp_client_bank b with (nolock)
					on ltrim(rtrim(c1.party_code)) = ltrim(rtrim(b.party_code))
		) c1_b,
		#temp_Client2 c2 with (nolock),
		#temp_Client5 c5 with (nolock)

	where
		ltrim(rtrim(c1_b.party_code)) = ltrim(rtrim(c2.party_code)) and
		ltrim(rtrim(c2.party_code)) = ltrim(rtrim(c5.party_code)) and
		ltrim(rtrim(left(c2.party_code,2))) <> '98'

	update
		mimansa_angel_ucc_nse_cm_client_data
	set
		client_name = ltrim(rtrim(isnull(addemailid, '')))
	from
		AngelNseCM.msajag.dbo.client_details
	where
		ltrim(rtrim(client_code)) = ltrim(rtrim(party_code))
		and len(ltrim(rtrim(isnull(client_code, '')))) > 0
		and len(ltrim(rtrim(isnull(party_code, '')))) > 0
		and len(ltrim(rtrim(isnull(addemailid, '')))) > 0
		
	update
		mimansa_angel_ucc_nse_cm_client_data
	set
		UPDATIONFLAG=isnull(c1.UPDATIONFLAG,''),
	    --RELATIONSHIP=ISNULL(c1.RELATIONSHIP,''),
	    RELATIONSHIP='',--Commented by prasanna on 24/12/2013. On mail confirmation of ajay.
	    MASTERPAN=ISNULL(c1.MASTERPAN,''),
	    TYPEOFFACILITY=ISNULL(c1.TYPEOFFACILITY,'')
	from
		AngelNseCM.msajag.dbo.CLIENT_MASTER_UCC_DATA c1 with(nolock)
	where
		client_code = party_code
		and len(isnull(client_code, '')) > 0
		and len(isnull(party_code, '')) > 0	
	
	--Added by prasanna on Jun 19 2012 for adding CIN column in Ucc Nsecm file as suggested in circular. 	
	update
		mimansa_angel_ucc_nse_cm_client_data
	set
		mimansa_angel_ucc_nse_cm_client_data.cin=isnull(c1.cin,'')
	from
		AngelNseCM.msajag.dbo.CLIENT_MASTER_NOMINEE_DATA c1 with(nolock)
	where
		client_code = party_code
		and len(isnull(client_code, '')) > 0
		and len(isnull(party_code, '')) > 0	
		and mimansa_angel_ucc_nse_cm_client_data.category=4	

	set nocount off

GO
