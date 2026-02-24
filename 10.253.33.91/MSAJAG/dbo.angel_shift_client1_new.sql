-- Object: PROCEDURE dbo.angel_shift_client1_new
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

                          
 -- select * from Intranet.testdb.dbo.shift                        
        
        
                            
CREATE procedure [dbo].[angel_shift_client1_new]                                                                  
as                                                                  
                                                                  
set nocount on                                                          
                                                
SET XACT_ABORT ON;                                          
                          
                                     
declare @maxdate as varchar(11)                                          
set @maxdate = (select max(entrydate)-1 from Intranet.testdb.dbo.shift)                                        
   
   
                                             
-- BEGIN TRAN                                                
 set transaction isolation level read uncommitted                                                          
select * into #Shift from Intranet.testdb.dbo.shift where new_kyc_code not in ( select party_code from client_Details )                                              
and entrydate >= @maxdate                           
      
      
      
                  
  -- code for Ebroking activation and deactivation                        
delete from Inhouse.dbo.temp_OldCodeToNewCodeForOdin                  
insert into Inhouse.dbo.temp_OldCodeToNewCodeForOdin(oldcode,NewCode,EcnFlag,RtgsFlag,Processdate,Branch,Sub_Broker)                 
select Old_Kyc_Code as oldcode,New_Kyc_Code as NewCode,'N' as EcnFlag,'N' as RtgsFlag,Getdate() as NewCode,Branch,Sub_Broker from #Shift               
            
