-- Object: PROCEDURE dbo.V2_Offline_ClientMaster_Cash
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE proc [dbo].[V2_Offline_ClientMaster_Cash]  
  
As  
  
  
--Begin Tran  
  
--Truncate Table Client_Details  
--Truncate Table Client_Brok_Details  
  
Insert into Client_Details  
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
from client1 c1, client2 c2 Left Outer Join Client5 C5   
On (C2.Cl_Code = C5.Cl_code)  
where c1.cl_code = c2.cl_code  
And C2.Party_Code Not In (Select Party_Code From Client_Details)  

  
Insert into Client_Details  
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
from Anand.Bsedb_Ab.DBO.client1 c1, Anand.Bsedb_Ab.DBO.client2 c2 Left Outer Join Anand.Bsedb_Ab.DBO.Client5 C5   
On (C2.Cl_Code = C5.Cl_code)  
where c1.cl_code = c2.cl_code  
And C2.Party_Code Not In (Select Party_Code From Client_Details)  
  
Insert into Client_Details  
SELECT C1.CL_CODE,  
       BRANCH_CD,  
       PARTY_CODE,  
       SUB_BROKER,  
       TRADER,  
       LONG_NAME,  
       SHORT_NAME,  
       L_ADDRESS1,  
       L_CITY,  
       L_ADDRESS2,  
       L_STATE,  
       L_ADDRESS3,  
       L_NATION,  
       L_ZIP,  
       PAN_GIR_NO,  
       WARD_NO,  
       SEBI_REGN_NO = FD_CODE,  
       RES_PHONE1,  
       RES_PHONE2,  
       OFF_PHONE1,  
       OFF_PHONE2,  
       MOBILE_PAGER,  
       FAX,  
       EMAIL,  
       CL_TYPE,  
       CL_STATUS,  
       FAMILY,  
       REGION,  
       AREA,  
       P_ADDRESS1,  
       P_CITY,  
       P_ADDRESS2,  
       P_STATE,  
       P_ADDRESS3,  
       P_NATION,  
       P_ZIP,  
       P_PHONE,  
       ADDEMAILID,  
       SEX,  
       DOB = BIRTHDATE,  
       INTRODUCER,  
       APPROVER,  
       INTERACTMODE,  
       PASSPORT_NO = PASSPORTDTL,  
       PASSPORT_ISSUED_AT = PASSPORTPLACEOFISSUE,  
       PASSPORT_ISSUED_ON = PASSPORTDATEOFISSUE,  
       PASSPORT_EXPIRES_ON = '',  
       LICENCE_NO = DRIVELICENDTL,  
       LICENCE_ISSUED_AT = LICENCENOPLACEOFISSUE,  
       LICENCE_ISSUED_ON = LICENCENODATEOFISSUE,  
       LICENCE_EXPIRES_ON = '',  
       RAT_CARD_NO = RATIONCARDDTL,  
       RAT_CARD_ISSUED_AT = RATIONCARDPLACEOFISSUE,  
       RAT_CARD_ISSUED_ON = RATIONCARDDATEOFISSUE,  
       VOTERSID_NO = VOTERSIDDTL,  
       VOTERSID_ISSUED_AT = VOTERIDPLACEOFISSUE,  
       VOTERSID_ISSUED_ON = VOTERIDDATEOFISSUE,  
       IT_RETURN_YR = ITRETURNDTL,  
       IT_RETURN_FILED_ON = ITRETURNDATEOFFILING,  
       REGR_NO='',  
       REGR_AT = '',  
       REGR_ON = '',  
       REGR_AUTHORITY = '',  
       CLIENT_AGREEMENT_ON = '',  
       SETT_MODE='',  
       DEALING_WITH_OTHER_TM = '',  
       OTHER_AC_NO = '',  
       INTRODUCER_ID = '',  
       INTRODUCER_RELATION = '',  
       REPATRIAT_BANK = REPATRIATBANK,  
       REPATRIAT_BANK_AC_NO = REPATRIATAC,  
       CHK_KYC_FORM = KYCFORM,  
       CHK_CORPORATE_DEED = CORPDEED,  
       CHK_BANK_CERTIFICATE = BANKCERT,  
       CHK_ANNUAL_REPORT = ANUALREPORT,  
       CHK_NETWORTH_CERT = NETWORTHCERT,  
       CHK_CORP_DTLS_RECD = CORPDTLRECD,  
       BANK_NAME = '',  
       BRANCH_NAME = '',  
       AC_TYPE = '',  
       AC_NUM = 0,  
       DEPOSITORY1 = '',  
       DPID1 = '',  
       CLTDPID1 = '',  
       POA1 = 0,  
       DEPOSITORY2 = '',  
       DPID2 = '',  
       CLTDPID2 = '',  
       POA2 = 0,  
       DEPOSITORY3 = '',  
       DPID3 = '',  
       CLTDPID3 = '',  
       POA3 = 0,  
       REL_MGR = DUMMY8,  
       C_GROUP = DUMMY9,  
       SBU = DUMMY10,  
       STATUS = 1,  
       IMP_STATUS = 1,  
       'SYSTEM',  
       GETDATE(),  
       BANK_ID = 0,  
       MAPIN_ID = '',  
       UCC_CODE = '',  
       MICR_NO = '',  
       DIRECTOR_NAME = '',  
       PAYLOCATION = ''  
