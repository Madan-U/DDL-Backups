-- Object: PROCEDURE dbo.PROC_MARGIN_REPORTING
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


 
--BEGIN TRAN  
  
--EXEC PROC_MARGIN_REPORTING 'JUL 20 2012','A43555','A43555'  
  
--ROLLBACK  
    
CREATE PROC [dbo].[PROC_MARGIN_REPORTING] (@SAUDA_DATE VARCHAR(11), @FROMPARTY VARCHAR(10), @TOPARTY VARCHAR(10))                    
AS                    
                    
DECLARE @PREVDATE VARCHAR(11),                    
@SETT_NO VARCHAR(7)                    
                    
SELECT @PREVDATE = LEFT(MAX(START_DATE),11) FROM SETT_MST                    
WHERE START_DATE < @SAUDA_DATE                    
AND SETT_TYPE = 'N'                    
                    
SELECT @SETT_NO = SETT_NO FROM SETT_MST                    
WHERE START_DATE between @SAUDA_DATE and @SAUDA_DATE  + ' 23:59'                  
AND SETT_TYPE = 'N'                    
                  
SELECT DISTINCT PARTY_CODE,                     
PREV_CASH = CONVERT(NUMERIC(18,4),0),                    
PREV_FD = CONVERT(NUMERIC(18,4),0),                    
PREV_BG = CONVERT(NUMERIC(18,4),0),                    
PREV_SEC = CONVERT(NUMERIC(18,4),0),                    
PREV_VAR = CONVERT(NUMERIC(18,4),0),                    
CURR_CASH = CONVERT(NUMERIC(18,4),0),                    
CURR_FD = CONVERT(NUMERIC(18,4),0),                    
CURR_BG = CONVERT(NUMERIC(18,4),0),                    
CURR_SEC = CONVERT(NUMERIC(18,4),0),                    
MAR_ADJUST = CONVERT(NUMERIC(18,4),0),                    
MAR_STATUS = CONVERT(NUMERIC(18,4),0)                    
INTO #MARGINREPORTING FROM SETTLEMENT                    
WHERE SAUDA_DATE between @SAUDA_DATE and @SAUDA_DATE  + ' 23:59'                   
AND SETT_TYPE IN ('N', 'W')                    
AND TRADE_NO NOT LIKE '%C%'                    
AND TRADEQTY > 0                     
                    
UPDATE #MARGINREPORTING SET                     
PREV_CASH = C.CASH,                    
PREV_FD = C.FD,                     
PREV_BG = C.BG,                    
PREV_SEC = C.SEC                    
FROM (                    
  SELECT PARTY_CODE,                     
  FD=SUM(CASE WHEN COLL_TYPE = 'FD'                     
     THEN FINALAMOUNT                    
     ELSE 0                     
      END),                    
  BG=SUM(CASE WHEN COLL_TYPE = 'BG'                     
     THEN FINALAMOUNT                    
     ELSE 0                     
      END),                    
  SEC=SUM(CASE WHEN COLL_TYPE = 'SEC'                     
     THEN FINALAMOUNT                    
     ELSE 0                     
      END),                    
  CASH=SUM(CASE WHEN COLL_TYPE = 'MARGIN'                     
     THEN FINALAMOUNT                    
     ELSE 0                     
      END)                    
  FROM COLLATERALDETAILS                    
  WHERE EFFDATE BETWEEN @PREVDATE AND @PREVDATE + ' 23:59'             
  AND EXCHANGE = 'NSE' AND SEGMENT = 'CAPITAL'                    
  GROUP BY PARTY_CODE                    
  ) C                    
WHERE #MARGINREPORTING.PARTY_CODE = C.PARTY_CODE                    
                    
