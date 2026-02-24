-- Object: PROCEDURE dbo.PROC_DELSALE
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

    
-- EXEC PROC_DELSALE 'APR  9 2013', 7, 500, 0, 0, '', 'SHV009', 'SHV009'          
          
--EXEC PROC_DELSALE 'may 15 2013', 5, 500, 0, 0, '', 'gfs274', 'gfs274'           
--EXEC PROC_DELSALE 'may 15 2013', 6, 500, 0, 0, '', 'gfs274', 'gfs274'             
--EXEC PROC_DELSALE 'JUN  5 2013', 7, 500, 0, 0, '', 'N43257', 'N43257'                                       
                                                 
CREATE PROC [dbo].[PROC_DELSALE]                                                                                             
(                                                                                    
 @PROCESS_DATE  VARCHAR(11),                                                                                     
 @NOOFDAYS   INT,                                                                                    
 @DEBITVALUE   NUMERIC(18, 4),                                                                                     
 @DEBITMARKUP  NUMERIC(18, 4),                                                                                    
 @CLRATEHAIRCUT  NUMERIC(18, 4),                                                                                    
 @CLTYPE    VARCHAR(200),                                                                                
 @FROMPARTY VARCHAR(10) = '0',                                                                                
 @TOPARTY VARCHAR(10) = 'ZZZZZZZZZZ'                                                                                   
)                                 
                                                                                   
AS                                                                                            
DECLARE                                                                                             
@LEDCUR CURSOR,                                                                                            
@DELCUR CURSOR,                                                                                            
@SETCUR CURSOR,                                                                                            
@PARTY_CODE VARCHAR(10),                                                                                            
@AMOUNT NUMERIC(18, 4),                                                                                            
@SETT_NO VARCHAR(7),                                                                                            
@SETT_TYPE VARCHAR(2),                                                                                            
@SCRIP_CD VARCHAR(12),                                                                                            
@SERIES VARCHAR(12),                                                                                            
@QTY INT,                                                                                            
@NEWQTY INT,                                                                                            
@CL_RATE NUMERIC(18, 4),                                                                                            
@START_DATE VARCHAR(11),                                                                                    
@CL_DATE    VARCHAR(11),                                                                                    
@SQL VARCHAR(200),                                                                                  
@SNO NUMERIC(18,0),                                                                                  
@HOLDTYPE VARCHAR(4),                                                                                  
@MDATE VARCHAR(11),                                                                                  
@SCRIP_CATEGORY INT                                                                                            
                                                                          
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED     
                                                        
SET @PROCESS_DATE = LEFT(GETDATE(),11)                                                        
                                                             
SELECT DISTINCT CL_TYPE INTO #CLTYPE FROM CLIENTTYPE                                                                                     
WHERE CL_TYPE NOT IN (SELECT SPLITTED_VALUE FROM PRADNYA.DBO.FUN_SPLITSTRING (@CLTYPE,','))                                                                                    
                               
DELETE FROM #CLTYPE                                        
WHERE CL_TYPE IN (SELECT DATAVALUE FROM TBL_RMS_EXCEPTION WHERE DATATYPE = 'CLTYPE')                    
                                                                                  
CREATE TABLE #SETT                                                                                        
(START_DATE VARCHAR(11))                                                                                          
                                                                 
SELECT @SQL = 'INSERT INTO #SETT SELECT LEFT(MIN(START_DATE),11) AS START_DATE FROM ( '                                                                                            
SELECT @SQL = @SQL + ' SELECT TOP ' + CONVERT(VARCHAR,@NOOFDAYS) + ' * FROM MSAJAG.DBO.SETT_MST '                                                                                  
SELECT @SQL = @SQL + ' WHERE START_DATE <= ''' + LEFT(CONVERT(VARCHAR,@PROCESS_DATE),11) + ''''                                             
SELECT @SQL = @SQL + ' AND SETT_TYPE = ''N'''                                                                                            
SELECT @SQL = @SQL + ' ORDER BY START_DATE DESC ) A'                                                                                           
                                            
EXEC (@SQL)                                                                                            
                                                          
SELECT @START_DATE = START_DATE FROM #SETT                                                                         
                                                                       
--SELECT @START_DATE                                                                         
--RETURN                                                                    
                                                                    
SELECT @CL_DATE = LEFT(MAX(START_DATE),11) FROM SETT_MST                                               
WHERE START_DATE < @PROCESS_DATE                                                                             
                                                  
SELECT L.CLTCODE, AMOUNT = SUM(CASE WHEN DRCR = 'D' THEN VAMT ELSE -VAMT END)                                                                                         
INTO #LEDBAL                                                                                            
FROM ACCOUNT.DBO.LEDGER L, ACCOUNT.DBO.ACMAST A, ACCOUNT.DBO.PARAMETER P                                                                 
WHERE L.VDT BETWEEN SDTCUR AND LDTCUR                                                                                                
AND L.CLTCODE = A.CLTCODE                                                                                       
AND A.ACCAT = 4                                                                                                 
AND L.VDT <= @PROCESS_DATE + ' 23:59:59'                                                            
AND L.VDT BETWEEN SDTCUR AND LDTCUR                                                                                      
AND @PROCESS_DATE BETWEEN SDTCUR AND LDTCUR                                                                                                
AND A.CLTCODE BETWEEN @FROMPARTY AND @TOPARTY                                                
GROUP BY L.CLTCODE                                  
                                                  