FROM   ANGELFO.NSEFO.DBO.CLIENT1 C1,  
       ANGELFO.NSEFO.DBO.CLIENT2 C2  
       LEFT OUTER JOIN ANGELFO.NSEFO.DBO.CLIENT5 C5  
                    ON (C2.CL_CODE = C5.CL_CODE)  
WHERE  C1.CL_CODE = C2.CL_CODE  
       AND C2.PARTY_CODE NOT IN (SELECT PARTY_CODE  
                                 FROM  CLIENT_DETAILS)  
  
Update Client_Details Set Depository1=Depository,DpId1=Bankid,CltDpId1=Cltdpid,Poa1=0  
From Client4 Where Client4.Party_Code = Client_Details.Party_Code  
And Depository In ('CDSL', 'NSDL')  
And DefDp = 1  
  
/*  
Delete from Client4   
where BankId >= 'A' And BankId <= 'Z'  
And Depository not In ('CDSL', 'NSDL')  
*/  
  
Update Client_Details Set Bank_Name=P.Bank_Name,  
Branch_Name=P.Branch_Name,AC_Type=Depository,AC_Num=Cltdpid, Bank_id = C4.BankId  
From Client4 C4, POBank P  
Where C4.BankId = P.BankId  
And Depository not In ('CDSL', 'NSDL')  
And C4.Party_Code = Client_Details.Party_Code  
and isnumeric(c4.bankid) = 1  
  
Update Client_Details Set UCC_Code = U.UCC_Code, Mapin_id = Mapidid  
From UCC_Client U  
Where U.Party_Code = Client_Details.Party_Code  
  
Update Client_Details Set POA1 = 1   
From MultiCltId M  
Where M.Party_Code = Client_Details.Party_Code  
And Depository1 = DpType  
And Def = 1  
And DpId1 = DpId  
And CltDpId1 = CltDpNo  
  
Update Client_Details Set Depository2=DpType,DpId2=DpId,CltDpId2=CltDpNo,Poa2=Def  
From MultiCltId M  
Where M.Party_Code = Client_Details.Party_Code  
And CltDpNo Not In ( Select CltDpNo From MultiCltId M1   
Where Depository1 = DpType  
And DpId1 = DpId  
And CltDpId1 = CltDpNo)  
  
  
Update Client_Details Set Depository3=DpType,DpId3=DpId,CltDpId3=CltDpNo,Poa3=Def  
From MultiCltId M  
Where M.Party_Code = Client_Details.Party_Code  
And CltDpNo Not In ( Select CltDpNo From MultiCltId M1   
Where Depository1 = DpType  
And DpId1 = DpId  
And CltDpId1 = CltDpNo)  
And CltDpNo Not In ( Select CltDpNo From MultiCltId M1   
Where Depository2 = DpType  
And DpId2 = DpId  
And CltDpId2 = CltDpNo)  
  
