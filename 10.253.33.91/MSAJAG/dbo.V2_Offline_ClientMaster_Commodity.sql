-- Object: PROCEDURE dbo.V2_Offline_ClientMaster_Commodity
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE proc [dbo].[V2_Offline_ClientMaster_Commodity]

As

/*-----------------------------------------------------------------------------------------------
Query to populate client data to off line client master tables
		1. Client_Details_Uppili
		2. Client_Brok_Details_Uppili

Following steps are to be carried out to execute batch,

1. Please execute each query seperately one at a time. 
2. To execute please select the query and press F5. 
3. Execute 'Commit' only if there is no run time error at any of the above steps
-------------------------------------------------------------------------------------------------*/

--Begin Tran

--Truncate Table Client_Details_Uppili
--Truncate Table Client_Brok_Details_Uppili

Insert into Client_Details_Uppili
select C1.cl_code,branch_cd,party_code,sub_broker,trader,long_name,short_name,l_address1,l_city,
l_address2,l_state,l_address3,l_nation,l_zip,pan_gir_no,ward_no,sebi_regn_no=FD_Code,res_phone1,res_phone2,
off_phone1,off_phone2,mobile_pager,fax,email,cl_type,cl_status,family,region,area,
p_address1,p_city,p_address2,p_state,p_address3,p_nation,p_zip,p_phone,addemailid,sex,
dob=Birthdate,introducer,approver,interactmode,passport_no=Passportdtl,passport_issued_at=Passportplaceofissue,
passport_issued_on=Passportdateofissue,
passport_expires_on=Passportexpdate,licence_no=Drivelicendtl,licence_issued_at=Licencenoplaceofissue,
licence_issued_on=Licencenodateofissue,licence_expires_on=Driveexpdate,
rat_card_no=Rationcarddtl,rat_card_issued_at=Rationcardplaceofissue,rat_card_issued_on=Rationcarddateofissue,
votersid_no=Votersiddtl,votersid_issued_at=Voteridplaceofissue,votersid_issued_on=Voteriddateofissue,
it_return_yr=Itreturndtl,it_return_filed_on=Itreturndateoffiling,regr_no,regr_at=Regr_Place,regr_on=Regr_Date,
regr_authority=Regr_Date,client_agreement_on=Client_Agre_Dt,sett_mode,
dealing_with_other_tm=Dealing_With_Othrer_Tm,other_ac_no=Any_Other_Acc,introducer_id=Introd_Client_Id,
introducer_relation=Introd_Relation,repatriat_bank=Repatriatbank,
repatriat_bank_ac_no=Repatriatac,
chk_kyc_form=Kycform,chk_corporate_deed=Corpdeed,chk_bank_certificate=Bankcert,chk_annual_report=Anualreport,
chk_networth_cert=Networthcert,chk_corp_dtls_recd=Corpdtlrecd,
Bank_Name='',Branch_Name='',AC_Type='',AC_Num=0,
Depository1='',DpId1='',CltDpId1='',Poa1=0,
Depository2='',DpId2='',CltDpId2='',Poa2=0,
Depository3='',DpId3='',CltDpId3='',Poa3=0,
rel_mgr=dummy8,c_group=dummy9,sbu=dummy10,Status=1,Imp_Status=1,'SYSTEM',GetDate(),
Bank_id=0,Mapin_id='',UCC_Code='',
Micr_No='',Director_name='',paylocation=''
from AngelCommodity.NCDX.Dbo.client1 c1, AngelCommodity.NCDX.Dbo.client2 c2 Left Outer Join AngelCommodity.NCDX.Dbo.Client5 C5 
On (C2.Cl_Code = C5.Cl_code)
where c1.cl_code = c2.cl_code
       AND C2.PARTY_CODE NOT IN (SELECT PARTY_CODE
                                 FROM  CLIENT_DETAILS_UPPILI)