INSERT INTO #LEDBAL                   
SELECT L.CLTCODE, AMOUNT = SUM(CASE WHEN DRCR = 'D' THEN VAMT ELSE -VAMT END)                                                                               
FROM AngelBSECM.ACCOUNT_AB.DBO.LEDGER L, AngelBSECM.ACCOUNT_AB.DBO.ACMAST A, AngelBSECM.ACCOUNT_AB.DBO.PARAMETER P                                                         
WHERE L.VDT BETWEEN SDTCUR AND LDTCUR                                                                                                
AND L.CLTCODE = A.CLTCODE                                                                                       
AND A.ACCAT = 4                                                             
AND L.VDT <= @PROCESS_DATE + ' 23:59:59'                              
AND L.VDT BETWEEN SDTCUR AND LDTCUR                                                                                      
AND @PROCESS_DATE BETWEEN SDTCUR AND LDTCUR                                                                                                
AND A.CLTCODE BETWEEN @FROMPARTY AND @TOPARTY                                                                                                           
GROUP BY L.CLTCODE                                                   
                                      
DELETE FROM TBL_RMS_SALE_LED_DET                                                    
WHERE PROCESSDATE = @PROCESS_DATE                                                    
AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY                                                              
AND NOOFDAYS = @NOOFDAYS                                                   
                                            
SELECT * INTO #TBL_RMS_SALE_LED_DET                                            
FROM TBL_RMS_SALE_LED_DET                                          
WHERE 1 = 2                                         
                                                  
INSERT INTO #TBL_RMS_SALE_LED_DET                                                    
SELECT CLTCODE, AMT=0,HOLD_AMT=0, @NOOFDAYS, EXCESS_COLL=0,@PROCESS_DATE,GETDATE(),SUM(AMOUNT)                                                    
FROM #LEDBAL                                                    
GROUP BY CLTCODE   
                            
TRUNCATE TABLE #LEDBAL                                                  
                                                 
INSERT INTO #LEDBAL                                                                                            
SELECT L.CLTCODE, AMOUNT = SUM(CASE WHEN DRCR = 'D' THEN VAMT ELSE -VAMT END)                                                                                         
FROM ACCOUNT.DBO.LEDGER L, ACCOUNT.DBO.ACMAST A, ACCOUNT.DBO.PARAMETER P                                                                 
WHERE L.VDT BETWEEN SDTCUR AND LDTCUR                                                                                                
AND L.CLTCODE = A.CLTCODE                                                                                       
AND A.ACCAT = 4                                                                                                 
AND L.VDT < @START_DATE                                                             
AND L.VDT BETWEEN SDTCUR AND LDTCUR                                                                                      
AND CONVERT(DATETIME,@START_DATE)-1 BETWEEN SDTCUR AND LDTCUR                                                              
AND A.CLTCODE BETWEEN @FROMPARTY AND @TOPARTY                                                                                    
/*AND A.CLTCODE IN (SELECT PARTY_CODE FROM CLIENT_DETAILS                                                                       
      WHERE CL_TYPE IN (SELECT CL_TYPE FROM #CLTYPE))*/                                                                          
GROUP BY L.CLTCODE  --HAVING SUM(CASE WHEN DRCR = 'D' THEN VAMT ELSE -VAMT END) > 0                                                                                                           
                                        
INSERT INTO #LEDBAL                                                                              
SELECT L.CLTCODE, AMOUNT = SUM(CASE WHEN DRCR = 'D' THEN VAMT ELSE -VAMT END)                                                                                           
FROM ACCOUNT.DBO.LEDGER L, ACCOUNT.DBO.ACMAST A                                                                                         
WHERE L.CLTCODE = A.CLTCODE                                                                                            
--AND L.VDT BETWEEN P.SDTCUR AND LDTCUR                                                                                            
--AND @START_DATE BETWEEN SDTCUR AND LDTCUR                                                  
AND ACCAT = 4                        
AND VDT >= @START_DATE                                                                                       
AND VDT <= @PROCESS_DATE + ' 23:59:59'                                                               
AND DRCR = 'C'                                                      
AND A.CLTCODE BETWEEN @FROMPARTY AND @TOPARTY                                                                                           
/*AND A.CLTCODE IN (SELECT PARTY_CODE FROM CLIENT_DETAILS                                                                                    
      WHERE CL_TYPE IN (SELECT CL_TYPE FROM #CLTYPE))*/                             
AND VTYP <> '15'                                   
AND VTYP <> (CASE WHEN MONTH(CONVERT(DATETIME,@START_DATE)-1) = '3'                                  
       AND MONTH(CONVERT(DATETIME,@PROCESS_DATE)) = '4' THEN '18'                                  
     ELSE '' END)                                  
GROUP BY L.CLTCODE                                                                                            
HAVING SUM(CASE WHEN DRCR = 'D' THEN VAMT ELSE -VAMT END) < 0                                                                                            
                                                                     
