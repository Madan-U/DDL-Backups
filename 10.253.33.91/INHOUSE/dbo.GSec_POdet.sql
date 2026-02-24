-- Object: PROCEDURE dbo.GSec_POdet
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------

create Procedure [dbo].[GSec_POdet](@pcode as varchar(10) = null)              
as              
              
Set nocount on                            
                   
declare @sdtcur as datetime,@ToDate as datetime = convert(varchar(11),getdate())+' 23:59:59'               
select @sdtcur=sdtcur from account.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()              
              
IF @Pcode is null              
BEGIN              
          
 Truncate table GSec_PO              
           
 insert into GSec_PO(ProcessDateTime,Cltcode,VBal,UCV,UnRecoCr,OtherDr)              
 select Getdate(),CLTCODE,              
 VBal=sum(case when drcr='D' then -VAMT else VAMT end),               
 UCV=sum(Case when edt > @Todate and Drcr='C' then -Vamt else 0 end),              
 0,0              
 from ACCOUNT.dbo.ledger a with (nolock)               
 where VDT>=@sdtcur and VDT <= @ToDate and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')              
 group by cltcode              

 exec Fetch_CliUnreco_GSec
           
 update GSec_PO set UNRecoCr=-b.UnRecoCr from               
 (select cltcode,SUM(Cramt) as UnRecoCr from BO_client_deposit_recno group by cltcode) b              
 where GSec_PO.cltcode=b.cltcode              
           
 update GSec_PO set OTherDr=b.Vbal from              
 (select substring(Cltcode,3,10) as Cltcode,VBAl from GSec_PO where cltcode like '98%' and VBAL < 0) b              
 where GSec_PO.cltcode=b.cltcode              
       
          
 truncate table GSec_PO_NSEIPO            
 insert into GSec_PO_NSEIPO (ProcessDateTime,Cltcode,VBal,UCV,UnRecoCr,OtherDr)            
 select ProcessDateTime,substring(Cltcode,2,10) as cltcode,VBal,UCV,UnRecoCr,OtherDr             
 from GSec_PO             
 where cltcode like '6%' and ISNUMERIC(cltcode)=0            

             
END              
ELSE              
BEGIN              
              
 delete from GSec_PO where Cltcode=@pcode              
           
 insert into GSec_PO(ProcessDateTime,Cltcode,VBal,UCV,UnRecoCr,OtherDr)              
 select Getdate(),CLTCODE,              
 VBal=sum(case when drcr='D' then -VAMT else VAMT end),               
 UCV=sum(Case when edt > @Todate and Drcr='C' then -Vamt else 0 end),              
 0,0              
 from ACCOUNT.dbo.ledger a with (nolock)               
 where VDT>=@sdtcur and VDT <= @ToDate and Cltcode=@pcode  and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')             
 group by cltcode              
           
 exec Fetch_CliUnreco_GSec @pcode              
            
 update GSec_PO set UNRecoCr=-b.UnRecoCr from               
 (select cltcode,SUM(Cramt) as UnRecoCr from BO_client_deposit_recno group by cltcode) b              
 where GSec_PO.cltcode=b.cltcode and GSec_PO.Cltcode=@pcode              
           
 update GSec_PO set OTherDr=b.Vbal from              
 (select substring(Cltcode,3,10) as Cltcode,VBAl from GSec_PO where cltcode like '98%' and VBAL < 0) b              
 where GSec_PO.cltcode=b.cltcode and GSec_PO.Cltcode=@pcode              
          
 delete from GSec_PO_NSEIPO where Cltcode=@pcode              
 insert into GSec_PO_NSEIPO (ProcessDateTime,Cltcode,VBal,UCV,UnRecoCr,OtherDr)            
 select ProcessDateTime,substring(Cltcode,2,10) as cltcode,VBal,UCV,UnRecoCr,OtherDr             
 from GSec_PO             
where substring(Cltcode,2,10)=@pcode            
               
END     
  
set nocount off

GO
