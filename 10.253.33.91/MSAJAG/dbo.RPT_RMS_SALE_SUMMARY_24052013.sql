-- Object: PROCEDURE dbo.RPT_RMS_SALE_SUMMARY_24052013
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

create PROC RPT_RMS_SALE_SUMMARY_24052013          
(                    
 @STATUSID VARCHAR(20),                  
 @STATUSNAME VARCHAR(50),                   
 @ACC_LEVEL  VARCHAR(10),                    
 @ACCCODE  VARCHAR(20),                    
 @PROCESS_DATE VARCHAR(11),                    
 @MOBILE_FLAG INT, -- PASS 0 FOR ALL, 1 FOR WITH MOBILE, 2 FOR NON MOBILE                    
 @SQOFFTYPE  VARCHAR(3),                    
 @LEVEL   VARCHAR(3) -- PASS ALL, T5, T6, T7                    
)                    
                    
AS                    
                  
-- EXEC RPT_RMS_SALE_SUMMARY 'FEB 27 2013' ,'','','','',''                   
/*                    
SELECT REGION, BRANCH_CD, SUB_BROKER, C.PARTY_CODE, CATEGORY = '', CL_TYPE,                     
SB_CATEGORY='', CASH_SEG_BAL=SUM(VDTBAL),                    
HOLD_AMT=SUM(HOLD_AMT), SQ_OFF_BAL = SUM(CASH_SEG_BAL+EXCESS_COLL),                  
ACT_SQ_OFF_BAL = SUM(CASH_SEG_BAL+EXCESS_COLL),                  
T5=SUM(CASE WHEN NOOFDAYS = 5 THEN CASH_SEG_BAL ELSE 0 END),                    
T6=SUM(CASE WHEN NOOFDAYS = 6 THEN CASH_SEG_BAL ELSE 0 END),                    
T7=SUM(CASE WHEN NOOFDAYS = 7 THEN CASH_SEG_BAL ELSE 0 END),                    
EXCESSAMT=SUM(ABS(EXCESS_COLL)),                    
SQOFFACTION = 'T - ' + CONVERT(VARCHAR,NOOFDAYS)                    
FROM TBL_RMS_SALE_LED_DET T,                    
     #CLIENT C                    
WHERE C.PARTY_CODE = T.PARTY_CODE                   
AND @STATUSNAME =                             
                  (CASE                             
                        WHEN @STATUSID = 'BRANCH' THEN C.BRANCH_CD                            
                        WHEN @STATUSID = 'SUBBROKER' THEN C.SUB_BROKER                            
                        WHEN @STATUSID = 'TRADER' THEN C.TRADER                            
                        WHEN @STATUSID = 'FAMILY' THEN C.FAMILY                            
                        WHEN @STATUSID = 'AREA' THEN C.AREA                            
                        WHEN @STATUSID = 'REGION' THEN C.REGION                            
                        WHEN @STATUSID = 'CLIENT' THEN C.PARTY_CODE                            
                  ELSE                             
                        'BROKER'                            
                  END)                   
GROUP BY REGION, BRANCH_CD, SUB_BROKER, C.PARTY_CODE, CL_TYPE, NOOFDAYS                     
ORDER BY REGION, BRANCH_CD, SUB_BROKER, C.PARTY_CODE, CL_TYPE, NOOFDAYS                     
                     
RETURN                    
*/                  
            
SELECT DISTINCT PARTY_CODE INTO #PARTY            
FROM TBL_RMS_SALE_LED_DET T                  
WHERE PROCESSDATE = @PROCESS_DATE      
AND HOLD_AMT<>0                  
                
SELECT PARTY_CODE,REGION, BRANCH_CD, SUB_BROKER, MOBILE_PAGER INTO #CLIENT FROM CLIENT_DETAILS C                  
WHERE @STATUSNAME =                             
                  (CASE                             
                        WHEN @STATUSID = 'BRANCH' THEN C.BRANCH_CD                            
                        WHEN @STATUSID = 'SUBBROKER' THEN C.SUB_BROKER                            
                        WHEN @STATUSID = 'TRADER' THEN C.TRADER                            
                        WHEN @STATUSID = 'FAMILY' THEN C.FAMILY                            
                        WHEN @STATUSID = 'AREA' THEN C.AREA                            
                        WHEN @STATUSID = 'REGION' THEN C.REGION                            
                        WHEN @STATUSID = 'CLIENT' THEN C.PARTY_CODE                            
                  ELSE                             
                        'BROKER'                            
                  END)                
AND @ACCCODE = (CASE WHEN @ACC_LEVEL = 'R' THEN (CASE WHEN @ACCCODE = 'ALL' THEN @ACCCODE ELSE REGION END)                  
         WHEN @ACC_LEVEL = 'B' THEN (CASE WHEN @ACCCODE = 'ALL' THEN @ACCCODE ELSE BRANCH_CD END)                  
      WHEN @ACC_LEVEL = 'S' THEN SUB_BROKER                  
      WHEN @ACC_LEVEL = 'C' THEN C.PARTY_CODE                  
      ELSE ''                   
    END)                                      
