-- Object: PROCEDURE dbo.upd_ECNREg
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

  
                     
                  
CREATE Procedure [dbo].[upd_ECNREg]                                                                      
as                                  
                        
/*feb 4 2011 alter by unnati set nocount on/off added in proc*/          
/*Changes to avoid SMS to Closed Account
Jira ID :https://angelbrokingpl.atlassian.net/browse/SRE-23413
Modified By : K SIVA KUMAR
Modified on : 2024-03-11
*/     



set nocount on                        
                                
DECLARE @rc INT                                                   
IF NOT EXISTS (SELECT * FROM intranet.msdb.sys.service_queues                                                   
WHERE name = N'ExternalMailQueue' AND is_receive_enabled = 1)                                                  
EXEC @rc = intranet.msdb.dbo.sysmail_start_sp                                
                                                            
select distinct CONVERT(varchar(15),CONVERT(datetime, a.reg_date,103),106) as reg_date,a.mail_id,a.tel_no,a.client_code,a.flag,a.reg_no,a.reg_status,a.entered_by,a.entered_on
into #file                                                                       
from mis.testdb.dbo.ecn_reg a with(Nolock)
inner join  client_details b  with(Nolock)
on a.Client_code=b.cl_code                                          
where a.flag=0 and ISNULL(b.email,'')<>''    

CREATE INDEX #S ON #FILE(CLIENT_CODE)


SELECT CL_CODE INTO #CLOSE_ACCOUNT FROM CLIENT_BROK_DETAILS WHERE Exists (SELECT CLIENT_CODE FROM #FILE WHERE CLIENT_CODE=CL_CODE )
AND ISNULL(DEACTIVE_VALUE,'') IN ('C','T')


DELETE FROM #FILE WHERE EXISTS  (SELECT CLIENT_CODE FROM #CLOSE_ACCOUNT WHERE CLIENT_CODE=CL_CODE)
    
    
   
                  
insert into #file                      
select b.reg_date,a.email as mail_id,a.mobile_pager as tel_no,      
a.party_code,b.flag,b.reg_no,b.reg_status,b.entered_by,b.entered_on from client_details a                      
join                      
#file b                      
on a.party_code= '98'+b.client_code  where isnull(a.email,'')<>''   
    
update #file set tel_no=mobile_pager from client_details where #file.client_code=cl_code                   
        
                                                                 
                                                                  
                      
                     
  insert into client_details_log                                                                        
select                                                                         
cl_code,branch_cd,party_code,sub_broker,trader,long_name,short_name,l_address1,l_city,l_address2,l_state,l_address3,l_nation,l_zip,pan_gir_no,ward_no,sebi_regn_no,res_phone1,res_phone2,off_phone1,off_phone2,mobile_pager,fax,email,cl_type,cl_status,family,
  
    
      
        
                          
region,area,p_address1,p_city,p_address2,p_state,p_address3,p_nation,p_zip,p_phone,addemailid,sex,dob,introducer,approver,interactmode,passport_no,passport_issued_at,passport_issued_on,passport_expires_on,licence_no,licence_issued_at,licence_issued_on,   
  
    
      
        
         
licence_expires_on,rat_card_no,rat_card_issued_at,rat_card_issued_on,votersid_no,votersid_issued_at,votersid_issued_on,it_return_yr,it_return_filed_on,regr_no,regr_at,regr_on,regr_authority,client_agreement_on,sett_mode,dealing_with_other_tm,other_ac_no, 
  
    
      
        
introducer_id,introducer_relation,repatriat_bank,repatriat_bank_ac_no,chk_kyc_form,chk_corporate_deed,chk_bank_certificate,chk_annual_report,chk_networth_cert,chk_corp_dtls_recd,Bank_Name,Branch_Name,AC_Type,AC_Num,Depository1,DpId1,CltDpId1,Poa1,        
  
    
      
        
                                             
