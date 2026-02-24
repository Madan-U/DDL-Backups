-- Object: PROCEDURE dbo.PROC_PNLPROCESS_Daily_RCS
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------




CREATE PROC [dbo].[PROC_PNLPROCESS_Daily_RCS]                                          
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
       @SETTREC    CURSOR,
	   @Exchange	varchar(3)                                                                      
                                                                      
SELECT @PREVDATE = ISNULL(LEFT(MAX(MARGINDATE),11),'APR  1 2004')                                                                                
FROM  TBL_PNL_DATA_NEW_RCS      WITH(NOLOCK)                                                                
WHERE MARGINDATE < CONVERT(DATETIME,@SAUDA_DATE)                                                                      
                                          
SELECT * INTO #BSEMULTIISIN                                          
FROM ANGELDEMAT.BSEDB.DBO.MULTIISIN M     WITH(NOLOCK)                                                                  
WHERE VALID = 1                                           
                                          
SELECT DISTINCT SETT_NO,SETT_TYPE,SCRIP_CD,SERIES,ISIN INTO #BSECMBILLVALAN                                          
FROM AngelBSECM.BSEDB_AB.DBO.CMBILLVALAN WITH(NOLOCK)                                          
WHERE SAUDA_DATE BETWEEN @SAUDA_DATE AND @SAUDA_DATE + ' 23:59'                                                            
AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY           
                                      
/*                                                                      
DELETE FROM TBL_PNL_DATA                                                                      
WHERE MARGINDATE = @SAUDA_DATE                                                                      
AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY                                                  
*/            

SELECT DISTINCT PARTY_CODE INTO #PARTY FROM DUSTBIN.DBO.SETTLEMENT_NSE_18102022 WITH(NOLOCK)  WHERE    SAUDA_DATE LIKE @SAUDA_DATE + '%'                                                   
AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY      AND SELL_BUY = 2                              

INSERT INTO  #PARTY
SELECT DISTINCT PARTY_CODE FROM DUSTBIN.DBO.SETTLEMENT_BSE_18102022 WITH(NOLOCK)   WHERE    SAUDA_DATE LIKE @SAUDA_DATE + '%'                                                   
AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY       AND SELL_BUY = 2     

Create index #party on #PARTY (PARTY_CODE)
                                               
---
                                                    
DELETE T FROM TBL_PNL_DATA_NEW_RCS T WITH(NOLOCK)                                                         
WHERE SAUDA_DATE >= @SAUDA_DATE                                                                   
AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY                                                                      
                                            
