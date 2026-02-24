-- Object: PROCEDURE dbo.usp_mimansa_ucc_nse_cm_client_data_pop_modification_process
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------














CREATE proc

	[dbo].[usp_mimansa_ucc_nse_cm_client_data_pop_modification_process]

as

	set nocount on

	/*******************FETCH DATA**************************/



	truncate table mimansa_angel_ucc_nse_cm_client1_modification_process
	truncate table mimansa_angel_ucc_nse_cm_client2_modification_process
	truncate table mimansa_angel_ucc_nse_cm_client5_modification_process


	truncate table mimansa_angel_ucc_nse_cm_client_bank_modification_process

	truncate table mimansa_angel_ucc_nse_cm_client_data_modification_process

	set implicit_transactions off
	set transaction isolation level read uncommitted

	insert into 
		mimansa_angel_ucc_nse_cm_client1_modification_process
	select
		party_code = ltrim(rtrim(c2.party_code)),
		c1.Cl_Code,c1.Short_Name,c1.Long_Name,c1.L_Address1,c1.L_Address2,c1.L_city,c1.L_State,c1.L_Nation,c1.L_Zip,c1.Fax,c1.Res_Phone1,c1.Res_Phone2,c1.Off_Phone1,c1.Off_Phone2,
		c1.Email,c1.Branch_cd,c1.Credit_Limit,c1.Cl_type,c1.Cl_Status,c1.Gl_Code,c1.Fd_Code,c1.Family,c1.Penalty,c1.Sub_Broker,c1.Confirm_fax,c1.PhoneOld,c1.L_Address3,c1.Mobile_Pager,
		c1.pan_gir_no,c1.trader,c1.Ward_No,c1.Region,c1.Area,c1.Clrating
	from 
		AngelNseCM.msajag.dbo.client1 c1 with(nolock),
		AngelNseCM.msajag.dbo.client2 c2 with(nolock),
		mimansa_tbl_ucc_nse_cm_trade_modification_process t with (nolock)
	where 
		c1.cl_code = c2.cl_code and 
		c2.party_code = t.party_code 

	insert into
		mimansa_angel_ucc_nse_cm_client2_modification_process
	select 
		c2.Cl_Code,c2.Exchange,c2.Tran_Cat,c2.Scrip_cat,c2.Party_code,c2.Table_no,c2.Sub_TableNo,c2.Margin,c2.Turnover_tax,c2.Sebi_Turn_tax,
		c2.Insurance_Chrg,c2.Service_chrg,c2.Std_rate,c2.P_To_P,c2.exposure_lim,c2.demat_tableno,c2.BankId,c2.CltDpNo,c2.Printf,c2.ALBMDelchrg,
		c2.ALBMDelivery,c2.AlbmCF_tableno,c2.MF_tableno,c2.SB_tableno,c2.brok1_tableno,c2.brok2_tableno,c2.brok3_tableno,c2.BrokerNote,
		c2.Other_chrg,c2.brok_scheme,c2.Contcharge,c2.MinContAmt,c2.AddLedgerBal,c2.Dummy1,c2.Dummy2,c2.InsCont,c2.SerTaxMethod,c2.Dummy6,
		c2.Dummy7,c2.Dummy8,c2.Dummy9,c2.Dummy10,c2.PARENTCODE,c2.Productcode
	from 
		AngelNseCM.msajag.dbo.client2 c2 with(nolock),
		mimansa_tbl_ucc_nse_cm_trade_modification_process t with (nolock)
	where 
		c2.party_code = t.party_code
	
	insert into
		mimansa_angel_ucc_nse_cm_client5_modification_process
	select 
		party_code = ltrim(rtrim(t.party_code)),
		c5.cl_code,c5.BirthDate,c5.Sex,c5.ActiveFrom,c5.InteractMode,c5.RepatriatAC,c5.RepatriatBank,c5.RepatriatACNO,c5.Introducer,
		c5.Approver,c5.KYCForm,c5.BankCert,c5.Passport,c5.Passportdtl,c5.VotersID,c5.VotersIDdtl,c5.ITReturn,c5.ITReturndtl,
		c5.Drivelicen,c5.Drivelicendtl,c5.Rationcard,c5.Rationcarddtl,c5.Corpdtlrecd,c5.Corpdeed,c5.Anualreport,c5.Networthcert,
		c5.InactiveFrom,c5.P_Address1,c5.P_Address2,c5.P_Address3,c5.P_City,c5.P_State,c5.P_Nation,c5.P_Phone,c5.P_Zip,c5.addemailid,
		c5.PassportDateOfIssue,c5.PassportPlaceOfIssue,c5.VoterIdDateOfIssue,c5.VoterIdPlaceOfIssue,c5.ITReturnDateOfFiling,c5.LicenceNoDateOfIssue,
		c5.LicenceNoPlaceOfIssue,c5.RationCardDateOfIssue,c5.RationCardPlaceOfIssue,c5.Client_Agre_Dt,c5.Regr_No,c5.Regr_Place,c5.Regr_Date,
		c5.Regr_Auth,c5.Introd_Client_Id,c5.Introd_Relation,c5.Any_Other_Acc,c5.Sett_Mode,c5.Dealing_With_Othrer_Tm,c5.Systumdate,c5.Passportexpdate,
		c5.Driveexpdate
	from 
		AngelNseCM.msajag.dbo.client5 c5 with(nolock),
		mimansa_angel_ucc_nse_cm_client2_modification_process t with (nolock)
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
		mimansa_tbl_ucc_nse_cm_trade_modification_process t with (nolock),
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
		mimansa_tbl_ucc_nse_cm_trade_modification_process t with (nolock),
		AngelNseCM.msajag.dbo.client4 c4 with(nolock),
		AngelNseCM.msajag.dbo.bank b with(nolock)
	where
		t.party_code = c4.party_code and
		c4.bankid = b.bankid and
		isnull(c4.depository, '') in ('CDSL', 'NSDL') and
		isnull(c4.defdp, '') = '1'

	insert into
		mimansa_angel_ucc_nse_cm_client_bank_modification_process
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
	from
		#pobank po full outer join #bank b on ltrim(rtrim(po.party_code)) = ltrim(rtrim(b.party_code))
	order by
		ltrim(rtrim(case when po.party_code is null then b.party_code else po.party_code end))


	/*******************END - FETCH DATA**************************/

	insert into
		mimansa_angel_ucc_nse_cm_client_data_modification_process
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
		client_name = left(ltrim(rtrim(isnull(c1_b.long_name, ''))), 150),

		category =
			case
				/*INDIVIDUAL/PROPRIETORSHIP FIRMS*/
				when ltrim(rtrim(isnull(c1_b.cl_status, ''))) = 'IND' then '1'		/*INDIVIDUAL*/

				/*PARTNERSHIP FIRM*/
				when ltrim(rtrim(isnull(c1_b.cl_status, ''))) = 'PF' then '2'		/*PARTNERSHIP FIRMS*/

				/*HUF*/
				when ltrim(rtrim(isnull(c1_b.cl_status, ''))) = 'HUF' then '3'		/*HINDU UNDIVIDED FAMILY*/

				/*PUBLIC & PRIVATE COMPANIES / BODIES CORPORATE*/
				when ltrim(rtrim(isnull(c1_b.cl_status, ''))) = 'PPB' then '4'		/*PUB. PVT COMP/BODIES CORP*/
				when ltrim(rtrim(isnull(c1_b.cl_status, ''))) = 'BCP' then '4'		/*BODY CORPORATE*/

				/*TRUST / SOCIETY*/
				when ltrim(rtrim(isnull(c1_b.cl_status, ''))) = 'TS' then ' 5'		/*TRUST / SOCIETY*/

				/*MUTUAL FUND*/
				when ltrim(rtrim(isnull(c1_b.cl_status, ''))) = 'MF' then ' 6'		/*MUTUAL FUNDS*/
				when ltrim(rtrim(isnull(c1_b.cl_status, ''))) = 'MFF' then '6'		/*MUTUAL FUND (MF)*/

				/*DOMESTIC FINANCIAL INSTITUTIONS (OTHER THAN BANKS & INSURANCE)*/
				when ltrim(rtrim(isnull(c1_b.cl_status, ''))) = 'IFI' then '7'		/*INDIAN FINANCIAL INSTI*/
				when ltrim(rtrim(isnull(c1_b.cl_status, ''))) = 'DFI' then '7'		/*DOMESTIC FIN. INST.*/

				/*BANK*/
				when ltrim(rtrim(isnull(c1_b.cl_status, ''))) = 'BA' then ' 8'		/*BANKS*/
				when ltrim(rtrim(isnull(c1_b.cl_status, ''))) = 'BNK' then '8'		/*BANK*/

				/*INSURANCE*/
				when ltrim(rtrim(isnull(c1_b.cl_status, ''))) = 'IC' then ' 9'		/*INSURANCE COMPANIES*/

				/*STATUTORY BODIES*/
				when ltrim(rtrim(isnull(c1_b.cl_status, ''))) = 'SB' then ' 10'		/*STATUTORY BODIES*/

				/*NRI*/
				when ltrim(rtrim(isnull(c1_b.cl_status, ''))) = 'NRI' then '11'		/*NON RESIDENT INDIAN*/

				/*FII*/
				when ltrim(rtrim(isnull(c1_b.cl_status, ''))) = 'FII' then '12'		/*FOREIGN INSTIT INVESTORS*/

				/*OCB*/
				when ltrim(rtrim(isnull(c1_b.cl_status, ''))) = 'OCB' then '13'		/*OVERSEAS CORPORATE BODIES*/

				/*FOREIGN DIRECT INVESTMENTS (FDI) / FOREIGN VENTURE CAPITAL FUNDS (VC)*/
				when ltrim(rtrim(isnull(c1_b.cl_status, ''))) = 'DFN' then '14'		/*DIRECT FOREIGN INVESTMENTS*/
				when ltrim(rtrim(isnull(c1_b.cl_status, ''))) = 'FVC' then '14'		/*FOREIGN VENTURE CAPITAL FUNDS*/
			else
				'1'		/*INDIVIDUAL*/
			end,

		pan =
			dbo.fn_validate_pan (pan_gir_no, 'NA'),
		client_email_id = left(ltrim(rtrim(isnull(email, ''))), 60),
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

		client_address_2 =  '',
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
				case when 
					isnumeric( 
						replace( 
							replace( 
								replace( 
									replace( 
										replace( 
											case 
												when len(ltrim(rtrim(isnull(c1_b.res_phone1, '')))) > 0 then ltrim(rtrim(isnull(c1_b.res_phone1, '')))
												when len(ltrim(rtrim(isnull(c1_b.res_phone2, '')))) > 0 then ltrim(rtrim(isnull(c1_b.res_phone2, '')))
												when len(ltrim(rtrim(isnull(c1_b.off_phone1, '')))) > 0 then ltrim(rtrim(isnull(c1_b.off_phone1, '')))
												when len(ltrim(rtrim(isnull(c1_b.off_phone2, '')))) > 0 then ltrim(rtrim(isnull(c1_b.off_phone2, '')))
											else 
												'' 
											end, 
											space(1), 
											'' 
										), 
										'-', 
										'' 
									), 
									'/', 
									'' 
								), 
								'(', 
								'' 
							), 
							'(', 
							'' 
						) 
					) = 1 
					then 
						replace( 
							replace( 
								replace( 
									replace( 
										replace( 
											case 
												when len(ltrim(rtrim(isnull(c1_b.res_phone1, '')))) > 0 then ltrim(rtrim(isnull(c1_b.res_phone1, '')))
												when len(ltrim(rtrim(isnull(c1_b.res_phone2, '')))) > 0 then ltrim(rtrim(isnull(c1_b.res_phone2, '')))
												when len(ltrim(rtrim(isnull(c1_b.off_phone1, '')))) > 0 then ltrim(rtrim(isnull(c1_b.off_phone1, '')))
												when len(ltrim(rtrim(isnull(c1_b.off_phone2, '')))) > 0 then ltrim(rtrim(isnull(c1_b.off_phone2, '')))
											else 
												'' 
											end, 
											space(1), 
											'' 
										), 
										'-', 
										'' 
									), 
									'/', 
									'' 
								), 
								'(', 
								'' 
							), 
							'(', 
							''
						) 
					else 
