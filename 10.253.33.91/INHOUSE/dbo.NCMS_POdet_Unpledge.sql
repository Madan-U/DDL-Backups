-- Object: PROCEDURE dbo.NCMS_POdet_Unpledge
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------


CREATE Procedure [dbo].[NCMS_POdet_Unpledge](@pcode as varchar(10) = null)            
as            
            
Set nocount on                          
         
            
declare @sdtcur as datetime,@ToDate as datetime = convert(varchar(11),getdate())+' 23:59:59'             
select @sdtcur=sdtcur from account.dbo.parameter with (nolock) where sdtcur <= GETDATE() and ldtcur >=GETDATE()            
--select @sdtcur=sdtcur from account.dbo.parameter where ldtcur        =
--(select ldtprv from account.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()  )



/*Code added to handle Financial year end issue on 3rd April 2017*/
/********************************************************************************/
declare @ccsy datetime,@ccse datetime
set @ccsy=@sdtcur
set @ccse=Convert(varchar(11),@sdtcur,121)+ ' 23:59:59'

--select @ccsy, @ccse


select @sdtcur=sdtcur from account.dbo.parameter where ldtcur        =
(select ldtprv from account.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )
/********************************************************************************/
            
IF @Pcode is null            
BEGIN            
            
 Truncate table Unpleadge_po            
         
 insert into Unpleadge_po(ProcessDateTime,Cltcode,VBal,UCV,UnRecoCr,OtherDr)            
 select Getdate(),CLTCODE,            
 VBal=sum(case when drcr='D' then -VAMT else VAMT end),             
 /*UCV=sum(Case when edt > @Todate and Drcr='C' then -Vamt else 0 end),*/  /*Commented on 11Oct 2017 as per Bhumika's mail*/
 UCV=sum(Case when edt > @Todate and Drcr='C' and (VTYP<>35 and isnull(enteredby,'')<>'mtf process') then -Vamt else 0 end),           
 0,0            
 from ACCOUNT.dbo.ledger a with (nolock)             
 where VDT>=@sdtcur and VDT <= @ToDate /*and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')             */
   /*Added to exclude opening balance of current year*/
  /********************************************************************************/
  and not exists (select cltcode,vdt,vtyp from ACCOUNT.dbo.ledger b with (nolock)   where VDT between @ccsy and @ccse
 and a.cltcode=b.cltcode and a.vtyp=b.vtyp and vtyp=18  AND A.VNO=B.VNO      )
 /********************************************************************************/
   /********Added on 03 Apr 2018*************/
 -- and  
 --(VTYP<>'18' or  VDT<>'2018-04-01 00:00:00.000')
 /********************************************/
 group by cltcode  

 exec Fetch_CliUnreco  
         
 update Unpleadge_po set UNRecoCr=-b.UnRecoCr from             
 (select cltcode,SUM(Cramt) as UnRecoCr from BO_client_deposit_recno with (nolock) group by cltcode) b            
 where Unpleadge_po.cltcode=b.cltcode            
         
 update Unpleadge_po set OTherDr=b.Vbal from            
 (select substring(Cltcode,3,10) as Cltcode,VBAl from Unpleadge_po  with (nolock) where cltcode like '98%' and VBAL < 0) b            
 where Unpleadge_po.cltcode=b.cltcode            
          
    /* Bill to Bill Client */      
 select       
 CLTCODE, B2Bamt=sum(case when drcr='D' then -VAMT else VAMT end)      
 into #b2B      
 from account.dbo.ledger  with (nolock) where vtyp=15 and edt>=(CONVERT(varchar(11),getdate())) and edt<=(CONVERT(varchar(11),getdate())+' 23:59:59')      
 and cltcode in (select partyCode from intranet.cms.dbo.tbl_manualbill_mark  with (nolock) where payoutType='B')      
 group by cltcode      
      
 update Unpleadge_po set vbal=b2bamt,UCV=0,UnRecoCr=0,OtherDr=0 from #b2B b where Unpleadge_po.cltcode=b.cltcode      
 /* B2B End */      
           
END            
ELSE            
BEGIN            
            
 delete from Unpleadge_po where Cltcode=@pcode            
         
 insert into Unpleadge_po(ProcessDateTime,Cltcode,VBal,UCV,UnRecoCr,OtherDr)            
 select Getdate(),CLTCODE,            
 VBal=sum(case when drcr='D' then -VAMT else VAMT end),             
 UCV=sum(Case when edt > @Todate and Drcr='C' then -Vamt else 0 end),            
 0,0            
 from ACCOUNT.dbo.ledger a with (nolock)             
 where VDT>=@sdtcur and VDT <= @ToDate and Cltcode=@pcode /*and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')            */
     /*Added to exclude opening balance of current year*/
  /********************************************************************************/
  and not exists (select cltcode,vdt,vtyp from ACCOUNT.dbo.ledger b with (nolock)   where VDT between @ccsy and @ccse
 and a.cltcode=b.cltcode and a.vtyp=b.vtyp and vtyp=18   AND A.VNO=B.VNO     )
 /********************************************************************************/ 
   /********Added on 03 Apr 2018*************/
 -- and  
 --(VTYP<>'18' or  VDT<>'2018-04-01 00:00:00.000')
 /********************************************/
 group by cltcode            
         
 exec Fetch_CliUnreco @pcode            
          
 update Unpleadge_po set UNRecoCr=-b.UnRecoCr from             
 (select cltcode,SUM(Cramt) as UnRecoCr from BO_client_deposit_recno with (nolock) group by cltcode) b            
 where Unpleadge_po.cltcode=b.cltcode and Unpleadge_po.Cltcode=@pcode            
         
 update Unpleadge_po set OTherDr=b.Vbal from            
 (select substring(Cltcode,3,10) as Cltcode,VBAl from Unpleadge_po  with (nolock) where cltcode like '98%' and VBAL < 0) b            
 where Unpleadge_po.cltcode=b.cltcode and Unpleadge_po.Cltcode=@pcode            
      
   /* Bill to Bill Client */    
 if (select COUNT(1) from intranet.cms.dbo.tbl_manualbill_mark with (nolock) where payoutType='B' and partycode=@pcode) > 0     
 BEGIN    
  update Unpleadge_po set vbal=b2bamt,UCV=0,UnRecoCr=0,OtherDr=0 from     
  (    
   select     
   CLTCODE, B2Bamt=sum(case when drcr='D' then -VAMT else VAMT end)    
   from account.dbo.ledger  with (nolock) where cltcode=@pcode and    
   vtyp=15 and edt>=(CONVERT(varchar(11),getdate())) and edt<=(CONVERT(varchar(11),getdate())+' 23:59:59')    
   group by cltcode    
  ) b where Unpleadge_po.cltcode=b.cltcode    
 END     
 /* B2B End */    
             
END   

set nocount off

GO
