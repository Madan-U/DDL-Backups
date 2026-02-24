-- Object: PROCEDURE dbo.PROC_PNLPROCESS_DAILY_05MAY
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

    
CREATE PROC [DBO].[PROC_PNLPROCESS_DAILY_05MAY]                                              
(                                                                          
 @SAUDA_DATE VARCHAR(11),                                                                           
 @FROMPARTY  VARCHAR(10),                                                                          
 @TOPARTY    VARCHAR(10)                                                                          
)                                                                          
AS                                                                      
                                                                          
DECLARE                                                                            
       @PREVDATE   VARCHAR(11),                                                                                    
       @PARTY_CODE VARCHAR(10),                                                                           
       @SCRIP_CD   VARCHAR(12),                                                                                    
       @BSECODE    VARCHAR(12),                                                                                    
       @SERIES     VARCHAR(3),                                                                                   
       @ISIN    VARCHAR(12),                                                                                    
       @PQTY       INT,                                                                                    
       @SQTY       INT,                                                                                    
       @PDIFF      INT,                                                                                    
       @TRDQTY     INT,                                                                                    
       @SETTCUR    CURSOR,                                                                                    
       @BUYSNO        NUMERIC,                                                                                    
       @SELLSNO        NUMERIC,                                                                    
       @BUYSAUDA_DATE   DATETIME,                                                                    
       @SELLSAUDA_DATE   DATETIME,                                                          
    @TEMPORGDATE DATETIME,                                                                                    
       @SETTREC    CURSOR                                                                          
                                                                          
SELECT @PREVDATE = ISNULL(LEFT(MAX(MARGINDATE),11),'APR  1 2004')                                                                                    
FROM  TBL_PNL_DATA_05MAY                                                                          
WHERE MARGINDATE < CONVERT(DATETIME,@SAUDA_DATE)                                                                          
                                              
SELECT * INTO #BSEMULTIISIN                                              
FROM ANGELDEMAT.BSEDB.DBO.MULTIISIN M                                                                          
WHERE VALID = 1                                               
                                              
SELECT * INTO #BSECMBILLVALAN                                              
FROM ANAND.BSEDB_AB.DBO.CMBILLVALAN                                              
WHERE SAUDA_DATE BETWEEN @SAUDA_DATE AND @SAUDA_DATE + ' 23:59'                                                                
AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY     


SELECT * INTO #NSESETTLEMENT  FROM 
(SELECT * FROM SETTLEMENT WITH(NOLOCK) WHERE SAUDA_DATE BETWEEN @SAUDA_DATE AND @SAUDA_DATE + ' 23:59' 
UNION ALL
SELECT *,'1' FROM HISTORY WITH(NOLOCK) WHERE SAUDA_DATE BETWEEN @SAUDA_DATE AND @SAUDA_DATE + ' 23:59')A


SELECT * INTO #BSESETTLEMENT  FROM 
(SELECT * FROM ANAND.BSEDB_AB.DBO.SETTLEMENT WITH(NOLOCK) WHERE SAUDA_DATE BETWEEN @SAUDA_DATE AND @SAUDA_DATE + ' 23:59' 
UNION ALL
SELECT *,'1' FROM ANAND.BSEDB_AB.DBO.HISTORY WITH(NOLOCK) WHERE SAUDA_DATE BETWEEN @SAUDA_DATE AND @SAUDA_DATE + ' 23:59')A

          
                                          
/*                                                                          
DELETE FROM TBL_PNL_DATA_05MAY                                                                          
WHERE MARGINDATE = @SAUDA_DATE                                                      
AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY                                                
*/                                                    
             
                                                        
DELETE FROM TBL_PNL_DATA_05MAY                                                              
WHERE SAUDA_DATE >= @SAUDA_DATE                                                                       
AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY                                                                          
                                                
UPDATE TBL_PNL_DATA_05MAY SET BILLFLAG = (CASE WHEN SELL_BUY = 1 THEN 4 ELSE 5 END),                                                                          
MARGINDATE = LEFT(SAUDA_DATE, 11),OPPDATE='DEC 31 2049'                                                                          
WHERE MARGINDATE >= @SAUDA_DATE                                                                          
AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY                                                                          
                             
TRUNCATE TABLE TBL_PNL_DATA_TMP_05MAY            
        
---- NSECM ----                                             
                                                                          
INSERT INTO TBL_PNL_DATA_TMP_05MAY                                                       
SELECT EXCHANGE,MARGINDATE=@SAUDA_DATE,TRADETYPE='BF',SETT_NO,SETT_TYPE,PARTY_CODE,SCRIP_CD,SERIES,                                                                    
BSECODE,ISIN,USER_ID,CONTRACTNO,ORDER_NO,TRADE_NO,SAUDA_DATE,TRADEQTY,MARKETRATE,                                                                       
PNLRATE,MARKETTYPE,SELL_BUY,INS_CHRG,TURN_TAX,OTHER_CHRG,SEBI_TAX,BROKER_CHRG,                                                              
BILLFLAG,NBROKAPP,NSERTAX,N_NETRATE,OPPDATE='DEC 31 2049', ORGDATE, SNO, 0, RECTYPE = 'OPEN'                                                                    
FROM TBL_PNL_DATA_05MAY                                                                          
WHERE /*MARGINDATE = @PREVDATE                                                             
AND*/PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY                                                                          
AND BILLFLAG = 4                                                    
                                                                  
INSERT INTO TBL_PNL_DATA_TMP_05MAY                                                                          
   SELECT EXCHANGE = 'NSE',                                                                       
         MARGINDATE = @SAUDA_DATE,                                                                                    
         TRADETYPE = 'BT',                                                                        
         SETT_NO,                                                                                    
         SETT_TYPE,                                                                                    
         PARTY_CODE,                                                                                    
         SCRIP_CD,                                                                                    
         SERIES,                                                                                    
         BSECODE =  CONVERT(VARCHAR(12), ''),                                                                            
   ISIN = CONVERT(VARCHAR(12), ''),                                                                                  
         USER_ID='',                                                                                    
         CONTRACTNO='',                                                                                    
         ORDER_NO='', TRADE_NO='',                                                                                    
        SAUDA_DATE=LEFT(SAUDA_DATE,11),                            
         TRADEQTY=SUM(TRADEQTY),                               
         MARKETRATE=SUM(TRADEQTY*MARKETRATE)/SUM(TRADEQTY),                                                                          
         PNLRATE = (CASE WHEN SELL_BUY = 1                                                       
       THEN ROUND(SUM(N_NETRATE*TRADEQTY + INS_CHRG + TURN_TAX + OTHER_CHRG + SEBI_TAX + BROKER_CHRG + NSERTAX) / SUM(TRADEQTY), 4)                                                                                
                         ELSE ROUND(SUM(N_NETRATE*TRADEQTY - (INS_CHRG + TURN_TAX + OTHER_CHRG + SEBI_TAX + BROKER_CHRG + NSERTAX)) / SUM(TRADEQTY), 4)                                                                                
                    END),                                                               
         MARKETTYPE='',                                                                                    
   SELL_BUY,                                                                                    
         INS_CHRG=SUM(INS_CHRG),                         
         TURN_TAX=SUM(TURN_TAX),                                                                                    
         OTHER_CHRG=SUM(OTHER_CHRG),                                           
         SEBI_TAX=SUM(SEBI_TAX),                                                                                    
         BROKER_CHRG=SUM(BROKER_CHRG),                                                       
         BILLFLAG=(CASE WHEN SETTFLAG = 1 THEN SELL_BUY + 3 ELSE SETTFLAG END),                                                                                    
         NBROKAPP=SUM(TRADEQTY*NBROKAPP),                                                
         NSERTAX=SUM(NSERTAX),                                                                                    
         N_NETRATE=SUM(N_NETRATE*TRADEQTY)/SUM(TRADEQTY),                                                                      
  OPPDATE=(CASE WHEN SETTFLAG IN (2,3) THEN LEFT(SAUDA_DATE,11) ELSE 'DEC 31 2049' END),                                                          
  ORGDATE=LEFT(SAUDA_DATE,11),                                                                      
   0, 1, RECTYPE = (CASE WHEN SETTFLAG IN (2,3) THEN 'SPEC' ELSE 'OPEN' END)                                                                
  FROM   #NSESETTLEMENT WITH(NOLOCK)                                                                                    
  WHERE  SAUDA_DATE LIKE @SAUDA_DATE + '%'                                                       
         AND AUCTIONPART NOT LIKE 'A%'                                                                                 
         AND TRADEQTY > 0                                                                                    
   AND TRADE_NO NOT LIKE '%C%'                                                                          
   AND MARKETRATE > 0                                                                           
         AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY                                                                          
