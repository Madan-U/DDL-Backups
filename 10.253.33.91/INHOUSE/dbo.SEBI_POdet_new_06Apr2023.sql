-- Object: PROCEDURE dbo.SEBI_POdet_new_06Apr2023
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------



Create Procedure [dbo].[SEBI_POdet_new_06Apr2023](@Flag as varchar(10) = null)            
as            
            
Set nocount on                          
         
--select distinct party_code into #aa from [196.1.115.167].sccs.dbo.sccs_clientmaster with(nolock)
--          /*where sccs_settDate_last>=convert(varchar(11),CONVERT(datetime,'1 jan 2011'))                                                                              
--          and sccs_settDate_last<convert(varchar(11),CONVERT(datetime,'16 jan 2011'))+' 23:59:59' */                                              
--          where sccs_settDate_last>=convert(varchar(11),getdate())                                                                              
--          and sccs_settDate_last<convert(varchar(11),getdate()+6)+' 23:59:59'            
--          and exclude='N'
 
         
--if @Flag='Daily'
--Begin
--	insert into #aa
--	select  distinct party_code from [196.1.115.132].cms.dbo.sccs_clientmaster_provisional with(nolock) where
--	SCCS_SettDate_Last =  DATEADD(DAY, 7 - DATEPART(WEEKDAY, GETDATE()), CAST(GETDATE() AS DATE)) and exclude='N'
--end
                      
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

select @sdtcur=sdtcur/*sdtnxt*/ from account.dbo.parameter with(nolock) where ldtcur        =
(select ldtprv from account.dbo.parameter with (nolock)  where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )
/********************************************************************************/
       
            
 Truncate table SEBI_PO            
         
 insert into SEBI_PO(ProcessDateTime,Cltcode,VBal,UCV,UnRecoCr,OtherDr)            
 select Getdate(),CLTCODE,            
 VBal=sum(case when drcr='D' then -VAMT else VAMT end),             
 /*UCV=sum(Case when edt > @Todate and Drcr='C' then -Vamt else 0 end),*/  /*Commented on 11Oct 2017 as per Bhumika's mail*/
 UCV=sum(Case when edt > @Todate and Drcr='C' and (VTYP not in (2,35) and isnull(enteredby,'')<>'mtf process') then -Vamt else 0 end),           
 0,0            
 from ACCOUNT.dbo.ledger a with (nolock)             
 where VDT>=@sdtcur and VDT <= @ToDate /*and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')             */
   --and CLTCODE in (select party_code from #aa)

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

 /**ading for unsetteled debit bill**/
 --truncate table SEBI_PO_UnsetDr
 --insert into SEBI_PO_UnsetDr(ProcessDateTime,Cltcode,VBal,UCV,UDebitV,UnRecoCr,OtherDr)            
 --select Getdate(),CLTCODE,            
 --VBal=sum(case when drcr='D' then -VAMT else VAMT end),  
 --UCV=sum(Case when edt > @Todate and Drcr='C' and (VTYP not in (2,35) and isnull(enteredby,'')<>'mtf process') then -Vamt else 0 end),           
 --UDebitV=sum(Case when edt > @Todate and Drcr='D' and (VTYP<>35 and isnull(enteredby,'')<>'mtf process') then -Vamt else 0 end),           
 --0,0            
 --from ACCOUNT.dbo.ledger a with (nolock)             
 --where VDT>=@sdtcur and VDT <= @ToDate   --and CLTCODE in (select party_code from #aa)

 -- and not exists (select cltcode,vdt,vtyp from ACCOUNT.dbo.ledger b with (nolock)   where VDT between @ccsy and @ccse
 --and a.cltcode=b.cltcode and a.vtyp=b.vtyp and vtyp=18  AND A.VNO=B.VNO      )
 --group by cltcode           
/***/

 --exec Fetch_CliUnreco  
 
SELECT  CLTCODE, SUM(VAMT*-1 ) Unreco INTO #Unreco
from  account.dbo.ledger WITH(NOLOCK)
WHERE EDT >getdate() and DRCR='C' and VTYP=2 group by CLTCODE
   
 update SEBI_PO set UNRecoCr=b.UnRecoCr from             
 (select cltcode,SUM(Unreco) as UnRecoCr from #Unreco with (nolock) group by cltcode) b            
 where SEBI_PO.cltcode=b.cltcode 
 
/* update SEBI_PO set UNRecoCr=-b.UnRecoCr from             
 (select cltcode,SUM(Cramt) as UnRecoCr from BO_client_deposit_recno with (nolock) group by cltcode) b            
 where SEBI_PO.cltcode=b.cltcode   */         
         
 update SEBI_PO set OTherDr=b.Vbal from            
 (select substring(Cltcode,3,10) as Cltcode,VBAl from SEBI_PO  with (nolock) where cltcode like '98%' and VBAL < 0) b            
 where SEBI_PO.cltcode=b.cltcode 
 
  select * into #FutureCharges from ACCOUNT.dbo.ledger a with (nolock)             
 where VDT>@ToDate and VDT <= convert(varchar(11),getdate()+3)+' 23:59:59'   and drcr='d'

  select cltcode,charges=SUM(case when drcr='D' then -vamt else vamt end) into #finalchrg from #FutureCharges group by cltcode
        
 update SEBI_PO set VBal=VBal+charges from             
 (select cltcode,charges  from #finalchrg with (nolock) ) b            
 where SEBI_PO.cltcode=b.cltcode
          
    /* Bill to Bill Client */      
 --select       
 --CLTCODE, B2Bamt=sum(case when drcr='D' then -VAMT else VAMT end)      
 --into #b2B      
 --from account.dbo.ledger  with (nolock) where vtyp=15 and edt>=(CONVERT(varchar(11),getdate())) and edt<=(CONVERT(varchar(11),getdate())+' 23:59:59')      
 --and cltcode in (select partyCode from intranet.cms.dbo.tbl_manualbill_mark  with (nolock) where payoutType='B')      
 --group by cltcode      
      
 --update SEBI_PO set vbal=b2bamt,UCV=0,UnRecoCr=0,OtherDr=0 from #b2B b where SEBI_PO.cltcode=b.cltcode      
 /* B2B End */      
        
 --truncate table SEBI_PO_NSEIPO          
 --insert into SEBI_PO_NSEIPO (ProcessDateTime,Cltcode,VBal,UCV,UnRecoCr,OtherDr)          
 --select ProcessDateTime,substring(Cltcode,2,10) as cltcode,VBal,UCV,UnRecoCr,OtherDr           
 --from SEBI_PO  with (nolock)           
 --where cltcode like '6%' and ISNUMERIC(cltcode)=0          
           
           
 
set nocount off

GO