Insert into Client_Brok_Details  
Select Distinct C1.Cl_Code,'NSE','CAPITAL',Brok_Scheme,Trd_Brok=Table_No,Del_Brok=Sub_TableNo,  
Ser_Tax=Service_Chrg,SerTaxMethod,Credit_Limit,  
InActiveFrom=IsNull(InActiveFrom,'Apr  1 2006'),Printf,No_Of_Copies=IsNull(Noc,1),  
BankId,CltdpNo,InsCont,Round_Style=2,  
STP_Provider=Dummy6,STP_Rp_Style=dummy7,Market_Type='',Multiplier=0,Charged=0,Maintenance=0,  
Reqd_By_Exch='0',Reqd_By_Broker='0',  
Client_Rating='A',DebitFlag-IsNull(DebitFlag,0),  
InterFlag=IsNull(InterFlag,0),TRD_STT=Insurance_Chrg,Trd_Tran_Chrgs=Turnover_Tax,  
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
SYSTEMDATE = getdate(), Active_Date = ActiveFrom,   
CheckActiveClient = (Case when IsNull(InActiveFrom,'Apr  1 2006') <= getdate() then '0' else '1' End)  
From Client1 C1, Client2 C2 Left Outer Join Client5 C5  
On (C5.Cl_Code = C2.Cl_Code) Left Outer Join DelPartyFlag D  
On (D.Party_Code = C2.Party_Code) Left Outer Join InstClient_Tbl I  
On (I.PartyCode = C2.Party_Code) Left Outer Join Account.DBO.ACMast A  
On (A.CltCode = C2.Party_Code)  
Where C1.Cl_Code = C2.Cl_Code  
And C1.cl_Code Not In (Select Cl_Code From Client_Brok_Details Where Exchange = 'NSE' And Segment = 'CAPITAL')  
  
  
Insert into Client_Brok_Details  
Select Distinct C1.Cl_Code,'BSE','CAPITAL',Brok_Scheme,Trd_Brok=Table_No,Del_Brok=Sub_TableNo,  
Ser_Tax=Service_Chrg,SerTaxMethod,Credit_Limit,  
InActiveFrom=IsNull(InActiveFrom,'Apr  1 2006'),Printf,No_Of_Copies=IsNull(Noc,1),  
BankId,CltdpNo,InsCont,Round_Style=2,  
STP_Provider=Dummy6,STP_Rp_Style=dummy7,Market_Type='',Multiplier=0,Charged=0,Maintenance=0,  
Reqd_By_Exch='0',Reqd_By_Broker='0',  
Client_Rating='A',DebitFlag-IsNull(DebitFlag,0),  
InterFlag=IsNull(InterFlag,0),TRD_STT=Insurance_Chrg,Trd_Tran_Chrgs=Turnover_Tax,  
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
SYSTEMDATE = getdate(), Active_Date = ActiveFrom,   
CheckActiveClient = (Case when IsNull(InActiveFrom,'Apr  1 2006') <= getdate() then '0' else '1' End)  
From Anand.Bsedb_Ab.DBO.Client1 C1, Anand.Bsedb_Ab.DBO.Client2 C2 Left Outer Join Anand.Bsedb_Ab.DBO.Client5 C5  
On (C5.Cl_Code = C2.Cl_Code) Left Outer Join Anand.Bsedb_Ab.DBO.DelPartyFlag D  
On (D.Party_Code = C2.Party_Code) Left Outer Join Anand.Bsedb_Ab.DBO.InstClient_Tbl I  
On (I.PartyCode = C2.Party_Code) Left Outer Join Anand.Account_AB.DBO.ACMast A  
On (A.CltCode = C2.Party_Code)  
Where C1.Cl_Code = C2.Cl_Code  
And C1.cl_Code Not In (Select Cl_Code From Client_Brok_Details Where Exchange = 'BSE' And Segment = 'CAPITAL')  
  