UPDATE #MARGINREPORTING SET                     
PREV_VAR = MARGIN                    
FROM (SELECT PARTY_CODE, MARGIN = SUM(VARAMT - MTOM)                    
FROM TBL_MG02                     
WHERE MARGIN_DATE between @SAUDA_DATE and @SAUDA_DATE  + ' 23:59'                         
AND REC_TYPE = 10                    
AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY                     
AND SETT_NO < @SETT_NO                    
GROUP BY PARTY_CODE) C                    
WHERE #MARGINREPORTING.PARTY_CODE = C.PARTY_CODE                    
     
    
          
CREATE TABLE #HOLD          
(          
PARTY_CODE VARCHAR(10),          
SCRIP_CD VARCHAR(12),          
SERIES VARCHAR(3),          
CERTNO VARCHAR(16),          
QTY NUMERIC(18,0),          
PREV_CL_RATE NUMERIC(18,4),                        
CURR_CL_RATE NUMERIC(18,4),                        
PREV_VAR_RATE NUMERIC(18,4),          
CURR_VAR_RATE NUMERIC(18,4),          
FLAG INT          
)          
        
INSERT INTO #HOLD          
SELECT PARTY_CODE, SCRIP_CD, SERIES, CERTNO, QTY = SUM(QTY), PREV_CL_RATE, CURR_CL_RATE, PREV_VAR_RATE,     
CURR_VAR_RATE, FLAG = 0         
FROM OPENQUERY(ANGELDEMAT, 'SELECT * FROM MSAJAG.DBO.VW_MARGIN_REPORTING')        
WHERE DELIVERED = '0' AND SEC_PAYIN <= @PREVDATE + ' 23:59'                          
AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY        
GROUP BY PARTY_CODE, SCRIP_CD, SERIES, CERTNO, PREV_CL_RATE, CURR_CL_RATE, PREV_VAR_RATE, CURR_VAR_RATE        
          
          
       
        
INSERT INTO #HOLD          
SELECT PARTY_CODE, SCRIP_CD, SERIES, CERTNO, QTY = SUM(QTY), PREV_CL_RATE, CURR_CL_RATE, PREV_VAR_RATE, CURR_VAR_RATE, FLAG = 1         
FROM OPENQUERY(ANGELDEMAT, 'SELECT * FROM MSAJAG.DBO.VW_MARGIN_REPORTING')        
WHERE DELIVERED <> '0' AND SEC_PAYIN <= @PREVDATE + ' 23:59'  AND TRANSDATE > @PREVDATE                         
AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY        
GROUP BY PARTY_CODE, SCRIP_CD, SERIES, CERTNO, PREV_CL_RATE, CURR_CL_RATE, PREV_VAR_RATE, CURR_VAR_RATE        
        
    
INSERT INTO #HOLD          
SELECT PARTY_CODE, SCRIP_CD, SERIES, CERTNO, QTY = SUM(QTY), PREV_CL_RATE, CURR_CL_RATE, PREV_VAR_RATE, CURR_VAR_RATE, FLAG = 2         
FROM OPENQUERY(ANGELDEMAT, 'SELECT * FROM MSAJAG.DBO.VW_MARGIN_REPORTING')        
WHERE DELIVERED = '0' AND SEC_PAYIN between @SAUDA_DATE and @SAUDA_DATE + ' 23:59'      
AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY        
GROUP BY PARTY_CODE, SCRIP_CD, SERIES, CERTNO, PREV_CL_RATE, CURR_CL_RATE, PREV_VAR_RATE, CURR_VAR_RATE        
      
