-- Object: PROCEDURE dbo.SEBI_POdet_For_FinancialYearEnd
-- Server: 10.253.33.91 | DB: MTFTRADE
--------------------------------------------------


create Procedure [dbo].[SEBI_POdet_For_FinancialYearEnd](@pcode as varchar(10) = null)            
as            
            
Set nocount on                          
         
            
declare @sdtcur as datetime,@ToDate as datetime = convert(varchar(11),getdate())+' 23:59:59'             
select @sdtcur=sdtcur from account.dbo.parameter with (nolock) where sdtcur <= GETDATE() and ldtcur >=GETDATE()            
            
IF @Pcode is null            
BEGIN            
            
 Truncate table SEBI_PO            
         
 insert into SEBI_PO(ProcessDateTime,Cltcode,VBal,UCV,UnRecoCr,OtherDr)            
 select Getdate(),CLTCODE,            
 VBal=sum(case when drcr='D' then -VAMT else VAMT end),             
 /*UCV=sum(Case when edt > @Todate and Drcr='C' then -Vamt else 0 end),            */
 UCV=0,
 0,0            
 from ledger a with (nolock)             
 where VDT>=@sdtcur and VDT <= @ToDate             
 group by cltcode            
 
 /* -- Not considered in MTF--*/    
 /*    
 update SEBI_PO set UNRecoCr=-b.UnRecoCr from             
 (select cltcode,SUM(Cramt) as UnRecoCr from BO_client_deposit_recno group by cltcode) b            
 where SEBI_PO.cltcode=b.cltcode            
         
 update SEBI_PO set OTherDr=b.Vbal from            
 (select substring(Cltcode,3,10) as Cltcode,VBAl from SEBI_PO where cltcode like '98%' and VBAL < 0) b            
 where SEBI_PO.cltcode=b.cltcode            
 */         
 
 /* Bill to Bill Client */      
 select       
 CLTCODE, B2Bamt=sum(case when drcr='D' then -VAMT else VAMT end)      
 into #b2B      
 from ledger where vtyp=15 and edt>=(CONVERT(varchar(11),getdate())) and edt<=(CONVERT(varchar(11),getdate())+' 23:59:59')      
 and cltcode in (select partyCode from intranet.cms.dbo.tbl_manualbill_mark with (nolock) where payoutType='B')      
 group by cltcode      
      
 update SEBI_PO set vbal=b2bamt,UCV=0,UnRecoCr=0,OtherDr=0 from #b2B b where SEBI_PO.cltcode=b.cltcode      
 /* B2B End */      
 
 /*       
 truncate table SEBI_PO_NSEIPO          
 insert into SEBI_PO_NSEIPO (ProcessDateTime,Cltcode,VBal,UCV,UnRecoCr,OtherDr)          
 select ProcessDateTime,substring(Cltcode,2,10) as cltcode,VBal,UCV,UnRecoCr,OtherDr           
 from SEBI_PO           
 where cltcode like '6%' and ISNUMERIC(cltcode)=0          
   */        
           
END            

set nocount off

GO