Insert into Client_Brok_Details  
Select Distinct C1.Cl_Code,'NSE','FUTURES',Brok_Scheme,Trd_Brok=Table_No,Del_Brok=Sub_TableNo,  
Ser_Tax=Service_Chrg,SerTaxMethod,Credit_Limit,  
InActiveFrom=IsNull(InActiveFrom,'Apr  1 2006'),Printf,No_Of_Copies=IsNull(Noc,1),  
BankId,CltdpNo,InsCont,Round_Style=2,  
STP_Provider=Dummy6,STP_Rp_Style=dummy7,Market_Type='',Multiplier=0,Charged=0,Maintenance=0,  
Reqd_By_Exch='0',Reqd_By_Broker='0',  
Client_Rating='A',DebitFlag-IsNull(DebitFlag,0),  
InterFlag=IsNull(InterFlag,0),TRD_STT=Insurance_Chrg,Trd_Tran_Chrgs=Turnover_Tax,  
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
Pay_B3B_Payment='',Pay_Bank_name='',Pay_Branch_name='',Pay_AC_No='',  
Pay_payment_Mode='',Brok_Eff_Date='Apr  1 2006',Inst_Trd_Brok=Table_No,Inst_Del_Brok=Sub_TableNo,    
SYSTEMDATE = getdate(), Active_Date = ActiveFrom,   
CheckActiveClient = (Case when IsNull(InActiveFrom,'Apr  1 2006') <= getdate() then '0' else '1' End)  
From AngelFo.NSEFO.DBO.Client1 C1, AngelFo.NSEFO.DBO.Client2 C2 Left Outer Join AngelFo.NSEFO.DBO.Client5 C5  
On (C5.Cl_Code = C2.Cl_Code) Left Outer Join AngelFo.NSEFO.DBO.DelPartyFlag D  
On (D.Party_Code = C2.Party_Code) Left Outer Join AngelFo.NSEFO.DBO.InstClient_Tbl I  
On (I.PartyCode = C2.Party_Code) Left Outer Join AngelFo.AccountFO.DBO.ACMast A  
On (A.CltCode = C2.Party_Code)  
Where C1.Cl_Code = C2.Cl_Code  
And C1.cl_Code Not In (Select Cl_Code From Client_Brok_Details Where Exchange = 'NSE' And Segment = 'FUTURES')  
  
Update Client_Brok_Details SET TRD_BROK = TABLE_NO, BROK_EFF_DATE = FROM_DATE,  
BROK_SCHEME = CLIENTBROK_SCHEME.BROKSCHEME  
FROM CLIENTBROK_SCHEME WHERE EXCHANGE = 'NSE' AND SEGMENT = 'CAPITAL'  
AND CL_CODE = PARTY_CODE  
AND TO_DATE LIKE 'DEC 31 2049%'  
AND SCHEME_TYPE = 'TRD'  
AND TRADE_TYPE = 'NRM'  
  
Update Client_Brok_Details SET INST_TRD_BROK = TABLE_NO   
FROM CLIENTBROK_SCHEME WHERE EXCHANGE = 'NSE' AND SEGMENT = 'CAPITAL'  
AND CL_CODE = PARTY_CODE  
AND TO_DATE LIKE 'DEC 31 2049%'  
AND SCHEME_TYPE = 'TRD'  
AND TRADE_TYPE = 'INS'  
  
Update Client_Brok_Details SET DEL_BROK = TABLE_NO   
FROM CLIENTBROK_SCHEME WHERE EXCHANGE = 'NSE' AND SEGMENT = 'CAPITAL'  
AND CL_CODE = PARTY_CODE  
AND TO_DATE LIKE 'DEC 31 2049%'  
AND SCHEME_TYPE = 'DEL'  
AND TRADE_TYPE = 'NRM'  
  