INSERT INTO #HOLD          
SELECT PARTY_CODE, SCRIP_CD, SERIES, CERTNO, QTY = SUM(QTY), PREV_CL_RATE, CURR_CL_RATE, PREV_VAR_RATE, CURR_VAR_RATE, FLAG = 2         
FROM OPENQUERY(ANGELDEMAT, 'SELECT * FROM MSAJAG.DBO.VW_MARGIN_REPORTING')        
WHERE DELIVERED <> '0' AND SEC_PAYIN <= @SAUDA_DATE + ' 23:59'  AND TRANSDATE > @SAUDA_DATE + ' 23:59'        
AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY        
GROUP BY PARTY_CODE, SCRIP_CD, SERIES, CERTNO, PREV_CL_RATE, CURR_CL_RATE, PREV_VAR_RATE, CURR_VAR_RATE        
      
       
------------------    
/*             
SELECT PARTY_CODE, D.SCRIP_CD, D.SERIES, CERTNO,              
QTY=SUM(QTY),               
PREV_CL_RATE = CONVERT(NUMERIC(18,4),0),              
CURR_CL_RATE = CONVERT(NUMERIC(18,4),0),              
PREV_VAR_RATE = CONVERT(NUMERIC(18,4),0),              
CURR_VAR_RATE = CONVERT(NUMERIC(18,4),0),              
FLAG = 0              
INTO #HOLD FROM ANGELDEMAT.MSAJAG.DBO.DELTRANS D, SETT_MST S, ANGELDEMAT.MSAJAG.DBO.DELIVERYDP DP              
WHERE S.SETT_NO = D.SETT_NO              
AND S.SETT_TYPE = D.SETT_TYPE              
AND DRCR = 'D'              
AND FILLER2 = 1               
AND DELIVERED = '0'              
AND DP.DPTYPE = D.BDPTYPE              
AND DP.DPID = D.BDPID              
AND DP.DPCLTNO = D.BCLTDPID              
AND CERTNO LIKE 'IN%'              
AND SEC_PAYIN <= @PREVDATE + ' 23:59'              
AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY        
AND ACCOUNTTYPE <> 'MAR'        
AND SEGMENT = 'CAPITAL'              
GROUP BY PARTY_CODE, D.SCRIP_CD, D.SERIES, CERTNO              
              
INSERT INTO #HOLD              
SELECT PARTY_CODE, D.SCRIP_CD, D.SERIES, CERTNO,              
QTY=SUM(QTY),               
PREV_CL_RATE = CONVERT(NUMERIC(18,4),0),              
CURR_CL_RATE = CONVERT(NUMERIC(18,4),0),              
PREV_VAR_RATE = CONVERT(NUMERIC(18,4),0),              
CURR_VAR_RATE = CONVERT(NUMERIC(18,4),0),              
FLAG = 1              
FROM ANGELDEMAT.MSAJAG.DBO.DELTRANS D, SETT_MST S, ANGELDEMAT.MSAJAG.DBO.DELIVERYDP DP              
WHERE S.SETT_NO = D.SETT_NO              
AND S.SETT_TYPE = D.SETT_TYPE              
AND DRCR = 'D'              
AND FILLER2 = 1               
AND DELIVERED <> '0'              
AND DP.DPTYPE = D.BDPTYPE              
AND DP.DPID = D.BDPID              
AND DP.DPCLTNO = D.BCLTDPID              
AND CERTNO LIKE 'IN%'              
AND SEC_PAYIN <= @PREVDATE + ' 23:59'              
AND TRANSDATE > @PREVDATE              
AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY              
AND ACCOUNTTYPE <> 'MAR'        
AND SEGMENT = 'CAPITAL'        
GROUP BY PARTY_CODE, D.SCRIP_CD, D.SERIES, CERTNO              
              
INSERT INTO #HOLD              
SELECT PARTY_CODE, D.SCRIP_CD, D.SERIES, CERTNO,              
QTY=SUM(QTY),               
PREV_CL_RATE = CONVERT(NUMERIC(18,4),0),              
CURR_CL_RATE = CONVERT(NUMERIC(18,4),0),              
PREV_VAR_RATE = CONVERT(NUMERIC(18,4),0),              
CURR_VAR_RATE = CONVERT(NUMERIC(18,4),0),              
FLAG = 2              
FROM ANGELDEMAT.MSAJAG.DBO.DELTRANS D, SETT_MST S, ANGELDEMAT.MSAJAG.DBO.DELIVERYDP DP              
WHERE S.SETT_NO = D.SETT_NO              
AND S.SETT_TYPE = D.SETT_TYPE              
AND DRCR = 'D'              
AND FILLER2 = 1               
AND DELIVERED = '0'              
AND DP.DPTYPE = D.BDPTYPE              
AND DP.DPID = D.BDPID              
AND DP.DPCLTNO = D.BCLTDPID              
AND CERTNO LIKE 'IN%'              
AND SEC_PAYIN between @SAUDA_DATE and @SAUDA_DATE  + ' 23:59'                   
AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY              
AND ACCOUNTTYPE <> 'MAR'        
AND SEGMENT = 'CAPITAL'        
GROUP BY PARTY_CODE, D.SCRIP_CD, D.SERIES, CERTNO              
              
INSERT INTO #HOLD              
SELECT PARTY_CODE, D.SCRIP_CD, D.SERIES, CERTNO,              
QTY=SUM(QTY),               
PREV_CL_RATE = CONVERT(NUMERIC(18,4),0),              
CURR_CL_RATE = CONVERT(NUMERIC(18,4),0),              
PREV_VAR_RATE = CONVERT(NUMERIC(18,4),0),              
CURR_VAR_RATE = CONVERT(NUMERIC(18,4),0),              
FLAG = 2              
FROM ANGELDEMAT.MSAJAG.DBO.DELTRANS D, SETT_MST S, ANGELDEMAT.MSAJAG.DBO.DELIVERYDP DP              
WHERE S.SETT_NO = D.SETT_NO              
AND S.SETT_TYPE = D.SETT_TYPE              
AND DRCR = 'D'              
AND FILLER2 = 1               
AND DELIVERED <> '0'              
AND DP.DPTYPE = D.BDPTYPE              
AND DP.DPID = D.BDPID              
AND DP.DPCLTNO = D.BCLTDPID              
AND CERTNO LIKE 'IN%'              
AND SEC_PAYIN <= @SAUDA_DATE + ' 23:59'              
AND TRANSDATE > @SAUDA_DATE + ' 23:59'              
AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY              
AND ACCOUNTTYPE <> 'MAR'        
AND SEGMENT = 'CAPITAL'        
GROUP BY PARTY_CODE, D.SCRIP_CD, D.SERIES, CERTNO              
   */           
