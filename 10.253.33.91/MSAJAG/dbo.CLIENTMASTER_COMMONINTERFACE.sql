-- Object: PROCEDURE dbo.CLIENTMASTER_COMMONINTERFACE
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

  
  
       
CREATE PROC [dbo].[CLIENTMASTER_COMMONINTERFACE]        
AS        
BEGIN TRAN  
    
  SELECT *,SPACE(1) AS ISEXIST INTO #CLIENT_DETAILS_TEMP FROM Client_Details_CommonInterface WITH(nOLOCK)  
  WHERE isnull(Updation_Flag,'N')='N'  
    
  SELECT *,SPACE(1) AS ISEXIST INTO #BROK_TEMP FROM CLIENT_BROK_DETAILS_CommonInterface WITH(nOLOCK)   
  WHERE isnull(Updation_Flag,'N')='N'  
    
 SELECT *,SPACE(1) AS ISEXIST INTO #UCCDATA FROM CLIENT_MASTER_UCC_DATA_CommonInterface WITH(nOLOCK)   
 WHERE isnull(Updation_Flag,'N')='N'   
   
 SELECT *,SPACE(1) AS ISEXIST INTO #NOMINEE FROM [CLIENT_MASTER_NOMINEE_DATA_CommonInterface] WITH(nOLOCK)   
 WHERE isnull(Updation_Flag,'N')='N'   
    

    
  UPDATE #CLIENT_DETAILS_TEMP SET ISEXIST='Y' FROM CLIENT_DETAILS A WITH(NOLOCK)  
  WHERE #CLIENT_DETAILS_TEMP.CL_CODE=A.CL_CODE  
    
    
  UPDATE #BROK_TEMP SET ISEXIST='Y' FROM CLIENT_BROK_DETAILS A WITH(NOLOCK)  
  WHERE #BROK_TEMP.CL_CODE=A.CL_CODE AND A.SEGMENT=#BROK_TEMP.SEGMENT  
  AND A.EXCHANGE=#BROK_TEMP.EXCHANGE  
    
    UPDATE #UCCDATA SET ISEXIST='Y' FROM CLIENT_MASTER_UCC_DATA A WITH(NOLOCK)  
  WHERE #UCCDATA.PARTY_CODE=A.PARTY_CODE  
    
     UPDATE #NOMINEE SET ISEXIST='Y' FROM CLIENT_MASTER_NOMINEE_DATA A WITH(NOLOCK)  
  WHERE #NOMINEE.PARTY_CODE=A.PARTY_CODE  
    
    
    
        
--INSERT INTO CLIENT_DETAILS_log        
--SELECT cl_code,branch_cd,party_code,sub_broker,trader,long_name,short_name,l_address1,l_city,l_address2,        
--l_state,l_address3,l_nation,l_zip,pan_gir_no,ward_no,sebi_regn_no,res_phone1,res_phone2,off_phone1,off_phone2,        
--mobile_pager,fax,email,cl_type,cl_status,family,region,area,p_address1,p_city,p_address2,p_state,p_address3,        
--p_nation,p_zip,p_phone,addemailid,sex,dob,introducer,approver,interactmode,passport_no,passport_issued_at,        
--passport_issued_on,passport_expires_on,licence_no,licence_issued_at,licence_issued_on,licence_expires_on,rat_card_no,        
--rat_card_issued_at,rat_card_issued_on,votersid_no,votersid_issued_at,votersid_issued_on,it_return_yr,it_return_filed_on,        
--regr_no,regr_at,regr_on,regr_authority,client_agreement_on,sett_mode,dealing_with_other_tm,other_ac_no,introducer_id,        
--introducer_relation,repatriat_bank,repatriat_bank_ac_no,chk_kyc_form,chk_corporate_deed,chk_bank_certificate,        
--chk_annual_report,chk_networth_cert,chk_corp_dtls_recd,Bank_Name,Branch_Name,AC_Type,AC_Num,Depository1,DpId1,        
--CltDpId1,Poa1,Depository2,DpId2,CltDpId2,Poa2,Depository3,DpId3,CltDpId3,Poa3,rel_mgr,c_group,sbu,Status,        
--Imp_Status,ModifidedBy,ModifidedOn,Bank_id,Mapin_id,UCC_Code,Micr_No,'SYSTEM' AS Edit_By,GETDATE() AS Edit_on,    
--Director_name,paylocation,        
--FMCode,INCOME_SLAB,NETWORTH_SLAB,PARENTCODE,PRODUCTCODE,RES_PHONE1_STD,RES_PHONE2_STD,OFF_PHONE1_STD,OFF_PHONE2_STD,        
--P_PHONE_STD        
--FROM CLIENT_DETAILS WHERE cl_code IN (        
--SELECT CL_CODE FROM #CLIENT_DETAILS_TEMP        
-- WHERE ISNULL(ISEXIST,'')='')        
         