GROUP BY SETT_NO,                                                                                    
         SETT_TYPE,                                                                                    
         PARTY_CODE,                                                                                    
         SCRIP_CD,                                                                              
         SERIES,SELL_BUY,SETTFLAG,LEFT(SAUDA_DATE,11)                                                    
/*                                                                   
INSERT INTO TBL_PNL_DATA_TMP_05MAY     
   SELECT EXCHANGE = 'NSE',                                                                                    
         MARGINDATE = @SAUDA_DATE,                                         
         TRADETYPE = 'BT',                                            
  SETT_NO,                                                                  
         SETT_TYPE,                                                                 
         PARTY_CODE,                                                                                    
         SCRIP_CD,                                                      
         SERIES,                                                                                    
         BSECODE =  CONVERT(VARCHAR(12), ''),                                                                            
   ISIN = CONVERT(VARCHAR(12), ''),                                                                                  
         USER_ID='',                                                           
         CONTRACTNO='',                                 
         ORDER_NO='',                                                                                    
         TRADE_NO='',                                                                                    
         SAUDA_DATE=LEFT(SAUDA_DATE,11),                                                                                    
         TRADEQTY=SUM(TRADEQTY),                                                             
         MARKETRATE=SUM(TRADEQTY*MARKETRATE)/SUM(TRADEQTY),                                                                   
         PNLRATE = (CASE WHEN SELL_BUY = 1                                                       
       THEN ROUND(SUM(N_NETRATE*TRADEQTY + INS_CHRG + TURN_TAX + OTHER_CHRG + SEBI_TAX + BROKER_CHRG + NSERTAX) / SUM(TRADEQTY), 4)                                                                                
                         ELSE ROUND(SUM(N_NETRATE*TRADEQTY - (INS_CHRG + TURN_TAX + OTHER_CHRG + SEBI_TAX + BROKER_CHRG + NSERTAX)) / SUM(TRADEQTY), 4)                                                                                
                    END),                                                                                    
         MARKETTYPE='',                                                                
         SELL_BUY,                                                                                    
         INS_CHRG=SUM(INS_CHRG),                                                                                    
         TURN_TAX=SUM(TURN_TAX),                                                                                   
         OTHER_CHRG=SUM(OTHER_CHRG),                                                                                    
         SEBI_TAX=SUM(SEBI_TAX),                                  
         BROKER_CHRG=SUM(BROKER_CHRG),                                                                                    
         BILLFLAG=(CASE WHEN SETTFLAG = 1 THEN SELL_BUY + 3 ELSE SETTFLAG END),                                                                                    
         NBROKAPP=SUM(TRADEQTY*NBROKAPP),                                                                           
         NSERTAX=SUM(NSERTAX),                                                                                    
         N_NETRATE=SUM(N_NETRATE*TRADEQTY)/SUM(TRADEQTY),                                                                      
  OPPDATE=(CASE WHEN SETTFLAG IN (2,3) THEN LEFT(SAUDA_DATE,11) ELSE 'DEC 31 2049' END),                                                          
  ORGDATE=LEFT(SAUDA_DATE,11),                                                                      
   0, 1, RECTYPE = (CASE WHEN SETTFLAG IN (2,3) THEN 'SPEC' ELSE 'OPEN' END)                                                                
    FROM  MSAJAG.DBO.HISTORY WITH(NOLOCK)                                   
        
 /*                   
 DROP TABLE BSEDB_AB_HISTORY010411TO180711.DBO.NSEHISTORY_160511_TO_30052011                        
                      
SELECT * INTO BSEDB_AB_HISTORY010411TO180711.DBO.NSEHISTORY_310511_TO_30062011                                   
FROM  MSAJAG.DBO.HISTORY                                   
WHERE SAUDA_DATE BETWEEN '2011-05-31 00:00:00.000' AND '2011-06-30 23:59:59.000'                                  
CREATE CLUSTERED INDEX IX_SAUDA_DATE ON BSEDB_AB_HISTORY010411TO180711.DBO.NSEHISTORY_310511_TO_30062011                                  
(SAUDA_DATE)                                  
*/                                  
                                  
                         
  WHERE  SAUDA_DATE LIKE @SAUDA_DATE + '%'                                                                          
         AND AUCTIONPART NOT LIKE 'A%'                                                                                 
         AND TRADEQTY > 0                                                                                    
  AND TRADE_NO NOT LIKE '%C%'                                                                          
   AND MARKETRATE > 0                                                                           
         AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY                                                                          
GROUP BY SETT_NO,                                                            
         SETT_TYPE,                                                                                    
         PARTY_CODE,                                                                                    
 SCRIP_CD,                                                                                    
         SERIES,SELL_BUY,SETTFLAG,LEFT(SAUDA_DATE,11)                                                                        
                                                  
