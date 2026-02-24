-- Object: PROCEDURE dbo.SCFM_COMMODITY
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

      

----SCFM_COMMODITY 'NOV 20 2015'      

      

      

CREATE proc [dbo].[SCFM_COMMODITY]  (      

      

@TODATE  VARCHAR (11)      

)AS      

BEGIN       



--DECLARE @FROMDATE DATETIME 

 

--SELECT @FROMDATE =sdtcur FROM PARAMETER WHERE @TODATE BETWEEN SDTCUR AND ldtcur 





      

select cltcode,NETAMT=sum(case when drcr='D' then -VAMT else VAMT end)       

into #MCDX      

from ANGELCOMMODITY.ACCOUNTMCDX.dbo.ledger where vdt >'mar 31 2017 23:59:59:000'      

and edt <@TODATE        

and cltcode between 'a' and 'zzzz9999'      

group by cltcode      

 

      

select cltcode,NETAMT=sum(case when drcr='D' then -VAMT else VAMT end)       

into #NCDX      

from ANGELCOMMODITY.ACCOUNTNCDX.dbo.ledger where vdt >'mar 31 2017 23:59:59:000'      

and edt <@TODATE        

and cltcode between 'a' and 'zzzz9999'      

group by cltcode      

      

 

   

      

       

      

       

      

select * into #ab from (      

      

select * from #MCDX      

      

union all      

      

select * from #NCDX      

      

 )x      

      

       

      

select cltcode,sum(netamt) as Balance  into #cc from #ab group by cltcode      

      

       

      

select * into #dd from #cc where balance <> 0  

  

--SELECT * FROM SURESHGHH      

      

 --SELECT   * INTO SURESHGHH  FROM #dd      

 --RETURN  

      

select sum(balance)/10000000 AS CREDITOR from #dd where balance >0      

  union all    

select sum(balance)/10000000 AS DEBITOR from #dd where balance <0      

  

--SELECT ( CASE WHEN SUM(balance) >= 0 THEN  sum(balance)/10000000  ELSE 0 END )  AS CREDITOR ,  

--(CASE WHEN SUM(balance) < 0 THEN  sum(balance)/10000000   ELSE 0 END  ) AS DEBITOR    

--FROM SURESHGHH  

  

      

      

END

GO