--DELETE FROM CLIENT_DETAILS WHERE  cl_code IN (        
--SELECT CL_CODE FROM Client_Details_CommonInterface WHERE Updation_Flag='N')        
        
--------------------------------        
        
--INSERT INTO CLIENT_BROK_DETAILS_LOG        
--SELECT Cl_Code,Exchange,Segment,Brok_Scheme,Trd_Brok,Del_Brok,Ser_Tax,Ser_Tax_Method,Credit_Limit,InActive_From,        
--Print_Options,No_Of_Copies,Participant_Code,Custodian_Code,Inst_Contract,Round_Style,STP_Provider,STP_Rp_Style,        
--Market_Type,Multiplier,Charged,Maintenance,Reqd_By_Exch,Reqd_By_Broker,Client_Rating,Debit_Balance,Inter_Sett,        
--TRD_STT,Trd_Tran_Chrgs,Trd_Sebi_Fees,Trd_Stamp_Duty,Trd_Other_Chrgs,Trd_Eff_Dt,Del_Stt,Del_Tran_Chrgs,Del_SEBI_Fees,        
--Del_Stamp_Duty,Del_Other_Chrgs,Del_Eff_Dt,Rounding_Method,Round_To_Digit,Round_To_Paise,Fut_Brok,Fut_Opt_Brok,        
--Fut_Fut_Fin_Brok,Fut_Opt_Exc,Fut_Brok_Applicable,Fut_Stt,Fut_Tran_Chrgs,Fut_Sebi_Fees,Fut_Stamp_Duty,Fut_Other_Chrgs,        
--Status,Modifiedon,Modifiedby,Imp_Status,Pay_B3B_Payment,Pay_Bank_name,Pay_Branch_name,Pay_AC_No,Pay_payment_Mode,        
--Brok_Eff_Date,Inst_Trd_Brok,Inst_Del_Brok,'SYSTEM' AS Edit_By, GETDATE() AS Edit_on,SYSTEMDATE,Active_Date,CheckActiveClient,Deactive_Remarks,        
--Deactive_value FROM CLIENT_BROK_DETAILS        
--WHERE cl_code IN (        
--SELECT CL_CODE FROM Client_BROK_Details_CommonInterface WHERE Updation_Flag='N')        
        
--DELETE FROM CLIENT_BROK_DETAILS        
--WHERE cl_code IN (        
--SELECT CL_CODE FROM Client_BROK_Details_CommonInterface WHERE Updation_Flag='N')        
        
        
--INSERT INTO CLIENT_MASTER_UCC_DATA_LOG        
--SELECT PARTY_CODE,UPDATIONFLAG,RELATIONSHIP,MASTERPAN,TYPEOFFACILITY,CATEGORY,FATHERNAME,GENDER,NATIONALITY,        
--NATIONALITY_OTHER,PAN_EXEMPT,PAN_EXEMPT_CATEGORY,AADHAR_UID,IN_PERSON,IN_PERSON_DATE,PEP,DATE_OF_DECLARATION,        
--GROSS_INCOME,NET_WORTH,NET_WORTH_DATE,PROOF_OF_ID,PROOF_OF_ADDRESS,OCCUPATION,OCCUPATION_OTHER,MARITALSTATUS,        
--DATEOFCOMMENCMENT,PLACEOFINCORPRATION,STATUS,STATUS_OTHER,RES_STATUS_IND,DOCUMENTS,PERMFOREIGN_STATE,        
--PERMFOREIGN_COUNTRY,PERMFOREIGN_ADDRESS_PROFF,PERMFOREIGN_REFID,PERMFOREIGN_REFID_DATE,PLACEOFCOMM,FORMNO,        
--COR_ADDRESS_PROOF_REF_DATE,COR_ADD_PROOF_REF_ID,TRADE_CATEGORY,PROOF_ADDRESS_COMM,GROSS_ANN_COMM,PEP_COMM,        
--OCCUPATION_COMM,PROOF_ADDRESS_DET1,PROOF_ADDRESS_DET2,PROOF_ADDRESS_DET3,PROOF_ADDRESS_DET4,PROOF_ADDRESS_DET5,        
--COMM_OCC_OTHER,PANEXEMPTPROOF,PROOF_NUMBER,ISSUE_PLACE,ISSUE_DATE,GROSS_DATE,STATUS_REMARKS,PARTNERS_KARTA_UID,        
--PARTNERS_CO_PARCENER_UID,'SYSTEM' AS Edit_By, GETDATE() AS Edit_on        
--FROM CLIENT_MASTER_UCC_DATA WHERE PARTY_CODE IN (        
--SELECT PARTY_CODE FROM CLIENT_MASTER_UCC_DATA_CommonInterface WHERE Updation_Flag='N')        
        
        
        
