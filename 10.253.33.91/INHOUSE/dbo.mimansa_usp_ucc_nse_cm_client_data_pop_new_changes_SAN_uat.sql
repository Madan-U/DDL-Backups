-- Object: PROCEDURE dbo.mimansa_usp_ucc_nse_cm_client_data_pop_new_changes_SAN_uat
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------


  
  
CREATE proc  
  
 [dbo].[mimansa_usp_ucc_nse_cm_client_data_pop_new_changes_SAN_uat]  
 (  
 @from_date varchar(20),  
 @to_date varchar(20),  
 @ClientCode varchar(20),  
 --@selected_clients_only char(1),  
 @processid varchar(50)  
 )  
  
as  
--exec [mimansa_usp_ucc_nse_cm_client_data_pop_new_changes_SAN] 'Mar 21 2014','Mar 22 2014','',''  
 set nocount on  
  
 /*Parameter Vertualization*/  
 Declare @@FromDate datetime,@@ToDate datetime,@@getdate datetime,  
   @@FromClientCode varchar(20),@@ToClientCode varchar(20)  
  
/*Initialized Parameters*/  
 if isnull(@from_date,'')='' or isnull(@to_date,'')=''  
 begin  
  set @@FromDate='Jan  1 1900'  
  set @@ToDate='Dec 31 2078'  
 end  
 else  
 begin  
  set @@FromDate=@from_date  
  set @@ToDate=@to_date+' 23:59'  
 end  
  
 if isnull(@ClientCode,'')=''  
 begin  
  set @@FromClientCode='A'  
  set @@ToClientCode='ZZZZZZZZZZ'  
 end  
 else  
 begin  
  set @@FromClientCode=@ClientCode  
  set @@ToClientCode=@ClientCode  
 end  
  
 set @@getdate=left(getdate(),11)+' 23:59'  
  
create table #TempClient (party_code varchar(20))  
  
if isnull(@processid,'')=''  
begin  
 print 'DATARANGE'  
  insert into #TempClient  
  select distinct cl_code = ltrim(rtrim(isnull(cl_code, '')))  
  from AngelNseCM.msajag.dbo.client5 c5 with(nolock)  
  where cl_code>=@@FromClientCode  
    and cl_code<=@@ToClientCode   
    and c5.inactivefrom >@@getdate /*>=@@FromDate Change on 16 Apr 2014, UCC reporting from Offline to Online (Futures / Currency / Commodity Segments)*/  
    and activefrom >= @@FromDate  
    and activefrom <= @@ToDate    
  
end  
else  
begin  
 print 'SELECTED'  
  insert into #TempClient  
  select distinct cl_code = ltrim(rtrim(isnull(cl_code, '')))  
  from AngelNseCM.msajag.dbo.client5 c5 with(nolock),tblUCCClientCode A with(nolock)  
  where c5.cl_code=A.party_code  
    and c5.cl_code>=@@FromClientCode  
    and c5.cl_code<=@@ToClientCode  
    and A.processid=@processid     
  
  /*Delete selected clients*/   
  delete from tblUCCClientCode where processid=@processid   
end  
  
  
 /*******************FETCH DATA**************************/  
  
 --truncate table mimansa_angel_ucc_nse_cm_client_data_new_changes  
  
  
  
  
 select  
  --party_code=ltrim(rtrim(c2.party_code)), --Commented by Arjun Singh on Dec 14 2018 on Mail of KYC/UCC Team  
  party_code=ltrim(rtrim(upper(c2.party_code))), -- Change to upper by Arjun Singh on Dec 14 2018 on Mail of KYC/UCC Team  
  Cl_Code=ltrim(rtrim(isnull(c1.Cl_Code,''))),  
  Short_Name=ltrim(rtrim(isnull(Short_Name,''))),  
  --Long_Name=ltrim(rtrim(c1.Long_Name)), --Commented by Arjun Singh on Dec 14 2018 on Mail of KYC/UCC Team  
  Long_Name=ltrim(rtrim(upper(c1.addemailid))), -- Added PAN Name by Arjun Singh on Dec 14 2018 on Mail of KYC/UCC Team  
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
  Email=ltrim(rtrim(isnull(Email,''))),  
  Cl_type=ltrim(rtrim(isnull(Cl_type,''))),  
  Cl_Status=ltrim(rtrim(isnull(Cl_Status,''))),  
  Mobile_Pager=dbo.strip_non_digit(ltrim(rtrim(isnull(Mobile_Pager,'')))),  
  P_address1=ltrim(rtrim(isnull(P_address1,''))),  
  P_address2=ltrim(rtrim(isnull(P_address2,''))),  
  P_address3=ltrim(rtrim(isnull(P_address3,''))),  
  P_City=dbo.strip_non_alpha(ltrim(rtrim(isnull(P_City,'')))),  
  --P_State=dbo.strip_non_alpha(ltrim(rtrim(isnull(P_State,'')))),  
  P_State=dbo.strip_non_alpha_without_space(ltrim(rtrim(isnull(P_State,'')))), --changed by ritesh on 7 jul 2014   
  P_State_For_Other=dbo.strip_non_alpha(ltrim(rtrim(isnull(P_State,'')))),  
  P_nation=dbo.strip_non_alpha(ltrim(rtrim(isnull(P_nation,'')))),  
  P_zip=replace(ltrim(rtrim(isnull(P_zip,''))), ' ', ''),  
  P_Len=case when len(P_address1)>0 and len(P_address2)>0 and len(P_address3)>0 and len(P_City)>0 and len(P_State)>0 and len(P_nation)>0 and len(P_zip)>0  
     then 'N' else 'Y' end ,  
  pan_gir_no=ltrim(rtrim(isnull(c1.pan_gir_no,''))),  
  Gender=ltrim(rtrim(isnull(sex,'')))  
 into #temp_Client1   
 from   
  --AngelNseCM.msajag.dbo.client1 c1 with(nolock),  
  msajag.dbo.Client_Details c1 with(nolock),  
  AngelNseCM.msajag.dbo.client2 c2 with(nolock),  
  #TempClient t with (nolock)  
 where   
  c1.cl_code = c2.cl_code and   
  c2.party_code = t.party_code   
  
   update #temp_Client1 set Email='notprovided@notprovided.com' where Email=''  
   
 update   
  #temp_Client1   
 set   
 L_State= dbo.fn_state_countary_value(l_state,'STATE'),  
 P_State=dbo.fn_state_countary_value(P_state,'STATE'),  
 L_nation=dbo.fn_state_countary_value(L_Nation,'NATION'),  
 P_Nation=dbo.fn_state_countary_value(P_Nation,'NATION'),  
 cl_status=case  
    /*INDIVIDUAL/PROPRIETORSHIP FIRMS*/  
    when cl_status = 'IND' then '1'  /*INDIVIDUAL*/  
  
    /*PARTNERSHIP FIRM*/  
    when cl_status = 'PF' or cl_status='LLP' then '2'  /*PARTNERSHIP FIRMS*/  
  
    /*HUF*/  
    when cl_status = 'HUF' then '3'  /*HINDU UNDIVIDED FAMILY*/  
  
    /*PUBLIC & PRIVATE COMPANIES / BODIES CORPORATE*/  
    when cl_status = 'PPB' then '4'  /*PUB. PVT COMP/BODIES CORP*/  
    when cl_status = 'BCP' then '4'  /*BODY CORPORATE*/  
  
    /*TRUST / SOCIETY*/  
    when cl_status = 'TS' then '5'  /*TRUST / SOCIETY*/  
  
    /*MUTUAL FUND*/  
    when cl_status = 'MF' then '6'  /*MUTUAL FUNDS*/  
    when cl_status = 'MFF' then '6'  /*MUTUAL FUND (MF)*/  
  
    /*DOMESTIC FINANCIAL INSTITUTIONS (OTHER THAN BANKS & INSURANCE)*/  
    when cl_status = 'IFI' then '7'  /*INDIAN FINANCIAL INSTI*/  
    when cl_status = 'DFI' then '7'  /*DOMESTIC FIN. INST.*/  
  
    /*BANK*/  
    when cl_status = 'BA' then ' 8'  /*BANKS*/  
    when cl_status = 'BNK' then '8'  /*BANK*/  
  
    /*INSURANCE*/  
    when cl_status = 'IC' then ' 9'  /*INSURANCE COMPANIES*/  
  
    /*STATUTORY BODIES*/  
    when cl_status = 'SB' then ' 10'  /*STATUTORY BODIES*/  
  
    /*NRI*/  
    when cl_status = 'NRI' or cl_status='NRE' or cl_status='NRO' then '11'  /*NON RESIDENT INDIAN*/  
  
    /*FII*/  
    when cl_status = 'FII' then '12'  /*FOREIGN INSTIT INVESTORS*/  
  
    /*OCB*/  
    when cl_status = 'OCB' then '13'  /*OVERSEAS CORPORATE BODIES*/  
  
    /*FOREIGN DIRECT INVESTMENTS (FDI) / FOREIGN VENTURE CAPITAL FUNDS (VC)*/  
    when cl_status = 'DFN' then '14'  /*DIRECT FOREIGN INVESTMENTS*/  
  
    when cl_status = 'QFI' then '17'       /*Qualified foreign investors*/  
      
    /*FVC*/  
    when cl_status = 'FVC' then '20'  /*FOREIGN VENTURE CAPITAL FUNDS*/  
   else  
    '1'  /*INDIVIDUAL*/  
   end  
  
    
  
  
 /*insert into  
  angel_ucc_nse_cm_client2*/  
 select   
  --c2.*  
  cl_code,party_code=c2.party_code  
 into #temp_Client2   
 from   
  AngelNseCM.msajag.dbo.client2 c2 with(nolock),  
  #TempClient t with (nolock)  
 where   
  c2.party_code = t.party_code  
   
 /*insert into  
  angel_ucc_nse_cm_client5*/  
 select   
  party_code = ltrim(rtrim(t.party_code)),  
  --c5.*  
  cl_code=ltrim(rtrim(isnull(c5.cl_code,''))),  
  --BirthDate=ltrim(rtrim(isnull(c5.BirthDate,''))),  
  BirthDate=upper(ltrim(rtrim(isnull(replace(convert(varchar(11), c5.Birthdate, 113),' ','-'),'')))),  
  ActiveFrom=ltrim(rtrim(isnull(c5.ActiveFrom,''))),InactiveFrom=ltrim(rtrim(isnull(c5.InactiveFrom,''))),  
  GrossAnnualIncomeasonDate=upper(ltrim(rtrim(isnull(replace(convert(varchar(11), c5.ActiveFrom, 113),' ','-'),''))))  
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
  bank_address =ltrim(rtrim(isnull(b.branch_name, ''))) + ltrim(rtrim(isnull(b.address1, ''))) + space(1) + ltrim(rtrim(isnull(b.address2, ''))) + space(1) + ltrim(rtrim(isnull(b.city, ''))) + space(1) + ltrim(rtrim(isnull(b.state, ''))) + space(1) + ltrim(rtrim(isnull(b.nation, ''))),  
  account_type = ltrim(rtrim(c4.depository)),  
  account_no = ltrim(rtrim(c4.cltdpid))  
 into  
  #pobank  
 from  
  #TempClient t with (nolock),  
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
  #TempClient t with (nolock),  
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
    
 --update #temp_client_bank set    
 -- dp_name = Depository,  
 -- depository_participant = Depository_Name,  
 -- demat_id_of_client = a1.dp_id  
 -- from Temp_dp_id_data a1 where a1.party_code =  #temp_client_bank.party_code  
   
 update   
  #temp_client_bank   
 set    
  dp_name = 'CDSL',  
  dp_id='12033200',  
  depository_participant = 'ANGEL BROKING LTD',  
  demat_id_of_client = a1.CDSL_Client_Code  
 from   
  --[196.1.115.199].synergy.dbo.VW_EXP_NEWCLIENT_POA a1 --commend because resource is changed on 31 Oct 2015 by ravi  
  AGMUBODPL3.DMAT.citrus_usr.VW_EXP_NEWCLIENT_POA a1   
  
 where  
  a1.nise_party_code =  #temp_client_bank.party_code  
  and LEN(demat_id_of_client)=0  
  
  
 /*******************END - FETCH DATA**************************/  
   