--INSERT INTO TBL_PNL_DATA_TMP_05MAY                         
--   SELECT EXCHANGE = 'BSE',                                                                                    
--         MARGINDATE = @SAUDA_DATE,                                                                                    
--         TRADETYPE = 'BT',                                                                             
--      SETT_NO,                                                                                    
--         SETT_TYPE,                                                                                    
--         PARTY_CODE,                                                                                    
--    SCRIP_CD= CONVERT(VARCHAR(12), ''),                                                                                    
--         SERIES,                                                         
--         BSECODE =  SCRIP_CD,                                                                            
--   ISIN = CONVERT(VARCHAR(12), ''),                                         
--         USER_ID='',                                                                                    
--         CONTRACTNO='',                                                                                    
--         ORDER_NO='',                                                          
--         TRADE_NO='',                                                                                    
--       SAUDA_DATE=LEFT(SAUDA_DATE,11),                                                                                    
--         TRADEQTY=SUM(TRADEQTY),                                                             
--         MARKETRATE=SUM(TRADEQTY*MARKETRATE)/SUM(TRADEQTY),                                                                          
--         PNLRATE = (CASE WHEN SELL_BUY = 1                                                       
--       THEN ROUND(SUM(N_NETRATE*TRADEQTY + INS_CHRG + TURN_TAX + OTHER_CHRG + SEBI_TAX + BROKER_CHRG + NSERTAX) / SUM(TRADEQTY), 4)                                                                                
--                         ELSE ROUND(SUM(N_NETRATE*TRADEQTY - (INS_CHRG + TURN_TAX + OTHER_CHRG + SEBI_TAX + BROKER_CHRG + NSERTAX)) / SUM(TRADEQTY), 4)                                                                                
--                    END),                      
--         MARKETTYPE='',                                                   
--         SELL_BUY,                                                                                    
--         INS_CHRG=SUM(INS_CHRG),                                                                           
--         TURN_TAX=SUM(TURN_TAX),                                                                                    
--         OTHER_CHRG=SUM(OTHER_CHRG),                                                                                 
--         SEBI_TAX=SUM(SEBI_TAX),                                                                                    
--         BROKER_CHRG=SUM(BROKER_CHRG),                                     
--         BILLFLAG=SETTFLAG,                                                                                    
--         NBROKAPP=SUM(TRADEQTY*NBROKAPP),                                                         
--         NSERTAX=SUM(NSERTAX),                                                                                    
--         N_NETRATE=SUM(N_NETRATE*TRADEQTY)/SUM(TRADEQTY),                                                                      
--  OPPDATE=(CASE WHEN SETTFLAG IN (2,3) THEN LEFT(SAUDA_DATE,11) ELSE 'DEC 31 2049' END),                                                          
--  ORGDATE=LEFT(SAUDA_DATE,11),                                                                      
--   0, 1, RECTYPE = (CASE WHEN SETTFLAG IN (2,3) THEN 'SPEC' ELSE 'OPEN' END)                                                                
--  FROM   ANAND.BSEDB_AB.DBO.SETTLEMENT WITH(NOLOCK)                                                               
--  WHERE  SAUDA_DATE LIKE @SAUDA_DATE + '%'                                                                          
--         AND AUCTIONPART NOT LIKE 'A%'                                                                                 
--         AND TRADEQTY > 0                                   
--   AND TRADE_NO NOT LIKE '%C%'                                                                          
--   AND MARKETRATE > 0                                                                           
--         AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY                                                                          
--GROUP BY SETT_NO,                                                                              
--         SETT_TYPE,                                                                                    
--         PARTY_CODE,                                                                                    
--         SCRIP_CD,                                                                                    
--         SERIES,SELL_BUY,SETTFLAG,LEFT(SAUDA_DATE,11)     
                                                           
     */                                                                   
INSERT INTO TBL_PNL_DATA_TMP_05MAY                                                                    
   SELECT EXCHANGE = 'BSE',                                                                                    
         MARGINDATE = @SAUDA_DATE,                                                                                    
   TRADETYPE = 'BT',                                                                                    
         SETT_NO,                                                                                    
         SETT_TYPE,                                                                                    
         PARTY_CODE,                                     
         SCRIP_CD= CONVERT(VARCHAR(12), ''),                                                                                 
  SERIES,                                                                                    
         BSECODE =  SCRIP_CD,         
   ISIN = CONVERT(VARCHAR(12), ''),      
         USER_ID='',                                                                                    
         CONTRACTNO='',                                       
         ORDER_NO='',                                                       
         TRADE_NO='',                                                                                    
         SAUDA_DATE=LEFT(SAUDA_DATE,11),                                                                                    
         TRADEQTY=SUM(TRADEQTY),                              
         MARKETRATE=SUM(TRADEQTY*MARKETRATE)/SUM(TRADEQTY),                                                                          
         PNLRATE = (CASE WHEN SELL_BUY = 1                                                       
   THEN ROUND(SUM(N_NETRATE*TRADEQTY + INS_CHRG + TURN_TAX + OTHER_CHRG + SEBI_TAX + BROKER_CHRG + NSERTAX) / SUM(TRADEQTY), 4)                                                                                
                         ELSE ROUND(SUM(N_NETRATE*TRADEQTY - (INS_CHRG + TURN_TAX + OTHER_CHRG + SEBI_TAX + BROKER_CHRG + NSERTAX)) / SUM(TRADEQTY), 4)                                                                                
                    END),                                                                
         MARKETTYPE='',                                                                                    
         SELL_BUY,                                                                        
         INS_CHRG=SUM(INS_CHRG),                                                                                    
         TURN_TAX=SUM(TURN_TAX),                                                                                    
         OTHER_CHRG=SUM(OTHER_CHRG),                                                                            
         SEBI_TAX=SUM(SEBI_TAX),                                  
         BROKER_CHRG=SUM(BROKER_CHRG),                                                                                    
         BILLFLAG=(CASE WHEN SETTFLAG = 1 THEN SELL_BUY + 3 ELSE SETTFLAG END),                                                                                    
         NBROKAPP=SUM(TRADEQTY*NBROKAPP),                                                                           
         NSERTAX=SUM(NSERTAX),                                                                            
      N_NETRATE=SUM(N_NETRATE*TRADEQTY)/SUM(TRADEQTY),                                                                      
  OPPDATE=(CASE WHEN SETTFLAG IN (2,3) THEN LEFT(SAUDA_DATE,11) ELSE 'DEC 31 2049' END),                                                          
  ORGDATE=LEFT(SAUDA_DATE,11),                                                                      
   0, 1, RECTYPE = (CASE WHEN SETTFLAG IN (2,3) THEN 'SPEC' ELSE 'OPEN' END)                                                                
  FROM  #BSESETTLEMENT WITH(NOLOCK)                                    
                                        
   /*                           
   DROP TABLE BSEDB_AB_HISTORY010411TO180711.DBO.HISTORY_110411_TO_300411                          
   SELECT * INTO BSEDB_AB_HISTORY010411TO180711.DBO.HISTORY_310511_TO_300611                                  
  FROM  [ANAND].BSEDB_AB.DBO.HISTORY                                   
  WHERE SAUDA_DATE BETWEEN '2011-05-31 00:00:00.000' AND '2011-06-30 23:59:59.000'                                
  GO                                
  CREATE CLUSTERED INDEX IX_SAUDA_DATE ON BSEDB_AB_HISTORY010411TO180711.DBO.HISTORY_310511_TO_300611        
  (SAUDA_DATE)                                  
  */                                  
                                    
                                                                                    
  WHERE  SAUDA_DATE LIKE @SAUDA_DATE + '%'                                                                          
         AND AUCTIONPART NOT LIKE 'A%'      
         AND TRADEQTY > 0                                                                              
   AND TRADE_NO NOT LIKE '%C%'                                                                          
   AND MARKETRATE > 0                                                                          
         AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY                                       
GROUP BY SETT_NO,                                                                                  
         SETT_TYPE,                                                                                    
         PARTY_CODE,                                                                              
         SCRIP_CD,                                                                                    
         SERIES,SELL_BUY,SETTFLAG,LEFT(SAUDA_DATE,11)             
                     
                     
