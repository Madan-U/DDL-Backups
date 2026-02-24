-- Object: PROCEDURE dbo.angel_shift_clientDPDemat_bkp08Oct2017
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

create procedure [dbo].[angel_shift_clientDPDemat_bkp08Oct2017]                  
as                                      
                                      
set nocount on                              
                    
-- SET XACT_ABORT ON;                    
                    
-- BEGIN TRAN                    
set transaction isolation level read uncommitted                              
        
declare @maxdate as varchar(11)        
set @maxdate = (select max(entrydate) from intranet.testdb.dbo.shift)        
              
select * into  #Shift from intranet.testdb.dbo.shift where  entrydate >= @maxdate        
           
-----------------------------Anand1 server------------            
Select * into #MultiCltIdOld_NK from Anand1.MSAJAG.dbo.MultiCltId where Party_Code in (Select OLD_KYC_CODE from #Shift)                        
        
Insert into Anand1.MSAJAG.dbo.Client4                     
Select S.NEW_KYC_CODE,S.NEW_KYC_CODE,Instru,BankId,CltDpId,Depository,DefDp from #Shift S ,Anand1.MSAJAG.dbo.Client4 C4 where S.OLD_KYC_CODE = C4.Party_Code  
--AND LTrim(RTrim(S.NEW_KYC_CODE))+LTrim(RTrim(CltDpId))+LTrim(RTrim(DefDp))<> LTrim(RTrim(C4.Party_Code))+LTrim(RTrim(C4.CltDpId))+LTrim(RTrim(C4.DefDp))                    
 AND LTrim(RTrim(S.NEW_KYC_CODE))+LTrim(RTrim(CltDpId))<> LTrim(RTrim(C4.Party_Code))+LTrim(RTrim(C4.CltDpId))                   
                   
--AND LTrim(RTrim(S.NEW_KYC_CODE))+LTrim(RTrim(CltDpId))+LTrim(RTrim(DefDp)) not in                     
--(Select LTrim(RTrim(Party_Code))+LTrim(RTrim(CltDpId))+LTrim(RTrim(DefDp)) from Anand1.MSAJAG.dbo.Client4 with(nolock))             
            
Insert into Anand1.MSAJAG.dbo.MultiCltId                    
Select S.NEW_KYC_CODE,MC.CltDpNo,MC.DPId,MC.Introducer,MC.DPType,MC.Def from #Shift S ,#MultiCltIdOld_NK MC where S.OLD_KYC_CODE = MC.Party_Code  
and LTrim(RTrim(S.NEW_KYC_CODE))+LTrim(RTrim(MC.CltDpNo))<>LTrim(RTrim(MC.Party_Code))+LTrim(RTrim(MC.CltDpNo))                     
                    
--and LTrim(RTrim(S.NEW_KYC_CODE))+LTrim(RTrim(MC.CltDpNo)) not in (Select LTrim(RTrim(Party_Code))+LTrim(RTrim(CltDpNo)) from Anand1.MSAJAG.dbo.MultiCltId with(nolock))                            
            
Update Anand1.MSAJAG.dbo.MultiCltId Set Def = 0 where Party_Code in (Select Party_Code from #MultiCltIdOld_NK)                    
        
--------------------------Delete-----------        
delete from Anand1.MSAJAG.dbo.Client4 where cl_code in        
(select old_Kyc_Code from #Shift) and depository in ('CDSL','NSDL')        
        
delete from Anand1.MSAJAG.dbo.MultiCltId where party_code in        
(select old_Kyc_Code from #Shift)

GO
