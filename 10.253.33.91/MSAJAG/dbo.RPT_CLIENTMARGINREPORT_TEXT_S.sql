-- Object: PROCEDURE dbo.RPT_CLIENTMARGINREPORT_TEXT_S
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


      
                                  
/*                                  
Exec RPT_CLIENTMARGINREPORT_TEST 'JUN 13 2012','','zzzzzzzzzzzz','','zzzzz','broker','broker','','zzzzzzzzzzzz'                                   
select top 5  *  from margin_reporting where sauda_date like '%jun 13 2012%'                                  
*/                                  
                                  
                                  
CREATE PROC [dbo].[RPT_CLIENTMARGINREPORT_TEXT_S]                                  
 (                                        
 @MDATE VARCHAR(11),                                        
 @FROMBRANCH VARCHAR(15),                                        
 @TOBRANCH VARCHAR(15),                      
@BRANCHFLAG VARCHAR(10),                                         
 @FROMPARTY VARCHAR(15),                                        
 @TOPARTY VARCHAR(15),                                        
 @STATUSID VARCHAR(15),                                        
 @STATUSNAME VARCHAR(25),                                      
 @FROMSUBBROKER VARCHAR(15) = '',                                      
 @TOSUBBROKER VARCHAR(15) ='zzzzzzzz',                                  
 @PRINTF VARCHAR(6) = 'ALL',                                  
 @DigiFlag VARCHAR(7) = 'ALL'                                  
 )                                        
                                         
 AS                                        
                                        
 IF ISNULL(@PRINTF,'') = ''                                   
 SELECT @PRINTF = 'ALL'                                  
                                  
 IF ISNULL(@DigiFlag,'') = ''                                   
 SELECT @DigiFlag = 'ALL'                                  
                               
 DECLARE @PLEDGEDATE VARCHAR(11)                              
                              
 SELECT @PLEDGEDATE = LEFT(MAX(PLEDGE_DATE),11)                              
 FROM                                  
  AngelNSECM.MSAJAG.DBO.TBL_ANG_PARTY_PLEDGE                                  
 WHERE                                  
  PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY                                        
  AND PLEDGE_DATE < @MDATE                              
                              
                                        
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED                                        
 SELECT                                      
  EXCHANGE = 'NSE',                                      
  SEGMENT = 'CAPITAL',                                         
  MDT_FD = SUM(PREV_FD),                                         
  MDT_BG = SUM(PREV_BG),                                         
  MDT_SEC = SUM(PREV_SEC),                                         
  MDT_CASH= SUM(PREV_CASH),                                         
  MDT_TOTAL = SUM((PREV_FD+PREV_BG+PREV_SEC+PREV_CASH)),                                        
  MAR_UTILISED = SUM(PREV_VAR),                                        
  MDT1_FD = SUM(CURR_FD),                                        
  MDT1_BG = SUM(CURR_BG),                                        
  MDT1_SEC= SUM(CURR_SEC),                                        
  MDT1_CASH = SUM(CURR_CASH),                                        
  MDT1_TOTAL= SUM((CURR_FD+CURR_BG+CURR_SEC+CURR_CASH)),                                        
  MAR_ADJUSTMENT = SUM(MAR_ADJUST),                                        
  MAR_STATUS = SUM(MAR_STATUS),                                        
  M.PARTY_CODE,                                   
  MAR_FLAG = 1,                                  
  ISIN = CONVERT(VARCHAR(20),''),                                  
  SCRIP_NAME = CONVERT(VARCHAR(100),''),                                  
  HOLDING_QTY = CONVERT(INT,0),                                  
  AMOUNT = CONVERT(NUMERIC(18,4),0),                                  
  FREE_QTY = CONVERT(INT,0),                                  
  PLEDGE_QTY = CONVERT(INT,0)            
 INTO                                  
 #MARGIN                                  
 FROM                                        
  MARGIN_REPORTING M (NOLOCK)                                     
 WHERE                                        
  M.PARTY_CODE >= @FROMPARTY                              
  AND M.PARTY_CODE <= @TOPARTY                        
  AND SAUDA_DATE BETWEEN @MDATE AND @MDATE + ' 23:59:59'                               