--------------------------MODIFIED BY JAY KHARE 15 DEC 2011----------------------------------------------        
   /*   
INSERT INTO TBL_PNL_DATA_TMP_05MAY                                                                    
   SELECT EXCHANGE = 'BSE',                                                                                    
         MARGINDATE = @SAUDA_DATE,                                                                                    
   TRADETYPE = 'BT',                                                                                    
         SETT_NO,                                                                                    
         SETT_TYPE,                                                                                    
         PARTY_CODE,                                                                           
   SCRIP_CD= CONVERT(VARCHAR(12), ''),                                                                                 
   SERIES,                                                                                    
         BSECODE =  SCRIP_CD,                                                                            
   ISIN = CONVERT(VARCHAR(12), ''),                                                                                  
         USER_ID='',                                                                                    
         CONTRACTNO='',                                                                
         ORDER_NO='',                                                                                    
         TRADE_NO='',                                                                                    
         SAUDA_DATE=LEFT(SAUDA_DATE,11),                                                                                    
         TRADEQTY=SUM(TRADEQTY),                                                             
         MARKETRATE=SUM(TRADEQTY*MARKETRATE)/SUM(TRADEQTY),                                                                          
         PNLRATE = (CASE WHEN SELL_BUY = 1                                                       
       THEN ROUND(SUM(N_NETRATE*TRADEQTY + INS_CHRG + TURN_TAX + OTHER_CHRG + SEBI_TAX + BROKER_CHRG + NSERTAX) / SUM(TRADEQTY), 4)                                                                                
                         ELSE ROUND(SUM(N_NETRATE*TRADEQTY - (INS_CHRG + TURN_TAX + OTHER_CHRG + SEBI_TAX + BROKER_CHRG + NSERTAX)) / SUM(TRADEQTY), 4)                                                                                
                    END),                                                                
         MARKETTYPE='',                                        
         SELL_BUY,                                                    
         INS_CHRG=SUM(INS_CHRG),                                                                                    
 TURN_TAX=SUM(TURN_TAX),                                                                                    
         OTHER_CHRG=SUM(OTHER_CHRG),                                                                            
     SEBI_TAX=SUM(SEBI_TAX),                                  
         BROKER_CHRG=SUM(BROKER_CHRG),                                                                                    
         BILLFLAG=(CASE WHEN SETTFLAG = 1 THEN SELL_BUY + 3 ELSE SETTFLAG END),                                         
         NBROKAPP=SUM(TRADEQTY*NBROKAPP),                                                                           
         NSERTAX=SUM(NSERTAX),                                                                            
      N_NETRATE=SUM(N_NETRATE*TRADEQTY)/SUM(TRADEQTY),                                                                      
  OPPDATE=(CASE WHEN SETTFLAG IN (2,3) THEN LEFT(SAUDA_DATE,11) ELSE 'DEC 31 2049' END),                                                         
  ORGDATE=LEFT(SAUDA_DATE,11),                                                                      
   0, 1, RECTYPE = (CASE WHEN SETTFLAG IN (2,3) THEN 'SPEC' ELSE 'OPEN' END)                                                                
 FROM  [ANAND].BSEDB_AB.DBO.HISTORY  WITH(NOLOCK)                                    
     
   /*                           
   DROP TABLE BSEDB_AB_HISTORY010411TO180711.DBO.HISTORY_110411_TO_300411                          
   SELECT * INTO BSEDB_AB_HISTORY010411TO180711.DBO.HISTORY_310511_TO_300611                                  
  FROM  [ANAND].BSEDB_AB.DBO.HISTORY                                   
  WHERE SAUDA_DATE BETWEEN '2011-05-31 00:00:00.000' AND '2011-06-30 23:59:59.000'                                
  GO                                
  CREATE CLUSTERED INDEX IX_SAUDA_DATE ON BSEDB_AB_HISTORY010411TO180711.DBO.HISTORY_310511_TO_300611                                   
  (SAUDA_DATE)                                  
  */                                  
                                    
                                                                                    
  WHERE  SAUDA_DATE LIKE @SAUDA_DATE + '%'                                                                          
         AND AUCTIONPART NOT LIKE 'A%'                                                                                 
         AND TRADEQTY > 0                                                                              
   AND TRADE_NO NOT LIKE '%C%'                                                                          
   AND MARKETRATE > 0                                                                           
         AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY                                       
 GROUP BY SETT_NO,                                                                                  
         SETT_TYPE,                                                                                    
         PARTY_CODE,                                                                                    
         SCRIP_CD,                                                                                    
         SERIES,SELL_BUY,SETTFLAG,LEFT(SAUDA_DATE,11)               
      
   */
            
-----------------------------------------------------------------------                                                                              
                            
IF (SELECT ISNULL(COUNT(1),0) FROM TBL_PNL_DATA_TMP_05MAY) > 0                                                     
BEGIN                                                    
SELECT CD_SETT_NO, CD_SETT_TYPE, CD_SAUDA_DATE, CD_PARTY_CODE, CD_SCRIP_CD, CD_SERIES,                                                     
CD_TRDBUYBROKERAGE = SUM(CD_TRDBUYBROKERAGE), CD_TRDSELLBROKERAGE = SUM(CD_TRDSELLBROKERAGE),                                                     
CD_DELBUYBROKERAGE = SUM(CD_DELBUYBROKERAGE), CD_DELSELLBROKERAGE = SUM(CD_DELSELLBROKERAGE),           
CD_TRDBUYSERTAX = SUM(CD_TRDBUYSERTAX), CD_TRDSELLSERTAX = SUM(CD_TRDSELLSERTAX),                                                     
CD_DELBUYSERTAX = SUM(CD_DELBUYSERTAX), CD_DELSELLSERTAX = SUM(CD_DELSELLSERTAX)                                                     
INTO #CHARGES_DETAIL FROM ANAND.BSEDB_AB.DBO.CHARGES_DETAIL  WHERE CD_SAUDA_DATE LIKE @SAUDA_DATE + '%'                                                    
GROUP BY CD_SETT_NO, CD_SETT_TYPE, CD_SAUDA_DATE, CD_PARTY_CODE, CD_SCRIP_CD, CD_SERIES                                 
                                                    
INSERT INTO #CHARGES_DETAIL                                                     
SELECT CD_SETT_NO, CD_SETT_TYPE, CD_SAUDA_DATE, CD_PARTY_CODE, CD_SCRIP_CD, CD_SERIES,                                                     
CD_TRDBUYBROKERAGE = SUM(CD_TRDBUYBROKERAGE), CD_TRDSELLBROKERAGE = SUM(CD_TRDSELLBROKERAGE),                                    
CD_DELBUYBROKERAGE = SUM(CD_DELBUYBROKERAGE), CD_DELSELLBROKERAGE = SUM(CD_DELSELLBROKERAGE),                                                     
CD_TRDBUYSERTAX = SUM(CD_TRDBUYSERTAX), CD_TRDSELLSERTAX = SUM(CD_TRDSELLSERTAX),                  
CD_DELBUYSERTAX = SUM(CD_DELBUYSERTAX), CD_DELSELLSERTAX = SUM(CD_DELSELLSERTAX)                                                     
FROM MSAJAG.DBO.CHARGES_DETAIL                                 
WHERE CD_SAUDA_DATE LIKE @SAUDA_DATE + '%'                                                    
GROUP BY CD_SETT_NO, CD_SETT_TYPE, CD_SAUDA_DATE, CD_PARTY_CODE, CD_SCRIP_CD, CD_SERIES                                                    
                                                    