--						'9999999'
						''
					end, 60
			),
		mobile_number =
			left(
				case when 
					isnumeric( 
						replace( 
							replace( 
								replace( 
									replace( 
										replace( 
											case 
												when len(ltrim(rtrim(isnull(c1_b.mobile_pager, '')))) > 0 then ltrim(rtrim(isnull(c1_b.mobile_pager, '')))
											else 
												'' 
											end, 
											space(1), 
											'' 
										), 
										'-', 
										'' 
									), 
									'/', 
									'' 
								), 
								'(', 
								'' 
							), 
							'(', 
							'' 
						) 
					) = 1 
					then 
						replace( 
							replace( 
								replace( 
									replace( 
										replace( 
											case 
												when len(ltrim(rtrim(isnull(c1_b.mobile_pager, '')))) > 0 then ltrim(rtrim(isnull(c1_b.mobile_pager, '')))
											else 
												'' 
											end, 
											space(1), 
											'' 
										), 
										'-', 
										'' 
									), 
									'/', 
									'' 
								), 
								'(', 
								'' 
							), 
							'(', 
							''
						) 
					else 
--						'9999999999'
						''
					end, 10
			),
		date_of_birth_incorporation = '',
		client_agreement_date = '',
		registration_no_of_client = '',
		registering_authority = '',
		place_of_registration = '',
		date_of_registration = '',
		bank_name ='' ,
		bank_branch_address = '',
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

	from
		(
			select
				c1.*,
				b.bank_name, b.bank_address, b.bank_account_type, b.bank_account_no, b.dp_id, b.dp_name, b.depository_participant, b.demat_id_of_client
			from
				mimansa_angel_ucc_nse_cm_client1_modification_process c1 with (nolock)
					left outer join
				mimansa_angel_ucc_nse_cm_client_bank_modification_process b with (nolock)
					on ltrim(rtrim(c1.party_code)) = ltrim(rtrim(b.party_code))
		) c1_b,
		mimansa_angel_ucc_nse_cm_client2_modification_process c2 with (nolock),
		mimansa_angel_ucc_nse_cm_client5_modification_process c5 with (nolock)

	where
		ltrim(rtrim(c1_b.party_code)) = ltrim(rtrim(c2.party_code)) and
		ltrim(rtrim(c2.party_code)) = ltrim(rtrim(c5.party_code)) and
		ltrim(rtrim(left(c2.party_code,2))) <> '98'

	update
		mimansa_angel_ucc_nse_cm_client_data_modification_process
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
		mimansa_angel_ucc_nse_cm_client_data_modification_process
	set
		UPDATIONFLAG=isnull(c1.UPDATIONFLAG,''),
	    --RELATIONSHIP=ISNULL(c1.RELATIONSHIP,''),
	    RELATIONSHIP=c1.RELATIONSHIP,
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
		mimansa_angel_ucc_nse_cm_client_data_modification_process
	set
		mimansa_angel_ucc_nse_cm_client_data_modification_process.cin=isnull(c1.cin,'')
	from
		AngelNseCM.msajag.dbo.CLIENT_MASTER_NOMINEE_DATA c1 with(nolock)
	where
		client_code = party_code
		and len(isnull(client_code, '')) > 0
		and len(isnull(party_code, '')) > 0	
		and mimansa_angel_ucc_nse_cm_client_data_modification_process.category=4	

	set nocount off

GO
