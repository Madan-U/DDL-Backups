-- Object: PROCEDURE dbo.angel_shift_client1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE procedure [dbo].[angel_shift_client1]                            
as                            
                            
set nocount on                    
          
-- SET XACT_ABORT ON;        
  
declare @maxdate as varchar(11)    
set @maxdate = (select max(entrydate) from intranet.testdb.dbo.shift)  
          
-- BEGIN TRAN          
 set transaction isolation level read uncommitted                    
select * into #Shift from intranet.testdb.dbo.shift where new_kyc_code not in ( select party_code from client_Details )        
and entrydate >= @maxdate  
                     
 set transaction isolation level read uncommitted                          
 select * into #file1 from client_Details (nolock) where party_code in         
 (select old_kyc_code from #shift (nolock))        
        
 update client_Details set ModifidedON=getdate(),p_address1='NEW CODE '+b.new_kyc_Code,IMP_STATUS=0         
 from #shift b (nolock) where client_Details.party_code=b.old_kyc_code              
                    
 update #file1 set cl_code=b.new_kyc_Code,party_Code = b.new_kyc_Code,family=b.new_kyc_Code,Parentcode = b.new_kyc_Code,             
 sub_Broker=b.sub_Broker,p_Address1='OLD CODE '+b.old_kyc_code,              
 branch_Cd=b.branch,ModifidedON=getdate(),introducer_id=b.new_kyc_Code from #shift b (nolock) where #file1.party_code=b.old_kyc_code                    
               
 update #file1 set region=b.regioncode from region b where #file1.branch_cd=b.branch_code              
 update #file1 set area=b.areacode from area b where #file1.branch_cd=b.branch_code              
 --update #file1 set trader=b.branch from branch b where #file1.branch_cd=b.branch_code              
 update #file1 set trader = b.short_name from             
 (select branch_Cd,short_name=max(short_name) from branches group by branch_Cd) b            
 where #file1.branch_Cd=b.branch_cd            
               
 update #file1 set imp_status=0               
             
 insert into client_Details         
 select * from #file1 where cl_Code not in (select cl_code from client_Details)                    
             
        
                     
 --------------------- Modify Broktabkle              
               
 select * into #file2 from client_brok_details (nolock)               
 where cl_code in (select old_kyc_code from #shift (nolock) ) and inactive_from > getdate()                    
                     
 update #file2 set cl_Code = b.new_kyc_Code,active_date=convert(varchar(11),getdate()+1)+' 00:00:00'                    
 from #shift b (nolock) where #file2.cl_Code=b.old_kyc_code                    
                   
 update client_brok_details set Inactive_from=convert(varchar(11),getdate()+1)+' 00:00:00'                    
 where cl_code in (select old_kyc_code from #shift (nolock) )                  
             
          
             
 -------------------------------              
               
 select * into #nsefile from #file2 where cl_code not in              
 (select cl_Code from #file2 where exchange='NSE') and exchange <> 'NSE'              
                  
 select a.* into #nsefile1 from #nsefile a, (select cl_code,exchange=min(exchange) from #nsefile group by cl_Code) b               
 where a.cl_code=b.cl_Code and a.exchange=b.exchange              
               
 update #nsefile1 set exchange='NSE',inactive_from =active_date-1              
 update #nsefile1 set segment='CAPITAL' where segment <> 'CAPITAL'              
               
 insert into #file2 select * from #nsefile1               
             
             
 UPDATE #file2 SET pay_bank_name='UNKNOWN',pay_branch_name='MUMBAI',Pay_payment_mode='C',            
 PAY_AC_NO='UNKNOWN'            
 WHERE LTRIM(RTRIM(ISNULL(PAY_BANK_NAME,'')))=''            
               
Delete from #file2 where cl_code+'|'+exchange+'|'+segment  in         
 (select cl_code+'|'+exchange+'|'+segment from client_brok_details)        
        
Insert into client_brok_details Select * from #file2        
        
 ---------------------- Updated by Deepak  Start                        
--         
--  update DpBackOffice.AcerCross.dbo.Client_Master                           
--  set cm_blsavingcd = New_Kyc_code                           
--  from #Shift s, DpBackOffice.AcerCross.dbo.Client_Master cm                           
--  where Old_Kyc_code=cm.cm_blsavingcd                  
--            
--            
--  -- Select Top 5 * from #Shift          
--         -- Select Top 5 * from AngelBSECM.BseDb_Ab.dbo.Client4          
--         -- Select Top 5 * from AngelBSECM.BseDb_Ab.dbo.MultiCltId          
--  /*          
--  Update AngelBSECM.BseDb_Ab.dbo.Client4 Set Cl_Code = S.Party_Code , Party_Code = S.Party_Code from AngelBSECM.BseDb_Ab.dbo.Client4 C4,#Shift S where C4.Party_Code = S.Party_Code          
--  Update AngelDemat.BseDb.dbo.Client4 Set Cl_Code = S.Party_Code , Party_Code = S.Party_Code from AngelDemat.BseDb.dbo.Client4 C4,#Shift S where C4.Party_Code = S.Party_Code          
--  Update AngelBSECM.BseDb_Ab.dbo.MultiCltId Set Party_Code = S.Party_Code from AngelBSECM.BseDb_Ab.dbo.MultiCltId M,#Shift S where C4.Party_Code = M.Party_Code          
--  Update AngelDemat.BseDb.dbo.MultiCltId Set Party_Code = S.Party_Code from AngelDemat.BseDb.dbo.MultiCltId M,#Shift S where C4.Party_Code = M.Party_Code          
--           
--  Update Anand1.MSAJAG.dbo.Client4 Set Cl_Code = S.Party_Code , Party_Code = S.Party_Code from Anand1.MSAJAG.dbo.Client4 C4,#Shift S where C4.Party_Code = S.Party_Code          
--  Update AngelDemat.MSAJAG.dbo.Client4 Set Cl_Code = S.Party_Code , Party_Code = S.Party_Code from AngelDemat.MSAJAG.dbo.Client4 C4,#Shift S where C4.Party_Code = S.Party_Code          
--  Update Anand1.MSAJAG.dbo.MultiCltId Set Party_Code = S.Party_Code from Anand1.MSAJAG.dbo.MultiCltId M,#Shift S where C4.Party_Code = M.Party_Code          
--  Update AngelDemat.MSAJAG.dbo.MultiCltId Set Party_Code = S.Party_Code from AngelDemat.MSAJAG.dbo.MultiCltId M,#Shift S where C4.Party_Code = M.Party_Code          
--           
--  SELECT * FROM #Shift          
--  */          
--           
--  Insert into AngelBSECM.BseDb_Ab.dbo.Client4           
--  Select S.NEW_KYC_CODE,S.NEW_KYC_CODE,Instru,BankId,CltDpId,Depository,DefDp from #Shift S ,AngelBSECM.BseDb_Ab.dbo.Client4 C4 where S.OLD_KYC_CODE = C4.Party_Code          
--  AND LTrim(RTrim(S.NEW_KYC_CODE))+LTrim(RTrim(CltDpId))+LTrim(RTrim(DefDp)) not in           
--  (Select LTrim(RTrim(Party_Code))+LTrim(RTrim(CltDpId))+LTrim(RTrim(DefDp)) from AngelBSECM.BseDb_Ab.dbo.Client4 )          
--           
--           
--  Insert into AngelDemat.BseDb.dbo.Client4           
--  Select S.NEW_KYC_CODE,S.NEW_KYC_CODE,Instru,BankId,CltDpId,Depository,DefDp from #Shift S ,AngelDemat.BseDb.dbo.Client4 C4 where S.OLD_KYC_CODE = C4.Party_Code          
--  AND LTrim(RTrim(S.NEW_KYC_CODE))+LTrim(RTrim(CltDpId))+LTrim(RTrim(DefDp)) not in           
--  (Select LTrim(RTrim(Party_Code))+LTrim(RTrim(CltDpId))+LTrim(RTrim(DefDp)) from AngelDemat.BseDb.dbo.Client4 )          
--           
--            
--  -- Select * from #MultiCltIdOld          Drop Table #MultiCltIdOld          
--  -- Select * from #MultiCltIdNew          Drop Table #MultiCltIdNew          
--  Select * into #MultiCltIdOld_BK from AngelBSECM.BseDb_Ab.dbo.MultiCltId where Party_Code in (Select OLD_KYC_CODE from #Shift)          
--  -- Select * into #MultiCltIdNew from AngelBSECM.BseDb_Ab.dbo.MultiCltId where Party_Code in (Select New_KYC_CODE from #Shift)          
--           
--  Update AngelBSECM.BseDb_Ab.dbo.MultiCltId Set Def = 0 from #Shift S ,AngelBSECM.BseDb_Ab.dbo.MultiCltId MC where S.OLD_KYC_CODE = MC.Party_Code          
--            
--  Insert into AngelBSECM.BseDb_Ab.dbo.MultiCltId          
--  Select S.NEW_KYC_CODE,MC.CltDpNo,MC.DPId,MC.Introducer,MC.DPType,MC.Def from #Shift S ,#MultiCltIdOld_BK MC where S.OLD_KYC_CODE = MC.Party_Code          
--  and LTrim(RTrim(S.NEW_KYC_CODE))+LTrim(RTrim(MC.CltDpNo)) not in           
--  (Select LTrim(RTrim(Party_Code))+LTrim(RTrim(CltDpNo)) from AngelBSECM.BseDb_Ab.dbo.MultiCltId)          
--           
--  Update AngelBSECM.BseDb_Ab.dbo.MultiCltId Set Def = 0 where Party_Code in (Select Party_Code from #MultiCltIdOld_BK)          
--            
--             
--  Select * into #MultiCltIdOld_BD from AngelDemat.BseDb.dbo.MultiCltId where Party_Code in (Select OLD_KYC_CODE from #Shift)          
--            
--  Insert into AngelDemat.BseDb.dbo.MultiCltId          
--  Select S.NEW_KYC_CODE,MC.CltDpNo,MC.DPId,MC.Introducer,MC.DPType,MC.Def from #Shift S ,#MultiCltIdOld_BD MC where S.OLD_KYC_CODE = MC.Party_Code          
--  and LTrim(RTrim(S.NEW_KYC_CODE))+LTrim(RTrim(MC.CltDpNo)) not in           
--  (Select LTrim(RTrim(Party_Code))+LTrim(RTrim(CltDpNo)) from AngelDemat.BseDb.dbo.MultiCltId)          
--           
--  Update AngelDemat.BSEDB.dbo.MultiCltId Set Def = 0 where Party_Code in (Select Party_Code from #MultiCltIdOld_BD)          
--           
--  Insert into Anand1.MSAJAG.dbo.Client4           
--  Select S.NEW_KYC_CODE,S.NEW_KYC_CODE,Instru,BankId,CltDpId,Depository,DefDp from #Shift S ,Anand1.MSAJAG.dbo.Client4 C4 where S.OLD_KYC_CODE = C4.Party_Code          
--  AND LTrim(RTrim(S.NEW_KYC_CODE))+LTrim(RTrim(CltDpId))+LTrim(RTrim(DefDp)) not in           
--  (Select LTrim(RTrim(Party_Code))+LTrim(RTrim(CltDpId))+LTrim(RTrim(DefDp)) from Anand1.MSAJAG.dbo.Client4 )          
--           
--           
--  Insert into AngelDemat.MSAJAG.dbo.Client4           
--  Select S.NEW_KYC_CODE,S.NEW_KYC_CODE,Instru,BankId,CltDpId,Depository,DefDp from #Shift S ,AngelDemat.MSAJAG.dbo.Client4 C4 where S.OLD_KYC_CODE = C4.Party_Code          
--  AND LTrim(RTrim(S.NEW_KYC_CODE))+LTrim(RTrim(CltDpId))+LTrim(RTrim(DefDp)) not in           
--  (Select LTrim(RTrim(Party_Code))+LTrim(RTrim(CltDpId))+LTrim(RTrim(DefDp)) from AngelDemat.MSAJAG.dbo.Client4 )          
--           
--           
--           
--  Select * into #MultiCltIdOld_NK from Anand1.MSAJAG.dbo.MultiCltId where Party_Code in (Select OLD_KYC_CODE from #Shift)          
--           
--  Insert into Anand1.MSAJAG.dbo.MultiCltId          
--  Select S.NEW_KYC_CODE,MC.CltDpNo,MC.DPId,MC.Introducer,MC.DPType,MC.Def from #Shift S ,#MultiCltIdOld_NK MC where S.OLD_KYC_CODE = MC.Party_Code          
--  and LTrim(RTrim(S.NEW_KYC_CODE))+LTrim(RTrim(MC.CltDpNo)) not in           
--  (Select LTrim(RTrim(Party_Code))+LTrim(RTrim(CltDpNo)) from Anand1.MSAJAG.dbo.MultiCltId)          
--           
--  Update Anand1.MSAJAG.dbo.MultiCltId Set Def = 0 where Party_Code in (Select Party_Code from #MultiCltIdOld_NK)          
--             
--            
--  Select * into #MultiCltIdOld_ND from AngelDemat.MSAJAG.dbo.MultiCltId where Party_Code in (Select OLD_KYC_CODE from #Shift)          
--           
--  Insert into AngelDemat.MSAJAG.dbo.MultiCltId          
--  Select S.NEW_KYC_CODE,MC.CltDpNo,MC.DPId,MC.Introducer,MC.DPType,MC.Def from #Shift S ,#MultiCltIdOld_NK MC where S.OLD_KYC_CODE = MC.Party_Code          
--  and LTrim(RTrim(S.NEW_KYC_CODE))+LTrim(RTrim(MC.CltDpNo)) not in           
--  (Select LTrim(RTrim(Party_Code))+LTrim(RTrim(CltDpNo)) from AngelDemat.MSAJAG.dbo.MultiCltId)          
--           
--  Update AngelDemat.MSAJAG.dbo.MultiCltId Set Def = 0 where Party_Code in (Select Party_Code from #MultiCltIdOld_NK)          
--           
 ---------------------- Updated by Deepak  End          
                     
 select * into #acmast from account.dbo.acmast where cltcode in (select old_kyc_code from #shift)                            
 update #acmast set cltcode = b.new_kyc_code from #shift b where #acmast.cltcode=b.old_kyc_code                             
 update #acmast set Branchcode = b.branch from #shift b where #acmast.cltcode=b.new_kyc_code                             
               
 insert into account.dbo.acmast select * from #acmast where cltcode not in (select cltcode from account.dbo.acmast )                           
               
 ------------------- THE END                            
                             
 set nocount off

GO