--DELETE FROM CLIENT_MASTER_UCC_DATA        
--WHERE PARTY_CODE IN (        
--SELECT PARTY_CODE FROM CLIENT_MASTER_UCC_DATA_CommonInterface WHERE Updation_Flag='N')        
        
        
        
        
---------Client_Details Info        
INSERT INTO Client_Details        
select distinct cl_code,branch_cd,party_code,sub_broker,cast(trader as varchar(20)),long_name,short_name,l_address1,        
l_city,l_address2,l_state,l_address3,l_nation,l_zip,pan_gir_no,ward_no,        
sebi_regn_no,res_phone1,res_phone2,off_phone1,off_phone2,mobile_pager,        
fax,email,cl_type,cl_status,family,region,area,p_address1,p_city,p_address2,        
p_state,p_address3,p_nation,p_zip,p_phone,addemailid,sex,dob,introducer,approver,        
interactmode,passport_no,passport_issued_at,passport_issued_on,passport_expires_on,        
licence_no,licence_issued_at,licence_issued_on,licence_expires_on,rat_card_no,        
rat_card_issued_at,rat_card_issued_on,votersid_no,votersid_issued_at,votersid_issued_on,        
it_return_yr,it_return_filed_on,regr_no,regr_at,regr_on,regr_authority,client_agreement_on,        
sett_mode,dealing_with_other_tm,other_ac_no,introducer_id,introducer_relation,repatriat_bank,        
repatriat_bank_ac_no,chk_kyc_form,chk_corporate_deed,chk_bank_certificate,chk_annual_report,        
chk_networth_cert,chk_corp_dtls_recd,Bank_Name,Branch_Name,AC_Type,AC_Num,Depository1,DpId1,        
CltDpId1,Poa1,Depository2,DpId2,CltDpId2,Poa2,Depository3,DpId3,CltDpId3,Poa3,rel_mgr,c_group,        
sbu,Status,Imp_Status,ModifidedBy,ModifidedOn,Bank_id,Mapin_id,UCC_Code,Micr_No,Director_name,        
paylocation,FMCode,INCOME_SLAB,NETWORTH_SLAB,PARENTCODE,PRODUCTCODE,isnull(RES_PHONE1_STD,''),        
isnull(RES_PHONE2_STD,''),isnull(OFF_PHONE1_STD,''),isnull(OFF_PHONE2_STD,''),isnull(P_PHONE_STD,'')        
from #CLIENT_DETAILS_TEMP WHERE ISNULL(ISEXIST,'')=''        
        
UPDATE Client_Details_CommonInterface SET Updation_Flag='I',UPDATION_DATE=GETDATE()        
WHERE Updation_Flag='N'        
       
       
---------------------Client Brok Info        
        
        
INSERT INTO CLIENT_BROK_DETAILS        
SELECT distinct Cl_Code,Exchange,Segment,Brok_Scheme,Trd_Brok,Del_Brok,Ser_Tax,Ser_Tax_Method,        
Credit_Limit,InActive_From,Print_Options,No_Of_Copies,Participant_Code,Custodian_Code,        
Inst_Contract,Round_Style,STP_Provider,STP_Rp_Style,Market_Type,Multiplier,Charged,Maintenance,        
Reqd_By_Exch,Reqd_By_Broker,Client_Rating,Debit_Balance,Inter_Sett,TRD_STT,Trd_Tran_Chrgs,        
Trd_Sebi_Fees,Trd_Stamp_Duty,Trd_Other_Chrgs,Trd_Eff_Dt,Del_Stt,Del_Tran_Chrgs,Del_SEBI_Fees,        
Del_Stamp_Duty,Del_Other_Chrgs,Del_Eff_Dt,Rounding_Method,Round_To_Digit,Round_To_Paise,Fut_Brok,        
Fut_Opt_Brok,Fut_Fut_Fin_Brok,Fut_Opt_Exc,Fut_Brok_Applicable,Fut_Stt,Fut_Tran_Chrgs,        
Fut_Sebi_Fees,Fut_Stamp_Duty,Fut_Other_Chrgs,Status,Modifiedon,Modifiedby,Imp_Status,        
Pay_B3B_Payment,Pay_Bank_name,Pay_Branch_name,Pay_AC_No,Pay_payment_Mode,Brok_Eff_Date,        
Inst_Trd_Brok,Inst_Del_Brok,SYSTEMDATE,Active_Date,CheckActiveClient,Deactive_Remarks,        
Deactive_value        
FROM #BROK_TEMP WHERE ISNULL(ISEXIST,'')='' 
        
        
UPDATE CLIENT_BROK_DETAILS_CommonInterface SET Updation_Flag='I',UPDATION_DATE=GETDATE()        
WHERE Updation_Flag='N'        
        
        
-----------------Client UCC Details        
        
