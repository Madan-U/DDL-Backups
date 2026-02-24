-- Object: PROCEDURE dbo.NCMS_POdet_03Apr2018
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------

create Procedure [dbo].[NCMS_POdet_03Apr2018](@pcode as varchar(10) = null)            
as            
            
Set nocount on                          
         
            
declare @sdtcur as datetime,@ToDate as datetime = convert(varchar(11),getdate())+' 23:59:59'             
select @sdtcur=sdtcur from account.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()            
            
IF @Pcode is null            
BEGIN            
            
 Truncate table NCMS_PO            
         
 insert into NCMS_PO(ProcessDateTime,Cltcode,VBal,UCV,UnRecoCr,OtherDr)            
 select Getdate(),CLTCODE,            
 VBal=sum(case when drcr='D' then -VAMT else VAMT end),             
 /*UCV=sum(Case when edt > @Todate and Drcr='C' then -Vamt else 0 end),*/  /*Commented on 11Oct 2017 as per Bhumika's mail*/
 UCV=sum(Case when edt > @Todate and Drcr='C' and (VTYP<>35 and isnull(enteredby,'')<>'mtf process') then -Vamt else 0 end),           
 0,0            
 from ACCOUNT.dbo.ledger a with (nolock)             
 where VDT>=@sdtcur and VDT <= @ToDate /*and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')             */
 group by cltcode            
         
 update NCMS_PO set UNRecoCr=-b.UnRecoCr from             
 (select cltcode,SUM(Cramt) as UnRecoCr from BO_client_deposit_recno group by cltcode) b            
 where NCMS_PO.cltcode=b.cltcode            
         
 update NCMS_PO set OTherDr=b.Vbal from            
 (select substring(Cltcode,3,10) as Cltcode,VBAl from NCMS_PO where cltcode like '98%' and VBAL < 0) b            
 where NCMS_PO.cltcode=b.cltcode            
          
    /* Bill to Bill Client */      
 select       
 CLTCODE, B2Bamt=sum(case when drcr='D' then -VAMT else VAMT end)      
 into #b2B      
 from account.dbo.ledger where vtyp=15 and edt>=(CONVERT(varchar(11),getdate())) and edt<=(CONVERT(varchar(11),getdate())+' 23:59:59')      
 and cltcode in (select partyCode from intranet.cms.dbo.tbl_manualbill_mark where payoutType='B')      
 group by cltcode      
      
 update NCMS_PO set vbal=b2bamt,UCV=0,UnRecoCr=0,OtherDr=0 from #b2B b where NCMS_PO.cltcode=b.cltcode      
 /* B2B End */      
        
 truncate table NCMS_PO_NSEIPO          
 insert into NCMS_PO_NSEIPO (ProcessDateTime,Cltcode,VBal,UCV,UnRecoCr,OtherDr)          
 select ProcessDateTime,substring(Cltcode,2,10) as cltcode,VBal,UCV,UnRecoCr,OtherDr           
 from NCMS_PO           
 where cltcode like '6%' and ISNUMERIC(cltcode)=0          
           
           
END            
ELSE            
BEGIN            
            
 delete from NCMS_PO where Cltcode=@pcode            
         
 insert into NCMS_PO(ProcessDateTime,Cltcode,VBal,UCV,UnRecoCr,OtherDr)            
 select Getdate(),CLTCODE,            
 VBal=sum(case when drcr='D' then -VAMT else VAMT end),             
 UCV=sum(Case when edt > @Todate and Drcr='C' then -Vamt else 0 end),            
 0,0            
 from ACCOUNT.dbo.ledger a with (nolock)             
 where VDT>=@sdtcur and VDT <= @ToDate and Cltcode=@pcode /*and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')            */
 group by cltcode            
         
 exec Fetch_CliUnreco @pcode            
          
 update NCMS_PO set UNRecoCr=-b.UnRecoCr from             
 (select cltcode,SUM(Cramt) as UnRecoCr from BO_client_deposit_recno group by cltcode) b            
 where NCMS_PO.cltcode=b.cltcode and NCMS_PO.Cltcode=@pcode            
         
 update NCMS_PO set OTherDr=b.Vbal from            
 (select substring(Cltcode,3,10) as Cltcode,VBAl from NCMS_PO where cltcode like '98%' and VBAL < 0) b            
 where NCMS_PO.cltcode=b.cltcode and NCMS_PO.Cltcode=@pcode            
      
   /* Bill to Bill Client */    
 if (select COUNT(1) from intranet.cms.dbo.tbl_manualbill_mark with (nolock) where payoutType='B' and partycode=@pcode) > 0     
 BEGIN    
  update NCMS_PO set vbal=b2bamt,UCV=0,UnRecoCr=0,OtherDr=0 from     
  (    
   select     
   CLTCODE, B2Bamt=sum(case when drcr='D' then -VAMT else VAMT end)    
   from account.dbo.ledger where cltcode=@pcode and    
   vtyp=15 and edt>=(CONVERT(varchar(11),getdate())) and edt<=(CONVERT(varchar(11),getdate())+' 23:59:59')    
   group by cltcode    
  ) b where NCMS_PO.cltcode=b.cltcode    
 END     
 /* B2B End */    
    
        
 delete from NCMS_PO_NSEIPO where Cltcode=@pcode            
 insert into NCMS_PO_NSEIPO (ProcessDateTime,Cltcode,VBal,UCV,UnRecoCr,OtherDr)          
 select ProcessDateTime,substring(Cltcode,2,10) as cltcode,VBal,UCV,UnRecoCr,OtherDr           
 from NCMS_PO           
where substring(Cltcode,2,10)=@pcode          
             
END   

set nocount off

GO
