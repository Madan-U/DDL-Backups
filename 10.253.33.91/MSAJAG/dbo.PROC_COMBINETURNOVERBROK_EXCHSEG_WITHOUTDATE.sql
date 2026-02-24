-- Object: PROCEDURE dbo.PROC_COMBINETURNOVERBROK_EXCHSEG_WITHOUTDATE
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




CREATE PROC [dbo].[PROC_COMBINETURNOVERBROK_EXCHSEG_WITHOUTDATE]         
(        
 @STATUSID		VARCHAR(25),      
 @STATUSNAME		VARCHAR(25),      
 @FROMDATE		VARCHAR(11),        
 @TODATE		VARCHAR(11),        
 @FROMPARTY		VARCHAR(20),        
 @TOPARTY		VARCHAR(20)
)        
        
AS        

IF CHARINDEX('/', @FROMDATE) > 0
BEGIN
	SET @FROMDATE = CONVERT(VARCHAR(11), CONVERT(DATETIME, @FROMDATE, 103), 109)
END

IF CHARINDEX('/', @TODATE) > 0
BEGIN
	SET @TODATE = CONVERT(VARCHAR(11), CONVERT(DATETIME, @TODATE, 103), 109)
END

-- EXEC PROC_COMBINETURNOVERBROK 'broker','broker','01/01/2010', '31/12/2020', '0', 'ZZ'   
      
SELECT PARTY_CODE, CLIENTTYPE, SAUDA_DATE, EXCHANGE = 'NSE', SEGMENT = 'CAPITAL',           
TOTTRD = SUM(TRDAMT-DELAMT), TOTDEL = SUM(DELAMT),          
BRKTRD = SUM(PBROKTRD + SBROKTRD), BRKDEL = SUM(PBROKDEL + SBROKDEL),        
OWNBRK = SUM(PBROKTRD + SBROKTRD + PBROKDEL + SBROKDEL)        
INTO #TURNOVER FROM CMBILLVALAN V        
WHERE SAUDA_DATE BETWEEN @FROMDATE AND @TODATE + ' 23:59:59'        
AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY         
AND TRADETYPE IN ('I', 'S')      
AND @STATUSNAME =                 
                  (CASE                 
                        WHEN @STATUSID = 'BRANCH' THEN BRANCH_CD                
                        WHEN @STATUSID = 'SUBBROKER' THEN SUB_BROKER                
                        WHEN @STATUSID = 'TRADER' THEN TRADER                
                        WHEN @STATUSID = 'FAMILY' THEN FAMILY                
                        WHEN @STATUSID = 'AREA' THEN AREA                
                        WHEN @STATUSID = 'REGION' THEN REGION                
                        WHEN @STATUSID = 'CLIENT' THEN PARTY_CODE                
                  ELSE                 
                        'BROKER'                
                  END)                     
GROUP BY PARTY_CODE, CLIENTTYPE, SAUDA_DATE          
        
INSERT INTO #TURNOVER          
SELECT PARTY_CODE, CLIENTTYPE, SAUDA_DATE, EXCHANGE = 'BSE', SEGMENT = 'CAPITAL',           
TOTTRD = SUM(TRDAMT-DELAMT), TOTDEL = SUM(DELAMT),          
BRKTRD = SUM(PBROKTRD + SBROKTRD), BRKDEL = SUM(PBROKDEL + SBROKDEL),        
OWNBRK = SUM(PBROKTRD + SBROKTRD + PBROKDEL + SBROKDEL)          
FROM AngelBSECM.BSEDB_ab.DBO.CMBILLVALAN V        
WHERE SAUDA_DATE BETWEEN @FROMDATE AND @TODATE + ' 23:59:59'        
AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY          
AND TRADETYPE IN ('I', 'S')      
AND @STATUSNAME =                 
                  (CASE                 
                        WHEN @STATUSID = 'BRANCH' THEN BRANCH_CD                
                        WHEN @STATUSID = 'SUBBROKER' THEN SUB_BROKER                
                        WHEN @STATUSID = 'TRADER' THEN TRADER                
                        WHEN @STATUSID = 'FAMILY' THEN FAMILY                
                        WHEN @STATUSID = 'AREA' THEN AREA                
                        WHEN @STATUSID = 'REGION' THEN REGION                
                        WHEN @STATUSID = 'CLIENT' THEN PARTY_CODE                
                  ELSE                 
                        'BROKER'                
                  END)        
GROUP BY PARTY_CODE, CLIENTTYPE, SAUDA_DATE        
        
INSERT INTO #TURNOVER        
SELECT PARTY_CODE, CLIENTTYPE = CLIENT_TYPE, SAUDA_DATE, EXCHANGE = 'NSE', SEGMENT = 'FUTURES',           
TOTTRD = SUM((PRATE*PQTY)+(SRATE*SQTY)), TOTDEL = 0,          
BRKTRD = SUM(PBROKAMT + SBROKAMT), BRKDEL = 0,        
OWNBRK = SUM(PBROKAMT + SBROKAMT)        
FROM angelfo.NSEFO.DBO.FOBILLVALAN V        
WHERE SAUDA_DATE BETWEEN @FROMDATE AND @TODATE + ' 23:59:59'        
AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY         
AND TRADETYPE = 'BT'              
AND @STATUSNAME =                 
                  (CASE                 
                        WHEN @STATUSID = 'BRANCH' THEN BRANCH_CODE                
                        WHEN @STATUSID = 'SUBBROKER' THEN SUB_BROKER                
                        WHEN @STATUSID = 'TRADER' THEN TRADER                
                        WHEN @STATUSID = 'FAMILY' THEN FAMILY                
                        WHEN @STATUSID = 'AREA' THEN AREA                
						WHEN @STATUSID = 'REGION' THEN REGION                
                        WHEN @STATUSID = 'CLIENT' THEN PARTY_CODE                
                  ELSE      
                        'BROKER'                
                  END)            