Update Client_Brok_Details SET INST_DEL_BROK = TABLE_NO   
FROM CLIENTBROK_SCHEME WHERE EXCHANGE = 'NSE' AND SEGMENT = 'CAPITAL'  
AND CL_CODE = PARTY_CODE  
AND TO_DATE LIKE 'DEC 31 2049%'  
AND SCHEME_TYPE = 'DEL'  
AND TRADE_TYPE = 'INS'  
  
Update Client_Brok_Details SET TRD_BROK = TABLE_NO, BROK_EFF_DATE = FROM_DATE,  
BROK_SCHEME = CLIENTBROK_SCHEME.BROKSCHEME  
FROM Anand.Bsedb_Ab.DBO.CLIENTBROK_SCHEME CLIENTBROK_SCHEME WHERE EXCHANGE = 'BSE' AND SEGMENT = 'CAPITAL'  
AND CL_CODE = PARTY_CODE  
AND TO_DATE LIKE 'DEC 31 2049%'  
AND SCHEME_TYPE = 'TRD'  
AND TRADE_TYPE = 'NRM'  
  
Update Client_Brok_Details SET INST_TRD_BROK = TABLE_NO   
FROM Anand.Bsedb_Ab.DBO.CLIENTBROK_SCHEME CLIENTBROK_SCHEME WHERE EXCHANGE = 'BSE' AND SEGMENT = 'CAPITAL'  
AND CL_CODE = PARTY_CODE  
AND TO_DATE LIKE 'DEC 31 2049%'  
AND SCHEME_TYPE = 'TRD'  
AND TRADE_TYPE = 'INS'  
  
Update Client_Brok_Details SET DEL_BROK = TABLE_NO   
FROM Anand.Bsedb_Ab.DBO.CLIENTBROK_SCHEME CLIENTBROK_SCHEME WHERE EXCHANGE = 'BSE' AND SEGMENT = 'CAPITAL'  
AND CL_CODE = PARTY_CODE  
AND TO_DATE LIKE 'DEC 31 2049%'  
AND SCHEME_TYPE = 'DEL'  
AND TRADE_TYPE = 'NRM'  
  
Update Client_Brok_Details SET INST_DEL_BROK = TABLE_NO   
FROM Anand.Bsedb_Ab.DBO.CLIENTBROK_SCHEME CLIENTBROK_SCHEME WHERE EXCHANGE = 'BSE' AND SEGMENT = 'CAPITAL'  
AND CL_CODE = PARTY_CODE  
AND TO_DATE LIKE 'DEC 31 2049%'  
AND SCHEME_TYPE = 'DEL'  
AND TRADE_TYPE = 'INS'  
  
Update Client_Brok_Details SET TRD_STT=Insurance_Chrg,Trd_Tran_Chrgs=Turnover_Tax,  
Trd_Sebi_Fees=SebiTurn_Tax,Trd_Stamp_Duty=Broker_note,  
Trd_Other_Chrgs=Other_Chrg,Trd_Eff_Dt=FROMDATE,  
Rounding_Method=(CASE WHEN ERRNUM = 0.5   
              THEN 'ACTUAL'   
               WHEN ERRNUM = -0.01 OR ERRNUM = -0.1  
                      THEN 'NEXT'  
                      WHEN ERRNUM = 0.01 OR ERRNUM = 0.1  
                      THEN 'PREVIOUS'  
                      WHEN ERRNUM = -2.5 OR ERRNUM = 2.5  
                      THEN 'BANKER'  
                 END),  
Round_To_Digit = Round_To,Round_To_Paise=RoFig   
FROM CLIENTTAXES_NEW   
WHERE Client_Brok_Details.EXCHANGE = 'NSE' AND SEGMENT = 'CAPITAL'  
AND CL_CODE = PARTY_CODE  
AND TODATE LIKE 'DEC 31 2049%'  
AND TRANS_CAT = 'TRD'  
  