INSERT INTO #LEDBAL                                                                                            
SELECT L.PARTY_CODE, AMOUNT = SUM(CASE WHEN DRCR = 'D' THEN AMOUNT ELSE -AMOUNT END)                                                                                      
FROM ACCOUNT.DBO.MARGINLEDGER L, ACCOUNT.DBO.ACMAST A, ACCOUNT.DBO.PARAMETER P                                                                                            
WHERE L.VDT BETWEEN SDTCUR AND LDTCUR                                                                                                
AND L.PARTY_CODE = A.CLTCODE                                                   
AND A.ACCAT = 4                                                                                                 
AND L.VDT < @START_DATE                                                                                      
AND L.VDT BETWEEN SDTCUR AND LDTCUR                             
AND CONVERT(DATETIME,@START_DATE)-1 BETWEEN SDTCUR AND LDTCUR                                                                                                
AND A.CLTCODE BETWEEN @FROMPARTY AND @TOPARTY                                                                                     
/*AND A.CLTCODE IN (SELECT PARTY_CODE FROM CLIENT_DETAILS                                                                                  
      WHERE CL_TYPE IN (SELECT CL_TYPE FROM #CLTYPE))*/                                                                          
GROUP BY L.PARTY_CODE        
--HAVING SUM(CASE WHEN DRCR = 'D' THEN AMOUNT ELSE -AMOUNT END) > 0                                                               
                  
INSERT INTO #LEDBAL        
SELECT L.PARTY_CODE, AMOUNT = SUM(CASE WHEN DRCR = 'D' THEN AMOUNT ELSE -AMOUNT END)                                                
FROM ACCOUNT.DBO.MARGINLEDGER L, ACCOUNT.DBO.ACMAST A                                                                                            
WHERE L.PARTY_CODE = A.CLTCODE                                                         
--AND L.VDT BETWEEN P.SDTCUR AND LDTCUR                                                                                            
--AND CURYEAR = 1                                   
AND ACCAT = 4                                                                                            
AND VDT >= @START_DATE                                                                                         
AND VDT <= @PROCESS_DATE + ' 23:59:59'                                                                    
AND DRCR = 'C'                                                           
AND A.CLTCODE BETWEEN @FROMPARTY AND @TOPARTY                                                                                    
/*AND A.CLTCODE IN (SELECT PARTY_CODE FROM CLIENT_DETAILS                                                             
      WHERE CL_TYPE IN (SELECT CL_TYPE FROM #CLTYPE))*/                                                        
GROUP BY L.PARTY_CODE                                                              
HAVING SUM(CASE WHEN DRCR = 'D' THEN AMOUNT ELSE -AMOUNT END) < 0                                                                                            
                                                
INSERT INTO #LEDBAL                                                              
SELECT PARTY_CODE, AMOUNT = -SUM(SAMT)                                             
FROM (                                                              
 SELECT PARTY_CODE, SAMT = SAMT-PAMT                                                                              
 FROM TBL_VALAN_DETAIL                                                    
 WHERE SAUDA_DATE >= @START_DATE                                                                                     
 AND SAUDA_DATE < @PROCESS_DATE --+ ' 23:59:59'                                                                             
 AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY                                                              
 AND SAMT-PAMT > 0                                                              
) A                                                                              
GROUP BY PARTY_CODE                                   
                            
INSERT INTO #LEDBAL                                                                           
EXEC AngelBSECM.ACCOUNT_AB.DBO.PROC_DELSALE_ACC @START_DATE, @PROCESS_DATE, @FROMPARTY, @TOPARTY                                                                                                   
                                       
INSERT INTO #TBL_RMS_SALE_LED_DET                                                    
SELECT CLTCODE, AMT=SUM(AMOUNT),HOLD_AMT=0, @NOOFDAYS, EXCESS_COLL=0,@PROCESS_DATE,GETDATE(),0                                                    
FROM #LEDBAL                                                    
GROUP BY CLTCODE                                   
                                                    
TRUNCATE TABLE #LEDBAL                                                    
    
SELECT CLTCODE, JVAMT = AMOUNT, EXCESS_COLL=AMOUNT    
INTO #LEDBAL_EXC FROM #LEDBAL    
WHERE 1 = 2     
    
INSERT INTO #LEDBAL_EXC                                                                                                    
EXEC ANGELFO.NSEFO.DBO.CLIENTMARGIN_UPD @PROCESS_DATE, @FROMPARTY, @TOPARTY, 1                                                             
                    
INSERT INTO #LEDBAL_EXC                                                     
EXEC ANGELFO.NSECURFO.DBO.CLIENTMARGIN_UPD @PROCESS_DATE, @FROMPARTY, @TOPARTY, 1                                                            
                              
INSERT INTO #LEDBAL_EXC                                                                
EXEC ANGELCOMMODITY.MCDXCDS.DBO.CLIENTMARGIN_UPD @PROCESS_DATE, @FROMPARTY, @TOPARTY, 1                     
                                                            
INSERT INTO #LEDBAL_EXC                                                               
EXEC ANGELCOMMODITY.BSEFO.DBO.CLIENTMARGIN_UPD @PROCESS_DATE, @FROMPARTY, @TOPARTY, 1                                                                  
                                            
