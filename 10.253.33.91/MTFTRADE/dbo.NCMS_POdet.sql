-- Object: PROCEDURE dbo.NCMS_POdet
-- Server: 10.253.33.91 | DB: MTFTRADE
--------------------------------------------------

CREATE Procedure [dbo].[NCMS_POdet](@pcode as varchar(10) = null)            
as            
            
Set nocount on                          
 
if((CONVERT(VARCHAR(5),GETDATE(),108)>='06:59') and (CONVERT(VARCHAR(5),GETDATE(),108)<='23:59'))    
Begin         
update INTRANET.CMS.dbo.ncms_batch_process set StartDate=GETDATE() where srno=13
End
declare @sdtcur as datetime,@ToDate as datetime = convert(varchar(11),getdate())+' 23:59:59'             
select @sdtcur=sdtcur from account.dbo.parameter with (nolock) where sdtcur <= GETDATE() and ldtcur >=GETDATE()            
            
IF @Pcode is null            
BEGIN            
       select distinct party_code into #PO_client from  INTRANET.cms.dbo.NCMS_PO_Request_ForPayout with(nolock) 

  create index #PO_cli on #PO_client(Party_code)
       
 Truncate table NCMS_PO            
         
 insert into NCMS_PO(ProcessDateTime,Cltcode,VBal,UCV,UnRecoCr,OtherDr)            
 select Getdate(),CLTCODE,            
 VBal=sum(case when drcr='D' then -VAMT else VAMT end),             
 /*UCV=sum(Case when edt > @Todate and Drcr='C' then -Vamt else 0 end),            */
 UCV=0,
 0,0            
 from ledger a with (nolock)    ,#PO_client p           
 where VDT>=@sdtcur and VDT <= @ToDate   and CLTCODE=p.party_code          
 group by cltcode            
 
 /* -- Not considered in MTF--*/    
 /*    
 update NCMS_PO set UNRecoCr=-b.UnRecoCr from             
 (select cltcode,SUM(Cramt) as UnRecoCr from BO_client_deposit_recno group by cltcode) b            
 where NCMS_PO.cltcode=b.cltcode            
         
 update NCMS_PO set OTherDr=b.Vbal from            
 (select substring(Cltcode,3,10) as Cltcode,VBAl from NCMS_PO where cltcode like '98%' and VBAL < 0) b            
 where NCMS_PO.cltcode=b.cltcode            
 */         
 
 /* Bill to Bill Client */      
 select       
 CLTCODE, B2Bamt=sum(case when drcr='D' then -VAMT else VAMT end)      
 into #b2B      
 from ledger where vtyp=15 and edt>=(CONVERT(varchar(11),getdate())) and edt<=(CONVERT(varchar(11),getdate())+' 23:59:59')      
 and cltcode in (select partyCode from intranet.cms.dbo.tbl_manualbill_mark with (nolock) where payoutType='B')      
 group by cltcode      
      
 update NCMS_PO set vbal=b2bamt,UCV=0,UnRecoCr=0,OtherDr=0 from #b2B b where NCMS_PO.cltcode=b.cltcode      
 /* B2B End */      
 
 /*       
 truncate table NCMS_PO_NSEIPO          
 insert into NCMS_PO_NSEIPO (ProcessDateTime,Cltcode,VBal,UCV,UnRecoCr,OtherDr)          
 select ProcessDateTime,substring(Cltcode,2,10) as cltcode,VBal,UCV,UnRecoCr,OtherDr           
 from NCMS_PO           
 where cltcode like '6%' and ISNUMERIC(cltcode)=0          
   */        
           
END            
ELSE            
BEGIN            
            
 delete from NCMS_PO where Cltcode=@pcode            
         
 insert into NCMS_PO(ProcessDateTime,Cltcode,VBal,UCV,UnRecoCr,OtherDr)            
 select Getdate(),CLTCODE,            
 VBal=sum(case when drcr='D' then -VAMT else VAMT end),             
 /*UCV=sum(Case when edt > @Todate and Drcr='C' then -Vamt else 0 end),            */
 UCV=0,
 0,0            
 from ledger a with (nolock)             
 where VDT>=@sdtcur and VDT <= @ToDate and Cltcode=@pcode           
 group by cltcode            
         
/* exec Fetch_CliUnreco @pcode            */
 /*         
 update NCMS_PO set UNRecoCr=-b.UnRecoCr from             
 (select cltcode,SUM(Cramt) as UnRecoCr from BO_client_deposit_recno group by cltcode) b            
 where NCMS_PO.cltcode=b.cltcode and NCMS_PO.Cltcode=@pcode            
         
 update NCMS_PO set OTherDr=b.Vbal from            
 (select substring(Cltcode,3,10) as Cltcode,VBAl from NCMS_PO where cltcode like '98%' and VBAL < 0) b            
 where NCMS_PO.cltcode=b.cltcode and NCMS_PO.Cltcode=@pcode            
   */   
   /* Bill to Bill Client */    
 if (select COUNT(1) from intranet.cms.dbo.tbl_manualbill_mark with (nolock) where payoutType='B' and partycode=@pcode) > 0     
 BEGIN    
  update NCMS_PO set vbal=b2bamt,UCV=0,UnRecoCr=0,OtherDr=0 from     
  (    
   select     
   CLTCODE, B2Bamt=sum(case when drcr='D' then -VAMT else VAMT end)    
   from account.dbo.ledger with (nolock) where cltcode=@pcode and    
   vtyp=15 and edt>=(CONVERT(varchar(11),getdate())) and edt<=(CONVERT(varchar(11),getdate())+' 23:59:59')    
   group by cltcode    
  ) b where NCMS_PO.cltcode=b.cltcode    
 END     
 /* B2B End */    
 
 /*   
        
 delete from NCMS_PO_NSEIPO where Cltcode=@pcode            
 insert into NCMS_PO_NSEIPO (ProcessDateTime,Cltcode,VBal,UCV,UnRecoCr,OtherDr)          
 select ProcessDateTime,substring(Cltcode,2,10) as cltcode,VBal,UCV,UnRecoCr,OtherDr           
 from NCMS_PO           
where substring(Cltcode,2,10)=@pcode          
*/             
END   

if((CONVERT(VARCHAR(5),GETDATE(),108)>='06:59') and (CONVERT(VARCHAR(5),GETDATE(),108)<='23:59'))    
Begin
update INTRANET.CMS.dbo.ncms_batch_process set EndDate=GETDATE(),Flag=1 where srno=13
end
set nocount off

GO
