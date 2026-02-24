-- Object: PROCEDURE dbo.SEBI_POdet_new
-- Server: 10.253.33.91 | DB: MTFTRADE
--------------------------------------------------

    
    
CREATE Procedure [dbo].[SEBI_POdet_new](@flag as varchar(10) = null)                
as                
                
Set nocount on                              
             
    
    
--select distinct party_code into #aaa from [196.1.115.167].sccs.dbo.sccs_clientmaster with(nolock)    
--          /*where sccs_settDate_last>=convert(varchar(11),CONVERT(datetime,'1 jan 2011'))                                                                                  
--          and sccs_settDate_last<convert(varchar(11),CONVERT(datetime,'16 jan 2011'))+' 23:59:59' */                                                  
--          where sccs_settDate_last>=convert(varchar(11),getdate())                                                                                  
--          and sccs_settDate_last<convert(varchar(11),getdate()+6)+' 23:59:59'                
--          and exclude='N'    
              
      
--if @Flag='Daily'    
--Begin    
-- insert into #aaa    
-- select  distinct party_code from [196.1.115.132].cms.dbo.sccs_clientmaster_provisional with(nolock) where    
-- SCCS_SettDate_Last =  DATEADD(DAY, 7 - DATEPART(WEEKDAY, GETDATE()), CAST(GETDATE() AS DATE)) and exclude='N'    
--end              
                          
declare @sdtcur as datetime,@ToDate as datetime = convert(varchar(11),getdate())+' 23:59:59'                 
select @sdtcur=sdtcur from account.dbo.parameter with (nolock) where sdtcur <= GETDATE() and ldtcur >=GETDATE()                
              
               
 Truncate table SEBI_PO                
             
 insert into SEBI_PO(ProcessDateTime,Cltcode,VBal,UCV,UnRecoCr,OtherDr)                
 select Getdate(),CLTCODE,                
 VBal=sum(case when drcr='D' then -VAMT else VAMT end),                 
 /*UCV=sum(Case when edt > @Todate and Drcr='C' then -Vamt else 0 end),            */    
 UCV=0,    
 0,0                
 from ledger a with (nolock)                 
 where /*VDT>=@sdtcur*/ EDT>@ToDate and VDT <= @ToDate --and drcr='D' and cltcode in (select party_code from #aaa)                
 group by cltcode        
     
 --update  a set VBal=VBal-block_amt from SEBI_PO a, [tbl_07Apr2023] b where LTRIM(rtrim(a.Cltcode))=LTRIM(rtrim(b.party_code))    
     
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
 --select           
 --CLTCODE, B2Bamt=sum(case when drcr='D' then -VAMT else VAMT end)          
 --into #b2B          
 --from ledger where vtyp=15 and edt>=(CONVERT(varchar(11),getdate())) and edt<=(CONVERT(varchar(11),getdate())+' 23:59:59')          
 --and cltcode in (select partyCode from intranet.cms.dbo.tbl_manualbill_mark with (nolock) where payoutType='B')          
 --group by cltcode          
          
 --update SEBI_PO set vbal=b2bamt,UCV=0,UnRecoCr=0,OtherDr=0 from #b2B b where SEBI_PO.cltcode=b.cltcode          
 /* B2B End */          
     
 /*           
 truncate table SEBI_PO_NSEIPO              
 insert into SEBI_PO_NSEIPO (ProcessDateTime,Cltcode,VBal,UCV,UnRecoCr,OtherDr)              
 select ProcessDateTime,substring(Cltcode,2,10) as cltcode,VBal,UCV,UnRecoCr,OtherDr               
 from SEBI_PO               
 where cltcode like '6%' and ISNUMERIC(cltcode)=0              
   */            
               
    
    
set nocount off

GO