--- AND (PREV_SEC+CURR_SEC)<>0                                  
 GROUP BY                                  
  M.PARTY_CODE                                  
                                  
                                  
--SELECT                                   
-- PARTY_CODE = m.PARTY_CODE,                                  
-- ISIN  = CERTNO,                                  
-- SCRIP_CD,                                  
-- SERIES,                                  
-- SCRIP_NAME = CONVERT(VARCHAR(100),''),                                  
-- HOLDING_QTY = SUM(QTY),                                  
-- AMOUNT  = SUM(CURR_CL_RATE * QTY),                                  
-- FREE_QTY = CONVERT(INT,0),                   
-- PLEDGE_QTY = CONVERT(INT,0)                                  
--INTO                                  
-- #HOLDING                                  
--FROM                                  
-- MARGIN_REPORT_HOLDING (nolock) m,                                
--#MARGIN  (nolock)m1                                
--WHERE                                
--  m.PARTY_CODE=m1.PARTY_CODE                                
-- and m.PARTY_CODE between @FROMPARTY and @TOPARTY                                        
-- AND m.SAUDA_DATE BETWEEN @MDATE AND @MDATE + ' 23:59:59'                           
----AND FLAG=0                             
                               
--GROUP BY                                  
-- CERTNO,                                  
-- SCRIP_CD,                                  
-- SERIES,                                  
-- m.PARTY_CODE             
                             
                                  
                       
--UPDATE                                   
-- #HOLDING                                   
--SET                                  
-- PLEDGE_QTY = QTY                                  
--FROM                                  
-- (                                  
-- SELECT                                   
--  PARTY_CODE,                                  
--  QTY = SUM(PLEDGE_QTY),                                  
--  ISIN                                  
-- FROM                                  
--  AngelNSECM.MSAJAG.DBO.TBL_ANG_PARTY_PLEDGE                                  
-- WHERE                                  
--  PARTY_CODE >= @FROMPARTY                                        
--  AND PARTY_CODE <= @TOPARTY                                        
----  AND PLEDGE_DATE BETWEEN @MDATE AND @MDATE + ' 23:59:59'                               
-- AND LEFT(PLEDGE_DATE,11) = LEFT(@PLEDGEDATE,11)                              
--  AND SEGMENT = 'NSECM'                                  
-- GROUP BY                                  
--  PARTY_CODE,                                  
--  ISIN                                  
-- ) P                                  
--WHERE                                  
-- #HOLDING.PARTY_CODE = P.PARTY_CODE                                  
-- AND #HOLDING.ISIN = P.ISIN                                      
                                  
----UPDATE                                     
---- #HOLDING                                  
----SET                                  
---- SCRIP_NAME = S1.LONG_NAME                                  
----FROM                                  
---- SCRIP1 S1 (NOLOCK), SCRIP2 S2 (NOLOCK)                                  
----WHERE                                  
---- S1.CO_CODE = S2.CO_CODE                                  
---- AND S1.SERIES = S2.SERIES                                  
----AND S2.BSECODE = #HOLDING.SCRIP_CD                         
                        
                        
--UPDATE                    
-- #HOLDING                        
--SET                                  
-- SCRIP_NAME = M.SCRIP_CD                                  
--FROM                                  
-- SCRIP1 S1 (NOLOCK), SCRIP2 S2 (NOLOCK) ,ANGELDEMAT.MSAJAG.DBO.MULTIISIN M (NOLOCK)                                  
--WHERE                                  
-- S1.CO_CODE = S2.CO_CODE                                  
-- AND S1.SERIES = S2.SERIES                                  
--AND S2.SCRIP_CD = #HOLDING.SCRIP_CD                         
--AND M.ISIN=#HOLDING.ISIN                                
  
  
--  /** Changes done as per requirement (Only Pledger Client's Holding Required    
-- Changes done on 28/05/2013**/     
     