UPDATE TBL_PNL_DATA_TMP_05MAY SET                         
NBROKAPP = NBROKAPP + (CASE WHEN SELL_BUY = 1 AND BILLFLAG = 2                          
       THEN CD_TRDBUYBROKERAGE                                                    
       WHEN SELL_BUY = 1 AND BILLFLAG = 4                                                    
       THEN CD_DELBUYBROKERAGE                                                    
       WHEN SELL_BUY = 2 AND BILLFLAG = 3                                                    
       THEN CD_TRDSELLBROKERAGE                                                    
       WHEN SELL_BUY = 2 AND BILLFLAG = 5                                                    
       THEN CD_DELSELLBROKERAGE                                             
       ELSE 0                                                    
      END),                                 
NSERTAX = NSERTAX + (CASE WHEN SELL_BUY = 1 AND BILLFLAG = 2                                                    
       THEN CD_TRDBUYSERTAX                                                    
       WHEN SELL_BUY = 1 AND BILLFLAG = 4                                                    
       THEN CD_DELBUYSERTAX                                                    
       WHEN SELL_BUY = 2 AND BILLFLAG = 3                                                    
       THEN CD_TRDSELLSERTAX                                                    
       WHEN SELL_BUY = 2 AND BILLFLAG = 5                                                    
       THEN CD_DELSELLSERTAX                                                    
       ELSE 0                                                    
      END),                                                    
N_NETRATE = N_NETRATE + (CASE WHEN SELL_BUY = 1 AND BILLFLAG = 2                                                    
         THEN CD_TRDBUYBROKERAGE/TRADEQTY                                                    
         WHEN SELL_BUY = 1 AND BILLFLAG = 4                                                    
         THEN CD_DELBUYBROKERAGE/TRADEQTY                                              
         WHEN SELL_BUY = 2 AND BILLFLAG = 3              
         THEN -CD_TRDSELLBROKERAGE/TRADEQTY                                                    
         WHEN SELL_BUY = 2 AND BILLFLAG = 5                                                    
         THEN -CD_DELSELLBROKERAGE/TRADEQTY                                                  
         ELSE 0                                                    
        END),                                                    
 PNLRATE = PNLRATE + (CASE WHEN SELL_BUY = 1 AND BILLFLAG = 2                                                    
         THEN (CD_TRDBUYBROKERAGE+CD_TRDBUYSERTAX)/TRADEQTY                                                    
         WHEN SELL_BUY = 1 AND BILLFLAG = 4                                               
         THEN (CD_DELBUYBROKERAGE+CD_DELBUYSERTAX)/TRADEQTY                         
         WHEN SELL_BUY = 2 AND BILLFLAG = 3                                                
         THEN -(CD_TRDSELLBROKERAGE+CD_TRDSELLSERTAX)/TRADEQTY                                                    
         WHEN SELL_BUY = 2 AND BILLFLAG = 5                                                    
         THEN -(CD_DELSELLBROKERAGE+CD_DELSELLSERTAX)/TRADEQTY                                                    
         ELSE 0                                                    
        END)                                                    
FROM #CHARGES_DETAIL                   
WHERE CD_SETT_NO = SETT_NO                      
AND CD_SETT_TYPE = SETT_TYPE                                                    
AND CD_SCRIP_CD = (CASE WHEN EXCHANGE = 'NSE' THEN SCRIP_CD ELSE BSECODE END)                                                    
AND CD_SERIES = SERIES                                                    
AND CD_PARTY_CODE = PARTY_CODE                                                    
AND LEFT(CD_SAUDA_DATE,11) = LEFT(SAUDA_DATE,11)                                            
                                                                       
  UPDATE TBL_PNL_DATA_TMP_05MAY                                                                                    
  SET    ISIN = M.ISIN                                                                 
  FROM   ANGELDEMAT.MSAJAG.DBO.MULTIISIN M                                                                                     
  WHERE  M.SCRIP_CD = TBL_PNL_DATA_TMP_05MAY.SCRIP_CD                                                                                    
  AND M.SERIES IN ('EQ', 'BE')                                                          
  AND TBL_PNL_DATA_TMP_05MAY.SERIES IN ('EQ', 'BE')                                                          
  AND VALID = 1                                                                          
  AND LEFT(EXCHANGE,1) = 'N'                                                                              
  AND TBL_PNL_DATA_TMP_05MAY.ISIN = ''                                                   
                                                          
  UPDATE TBL_PNL_DATA_TMP_05MAY                                                                                    
  SET    ISIN = M.ISIN                                                     
  FROM   ANGELDEMAT.MSAJAG.DBO.MULTIISIN M                                                                                     
  WHERE  M.SCRIP_CD = TBL_PNL_DATA_TMP_05MAY.SCRIP_CD                                                                                    
  AND M.SERIES = TBL_PNL_DATA_TMP_05MAY.SERIES                                                                          
  AND TBL_PNL_DATA_TMP_05MAY.SERIES NOT IN ('EQ', 'BE')                                                          
  AND VALID = 1                                                                          
  AND LEFT(EXCHANGE,1) = 'N'                                                                            
  AND TBL_PNL_DATA_TMP_05MAY.ISIN = ''                                                          
                       
  UPDATE TBL_PNL_DATA_TMP_05MAY                                                                                    
  SET    ISIN = M.ISIN                                                                                 
  FROM   MSAJAG.DBO.CMBILLVALAN M          
  WHERE  M.SETT_NO = TBL_PNL_DATA_TMP_05MAY.SETT_NO                                                                  
AND M.SETT_TYPE = TBL_PNL_DATA_TMP_05MAY.SETT_TYPE                                                
  AND M.SCRIP_CD = TBL_PNL_DATA_TMP_05MAY.SCRIP_CD                                                                                    
  AND M.SERIES = TBL_PNL_DATA_TMP_05MAY.SERIES                             
  AND LEFT(TBL_PNL_DATA_TMP_05MAY.EXCHANGE,1) = 'N'                                                                              
  AND TBL_PNL_DATA_TMP_05MAY.ISIN = ''                                                                  
  AND M.ISIN <> ''                    
                                       
  UPDATE TBL_PNL_DATA_TMP_05MAY                                                                                    
  SET    ISIN = M.ISIN                                                                                 
  FROM   #BSEMULTIISIN M                                                                                     
  WHERE  M.SCRIP_CD = TBL_PNL_DATA_TMP_05MAY.BSECODE                                                                                    
  AND M.SERIES = TBL_PNL_DATA_TMP_05MAY.SERIES                                                                          
  AND VALID = 1                                                                          
  AND LEFT(EXCHANGE,1) = 'B'                             
  AND TBL_PNL_DATA_TMP_05MAY.ISIN = ''                                      
                                                                  
  UPDATE TBL_PNL_DATA_TMP_05MAY                                                                                    
  SET    ISIN = M.ISIN                                                           
  FROM   #BSECMBILLVALAN M                                                                                     
  WHERE  M.SETT_NO = TBL_PNL_DATA_TMP_05MAY.SETT_NO                                                                  
  AND M.SETT_TYPE = TBL_PNL_DATA_TMP_05MAY.SETT_TYPE                                                                  
  AND M.SCRIP_CD = TBL_PNL_DATA_TMP_05MAY.BSECODE                                               
  AND M.SERIES = TBL_PNL_DATA_TMP_05MAY.SERIES                                                                          
  AND LEFT(TBL_PNL_DATA_TMP_05MAY.EXCHANGE,1) = 'B'                                               
  AND TBL_PNL_DATA_TMP_05MAY.ISIN = ''                                                                  
  AND M.ISIN <> ''                                                   
                                                                
  UPDATE TBL_PNL_DATA_TMP_05MAY                                                                                    
  SET    BSECODE = M.SCRIP_CD                                                                          
  FROM   #BSEMULTIISIN M                                      
  WHERE  M.ISIN = TBL_PNL_DATA_TMP_05MAY.ISIN                                                                                    
  AND M.VALID = 1                                                                 
              
  UPDATE TBL_PNL_DATA_TMP_05MAY                                                                                    
  SET    SCRIP_CD = M.SCRIP_CD,                                                      
  SERIES = M.SERIES                                                                          
  FROM   ANGELDEMAT.MSAJAG.DBO.MULTIISIN M                                               
  WHERE  M.ISIN = TBL_PNL_DATA_TMP_05MAY.ISIN                                                                       
  AND M.VALID = 1                                                                
                                                                             