CREATE TABLE #mimansa_angel_ucc_nse_cm_client_data_new_changes(  
 [Segment] [varchar](1) NULL,  
 [Client_Code] [varchar](10) NULL,  
 [Client_Name] [varchar](150) NULL,  
 [Category] [varchar](10) NULL,  
 [PAN] [varchar](10) NULL,  
 [Gender] [varchar](2) NULL,  
 [Fathers_Husbands_GuardiansName] [varchar](150) NULL,  
 [Maritalstatus] [varchar](2) NULL,  
 [Nationality] [varchar](2) NULL,  
 [Nationality_Other] [varchar](50) NULL,  
 [ClientEmailId] [varchar](60) NULL,  
 [CorrespondenceClientAddressline1] [varchar](255) NULL,  
 [CorrespondenceClientAddressline2] [varchar](255) NULL,  
 [CorrespondenceClientAddressline3] [varchar](255) NULL,  
 [CorrespondenceClientAddress_City] [varchar](50) NULL,  
 [CorrespondenceClientAddress_State] [varchar](2) NULL,  
 [CorrespondenceClientAddress_State_Others] [varchar](75) NULL,  
 [CorrespondenceClientAddress_Country] [varchar](3) NULL,  
 [CorrespondenceClientAddress_Pincode] [varchar](10) NULL,  
 [FlagIndicatingifCorrespondenceAddressissameasPermanentAddress] [varchar](1) NULL,  
 [PermanentClientAddressline1] [varchar](255) NULL,  
 [PermanentClientAddressline2] [varchar](255) NULL,  
 [PermanentClientAddressline3] [varchar](255) NULL,  
 [PermanentClientAddress_City] [varchar](50) NULL,  
 [PermanentClientAddress_State] [varchar](2) NULL,  
 [PermanentClientAddress_StateOthers] [varchar](75) NULL,  
 [PermanentClientAddress_Country] [varchar](3) NULL,  
 [PermanentClientAddress_Pincode] [varchar](10) NULL,  
 [ISDcode_Residence] [varchar](10) NULL,  
 [STDcode_Residence] [varchar](10) NULL,  
 [TelephoneNumber_Residence] [varchar](60) NULL,  
 [Mobilenumber] [varchar](20) NULL,  
 [ISDcode_Office] [varchar](10) NULL,  
 [STDcode_Office] [varchar](10) NULL,  
 [TelephoneNumber_Office] [varchar](60) NULL,  
 [DateofBirth_Incorporation] [varchar](60) NULL,  
 [UIDNUMBER] [varchar](12) NULL,  
 [BankName1] [varchar](60) NULL,  
 [BankBranchAddress1] [varchar](255) NULL,  
 [BankAccountNo1] [varchar](25) NULL,  
 [BankAccountType1] [varchar](2) NULL,  
 [BankName2] [varchar](60) NULL,  
 [BankBranchAddress2] [varchar](255) NULL,  
 [BankAccountNo2] [varchar](25) NULL,  
 [BankAccountType2] [varchar](2) NULL,  
 [BankName3] [varchar](60) NULL,  
 [BankBranchAddress3] [varchar](255) NULL,  
 [BankAccountNo3] [varchar](25) NULL,  
 [BankAccountType3] [varchar](2) NULL,  
 [DepositoryName1] [varchar](4) NULL,  
 [DepositoryID1] [varchar](8) NULL,  
 [BeneficialOwnerAccountNo1] [varchar](16) NULL,  
 [DepositoryName2] [varchar](4) NULL,  
 [DepositoryID2] [varchar](8) NULL,  
 [BeneficialOwnerAccountNo2] [varchar](16) NULL,  
 [DepositoryName3] [varchar](4) NULL,  
 [DepositoryID3] [varchar](8) NULL,  
 [BeneficialOwnerAccountNo3] [varchar](16) NULL,  
 [CorporateIdentitynumber_CIN] [varchar](21) NULL,  
 [GrossAnnualIncomeRange] [varchar](40) NULL,  
 [GrossAnnualIncomeasonDate] [varchar](40) NULL,  
 [NetWorth_InRs] [varchar](40) NULL,  
 [NetWorthasonDate] [varchar](40) NULL,  
 [PoliticallyExposedPerson_PEP] [varchar](2) NULL,  
 [PlaceofIncorporation] [varchar](75) NULL,  
 [Occupation] [varchar](2) NULL,  
 [OccupationDetails_Forothers] [varchar](75) NULL,  
 [Dateofcommencementofbusiness] [varchar](40) NULL,  
 [CustodialParticipantCodeoftheclient] [varchar](15) NULL,  
 [RegistrationNoofClient] [varchar](25) NULL,  
 [RegisteringAuthority] [varchar](60) NULL,  
 [PlaceofRegistration] [varchar](25) NULL,  
 [DateofRegistration] [varchar](40) NULL,  
 [InpersonVerification] [varchar](1) NULL,  
 [ClientAgreementDate] [varchar](40) NULL,  
 [UniqueClientCodeallottedbyNSCCL_BSE] [varchar](10) NULL,  
 [UpdationFlag_for_SMS_and_Email_facility] [varchar](1) NULL,  
 [Relationship] [varchar](1) NULL,  
 [TypeofFacility_for_SMS_and_Email_facility] [varchar](1) NULL,  
 [ProofType] [varchar](1) NULL,  
 [ProofNumber] [varchar](25) NULL,  
 [IssuePlaceofProof] [varchar](100) NULL,  
 [IssueDateofProof] [varchar](40) NULL,  
 [ClientStatus] [varchar](1) NULL,  
 [Remarks] [varchar](200) NULL,  
 [ClientType_Corporate] [varchar](200) NULL,  
 [NameofcontactPerson_1] [varchar](200) NULL,  
 [DesignationofContactPerson_1] [varchar](200) NULL,  
 [PANofcontactPerson_1] [varchar](200) NULL,  
 [AddressofcontactPerson_1] [varchar](200) NULL,  
 [ContactdetailsofcontactPerson_1] [varchar](200) NULL,  
 [DINofcontactPerson_1] [varchar](200) NULL,  
 [UIDofcontactPerson_1] [varchar](200) NULL,  
 [EmailIdofcontactPerson_1] [varchar](200) NULL,  
 [NameofcontactPerson_2] [varchar](200) NULL,  
 [DesignationofcontactPerson_2] [varchar](200) NULL,  
 [PANofcontactPerson_2] [varchar](200) NULL,  
 [AddressofcontactPerson_2] [varchar](200) NULL,  
 [ContactdetailsofcontactPerson_2] [varchar](200) NULL,  
 [DINofcontactPerson_2] [varchar](200) NULL,  
 [UIDofcontactPerson_2] [varchar](200) NULL,  
 [EmailIdofcontactPerson_2] [varchar](200) NULL,  
 [NameofcontactPerson_3] [varchar](200) NULL,  
 [DesignationofcontactPerson_3] [varchar](200) NULL,  
 [PANofcontactPerson_3] [varchar](200) NULL,  
 [AddressofcontactPerson_3] [varchar](200) NULL,  
 [ContactdetailsofcontactPerson_3] [varchar](200) NULL,  
 [DINofcontactPerson_3] [varchar](200) NULL,  
 [UIDofcontactPerson_3] [varchar](200) NULL,  
 [EmailIdofcontactPerson_3] [varchar](200) NULL,  
 [NameofcontactPerson_4] [varchar](200) NULL,  
 [DesignationofcontactPerson_4] [varchar](200) NULL,  
 [PANofcontactPerson_4] [varchar](200) NULL,  
 [AddressofcontactPerson_4] [varchar](200) NULL,  
 [ContactdetailsofcontactPerson_4] [varchar](200) NULL,  
 [DINofcontactPerson_4] [varchar](200) NULL,  
 [UIDofcontactPerson_4] [varchar](200) NULL,  
 [EmailIdofcontactPerson_4] [varchar](200) NULL,  
 [NameofcontactPerson_5] [varchar](200) NULL,  
 [DesignationofcontactPerson_5] [varchar](200) NULL,  
 [PANofcontactPerson_5] [varchar](200) NULL,  
 [AddressofcontactPerson_5] [varchar](200) NULL,  
 [ContactdetailsofcontactPerson_5] [varchar](200) NULL,  
 [DINofcontactPerson_5] [varchar](200) NULL,  
 [UIDofcontactPerson_5] [varchar](200) NULL,  
 [EmailIdofcontactPerson_5] [varchar](200) NULL,  
 [NameofcontactPerson_6] [varchar](200) NULL,  
 [DesignationofcontactPerson_6] [varchar](200) NULL,  
 [PANofcontactPerson_6] [varchar](200) NULL,  
 [AddressofcontactPerson_6] [varchar](200) NULL,  
 [ContactdetailsofcontactPerson_6] [varchar](200) NULL,  
 [DINofcontactPerson_6] [varchar](200) NULL,  
 [UIDofcontactPerson_6] [varchar](200) NULL,  
 [EmailIdofcontactPerson_6] [varchar](200) NULL,  
 [NameofcontactPerson_7] [varchar](200) NULL,  
 [DesignationofcontactPerson_7] [varchar](200) NULL,  
 [PANofcontactPerson_7] [varchar](200) NULL,  
 [AddressofcontactPerson_7] [varchar](200) NULL,  
 [ContactdetailsofcontactPerson_7] [varchar](200) NULL,  
 [DINofcontactPerson_7] [varchar](200) NULL,  
 [UIDofcontactPerson_7] [varchar](200) NULL,  
 [EmailIdofcontactPerson_7] [varchar](200) NULL,  
 [NameofcontactPerson_8] [varchar](200) NULL,  
 [DesignationofcontactPerson_8] [varchar](200) NULL,  
 [PANofcontactPerson_8] [varchar](200) NULL,  
 [AddressofcontactPerson_8] [varchar](200) NULL,  
 [ContactdetailsofcontactPerson_8] [varchar](200) NULL,  
 [DINofcontactPerson_8] [varchar](200) NULL,  
 [UIDofcontactPerson_8] [varchar](200) NULL,  
 [EmailIdofcontactPerson_8] [varchar](200) NULL,  
 [NameofcontactPerson_9] [varchar](200) NULL,  
 [DesignationofcontactPerson_9] [varchar](200) NULL,  
 [PANofcontactPerson_9] [varchar](200) NULL,  
 [AddressofcontactPerson_9] [varchar](200) NULL,  
 [ContactdetailsofcontactPerson_9] [varchar](200) NULL,  
 [DINofcontactPerson_9] [varchar](200) NULL,  
 [UIDofcontactPerson_9] [varchar](200) NULL,  
 [EmailIdofcontactPerson_9] [varchar](200) NULL,  
 [NameofcontactPerson_10] [varchar](200) NULL,  
 [DesignationofcontactPerson_10] [varchar](200) NULL,  
 [PANofcontactPerson_10] [varchar](200) NULL,  
 [AddressofcontactPerson_10] [varchar](200) NULL,  
 [ContactdetailsofcontactPerson_10] [varchar](200) NULL,  
 [DINofcontactPerson_10] [varchar](200) NULL,  
 [UIDofcontactPerson_10] [varchar](200) NULL,  
 [EmailIdofcontactPerson_10] [varchar](200) NULL,  
 [NameofcontactPerson_11] [varchar](200) NULL,  
 [DesignationofcontactPerson_11] [varchar](200) NULL,  
 [PANofcontactPerson_11] [varchar](200) NULL,  
 [AddressofcontactPerson_11] [varchar](200) NULL,  
 [ContactdetailsofcontactPerson_11] [varchar](200) NULL,  
 [DINofcontactPerson_11] [varchar](200) NULL,  
 [UIDofcontactPerson_11] [varchar](200) NULL,  
 [EmailIdofcontactPerson_11] [varchar](200) NULL,  
 [NameofcontactPerson_12] [varchar](200) NULL,  
 [DesignationofcontactPerson_12] [varchar](200) NULL,  
 [PANofcontactPerson_12] [varchar](200) NULL,  
 [AddressofcontactPerson_12] [varchar](200) NULL,  
 [ContactdetailsofcontactPerson_12] [varchar](200) NULL,  
 [DINofcontactPerson_12] [varchar](200) NULL,  
 [UIDofcontactPerson_12] [varchar](200) NULL,  
 [EmailIdofcontactPerson_12] [varchar](200) NULL,  
 [NameofcontactPerson_13] [varchar](200) NULL,  
 [DesignationofcontactPerson_13] [varchar](200) NULL,  
 [PANofcontactPerson_13] [varchar](200) NULL,  
 [AddressofcontactPerson_13] [varchar](200) NULL,  
 [ContactdetailsofcontactPerson_13] [varchar](200) NULL,  
 [DINofcontactPerson_13] [varchar](200) NULL,  
 [UIDofcontactPerson_13] [varchar](200) NULL,  
 [EmailIdofcontactPerson_13] [varchar](200) NULL,  
 [NameofcontactPerson_14] [varchar](200) NULL,  
 [DesignationofcontactPerson_14] [varchar](200) NULL,  
 [PANofcontactPerson_14] [varchar](200) NULL,  
 [AddressofcontactPerson_14] [varchar](200) NULL,  
 [ContactdetailsofcontactPerson_14] [varchar](200) NULL,  
 [DINofcontactPerson_14] [varchar](200) NULL,  
 [UIDofcontactPerson_14] [varchar](200) NULL,  
 [EmailIdofcontactPerson_14] [varchar](200) NULL,  
 [NameofcontactPerson_15] [varchar](200) NULL,  
 [DesignationofcontactPerson_15] [varchar](200) NULL,  
 [PANofcontactPerson_15] [varchar](200) NULL,  
 [AddressofcontactPerson_15] [varchar](200) NULL,  
 [ContactdetailsofcontactPerson_15] [varchar](200) NULL,  
 [DINofcontactPerson_15] [varchar](200) NULL,  
 [UIDofcontactPerson_15] [varchar](200) NULL,  
 [EmailIdofcontactPerson_15] [varchar](200) NULL,  
 [NameofcontactPerson_16] [varchar](200) NULL,  
 [DesignationofcontactPerson_16] [varchar](200) NULL,  
 [PANofcontactPerson_16] [varchar](200) NULL,  
 [AddressofcontactPerson_16] [varchar](200) NULL,  
 [ContactdetailsofcontactPerson_16] [varchar](200) NULL,  
 [DINofcontactPerson_16] [varchar](200) NULL,  
 [UIDofcontactPerson_16] [varchar](200) NULL,  
 [EmailIdofcontactPerson_16] [varchar](200) NULL,  
 [NameofcontactPerson_17] [varchar](200) NULL,  
 [DesignationofcontactPerson_17] [varchar](200) NULL,  
 [PANofcontactPerson_17] [varchar](200) NULL,  
 [AddressofcontactPerson_17] [varchar](200) NULL,  
 [ContactdetailsofcontactPerson_17] [varchar](200) NULL,  
 [DINofcontactPerson_17] [varchar](200) NULL,  
 [UIDofcontactPerson_17] [varchar](200) NULL,  
 [EmailIdofcontactPerson_17] [varchar](200) NULL,  
 [NameofcontactPerson_18] [varchar](200) NULL,  
 [DesignationofcontactPerson_18] [varchar](200) NULL,  
 [PANofcontactPerson_18] [varchar](200) NULL,  
 [AddressofcontactPerson_18] [varchar](200) NULL,  
 [ContactdetailsofcontactPerson_18] [varchar](200) NULL,  
 [DINofcontactPerson_18] [varchar](200) NULL,  
 [UIDofcontactPerson_18] [varchar](200) NULL,  
 [EmailIdofcontactPerson_18] [varchar](200) NULL,  
 [NameofcontactPerson_19] [varchar](200) NULL,  
 [DesignationofcontactPerson_19] [varchar](200) NULL,  
 [PANofcontactPerson_19] [varchar](200) NULL,  
 [AddressofcontactPerson_19] [varchar](200) NULL,  
 [ContactdetailsofcontactPerson_19] [varchar](200) NULL,  
 [DINofcontactPerson_19] [varchar](200) NULL,  
 [UIDofcontactPerson_19] [varchar](200) NULL,  
 [EmailIdofcontactPerson_19] [varchar](200) NULL,  
 [NameofcontactPerson_20] [varchar](200) NULL,  
 [DesignationofcontactPerson_20] [varchar](200) NULL,  
 [PANofcontactPerson_20] [varchar](200) NULL,  
 [AddressofcontactPerson_20] [varchar](200) NULL,  
 [ContactdetailsofcontactPerson_20] [varchar](200) NULL,  
 [DINofcontactPerson_20] [varchar](200) NULL,  
 [UIDofcontactPerson_20] [varchar](200) NULL,  
 [EmailIdofcontactPerson_20] [varchar](200) NULL,  
   
 [POAforFunds] [varchar](1) NULL,  
 [POAforSecurities] [varchar](1) NULL,  
 [Flag] [varchar](1) NULL  
)  
  
  
  
  
  
  
 insert into #mimansa_angel_ucc_nse_cm_client_data_new_changes  
    
 select  
  segment = 'C',  
  client_code = ltrim(rtrim(isnull(c2.party_code, ''))),  
  client_name = left(c1_b.long_name, 150),  
  category =cl_status,  
  pan =dbo.fn_validate_pan (c1_b.pan_gir_no, 'NA'),  
  Gender= (case when cl_status ='3' then '' else ltrim(rtrim(c1_b.Gender)) end),  
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
  end  ,  
  FlagIndicatingifCorrespondenceAddressissameasPermanentAddress=c1_b.P_Len,   
  /*Modify on 30 Apr 2014*/  
  PermanentClientAddressline1 =case when c1_b.P_Len='N' then left(c1_b.P_address1, 255)+' '+left(c1_b.P_address2, 255)+' '+left(c1_b.P_address3, 255) else '' end,   
  PermanentClientAddressline2 ='',  
  PermanentClientAddressline3 ='',  
  /*PermanentClientAddressline1 =case when c1_b.P_Len='N' then left(c1_b.P_address1, 255) else '' end,   
  PermanentClientAddressline2 =case when c1_b.P_Len='N' then left(c1_b.P_address2, 255) else '' end,  
  PermanentClientAddressline3 =case when c1_b.P_Len='N' then left(c1_b.P_address3, 255) else '' end,*/  
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
  STDcode_Residence =(case when len(STDcode_Residence1)>0 then STDcode_Residence1 else '' end), /*Added on 21 Apr 2014: DP will be blank in NSEFO & NSX*/  
    
  --Commneted by prasanna on request of KYC team on 08/02/2014  
      /*case   
       when len(STDcode_Residence1)>0 then STDcode_Residence1  
       when len(STDcode_Residence2)>0 then STDcode_Residence2  
         else '' end,*/   
  TelephoneNumber_Residence = (case when len(STDcode_Residence1)>0 then isnull(c1_b.res_phone1, '') else '' end),  /*Added on 21 Apr 2014: DP will be blank in NSEFO & NSX*/  
    
  --Commneted by prasanna on request of KYC team on 08/02/2014  
   /*left( case   
      when len(isnull(c1_b.res_phone1, '')) > 0 then isnull(c1_b.res_phone1, '')  
      when len(isnull(c1_b.res_phone2, '')) > 0 then isnull(c1_b.res_phone2, '')  
     else   
      ''   
     end  
    , 60  
    ),*/  
  Mobilenumber =left(c1_b.mobile_pager, 10),  
  ISDcode_Office ='',  
  STDcode_Office ='', --Commneted by prasanna on request of KYC team on 08/02/2014  
      /*case   
       when len(STDcode_Office1)>0 then STDcode_Office1  
       when len(STDcode_Office2)>0 then STDcode_Office2  
         else '' end,*/  
  TelephoneNumber_Office='', --Commneted by prasanna on request of KYC team on 08/02/2014  
   /*left( case   
      when len(isnull(c1_b.off_phone1, '')) > 0 then isnull(c1_b.off_phone1, '')  
      when len(isnull(c1_b.off_phone2, '')) > 0 then isnull(c1_b.off_phone2, '')  
     else   
      ''   
     end  
    , 60  
    ),*/  
  DateofBirth_Incorporation = case when c5.BirthDate='01-JAN-1900' then '' else c5.BirthDate end ,  
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
    
  DepositoryName1 =dp_name,  
  DepositoryID1 = case when dp_name='NSDL' then dp_id else '' end,  
  BeneficialOwnerAccountNo1 =demat_id_of_client,  
    
  DepositoryName2 ='',  
  DepositoryID2 ='',  
  BeneficialOwnerAccountNo2 ='',  
  DepositoryName3 ='',  
  DepositoryID3 ='',  
  BeneficialOwnerAccountNo3 ='',  
  CorporateIdentitynumber_CIN='',  
  GrossAnnualIncomeRange ='',  
  GrossAnnualIncomeasonDate =case when c5.GrossAnnualIncomeasonDate='01-JAN-1900' then '' else c5.GrossAnnualIncomeasonDate end ,  
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
  POAforFunds ='N',  
     POAforSecurities='',   
  Flag='E'  
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
  --and c1_b.party_code in (select distinct party_code from Temp_dp_id_data)  
  
 --update  
 -- mimansa_angel_ucc_nse_cm_client_data  
 --set  
 -- client_name = ltrim(rtrim(isnull(addemailid, '')))  
 --from  
 -- AngelNseCM.msajag.dbo.client_details  
 --where  
 -- ltrim(rtrim(client_code)) = ltrim(rtrim(party_code))  
 -- and len(ltrim(rtrim(isnull(client_code, '')))) > 0  
 -- and len(ltrim(rtrim(isnull(party_code, '')))) > 0  
 -- and len(ltrim(rtrim(isnull(addemailid, '')))) > 0  
    
 update  
  #mimansa_angel_ucc_nse_cm_client_data_new_changes  
 set  
  UpdationFlag_for_SMS_and_Email_facility=isnull(c1.UPDATIONFLAG,''),  
     --RELATIONSHIP=ISNULL(c1.RELATIONSHIP,''),  
     RELATIONSHIP='',--Commented by prasanna on 24/12/2013. On mail confirmation of ajay.  
     --MASTERPAN=ISNULL(c1.MASTERPAN,''),  
     TypeofFacility_for_SMS_and_Email_facility=ISNULL(c1.TYPEOFFACILITY,''),  
  --Gender=isnull(c1.Gender,''),  
  Fathers_Husbands_GuardiansName=isnull(c1.FATHERNAME,''),  
  Maritalstatus=  
   case when #mimansa_angel_ucc_nse_cm_client_data_new_changes.category in ('1','11','18') then  
     case   
      when isnull(c1.MARITALSTATUS,'')='01' then 'S'   
      when isnull(c1.MARITALSTATUS,'')='02' then 'M'  
      else 'S'   
     end  
   else  
    ''  
   end   ,  
  Nationality=  
     case when #mimansa_angel_ucc_nse_cm_client_data_new_changes.category in ('1','11','18') then  right(isnull(c1.Nationality,'1'),1) else '' end,   
  NATIONALITY_OTHER=case when isnull(c1.Nationality,'1')=2 then isnull(c1.NATIONALITY_OTHER,'') else '' end,  
  GrossAnnualIncomeRange=case   
     when c1.Gross_Income ='01' then '1'  
     when c1.Gross_Income ='02' then '2'  
     when c1.Gross_Income ='03' then '3'  
     when c1.Gross_Income ='04' then '4'  
     when c1.Gross_Income ='05' then '5'   
     when c1.Gross_Income ='06' then '5'--6 /*Modify on 30 Apr 2014*/  
     when c1.Gross_Income ='07' then '6'--7 /*Modify on 30 Apr 2014*/  
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
  --UIDNUMBER=isnull(c1.AADHAR_UID,''),  
  UIDNUMBER=replace(isnull(rtrim(ltrim(c1.AADHAR_UID)),''),' ',''),  
  /*Added on 21 Apr 2014: As confirm by Ajay*/  
  GrossAnnualIncomeasonDate=(case when upper(replace(convert(varchar,GROSS_DATE,106),' ','-'))='01-JAN-1900' then ''   
         else upper(replace(convert(varchar,GROSS_DATE,106),' ','-')) end)   
 from  
  AngelNseCM.msajag.dbo.CLIENT_MASTER_UCC_DATA c1 with(nolock)  
 where  
  client_code = party_code  
  and len(isnull(client_code, '')) > 0  
  and len(isnull(party_code, '')) > 0   
  
 update   
  #mimansa_angel_ucc_nse_cm_client_data_new_changes   
 set   
  GrossAnnualIncomeasonDate='',  
  NetWorth_InRs='',  
  NetWorthasonDate=''  
 where len(GrossAnnualIncomeRange)=0   
  
 --Added by prasanna on Jun 19 2012 for adding CIN column in Ucc Nsecm file as suggested in circular.    
 update  
  #mimansa_angel_ucc_nse_cm_client_data_new_changes  
 set  
  #mimansa_angel_ucc_nse_cm_client_data_new_changes.CorporateIdentitynumber_CIN=isnull(c1.cin,''),  
  ClientType_Corporate='Y'  
 from  
  AngelNseCM.msajag.dbo.CLIENT_MASTER_NOMINEE_DATA c1 with(nolock)  
 where  
  client_code = party_code  
  and len(isnull(client_code, '')) > 0  
  and len(isnull(party_code, '')) > 0   
  and #mimansa_angel_ucc_nse_cm_client_data_new_changes.category=4   
  
  
 /****ADDRESS 1****/  
 update  
  #mimansa_angel_ucc_nse_cm_client_data_new_changes  
 set  
 NameofcontactPerson_1=c1.contact_name,  
 DesignationofContactPerson_1=c1.designation,  
 PANofcontactPerson_1=c1.PanNo,  
 AddressofcontactPerson_1=isnull(c1.Address1,' ') + ' '+  isnull(c1.Address2,' ') + ' ' +isnull( c1.Address3,' '),  
 ContactdetailsofcontactPerson_1=(case when len(c1.Mobileno)>0 then c1.Mobileno else c1.Phone_no end),  
 DINofcontactPerson_1=c1.DIN,  
 UIDofcontactPerson_1=c1.UID,  
 EmailIdofcontactPerson_1=c1.Email    
 from  
  AngelNseCM.msajag.dbo.client_contact_details c1 with(nolock)  
 where  
  Client_Code = cl_code  
  and c1.designation in  ('DIRECTOR','KARTA','PARTNER','TRUSTEE')  
  and #mimansa_angel_ucc_nse_cm_client_data_new_changes.category in ('2','3','4','5')  
  and line_no='1'  
   
 /****ADDRESS 2****/  
 update  
  #mimansa_angel_ucc_nse_cm_client_data_new_changes  
 set  
 NameofcontactPerson_2=c1.contact_name,  
 DesignationofContactPerson_2=c1.designation,  
 PANofcontactPerson_2=c1.PanNo,  
 AddressofcontactPerson_2=isnull(c1.Address1,' ') + ' '+  isnull(c1.Address2,' ') + ' ' + isnull(c1.Address3,' '),  
 ContactdetailsofcontactPerson_2=(case when len(c1.Mobileno)>0 then c1.Mobileno else c1.Phone_no end),  
 DINofcontactPerson_2=c1.DIN,  
 UIDofcontactPerson_2=c1.UID,  
 EmailIdofcontactPerson_2=c1.Email    
 from  
  AngelNseCM.msajag.dbo.client_contact_details c1 with(nolock)  
 where  
  Client_Code = cl_code  
  and c1.designation in  ('DIRECTOR','KARTA','PARTNER','TRUSTEE')  
  and #mimansa_angel_ucc_nse_cm_client_data_new_changes.category in ('2','3','4','5')  
  and line_no='2'  
  
 /****ADDRESS 3****/  
 update  
  #mimansa_angel_ucc_nse_cm_client_data_new_changes  
 set  
 NameofcontactPerson_3=c1.contact_name,  
 DesignationofContactPerson_3=c1.designation,  
 PANofcontactPerson_3=c1.PanNo,  
 AddressofcontactPerson_3=isnull(c1.Address1,' ') + ' '+  isnull(c1.Address2,' ') + ' ' + isnull(c1.Address3,' '),  
 ContactdetailsofcontactPerson_3=(case when len(c1.Mobileno)>0 then c1.Mobileno else c1.Phone_no end),  
 DINofcontactPerson_3=c1.DIN,  
 UIDofcontactPerson_3=c1.UID,  
 EmailIdofcontactPerson_3=c1.Email    
 from  
  AngelNseCM.msajag.dbo.client_contact_details c1 with(nolock)  
 where  
  Client_Code = cl_code  
  and c1.designation in  ('DIRECTOR','KARTA','PARTNER','TRUSTEE')  
  and #mimansa_angel_ucc_nse_cm_client_data_new_changes.category in ('2','3','4','5')  
  and line_no='3'  
  
 /****ADDRESS 4****/  
 update  
  #mimansa_angel_ucc_nse_cm_client_data_new_changes  
 set  
 NameofcontactPerson_4=c1.contact_name,  
 DesignationofContactPerson_4=c1.designation,  
 PANofcontactPerson_4=c1.PanNo,  
 AddressofcontactPerson_4=isnull(c1.Address1,' ') + ' '+ isnull( c1.Address2,' ') + ' ' + isnull(c1.Address3,' '),  
 ContactdetailsofcontactPerson_4=(case when len(c1.Mobileno)>0 then c1.Mobileno else c1.Phone_no end),  
 DINofcontactPerson_4=c1.DIN,  
 UIDofcontactPerson_4=c1.UID,  
 EmailIdofcontactPerson_4=c1.Email    
 from  
  AngelNseCM.msajag.dbo.client_contact_details c1 with(nolock)  
 where  
  Client_Code = cl_code  
  and c1.designation in  ('DIRECTOR','KARTA','PARTNER','TRUSTEE')  
  and #mimansa_angel_ucc_nse_cm_client_data_new_changes.category in ('2','3','4','5')  
  and line_no='4'  
  
 /****ADDRESS 5****/  
 update  
  #mimansa_angel_ucc_nse_cm_client_data_new_changes  
 set  
 NameofcontactPerson_5=c1.contact_name,  
 DesignationofContactPerson_5=c1.designation,  
 PANofcontactPerson_5=c1.PanNo,  
 AddressofcontactPerson_5=isnull(c1.Address1,' ') + ' '+  isnull(c1.Address2,' ') + ' ' + isnull(c1.Address3,' '),  
 ContactdetailsofcontactPerson_5=(case when len(c1.Mobileno)>0 then c1.Mobileno else c1.Phone_no end),  
 DINofcontactPerson_5=c1.DIN,  
 UIDofcontactPerson_5=c1.UID,  
 EmailIdofcontactPerson_5=c1.Email    
 from  
  AngelNseCM.msajag.dbo.client_contact_details c1 with(nolock)  
 where  
  Client_Code = cl_code  
  and c1.designation in  ('DIRECTOR','KARTA','PARTNER','TRUSTEE')  
  and #mimansa_angel_ucc_nse_cm_client_data_new_changes.category in ('2','3','4','5')  
  and line_no='5'  
  
 /****ADDRESS 6****/  
 update  
  #mimansa_angel_ucc_nse_cm_client_data_new_changes  
 set  
 NameofcontactPerson_6=c1.contact_name,  
 DesignationofContactPerson_6=c1.designation,  
 PANofcontactPerson_6=c1.PanNo,  
 AddressofcontactPerson_6=isnull(c1.Address1,' ') + ' '+  isnull(c1.Address2,' ') + ' ' + isnull(c1.Address3,' '),  
 ContactdetailsofcontactPerson_6=(case when len(c1.Mobileno)>0 then c1.Mobileno else c1.Phone_no end),  
 DINofcontactPerson_6=c1.DIN,  
 UIDofcontactPerson_6=c1.UID,  
 EmailIdofcontactPerson_6=c1.Email    
 from  
  AngelNseCM.msajag.dbo.client_contact_details c1 with(nolock)  
 where  
  Client_Code = cl_code  
  and c1.designation in  ('DIRECTOR','KARTA','PARTNER','TRUSTEE')  
  and #mimansa_angel_ucc_nse_cm_client_data_new_changes.category in ('2','3','4','5')  
  and line_no='6'  
  
 /****ADDRESS 7****/  
 update  
  #mimansa_angel_ucc_nse_cm_client_data_new_changes  
 set  
 NameofcontactPerson_7=c1.contact_name,  
 DesignationofContactPerson_7=c1.designation,  
 PANofcontactPerson_7=c1.PanNo,  
 AddressofcontactPerson_7=isnull(c1.Address1,' ') + ' '+  isnull(c1.Address2,' ') + ' ' + isnull(c1.Address3,' '),  
 ContactdetailsofcontactPerson_7=(case when len(c1.Mobileno)>0 then c1.Mobileno else c1.Phone_no end),  
 DINofcontactPerson_7=c1.DIN,  
 UIDofcontactPerson_7=c1.UID,  
 EmailIdofcontactPerson_7=c1.Email    
 from  
  AngelNseCM.msajag.dbo.client_contact_details c1 with(nolock)  
 where  
  Client_Code = cl_code  
  and c1.designation in  ('DIRECTOR','KARTA','PARTNER','TRUSTEE')  
  and #mimansa_angel_ucc_nse_cm_client_data_new_changes.category in ('2','3','4','5')  
  and line_no='7'  
  
 /****ADDRESS 8****/  
 update  
  #mimansa_angel_ucc_nse_cm_client_data_new_changes  
 set  
 NameofcontactPerson_8=c1.contact_name,  
 DesignationofContactPerson_8=c1.designation,  
 PANofcontactPerson_8=c1.PanNo,  
 AddressofcontactPerson_8=isnull(c1.Address1,' ') + ' '+  isnull(c1.Address2,' ') + ' ' +isnull( c1.Address3,' '),  
 ContactdetailsofcontactPerson_8=(case when len(c1.Mobileno)>0 then c1.Mobileno else c1.Phone_no end),  
 DINofcontactPerson_8=c1.DIN,  
 UIDofcontactPerson_8=c1.UID,  
 EmailIdofcontactPerson_8=c1.Email    
 from  
  AngelNseCM.msajag.dbo.client_contact_details c1 with(nolock)  
 where  
  Client_Code = cl_code  
  and c1.designation in  ('DIRECTOR','KARTA','PARTNER','TRUSTEE')  
  and #mimansa_angel_ucc_nse_cm_client_data_new_changes.category in ('2','3','4','5')  
  and line_no='8'  
  
 /****ADDRESS 9****/  
 update  
  #mimansa_angel_ucc_nse_cm_client_data_new_changes  
 set  
 NameofcontactPerson_9=c1.contact_name,  
 DesignationofContactPerson_9=c1.designation,  
 PANofcontactPerson_9=c1.PanNo,  
 AddressofcontactPerson_9=isnull(c1.Address1,' ') + ' '+  isnull(c1.Address2,' ') + ' ' + isnull(c1.Address3,' '),  
 ContactdetailsofcontactPerson_9=(case when len(c1.Mobileno)>0 then c1.Mobileno else c1.Phone_no end),  
 DINofcontactPerson_9=c1.DIN,  
 UIDofcontactPerson_9=c1.UID,  
 EmailIdofcontactPerson_9=c1.Email    
 from  
  AngelNseCM.msajag.dbo.client_contact_details c1 with(nolock)  
 where  
  Client_Code = cl_code  
  and c1.designation in  ('DIRECTOR','KARTA','PARTNER','TRUSTEE')  
  and #mimansa_angel_ucc_nse_cm_client_data_new_changes.category in ('2','3','4','5')  
  and line_no='9'  
  
 /****ADDRESS 10****/  
 update  
  #mimansa_angel_ucc_nse_cm_client_data_new_changes  
 set  
 NameofcontactPerson_10=c1.contact_name,  
 DesignationofContactPerson_10=c1.designation,  
 PANofcontactPerson_10=c1.PanNo,  
 AddressofcontactPerson_10=isnull(c1.Address1,' ') + ' '+  isnull(c1.Address2,' ') + ' ' + isnull(c1.Address3,' '),  
 ContactdetailsofcontactPerson_10=(case when len(c1.Mobileno)>0 then c1.Mobileno else c1.Phone_no end),  
 DINofcontactPerson_10=c1.DIN,  
 UIDofcontactPerson_10=c1.UID,  
 EmailIdofcontactPerson_10=c1.Email    
 from  
  AngelNseCM.msajag.dbo.client_contact_details c1 with(nolock)  
 where  
  Client_Code = cl_code  
  and c1.designation in  ('DIRECTOR','KARTA','PARTNER','TRUSTEE')  
  and #mimansa_angel_ucc_nse_cm_client_data_new_changes.category in ('2','3','4','5')  
  and line_no='10'  
  
  
  /*Update POA*/  
  Update   
      #mimansa_angel_ucc_nse_cm_client_data_new_changes  
    set       
       POAforSecurities=  
    case   
    when ltrim(rtrim(Def))=1 then 'Y'    
    when ltrim(rtrim(Def))=0 then 'N'       
    else  ''   
   end  
    from  
     AngelNseCM.msajag.dbo.Multicltid m with(nolock)  
       where  
  Client_Code = m.Party_code  
  
   
  
