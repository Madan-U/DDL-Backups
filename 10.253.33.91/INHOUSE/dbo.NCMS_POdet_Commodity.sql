-- Object: PROCEDURE dbo.NCMS_POdet_Commodity
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------

create Procedure [dbo].[NCMS_POdet_Commodity](@pcode as varchar(10) = null)            
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

/**************************************************************/ /* uncomment in financial year end*/
select @sdtcur=sdtcur from account.dbo.parameter where ldtcur        =
(select ldtprv from account.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )
/********************************************************************************/

--select @sdtcur=sdtnxt from account.dbo.parameter where ldtcur        =
--(select ldtprv from account.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )
            
IF @Pcode is null            
BEGIN            
  
  select distinct party_code into #PO_client from  INTRANET.cms.dbo.NCMS_Commodity_clients
   where CAST(updatedOn as date)=CAST(GETDATE() as date)
 
 Truncate table NCMS_PO            
         
 insert into NCMS_PO(ProcessDateTime,Cltcode,VBal,UCV,UnRecoCr,OtherDr)            
 select Getdate(),CLTCODE,            
  VBal=sum(case when drcr='D' then -VAMT
  when drcr='C' and ( CONVERT(datetime,cdt) not BETWEEN CONVERT(DATETIME, CONVERT(DATE, CURRENT_TIMESTAMP)) + '00:00' AND 
 CONVERT(DATETIME, CONVERT(DATE, CURRENT_TIMESTAMP)) + '23:59' or VTYP not in (2,8)) then isnull(VAMT,0.00) end),            
 UCV=sum(Case when edt > @Todate and Drcr='C' and (VTYP<>35 and isnull(enteredby,'')<>'mtf process') then -Vamt else 0 end),           
 0,0            
 from ACCOUNT.dbo.ledger a with (nolock)  join #PO_client p  on  CLTCODE=p.party_code      
 where a.VDT>=@sdtcur and a.VDT <= @ToDate and 
   not exists (select cltcode,vdt,vtyp from ACCOUNT.dbo.ledger b with (nolock)   where VDT between @ccsy and @ccse
 and a.cltcode=b.cltcode and a.vtyp=b.vtyp and vtyp=18  AND A.VNO=B.VNO      )
 group by cltcode  
 

 /**ading for unsetteled debit bill**/
 --truncate table NCMS_PO_UnsetDr
 --insert into NCMS_PO_UnsetDr(ProcessDateTime,Cltcode,VBal,UCV,UDebitV,UnRecoCr,OtherDr)            
 --select Getdate(),CLTCODE,            
 --VBal=sum(case when drcr='D' then -VAMT else VAMT end),  
 --UCV=sum(Case when edt > @Todate and Drcr='C' and (VTYP<>35 and isnull(enteredby,'')<>'mtf process') then -Vamt else 0 end),           
 --UDebitV=sum(Case when edt > @Todate and Drcr='D' and (VTYP<>35 and isnull(enteredby,'')<>'mtf process') then -Vamt else 0 end),           
 --0,0            
 --from ACCOUNT.dbo.ledger a with (nolock)  ,#PO_client p           
 --where VDT>=@sdtcur and VDT <= @ToDate and CLTCODE=p.party_code
 --/* uncomment on financial year end*/
 ---- and not exists (select cltcode,vdt,vtyp from ACCOUNT.dbo.ledger b with (nolock)   where VDT between @ccsy and @ccse
 ----and a.cltcode=b.cltcode and a.vtyp=b.vtyp and vtyp=18  AND A.VNO=B.VNO      )
 --group by cltcode           