INSERT INTO CLIENT_MASTER_UCC_DATA        
select distinct PARTY_CODE,UPDATIONFLAG,RELATIONSHIP,MASTERPAN,TYPEOFFACILITY,CATEGORY,FATHERNAME,GENDER,NATIONALITY,        
NATIONALITY_OTHER,PAN_EXEMPT,PAN_EXEMPT_CATEGORY,AADHAR_UID,IN_PERSON,IN_PERSON_DATE,PEP,DATE_OF_DECLARATION,        
GROSS_INCOME,NET_WORTH,NET_WORTH_DATE,PROOF_OF_ID,PROOF_OF_ADDRESS,OCCUPATION,OCCUPATION_OTHER,MARITALSTATUS,        
DATEOFCOMMENCMENT,PLACEOFINCORPRATION,STATUS,STATUS_OTHER,RES_STATUS_IND,DOCUMENTS,PERMFOREIGN_STATE,PERMFOREIGN_COUNTRY,        
PERMFOREIGN_ADDRESS_PROFF,PERMFOREIGN_REFID,PERMFOREIGN_REFID_DATE,PLACEOFCOMM,FORMNO,COR_ADDRESS_PROOF_REF_DATE,        
COR_ADD_PROOF_REF_ID,TRADE_CATEGORY,PROOF_ADDRESS_COMM,GROSS_ANN_COMM,PEP_COMM,OCCUPATION_COMM,PROOF_ADDRESS_DET1,        
PROOF_ADDRESS_DET2,PROOF_ADDRESS_DET3,PROOF_ADDRESS_DET4,PROOF_ADDRESS_DET5,COMM_OCC_OTHER,PANEXEMPTPROOF,PROOF_NUMBER,        
ISSUE_PLACE,ISSUE_DATE,GROSS_DATE,STATUS_REMARKS,PARTNERS_KARTA_UID,PARTNERS_CO_PARCENER_UID        
 from #UCCDATA WHERE ISNULL(ISEXIST,'')=''        
        
        
UPDATE CLIENT_MASTER_UCC_DATA_CommonInterface SET Updation_Flag='I',UPDATION_DATE=GETDATE()        
WHERE Updation_Flag='N'        
        
        
--insert into CLIENT_MASTER_NOMINEE_DATA_LOG    
--SELECT PARTY_CODE,NOMINEE,RELATIONSHIP,ADDRESS1,ADDRESS2,DOB,NAMEOFGUARDIAN,    
--NOMINEEPANNO,MINORFLAG,NOMINEEPHONE,GUARDIANPHONE,GUARDIANPANNO,CIN,    
--'SYSTEM' AS Edit_By, GETDATE() AS Edit_on  from     
--[CLIENT_MASTER_NOMINEE_DATA_CommonInterface]  WHERE isnull(Updation_Flag,'N')='N'    
    
--DELETE FROM CLIENT_MASTER_NOMINEE_DATA       
--WHERE PARTY_CODE IN (        
--SELECT PARTY_CODE FROM [CLIENT_MASTER_NOMINEE_DATA_CommonInterface]     
--WHERE isnull(Updation_Flag,'N')='N')              
        
    
INSERT INTO CLIENT_MASTER_NOMINEE_DATA(PARTY_CODE,NOMINEE,RELATIONSHIP,ADDRESS1,ADDRESS2,DOB,NAMEOFGUARDIAN,    
NOMINEEPANNO,MINORFLAG,NOMINEEPHONE,GUARDIANPHONE,GUARDIANPANNO,CIN)    
  
SELECT distinct PARTY_CODE,NOMINEE,RELATIONSHIP,ADDRESS1,ADDRESS2,DOB,NAMEOFGUARDIAN,    
NOMINEEPANNO,MINORFLAG,NOMINEEPHONE,GUARDIANPHONE,GUARDIANPANNO,CIN     
FROM #NOMINEE where  isnull(ISEXIST,'')=''    
       
UPDATE [CLIENT_MASTER_NOMINEE_DATA_CommonInterface] SET Updation_Flag='I',UPDATION_DATE=GETDATE()        
WHERE isnull(Updation_Flag,'N')='N'    
    
    
    
          
COMMIT

GO