SELECT                     
    Scrip_Cd,                     
    Series='EQ',                     
    Cl_Rate,                     
    SysDate                     
INTO #NSE_LatestClosing_1                     
FROM Closing C WITH(NOLOCK)                    
WHERE SYSDATE =                     
    (                    
          SELECT                     
                MAX(SYSDATE)                     
          FROM Closing WITH(NOLOCK)                     
          WHERE SCRIP_CD = C.SCRIP_CD                      
                And C.SERIES In ('BE', 'EQ')               
    AND SYSDATE <= @PREVDATE + ' 23:59'              
    )                    
And SERIES In ('BE', 'EQ')                    
              
INSERT INTO #NSE_LatestClosing_1                     
SELECT                     
    Scrip_Cd,                     
    Series,                     
    Cl_Rate,                     
    SysDate                     
FROM Closing C WITH(NOLOCK)                    
WHERE SYSDATE =                     
    (                    
          SELECT                     
                MAX(SYSDATE)                     
    FROM Closing WITH(NOLOCK)                     
          WHERE SCRIP_CD = C.SCRIP_CD                      
                And SERIES = C.SERIES                 
  AND SYSDATE <= @PREVDATE + ' 23:59'                  
    )                    
And SERIES Not In ('BE', 'EQ')                 
              
SELECT                     
    Scrip_Cd,                     
    Series='EQ',                     
    Cl_Rate,                     
    SysDate                     
INTO #NSE_LatestClosing_2                     
FROM Closing C WITH(NOLOCK)                    
WHERE SYSDATE =                     
    (             
          SELECT                     
                MAX(SYSDATE)                     
          FROM Closing WITH(NOLOCK)                     
          WHERE SCRIP_CD = C.SCRIP_CD                      
                And C.SERIES In ('BE', 'EQ')               
    AND SYSDATE <= @SAUDA_DATE + ' 23:59'              
    )                    
