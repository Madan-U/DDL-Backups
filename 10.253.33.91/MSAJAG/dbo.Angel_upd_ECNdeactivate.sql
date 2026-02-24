-- Object: PROCEDURE dbo.Angel_upd_ECNdeactivate
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE Procedure [dbo].[Angel_upd_ECNdeactivate]                                                                    
as                
begin             
set nocount on                                                                
select a.*,left(ltrim(rtrim(b.reason)),200) as reason into #file                                                                     
from mis.testdb.dbo.ecn_Dreg_branch a                              
left outer join mis.testdb.dbo.rejected_Decn b on a.client_code=b.party_code                                                                    
where a.status='YES' and reg_status=0  and  b.status='approve'                                                                           
          
                         
                                                                     
insert into client_details_log 
                                                                  
select                                                                       
cl_code,branch_cd,party_code,sub_broker,trader,long_name,short_name,l_address1,l_city,l_address2,l_state,                  
l_address3,l_nation,l_zip,pan_gir_no,ward_no,sebi_regn_no,res_phone1,res_phone2,off_phone1,off_phone2,mobile_pager,                  
fax,email,cl_type,cl_status,family,region,area,p_address1,p_city,p_address2,p_state,p_address3,p_nation,p_zip,                  
p_phone,addemailid,sex,dob,introducer,approver,interactmode,passport_no,passport_issued_at,passport_issued_on,                  
passport_expires_on,licence_no,licence_issued_at,licence_issued_on,licence_expires_on,rat_card_no,                  
rat_card_issued_at,rat_card_issued_on,votersid_no,votersid_issued_at,votersid_issued_on,it_return_yr,                  
it_return_filed_on,regr_no,regr_at,regr_on,regr_authority,client_agreement_on,sett_mode,dealing_with_other_tm,                  
other_ac_no, introducer_id,introducer_relation,repatriat_bank,repatriat_bank_ac_no,chk_kyc_form,chk_corporate_deed,                  
chk_bank_certificate,chk_annual_report,chk_networth_cert,chk_corp_dtls_recd,Bank_Name,Branch_Name,AC_Type,                  
AC_Num,Depository1,DpId1,CltDpId1,Poa1,Depository2, DpId2,CltDpId2,Poa2,Depository3,DpId3,CltDpId3,Poa3,rel_mgr,                  
c_group,sbu,Status,Imp_Status,ModifidedBy,ModifidedOn,Bank_id,Mapin_id,UCC_Code,Micr_No,Edit_By='ECNUnReg',                  
Edit_on=getdate(),Director_name,Paylocation,FMCode,INCOME_SLAB,NETWORTH_SLAB,PARENTCODE,PRODUCTCODE,'','','','','',GST_NO,GST_LOCATION                   
from client_details where party_code in (select client_code from #file)                                                                      
  
 update client_details set repatriat_bank_ac_no='',imp_status=0,status='U',modifidedOn=getdate(),                                                            
 director_name=b.reason                                                                      
 from #file b  where  client_details.party_code=b.client_code
                                                                  
                                                                  
                                                                 
                                                                    
insert into client_Brok_details_log                                                                    
select                                                                     
Cl_Code,Exchange,Segment,Brok_Scheme,Trd_Brok,Del_Brok,Ser_Tax,Ser_Tax_Method,Credit_Limit,InActive_From,                  
Print_Options,No_Of_Copies,Participant_Code,Custodian_Code,Inst_Contract,Round_Style,STP_Provider,STP_Rp_Style,
Market_Type,Multiplier,Charged,  Maintenance,Reqd_By_Exch,Reqd_By_Broker,Client_Rating,Debit_Balance,Inter_Sett,                
TRD_STT,Trd_Tran_Chrgs,Trd_Sebi_Fees,Trd_Stamp_Duty,Trd_Other_Chrgs,Trd_Eff_Dt,Del_Stt,Del_Tran_Chrgs,Del_SEBI_Fees                  
,Del_Stamp_Duty,Del_Other_Chrgs,Del_Eff_Dt,Rounding_Method,Round_To_Digit,Round_To_Paise,Fut_Brok,Fut_Opt_Brok,                  
Fut_Fut_Fin_Brok,Fut_Opt_Exc,Fut_Brok_Applicable,Fut_Stt,Fut_Tran_Chrgs,Fut_Sebi_Fees,Fut_Stamp_Duty,                  
Fut_Other_Chrgs,Status,Modifiedon,Modifiedby,Imp_Status,Pay_B3B_Payment,Pay_Bank_name,Pay_Branch_name,Pay_AC_No,                  
Pay_payment_Mode,Brok_Eff_Date,Inst_Trd_Brok,Inst_Del_Brok,Edit_By='ECNUnReg',Edit_on=getdate(),                  
SYSTEMDATE,Active_Date,CheckActiveClient,Deactive_Remarks,Deactive_value                      
from client_Brok_details where cl_code in (select client_code from #file)                               
 
 update client_Brok_details set print_options=0,imp_status=0,status='U',modifiedOn=getdate()                                                                               
 from #file b                                                                          
 where client_Brok_details.cl_code=b.client_code   
  
  -- code for ECN DEACTIVATION SMS
  
  select a.client_code,b.mobile_pager into #SMStable from #file a 
  inner join client_details b with(Nolock) on b.cl_code=a.client_code
  
  update #SMStable set client_code=ltrim(rtrim(client_code))
  update #SMStable set mobile_pager=dbo.getCorrectMobileNo(mobile_pager)
  
Declare @Str as Varchar(11),@Dt as Varchar(11),@Tm as Varchar(5),@AP as Varchar(2)                      
Set @Str = Convert(Varchar(11),getdate(),113)                                                                                                                                                
Set @Dt = Convert(Varchar(11),getdate(),103)                                                                                    
Set @Tm = Replace(SubString(Convert(Varchar,dateadd(mi,10,getdate()),9),13,5),' ','')                                                                                                                   
Set @AP = Right(Convert(Varchar,getdate(),100),2)                                                                                                                   
                                                           
                                                                                       
------For Updating in SMS Table----------------                                                                                         
                                                           
Insert into Intranet.Sms.Dbo.Sms    
Select distinct mobile_pager,  
'Dear Customer, the Electronic contract note facility for your client code '+client_code+' has been deactivated. You will now receive all documents on your address',  
@Dt,@Tm,'P',@AP,'ECN Deactivation' from #SMStable where len(mobile_pager)=10
  
                              
TRUNCATE TABLE dbo.ecn_Unreg_client                        
INSERT INTO dbo.ecn_Unreg_client SELECT client_code FROM #FILE             
set nocount off            
end

GO