-- DELETE FROM #HOLDING WHERE PARTY_CODE NOT IN (    
-- SELECT DISTINCT PARTY_CODE FROM #HOLDING WHERE PLEDGE_QTY <>0)                   
--   /* Completed**/        
                         
                        
----UPDATE                                     
---- #HOLDING                                    
----SET                                    
---- SCRIP_NAME = M.SCRIP_CD                        
----FROM                                    
----  MULTIISIN M (NOLOCK)                 
----WHERE                                    
---- M.SCRIP_CD = #HOLDING.SCRIP_CD                                    
---- AND M.SERIES = #HOLDING.SERIES                                    
---- AND M.ISIN = #HOLDING.ISIN                                 
                                  
-- INSERT INTO #MARGIN                                   
-- SELECT                                      
--  EXCHANGE = 'NSE',                                      
--  SEGMENT = 'CAPITAL',                                         
--  MDT_FD = 0,                                         
--  MDT_BG = 0,                                  
--  MDT_SEC = 0,                                  
--  MDT_CASH= 0,                                  
--  MDT_TOTAL = 0,                                  
--  MAR_UTILISED = 0,                                  
--  MDT1_FD = 0,                                        
--  MDT1_BG = 0,                                  
--  MDT1_SEC= 0,                                  
--  MDT1_CASH = 0,                                  
--  MDT1_TOTAL= 0,                                        
--  MAR_ADJUSTMENT = 0,                                        
--  MAR_STATUS = 0,                                  
--  PARTY_CODE,                                   
--  MAR_FLAG = 2,                                  
--  ISIN,                      
--  SCRIP_NAME,                                  
--  HOLDING_QTY = SUM(HOLDING_QTY),                                  
--  AMOUNT = SUM(AMOUNT),                                  
--  FREE_QTY = (                                  
--  CASE                                  
-- WHEN SUM(PLEDGE_QTY) > SUM(HOLDING_QTY) THEN 0                                  
-- ELSE SUM(HOLDING_QTY-PLEDGE_QTY)                                  
--  END),                                  
--  PLEDGE_QTY = (                           
--  CASE                                  
-- WHEN SUM(PLEDGE_QTY) > SUM(HOLDING_QTY) THEN SUM(HOLDING_QTY)                                  
-- ELSE SUM(PLEDGE_QTY)                                  
--  END)                                  
--FROM                                   
--  #HOLDING                                  
--GROUP BY                                  
--  PARTy_CODE,                 
--SCRIP_NAME,                                 
--  ISIN                
                            
                  
                                  
                                  
 SELECT                      
  EXCHANGE = M.EXCHANGE,                                      
  SEGMENT = M.SEGMENT,                                  
  MDT_FD,                                         
  MDT_BG,                                  
  MDT_SEC,                                  
  MDT_CASH,                                  
  MDT_TOTAL,                                  
  MAR_UTILISED,                                  
  MDT1_FD,                                        
  MDT1_BG,                                  
  MDT1_SEC,                                  
  MDT1_CASH,                                  
  MDT1_TOTAL,                                  
  MAR_ADJUSTMENT,                      
  MAR_STATUS,                                  
  PARTY_CODE = M.PARTY_CODE,                                   
  MAR_FLAG,                                  
  ISIN,                                  
  SCRIP_NAME,                                  
  HOLDING_QTY,                                  
  AMOUNT,                                  
  FREE_QTY,                                  
  PLEDGE_QTY,                                  
  C1.LONG_NAME,                                        
  C1.L_ADDRESS1,                                        
  C1.L_ADDRESS2,                                        
  C1.L_ADDRESS3,                                        
  C1.L_CITY,                                        
  C1.L_ZIP,                               
  C1.L_STATE,                                        
  C1.L_NATION,                                        
  C1.EMAIL,                                        
  C1.PAN_GIR_NO,                                        
  C1.BRANCH_CD,                                        
  C1.SUB_BROKER                       