Insert into Client_Details_Uppili
select C1.cl_code,branch_cd,party_code,sub_broker,trader,long_name,short_name,l_address1,l_city,
l_address2,l_state,l_address3,l_nation,l_zip,pan_gir_no,ward_no,sebi_regn_no=FD_Code,res_phone1,res_phone2,
off_phone1,off_phone2,mobile_pager,fax,email,cl_type,cl_status,family,region,area,
p_address1,p_city,p_address2,p_state,p_address3,p_nation,p_zip,p_phone,addemailid,sex,
dob=Birthdate,introducer,approver,interactmode,passport_no=Passportdtl,passport_issued_at=Passportplaceofissue,
passport_issued_on=Passportdateofissue,
passport_expires_on=Passportexpdate,licence_no=Drivelicendtl,licence_issued_at=Licencenoplaceofissue,
licence_issued_on=Licencenodateofissue,licence_expires_on=Driveexpdate,
rat_card_no=Rationcarddtl,rat_card_issued_at=Rationcardplaceofissue,rat_card_issued_on=Rationcarddateofissue,
votersid_no=Votersiddtl,votersid_issued_at=Voteridplaceofissue,votersid_issued_on=Voteriddateofissue,
it_return_yr=Itreturndtl,it_return_filed_on=Itreturndateoffiling,regr_no,regr_at=Regr_Place,regr_on=Regr_Date,
regr_authority=Regr_Date,client_agreement_on=Client_Agre_Dt,sett_mode,
dealing_with_other_tm=Dealing_With_Othrer_Tm,other_ac_no=Any_Other_Acc,introducer_id=Introd_Client_Id,
introducer_relation=Introd_Relation,repatriat_bank=Repatriatbank,
repatriat_bank_ac_no=Repatriatac,
chk_kyc_form=Kycform,chk_corporate_deed=Corpdeed,chk_bank_certificate=Bankcert,chk_annual_report=Anualreport,
chk_networth_cert=Networthcert,chk_corp_dtls_recd=Corpdtlrecd,
Bank_Name='',Branch_Name='',AC_Type='',AC_Num=0,
Depository1='',DpId1='',CltDpId1='',Poa1=0,
Depository2='',DpId2='',CltDpId2='',Poa2=0,
Depository3='',DpId3='',CltDpId3='',Poa3=0,
rel_mgr=dummy8,c_group=dummy9,sbu=dummy10,Status=1,Imp_Status=1,'SYSTEM',GetDate(),
Bank_id=0,Mapin_id='',UCC_Code='',
Micr_No='',Director_name='',paylocation=''
from AngelCommodity.MCDX.DBO.client1 c1, AngelCommodity.MCDX.DBO.client2 c2 Left Outer Join AngelCommodity.MCDX.DBO.Client5 C5 
On (C2.Cl_Code = C5.Cl_code)
where c1.cl_code = c2.cl_code
And C2.Party_Code Not In (Select Party_Code From Client_Details_Uppili )


Update Client_Details_Uppili Set Depository1=Depository,DpId1=Bankid,CltDpId1=Cltdpid,Poa1=0
From AngelCommodity.NCDX.dbo.Client4 c4 Where c4.Party_Code = Client_Details_Uppili.Party_Code
And Depository In ('CDSL', 'NSDL')
And DefDp = 1

/*
Delete from AngelCommodity.NCDX.dbo.Client4 
where BankId >= 'A' And BankId <= 'Z'
And Depository not In ('CDSL', 'NSDL')


Delete from AngelCommodity.MCDX.DBO.Client4 
where BankId >= 'A' And BankId <= 'Z'
And Depository not In ('CDSL', 'NSDL')
*/

Update Client_Details_Uppili Set Bank_Name=P.Bank_Name,
Branch_Name=P.Branch_Name,AC_Type=Depository,AC_Num=Cltdpid, Bank_id = C4.BankId
From  AngelCommodity.NCDX.dbo.Client4 C4,  AngelCommodity.NCDX.dbo.POBank P
Where C4.BankId = P.BankId
And Depository not In ('CDSL', 'NSDL')
And C4.Party_Code = Client_Details_Uppili.Party_Code
and isnumeric(c4.bankid) = 1

Update Client_Details_Uppili Set Bank_Name=P.Bank_Name,
Branch_Name=P.Branch_Name,AC_Type=Depository,AC_Num=Cltdpid, Bank_id = C4.BankId
From  AngelCommodity.MCDX.dbo.Client4 C4,  AngelCommodity.MCDX.dbo.POBank P
Where C4.BankId = P.BankId
And Depository not In ('CDSL', 'NSDL')
And C4.Party_Code = Client_Details_Uppili.Party_Code
and isnumeric(c4.bankid) = 1


Update Client_Details_Uppili Set UCC_Code = U.UCC_Code, Mapin_id = Mapidid
From  AngelCommodity.NCDX.dbo.UCC_Client U
Where U.Party_Code = Client_Details_Uppili.Party_Code


