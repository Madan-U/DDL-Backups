-- Object: PROCEDURE dbo.PR_Client_Party_Modification
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc PR_Client_Party_Modification  
(  
 @OldPartyCode Varchar (10),  
 @NewPartyCode Varchar (10),  
 @BranchCode varchar(20),  
 @SubBrokerCode varchar(10),  
 @TraderCode varchar(20),  
 @FamilyCode varchar(10),  
 @AreaCode varchar(10),  
 @RegionCode varchar(10),  
 @StatusName varchar(50)  
)  
as  
  
Insert Into  
 Client_Party_Modification   
Values (  
  @OldPartyCode,@NewPartyCode,@BranchCode,@SubBrokerCode,@TraderCode,  
  @FamilyCode,@AreaCode,@RegionCode,0,@StatusName,GetDate(),''
 )  

insert into Client_Details
SELECT @NewPartyCode,@BranchCode,@NewPartyCode,@SubBrokerCode,@TraderCode,long_name,short_name,l_address1,l_city,
l_address2,l_state,l_address3,l_nation,l_zip,pan_gir_no,ward_no,sebi_regn_no,res_phone1,
res_phone2,off_phone1,off_phone2,mobile_pager,fax,email,cl_type,cl_status,@FamilyCode,@RegionCode,@AreaCode,
p_address1,p_city,p_address2,p_state,p_address3,p_nation,p_zip,p_phone,addemailid,sex,dob,introducer,
approver,interactmode,passport_no,passport_issued_at,passport_issued_on,passport_expires_on,licence_no,
licence_issued_at,licence_issued_on,licence_expires_on,rat_card_no,rat_card_issued_at,rat_card_issued_on,
votersid_no,votersid_issued_at,votersid_issued_on,it_return_yr,it_return_filed_on,regr_no,regr_at,regr_on,
regr_authority,client_agreement_on,sett_mode,dealing_with_other_tm,other_ac_no,introducer_id,introducer_relation,
repatriat_bank,repatriat_bank_ac_no,chk_kyc_form,chk_corporate_deed,chk_bank_certificate,chk_annual_report,
chk_networth_cert,chk_corp_dtls_recd,Bank_Name,Branch_Name,AC_Type,AC_Num,Depository1,DpId1,CltDpId1,Poa1,
Depository2,DpId2,CltDpId2,Poa2,Depository3,DpId3,CltDpId3,Poa3,rel_mgr,c_group,sbu,Status='I',Imp_Status=0,
@StatusName,ModifidedOn=GetDate(),Bank_id,Mapin_id,UCC_Code,Micr_No,Director_name,paylocation,FmCode
FROM CLIENT_DETAILS WHERE CL_CODE = @OldPartyCode

insert into Client_Details_log
SELECT cl_code,branch_cd,party_code,sub_broker,trader,long_name,short_name,l_address1,l_city,
l_address2,l_state,l_address3,l_nation,l_zip,pan_gir_no,ward_no,sebi_regn_no,res_phone1,
res_phone2,off_phone1,off_phone2,mobile_pager,fax,email,cl_type,cl_status,family,region,area,
p_address1,p_city,p_address2,p_state,p_address3,p_nation,p_zip,p_phone,addemailid,sex,dob,introducer,
approver,interactmode,passport_no,passport_issued_at,passport_issued_on,passport_expires_on,licence_no,
licence_issued_at,licence_issued_on,licence_expires_on,rat_card_no,rat_card_issued_at,rat_card_issued_on,
votersid_no,votersid_issued_at,votersid_issued_on,it_return_yr,it_return_filed_on,regr_no,regr_at,regr_on,
regr_authority,client_agreement_on,sett_mode,dealing_with_other_tm,other_ac_no,introducer_id,introducer_relation,
repatriat_bank,repatriat_bank_ac_no,chk_kyc_form,chk_corporate_deed,chk_bank_certificate,chk_annual_report,
chk_networth_cert,chk_corp_dtls_recd,Bank_Name,Branch_Name,AC_Type,AC_Num,Depository1,DpId1,CltDpId1,Poa1,
Depository2,DpId2,CltDpId2,Poa2,Depository3,DpId3,CltDpId3,Poa3,rel_mgr,c_group,sbu,Status,Imp_Status,
ModifidedBy,ModifidedOn,Bank_id,Mapin_id,UCC_Code,Micr_No,
@StatusName,ModifidedOn=GetDate(),
Director_name,paylocation,FmCode
FROM CLIENT_DETAILS WHERE CL_CODE = @OldPartyCode

Update CLIENT_DETAILS 
set pan_gir_no = '',
Depository1 = '', DpId1 = '', CltDpId1 = '', Poa1 = '',
Depository2 = '', DpId2 = '', CltDpId2 = '', Poa2 = '',
Depository3 = '', DpId3 = '', CltDpId3 = '', Poa3 = ''
WHERE CL_CODE = @OldPartyCode

insert into Client_brok_Details
select @NewPartyCode,Exchange,Segment,Brok_Scheme,Trd_Brok,Del_Brok,Ser_Tax,Ser_Tax_Method,Credit_Limit,InActive_From,
Print_Options,No_Of_Copies,Participant_Code,Custodian_Code,Inst_Contract,Round_Style,STP_Provider,STP_Rp_Style,
Market_Type,Multiplier,Charged,Maintenance,Reqd_By_Exch,Reqd_By_Broker,Client_Rating,Debit_Balance,Inter_Sett,
TRD_STT,Trd_Tran_Chrgs,Trd_Sebi_Fees,Trd_Stamp_Duty,Trd_Other_Chrgs,Trd_Eff_Dt=Left(GetDate(),11) + ' 23:59:59',
Del_Stt,Del_Tran_Chrgs,Del_SEBI_Fees,Del_Stamp_Duty,Del_Other_Chrgs,Del_Eff_Dt=Left(GetDate(),11) + ' 23:59:59',
Rounding_Method,Round_To_Digit,Round_To_Paise,Fut_Brok,Fut_Opt_Brok,
Fut_Fut_Fin_Brok,Fut_Opt_Exc,Fut_Brok_Applicable,Fut_Stt,Fut_Tran_Chrgs,Fut_Sebi_Fees,Fut_Stamp_Duty,Fut_Other_Chrgs,
Status='I',Modifiedon=GetDate(),@StatusName,Imp_Status=0,Pay_B3B_Payment,Pay_Bank_name,Pay_Branch_name,
Pay_AC_No,Pay_payment_Mode,Brok_Eff_Date=Left(GetDate(),11),
Inst_Trd_Brok,Inst_Del_Brok,SYSTEMDATE=GetDate(),Active_Date=GetDate(),CheckActiveClient 
from Client_brok_Details
WHERE CL_CODE = @OldPartyCode

GO