GROUP BY PARTY_CODE, CLIENT_TYPE, SAUDA_DATE         
      
INSERT INTO #TURNOVER        
SELECT PARTY_CODE, CLIENTTYPE = CLIENT_TYPE, SAUDA_DATE, EXCHANGE = 'NSX', SEGMENT = 'FUTURES',           
TOTTRD = SUM((PRATE*PQTY)+(SRATE*SQTY)), TOTDEL = 0,          
BRKTRD = SUM(PBROKAMT + SBROKAMT), BRKDEL = 0,        
OWNBRK = SUM(PBROKAMT + SBROKAMT)        
FROM angelfo.NSECURFO.DBO.FOBILLVALAN V        
WHERE SAUDA_DATE BETWEEN @FROMDATE AND @TODATE + ' 23:59:59'        
AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY         
AND TRADETYPE = 'BT'                    
AND (PQTY+SQTY) > 0  
GROUP BY PARTY_CODE, CLIENT_TYPE, SAUDA_DATE     
  
INSERT INTO #TURNOVER        
SELECT PARTY_CODE, CLIENTTYPE = CLIENT_TYPE, SAUDA_DATE, EXCHANGE = 'MCX', SEGMENT = 'FUTURES',           
TOTTRD = SUM(ISNULL(PRATE*PQTY*NUMERATOR/DENOMINATOR + SRATE*SQTY*NUMERATOR/DENOMINATOR,0)), TOTDEL = 0,          
BRKTRD = SUM(PBROKAMT + SBROKAMT), BRKDEL = 0,        
OWNBRK = SUM(PBROKAMT + SBROKAMT)        
FROM angelcommodity.MCDX.DBO.FOBILLVALAN V        
WHERE SAUDA_DATE BETWEEN @FROMDATE AND @TODATE + ' 23:59:59'        
AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY          
AND TRADETYPE = 'BT'      
AND @STATUSNAME =                 
                  (CASE                 
                        WHEN @STATUSID = 'BRANCH' THEN BRANCH_CODE                
                        WHEN @STATUSID = 'SUBBROKER' THEN SUB_BROKER                
                        WHEN @STATUSID = 'TRADER' THEN TRADER                
                        WHEN @STATUSID = 'FAMILY' THEN FAMILY                
                        WHEN @STATUSID = 'AREA' THEN AREA                
                        WHEN @STATUSID = 'REGION' THEN REGION                
                        WHEN @STATUSID = 'CLIENT' THEN PARTY_CODE                
                  ELSE                 
                        'BROKER'                
                  END)                    
GROUP BY PARTY_CODE, CLIENT_TYPE, SAUDA_DATE        
        
INSERT INTO #TURNOVER        
SELECT PARTY_CODE, CLIENTTYPE = CLIENT_TYPE, SAUDA_DATE, EXCHANGE = 'NCX', SEGMENT = 'FUTURES',           
TOTTRD = SUM((PRATE+SRATE+STRIKE_PRICE)*(PQTY+SQTY)*NUMERATOR/DENOMINATOR), TOTDEL = 0,          
BRKTRD = SUM(PBROKAMT + SBROKAMT), BRKDEL = 0,        
OWNBRK = SUM(PBROKAMT + SBROKAMT)        
FROM angelcommodity.NCDX.DBO.FOBILLVALAN V        
WHERE SAUDA_DATE BETWEEN @FROMDATE AND @TODATE + ' 23:59:59'        
AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY            
AND TRADETYPE = 'BT'      
AND @STATUSNAME =                 
                  (CASE                 
                        WHEN @STATUSID = 'BRANCH' THEN BRANCH_CODE                
                        WHEN @STATUSID = 'SUBBROKER' THEN SUB_BROKER                
                        WHEN @STATUSID = 'TRADER' THEN TRADER                
                        WHEN @STATUSID = 'FAMILY' THEN FAMILY                
                        WHEN @STATUSID = 'AREA' THEN AREA                
                        WHEN @STATUSID = 'REGION' THEN REGION                
                        WHEN @STATUSID = 'CLIENT' THEN PARTY_CODE           
                  ELSE                 
                        'BROKER'                
                  END)                    
GROUP BY PARTY_CODE, CLIENT_TYPE, SAUDA_DATE        

       
SELECT	--PARTY_CODE, 
		--SAUDA_DATE, 
		EXCHANGE, 
		SEGMENT,           
		TRD_TURNOVER = SUM(TOTTRD), 
		DEL_TURNOVER = SUM(TOTDEL),          
		TRD_BROKERAGE = SUM(BRKTRD), 
		DEL_BROKERAGE = SUM(BRKDEL)
FROM	#TURNOVER 
GROUP BY 
		--PARTY_CODE, 
		--SAUDA_DATE, 
		EXCHANGE, 
		SEGMENT
ORDER BY
		--PARTY_CODE, 
		--SAUDA_DATE
		EXCHANGE, 
		SEGMENT		


--EXEC  PROC_COMBINETURNOVERBROK_EXCHSEG_WITHOUTDATE 'BROKER','BROKER','APR  1 2020','APR 23 2020','','ZZZZZZ'

GO