exec ABVSKYCMIS.genodinlimit.dbo.USP_OldCodeToNew_Ebrokingactivation                                     
                                                           
 set transaction isolation level read uncommitted                                                                
 select * into #file1 from client_Details (nolock) where party_code in                                               
 (select old_kyc_code from #shift (nolock))                                              
                                      
select * into #file3 from Intranet.risk.dbo.tbl_mf where UserId in                                               
 (select old_kyc_code from #shift (nolock))                                              
                                      
select * into #file4 from ABVSKYCMIS.kyc.dbo.tbl_marginfunding_entry where Fld_partycode in                                               
 (select old_kyc_code from #shift (nolock))                                              
                                              
 update client_Details set ModifidedON=getdate(),p_address1='NEW CODE '+b.new_kyc_Code,IMP_STATUS = 2                               
 from #shift b (nolock) where client_Details.party_code=b.old_kyc_code                                                    
                                      
update Intranet.risk.dbo.tbl_mf set Fld_ShiftRemarks='NEW CODE '+b.new_kyc_Code                                      
from #shift b (nolock),Intranet.risk.dbo.tbl_mf a where a.UserId=b.old_kyc_code                                                    
                                      
Exec ABVSKYCMIS.Kyc.dbo.Usp_Update_Shift                                  
                                                          
 update #file1 set cl_code = b.new_kyc_Code,party_Code = b.new_kyc_Code,family = b.new_kyc_Code,                                
 Parentcode = b.new_kyc_Code, --- Added by Amit I on 10/11/2010                                                   
 sub_Broker=b.sub_Broker,p_Address1='OLD CODE '+b.old_kyc_code,                                                    
 branch_Cd=b.branch,ModifidedON=getdate(),introducer_id=b.new_kyc_Code from #shift b (nolock) where #file1.party_code=b.old_kyc_code                                                          
                                               
 update #file1 set region=b.regioncode from region b where #file1.branch_cd=b.branch_code                                                    
 update #file1 set area=b.areacode from area b where #file1.branch_cd=b.branch_code                                                    
--update #file1 set trader=b.branch from branch b where #file1.branch_cd=b.branch_code                                 
 update #file1 set trader = b.short_name from                                                   
 (select branch_Cd,short_name=max(short_name) from branches group by branch_Cd) b                                                  
 where #file1.branch_Cd=b.branch_cd                                                  
                                                     
 update #file1 set imp_status = 2                               
                                                   
 insert into client_Details                                               
 select * from #file1 
 --where cl_Code not in (select ltrim(rtrim(cl_code)) as cl_code from client_Details with(Nolock))                                                          
                    
                                            
                                                           
 --------------------- Modify Broktabkle                                                    
                                                     
 select * into #file2 from client_brok_details (nolock)                                                     
 where cl_code in (select old_kyc_code from #shift (nolock) ) and inactive_from > getdate()                                                          
                                                           
 update #file2 set cl_Code = b.new_kyc_Code, imp_status = 2,active_date=convert(varchar(11),getdate()+1)+' 00:00:00'                           
 from #shift b (nolock) where #file2.cl_Code=b.old_kyc_code                                                          
                                                         
 update client_brok_details set imp_status = 2,Inactive_from = Convert(varchar(11),getdate()+1)+' 00:00:00',ModifiedOn=GETDATE()                            
 -- code als0 for Deactive_remarks='New Code 'NewCode' Allocated',Deactive_Value='T'                                                          
 where cl_code in (select old_kyc_code from #shift (nolock) )                           
                           
 -- code added by amit on 26/08/2011                          
 update client_brok_details set  Deactive_remarks='NewCode Allocated '+Ltrim(rtrim(s.New_Kyc_Code)),Deactive_Value='T',ModifiedOn=GETDATE()                          
   from #Shift s where ltrim(rtrim(cl_code))=ltrim(rtrim(s.OLD_Kyc_Code))                           
   -- Code end here                                    
                              
UPDATE #file2 SET pay_bank_name = 'UNKNOWN',pay_branch_name = 'MUMBAI',Pay_payment_mode = 'C',                                                  
PAY_AC_NO = 'UNKNOWN'                                                  
WHERE LTRIM(RTRIM(ISNULL(PAY_BANK_NAME,'')))=''                                                  
                                                     
Delete from #file2 where Cl_code+'|'+exchange+'|'+segment  in                                               
(Select Cl_code+'|'+exchange+'|'+segment from client_brok_details)                                              
                                                
                                                   
Insert into client_brok_details Select * from #file2 
--where cl_Code not in (select ltrim(rtrim(cl_code)) as cl_code from client_brok_Details with(Nolock))                                                 
                             
   -- code added by amit on 26/08/2011                          
update client_brok_details set  Deactive_remarks='Transfered from Old Code '+Ltrim(rtrim(s.Old_Kyc_Code)),Deactive_Value='N',ModifiedOn=GETDATE()                          
from #Shift s inner join client_brok_details b with(Nolock) on b.cl_code=s.New_Kyc_Code                          
                           
                       
--code for stroing deactive log                         
Insert into Inhouse.dbo.tbl_OldcodeToNewCode_deactive_log(Cl_Code,Exchange,segment,Active_Date,Inactive_From,Imp_Status,Deactive_Remarks,Deactive_Value,ProcessDate,ProcessBy)                         
Select b.Cl_Code,b.Exchange,b.segment,b.Active_Date,b.Inactive_From,b.Imp_Status,b.Deactive_Remarks,b.Deactive_Value,getdate(),'System' from  #Shift a inner join  client_brok_details b with(Nolock) on  ltrim(rtrim(a.Old_Kyc_COde))=ltrim(rtrim(b.cl_code)) 
  
    
      
       
                     
                        
                        
Insert into Inhouse.dbo.tbl_OldcodeToNewCode_deactive_log(Cl_Code,Exchange,segment,Active_Date,Inactive_From,Imp_Status,Deactive_Remarks,Deactive_Value,ProcessDate,ProcessBy)                         
Select b.Cl_Code,b.Exchange,b.segment,b.Active_Date,b.Inactive_From,b.Imp_Status,b.Deactive_Remarks,b.Deactive_Value,getdate(),'System' from  #Shift a inner join  client_brok_details b with(Nolock) on  ltrim(rtrim(a.NEW_Kyc_COde))=ltrim(rtrim(b.cl_code)) 
  
    
     
                     
                                          
 -- Code end here by amit                           
                                                     
--insert into #file2 select * from #nsefile1                                                     
                                      
--update #file3 set UserId=b.new_kyc_Code,Fld_ShiftRemarks='OLD CODE '+b.old_kyc_code,                                                    
--Entered_Date=getdate() from #shift b (nolock) where #file3.UserID=b.old_kyc_code                                                          
                                      
--update #file4 set Fld_PartyCode=b.new_kyc_Code,Fld_ShiftRemarks='OLD CODE '+b.old_kyc_code,                                             
--Fld_EntryDate=getdate() from #shift b (nolock) where #file4.Fld_PartyCode=b.old_kyc_code                                  
                                  
--Insert into Intranet.risk.dbo.tbl_mf                                  
--Select * from #file3                                                               
                                  
--Insert into ABVSKYCMIS.Kyc.dbo.tbl_marginfunding_entry                                  
--Select * from #file4                          
                        
                        
            
--where ltrim(rtrim(Old_Kyc_Code))+ltrim(rtrim(New_Kyc_Code)) not in (Select ltrim(rtrim(oldcode))+ltrim(rtrim(NewCode)) from Inhouse.dbo.temp_OldCodeToNewCodeForOdin with(Nolock))                
                     
                      
                  
                    
                                                   
                                                                   
 set nocount off

GO
