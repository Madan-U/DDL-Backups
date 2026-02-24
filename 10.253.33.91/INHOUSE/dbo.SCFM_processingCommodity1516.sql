-- Object: PROCEDURE dbo.SCFM_processingCommodity1516
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------

--exec SCFM_processingCommodity1516 'mar 31 2015 23:59:59:000','apr  1 2015 23:59:59'          



CREATE procedure [dbo].[SCFM_processingCommodity1516]          



(          



@startdate datetime,          



@enddate datetime          



)          



as          



          



set nocount on           



          



/*          



Declare @startdate datetime,@enddate datetime          



 set @startdate='mar 31 2015 23:59:59:000'          



 set @enddate='apr  1 2015 23:59:59'          



 */          



          



 select cltcode,NETAMT=sum(case when drcr='D' then -VAMT else VAMT end)          



 into #mcdx        



 from ANGELCOMMODITY.ACCOUNTMCDX.dbo.ledger where vdt >@startdate          



 and edt <=@enddate          

 

 --and cltcode between 'a' and 'zzzz9999'          



 group by cltcode          



 select cltcode,NETAMT=sum(case when drcr='D' then -VAMT else VAMT end)          



 into #ncdx          



 from ANGELCOMMODITY.ACCOUNTNCDX.dbo.ledger where vdt >@startdate          



 and edt <=@enddate          



 --and cltcode between 'a' and 'zzzz9999'          



 group by cltcode               



     







           



  select * into #ab from (          



  select * from #mcdx          



  union all          



  select * from #ncdx          



)x     



      



      



        



UPDATE  #ab SET CLTCODE =PARENTCODE FROM MSAJAG.DBO.CLIENT_DETAILS C      



WHERE  CLTCODE LIKE '98%' AND CLTCODE=CL_cODE     



      



      



    



     



          



           



           



 select cltcode,sum(netamt) as Balance  into #cc from #ab where cltcode between 'a' and 'zzzz9999'  group by cltcode          



           



 --delete from #cc where Balance=0          



          



          



 delete from SCFM_FYCommodity1617 where effectivedate=@enddate          



           



 insert into SCFM_FYCommodity1617          



 select @enddate,cltcode,          



 debitamt=case when Balance<0 then Balance else 0 end,            



 creditamt=case when Balance>0 then Balance else 0 end,            



 Unrecoamt=0,          



 Marginamt=0          



 from #cc          



          



 --select * from SCFM_FY1516           



           



          



--drop table           



set nocount off

GO