/***/

 exec Fetch_CliUnreco_ForPO  
         
 update NCMS_PO set UNRecoCr=-b.UnRecoCr from             
 (select cltcode,SUM(Cramt) as UnRecoCr from BO_client_deposit_recno with (nolock) group by cltcode) b            
 where NCMS_PO.cltcode=b.cltcode            
         
 update NCMS_PO set OTherDr=b.Vbal from            
 (select substring(Cltcode,3,10) as Cltcode,VBAl from NCMS_PO  with (nolock) where cltcode like '98%' and VBAL < 0) b            
 where NCMS_PO.cltcode=b.cltcode  
 
   select * into #FutureCharges from ACCOUNT.dbo.ledger a with (nolock)             
 where VDT>@ToDate and VDT <= convert(varchar(11),getdate()+3)+' 23:59:59'   and drcr='d'

  select cltcode,charges=SUM(case when drcr='D' then -vamt else vamt end) into #finalchrg from #FutureCharges group by cltcode
        
 update NCMS_PO set VBal=VBal+charges from             
 (select cltcode,charges  from #finalchrg with (nolock) ) b            
 where NCMS_PO.cltcode=b.cltcode
          
    /* Bill to Bill Client */      
 select       
 CLTCODE, B2Bamt=sum(case when drcr='D' then -VAMT else VAMT end)      
 into #b2B      
 from account.dbo.ledger  with (nolock) where vtyp=15 and edt>=(CONVERT(varchar(11),getdate())) and edt<=(CONVERT(varchar(11),getdate())+' 23:59:59')      
 and cltcode in (select partyCode from intranet.cms.dbo.tbl_manualbill_mark  with (nolock) where payoutType='B')      
 group by cltcode      
      
 update NCMS_PO set vbal=b2bamt,UCV=0,UnRecoCr=0,OtherDr=0 from #b2B b where NCMS_PO.cltcode=b.cltcode      
 /* B2B End */      
        
 truncate table NCMS_PO_NSEIPO          
 insert into NCMS_PO_NSEIPO (ProcessDateTime,Cltcode,VBal,UCV,UnRecoCr,OtherDr)          
 select ProcessDateTime,substring(Cltcode,2,10) as cltcode,VBal,UCV,UnRecoCr,OtherDr           
 from NCMS_PO  with (nolock)           
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
          
 update NCMS_PO set UNRecoCr=-b.UnRecoCr from             
 (select cltcode,SUM(Cramt) as UnRecoCr from BO_client_deposit_recno with (nolock) group by cltcode) b            
 where NCMS_PO.cltcode=b.cltcode and NCMS_PO.Cltcode=@pcode            
         
 update NCMS_PO set OTherDr=b.Vbal from            
 (select substring(Cltcode,3,10) as Cltcode,VBAl from NCMS_PO  with (nolock) where cltcode like '98%' and VBAL < 0) b            
 where NCMS_PO.cltcode=b.cltcode and NCMS_PO.Cltcode=@pcode            
      
   /* Bill to Bill Client */    
 if (select COUNT(1) from intranet.cms.dbo.tbl_manualbill_mark with (nolock) where payoutType='B' and partycode=@pcode) > 0     
 BEGIN    
  update NCMS_PO set vbal=b2bamt,UCV=0,UnRecoCr=0,OtherDr=0 from     
  (    
   select     
   CLTCODE, B2Bamt=sum(case when drcr='D' then -VAMT else VAMT end)    
   from account.dbo.ledger  with (nolock) where cltcode=@pcode and    
   vtyp=15 and edt>=(CONVERT(varchar(11),getdate())) and edt<=(CONVERT(varchar(11),getdate())+' 23:59:59')    
   group by cltcode    
  ) b where NCMS_PO.cltcode=b.cltcode    
 END     
 /* B2B End */    
    
        
 delete from NCMS_PO_NSEIPO where Cltcode=@pcode            
 insert into NCMS_PO_NSEIPO (ProcessDateTime,Cltcode,VBal,UCV,UnRecoCr,OtherDr)          
 select ProcessDateTime,substring(Cltcode,2,10) as cltcode,VBal,UCV,UnRecoCr,OtherDr           
 from NCMS_PO   with (nolock)         
where substring(Cltcode,2,10)=@pcode          
             
END  


set nocount off

GO
