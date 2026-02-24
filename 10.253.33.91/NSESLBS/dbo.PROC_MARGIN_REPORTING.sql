-- Object: PROCEDURE dbo.PROC_MARGIN_REPORTING
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE  PROC [dbo].[PROC_MARGIN_REPORTING] (@SAUDA_DATE VARCHAR(11), @FROMPARTY VARCHAR(10), @TOPARTY VARCHAR(10))                  
AS                  
                  
DECLARE @PREVDATE VARCHAR(11),                  
@SETT_NO VARCHAR(7)                  
        
UPDATE TBL_MG02 SET PARTY_CODE = C.PARTY_CODE         
FROM MSAJAG.DBO.CLIENT_DETAILS C, MSAJAG.DBO.CLIENT_BROK_DETAILS D        
WHERE C.CL_CODE = D.CL_CODE AND D.EXCHANGE = 'NSE' AND D.SEGMENT = 'SLBS'        
AND C.CL_CODE  = TBL_MG02.PARTY_CODE           
AND MARGIN_DATE = @SAUDA_DATE        
        
UPDATE TBL_MG02 SET PARTY_CODE = C.PARTY_CODE         
FROM MSAJAG.DBO.CLIENT_DETAILS C, MSAJAG.DBO.CLIENT_BROK_DETAILS D        
WHERE C.CL_CODE = D.CL_CODE AND D.EXCHANGE = 'NSE' AND D.SEGMENT = 'SLBS'        
AND D.PARTICIPANT_CODE = TBL_MG02.PARTY_CODE        
AND MARGIN_DATE = @SAUDA_DATE        
        
SELECT @PREVDATE = LEFT(MAX(START_DATE),11) FROM SETT_MST                  
WHERE START_DATE < @SAUDA_DATE                  
AND SETT_TYPE = 'L'                  
                  
SELECT @SETT_NO = SETT_NO FROM SETT_MST                  
WHERE START_DATE LIKE @SAUDA_DATE + '%'                  
AND SETT_TYPE = 'L'                  
                
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
WHERE SAUDA_DATE LIKE @SAUDA_DATE + '%'                  
AND SETT_TYPE IN ('L', 'P')        
AND TRADE_NO NOT LIKE '%C%'                  
AND TRADEQTY > 0                   
AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY             
                  
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
  WHERE EFFDATE LIKE @PREVDATE + '%'                  
  AND EXCHANGE = 'NSE' AND SEGMENT = 'SLBS'                  
  GROUP BY PARTY_CODE                  
  ) C                  
WHERE #MARGINREPORTING.PARTY_CODE = C.PARTY_CODE                  
                  
UPDATE #MARGINREPORTING SET                   
PREV_VAR = MARGIN                  
FROM (SELECT PARTY_CODE, MARGIN = SUM(VARAMT - MTOM)                  
FROM TBL_MG02                   
WHERE MARGIN_DATE LIKE @SAUDA_DATE + '%'                   
AND REC_TYPE = 10                  
AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY                   
AND SETT_NO < @SETT_NO                  
GROUP BY PARTY_CODE) C                  
WHERE #MARGINREPORTING.PARTY_CODE = C.PARTY_CODE                  
            
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
  WHERE EFFDATE LIKE @SAUDA_DATE + '%'               
  AND EXCHANGE = 'NSE' AND SEGMENT = 'SLBS'                     
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
  AND EDT LIKE @SAUDA_DATE + '%'                  
  AND CLTCODE BETWEEN @FROMPARTY AND @TOPARTY                   
   GROUP BY CLTCODE ) L                  
WHERE L.CLTCODE = #MARGINREPORTING.PARTY_CODE                  
                  
UPDATE #MARGINREPORTING SET CURR_CASH = CURR_CASH + LEDBAL                  
FROM (SELECT CLTCODE, LEDBAL = SUM(CASE WHEN DRCR = 'C' THEN -VAMT ELSE VAMT END)                  
   FROM ACCOUNT.DBO.LEDGER L, ACCOUNT.DBO.PARAMETER P                  
   WHERE VDt LIKE @SAUDA_DATE + '%'                                 
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
WHERE MARGIN_DATE LIKE @SAUDA_DATE + '%'                   
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