And SERIES In ('BE', 'EQ')                    
              
INSERT INTO #NSE_LatestClosing_2                     
SELECT                     
    Scrip_Cd,                     
    Series,                     
    Cl_Rate,                     
    SysDate      
FROM Closing C WITH(NOLOCK)                    
WHERE SYSDATE =                     
    (                    
          SELECT                     
        MAX(SYSDATE)                     
          FROM Closing WITH(NOLOCK)                     
          WHERE SCRIP_CD = C.SCRIP_CD                      
                And SERIES = C.SERIES                 
  AND SYSDATE <= @SAUDA_DATE + ' 23:59'                  
    )                    
And SERIES Not In ('BE', 'EQ')                 
              
UPDATE #HOLD SET PREV_CL_RATE = C.CL_RATE              
FROM #NSE_LatestClosing_1 C                
WHERE C.Scrip_Cd = #HOLD.Scrip_Cd                                
And C.Series = (Case When #HOLD.Series In ('EQ', 'BE')                 
       Then 'EQ'                 
       Else #HOLD.Series                 
  End)              
              
UPDATE #HOLD SET CURR_CL_RATE = C.CL_RATE              
FROM #NSE_LatestClosing_2 C                
WHERE C.Scrip_Cd = #HOLD.Scrip_Cd                                
And C.Series = (Case When #HOLD.Series In ('EQ', 'BE')                 
       Then 'EQ'                 
       Else #HOLD.Series                 
  End)              
              
UPDATE #HOLD              
SET PREV_VAR_RATE = Varmarginrate              
FROM vardetail V, Varcontrol C              
Where V.DetailKey = C.DetailKey              
AND V.SCRIP_CD = #HOLD.SCRIP_CD              
AND V.SERIES IN ('EQ', 'BE')              
AND #HOLD.SERIES IN ('EQ', 'BE')              
AND C.RECDATE between @PREVDATE and @PREVDATE  + ' 23:59'                   
              
UPDATE #HOLD              
SET PREV_VAR_RATE = Varmarginrate              
FROM vardetail V, Varcontrol C              
Where V.DetailKey = C.DetailKey              
AND V.SCRIP_CD = #HOLD.SCRIP_CD              
AND V.SERIES NOT IN ('EQ', 'BE')              
AND V.SERIES = #HOLD.SERIES               
AND C.RECDATE between @PREVDATE and @PREVDATE  + ' 23:59'                   
              
UPDATE #HOLD              
SET CURR_VAR_RATE = Varmarginrate              
FROM vardetail V, Varcontrol C              
Where V.DetailKey = C.DetailKey              
AND V.SCRIP_CD = #HOLD.SCRIP_CD              
AND V.SERIES IN ('EQ', 'BE')              
AND #HOLD.SERIES IN ('EQ', 'BE')              
AND C.RECDATE between @SAUDA_DATE and @SAUDA_DATE  + ' 23:59'                   
              
UPDATE #HOLD              
SET CURR_VAR_RATE = Varmarginrate              
FROM vardetail V, Varcontrol C              
Where V.DetailKey = C.DetailKey              
AND V.SCRIP_CD = #HOLD.SCRIP_CD              
AND V.SERIES NOT IN ('EQ', 'BE')              
AND V.SERIES = #HOLD.SERIES               
AND C.RECDATE between @SAUDA_DATE and @SAUDA_DATE  + ' 23:59'                   
              
UPDATE #HOLD SET               
PREV_CL_RATE =               
  (CASE 
	WHEN PREV_VAR_RATE > 0 THEN PREV_CL_RATE - ( PREV_CL_RATE * PREV_VAR_RATE / 100)              
     ELSE PREV_CL_RATE - ( PREV_CL_RATE * 30 / 100)               
   END),              