/*INVALID PAN*/  
select Client_Code,Client_Name,PAN   
into #invalidpan  
from #mimansa_angel_ucc_nse_cm_client_data_new_changes where isnull(pan, 'NA') = 'NA'  
  
  
  
  
/*Take Reference from [mimansa_usp_ucc_nse_cm_client_data_fetch_new_changes]*/  
delete  
 #mimansa_angel_ucc_nse_cm_client_data_new_changes  
from  
 --[196.1.115.239].inhouse.dbo.AllSebiBannedEntities bp with (nolock)  
 INTRANET.mimansa.dbo.UCC_AllSebiBannedEntities bp with (nolock)  
where  
 ltrim(rtrim(replace(isnull(#mimansa_angel_ucc_nse_cm_client_data_new_changes.pan, ''), ',', ''))) = ltrim(rtrim(isnull(bp.panno, '')))  
 and len(bp.panno)=10  
  
  
/*FINAL RESULT*/  
/* Start Added by Nitesh On JUL 12 2019 For Remove client which value INTEROP ACCOUNT UCC NOT DONE  and D.Deactive_value='p'*/  
  
delete #mimansa_angel_ucc_nse_cm_client_data_new_changes  
from    
msajag.dbo.CLIENT_BROK_DETAILS D with (nolock)  
where #mimansa_angel_ucc_nse_cm_client_data_new_changes.Client_Code=D.cl_code   
and D.Deactive_Remarks='INTEROP ACCOUNT UCC NOT DONE'   
and D.Deactive_value='p'  
  
/* End  */  
  
select distinct  
  Segment,   
  Client_Code,   
  Client_Name ,  
  Category ,  
  PAN ,  
  Gender,   
  Fathers_Husbands_GuardiansName ,  
  Maritalstatus ,  
  Nationality ,  
  Nationality_Other,   
  ClientEmailId ,  
  CorrespondenceClientAddressline1 ,  
  CorrespondenceClientAddressline2 ,  
  CorrespondenceClientAddressline3 ,  
  CorrespondenceClientAddress_City ,  
  CorrespondenceClientAddress_State ,  
  CorrespondenceClientAddress_State_Others,   
  CorrespondenceClientAddress_Country ,  
  CorrespondenceClientAddress_Pincode ,  
  FlagIndicatingifCorrespondenceAddressissameasPermanentAddress ,  
  PermanentClientAddressline1 ,  
  PermanentClientAddressline2 ,  
  PermanentClientAddressline3 ,  
  PermanentClientAddress_City ,  
  PermanentClientAddress_State ,  
  PermanentClientAddress_StateOthers  ,  
  PermanentClientAddress_Country ,  
  PermanentClientAddress_Pincode ,  
  ISDcode_Residence ,  
  STDcode_Residence ,  
  TelephoneNumber_Residence ,  
  Mobilenumber ,  
  ISDcode_Office,   
  STDcode_Office ,  
  TelephoneNumber_Office ,  
  DateofBirth_Incorporation ,  
  UIDNUMBER ,  
  BankName1 ,  
  BankBranchAddress1 ,  
  BankAccountNo1 ,  
  BankAccountType1 ,  
  BankName2 ,  
  BankBranchAddress2 ,  
  BankAccountNo2 ,  
  BankAccountType2 ,  
  BankName3 ,  
  BankBranchAddress3 ,  
  BankAccountNo3 ,  
  BankAccountType3,   
  DepositoryName1 ,  
  DepositoryID1 ,  
  BeneficialOwnerAccountNo1 ,  
  DepositoryName2 ,  
  DepositoryID2 ,  
  BeneficialOwnerAccountNo2 ,  
  DepositoryName3 ,  
  DepositoryID3 ,  
  BeneficialOwnerAccountNo3 ,  
  CorporateIdentitynumber_CIN,   
  GrossAnnualIncomeRange ,  
  GrossAnnualIncomeasonDate,   
  NetWorth_InRs ,  
  NetWorthasonDate,   
  PoliticallyExposedPerson_PEP ,  
  PlaceofIncorporation ,  
  Occupation ,  
  OccupationDetails_Forothers ,  
  Dateofcommencementofbusiness ,  
  CustodialParticipantCodeoftheclient ,  
  RegistrationNoofClient ,  
  RegisteringAuthority ,  
  PlaceofRegistration ,  
  DateofRegistration ,  
  InpersonVerification,   
  ClientAgreementDate ,  
  UniqueClientCodeallottedbyNSCCL_BSE ,  
  UpdationFlag_for_SMS_and_Email_facility ,  
  Relationship ,  
  TypeofFacility_for_SMS_and_Email_facility ,  
  ProofType ,  
  ProofNumber ,  
  IssuePlaceofProof ,  
  IssueDateofProof ,  
  ClientStatus ,  
  Remarks ,  
  ClientType_Corporate,   
  NameofcontactPerson_1 ,  
  DesignationofContactPerson_1 ,  
  PANofcontactPerson_1 ,  
  AddressofcontactPerson_1 ,  
  ContactdetailsofcontactPerson_1 ,  
  DINofcontactPerson_1 ,  
  UIDofcontactPerson_1 ,  
  EmailIdofcontactPerson_1 ,  
  NameofcontactPerson_2  ,  
  DesignationofcontactPerson_2 ,  
  PANofcontactPerson_2 ,  
  AddressofcontactPerson_2 ,  
  ContactdetailsofcontactPerson_2,   
  DINofcontactPerson_2 ,  
  UIDofcontactPerson_2 ,  
  EmailIdofcontactPerson_2 ,  
  NameofcontactPerson_3 ,  
  DesignationofcontactPerson_3,   
  PANofcontactPerson_3 ,  
  AddressofcontactPerson_3 ,  
  ContactdetailsofcontactPerson_3,   
  DINofcontactPerson_3 ,  
  UIDofcontactPerson_3 ,  
  EmailIdofcontactPerson_3 ,  
  NameofcontactPerson_4 ,  
  DesignationofcontactPerson_4,   
  PANofcontactPerson_4 ,  
  AddressofcontactPerson_4 ,  
  ContactdetailsofcontactPerson_4 ,  
  DINofcontactPerson_4 ,  
  UIDofcontactPerson_4 ,  
  EmailIdofcontactPerson_4 ,  
  NameofcontactPerson_5 ,  
  DesignationofcontactPerson_5 ,  
  PANofcontactPerson_5 ,  
  AddressofcontactPerson_5 ,  
  ContactdetailsofcontactPerson_5,   
  DINofcontactPerson_5 ,  
  UIDofcontactPerson_5 ,  
  EmailIdofcontactPerson_5 ,  
  NameofcontactPerson_6 ,  
  DesignationofcontactPerson_6,   
  PANofcontactPerson_6 ,  
  AddressofcontactPerson_6 ,  
  ContactdetailsofcontactPerson_6,   
  DINofcontactPerson_6 ,  
  UIDofcontactPerson_6 ,  
  EmailIdofcontactPerson_6 ,  
  NameofcontactPerson_7 ,  
  DesignationofcontactPerson_7,   
  PANofcontactPerson_7 ,  
  AddressofcontactPerson_7 ,  
  ContactdetailsofcontactPerson_7,   
  DINofcontactPerson_7 ,  
  UIDofcontactPerson_7 ,  
  EmailIdofcontactPerson_7 ,  
  NameofcontactPerson_8 ,  
  DesignationofcontactPerson_8 ,  
  PANofcontactPerson_8 ,  
  AddressofcontactPerson_8 ,  
  ContactdetailsofcontactPerson_8 ,  
  DINofcontactPerson_8 ,  
  UIDofcontactPerson_8 ,  
  EmailIdofcontactPerson_8 ,  
  NameofcontactPerson_9 ,  
  DesignationofcontactPerson_9,   
  PANofcontactPerson_9 ,  
  AddressofcontactPerson_9 ,  
  ContactdetailsofcontactPerson_9,   
  DINofcontactPerson_9 ,  
  UIDofcontactPerson_9 ,  
  EmailIdofcontactPerson_9 ,  
  NameofcontactPerson_10 ,  
  DesignationofcontactPerson_10,   
  PANofcontactPerson_10 ,  
  AddressofcontactPerson_10 ,  
  ContactdetailsofcontactPerson_10,   
  DINofcontactPerson_10 ,  
  UIDofcontactPerson_10 ,  
  EmailIdofcontactPerson_10 ,  
  NameofcontactPerson_11 ,  
  DesignationofcontactPerson_11,   
  PANofcontactPerson_11 ,  
  AddressofcontactPerson_11 ,  
  ContactdetailsofcontactPerson_11,   
  DINofcontactPerson_11 ,  
  UIDofcontactPerson_11 ,  
  EmailIdofcontactPerson_11 ,  
  NameofcontactPerson_12 ,  
  DesignationofcontactPerson_12,   
  PANofcontactPerson_12 ,  
  AddressofcontactPerson_12 ,  
  ContactdetailsofcontactPerson_12,   
  DINofcontactPerson_12 ,  
  UIDofcontactPerson_12 ,  
  EmailIdofcontactPerson_12 ,  
  NameofcontactPerson_13 ,  
  DesignationofcontactPerson_13 ,  
  PANofcontactPerson_13 ,  
  AddressofcontactPerson_13 ,  
  ContactdetailsofcontactPerson_13 ,  
  DINofcontactPerson_13 ,  
  UIDofcontactPerson_13 ,  
  EmailIdofcontactPerson_13 ,  
  NameofcontactPerson_14 ,  
  DesignationofcontactPerson_14 ,  
  PANofcontactPerson_14 ,  
  AddressofcontactPerson_14 ,  
  ContactdetailsofcontactPerson_14 ,  
  DINofcontactPerson_14 ,  
  UIDofcontactPerson_14 ,  
  EmailIdofcontactPerson_14 ,  
  NameofcontactPerson_15 ,  
  DesignationofcontactPerson_15 ,  
  PANofcontactPerson_15 ,  
  AddressofcontactPerson_15 ,  
  ContactdetailsofcontactPerson_15,   
  DINofcontactPerson_15 ,  
  UIDofcontactPerson_15 ,  
  EmailIdofcontactPerson_15 ,  
  NameofcontactPerson_16 ,  
  DesignationofcontactPerson_16,   
  PANofcontactPerson_16 ,  
  AddressofcontactPerson_16 ,  
  ContactdetailsofcontactPerson_16,   
  DINofcontactPerson_16 ,  
  UIDofcontactPerson_16 ,  
  EmailIdofcontactPerson_16 ,  
  NameofcontactPerson_17 ,  
  DesignationofcontactPerson_17,   
  PANofcontactPerson_17 ,  
  AddressofcontactPerson_17 ,  
  ContactdetailsofcontactPerson_17,   
  DINofcontactPerson_17 ,  
  UIDofcontactPerson_17 ,  
  EmailIdofcontactPerson_17 ,  
  NameofcontactPerson_18 ,    DesignationofcontactPerson_18,   
  PANofcontactPerson_18 ,  
  AddressofcontactPerson_18 ,  
  ContactdetailsofcontactPerson_18,   
  DINofcontactPerson_18 ,  
  UIDofcontactPerson_18 ,  
  EmailIdofcontactPerson_18 ,  
  NameofcontactPerson_19 ,  
  DesignationofcontactPerson_19,   
  PANofcontactPerson_19 ,  
  AddressofcontactPerson_19 ,  
  ContactdetailsofcontactPerson_19,   
  DINofcontactPerson_19 ,  
  UIDofcontactPerson_19 ,  
  EmailIdofcontactPerson_19 ,  
  NameofcontactPerson_20 ,  
  DesignationofcontactPerson_20,   
  PANofcontactPerson_20 ,  
  AddressofcontactPerson_20 ,  
  ContactdetailsofcontactPerson_20,   
  DINofcontactPerson_20 ,  
  UIDofcontactPerson_20 ,  
  EmailIdofcontactPerson_20 ,  
  POAforFunds ='N',  
     POAforSecurities,  
  Flag='E'  
from  
 #mimansa_angel_ucc_nse_cm_client_data_new_changes with(nolock)  
   
where  
 len(ltrim(rtrim(isnull(pan, '')))) > 0 and  
 isnull(pan, '' ) <> 'NA'  
  
  
/*****ROW COUNT****/  
declare @totalrecord numeric  
  
select @totalrecord=count(*)  from #mimansa_angel_ucc_nse_cm_client_data_new_changes with(nolock)  
where  
 len(ltrim(rtrim(isnull(pan, '')))) > 0 and  
 isnull(pan, '' ) <> 'NA'  
  
/*Insert Log*/  
if exists(select * from [AngelFO].INHOUSE.dbo.mimansa_tbl_ucc_nse_file_count with(nolock) where time_stamp>=cast(left(getdate(),11) as datetime))  
begin  
 update [AngelFO].INHOUSE.dbo.mimansa_tbl_ucc_nse_file_count   
 set file_number=file_number+1  
 where time_stamp>=cast(left(getdate(),11) as datetime)  
end  
else  
begin  
 insert into [AngelFO].INHOUSE.dbo.mimansa_tbl_ucc_nse_file_count(file_number,time_stamp)  
 select 1,getdate()  
end  
  
  
/*Display File Name and First Row  
File NAme Syntax: uci_<YYYYMMDD>.t<LastFileNumber+1>   
    Ex- uci_20130307.t04  
First Row Syntax: 10|M|12798|<DDMMYYYY>|<Latest File Number>|<Total Rows>  
    Ex- 10|M|12798|25022014|01|72  
*/  
  
  
  
select FileName='uci_'+replace(convert(varchar, getdate(), 102), '.', '')+(case when isnull(@processid,'')<>'' then '_selected_clients' else '' end)  
    +'.T'+(case when file_number<10 then  '0'+cast(file_number  as varchar) else cast(file_number  as varchar) end),       
    FirstRow='10|M|12798|'+replace(convert(varchar, getdate(), 103), '/', '')+'|'  
    +(case when file_number<10 then  '0'+cast(file_number  as varchar) else cast(file_number  as varchar) end)+'|'  
    +cast(@totalrecord  as varchar)   
from [AngelFO].INHOUSE.dbo.mimansa_tbl_ucc_nse_file_count with(nolock) where time_stamp>=cast(left(getdate(),11) as datetime)  
  
/*DISPLAY INVALID PAN*/  
select Client_Code,Client_Name,PAN   
from #invalidpan

GO
