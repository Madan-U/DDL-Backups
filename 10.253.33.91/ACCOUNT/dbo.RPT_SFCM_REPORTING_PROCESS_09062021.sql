-- Object: PROCEDURE dbo.RPT_SFCM_REPORTING_PROCESS_09062021
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------



CREATE PROC [dbo].[RPT_SFCM_REPORTING_PROCESS] (@TODATE  DATETIME)

AS --- EXEC RPT_SFCM_REPORTING_PROCESS 'MAY 19 2021'

DECLARE @FROMDATE DATETIME

SELECT @FROMDATE =sdtcur FROM PARAMETER WHERE @TODATE BETWEEN SDTCUR AND ldtcur         
        
        
select cltcode,VTYP,NETAMT=sum(case when drcr='D' then -VAMT else VAMT end),EXCHANGE='NSE'                
 into #nsecm                  
 from ledger (NOLOCK) WHERE vdt >=@FROMDATE        
 and edt <=@todate  + ' 23:59'        
  group by cltcode ,VTYP           
        
        
 select cltcode, VTYP,NETAMT=sum(case when drcr='D' then -VAMT else VAMT end),EXCHANGE='BSE'            
 into #bsecm                  
 from anand.account_ab.dbo.ledger  WHERE vdt >=@FROMDATE        
 and edt <=@todate  + ' 23:59'        
 group by cltcode ,VTYP         
 

        
 select cltcode,VTYP,NETAMT=sum(case when drcr='D' then -VAMT else VAMT end),EXCHANGE='NSEFO'                  
 into #nsefo                  
 from angelfo.accountfo.dbo.ledger  WHERE vdt >=@FROMDATE        
 and edt <=@todate  + ' 23:59'        
 group by cltcode ,VTYP        
            
        
 select cltcode,VTYP,NETAMT=sum(case when drcr='D' then -VAMT else VAMT end),EXCHANGE='NSECD'                  
 into #nsx                  
 from angelfo.accountcurfo.dbo.ledger  WHERE vdt >=@FROMDATE        
 and edt <=@todate  + ' 23:59'        
 group by cltcode  ,VTYP          
               
        
 select cltcode,VTYP,NETAMT=sum(case when drcr='D' then -VAMT else VAMT end),EXCHANGE='MCXCD'                  
 into #mcd                  
 from angelcommodity.accountmcdxcds.dbo.ledger  WHERE vdt >=@FROMDATE        
 and edt <=@todate  + ' 23:59'        
 group by cltcode  ,VTYP          
        
        
 select cltcode,VTYP,NETAMT=sum(case when drcr='D' then -VAMT else VAMT end),EXCHANGE='MTF'                  
 into #MTF                  
 from MTFTRADE.dbo.ledger  WHERE vdt >=@FROMDATE            
 and edt <=@todate  + ' 23:59'        
 group by cltcode,VTYP
 
  select cltcode,VTYP,NETAMT=sum(case when drcr='D' then -VAMT else VAMT end),EXCHANGE='SLBS'                  
 into #SLBS                  
 from ACCOUNTSLBS.dbo.ledger  WHERE vdt >=@FROMDATE            
 and edt <=@todate  + ' 23:59'        
 group by cltcode,VTYP        
               
        
 select cltcode,VTYP,NETAMT=sum(case when drcr='D' then -VAMT else VAMT end),EXCHANGE='MCDX'                 
 into #mcx        
 from ANGELCOMMODITY.accountMcdx.dbo.ledger WHERE vdt >=@FROMDATE             
 and edt <=@todate +' 23:59'        
 --and cltcode between 'a' and 'zzzz9999'                  
 group by cltcode   ,VTYP         
        
        
 select cltcode,VTYP,NETAMT=sum(case when drcr='D' then -VAMT else VAMT end),EXCHANGE='NCDX'                  
 into #ncx                  
 from ANGELCOMMODITY.accountncdx.dbo.ledger  WHERE vdt >=@FROMDATE             
 and edt <=@todate +' 23:59'        
  --and cltcode between 'a' and 'zzzz9999'                  
 group by cltcode,VTYP          
        
  select cltcode,VTYP,NETAMT=sum(case when drcr='D' then -VAMT else VAMT end),EXCHANGE='BSEFO'                  
 into #BSEFO                  
 from ANGELCOMMODITY.accountBFO.dbo.ledger  WHERE vdt >=@FROMDATE             
 and edt <=@todate +' 23:59'        
  --and cltcode between 'a' and 'zzzz9999'              
 group by cltcode,VTYP          
        
        
        
  select cltcode,VTYP,NETAMT=sum(case when drcr='D' then -VAMT else VAMT end),EXCHANGE='BSECD'                 
 into #BSX                 
 from ANGELCOMMODITY.accountCURBFO.dbo.ledger  WHERE vdt >=@FROMDATE             
 and edt <=@todate +' 23:59'        
  --and cltcode between 'a' and 'zzzz9999'                  
 group by cltcode,VTYP              
        

  SELECT * INTO #ab FROM (                  
  SELECT * FROM #nsecm                  
  UNION ALL                  
  SELECT * FROM #bsecm                  
  UNION ALL                  
  SELECT * FROM #nsefo                  
  UNION ALL                  
  SELECT * FROM #nsx                  
  UNION ALL                  
  SELECT * FROM #mcd         
  UNION ALL                  
  SELECT * FROM #MTF        
  UNION ALL
  SELECT * FROM #SLBS
  UNION ALL        
  SELECT * FROM #mcx                  
  UNION ALL                  
  SELECT * FROM #ncx          
  UNION ALL                  
  SELECT * FROM #BSEFO          
  UNION ALL                  
  SELECT * FROM #BSX          
  )x             
        
DELETE FROM #AB WHERE CLTCODE='BBBB'


DELETE FROM SFCM_REPORTING_HISTORY WHERE REPORT_DATE BETWEEN @TODATE AND @TODATE + ' 23:59'

DELETE FROM SFCM_REPORTING_LOG WHERE REPORT_DATE BETWEEN @TODATE AND @TODATE + ' 23:59'

DELETE FROM SFCM_REPORTING WHERE REPORT_DATE BETWEEN @TODATE AND @TODATE + ' 23:59'


INSERT INTO SFCM_REPORTING_HISTORY
SELECT REPORT_DATE,CLTCODE,VTYP,BALANCE,EXCHANGE,LOG_DATE FROM SFCM_REPORTING_LOG ORDER BY REPORT_DATE

TRUNCATE TABLE SFCM_REPORTING_LOG

INSERT INTO SFCM_REPORTING_LOG
SELECT REPORT_DATE,CLTCODE,VTYP,BALANCE,EXCHANGE,RUNDATE FROM SFCM_REPORTING ORDER BY REPORT_DATE

TRUNCATE TABLE SFCM_REPORTING

INSERT INTO SFCM_REPORTING
SELECT @TODATE,CLTCODE,VTYP,NETAMT,EXCHANGE,GETDATE() FROM #AB 


SELECT 'SFCM REPORTING PROCESS RUN SUCESSFULLY !!'

GO
