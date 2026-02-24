-- Object: PROCEDURE dbo.Bond_POdet_02082017
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------

CREATE Procedure Bond_POdet_02082017(@pcode as varchar(10) = null)                
as                
                
Set nocount on                              
             
                
declare @sdtcur as datetime,@ToDate as datetime = convert(varchar(11),getdate())+' 23:59:59'                 
select @sdtcur=sdtcur from account.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()                
                
IF @Pcode is null                
BEGIN                
            
 Truncate table Bond_PO                
             
 insert into Bond_PO(ProcessDateTime,Cltcode,VBal,UCV,UnRecoCr,OtherDr)                
 select Getdate(),CLTCODE,                
 VBal=sum(case when drcr='D' then -VAMT else VAMT end),                 
 UCV=sum(Case when edt > @Todate and Drcr='C' then -Vamt else 0 end),                
 0,0                
 from ACCOUNT.dbo.ledger a with (nolock)                 
 where VDT>=@sdtcur and VDT <= @ToDate                
 group by cltcode                
  
 exec Fetch_CliUnreco_bond  
             
 update Bond_PO set UNRecoCr=-b.UnRecoCr from                 
 (select cltcode,SUM(Cramt) as UnRecoCr from BO_client_deposit_recno group by cltcode) b                
 where Bond_PO.cltcode=b.cltcode                
             
 update Bond_PO set OTherDr=b.Vbal from                
 (select substring(Cltcode,3,10) as Cltcode,VBAl from Bond_PO where cltcode like '98%' and VBAL < 0) b                
 where Bond_PO.cltcode=b.cltcode                
         
            
 truncate table Bond_PO_NSEIPO              
 insert into Bond_PO_NSEIPO (ProcessDateTime,Cltcode,VBal,UCV,UnRecoCr,OtherDr)              
 select ProcessDateTime,substring(Cltcode,2,10) as cltcode,VBal,UCV,UnRecoCr,OtherDr               
 from Bond_PO               
 where cltcode like '6%' and ISNUMERIC(cltcode)=0              
         
               
END                
ELSE                
BEGIN                
                
 delete from Bond_PO where Cltcode=@pcode                
             
 insert into Bond_PO(ProcessDateTime,Cltcode,VBal,UCV,UnRecoCr,OtherDr)                
 select Getdate(),CLTCODE,                
 VBal=sum(case when drcr='D' then -VAMT else VAMT end),                 
 UCV=sum(Case when edt > @Todate and Drcr='C' then -Vamt else 0 end),                
 0,0                
 from ACCOUNT.dbo.ledger a with (nolock)                 
 where VDT>=@sdtcur and VDT <= @ToDate and Cltcode=@pcode                
 group by cltcode                
             
 exec Fetch_CliUnreco_bond @pcode                
              
 update Bond_PO set UNRecoCr=-b.UnRecoCr from                 
 (select cltcode,SUM(Cramt) as UnRecoCr from BO_client_deposit_recno group by cltcode) b                
 where Bond_PO.cltcode=b.cltcode and Bond_PO.Cltcode=@pcode                
             
 update Bond_PO set OTherDr=b.Vbal from                
 (select substring(Cltcode,3,10) as Cltcode,VBAl from Bond_PO where cltcode like '98%' and VBAL < 0) b                
 where Bond_PO.cltcode=b.cltcode and Bond_PO.Cltcode=@pcode                
            
 delete from Bond_PO_NSEIPO where Cltcode=@pcode                
 insert into Bond_PO_NSEIPO (ProcessDateTime,Cltcode,VBal,UCV,UnRecoCr,OtherDr)              
 select ProcessDateTime,substring(Cltcode,2,10) as cltcode,VBal,UCV,UnRecoCr,OtherDr               
 from Bond_PO               
where substring(Cltcode,2,10)=@pcode              
                 
END       
    
set nocount off

GO
