-- Object: PROCEDURE dbo.SP_CLIENT_M_CI
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE PROCEDURE [dbo].[SP_CLIENT_M_CI]       
AS       
       
 BEGIN TRAN      
     
 INSERT INTO CLIENT_DETAILS_LOG     
SELECT cl_code,branch_cd,party_code,sub_broker,trader,long_name,short_name,l_address1,l_city,l_address2,          
l_state,l_address3,l_nation,l_zip,pan_gir_no,ward_no,sebi_regn_no,res_phone1,res_phone2,off_phone1,off_phone2,          
mobile_pager,fax,email,cl_type,cl_status,family,region,area,p_address1,p_city,p_address2,p_state,p_address3,          
p_nation,p_zip,p_phone,addemailid,sex,dob,introducer,approver,interactmode,passport_no,passport_issued_at,          
passport_issued_on,passport_expires_on,licence_no,licence_issued_at,licence_issued_on,licence_expires_on,rat_card_no,          
rat_card_issued_at,rat_card_issued_on,votersid_no,votersid_issued_at,votersid_issued_on,it_return_yr,it_return_filed_on,          
regr_no,regr_at,regr_on,regr_authority,client_agreement_on,sett_mode,dealing_with_other_tm,other_ac_no,introducer_id,          
introducer_relation,repatriat_bank,repatriat_bank_ac_no,chk_kyc_form,chk_corporate_deed,chk_bank_certificate,          
chk_annual_report,chk_networth_cert,chk_corp_dtls_recd,Bank_Name,Branch_Name,AC_Type,AC_Num,Depository1,DpId1,          
CltDpId1,Poa1,Depository2,DpId2,CltDpId2,Poa2,Depository3,DpId3,CltDpId3,Poa3,rel_mgr,c_group,sbu,Status,          
Imp_Status,ModifidedBy,ModifidedOn,Bank_id,Mapin_id,UCC_Code,Micr_No,'SYSTEM' AS Edit_By,GETDATE() AS Edit_on,Director_name,paylocation,          
FMCode,INCOME_SLAB,NETWORTH_SLAB,PARENTCODE,PRODUCTCODE,RES_PHONE1_STD,RES_PHONE2_STD,OFF_PHONE1_STD,OFF_PHONE2_STD,          
P_PHONE_STD ,GST_NO,GST_LOCATION       
FROM CLIENT_DETAILS WHERE cl_code IN (          
SELECT CL_CODE FROM CLIENT_M_CI          
 WHERE Status ='N')        
     
     
     
 --------- MOBILE UPDATION      
 UPDATE CLIENT_DETAILS SET mobile_pager=Mobile,Imp_Status=0,ModifidedBy='OTP',ModifidedON=GETDATE()       
 FROM CLIENT_M_CI AS M      
 WHERE M.CL_CODE= CLIENT_DETAILS.cl_code      
 AND (MODI_TYPE ='M'OR MODI_TYPE ='B')      
 AND M.Status ='N'      
       
 ---------EMAIL UPDATAION      
 UPDATE CLIENT_DETAILS SET email=M.email ,Imp_Status=0,ModifidedBy='OTP',ModifidedON=GETDATE()       
 FROM CLIENT_M_CI AS M      
 WHERE M.CL_CODE= CLIENT_DETAILS.cl_code      
 AND ( MODI_TYPE ='E' OR MODI_TYPE ='B')      
 AND M.Status ='N'      
       
       
 UPDATE CLIENT_M_CI SET STATUS ='U',BOUPDTIME=GETDATE()      
 WHERE ( MODI_TYPE ='E' OR MODI_TYPE ='B' OR MODI_TYPE ='M' )    
 AND  Status ='N'   
       
 COMMIT

GO