INSERT INTO #TBL_RMS_SALE_LED_DET                                                    
SELECT CLTCODE, AMT=0,HOLD_AMT=SUM(EXCESS_COLL), @NOOFDAYS, EXCESS_COLL=SUM(JVAMT),@PROCESS_DATE,GETDATE(),0                                     
FROM #LEDBAL_EXC                                    
GROUP BY CLTCODE       
                                             
TRUNCATE TABLE #LEDBAL                             
                                                    
INSERT INTO #LEDBAL                                                    
SELECT PARTY_CODE, AMOUNT = SUM(CASH_SEG_BAL+EXCESS_COLL)                                                     
FROM #TBL_RMS_SALE_LED_DET                                                    
WHERE PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY                                                              
AND NOOFDAYS = @NOOFDAYS                                                    
GROUP BY PARTY_CODE                                      
                                                              
SELECT CLTCODE, AMOUNT = SUM(AMOUNT) +  SUM(AMOUNT)*@DEBITMARKUP/100                                                                                     
INTO #LEDBAL_FINAL                    
FROM #LEDBAL                                                                              
GROUP BY CLTCODE                                                                                    
--HAVING SUM(AMOUNT) > 0 AND SUM(AMOUNT) >= @DEBITVALUE                                     
                                                                         
CREATE CLUSTERED INDEX [CLTCODE] ON [DBO].[#LEDBAL_FINAL]                                                                                  
(                              
 [CLTCODE] ASC                                                                                  
)                                                                                  
                                                                                   
DELETE FROM #LEDBAL_FINAL                                                                                     
WHERE CLTCODE IN (SELECT DATAVALUE FROM TBL_RMS_EXCEPTION WHERE DATATYPE = 'PARTYCODE')                                    
              
DELETE FROM #LEDBAL_FINAL                                                                                     
WHERE CLTCODE IN (SELECT PARTY_CODE FROM CLIENT_DETAILS WHERE REGION IN (SELECT DATAVALUE FROM TBL_RMS_EXCEPTION WHERE DATATYPE = 'REGION') )                
              
DELETE FROM #LEDBAL_FINAL                                                                                     
WHERE CLTCODE IN (SELECT PARTY_CODE FROM CLIENT_DETAILS WHERE AREA IN (SELECT DATAVALUE FROM TBL_RMS_EXCEPTION WHERE DATATYPE = 'AREA') )                
              
DELETE FROM #LEDBAL_FINAL                                                                                     
WHERE CLTCODE IN (SELECT PARTY_CODE FROM CLIENT_DETAILS WHERE BRANCH_CD IN (SELECT DATAVALUE FROM TBL_RMS_EXCEPTION WHERE DATATYPE = 'BRANCH') )                
              
DELETE FROM #LEDBAL_FINAL                                                                                     
WHERE CLTCODE IN (SELECT PARTY_CODE FROM CLIENT_DETAILS WHERE SUB_BROKER IN (SELECT DATAVALUE FROM TBL_RMS_EXCEPTION WHERE DATATYPE = 'SUBBROKER') )                
              
/*                                                                    
DELETE FROM #LEDBAL_FINAL                         
WHERE CLTCODE NOT IN (SELECT CLIENT FROM VW_CLIENT_CATEGORY                                                                                  
WHERE CATEGORY IN ('C', 'D'))                                                                                  
*/                          
DELETE FROM #LEDBAL_FINAL                                                                                     
WHERE CLTCODE NOT IN (SELECT CL_CODE FROM CLIENT_DETAILS                                                                                  
WHERE PAN_GIR_NO <> '')                                                                                     
                                                          
DELETE FROM #LEDBAL_FINAL                                                                                     
WHERE CLTCODE NOT IN (SELECT CL_CODE FROM CLIENT_BROK_DETAILS                                                                                  
WHERE INACTIVE_FROM >= LEFT(GETDATE(),11)                                                                                  
AND EXCHANGE+SEGMENT NOT IN ('NCXFUTURES', 'MCXFUTURES'))                    
                  
SELECT * INTO #V_USERLIST FROM V_USERLIST                  
                    
DELETE FROM #LEDBAL_FINAL                                                                                     
WHERE CLTCODE NOT IN (SELECT PCODE FROM #V_USERLIST)                    
                                                                                  
DELETE FROM TBL_RMS_SALE_LEDBAL                           
WHERE SAUDA_DATE = @PROCESS_DATE                                                                                   
AND NOOFDAYS = @NOOFDAYS                                                                                   
AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY                                                    
                                                                    
DELETE FROM TBL_RMS_SALE_LEDBAL_HISTORY                                                                    
WHERE SAUDA_DATE = @PROCESS_DATE                                                                          
AND NOOFDAYS = @NOOFDAYS                                                                                   
AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY                                                                    
                                                                            
SELECT D.SNO, D.SETT_NO, D.SETT_TYPE, D.PARTY_CODE, D.SCRIP_CD, SERIES = CONVERT(VARCHAR(12),D.SERIES), QTY,                                                                                             
CL_RATE = CONVERT(NUMERIC(18,4),0), LEDAMT = CONVERT(NUMERIC(18,4),0),                                                                                            
TOSELLQTY = 0, START_DATE = GETDATE(), EXCHANGE = 'NSE',                                                                                  
HOLDTYPE = CONVERT(VARCHAR(4), ''),                                                                                  
SCRIP_CATEGORY = 10,                                                                                  
CERTNO                                    
INTO #DEL FROM MSAJAG.DBO.DELTRANS D                                        
WHERE 1 = 2                                                                              
                                                                  
INSERT INTO #DEL                                                                                  
EXEC ANGELDEMAT.MSAJAG.DBO.PROC_DELSALE_HOLD @PROCESS_DATE, @FROMPARTY, @TOPARTY                          
                            
DELETE FROM #LEDBAL_FINAL                                                                          
WHERE CLTCODE IN (SELECT PARTY_CODE FROM CLIENT_DETAILS                                  
      WHERE CL_TYPE NOT IN (SELECT CL_TYPE FROM #CLTYPE))                  
                           
                         
                          
UPDATE #DEL SET SCRIP_CATEGORY = (CASE WHEN S.CATEGORY = 'BLUECHIP' OR S.CATEGORY = 'BLUE CHIP' THEN 1                                                                                   
            WHEN S.CATEGORY = 'GOOD' THEN 2                                                                                  
       WHEN S.CATEGORY = 'AVERAGE' THEN 3                                                                             
            WHEN S.CATEGORY = 'POOR' THEN 4                                                                                  
            ELSE 5 END)                                           
FROM VW_SCRIP_CATEGORY S                                                                                  
WHERE CERTNO = ISIN                        
                                                              
UPDATE #DEL SET SCRIP_CD = M.SCRIP_CD, SERIES = M.SERIES                                                                                  
FROM ANGELDEMAT.MSAJAG.DBO.MULTIISIN M                                                                                  
WHERE M.ISIN = CERTNO                                  
AND VALID = 1                                                                                  
AND EXCHANGE = 'NSE'                                                            
                                                                                  
UPDATE #DEL SET SCRIP_CD = M.SCRIP_CD, SERIES = M.SERIES                                                                                  
FROM ANGELDEMAT.BSEDB.DBO.MULTIISIN M                                                                                  
WHERE M.ISIN = CERTNO                                                                                  
AND VALID = 1                                                          
AND EXCHANGE = 'BSE'                                                                           
                                                                                  
UPDATE #DEL SET CL_RATE = C.CL_RATE FROM MSAJAG.DBO.CLOSING C                                                                                     
WHERE SYSDATE LIKE @CL_DATE + '%'                                                                                                     
AND C.SCRIP_CD = #DEL.SCRIP_CD                                                                                                                    
AND #DEL.SERIES IN ('EQ','BE')                                                                     
AND C.SERIES IN ('EQ','BE')                                                                                               
AND #DEL.CL_RATE = 0 AND EXCHANGE = 'NSE'                                                                                                                  
                                                                                                           
UPDATE #DEL SET CL_RATE = C.CL_RATE FROM MSAJAG.DBO.CLOSING C                                            
WHERE SYSDATE LIKE @CL_DATE + '%'                                                             
AND C.SCRIP_CD = #DEL.SCRIP_CD                                  
AND C.SERIES = #DEL.SERIES                                                                                                              
AND #DEL.CL_RATE = 0 AND EXCHANGE = 'NSE'                                                                                                       
                                                                                          
UPDATE #DEL SET CL_RATE = C.CL_RATE FROM AngelBSECM.BSEDB_AB.DBO.CLOSING C                              
WHERE SYSDATE LIKE @CL_DATE + '%'                                          
AND C.SCRIP_CD = #DEL.SCRIP_CD                                                                                                                    
AND C.SERIES = #DEL.SERIES                                                                   
AND #DEL.CL_RATE = 0 AND EXCHANGE = 'BSE'                                                                                                           
                                
UPDATE #DEL SET SCRIP_CD = M.SCRIP_CD, SERIES = M.SERIES, EXCHANGE = 'NSE'                                                                                  
FROM ANGELDEMAT.MSAJAG.DBO.MULTIISIN M                                                     
WHERE M.ISIN = CERTNO                                                                                  
AND VALID = 1                                    
AND CL_RATE = 0                                
                                
UPDATE #DEL SET CL_RATE = C.CL_RATE FROM MSAJAG.DBO.CLOSING C                                                                                     
WHERE SYSDATE LIKE @CL_DATE + '%'                                                                                                     
AND C.SCRIP_CD = #DEL.SCRIP_CD                       
AND #DEL.SERIES IN ('EQ','BE')                                                                                                       
AND C.SERIES IN ('EQ','BE')                                                                                               
AND #DEL.CL_RATE = 0 AND EXCHANGE = 'NSE'                                                                                                                  
                                                                                                           
UPDATE #DEL SET CL_RATE = C.CL_RATE FROM MSAJAG.DBO.CLOSING C                                            
WHERE SYSDATE LIKE @CL_DATE + '%'                                                                                    
AND C.SCRIP_CD = #DEL.SCRIP_CD                                                                    
AND C.SERIES = #DEL.SERIES                                                                                                              
AND #DEL.CL_RATE = 0 AND EXCHANGE = 'NSE'                                                                                                       
                                
UPDATE #DEL SET SCRIP_CD = M.SCRIP_CD, SERIES = M.SERIES, EXCHANGE = 'BSE'                                                                                  
FROM ANGELDEMAT.BSEDB.DBO.MULTIISIN M                                                                                  
WHERE M.ISIN = CERTNO                                
AND VALID = 1                                                                                  
AND CL_RATE = 0                                
                                                                                          
UPDATE #DEL SET CL_RATE = C.CL_RATE FROM AngelBSECM.BSEDB_AB.DBO.CLOSING C                       
WHERE SYSDATE LIKE @CL_DATE + '%'                                                                                                            
AND C.SCRIP_CD = #DEL.SCRIP_CD                                                                                                                    
AND C.SERIES = #DEL.SERIES                                    
AND #DEL.CL_RATE = 0 AND EXCHANGE = 'BSE'                                                                                          
                                                                                          
UPDATE #DEL SET SCRIP_CD = S2.SCRIP_CD, SERIES = #DEL.SCRIP_CD                                                               
FROM AngelBSECM.BSEDB_AB.DBO.SCRIP2 S2                                                                                   
WHERE BSECODE = #DEL.SCRIP_CD                                                                  
AND #DEL.EXCHANGE = 'BSE'                                 
                                                   
UPDATE #DEL SET CL_RATE = CL_RATE - (CL_RATE * @CLRATEHAIRCUT)/ 100          
                                                                             
UPDATE #DEL SET CL_RATE = ((FLOOR(( CL_RATE * POWER(10,2)+ 5 + -2.5)/(5 + 0 )) * (5 + 0))/POWER(10,2))                               
WHERE CL_RATE > 0                                                            
                                                         
UPDATE #DEL SET LEDAMT = AMOUNT                                                                                            
FROM #LEDBAL_FINAL                                                      
WHERE #DEL.PARTY_CODE = CLTCODE                                                                                            
                                                                                    
DELETE FROM #DEL                                                                                     
WHERE SCRIP_CD IN (SELECT DATAVALUE FROM TBL_RMS_EXCEPTION WHERE DATATYPE = 'SCRIP')                                                                                    
                                                    
DELETE FROM #DEL                            
WHERE SERIES IN (SELECT DATAVALUE FROM TBL_RMS_EXCEPTION WHERE DATATYPE = 'SCRIP')            
        
                                                    
INSERT INTO #TBL_RMS_SALE_LED_DET                                  
SELECT PARTY_CODE, AMT=0,HOLD_AMT=SUM(QTY*CL_RATE), @NOOFDAYS, EXCESS_COLL=0,@PROCESS_DATE,GETDATE(),0                                                    
FROM #DEL WHERE HOLDTYPE <> 'MAR'                                                   
GROUP BY PARTY_CODE                                                    
          
DELETE FROM #DEL WHERE PARTY_CODE IN (SELECT PARTY_CODE FROM #TBL_RMS_SALE_LED_DET          
            GROUP BY PARTY_CODE HAVING SUM(HOLD_AMT) = 0 )          
                      
DELETE FROM #DEL WHERE PARTY_CODE NOT IN (SELECT CLTCODE                                                                                            
     FROM #LEDBAL_FINAL)                            
                                
DELETE FROM #LEDBAL_FINAL                                
WHERE NOT EXISTS (SELECT PARTY_CODE FROM #DEL WHERE CLTCODE = PARTY_CODE)                                
                                
DELETE FROM #TBL_RMS_SALE_LED_DET                                
WHERE NOT EXISTS (SELECT PARTY_CODE FROM #DEL WHERE #TBL_RMS_SALE_LED_DET.PARTY_CODE = #DEL.PARTY_CODE)                                
                                
INSERT INTO TBL_RMS_SALE_LEDBAL_HISTORY                                                                    
SELECT @PROCESS_DATE, CLTCODE, AMOUNT, @NOOFDAYS, GETDATE()                                                                                  
FROM  #LEDBAL_FINAL                                                           
WHERE AMOUNT > 0 AND AMOUNT >= @DEBITVALUE                                                                    
AND CLTCODE IN (SELECT PCODE FROM  #V_USERLIST)                                              
                                                                                  
INSERT INTO TBL_RMS_SALE_LEDBAL                                                                     
SELECT @PROCESS_DATE, CLTCODE, AMOUNT, @NOOFDAYS, GETDATE()                                                                                  
FROM  #LEDBAL_FINAL                                                           
WHERE AMOUNT > 0 AND AMOUNT >= @DEBITVALUE                                                                    
AND CLTCODE IN (SELECT PCODE FROM  #V_USERLIST)                                 
                          
DELETE FROM #LEDBAL_FINAL                           
WHERE AMOUNT < @DEBITVALUE            
                      
INSERT INTO TBL_RMS_SALE_LED_DET                                            
SELECT PARTY_CODE,CASH_SEG_BAL=SUM(CASH_SEG_BAL),                                            
HOLD_AMT=SUM(HOLD_AMT),NOOFDAYS,EXCESS_COLL=SUM(EXCESS_COLL),                            
@PROCESS_DATE,RUNDATE=GETDATE(),VDTBAL=SUM(VDTBAL)                                            
FROM #TBL_RMS_SALE_LED_DET                                            
WHERE PARTY_CODE IN (SELECT CLTCODE                                       
     FROM #LEDBAL_FINAL)                                           
GROUP BY PARTY_CODE, NOOFDAYS                        
                                              
CREATE CLUSTERED INDEX [SNO] ON [DBO].[#DEL]                                                                                  
(                                                                                  
 [SNO] ASC                                                                                  
)                                                                                  
                               
CREATE NONCLUSTERED INDEX [PARTYCL] ON [DBO].[#DEL]                                     
(                                                                                  
 [PARTY_CODE] ASC,                                                                              
 [CL_RATE] ASC                                                                                  
)                                  
    
UPDATE #LEDBAL_FINAL SET AMOUNT = (CASE WHEN AMOUNT > HOLD_AMT THEN HOLD_AMT ELSE AMOUNT END)    
FROM (    
  SELECT PARTY_CODE,                                            
  HOLD_AMT=SUM(HOLD_AMT)    
  FROM #TBL_RMS_SALE_LED_DET                                            
  GROUP BY PARTY_CODE     
 ) A    
WHERE CLTCODE = PARTY_CODE    
                                                                  
SET @LEDCUR = CURSOR FOR                                                                                            
SELECT CLTCODE, AMOUNT                                                                                      
FROM #LEDBAL_FINAL                                                                                      
ORDER BY CLTCODE                     
OPEN @LEDCUR                                                                                             
FETCH NEXT FROM @LEDCUR INTO @PARTY_CODE, @AMOUNT                                                                                  
WHILE @@FETCH_STATUS = 0                                                            
BEGIN                                                                      
 SET @DELCUR = CURSOR FOR                                                                                            
SELECT SNO, SETT_NO, SETT_TYPE, SCRIP_CD, SERIES, QTY, CL_RATE, START_DATE, HOLDTYPE, SCRIP_CATEGORY FROM #DEL                                                                                            
 WHERE PARTY_CODE = @PARTY_CODE  AND CL_RATE > 0                                                                            
 ORDER BY HOLDTYPE, START_DATE DESC, SCRIP_CATEGORY, CL_RATE, SCRIP_CD, SERIES                                                                                            
 OPEN @DELCUR                                                                                    
 FETCH NEXT FROM @DELCUR INTO @SNO, @SETT_NO, @SETT_TYPE, @SCRIP_CD, @SERIES, @QTY, @CL_RATE, @START_DATE, @HOLDTYPE, @SCRIP_CATEGORY                                                                                            
 WHILE @@FETCH_STATUS = 0 AND @AMOUNT > 0                                                                                            
 BEGIN                                                                                              
 IF @AMOUNT >= @CL_RATE * @QTY                                                        
  BEGIN                                           
   UPDATE #DEL SET TOSELLQTY = @QTY                                                                  
   WHERE SNO = @SNO                                                                                           
            
   SET @AMOUNT = @AMOUNT - (@CL_RATE * @QTY)                                                                        
  END                                                                                            
  ELSE                                                                                            
  BEGIN                                                                                            
   SET @NEWQTY = CEILING(@AMOUNT / @CL_RATE)                                                                              
                                                                                  
   IF @NEWQTY > @QTY                                                                                   
   BEGIN                     
 SELECT @NEWQTY = @QTY                                               
   END                    
                                        
   UPDATE #DEL SET TOSELLQTY = @NEWQTY                                                                                            
   WHERE SNO = @SNO                                                                                  
                                                                                            
   SET @AMOUNT = @AMOUNT - (@CL_RATE * @NEWQTY)                    
                    
  END         
  FETCH NEXT FROM @DELCUR INTO @SNO, @SETT_NO, @SETT_TYPE, @SCRIP_CD, @SERIES, @QTY, @CL_RATE, @START_DATE, @HOLDTYPE, @SCRIP_CATEGORY                                                        
 END                                                                              
 CLOSE @DELCUR                      
 DEALLOCATE @DELCUR                                            
 FETCH NEXT FROM @LEDCUR INTO @PARTY_CODE, @AMOUNT                                                                                            
END                                                                                            
CLOSE @LEDCUR                                                                                           
DEALLOCATE @LEDCUR                       
    
    
if @NOOFDAYS = 7     
BEGIN                                                                         
 DELETE FROM TBL_RMS_SALE                                                                                    
 WHERE PROCESS_DATE LIKE @PROCESS_DATE + '%'                              
 AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY                        
                                                                               
 INSERT INTO TBL_RMS_SALE                                                                                
 SELECT D.EXCHANGE,SETT_NO,SETT_TYPE,D.PARTY_CODE,LONG_NAME,BRANCH_CD,                                                                                            
 SCRIP_CD,SERIES,QTY,CL_RATE,LEDAMT,TOSELLQTY,                                                                                            
 START_DATE, HOLDAMT = QTY*CL_RATE, SELLAMT = TOSELLQTY*CL_RATE,                                                                                     
 NOOFDAYS=@NOOFDAYS,DEBITVALUE=@DEBITVALUE,DEBITMARKUP=@DEBITMARKUP,CLRATEHAIRCUT=@CLRATEHAIRCUT,CLTYPEPARA=@CLTYPE,                        
 PROCESS_DATE = CONVERT(DATETIME,@PROCESS_DATE), RUNDATE = GETDATE(), HOLDTYPE,                    
 CERTNO, SCRIP_CATEGORY                                                                                  
 FROM #DEL D, CLIENT_DETAILS C                                    
 WHERE C.CL_CODE = D.PARTY_CODE                                                                                       
 AND TOSELLQTY > 0                                                               
 AND D.PARTY_CODE IN (SELECT PCODE FROM  #V_USERLIST)                                                                          
 ORDER BY D.PARTY_CODE, START_DATE,                                                                                             
 CL_RATE, SCRIP_CD, SERIES                                                            
      
 INSERT INTO TBL_RMS_SALE_HISTORY                                                              
 SELECT D.EXCHANGE,SETT_NO,SETT_TYPE,D.PARTY_CODE,LONG_NAME,BRANCH_CD,                                                                                          
 SCRIP_CD,SERIES,QTY,CL_RATE,LEDAMT,TOSELLQTY,                                                                                            
 START_DATE, HOLDAMT = QTY*CL_RATE, SELLAMT = TOSELLQTY*CL_RATE,                                                                                     
 NOOFDAYS=@NOOFDAYS,DEBITVALUE=@DEBITVALUE,DEBITMARKUP=@DEBITMARKUP,CLRATEHAIRCUT=@CLRATEHAIRCUT,CLTYPEPARA=@CLTYPE,                                                                                      
 PROCESS_DATE = CONVERT(DATETIME,@PROCESS_DATE), RUNDATE = GETDATE(), HOLDTYPE,                                                         
 CERTNO, SCRIP_CATEGORY                                                                                    
 FROM #DEL D, CLIENT_DETAILS C                                                                                            
 WHERE C.CL_CODE = D.PARTY_CODE                                              
 AND D.PARTY_CODE IN (SELECT PCODE FROM  #V_USERLIST)                                                                                      
 --AND TOSELLQTY > 0                                                                                           
 ORDER BY D.PARTY_CODE, START_DATE,                                                                   
 CL_RATE, SCRIP_CD, SERIES     
END    
ELSE    
BEGIN                                                                         
 DELETE FROM TBL_RMS_SALE_OTHER                                                                                    
 WHERE PROCESS_DATE LIKE @PROCESS_DATE + '%'                              
 AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY                        
    AND NOOFDAYS=@NOOFDAYS    
                                                                            
 INSERT INTO TBL_RMS_SALE_OTHER                                                                                
 SELECT D.EXCHANGE,SETT_NO,SETT_TYPE,D.PARTY_CODE,LONG_NAME,BRANCH_CD,                                                                                            
 SCRIP_CD,SERIES,QTY,CL_RATE,LEDAMT,TOSELLQTY,                                                                                            
 START_DATE, HOLDAMT = QTY*CL_RATE, SELLAMT = TOSELLQTY*CL_RATE,                                                                                     
 NOOFDAYS=@NOOFDAYS,DEBITVALUE=@DEBITVALUE,DEBITMARKUP=@DEBITMARKUP,CLRATEHAIRCUT=@CLRATEHAIRCUT,CLTYPEPARA=@CLTYPE,                        
 PROCESS_DATE = CONVERT(DATETIME,@PROCESS_DATE), RUNDATE = GETDATE(), HOLDTYPE,                    
 CERTNO, SCRIP_CATEGORY                                                                                  
 FROM #DEL D, CLIENT_DETAILS C                                    
 WHERE C.CL_CODE = D.PARTY_CODE                                                                                       
 AND TOSELLQTY > 0                                                               
 AND D.PARTY_CODE IN (SELECT PCODE FROM  #V_USERLIST)                                                                          
 ORDER BY D.PARTY_CODE, START_DATE,                                                                                             
 CL_RATE, SCRIP_CD, SERIES                                                            
      
 INSERT INTO TBL_RMS_SALE_OTHER_HISTORY                                                              
 SELECT D.EXCHANGE,SETT_NO,SETT_TYPE,D.PARTY_CODE,LONG_NAME,BRANCH_CD,   
 SCRIP_CD,SERIES,QTY,CL_RATE,LEDAMT,TOSELLQTY,                                                                                            
 START_DATE, HOLDAMT = QTY*CL_RATE, SELLAMT = TOSELLQTY*CL_RATE,                                                                                     
 NOOFDAYS=@NOOFDAYS,DEBITVALUE=@DEBITVALUE,DEBITMARKUP=@DEBITMARKUP,CLRATEHAIRCUT=@CLRATEHAIRCUT,CLTYPEPARA=@CLTYPE,                                                                                      
 PROCESS_DATE = CONVERT(DATETIME,@PROCESS_DATE), RUNDATE = GETDATE(), HOLDTYPE,                                                                                  
 CERTNO, SCRIP_CATEGORY                                                                                    
 FROM #DEL D, CLIENT_DETAILS C                                                                                            
 WHERE C.CL_CODE = D.PARTY_CODE                                              
 AND D.PARTY_CODE IN (SELECT PCODE FROM  #V_USERLIST)                                                                                      
 --AND TOSELLQTY > 0                                                                                           
 ORDER BY D.PARTY_CODE, START_DATE,                                                                   
 CL_RATE, SCRIP_CD, SERIES     
END

GO