/*        
  UPDATE TBL_PNL_DATA_TMP_05MAY                                                                                    
  SET    BILLFLAG = 2,                                                                      
   OPPDATE = @SAUDA_DATE,                                                                        
   UPDFLAG = 1                                                                                    
  FROM   #PNL_REARRANGE S (NOLOCK)                                                                                    
  WHERE  S.PARTY_CODE = TBL_PNL_DATA_TMP_05MAY.PARTY_CODE                                                                                    
         AND S.ISIN = TBL_PNL_DATA_TMP_05MAY.ISIN                                                     
   AND S.SCRIP_CD = TBL_PNL_DATA_TMP_05MAY.SCRIP_CD                                         
   AND S.SERIES = TBL_PNL_DATA_TMP_05MAY.SERIES                                                                          
   AND S.BSECODE = TBL_PNL_DATA_TMP_05MAY.BSECODE                                          
         AND PQTY <= SQTY                                                                                    
         AND PQTY > 0                                                                                    
         AND TBL_PNL_DATA_TMP_05MAY.SELL_BUY = 1                                                                     
                                                                          
  UPDATE TBL_PNL_DATA_TMP_05MAY                                                                                    
  SET    BILLFLAG = 3,                                                                      
   OPPDATE = @SAUDA_DATE,                                          
   UPDFLAG = 1                                                                                    
FROM   #PNL_REARRANGE S (NOLOCK)                                                            
  WHERE  S.PARTY_CODE = TBL_PNL_DATA_TMP_05MAY.PARTY_CODE                                                                                    
         AND S.ISIN = TBL_PNL_DATA_TMP_05MAY.ISIN                                   
   AND S.SCRIP_CD = TBL_PNL_DATA_TMP_05MAY.SCRIP_CD                                                                          
   AND S.SERIES = TBL_PNL_DATA_TMP_05MAY.SERIES                                                                          
   AND S.BSECODE = TBL_PNL_DATA_TMP_05MAY.BSECODE                                                                              
         AND SQTY <= PQTY                                                    
         AND SQTY > 0                                                                                    
         AND TBL_PNL_DATA_TMP_05MAY.SELL_BUY = 2                                                                                    
*/                                                                          
/*==============================================================================*/                                                                                    
/*CURSOR TO COMPLETE FINAL MARKING FOR PART SQUARED-OFF POSITIONS*/                                                                     
/*==============================================================================*/                                                                                    
  SET @SETTCUR = CURSOR FOR SELECT   SNO, PARTY_CODE, ISIN, TRADEQTY, ORGDATE1=LEFT(ORGDATE,11), ORGDATE                                                          
                            FROM     TBL_PNL_DATA_TMP_05MAY P (NOLOCK)                                              
                            WHERE    SELL_BUY = 1 AND OPPDATE LIKE 'DEC 31 2049%'                                                                    
       AND PARTY_CODE IN (SELECT PARTY_CODE FROM TBL_PNL_DATA_TMP_05MAY P1                                                              
              WHERE P.PARTY_CODE = P1.PARTY_CODE                                                                    
              AND P.ISIN = P1.ISIN                                                                    
              AND P1.SELL_BUY = 2 AND OPPDATE LIKE 'DEC 31 2049%')                                                                    
                          ORDER BY PARTY_CODE, ISIN, ORGDATE                                                                                    
          
  OPEN @SETTCUR                                                                                    
                                                                                      
  FETCH NEXT FROM @SETTCUR                                                                                    
  INTO @BUYSNO, @PARTY_CODE,                                             
       @ISIN,                                                                       
       @PQTY,                                                                                    
       @BUYSAUDA_DATE,                             
    @TEMPORGDATE                                                                          
                                                                
  WHILE @@FETCH_STATUS = 0                                                                                    
    BEGIN                                                  
  SET @SETTREC = CURSOR FOR                                                                      
                                                  
   SELECT   SNO, TRADEQTY, ORGDATE=LEFT(ORGDATE,11)                                                                                    
   FROM     TBL_PNL_DATA_TMP_05MAY (NOLOCK)                                                                                    
   WHERE    PARTY_CODE = @PARTY_CODE                                                                                    
   AND ISIN = @ISIN                                                                                   
   AND SELL_BUY = 2                                                                                    
   AND OPPDATE LIKE 'DEC 31 2049%'                                                                    
   ORDER BY EXCHANGE DESC, ORGDATE                                                                    
          OPEN @SETTREC                                                                    
  FETCH NEXT FROM @SETTREC                                                           
  INTO @SELLSNO,                                                                                 
       @SQTY,                      
       @SELLSAUDA_DATE                                                                    
