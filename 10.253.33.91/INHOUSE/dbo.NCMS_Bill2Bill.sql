-- Object: PROCEDURE dbo.NCMS_Bill2Bill
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------

CREATE Procedure NCMS_Bill2Bill(@pcode as varchar(10) = null)            
as            
            
set xact_abort on            
set nocount on            
            
declare @sdtcur as datetime,@ToDate as datetime = convert(varchar(11),getdate())+' 23:59:59'             
--select @sdtcur=sdtcur from account.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()            
            
IF @Pcode is null          
BEGIN          
    
  Truncate table NCMS_PO_B2B          
    
  
  insert into NCMS_PO_B2B(ProcessDateTime,Cltcode,B2Bamt,SettNo,SettType,NARRATION,UCV,UnRecoCr,OtherDr)          
  select Getdate(),CLTCODE,          
  B2Bamt=sum(case when drcr='D' then -VAMT else VAMT end),
  0,'',NARRATION,           
  UCV=sum(Case when edt > @Todate and Drcr='C' then -Vamt else 0 end),          
  0,0          
  from account.dbo.ledger a with (nolock)           
  where edt>=(CONVERT(varchar(11),getdate())) and edt<=(CONVERT(varchar(11),getdate())+' 23:59:59') and vtyp=15    
  and cltcode in (select partyCode from intranet.cms.dbo.tbl_manualbill_mark where payoutType='B')         
  group by cltcode,NARRATION          
         
END          
ELSE          
BEGIN          
          
 delete from NCMS_PO_B2B where Cltcode=@pcode          
    
 if (select COUNT(1) from intranet.cms.dbo.tbl_manualbill_mark with (nolock) where payoutType='B' and partycode=@pcode) > 0     
 BEGIN           
 
  insert into NCMS_PO_B2B(ProcessDateTime,Cltcode,B2Bamt,SettNo,SettType,NARRATION,UCV,UnRecoCr,OtherDr)          
  select Getdate(),CLTCODE,          
  B2Bamt=sum(case when drcr='D' then -VAMT else VAMT end),
  0,'',NARRATION,           
  UCV=sum(Case when edt > @Todate and Drcr='C' then -Vamt else 0 end),          
  0,0          
  from account.dbo.ledger a with (nolock)           
  where edt>=(CONVERT(varchar(11),getdate())) and edt<=(CONVERT(varchar(11),getdate())+' 23:59:59') and vtyp=15    
  and cltcode in (select partyCode from intranet.cms.dbo.tbl_manualbill_mark where payoutType='B')         
  group by cltcode,NARRATION  
 end    
           
END                   
            
set nocount off

GO