Depository2,                                                                      
DpId2,CltDpId2,Poa2,Depository3,DpId3,CltDpId3,Poa3,rel_mgr,c_group,sbu,Status,Imp_Status,ModifidedBy,                            
ModifidedOn,Bank_id,Mapin_id,UCC_Code,Micr_No,Edit_By='ECNReg',Edit_on=getdate(),Director_name,Paylocation,FMCode                                                                    
,INCOME_SLAB,NETWORTH_SLAB,PARENTCODE,PRODUCTCODE,'','','','','' ,GST_NO,GST_LOCATION                         
                         
                                
from client_details where party_code in (select client_code from #file)       
      
 update client_details set repatriat_bank_ac_no=reg_no,imp_status=0,status='U',modifidedOn=getdate()                    
 ,modifidedBy='ECNReg' ,                                                             
 director_name=reg_date                                                                             
 from #file b                                                                 
 where client_details.party_code=b.client_code and reg_status='New'    
                              
update client_details set repatriat_bank_ac_no=reg_no,imp_status=0,status='U',modifidedOn=getdate()                    
,modifidedBy='ECNReg'                                                        
                                                         
 from #file b                                                                              
 where client_details.party_code=b.client_code  and reg_status='Old'                                                          
                                                                       
                                                                      
                                                                     
   insert into client_Brok_details_log                                                                   
select                                                                
Cl_Code,Exchange,Segment,Brok_Scheme,Trd_Brok,Del_Brok,Ser_Tax,Ser_Tax_Method,Credit_Limit,InActive_From,Print_Options,No_Of_Copies,Participant_Code,Custodian_Code,Inst_Contract,Round_Style,STP_Provider,STP_Rp_Style,Market_Type,Multiplier,Charged,       
   
    
      
        
                 
Maintenance,Reqd_By_Exch,Reqd_By_Broker,Client_Rating,Debit_Balance,Inter_Sett,TRD_STT,Trd_Tran_Chrgs,Trd_Sebi_Fees,Trd_Stamp_Duty,Trd_Other_Chrgs,Trd_Eff_Dt,Del_Stt,Del_Tran_Chrgs,Del_SEBI_Fees,Del_Stamp_Duty,Del_Other_Chrgs,Del_Eff_Dt,Rounding_Method,  
  
    
      
        
                   
Round_To_Digit,Round_To_Paise,Fut_Brok,Fut_Opt_Brok,Fut_Fut_Fin_Brok,Fut_Opt_Exc,Fut_Brok_Applicable,Fut_Stt,Fut_Tran_Chrgs,Fut_Sebi_Fees,Fut_Stamp_Duty,Fut_Other_Chrgs,Status,Modifiedon,Modifiedby,Imp_Status,Pay_B3B_Payment,Pay_Bank_name,Pay_Branch_name,
  
    
      
        
                    
Pay_AC_No,Pay_payment_Mode,Brok_Eff_Date,Inst_Trd_Brok,Inst_Del_Brok,Edit_By='ECNReg',Edit_on=getdate(),SYSTEMDATE,Active_Date,CheckActiveClient,Deactive_Remarks,Deactive_value                
                                                                      
from client_Brok_details where cl_code in (select client_code from #file)                                          
                                                                    
 update client_Brok_details set print_options=2,imp_status=0,status='U',modifiedOn=getdate(),modifiedby ='ECNReg'                                                                                
 from #file b                                                                            
 where client_Brok_details.cl_code=b.client_code      
 --and exchange not in ('MCX','NCX')              
             
                                                                     
 --update client_Brok_details set print_options=2,imp_status=0,status='U',modifiedOn=getdate(),modifiedby ='ECNReg'                                                                                
 --from #file b                                                                            
 --where client_Brok_details.cl_code=b.client_code  and exchange  in ('MCX','NCX')                                                                     
              
                                                                   
                                                                    
--and exchange not in ('MCX','NCX')                    
                                                                      
truncate table ecn_reg_client                                                                      
insert into ecn_reg_client select client_code from #file                                                   
                                                  
--Send SMS To ECN registered Client                                                  
                                                  
declare @str as varchar(500)                                                  
    
Set @str='Dear Customer, your A/C has been activated for Electronic Contract Note facility. You will start receiving contract notes on your registered email id'            
                                                  
insert into intranet.sms.dbo.sms(to_no,message,date,time,flag,ampm,purpose)                                                  
select distinct tel_no,@str,convert(varchar(11),getdate(),103),substring(convert(varchar(25),getdate()),13,5)                                                  
,'P',reverse(substring(reverse(getdate()),1,2)),'ECN Activation'                                                   
from #file where reg_status='NEW'                                                   
and len(tel_no)=10 and LEFT(tel_no,1) in ('9','8','7')    
--and tel_no like '9%'                                                  
                                                  
                                                
------------Send EMAIL                                                
                                                
   -- code commented for email as per pramita approval 25/09/2013                                           
                                                
--declare @email varchar(200),@pcode varchar(200),@mess2 as varchar(1300)                                                 
                                                                                             
--DECLARE email_EBROK_cursor CURSOR FOR                                                                                                       
--select distinct mail_id from #file where reg_status='NEW'   and mail_id not like '%ecn.sify.com'                                           
                                                                                                      
--OPEN email_EBROK_cursor                                                                                                      
                                   
--FETCH NEXT FROM email_EBROK_cursor                                                                                                       
--INTO @email                                                      
                                                
                                                   
--WHILE @@FETCH_STATUS = 0                               
--BEGIN                                                  
                                
--set @mess2='Dear Customer,                                        
                                        
--We are pleased to inform you that we have activated the ECN (Electronic Contract Notes) facility on your account with us and you will receive all your Contract Notes via e-mail with immediate effect.                                        
                                        
--This will enable you to have instant and anytime access of your transactions.                                        
                                        
--We request you to keep adequate space in your Inbox to avoid any mail bounce.                                        
                                         
--Assuring you of our personalized services at all times.                                        
                                        
--For any further assistance please feel free to revert back to us at  feedback@angeltrade.com or ecn.cso@angeltrade.com                                        
                                        
--Warm Regards,                                        
                                        
--Operations Department                                        
--Angel Broking                                         
--'                                                
--  if ISNULL(@email,'')<>''    
--  Begin                                          
-- exec intranet.msdb.dbo.sp_send_dbmail                                
-- @profile_name = 'angelecn',                                  
--  --@from='angelecn@angeltrade.com',                                              
-- @recipients =@email,                                                      
--  --@bcc='Deepak.Redekar@angeltrade.com,Pramita.Poojary@angeltrade.com,shweta.tiwari@angeltrade.com',                                                      
-- @subject='ECN Registration',--@type='text/html',                                                      
-- -- @priority='HIGH',                                                      
--  --@attachments=@attach,                                                
--  --@server='angelmail.angelbroking.com',                                                      
-- @body =@mess2                                                      
--  --print 'File send '+@tag                                                      
--  End                     
-- FETCH NEXT FROM email_EBROK_cursor                               
-- INTO @email                                                     
                                                     
--END                          
--CLOSE email_EBROK_cursor                                                                                          
--DEALLOCATE email_EBROK_cursor                 
                        
set nocount off

GO
