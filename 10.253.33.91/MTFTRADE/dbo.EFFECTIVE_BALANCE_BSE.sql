-- Object: PROCEDURE dbo.EFFECTIVE_BALANCE_BSE
-- Server: 10.253.33.91 | DB: MTFTRADE
--------------------------------------------------

  
  
  
  
CREATE proc [dbo].[EFFECTIVE_BALANCE_BSE]  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
 (    
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
@TODATE   VARCHAR (11)    
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
) AS BEGIN     
  
  
  
  
  
  
  
  
  
  
  
  
  
SELECT CLTCODE ,SUM(CASE WHEN DRCR='D' THEN VAMT ELSE VAMT*-1 END) BAL INTO #BAL4  
  
  
  
FROM LEDGER WHERE VDT >='2019-04-01'   AND EDT <= @TODATE + ' 23:59:59'   
  
  
  
GROUP BY CLTCODE   
  
  
  
  
  
  
  
INSERT INTO #BAL4  
  
  
  
SELECT CLTCODE ,SUM(CASE WHEN DRCR='D' THEN VAMT*-1 ELSE VAMT END) FROM LEDGER  
  
  
  
 WHERE VDT < '2019-04-01'  AND EDT > @TODATE + ' 23:59:59'   AND  VTYP in ( '15' ,'35')  
  
  
  
 GROUP BY CLTCODE   
  
  
  
   
  
  
  
  
  
--------------------------------------------BSE  
  
  
  
  
  
  
  
SELECT CLTCODE ,SUM(CASE WHEN DRCR='D' THEN VAMT ELSE VAMT*-1 END) BAL INTO #BAL5  
  
  
  
FROM [AngelBSECM].ACCOUNT_Ab.dbo.LEDGER with (nolock) WHERE VDT >='2019-04-01'   AND EDT <= @TODATE + ' 23:59:59'   
  
  
  
GROUP BY CLTCODE   
  
  
  
  
  
  
  
INSERT INTO #BAL5  
  
  
  
SELECT CLTCODE ,SUM(CASE WHEN DRCR='D' THEN VAMT*-1 ELSE VAMT END) FROM [AngelBSECM].ACCOUNT_Ab.dbo.LEDGER with (nolock)  
  
  
  
 WHERE VDT < '2019-04-01'  AND EDT > @TODATE + ' 23:59:59'   AND  VTYP in ( '15' ,'35')  
  
  
  
 GROUP BY CLTCODE   
  
  
  
 select 'BSE'as SEGMENT,CLTCODE,SUM(BAL) BAL INTO #DATA  from #BAL5    
  
  
  
where    cltcode IN (SELECT * FROM MTFTRADE.dbo.oldnew)   
  
  
  
GROUP BY CLTCODE  
  
  
  
order by CLTCODE  
  
  
  
INSERT  INTO #DATA   
  
 select 'MTF'as SEGMENT,CLTCODE,SUM(BAL) BAL from #BAL4     
  
  
  
where    cltcode IN (SELECT * FROM oldnew)   
  
  
  
GROUP BY CLTCODE  
  
  
  
order by CLTCODE  
  
  
  
SELECT * into data12 FROM #DATA   
  
  
SELECT * FROM DATA12   
order by SEGMENT  
  
drop table DATA12  
  
  
  
END

GO