WHILE @@FETCH_STATUS = 0 AND @PQTY > 0                                                                    
BEGIN                                                                     
 IF @PQTY >= @SQTY                                                          
 BEGIN                                                                                   
                                                                    
  SELECT @PDIFF = @PQTY - @SQTY                                                       
                                                                    
  UPDATE TBL_PNL_DATA_TMP_05MAY                                                        
  SET    BILLFLAG = 3, UPDFLAG = 1, OPPDATE = @BUYSAUDA_DATE                                 
  WHERE  SNO = @SELLSNO                                                                                    
                                                                                                      
  IF @PQTY = @SQTY                                                                     
  BEGIN                   
   UPDATE TBL_PNL_DATA_TMP_05MAY                                                           
   SET    BILLFLAG = 2, UPDFLAG = 1, OPPDATE = @SELLSAUDA_DATE                                                                                 
   WHERE SNO = @BUYSNO      
                                                                       
 SET @PQTY = 0                                                                                    
     END                                                                                     
  ELSE                                                                    
  BEGIN                          
   INSERT INTO TBL_PNL_DATA_TMP_05MAY                                                                                    
   SELECT EXCHANGE,                                                                                    
     MARGINDATE,                                                                            
     TRADETYPE,                                                                                    
     SETT_NO,                                                        
     SETT_TYPE,                                                                                    
     PARTY_CODE,                                                                                    
     SCRIP_CD,                                                                                    
     SERIES,           
  BSECODE,                                                                  
     ISIN,                                                                                   
 USER_ID,                                        
     CONTRACTNO,                                                                                    
     ORDER_NO,                                                                                    
     TRADE_NO,                                                                                    
     SAUDA_DATE,                                                                                    
     TRADEQTY = @SQTY,                                                                                    
     MARKETRATE,                                                                          
     PNLRATE,                                                    
     MARKETTYPE,                                                          
     SELL_BUY,                                                                                    
     INS_CHRG,                                            
     TURN_TAX,                                                                                    
     OTHER_CHRG,                                                                                    
     SEBI_TAX,                                                                                    
     BROKER_CHRG,                                                             
     BILLFLAG=2,                                                                                    
     NBROKAPP,                                                                                    
     NSERTAX,                                                                                    
     N_NETRATE, OPPDATE=@SELLSAUDA_DATE, ORGDATE, 0, UPDFLAG = 1, RECTYPE = 'OPEN'                                                                                   
   FROM   TBL_PNL_DATA_TMP_05MAY (NOLOCK)                                                                                    
   WHERE  SNO = @BUYSNO                              
                                                                    
   UPDATE TBL_PNL_DATA_TMP_05MAY                                        
   SET TRADEQTY = @PDIFF, UPDFLAG = 1                                                             
   WHERE  SNO = @BUYSNO                                           
                                           SELECT @PQTY = @PDIFF                                                                    
        END                     
 END                                            
ELSE                                                                    
 BEGIN                                                                    
  SELECT @PDIFF = @SQTY - @PQTY                                                                    
                                                    
  UPDATE TBL_PNL_DATA_TMP_05MAY                                                                                    
  SET    BILLFLAG = 2, UPDFLAG = 1, OPPDATE = @SELLSAUDA_DATE                                                                                 
  WHERE  SNO = @BUYSNO             
                                                                    
  INSERT INTO TBL_PNL_DATA_TMP_05MAY                                                                                    
  SELECT EXCHANGE,                                                                                    
    MARGINDATE,                                                                            
    TRADETYPE,                                                                                    
    SETT_NO,                                                                                    
    SETT_TYPE,                                                                                    
    PARTY_CODE,                                                   
    SCRIP_CD,                                                                                    
    SERIES,                                                            
    BSECODE,                                                                           
    ISIN,                        
    USER_ID,                                                                                    
    CONTRACTNO,                                                                                    
    ORDER_NO,                                                                                    
    TRADE_NO,                                                                                    
    SAUDA_DATE,                                                                                 
    TRADEQTY = @PQTY,                                                                                    
    MARKETRATE,                          
    PNLRATE,                                                          
    MARKETTYPE,                                                                                    
    SELL_BUY,                                                                                    
    INS_CHRG,                          
    TURN_TAX,                                                                                    
    OTHER_CHRG,                                                      
    SEBI_TAX,                                                                                    
    BROKER_CHRG,                                                                                    
    BILLFLAG=3,                                         
    NBROKAPP,                                                                                    
    NSERTAX,                                                                                    
    N_NETRATE, OPPDATE=@BUYSAUDA_DATE, ORGDATE, 0, UPDFLAG = 1, RECTYPE = 'OPEN'                                                                                 
  FROM   TBL_PNL_DATA_TMP_05MAY (NOLOCK)                                                                                    
  WHERE  SNO = @SELLSNO                                                          
                                                                    
  SET @PQTY = 0                                                                    
                                                                    
  UPDATE TBL_PNL_DATA_TMP_05MAY                                                                                    
  SET TRADEQTY = @PDIFF, UPDFLAG = 1      
  WHERE  SNO = @SELLSNO                                                                          
 END                                                                    
   FETCH NEXT FROM @SETTREC                                                                                    
  INTO @SELLSNO,                                                                                 
       @SQTY,                                              
       @SELLSAUDA_DATE                                                                    
END                                        
                                                                    
  FETCH NEXT FROM @SETTCUR                                                
INTO @BUYSNO, @PARTY_CODE,                                                               
       @ISIN,                                                                                    
       @PQTY,                                                                                    
       @BUYSAUDA_DATE,                                                          
  @TEMPORGDATE                                                                     
END                                                                    
                                                    