CURR_CL_RATE =               
  (CASE 
	WHEN CURR_VAR_RATE > 0 THEN CURR_CL_RATE - ( CURR_CL_RATE * CURR_VAR_RATE / 100)              
     ELSE CURR_CL_RATE - ( CURR_CL_RATE * 30 / 100)               
   END)  
    
/*------ FOR MARGIN REPORT HOLDING -------*/      
      
DELETE FROM MARGIN_REPORT_HOLDING                   
WHERE SAUDA_DATE = @SAUDA_DATE                      
AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY                      
      
INSERT INTO MARGIN_REPORT_HOLDING      
SELECT @SAUDA_DATE,PARTY_CODE,SCRIP_CD,SERIES,CERTNO,QTY,PREV_CL_RATE,CURR_CL_RATE,PREV_VAR_RATE,CURR_VAR_RATE,FLAG  
 FROM #HOLD  
WHERE FLAG IN ('0','2')    
      
/*------ FOR MARGIN REPORT HOLDING -------*/     
            
              
UPDATE #MARGINREPORTING SET PREV_SEC = PREV_SEC + HOLDAMT               
FROM ( SELECT PARTY_CODE, HOLDAMT = SUM(PREV_CL_RATE * QTY)              
       FROM #HOLD WHERE FLAG IN (0, 1)              
    GROUP BY PARTY_CODE ) A              
WHERE #MARGINREPORTING.PARTY_CODE = A.PARTY_CODE              
              
UPDATE #MARGINREPORTING SET CURR_SEC = CURR_SEC + HOLDAMT               
FROM ( SELECT PARTY_CODE, HOLDAMT = SUM(CURR_CL_RATE * QTY)              
       FROM #HOLD WHERE FLAG IN (0, 2)              
    GROUP BY PARTY_CODE ) A              
WHERE #MARGINREPORTING.PARTY_CODE = A.PARTY_CODE              
              
UPDATE #MARGINREPORTING SET                     
CURR_CASH = C.CASH,              
CURR_FD = C.FD,                     
CURR_BG = C.BG,            
CURR_SEC = CURR_SEC + C.SEC            
FROM (                    
  SELECT PARTY_CODE,                     
  FD=SUM(CASE WHEN COLL_TYPE = 'FD'                     
THEN FINALAMOUNT                    
     ELSE 0                     
      END),                    
  BG=SUM(CASE WHEN COLL_TYPE = 'BG'                     
     THEN FINALAMOUNT                    
     ELSE 0                     
      END),                    
  SEC=SUM(CASE WHEN COLL_TYPE = 'SEC'                     
     THEN FINALAMOUNT                    
     ELSE 0                     
      END),                    
  CASH=SUM(CASE WHEN COLL_TYPE = 'MARGIN'                     
     THEN FINALAMOUNT                    
     ELSE 0                     
      END)                    
  FROM COLLATERALDETAILS                    
  WHERE EFFDATE between @SAUDA_DATE and @SAUDA_DATE  + ' 23:59'                      
  AND EXCHANGE = 'NSE' AND SEGMENT = 'CAPITAL'                       
  GROUP BY PARTY_CODE                    
  ) C                    
WHERE #MARGINREPORTING.PARTY_CODE = C.PARTY_CODE                    
            
UPDATE #MARGINREPORTING SET                     
CURR_CASH = CURR_CASH - PREV_CASH,           
CURR_FD = CURR_FD - PREV_FD,                     
CURR_BG = CURR_BG - PREV_BG,                    
CURR_SEC = CURR_SEC - PREV_SEC                    
              
UPDATE #MARGINREPORTING SET PREV_CASH = PREV_CASH + LEDBAL                    
FROM (SELECT CLTCODE, LEDBAL = SUM(CASE WHEN DRCR = 'C' THEN VAMT ELSE -VAMT END)                    
   FROM ACCOUNT.DBO.LEDGER L, ACCOUNT.DBO.PARAMETER P                    
   WHERE Vdt >= Sdtcur                             
  And Vdt <= Ldtcur                             
  And CurYear = 1                    
  AND EDT < @SAUDA_DATE                   
  AND CLTCODE BETWEEN @FROMPARTY AND @TOPARTY                     
   GROUP BY CLTCODE ) L                    