Insert into Client_Brok_Details_Uppili
Select Distinct C1.Cl_Code,'NCX','FUTURES',Brok_Scheme,Trd_Brok=Table_No,
Del_Brok=MF_TableNo,
Ser_Tax=Service_Chrg,SerTaxMethod,Credit_Limit,
InActiveFrom=IsNull(InActiveFrom,'Apr  1 2006'),Printf,No_Of_Copies=1,
BankId,CltdpNo,InsCont,Round_Style=2,
STP_Provider=Dummy6,STP_Rp_Style=dummy7,Market_Type='',Multiplier=0,Charged=0,Maintenance=0,
Reqd_By_Exch='0',Reqd_By_Broker='0',
Client_Rating='A',DebitFlag=0,
InterFlag=0,TRD_STT=Insurance_Chrg,Trd_Tran_Chrgs=Turnover_Tax,
Trd_Sebi_Fees=Sebi_Turn_Tax,Trd_Stamp_Duty=Brokernote,
Trd_Other_Chrgs=Other_Chrg,Trd_Eff_Dt='Apr  1 2006',Del_Stt=Insurance_Chrg,
Del_Tran_Chrgs=Turnover_Tax,Del_SEBI_Fees=Sebi_Turn_Tax,
Del_Stamp_Duty=Brokernote,Del_Other_Chrgs=Other_Chrg,
Del_Eff_Dt='Apr  1 2006',
Rounding_Method='ACTUAL',Round_To_Digit=2,Round_To_Paise=0,
Fut_Brok=Std_rate,Fut_Opt_Brok=brok2_tableno,Fut_Fut_Fin_Brok=brok1_tableno,
Fut_Opt_Exc=Dummy2,Fut_Brok_Applicable=0,
Fut_Stt=Insurance_Chrg,Fut_Tran_Chrgs=Turnover_Tax,Fut_Sebi_Fees=Sebi_Turn_Tax,
Fut_Stamp_Duty=Brokernote,Fut_Other_Chrgs=Other_Chrg,
Status=1,Modifiedon=GetDate(),Modifiedby='SYSTEM',Imp_Status=1,
Pay_B3B_Payment=Btobpayment,Pay_Bank_name=Pobankname,Pay_Branch_name=Pobranch,Pay_AC_No=Pobankcode,
Pay_payment_Mode=Paymode,Brok_Eff_Date='Apr  1 2006',Inst_Trd_Brok=Table_No,Inst_Del_Brok=Sub_TableNo,
SYSTEMDATE = getdate(),Active_Date = ActiveFrom ,CheckActiveClient = (Case when IsNull(InActiveFrom,'Apr  1 2006') <= getdate() then '0' else '1' End) 
From 
AngelCommodity.AccountNCDX.dbo.AcMast a ,
AngelCommodity.NCDX.dbo.Client1 C1, AngelCommodity.NCDX.dbo.Client2 C2 Left Outer Join AngelCommodity.NCDX.dbo.Client5 C5
On (C5.Cl_Code = C2.Cl_Code) 
Where C1.Cl_Code = C2.Cl_Code
and a.CltCode = C1.Cl_Code
And C1.cl_Code Not In (Select Cl_Code From Client_Brok_Details_Uppili Where Exchange = 'NCX' And Segment = 'FUTURES')

Insert into Client_Brok_Details_Uppili
Select Distinct C1.Cl_Code,'MCX','FUTURES',Brok_Scheme,Trd_Brok=Table_No,
Del_Brok=MF_TableNo,
Ser_Tax=Service_Chrg,SerTaxMethod,Credit_Limit,
InActiveFrom=IsNull(InActiveFrom,'Apr  1 2006'),Printf,No_Of_Copies=1,
BankId,CltdpNo,InsCont,Round_Style=2,
STP_Provider=Dummy6,STP_Rp_Style=dummy7,Market_Type='',Multiplier=0,Charged=0,Maintenance=0,
Reqd_By_Exch='0',Reqd_By_Broker='0',
Client_Rating='A',DebitFlag=0,
InterFlag=0,TRD_STT=Insurance_Chrg,Trd_Tran_Chrgs=Turnover_Tax,
Trd_Sebi_Fees=Sebi_Turn_Tax,Trd_Stamp_Duty=Brokernote,
Trd_Other_Chrgs=Other_Chrg,Trd_Eff_Dt='Apr  1 2006',Del_Stt=Insurance_Chrg,
Del_Tran_Chrgs=Turnover_Tax,Del_SEBI_Fees=Sebi_Turn_Tax,
Del_Stamp_Duty=Brokernote,Del_Other_Chrgs=Other_Chrg,
Del_Eff_Dt='Apr  1 2006',
Rounding_Method='ACTUAL',Round_To_Digit=2,Round_To_Paise=0,
Fut_Brok=Std_rate,Fut_Opt_Brok=brok2_tableno,Fut_Fut_Fin_Brok=brok1_tableno,
Fut_Opt_Exc=Dummy2,Fut_Brok_Applicable=0,
Fut_Stt=Insurance_Chrg,Fut_Tran_Chrgs=Turnover_Tax,Fut_Sebi_Fees=Sebi_Turn_Tax,
Fut_Stamp_Duty=Brokernote,Fut_Other_Chrgs=Other_Chrg,
Status=1,Modifiedon=GetDate(),Modifiedby='SYSTEM',Imp_Status=1,
Pay_B3B_Payment=Btobpayment,Pay_Bank_name=Pobankname,Pay_Branch_name=Pobranch,Pay_AC_No=Pobankcode,
Pay_payment_Mode=Paymode,Brok_Eff_Date='Apr  1 2006',Inst_Trd_Brok=Table_No,Inst_Del_Brok=Sub_TableNo,
SYSTEMDATE = getdate(),Active_Date = ActiveFrom ,CheckActiveClient = (Case when IsNull(InActiveFrom,'Apr  1 2006') <= getdate() then '0' else '1' End)
From 
AngelCommodity.AccountMCDX.DBO.AcMast a ,
AngelCommodity.MCDX.DBO.Client1 C1, AngelCommodity.MCDX.DBO.Client2 C2 Left Outer Join AngelCommodity.MCDX.DBO.Client5 C5
On (C5.Cl_Code = C2.Cl_Code) 
Where C1.Cl_Code = C2.Cl_Code
And a.CltCode = C1.Cl_Code
And C1.cl_Code Not In (Select Cl_Code From Client_Brok_Details_Uppili Where Exchange = 'MCX' And Segment = 'FUTURES')

--Commit Tran

GO