AND PARTY_CODE IN (SELECT PARTY_CODE FROM #PARTY)            
                                      
SELECT C.PARTY_CODE,CASH_SEG_BAL=SUM(CASH_SEG_BAL),                    
HOLD_AMT=SUM(HOLD_AMT),NOOFDAYS,EXCESS_COLL=SUM(EXCESS_COLL),                    
VDTBAL=SUM(VDTBAL),                   
ACT_SQ_OFF_BAL = CONVERT(NUMERIC(18,2),0),                  
MOBILE_PAGER,                   
CATEGORY = CONVERT(VARCHAR(10),''),                   
CL_TYPE = CONVERT(VARCHAR(10),''),                   
SB_CATEGORY=CONVERT(VARCHAR(10),'')                   
INTO #TBL_RMS_SALE_LED_DET                     
FROM TBL_RMS_SALE_LED_DET T, #CLIENT C                  
WHERE PROCESSDATE = @PROCESS_DATE                  
AND C.PARTY_CODE = T.PARTY_CODE                      
AND NOOFDAYS = 7                    
GROUP BY C.PARTY_CODE, NOOFDAYS, MOBILE_PAGER                    
--HAVING SUM(CASH_SEG_BAL+EXCESS_COLL) > 0 AND SUM(HOLD_AMT) > 0                    
                    
INSERT INTO #TBL_RMS_SALE_LED_DET                     
SELECT C.PARTY_CODE,CASH_SEG_BAL=SUM(CASH_SEG_BAL),                    
HOLD_AMT=SUM(HOLD_AMT),NOOFDAYS,EXCESS_COLL=SUM(EXCESS_COLL),                    
VDTBAL=SUM(VDTBAL),                   
ACT_SQ_OFF_BAL = CONVERT(NUMERIC(18,2),0),                  
MOBILE_PAGER,                   
CATEGORY = CONVERT(VARCHAR(10),''),                   
CL_TYPE = CONVERT(VARCHAR(10),''),                   
SB_CATEGORY=CONVERT(VARCHAR(10),'')                    
FROM TBL_RMS_SALE_LED_DET T, #CLIENT C                  
WHERE PROCESSDATE = @PROCESS_DATE                  
AND C.PARTY_CODE = T.PARTY_CODE                  
AND NOOFDAYS = 6                     
AND NOT EXISTS (SELECT PARTY_CODE FROM #TBL_RMS_SALE_LED_DET                    
      WHERE PARTY_CODE = T.PARTY_CODE)                    
GROUP BY C.PARTY_CODE, NOOFDAYS, MOBILE_PAGER                    
--HAVING SUM(CASH_SEG_BAL+EXCESS_COLL) > 0 AND SUM(HOLD_AMT) > 0                    
                    
INSERT INTO #TBL_RMS_SALE_LED_DET                     
SELECT C.PARTY_CODE,CASH_SEG_BAL=SUM(CASH_SEG_BAL),                    
HOLD_AMT=SUM(HOLD_AMT),NOOFDAYS,EXCESS_COLL=SUM(EXCESS_COLL),                    
VDTBAL=SUM(VDTBAL),                   
ACT_SQ_OFF_BAL = CONVERT(NUMERIC(18,2),0),                  
MOBILE_PAGER,                   
CATEGORY = CONVERT(VARCHAR(10),''),                   
CL_TYPE = CONVERT(VARCHAR(10),''),                   
SB_CATEGORY=CONVERT(VARCHAR(10),'')                  
FROM TBL_RMS_SALE_LED_DET T, #CLIENT C                  
WHERE PROCESSDATE = @PROCESS_DATE                  
AND C.PARTY_CODE = T.PARTY_CODE                  
AND NOOFDAYS = 5                     
AND NOT EXISTS (SELECT PARTY_CODE FROM #TBL_RMS_SALE_LED_DET                    
      WHERE PARTY_CODE = T.PARTY_CODE)                    
GROUP BY C.PARTY_CODE, NOOFDAYS, MOBILE_PAGER                    
--HAVING SUM(CASH_SEG_BAL+EXCESS_COLL) > 0 AND SUM(HOLD_AMT) > 0                      
                  
UPDATE #TBL_RMS_SALE_LED_DET SET ACT_SQ_OFF_BAL = AMT                   
FROM (                  
  SELECT PARTY_CODE, AMT = SUM(TRADEQTY*MARKETRATE)                  
  FROM TRADE_MATCH                  
  WHERE SAUDA_DATE LIKE @PROCESS_DATE + '%'                  
  AND SELL_BUY = 2                   
  GROUP BY PARTY_CODE                   
 ) A                  
WHERE A.PARTY_CODE = #TBL_RMS_SALE_LED_DET.PARTY_CODE                  
                  
UPDATE #TBL_RMS_SALE_LED_DET SET ACT_SQ_OFF_BAL = ACT_SQ_OFF_BAL + AMT                   
FROM (                  
  SELECT PARTY_CODE, AMT = SUM(TRADEQTY*MARKETRATE)                  
  FROM TRADE_MATCH_BSE                  
  WHERE SAUDA_DATE LIKE @PROCESS_DATE + '%'                  
  AND SELL_BUY = 2                   
  GROUP BY PARTY_CODE                  
 ) A                  
WHERE A.PARTY_CODE = #TBL_RMS_SALE_LED_DET.PARTY_CODE                  
                  
UPDATE #TBL_RMS_SALE_LED_DET SET CATEGORY = CLIENT_CATEGORY,                  
CL_TYPE = CLIENT_TYPE, SB_CATEGORY = C.SB_CATEGORY                  
FROM MKT_CLIENTDETAILS C                  
WHERE #TBL_RMS_SALE_LED_DET.PARTY_CODE = C.PARTY_CODE                  
                          
SELECT REGION, BRANCH_CD, SUB_BROKER, C.PARTY_CODE, CATEGORY, T.CL_TYPE,                     
SB_CATEGORY, CASH_SEG_BAL=SUM(VDTBAL),                    
--HOLD_AMT=SUM(HOLD_AMT+EXCESS_COLL),           
HOLD_AMT= CASE WHEN SUM(EXCESS_COLL) < 0 THEN  SUM(HOLD_AMT - EXCESS_COLL) ELSE SUM(HOLD_AMT+EXCESS_COLL) END ,           
SQ_OFF_BAL = CASE WHEN SUM(HOLD_AMT) <= (SUM(CASH_SEG_BAL)- SUM(ABS(EXCESS_COLL))) THEN SUM(HOLD_AMT) ELSE SUM(CASH_SEG_BAL)- SUM(ABS(EXCESS_COLL)) END,                    
ACT_SQ_OFF_BAL=SUM(ACT_SQ_OFF_BAL),                  
T5=SUM(CASE WHEN NOOFDAYS = 5 THEN CASH_SEG_BAL ELSE 0 END),                    
T6=SUM(CASE WHEN NOOFDAYS = 6 THEN CASH_SEG_BAL ELSE 0 END),                    
T7=SUM(CASE WHEN NOOFDAYS = 7 THEN CASH_SEG_BAL ELSE 0 END),                    
EXCESSAMT=SUM(ABS(EXCESS_COLL)),                    
SQOFFACTION = 'T - ' + CONVERT(VARCHAR,NOOFDAYS)                    
FROM #TBL_RMS_SALE_LED_DET T,                    
     #CLIENT C                    
WHERE C.PARTY_CODE = T.PARTY_CODE                  
AND 1 = (CASE WHEN @MOBILE_FLAG = 0 THEN 1                   
     WHEN @MOBILE_FLAG = 1 AND T.MOBILE_PAGER <> '' THEN 1                  
     WHEN @MOBILE_FLAG = 2 AND T.MOBILE_PAGER = '' THEN 1                  
        ELSE 2                  
   END)                  
AND NOOFDAYS = (CASE WHEN @LEVEL = 'ALL' THEN NOOFDAYS                  
      WHEN @LEVEL = 'T5' THEN 5                  
      WHEN @LEVEL = 'T6' THEN 6                  
      WHEN @LEVEL = 'T7' THEN 7                  
      ELSE 0                
    END)                  
AND @ACCCODE = (CASE WHEN @ACC_LEVEL = 'R' THEN (CASE WHEN @ACCCODE = 'ALL' THEN @ACCCODE ELSE REGION END)                  
         WHEN @ACC_LEVEL = 'B' THEN (CASE WHEN @ACCCODE = 'ALL' THEN @ACCCODE ELSE BRANCH_CD END)                  
      WHEN @ACC_LEVEL = 'S' THEN SUB_BROKER                  
      WHEN @ACC_LEVEL = 'C' THEN C.PARTY_CODE                  
      ELSE ''                   
    END)                  
AND T.CL_TYPE = (CASE WHEN @SQOFFTYPE = 'ALL' THEN T.CL_TYPE ELSE @SQOFFTYPE END)                  
GROUP BY REGION, BRANCH_CD, SUB_BROKER, C.PARTY_CODE,NOOFDAYS, CATEGORY, T.CL_TYPE,                     
SB_CATEGORY                     
--HAVING SUM(CASH_SEG_BAL+EXCESS_COLL) > 0 AND SUM(HOLD_AMT) > 0                  
ORDER BY REGION, BRANCH_CD, SUB_BROKER, C.PARTY_CODE, T.CL_TYPE

GO