WHERE L.CLTCODE = #MARGINREPORTING.PARTY_CODE                    
                    
UPDATE #MARGINREPORTING SET PREV_CASH = PREV_CASH + LEDBAL                    
FROM (SELECT CLTCODE, LEDBAL = SUM(CASE WHEN DRCR = 'C' THEN -VAMT ELSE VAMT END)                    
   FROM ACCOUNT.DBO.LEDGER L, ACCOUNT.DBO.PARAMETER P                    
   WHERE VDt < @SAUDA_DATE                             
  And VDT < SdtCur                                      
  And EDT >= Sdtcur                                       
  And CurYear = 1                    
AND CLTCODE BETWEEN @FROMPARTY AND @TOPARTY                     
   GROUP BY CLTCODE ) L                    
WHERE L.CLTCODE = #MARGINREPORTING.PARTY_CODE                    
                    
UPDATE #MARGINREPORTING SET CURR_CASH = CURR_CASH + LEDBAL                    
FROM (SELECT CLTCODE, LEDBAL = SUM(CASE WHEN DRCR = 'C' THEN VAMT ELSE -VAMT END)                    
   FROM ACCOUNT.DBO.LEDGER L, ACCOUNT.DBO.PARAMETER P                    
   WHERE Vdt >= Sdtcur                             
  And Vdt <= Ldtcur                             
  And CurYear = 1                    
  AND EDT between @SAUDA_DATE and @SAUDA_DATE  + ' 23:59'                         
  AND CLTCODE BETWEEN @FROMPARTY AND @TOPARTY                     
   GROUP BY CLTCODE ) L                    
WHERE L.CLTCODE = #MARGINREPORTING.PARTY_CODE                    
                    
UPDATE #MARGINREPORTING SET CURR_CASH = CURR_CASH + LEDBAL                    
FROM (SELECT CLTCODE, LEDBAL = SUM(CASE WHEN DRCR = 'C' THEN -VAMT ELSE VAMT END)                    
   FROM ACCOUNT.DBO.LEDGER L, ACCOUNT.DBO.PARAMETER P                    
   WHERE VDt between @SAUDA_DATE and @SAUDA_DATE  + ' 23:59'                                        
  And VDT < SdtCur                                      
  And EDT >= Sdtcur                                       
  And CurYear = 1                    
  AND CLTCODE BETWEEN @FROMPARTY AND @TOPARTY                     
   GROUP BY CLTCODE ) L                    
WHERE L.CLTCODE = #MARGINREPORTING.PARTY_CODE                    
                    
UPDATE #MARGINREPORTING SET                     
MAR_ADJUST = MARGIN                    
FROM (SELECT PARTY_CODE, MARGIN = SUM(VARAMT - MTOM)                    
FROM TBL_MG02                     
WHERE MARGIN_DATE between @SAUDA_DATE and @SAUDA_DATE  + ' 23:59'                          
AND REC_TYPE = 10                    
AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY                     
AND SETT_NO >= @SETT_NO                    
GROUP BY PARTY_CODE) C                    
WHERE #MARGINREPORTING.PARTY_CODE = C.PARTY_CODE                    
                    
UPDATE #MARGINREPORTING SET                     
MAR_STATUS = PREV_CASH + PREV_FD + PREV_BG + PREV_SEC - PREV_VAR +                     
       CURR_CASH + CURR_FD + CURR_BG + CURR_SEC - MAR_ADJUST                     
                    
DELETE FROM MARGIN_REPORTING                 
WHERE SAUDA_DATE = @SAUDA_DATE                    
AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY                     
                    
INSERT INTO MARGIN_REPORTING              
SELECT @SAUDA_DATE,*,GETDATE() FROM #MARGINREPORTING

GO