/*                                                                    
SET @SETTCUR = CURSOR FOR SELECT   SNO, PARTY_CODE, SCRIP_CD, SERIES, BSECODE, ISIN, TRADEQTY, ORGDATE1=LEFT(ORGDATE,11), ORGDATE                                                                                    
                            FROM     TBL_PNL_DATA_TMP_05MAY P (NOLOCK)                                                         
                            WHERE    SELL_BUY = 2 AND OPPDATE LIKE 'DEC 31 2049%'                                                                    
       AND PARTY_CODE IN (SELECT PARTY_CODE FROM TBL_PNL_DATA_TMP_05MAY P1                                                                    
              WHERE P.PARTY_CODE = P1.PARTY_CODE                                                                    
              AND P.SCRIP_CD = P1.SCRIP_CD                                
              AND P.SERIES = P1.SERIES                                                                    
              AND P.BSECODE = P1.BSECODE                                                                    
              AND P.ISIN = P1.ISIN                                                                    
              AND P1.SELL_BUY = 1 AND OPPDATE LIKE 'DEC 31 2049%')                                                                    
                            ORDER BY PARTY_CODE, SCRIP_CD, SERIES, BSECODE, ORGDATE                                                                                    
                                                         
  OPEN @SETTCUR                                                        
                                                                                      
  FETCH NEXT FROM @SETTCUR                                                                        
  INTO @SELLSNO, @PARTY_CODE,@SCRIP_CD,                                                                          
     @SERIES,                                                                          
     @BSECODE,                     
       @ISIN,                                                                                    
       @SQTY,                                                                                    
       @SELLSAUDA_DATE, @TEMPORGDATE                                            
                                                                          
  WHILE @@FETCH_STATUS = 0                                                                                    
    BEGIN                         
  SET @SETTREC = CURSOR FOR                                                                      
                                                                    
   SELECT SNO, TRADEQTY, ORGDATE=LEFT(ORGDATE,11)                                                                                    
   FROM     TBL_PNL_DATA_TMP_05MAY (NOLOCK)                                                            
   WHERE    PARTY_CODE = @PARTY_CODE                                                      
   AND SCRIP_CD = @SCRIP_CD                                                                          
   AND SERIES = @SERIES                                                                          
   AND BSECODE = @BSECODE                                     
   AND ISIN = @ISIN                                                                                   
   AND SELL_BUY = 1                                                                                    
   AND OPPDATE LIKE 'DEC 31 2049%'                                                                    
   ORDER BY EXCHANGE DESC, ORGDATE                                                                    
          OPEN @SETTREC                                                 
  FETCH NEXT FROM @SETTREC                                                                           
  INTO @BUYSNO,                                                                                 
       @PQTY,                                                                                    
       @BUYSAUDA_DATE                                                                    
WHILE @@FETCH_STATUS = 0 AND @SQTY > 0                                                 
BEGIN                                                                     
 IF @SQTY >= @PQTY                                                                                    
 BEGIN                                   
                                                                    
  SELECT @PDIFF = @SQTY - @PQTY                                                                    
                                                                    
  UPDATE TBL_PNL_DATA_TMP_05MAY                                                            
  SET    BILLFLAG = 2, UPDFLAG = 1, OPPDATE = @SELLSAUDA_DATE                                                                                 
  WHERE  SNO = @BUYSNO                                                                                    
                                                  
  IF @PQTY = @SQTY                                                                     
  BEGIN                                                                    
   UPDATE TBL_PNL_DATA_TMP_05MAY                                                                                    
   SET    BILLFLAG = 3, UPDFLAG = 1, OPPDATE = @BUYSAUDA_DATE                                                                                 
   WHERE  SNO = @SELLSNO                                                                     
                                                                       
   SET @SQTY = 0                                                                                    
     END                                                                                    
  ELSE                                              
  BEGIN                      
   INSERT INTO TBL_PNL_DATA_TMP_05MAY                    
   SELECT EXCHANGE,                                                              
     MARGINDATE,                                                                            
     TRADETYPE,                                                                                    
     SETT_NO,                                          
SETT_TYPE,                                                                                    
     PARTY_CODE,                                                                                    
     SCRIP_CD,                                   
     SERIES,                                                                                    
     BSECODE,               
     ISIN,                                                                                   
     USER_ID,                                                                                    
     CONTRACTNO,                    
     ORDER_NO,      
     TRADE_NO,                                                                                    
     SAUDA_DATE,                                                                                    
     TRADEQTY = @PQTY,                                                    
     MARKETRATE,                                                                          
     PNLRATE,                                                                                    
     MARKETTYPE,                                                                   
     SELL_BUY,                                                                                    
   INS_CHRG,                                                                                    
     TURN_TAX,                                                                                    
     OTHER_CHRG,                                                                                    
     SEBI_TAX,                                                                    
     BROKER_CHRG,                         
     BILLFLAG=3,                                                     
     NBROKAPP,                                                                                    
     NSERTAX,                                                                                   
     N_NETRATE, OPPDATE=@BUYSAUDA_DATE, ORGDATE, 0, UPDFLAG = 1, RECTYPE = 'OPEN'                                           
   FROM   TBL_PNL_DATA_TMP_05MAY (NOLOCK)             
   WHERE  SNO = @SELLSNO                                                                                    
                                                                    
   UPDATE TBL_PNL_DATA_TMP_05MAY                                                                                    
   SET TRADEQTY = @PDIFF, UPDFLAG = 1                                                                                    
   WHERE  SNO = @SELLSNO                                                    
                                                 
   SELECT @SQTY = @PDIFF                                                                    
        END                                                                                    
 END                                                                    
 ELSE                                                                    
 BEGIN                                                                    
                                                                    
  SELECT @PDIFF = @PQTY - @SQTY                              
                                                                    
  UPDATE TBL_PNL_DATA_TMP_05MAY                                                                                    
  SET    BILLFLAG = 3, UPDFLAG = 1, OPPDATE = @BUYSAUDA_DATE                                                                                 
  WHERE SNO = @SELLSNO                                                                     
            
  INSERT INTO TBL_PNL_DATA_TMP_05MAY                                                                                    
 SELECT EXCHANGE,                                                             
    MARGINDATE,                                                              
    TRADETYPE,                                                                                    
    SETT_NO,                                                                                    
    SETT_TYPE,        PARTY_CODE,                                                                                    
    SCRIP_CD,                                                                                    
    SERIES,                                      
    BSECODE,                                        
    ISIN,                                                                               
    USER_ID,                                                                                    
    CONTRACTNO,                                               
    ORDER_NO,                                                                                    
    TRADE_NO,                                                         
    SAUDA_DATE,                          
    TRADEQTY = @SQTY,                                                                             
    MARKETRATE,                                                                          
    PNLRATE,                                                                                           
    MARKETTYPE,                                                                                    
    SELL_BUY,                                                                                    
    INS_CHRG,                                                                                    
    TURN_TAX,                                                                                    
    OTHER_CHRG,                                                                                    
    SEBI_TAX,                                                                      
    BROKER_CHRG,                                                                                    
    BILLFLAG=2,                                                                                    
    NBROKAPP,                                                                                    
    NSERTAX,                                                           
    N_NETRATE, OPPDATE=@SELLSAUDA_DATE, ORGDATE, 0, UPDFLAG = 1, RECTYPE = 'OPEN'                                                          
  FROM   TBL_PNL_DATA_TMP_05MAY (NOLOCK)                                                                                    
  WHERE  SNO = @BUYSNO                                                                                    
                                                                      
  SET @SQTY = 0                                                                    
                                                                    
  UPDATE TBL_PNL_DATA_TMP_05MAY                                                                                    
  SET TRADEQTY = @PDIFF, UPDFLAG = 1                                                                      
  WHERE  SNO = @BUYSNO                                                                            
 END                                                                    
   FETCH NEXT FROM @SETTREC                                                                                    
  INTO @BUYSNO,                                                                                 
       @PQTY,                                                                                    
       @BUYSAUDA_DATE                                                                    
END        
  FETCH NEXT FROM @SETTCUR                                                                                    
  INTO @SELLSNO, @PARTY_CODE,@SCRIP_CD,                                                                      
     @SERIES,                             
     @BSECODE,                                                      
       @ISIN,                                               
       @SQTY,                                                                                    
       @SELLSAUDA_DATE, @TEMPORGDATE                                                                     
END                                                          
*/                                             
                                                                    
DELETE FROM TBL_PNL_DATA_05MAY                                
WHERE SNO IN (SELECT ORGSNO FROM TBL_PNL_DATA_TMP_05MAY WHERE UPDFLAG = 1 AND ORGSNO <> 0)                                                                        
                                                
INSERT INTO TBL_PNL_DATA_05MAY                                                                          
SELECT EXCHANGE,MARGINDATE,TRADETYPE,SETT_NO,SETT_TYPE,PARTY_CODE,SCRIP_CD,SERIES,BSECODE,                                                           
ISIN,USER_ID,CONTRACTNO,ORDER_NO,TRADE_NO,SAUDA_DATE,TRADEQTY,MARKETRATE,PNLRATE,MARKETTYPE,                                                                          
SELL_BUY,INS_CHRG,TURN_TAX,OTHER_CHRG,SEBI_TAX,BROKER_CHRG,BILLFLAG,NBROKAPP,NSERTAX,N_NETRATE,OPPDATE,ORGDATE,                      
RECTYPE = (CASE WHEN RECTYPE = 'OPEN' AND ABS(DATEDIFF(D,OPPDATE,SAUDA_DATE)) > 365 AND OPPDATE <> 'DEC 31 2049'                                                         
    THEN 'LONG TERM'                                                         
    WHEN RECTYPE = 'OPEN' AND ABS(DATEDIFF(D,OPPDATE,SAUDA_DATE)) < 365 AND RECTYPE <> 'SPEC'                                                    
    THEN 'SHORT TERM'                                                         
    WHEN RECTYPE = 'SPEC'                                                         
    THEN 'SPECULATION'                                                        
    ELSE 'OPEN'                                                        
     END)                                                        
FROM TBL_PNL_DATA_TMP_05MAY                                                                          
WHERE UPDFLAG = 1                                                                     
END

GO