UPDATE T SET BILLFLAG = (CASE WHEN SELL_BUY = 1 THEN 4 ELSE 5 END),                                                                      
MARGINDATE = LEFT(SAUDA_DATE, 11),OPPDATE='DEC 31 2049'  
FROM TBL_PNL_DATA_NEW_RCS T   WITH(NOLOCK)                                                                           
WHERE MARGINDATE >= @SAUDA_DATE                                                                      
AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY AND EXISTS (SELECT PARTY_CODE FROM #PARTY P Where T.Party_code =P.Party_CODE)
AND SETT_TYPE NOT IN ('A','X','AC','AD')  -- Added on 26/10/2015 by Dharmesh M.
                                                                    
                         
                         
  -- Added on 20/10/2015 by Dharmesh M.

UPDATE T  SET OPPDATE = ORGDATE + 366 
FROM TBL_PNL_DATA_NEW_RCS T (NOLOCK) WHERE SETT_TYPE IN ('A','X','AC','AD') AND RECTYPE = 'OPEN'
AND OPPDATE LIKE 'DEC 31 2049%' 
AND SELL_BUY='1'
AND EXISTS (SELECT PARTY_CODE FROM #PARTY P Where T.Party_code = P.Party_CODE)
                         
TRUNCATE TABLE TBL_PNL_DATA_TMP        
    
---- NSECM ----                                         
                                                                      
INSERT INTO TBL_PNL_DATA_TMP                                                   
SELECT EXCHANGE,MARGINDATE=@SAUDA_DATE,TRADETYPE='BF',SETT_NO,SETT_TYPE,PARTY_CODE,SCRIP_CD,SERIES,                                                                
BSECODE,ISIN,USER_ID,CONTRACTNO,ORDER_NO,TRADE_NO,SAUDA_DATE,TRADEQTY,MARKETRATE,                                                                   
PNLRATE,MARKETTYPE,SELL_BUY,INS_CHRG,TURN_TAX,OTHER_CHRG,SEBI_TAX,BROKER_CHRG,                                                          
BILLFLAG,NBROKAPP,NSERTAX,N_NETRATE,OPPDATE='DEC 31 2049', ORGDATE, SNO, 0, RECTYPE = 'OPEN'                                                                
FROM TBL_PNL_DATA_NEW_RCS  T  WITH(NOLOCK)                                                                            
WHERE /*MARGINDATE = @PREVDATE                                                         
AND*/PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY                                                                      
AND BILLFLAG = 4 AND EXISTS (SELECT PARTY_CODE FROM #PARTY P WHERE T.PARTY_CODE =P.PARTY_CODE)
 
                                              
                                                              
INSERT INTO TBL_PNL_DATA_TMP                                                                      
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
         BILLFLAG=SELL_BUY + 3,                                                                                
         NBROKAPP=SUM(TRADEQTY*NBROKAPP),                                            
         NSERTAX=SUM(NSERTAX),                                                                                
         N_NETRATE=SUM(N_NETRATE*TRADEQTY)/SUM(TRADEQTY),                                                                  
  OPPDATE='DEC 31 2049',                                                      
  ORGDATE=LEFT(SAUDA_DATE,11),                                                                  
   0, 1, RECTYPE = 'OPEN'                                                           
  FROM   DUSTBIN.DBO.settlement_nse_18102022 WITH(NOLOCK)                                                                                
  WHERE  SAUDA_DATE LIKE @SAUDA_DATE + '%'                                                   
         AND AUCTIONPART NOT LIKE 'A%'  
         --AND AUCTIONPART NOT LIKE 'F%'                                                                             
         AND TRADEQTY > 0                                                                                
   AND TRADE_NO NOT LIKE '%C%'                                                                      
   AND MARKETRATE > 0                                                                       
         AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY                                                                      
GROUP BY SETT_NO,                                                                                
         SETT_TYPE,                                                                                
         PARTY_CODE,                                                                                
         SCRIP_CD,                                                                          
         SERIES,SELL_BUY,LEFT(SAUDA_DATE,11)                                                
 /*                                                               
INSERT INTO TBL_PNL_DATA_TMP                                                                      
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
                                              
--INSERT INTO TBL_PNL_DATA_TMP                     
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
--  FROM   AngelBSECM.BSEDB_AB.DBO.SETTLEMENT WITH(NOLOCK)                                                           
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
                                                                    
INSERT INTO TBL_PNL_DATA_TMP                                                                
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
         BILLFLAG=SELL_BUY + 3,                                                                                
         NBROKAPP=SUM(TRADEQTY*NBROKAPP),                                                                       
         NSERTAX=SUM(NSERTAX),                                                                        
      N_NETRATE=SUM(N_NETRATE*TRADEQTY)/SUM(TRADEQTY),                                                                  
  OPPDATE='DEC 31 2049',                                                      
  ORGDATE=LEFT(SAUDA_DATE,11),                                                                  
   0, 1, RECTYPE = 'OPEN'                                                           
  FROM  DUSTBIN.DBO.settlement_bse_18102022  WITH(NOLOCK)                                
                                    
   /*                       
   DROP TABLE BSEDB_AB_HISTORY010411TO180711.DBO.HISTORY_110411_TO_300411                      
   SELECT * INTO BSEDB_AB_HISTORY010411TO180711.DBO.HISTORY_310511_TO_300611                              
  FROM  [AngelBSECM].BSEDB_AB.DBO.HISTORY                               
  WHERE SAUDA_DATE BETWEEN '2011-05-31 00:00:00.000' AND '2011-06-30 23:59:59.000'                            
  GO                            
  CREATE CLUSTERED INDEX IX_SAUDA_DATE ON BSEDB_AB_HISTORY010411TO180711.DBO.HISTORY_310511_TO_300611    
  (SAUDA_DATE)                              
  */                              
                                
                                                                                
  WHERE  SAUDA_DATE LIKE @SAUDA_DATE + '%'                                                                      
         AND AUCTIONPART NOT LIKE 'A%'  
         --AND AUCTIONPART NOT LIKE 'F%' 
         AND TRADEQTY > 0                                                                          
   AND TRADE_NO NOT LIKE '%C%'                                                                      
   AND MARKETRATE > 0                                                                       
         AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY                                   
GROUP BY SETT_NO,                                                                              
         SETT_TYPE,                                                                                
         PARTY_CODE,                                                                          
         SCRIP_CD,                                                                                
         SERIES,SELL_BUY,LEFT(SAUDA_DATE,11)         
                 
                 
--------------------------MODIFIED BY JAY KHARE 15 DEC 2011----------------------------------------------    
/*    
INSERT INTO TBL_PNL_DATA_TMP                                                                
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
 FROM  [AngelBSECM].BSEDB_AB.DBO.HISTORY  WITH(NOLOCK)                                
 
   /*                       
   DROP TABLE BSEDB_AB_HISTORY010411TO180711.DBO.HISTORY_110411_TO_300411                      
   SELECT * INTO BSEDB_AB_HISTORY010411TO180711.DBO.HISTORY_310511_TO_300611                              
  FROM  [AngelBSECM].BSEDB_AB.DBO.HISTORY                               
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
                        
IF (SELECT ISNULL(COUNT(1),0) FROM TBL_PNL_DATA_TMP) > 0                                                 
BEGIN                                                
SELECT CD_SETT_NO, CD_SETT_TYPE, CD_SAUDA_DATE, CD_PARTY_CODE, CD_SCRIP_CD, CD_SERIES,                                                 
CD_TRDBUYBROKERAGE = SUM(CD_TRDBUYBROKERAGE), CD_TRDSELLBROKERAGE = SUM(CD_TRDSELLBROKERAGE),                                                 
CD_DELBUYBROKERAGE = SUM(CD_DELBUYBROKERAGE), CD_DELSELLBROKERAGE = SUM(CD_DELSELLBROKERAGE),       
CD_TRDBUYSERTAX = SUM(CD_TRDBUYSERTAX), CD_TRDSELLSERTAX = SUM(CD_TRDSELLSERTAX),                                                 
CD_DELBUYSERTAX = SUM(CD_DELBUYSERTAX), CD_DELSELLSERTAX = SUM(CD_DELSELLSERTAX)                                                 
INTO #CHARGES_DETAIL FROM AngelBSECM.BSEDB_AB.DBO.CHARGES_DETAIL WITH(NOLOCK)           WHERE CD_SAUDA_DATE >= @SAUDA_DATE AND CD_SAUDA_DaTE <=@SAUDA_DATE +' 23:59:59'
AND  CD_PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY                                             
GROUP BY CD_SETT_NO, CD_SETT_TYPE, CD_SAUDA_DATE, CD_PARTY_CODE, CD_SCRIP_CD, CD_SERIES                                                
                                                
INSERT INTO #CHARGES_DETAIL                                                 
SELECT CD_SETT_NO, CD_SETT_TYPE, CD_SAUDA_DATE, CD_PARTY_CODE, CD_SCRIP_CD, CD_SERIES,                                                 
CD_TRDBUYBROKERAGE = SUM(CD_TRDBUYBROKERAGE), CD_TRDSELLBROKERAGE = SUM(CD_TRDSELLBROKERAGE),                                
CD_DELBUYBROKERAGE = SUM(CD_DELBUYBROKERAGE), CD_DELSELLBROKERAGE = SUM(CD_DELSELLBROKERAGE),                                                 
CD_TRDBUYSERTAX = SUM(CD_TRDBUYSERTAX), CD_TRDSELLSERTAX = SUM(CD_TRDSELLSERTAX),              
CD_DELBUYSERTAX = SUM(CD_DELBUYSERTAX), CD_DELSELLSERTAX = SUM(CD_DELSELLSERTAX)                                                 
FROM MSAJAG.DBO.CHARGES_DETAIL   WITH(NOLOCK)                                    
WHERE CD_SAUDA_DATE >= @SAUDA_DATE AND CD_SAUDA_DaTE <=@SAUDA_DATE +' 23:59:59'                        
AND  CD_PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY                                            
GROUP BY CD_SETT_NO, CD_SETT_TYPE, CD_SAUDA_DATE, CD_PARTY_CODE, CD_SCRIP_CD, CD_SERIES                                                
                                                
UPDATE TBL_PNL_DATA_TMP SET                     
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

    SELECT * INTO #NSECM_ISIN FROM ANGELDEMAT.MSAJAG.DBO.MULTIISIN WITH(NOLOCK)

  CREATE INDEX #SCRIP ON #NSECM_ISIN (SCRIP_CD,SERIES)
    CREATE INDEX #ISIN ON #BSEMULTIISIN(ISIN)  
  
    CREATE INDEX #ISIN ON #NSECM_ISIN(ISIN)      

	SELECT DISTINCT SETT_NO,SETT_TYPE,SCRIP_CD,SERIES,ISIN INTO #NSECMVISIN
 FROM MSAJAG.DBO.CMBILLVALAN WITH(NOLOCK) WHERE SAUDA_DATE >=@SAUDA_DATE AND SAUDA_DATE <=@SAUDA_DATE +' 23:59:59'
  
   CREATE INDEX #ISIN ON #NSECMVISIN(SETT_NO,SETT_TYPE,SCRIP_CD) 
  
  
  UPDATE TBL_PNL_DATA_TMP                                                                                
  SET    ISIN = M.ISIN                                                                             
  FROM   #NSECMVISIN M  WITH(NOLOCK)              
  WHERE  M.SETT_NO = TBL_PNL_DATA_TMP.SETT_NO                                                              
  AND M.SETT_TYPE = TBL_PNL_DATA_TMP.SETT_TYPE                                            
  AND M.SCRIP_CD = TBL_PNL_DATA_TMP.SCRIP_CD                                                                                
  AND M.SERIES = TBL_PNL_DATA_TMP.SERIES                         
  AND LEFT(TBL_PNL_DATA_TMP.EXCHANGE,1) = 'N'                                                                          
  AND TBL_PNL_DATA_TMP.ISIN = ''                                                              
  AND M.ISIN <> ''      

  UPDATE TBL_PNL_DATA_TMP                                                                                
  SET    ISIN = M.ISIN                                                       
  FROM   #BSECMBILLVALAN M    WITH(NOLOCK)                                                                                       
  WHERE  M.SETT_NO = TBL_PNL_DATA_TMP.SETT_NO                                                              
  AND M.SETT_TYPE = TBL_PNL_DATA_TMP.SETT_TYPE                                                              
  AND M.SCRIP_CD = TBL_PNL_DATA_TMP.BSECODE                                           
  AND M.SERIES = TBL_PNL_DATA_TMP.SERIES                                                                      
  AND LEFT(TBL_PNL_DATA_TMP.EXCHANGE,1) = 'B'                                           
  AND TBL_PNL_DATA_TMP.ISIN = ''                                                              
  AND M.ISIN <> ''    
                                        
                                                                   
  UPDATE TBL_PNL_DATA_TMP                                                                                
  SET    ISIN = M.ISIN                                                             
  FROM   #NSECM_ISIN M   WITH(NOLOCK)                                                                                        
  WHERE  M.SCRIP_CD = TBL_PNL_DATA_TMP.SCRIP_CD                                                                                
  AND M.SERIES IN ('EQ', 'BE')                                                      
  AND TBL_PNL_DATA_TMP.SERIES IN ('EQ', 'BE')                                                      
  AND VALID = 1                                                                      
  AND LEFT(EXCHANGE,1) = 'N'                                                                          
  AND TBL_PNL_DATA_TMP.ISIN = ''                                               
                                                      
  UPDATE TBL_PNL_DATA_TMP                                                                                
  SET    ISIN = M.ISIN                                                 
  FROM   #NSECM_ISIN M    WITH(NOLOCK)                                                                                       
  WHERE  M.SCRIP_CD = TBL_PNL_DATA_TMP.SCRIP_CD                                                                                
  AND M.SERIES = TBL_PNL_DATA_TMP.SERIES                                                                      
  AND TBL_PNL_DATA_TMP.SERIES NOT IN ('EQ', 'BE')                                                      
  AND VALID = 1                                                                      
  AND LEFT(EXCHANGE,1) = 'N'                                                                        
  AND TBL_PNL_DATA_TMP.ISIN = ''                                                      
                                                    
--  UPDATE TBL_PNL_DATA_TMP                                                                                
--  SET    ISIN = M.ISIN                                                                             
--  FROM   MSAJAG.DBO.CMBILLVALAN M  WITH(NOLOCK)              
--  WHERE  M.SETT_NO = TBL_PNL_DATA_TMP.SETT_NO                                                              
--AND M.SETT_TYPE = TBL_PNL_DATA_TMP.SETT_TYPE                                            
--  AND M.SCRIP_CD = TBL_PNL_DATA_TMP.SCRIP_CD                                                                                
--  AND M.SERIES = TBL_PNL_DATA_TMP.SERIES                         
--  AND LEFT(TBL_PNL_DATA_TMP.EXCHANGE,1) = 'N'                                                                          
--  AND TBL_PNL_DATA_TMP.ISIN = ''                                                              
--  AND M.ISIN <> ''                                
                                   
  UPDATE TBL_PNL_DATA_TMP                                                                                
  SET    ISIN = M.ISIN                                                                             
  FROM   #BSEMULTIISIN M        WITH(NOLOCK)                                                                                   
  WHERE  M.SCRIP_CD = TBL_PNL_DATA_TMP.BSECODE                                                                                
  AND M.SERIES = TBL_PNL_DATA_TMP.SERIES                                                                      
  AND VALID = 1                                                                      
  AND LEFT(EXCHANGE,1) = 'B'                         
  AND TBL_PNL_DATA_TMP.ISIN = ''                                  
                                                              
  --UPDATE TBL_PNL_DATA_TMP                                                                                
  --SET    ISIN = M.ISIN                                                       
  --FROM   #BSECMBILLVALAN M    WITH(NOLOCK)                                                                                       
  --WHERE  M.SETT_NO = TBL_PNL_DATA_TMP.SETT_NO                                                              
  --AND M.SETT_TYPE = TBL_PNL_DATA_TMP.SETT_TYPE                                                              
  --AND M.SCRIP_CD = TBL_PNL_DATA_TMP.BSECODE                                           
  --AND M.SERIES = TBL_PNL_DATA_TMP.SERIES                                                                      
  --AND LEFT(TBL_PNL_DATA_TMP.EXCHANGE,1) = 'B'                                           
  --AND TBL_PNL_DATA_TMP.ISIN = ''                                                              
  --AND M.ISIN <> ''                                               
                                                            
  UPDATE TBL_PNL_DATA_TMP                                                                                
  SET    BSECODE = M.SCRIP_CD                                                                      
  FROM   #BSEMULTIISIN M                                  
  WHERE  M.ISIN = TBL_PNL_DATA_TMP.ISIN      AND ISNULL(M.SCRIP_CD,'') <>  ISNULL(BSECODE,'')                                                                                    
  AND M.VALID = 1                                                             
          
  UPDATE TBL_PNL_DATA_TMP                                                                                
  SET    SCRIP_CD = M.SCRIP_CD,                                                  
  SERIES = M.SERIES                                                                      
  FROM   #NSECM_ISIN M  WITH(NOLOCK)                                                   
  WHERE  M.ISIN = TBL_PNL_DATA_TMP.ISIN   AND ISNULL(M.SCRIP_CD,'') <>  ISNULL(TBL_PNL_DATA_TMP.SCRIP_CD,'')                                                                                  
  AND M.VALID = 1                                                            
                                                                         
/*    
  UPDATE TBL_PNL_DATA_TMP                                                                                
  SET    BILLFLAG = 2,                                                                  
   OPPDATE = @SAUDA_DATE,                                                                    
   UPDFLAG = 1                                                                                
  FROM   #PNL_REARRANGE S (NOLOCK)                                                                                
  WHERE  S.PARTY_CODE = TBL_PNL_DATA_TMP.PARTY_CODE                                                                                
         AND S.ISIN = TBL_PNL_DATA_TMP.ISIN                                                 
   AND S.SCRIP_CD = TBL_PNL_DATA_TMP.SCRIP_CD                                     
   AND S.SERIES = TBL_PNL_DATA_TMP.SERIES                                                                      
   AND S.BSECODE = TBL_PNL_DATA_TMP.BSECODE                                      
         AND PQTY <= SQTY                                                                                
         AND PQTY > 0                                                                                
         AND TBL_PNL_DATA_TMP.SELL_BUY = 1                                                                 
                                                                      
  UPDATE TBL_PNL_DATA_TMP                                                                                
  SET    BILLFLAG = 3,                                                                  
   OPPDATE = @SAUDA_DATE,                                      
   UPDFLAG = 1                                                                                
FROM   #PNL_REARRANGE S (NOLOCK)                                                        
  WHERE  S.PARTY_CODE = TBL_PNL_DATA_TMP.PARTY_CODE                                                                                
         AND S.ISIN = TBL_PNL_DATA_TMP.ISIN                               
   AND S.SCRIP_CD = TBL_PNL_DATA_TMP.SCRIP_CD                                                                      
   AND S.SERIES = TBL_PNL_DATA_TMP.SERIES                                                                      
   AND S.BSECODE = TBL_PNL_DATA_TMP.BSECODE                                                                          
         AND SQTY <= PQTY                                                
         AND SQTY > 0                                                                                
         AND TBL_PNL_DATA_TMP.SELL_BUY = 2                                                                                
*/                                                                      
/*==============================================================================*/                                                                                
/*CURSOR TO COMPLETE FINAL MARKING FOR PART SQUARED-OFF POSITIONS*/                                                                 
/*==============================================================================*/    

SELECT   SNO, PARTY_CODE, ISIN, TRADEQTY, ORGDATE1=LEFT(ORGDATE,11), ORGDATE, Exchange  INTO #INTRADAY                                                    
                            FROM     TBL_PNL_DATA_TMP P (NOLOCK)                                          
                            WHERE    SELL_BUY = 1 AND OPPDATE LIKE 'DEC 31 2049%'                                                                
							AND SAUDA_DATE LIKE @SAUDA_DATE + '%'
       AND PARTY_CODE IN (SELECT PARTY_CODE FROM TBL_PNL_DATA_TMP P1   WITH(NOLOCK)                                                                 
              WHERE P.PARTY_CODE = P1.PARTY_CODE                                                                
              AND P.ISIN = P1.ISIN                                                                
              AND P1.SELL_BUY = 2 AND OPPDATE LIKE 'DEC 31 2049%'
			  AND SAUDA_DATE LIKE @SAUDA_DATE + '%'
			  AND P.EXCHANGE = P1.EXCHANGE)                                                                
                          ORDER BY PARTY_CODE, ISIN, ORGDATE, Exchange   

						    CREATE INDEX #PARTY ON #INTRADAY (PARTY_CODE, ISIN, ORGDATE  )


SET @SETTCUR = CURSOR FOR SELECT   SNO, PARTY_CODE, ISIN, TRADEQTY, ORGDATE1=LEFT(ORGDATE,11), ORGDATE, Exchange                                                      
                            FROM     #INTRADAY (NOLOCK)                                          
                             ORDER BY PARTY_CODE, ISIN, ORGDATE, Exchange                                                                                 
      
  OPEN @SETTCUR                                                                                
                                                                                  
  FETCH NEXT FROM @SETTCUR                                                                                
  INTO @BUYSNO, @PARTY_CODE,                                         
       @ISIN,                                                                   
       @PQTY,                                                                                
       @BUYSAUDA_DATE,                         
    @TEMPORGDATE,
	@Exchange                                                                      
                                                                      
  WHILE @@FETCH_STATUS = 0                                                                                
    BEGIN                                              
  SET @SETTREC = CURSOR FOR                                                                  
                                              
   SELECT   SNO, TRADEQTY, ORGDATE=LEFT(ORGDATE,11)                                                                                
   FROM     TBL_PNL_DATA_TMP (NOLOCK)                                                                                
   WHERE    PARTY_CODE = @PARTY_CODE                                                                                
   AND ISIN = @ISIN                                                                               
   AND SELL_BUY = 2                                                                                
   AND OPPDATE LIKE 'DEC 31 2049%' 
   AND EXCHANGE = @EXCHANGE                                                               
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
                                                                
  UPDATE TBL_PNL_DATA_TMP                                                    
  SET    BILLFLAG = 3, UPDFLAG = 1, OPPDATE = @BUYSAUDA_DATE, RECTYPE = 'SPEC'                             
  WHERE  SNO = @SELLSNO                                                                                
                                                                                                  
  IF @PQTY = @SQTY                                                                 
  BEGIN               
   UPDATE TBL_PNL_DATA_TMP                                                                                
   SET    BILLFLAG = 2, UPDFLAG = 1, OPPDATE = @SELLSAUDA_DATE, RECTYPE = 'SPEC'                                                                             
   WHERE SNO = @BUYSNO  
                                                                   
 SET @PQTY = 0                                                                                
     END                                                                                 
  ELSE                                                                
  BEGIN                      
   INSERT INTO TBL_PNL_DATA_TMP                                                                                
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
     N_NETRATE, OPPDATE=@SELLSAUDA_DATE, ORGDATE, 0, UPDFLAG = 1, RECTYPE = 'SPEC'                                                                               
   FROM   TBL_PNL_DATA_TMP (NOLOCK)                                                                                
   WHERE  SNO = @BUYSNO                          
                                                                
   UPDATE TBL_PNL_DATA_TMP                                    
   SET TRADEQTY = @PDIFF, UPDFLAG = 1                                                         
   WHERE  SNO = @BUYSNO                                       
                                           SELECT @PQTY = @PDIFF                                                                
        END                                                  
 END                                        
ELSE                                                                
 BEGIN                                                                
  SELECT @PDIFF = @SQTY - @PQTY                                                                
                                                
  UPDATE TBL_PNL_DATA_TMP                                                                                
  SET    BILLFLAG = 2, UPDFLAG = 1, OPPDATE = @SELLSAUDA_DATE,RECTYPE = 'SPEC'                                                                             
  WHERE  SNO = @BUYSNO         
                                                                
  INSERT INTO TBL_PNL_DATA_TMP                                                                                
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
    N_NETRATE, OPPDATE=@BUYSAUDA_DATE, ORGDATE, 0, UPDFLAG = 1, RECTYPE = 'SPEC'                                                                             
  FROM   TBL_PNL_DATA_TMP (NOLOCK)                                                                                
  WHERE  SNO = @SELLSNO                                                      
                                                                
  SET @PQTY = 0                                                                
                                                                
  UPDATE TBL_PNL_DATA_TMP                                                                                
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
  @TEMPORGDATE,
  @Exchange                                                                 
END    

-------

SELECT   SNO, PARTY_CODE, ISIN, TRADEQTY, ORGDATE1=LEFT(ORGDATE,11), ORGDATE    INTO #DeliVRYMaRk                                                  
                            FROM     TBL_PNL_DATA_TMP P (NOLOCK)                                          
                            WHERE    SELL_BUY = 1 AND OPPDATE LIKE 'DEC 31 2049%'                                                                
       AND PARTY_CODE IN (SELECT PARTY_CODE FROM TBL_PNL_DATA_TMP P1  WITH(NOLOCK)                                                                  
              WHERE P.PARTY_CODE = P1.PARTY_CODE                                                                
              AND P.ISIN = P1.ISIN                                                                
              AND P1.SELL_BUY = 2 AND OPPDATE LIKE 'DEC 31 2049%')                                                                
                          ORDER BY PARTY_CODE, ISIN, ORGDATE   
  CREATE INDEX #PARTY ON #DELIVRYMARK (PARTY_CODE, ISIN, ORGDATE  )
                                                                            
  SET @SETTCUR = CURSOR FOR SELECT   SNO, PARTY_CODE, ISIN, TRADEQTY, ORGDATE1=LEFT(ORGDATE,11), ORGDATE                                                      
                            FROM     #DeliVRYMaRk P (NOLOCK)                                          
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
   FROM     TBL_PNL_DATA_TMP (NOLOCK)                                                                                
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
                                                                
  UPDATE TBL_PNL_DATA_TMP                                                    
  SET    BILLFLAG = 3, UPDFLAG = 1, OPPDATE = @BUYSAUDA_DATE                             
  WHERE  SNO = @SELLSNO                                                                                
                                                                                                  
  IF @PQTY = @SQTY                                                                 
  BEGIN               
   UPDATE TBL_PNL_DATA_TMP                                                                                
   SET    BILLFLAG = 2, UPDFLAG = 1, OPPDATE = @SELLSAUDA_DATE                                                                             
   WHERE SNO = @BUYSNO  
                                                                   
 SET @PQTY = 0                                                                                
     END                                                                                 
  ELSE                                                                
  BEGIN                      
   INSERT INTO TBL_PNL_DATA_TMP                                                                                
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
   FROM   TBL_PNL_DATA_TMP (NOLOCK)                                                                                
   WHERE  SNO = @BUYSNO                          
                                                                
   UPDATE TBL_PNL_DATA_TMP                                    
   SET TRADEQTY = @PDIFF, UPDFLAG = 1                                                         
   WHERE  SNO = @BUYSNO                                       
                                           SELECT @PQTY = @PDIFF                                                                
        END                                                  
 END                                        
ELSE                                                                
 BEGIN                                                                
  SELECT @PDIFF = @SQTY - @PQTY                                                                
                                                
  UPDATE TBL_PNL_DATA_TMP                                                                                
  SET    BILLFLAG = 2, UPDFLAG = 1, OPPDATE = @SELLSAUDA_DATE                                                                             
  WHERE  SNO = @BUYSNO         
                                                                
  INSERT INTO TBL_PNL_DATA_TMP                                                                                
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
  FROM   TBL_PNL_DATA_TMP (NOLOCK)                                                                                
  WHERE  SNO = @SELLSNO                                                      
                                                                
  SET @PQTY = 0                                                                
                                                                
  UPDATE TBL_PNL_DATA_TMP                                                                                
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
                            FROM     TBL_PNL_DATA_TMP P (NOLOCK)                                                            
                            WHERE    SELL_BUY = 2 AND OPPDATE LIKE 'DEC 31 2049%'                                                                
       AND PARTY_CODE IN (SELECT PARTY_CODE FROM TBL_PNL_DATA_TMP P1                                                                
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
   FROM     TBL_PNL_DATA_TMP (NOLOCK)                                                        
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
                                                                
  UPDATE TBL_PNL_DATA_TMP                                                        
  SET    BILLFLAG = 2, UPDFLAG = 1, OPPDATE = @SELLSAUDA_DATE                                                                             
  WHERE  SNO = @BUYSNO                                                                                
                                              
  IF @PQTY = @SQTY                                                                 
  BEGIN                                                                
   UPDATE TBL_PNL_DATA_TMP                                                                                
   SET    BILLFLAG = 3, UPDFLAG = 1, OPPDATE = @BUYSAUDA_DATE                                                                             
   WHERE  SNO = @SELLSNO                                                                 
                                                                   
   SET @SQTY = 0                                                                                
     END                                                                                
  ELSE                                          
  BEGIN                  
   INSERT INTO TBL_PNL_DATA_TMP                
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
   FROM   TBL_PNL_DATA_TMP (NOLOCK)                                                                      
   WHERE  SNO = @SELLSNO                                                                                
                                                                
   UPDATE TBL_PNL_DATA_TMP                                                                                
   SET TRADEQTY = @PDIFF, UPDFLAG = 1                                                                                
   WHERE  SNO = @SELLSNO                                                
                                             
   SELECT @SQTY = @PDIFF                                                                
        END                                                                                
 END                                                                
 ELSE                                                                
 BEGIN                                                                
                                                                
  SELECT @PDIFF = @PQTY - @SQTY                          
                                                                
  UPDATE TBL_PNL_DATA_TMP                                                                                
  SET    BILLFLAG = 3, UPDFLAG = 1, OPPDATE = @BUYSAUDA_DATE                                                                             
  WHERE SNO = @SELLSNO                                                                 
        
  INSERT INTO TBL_PNL_DATA_TMP                                                                                
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
  FROM   TBL_PNL_DATA_TMP (NOLOCK)                                                                                
  WHERE  SNO = @BUYSNO                                                                                
                                                                  
  SET @SQTY = 0                                                                
                                                                
  UPDATE TBL_PNL_DATA_TMP                                                                                
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
                                                                
DELETE FROM TBL_PNL_DATA_NEW_RCS                            
WHERE SNO IN (SELECT ORGSNO FROM TBL_PNL_DATA_TMP WHERE UPDFLAG = 1 AND ORGSNO <> 0)                                                                    
                                            
INSERT INTO TBL_PNL_DATA_NEW_RCS                                                                      
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
FROM TBL_PNL_DATA_TMP    WITH(NOLOCK)                                                                            
WHERE UPDFLAG = 1   

                    
END

GO