INTO #CONTRACTTEXT                                  
FROM                                  
  #MARGIN M (NOLOCK),                                  
  CLIENT1 C1 (NOLOCK),                                  
  --CONTRACT_MASTER C2 (NOLOCK),                                    
  CLIENT2 C2 (NOLOCK),                                    
  MSAJAG.DBO.FUN_PRINTF(@PRINTF) P                                          
 WHERE                                        
  M.PARTY_CODE = C2.PARTY_CODE                                  
  AND C1.CL_CODE = C2.PARTY_CODE             
 AND C1.CL_TYPE<>'NRI'                              
  AND C2.PRINTF = P.PRINTF                                           
  ---AND Left(Convert(Varchar,convert(DateTime,start_date,103),109),11) BETWEEN @MDATE AND @MDATE + ' 23:59'                                  
  --AND C1.BRANCH_CD  >= @FROMBRANCH                                        
 -- AND C1.BRANCH_CD  <= @TOBRANCH                                        
  AND C1.SUB_BROKER >= @FROMSUBBROKER                      
  AND C1.SUB_BROKER <= @TOSUBBROKER                                      
  AND @STATUSNAME = (                                         
  CASE                                       
         WHEN @STATUSID = 'BROKER'                                       
         THEN 'BROKER'                                       
         WHEN @STATUSID = 'BRANCH'                                       
         THEN C1.BRANCH_CD                                       
         WHEN @STATUSID = 'SUBBROKER'                              
         THEN C1.SUB_BROKER                                       
         WHEN @STATUSID = 'TRADER'                                       
         THEN C1.TRADER                                       
         WHEN @STATUSID = 'FAMILY'                                       
         THEN C1.FAMILY                                       
         WHEN @STATUSID = 'AREA'                                       
         THEN C1.AREA                                       
         WHEN @STATUSID = 'REGION'                                       
         THEN C1.REGION                                       
         WHEN @STATUSID = 'CLIENT'                                       
         THEN M.PARTY_CODE                                       
ELSE 'I DONT KNOW' END)                              
                                  
     AND 1 = (CASE WHEN @DIGIFLAG = 'ALL'                                     
       THEN 1                                     
       ELSE (CASE WHEN M.PARTY_CODE IN (SELECT PARTY_CODE FROM TBL_ECNBOUNCED T WHERE LEFT(T.SDate,11) = @MDATE)                                     
         THEN 1                                    
         ELSE 0                        
          END)                                    
     END)                                        
 ORDER BY             
                                    
  C1.BRANCH_CD,                                        
  C1.SUB_BROKER,                                    
  M.PARTY_CODE,                                  
  MAR_FLAG  ,scrip_name                     
                      
CREATE INDEX [TEXTINDEX]                                       
        ON [dbo].[#CONTRACTTEXT]                                       
        (                                       
                [PARTY_CODE]                                       
        )                         
                        
                          
                            
IF @BRANCHFLAG='BRANCH'                            
    SELECT * FROM #CONTRACTTEXT                            
    WHERE BRANCH_CD BETWEEN @FROMBRANCH AND @TOBRANCH                            
ELSE                            
    SELECT * FROM #CONTRACTTEXT T LEFT OUTER JOIN BRANCHGROUP BG                               
           ON T.BRANCH_CD=BG.BRANCH_CODE                                     
    --WHERE  BG.BRANCH_GROUP BETWEEN @FROMBRANCH AND @TOBRANCH                   
WHERE  BG.BRANCH_GROUP >= @FROMBRANCH AND BG.BRANCH_GROUP <=@FROMBRANCH                         
    ORDER BY BG.BRANCH_GROUP,Party_code,Mar_flag                            
                            
DROP TABLE #CONTRACTTEXT

GO