Update Client_Brok_Details SET Del_Stt=Insurance_Chrg,  
Del_Tran_Chrgs=Turnover_Tax,Del_SEBI_Fees=SebiTurn_Tax,  
Del_Stamp_Duty=Broker_note,Del_Other_Chrgs=Other_Chrg,  
Del_Eff_Dt=FROMDATE,   
Rounding_Method=(CASE WHEN ERRNUM = 0.5   
              THEN 'ACTUAL'   
               WHEN ERRNUM = -0.01 OR ERRNUM = -0.1  
                      THEN 'NEXT'  
                      WHEN ERRNUM = 0.01 OR ERRNUM = 0.1  
                      THEN 'PREVIOUS'  
                      WHEN ERRNUM = -2.5 OR ERRNUM = 2.5  
                      THEN 'BANKER'  
                 END),  
Round_To_Digit = Round_To,Round_To_Paise=RoFig   
FROM CLIENTTAXES_NEW   
WHERE Client_Brok_Details.EXCHANGE = 'NSE' AND SEGMENT = 'CAPITAL'  
AND CL_CODE = PARTY_CODE  
AND TODATE LIKE 'DEC 31 2049%'  
AND TRANS_CAT = 'DEL'  
  
Update Client_Brok_Details SET TRD_STT=Insurance_Chrg,Trd_Tran_Chrgs=Turnover_Tax,  
Trd_Sebi_Fees=SebiTurn_Tax,Trd_Stamp_Duty=Broker_note,  
Trd_Other_Chrgs=Other_Chrg,Trd_Eff_Dt=FROMDATE,  
Rounding_Method=(CASE WHEN ERRNUM = 0.5   
              THEN 'ACTUAL'   
               WHEN ERRNUM = -0.01 OR ERRNUM = -0.1  
                      THEN 'NEXT'  
                      WHEN ERRNUM = 0.01 OR ERRNUM = 0.1  
                      THEN 'PREVIOUS'  
                      WHEN ERRNUM = -2.5 OR ERRNUM = 2.5  
                      THEN 'BANKER'  
                 END),  
Round_To_Digit = Round_To,Round_To_Paise=RoFig  
FROM Anand.Bsedb_Ab.DBO.CLIENTTAXES_NEW   
WHERE Client_Brok_Details.EXCHANGE = 'BSE' AND SEGMENT = 'CAPITAL'  
AND CL_CODE = PARTY_CODE  
AND TODATE LIKE 'DEC 31 2049%'  
AND TRANS_CAT = 'TRD'  
  
Update Client_Brok_Details SET Del_Stt=Insurance_Chrg,  
Del_Tran_Chrgs=Turnover_Tax,Del_SEBI_Fees=SebiTurn_Tax,  
Del_Stamp_Duty=Broker_note,Del_Other_Chrgs=Other_Chrg,  
Del_Eff_Dt=FROMDATE,   
Rounding_Method=(CASE WHEN ERRNUM = 0.5   
              THEN 'ACTUAL'   
               WHEN ERRNUM = -0.01 OR ERRNUM = -0.1  
                      THEN 'NEXT'  
                      WHEN ERRNUM = 0.01 OR ERRNUM = 0.1  
                      THEN 'PREVIOUS'  
                      WHEN ERRNUM = -2.5 OR ERRNUM = 2.5  
                      THEN 'BANKER'  
                 END),  
Round_To_Digit = Round_To,Round_To_Paise=RoFig   
FROM Anand.Bsedb_Ab.DBO.CLIENTTAXES_NEW   
WHERE Client_Brok_Details.EXCHANGE = 'BSE' AND SEGMENT = 'CAPITAL'  
AND CL_CODE = PARTY_CODE  
AND TODATE LIKE 'DEC 31 2049%'  
AND TRANS_CAT = 'DEL'  
--Commit Tran

GO
