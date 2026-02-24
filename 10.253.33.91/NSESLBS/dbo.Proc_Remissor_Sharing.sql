-- Object: PROCEDURE dbo.Proc_Remissor_Sharing
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc Proc_Remissor_Sharing                      
(@Sett_No Varchar(7), @Sett_Type Varchar(2))                      
As                      
--SET NOCOUNT ON                       
Declare @FromDate     Varchar(11),                      
 @ToDate       Varchar(11),                      
 @Funds_Payin  Varchar(11),                       
 @Funds_Payout Varchar(11),                      
 @REMBROKNARR  VARCHAR(25),  
 @REMTDSNARR  VARCHAR(25)  
  
SELECT @REMBROKNARR = 'REM BROK SHARE', @REMTDSNARR = 'REM TDS AMOUNT'  
  
SELECT  @FromDate  = Left(Start_Date,11),            
 @ToDate    = Left(End_Date,11),                      
 @Funds_Payin    = Left(Funds_Payin,11),                      
 @Funds_Payout   = Left(Funds_Payout,11)                      
FROM REM_SETT_MST                       
WHERE SETT_NO = @SETT_NO                      
AND SETT_TYPE = @SETT_TYPE                      
                            
select distinct B.* Into #Broktable                       
from nsefo.dbo.broktable B, Remissor_Brok_Scheme R                      
Where R.FutTableNo = Table_No                      
or R.OptTableNo = Table_No                      
or R.OptExTableNo = Table_No                      
or R.FutFinalTableNo = Table_No                      
And RecType = 'FUTURES'                      
                      
SELECT S.SETT_NO,                      
       S.SETT_TYPE,                      
       S.PARTY_CODE,                      
       S.SCRIP_CD,                      
       S.SERIES,                      
       S.SAUDA_DATE,                      
       S.TRADE_NO,                      
       S.ORDER_NO,                      
       S.SELL_BUY,                      
       S.TRADEQTY,                      
       S.MARKETRATE,                      
       BROKAPPLIED,                      
       NBROKAPP,                      
       BILLFLAG,                      
       REMCODE = SUB_BROKER,                      
       BRANCH_CD,                      
       REM_BROKAPPLIED = CONVERT(NUMERIC(18,4),0),                      
       REM_NBROKAPP = CONVERT(NUMERIC(18,4),0),                      
       STATUS = '0',                      
       SLABTYPE = CONVERT(VARCHAR(10),''),                      
       FROMDATE = CONVERT(DATETIME,@FromDate),                      
       TODATE = CONVERT(DATETIME,@ToDate + ' 23:59:59'),                      
       REMPARTYCD = CONVERT(VARCHAR(10),''),                  
       ExchangeId = 'BSECM'                      
INTO   #REMBROK                      
FROM   BSEDB.DBO.CLIENT1 C1,                      
       BSEDB.DBO.CLIENT2 C2,                      
       BSEDB.DBO.SETTLEMENT S                      
WHERE  S.SAUDA_DATE >= @FromDate                      
       AND S.SAUDA_DATE <= @ToDate + ' 23:59'                      
       AND C1.CL_CODE = C2.CL_CODE                      
       AND C2.PARTY_CODE = S.PARTY_CODE                      
       AND AUCTIONPART NOT IN ('AP',                      
                               'AR',                      
                               'FP',                      
                               'FS',                      
                               'FA',                      
                               'FC',                      
                               'FL')                      
   AND (SUB_BROKER IN (SELECT REMCODE FROM Remissor_Brok_Scheme)                      
   OR SUB_BROKER IN (SELECT REMCODE FROM REM_BRANCH_SHARE_MASTER)                      
   OR BRANCH_CD IN (SELECT REMCODE FROM REM_BRANCH_SHARE_MASTER) )                      
                    
INSERT INTO   #REMBROK                      
SELECT S.SETT_NO,                      
       S.SETT_TYPE,                      
       S.PARTY_CODE,                      
       S.SCRIP_CD,                      
       S.SERIES,                      
       S.SAUDA_DATE,                      
       S.TRADE_NO,                      
       S.ORDER_NO,                      
       S.SELL_BUY,                      
S.TRADEQTY,                      
       S.MARKETRATE,                      
       BROKAPPLIED,               
      NBROKAPP,                      
       BILLFLAG,                      
       REMCODE = SUB_BROKER,                      
       BRANCH_CD,                      
       REM_BROKAPPLIED = CONVERT(NUMERIC(18,4),0),                      
       REM_NBROKAPP = CONVERT(NUMERIC(18,4),0),                      
       STATUS = '0',                      
       SLABTYPE = CONVERT(VARCHAR(10),''),           
       FROMDATE = CONVERT(DATETIME,@FromDate),                      
       TODATE = CONVERT(DATETIME,@ToDate + ' 23:59:59'),                      
       REMPARTYCD = CONVERT(VARCHAR(10),''),                  
       ExchangeId = 'BSECM'                   
FROM   BSEDB.DBO.CLIENT1 C1,                      
       BSEDB.DBO.CLIENT2 C2,                      
       BSEDB.DBO.HISTORY S                      
WHERE  S.SAUDA_DATE >= @FromDate                      
       AND S.SAUDA_DATE <= @ToDate + ' 23:59'                      
       AND C1.CL_CODE = C2.CL_CODE                      
       AND C2.PARTY_CODE = S.PARTY_CODE                      
       AND AUCTIONPART NOT IN ('AP',                      
                               'AR',                      
                               'FP',                      
                               'FS',                      
                               'FA',                      
                               'FC',                      
                              'FL')                      
    AND (SUB_BROKER IN (SELECT REMCODE FROM Remissor_Brok_Scheme)                      
   OR SUB_BROKER IN (SELECT REMCODE FROM REM_BRANCH_SHARE_MASTER)                      
   OR BRANCH_CD IN (SELECT REMCODE FROM REM_BRANCH_SHARE_MASTER) )                      
                      
INSERT INTO #REMBROK                      
SELECT S.SETT_NO,                      
       S.SETT_TYPE,                      
       S.PARTY_CODE,                      
       S.SCRIP_CD,                      
       S.SERIES,                      
       S.SAUDA_DATE,                      
       S.TRADE_NO,                      
       S.ORDER_NO,                      
       S.SELL_BUY,                      
       S.TRADEQTY,                      
       S.MARKETRATE,                      
       BROKAPPLIED,                      
       NBROKAPP,                      
       BILLFLAG,                      
       REMCODE = SUB_BROKER,                      
       BRANCH_CD,                      
       REM_BROKAPPLIED = CONVERT(NUMERIC(18,4),0),                      
       REM_NBROKAPP = CONVERT(NUMERIC(18,4),0),                      
       STATUS = '0',                      
       SLABTYPE = CONVERT(VARCHAR(10),''),                      
       FROMDATE = CONVERT(DATETIME,@FromDate),                      
       TODATE = CONVERT(DATETIME,@ToDate + ' 23:59:59'),                      
       REMPARTYCD = CONVERT(VARCHAR(10),''),                  
       ExchangeId = 'NSECM'                     
FROM   CLIENT1 C1,                      
       CLIENT2 C2,                      
       SETTLEMENT S                      
WHERE  S.SAUDA_DATE >= @FromDate                      
       AND S.SAUDA_DATE <= @ToDate + ' 23:59'                      
       AND C1.CL_CODE = C2.CL_CODE                      
       AND C2.PARTY_CODE = S.PARTY_CODE                      
       AND AUCTIONPART NOT IN ('AP',                      
                               'AR',                      
                               'FP',                      
                               'FS',                      
                               'FA',                      
                               'FC',                      
                               'FL')                      
       AND (SUB_BROKER IN (SELECT REMCODE FROM Remissor_Brok_Scheme)                      
       OR SUB_BROKER IN (SELECT REMCODE FROM REM_BRANCH_SHARE_MASTER)                      
       OR BRANCH_CD IN (SELECT REMCODE FROM REM_BRANCH_SHARE_MASTER) )                      
             
INSERT INTO #REMBROK                      
SELECT S.SETT_NO,                      
       S.SETT_TYPE,                      
       S.PARTY_CODE,                      
       S.SCRIP_CD,                      
       S.SERIES,                      
       S.SAUDA_DATE,                      
       S.TRADE_NO,                      
S.ORDER_NO,                
       S.SELL_BUY,                      
       S.TRADEQTY,                      
       S.MARKETRATE,                      
       BROKAPPLIED,                      
       NBROKAPP,                      
       BILLFLAG,                      
       REMCODE = SUB_BROKER,                      
       BRANCH_CD,                      
       REM_BROKAPPLIED = CONVERT(NUMERIC(18,4),0),                      
       REM_NBROKAPP = CONVERT(NUMERIC(18,4),0),                      
       STATUS = '0',                      
       SLABTYPE = CONVERT(VARCHAR(10),''),                      
       FROMDATE = CONVERT(DATETIME,@FromDate),                      
       TODATE = CONVERT(DATETIME,@ToDate + ' 23:59:59'),                      
       REMPARTYCD = CONVERT(VARCHAR(10),''),                  
       ExchangeId = 'NSECM'                      
FROM   CLIENT1 C1,                      
       CLIENT2 C2,                      
       HISTORY S                      
WHERE  S.SAUDA_DATE >= @FromDate                      
       AND S.SAUDA_DATE <= @ToDate + ' 23:59'                      
       AND C1.CL_CODE = C2.CL_CODE                      
       AND C2.PARTY_CODE = S.PARTY_CODE                      
       AND AUCTIONPART NOT IN ('AP',                      
                               'AR',                      
                               'FP',                      
                               'FS',                      
                               'FA',                      
                               'FC',                      
                               'FL')                      
    AND (SUB_BROKER IN (SELECT REMCODE FROM Remissor_Brok_Scheme)                      
   OR SUB_BROKER IN (SELECT REMCODE FROM REM_BRANCH_SHARE_MASTER)                      
   OR BRANCH_CD IN (SELECT REMCODE FROM REM_BRANCH_SHARE_MASTER) )                      
                      
SELECT S.PARTY_CODE, INST_TYPE, SYMBOL, EXPIRYDATE, STRIKE_PRICE, OPTION_TYPE, AUCTIONPART, SETTFLAG,                        
SAUDA_DATE, TRADE_NO, ORDER_NO, SELL_BUY,                 
TRADEQTY, PRICE, Brokerage=BROKAPPLIED*TRADEQTY,                       
REMCODE = SUB_BROKER, BRANCH_CD,                       
REM_BROKAPPLIED=CONVERT(NUMERIC(18,4),0), REM_NBROKAPP=CONVERT(NUMERIC(18,4),0), Status = '0',                      
SLABTYPE=CONVERT(VARCHAR(10),''),                      
FROMDATE = CONVERT(DATETIME,@FromDate),                       
TODATE = CONVERT(DATETIME,@ToDate + ' 23:59:59'),                      
MPrice = Strike_Price+Price,                      
Multiplier = 1,                      
REMPARTYCD = CONVERT(VARCHAR(10),''),                   
ExchangeId = 'NSEFO'                     
Into #FOREMBROK                      
FROM NSEFO.DBO.CLIENT1 C1, NSEFO.DBO.CLIENT2 C2, NSEFO.DBO.FOSETTLEMENT S                      
WHERE S.SAUDA_DATE >= @FromDate AND S.SAUDA_DATE <= @ToDate + ' 23:59'                      
AND C1.CL_CODE = C2.CL_CODE                      
AND C2.PARTY_CODE = S.PARTY_CODE                      
AND AUCTIONPART <> 'CA'                      
AND PRICE > 0                      
AND (SUB_BROKER IN (SELECT REMCODE FROM Remissor_Brok_Scheme)                      
OR SUB_BROKER IN (SELECT REMCODE FROM REM_BRANCH_SHARE_MASTER)                      
OR BRANCH_CD IN (SELECT REMCODE FROM REM_BRANCH_SHARE_MASTER))                      
                
                
UPDATE #REMBROK                      
SET   REM_BROKAPPLIED = (CASE                       
                            WHEN #REMBROK.STATUS = 'N' THEN 0                      
ELSE (CASE                       
                                    WHEN (#REMBROK.BILLFLAG = 1                      
                                          AND BROKTABLE.VAL_PERC = 'V'         
                                          AND SELL_BUY = 1) THEN  /* broktable.Normal */                      
                                          ((Floor((BROKTABLE.NORMAL * Power(10,BROKTABLE.ROUND_TO) + BROKTABLE.ROFIG + BROKTABLE.ERRNUM) / (BROKTABLE.ROFIG + BROKTABLE.NOZERO)) * (BROKTABLE.ROFIG + BROKTABLE.NOZERO)) / Power(10,BROKTABLE.ROUND_TO))       
 
    
      
       
       
           
            
              
               
             WHEN (#REMBROK.BILLFLAG = 1            
                                          AND BROKTABLE.VAL_PERC = 'V'                      
                                       AND SELL_BUY = 2) THEN /* broktable.Normal  */                      
                                         ((Floor((BROKTABLE.NORMAL * Power(10,BROKTABLE.ROUND_TO) + BROKTABLE.ROFIG + BROKTABLE.ERRNUM) / (BROKTABLE.ROFIG + BROKTABLE.NOZERO)) * (BROKTABLE.ROFIG + BROKTABLE.NOZERO)) / Power(10,BROKTABLE.ROUND_TO))        
 
          
            
              
                                    WHEN (#REMBROK.BILLFLAG = 1                      
                                          AND BROKTABLE.VAL_PERC = 'P'                      
                                          AND SELL_BUY = 1) THEN ((Floor((((BROKTABLE.NORMAL / 100) * #REMBROK.MARKETRATE) * Power(10,BROKTABLE.ROUND_TO) + BROKTABLE.ROFIG + BROKTABLE.ERRNUM) / (BROKTABLE.ROFIG + BROKTABLE.NOZERO)) * (BROKTABLE.ROFIG + BROKTABLE.NOZERO)) / Power(10,BROKTABLE.ROUND_TO))                      
                                    WHEN (#REMBROK.BILLFLAG = 1                      
                                          AND BROKTABLE.VAL_PERC = 'P'                      
                                       AND SELL_BUY = 2) THEN /* round((broktable.Normal /100 )* #REMBROK.marketrate,BrokTable.Round_To)         */                      
                                      ((Floor((((BROKTABLE.NORMAL / 100) * #REMBROK.MARKETRATE) * Power(10,BROKTABLE.ROUND_TO) + BROKTABLE.ROFIG + BROKTABLE.ERRNUM) / (BROKTABLE.ROFIG + BROKTABLE.NOZERO)) * (BROKTABLE.ROFIG + BROKTABLE.NOZERO)) / Power(10,BROKTABLE.ROUND_TO))                      
                                    WHEN (#REMBROK.BILLFLAG = 2                      
                                          AND BROKTABLE.VAL_PERC = 'V') THEN /* ((broktable.day_puc)) */                      
                                         ((Floor((((BROKTABLE.DAY_PUC)) * Power(10,BROKTABLE.ROUND_TO) + BROKTABLE.ROFIG + BROKTABLE.ERRNUM) / (BROKTABLE.ROFIG + BROKTABLE.NOZERO)) * (BROKTABLE.ROFIG + BROKTABLE.NOZERO)) / Power(10,BROKTABLE.ROUND_TO))   
  
    
      
      
        
          
                  
                   
                                    WHEN (#REMBROK.BILLFLAG = 2                      
                                       AND BROKTABLE.VAL_PERC = 'P') THEN /* round((broktable.day_puc/100) * #REMBROK.marketrate,BrokTable.Round_To)  */                      
                                         ((Floor((((BROKTABLE.DAY_PUC / 100) * #REMBROK.MARKETRATE) * Power(10,BROKTABLE.ROUND_TO) + BROKTABLE.ROFIG + BROKTABLE.ERRNUM) / (BROKTABLE.ROFIG + BROKTABLE.NOZERO)) * (BROKTABLE.ROFIG + BROKTABLE.NOZERO)) / Power(10,BROKTABLE.ROUND_TO))                      
                                    WHEN (#REMBROK.BILLFLAG = 3                      
                                          AND BROKTABLE.VAL_PERC = 'V') THEN /* broktable.day_sales */                      
                                         ((Floor((BROKTABLE.DAY_SALES * Power(10,BROKTABLE.ROUND_TO) + BROKTABLE.ROFIG + BROKTABLE.ERRNUM) / (BROKTABLE.ROFIG + BROKTABLE.NOZERO)) * (BROKTABLE.ROFIG + BROKTABLE.NOZERO)) / Power(10,BROKTABLE.ROUND_TO))     
  
    
      
      
        
          
            
              
                
                 
                         WHEN (#REMBROK.BILLFLAG = 3                      
                                          AND BROKTABLE.VAL_PERC = 'P') THEN /*round((broktable.day_sales/ 100) * #REMBROK.marketrate ,BrokTable.Round_To) */                      
                                         ((Floor((((BROKTABLE.DAY_SALES / 100) * #REMBROK.MARKETRATE) * Power(10,BROKTABLE.ROUND_TO) + BROKTABLE.ROFIG + BROKTABLE.ERRNUM) / (BROKTABLE.ROFIG + BROKTABLE.NOZERO)) * (BROKTABLE.ROFIG + BROKTABLE.NOZERO)) / Power(10,BROKTABLE.ROUND_TO))                      
                                    WHEN (#REMBROK.BILLFLAG = 4                      
                                          AND BROKTABLE.VAL_PERC = 'V') THEN /* broktable.sett_purch  */                      
  ((Floor((BROKTABLE.SETT_PURCH * Power(10,BROKTABLE.ROUND_TO) + BROKTABLE.ROFIG + BROKTABLE.ERRNUM) / (BROKTABLE.ROFIG + BROKTABLE.NOZERO)) * (BROKTABLE.ROFIG + BROKTABLE.NOZERO)) / Power(10,BROKTABLE.ROUND_TO))          
        
          
                   
                                    WHEN (#REMBROK.BILLFLAG = 4                      
                                          AND BROKTABLE.VAL_PERC = 'P') THEN /* round((broktable.sett_purch/100) * #REMBROK.marketrate ,BrokTable.Round_To) */                      
                                         ((Floor((((BROKTABLE.SETT_PURCH / 100) * #REMBROK.MARKETRATE) * Power(10,BROKTABLE.ROUND_TO) + BROKTABLE.ROFIG + BROKTABLE.ERRNUM) / (BROKTABLE.ROFIG + BROKTABLE.NOZERO)) * (BROKTABLE.ROFIG + BROKTABLE.NOZERO)) / Power(10,BROKTABLE.ROUND_TO))                      
                                    WHEN (#REMBROK.BILLFLAG = 5                      
                                          AND BROKTABLE.VAL_PERC = 'V') THEN /* broktable.sett_sales */                      
                                         ((Floor((BROKTABLE.SETT_SALES * Power(10,BROKTABLE.ROUND_TO) + BROKTABLE.ROFIG + BROKTABLE.ERRNUM) / (BROKTABLE.ROFIG + BROKTABLE.NOZERO)) * (BROKTABLE.ROFIG + BROKTABLE.NOZERO)) / Power(10,BROKTABLE.ROUND_TO))    
  
    
      
      
        
                
                                    WHEN (#REMBROK.BILLFLAG = 5                      
                                          AND BROKTABLE.VAL_PERC = 'P') THEN /* round((broktable.sett_sales/100) * #REMBROK.marketrate ,BrokTable.Round_To)*/                      
                                         ((Floor((((BROKTABLE.SETT_SALES / 100) * #REMBROK.MARKETRATE) * Power(10,BROKTABLE.ROUND_TO) + BROKTABLE.ROFIG + BROKTABLE.ERRNUM) / (BROKTABLE.ROFIG + BROKTABLE.NOZERO)) * (BROKTABLE.ROFIG + BROKTABLE.NOZERO)) / Power(10,BROKTABLE.ROUND_TO))                      
                                    ELSE 0                      
                                  END)                      
                          END),                      
       SLABTYPE = R.SLABTYPE,                      
       REMPARTYCD = R.REMPARTYCD                      
FROM   BROKTABLE,                      
       #REMBROK,                      
       REMISSOR_BROK_SCHEME R,                      
       (SELECT   SETT_NO,                      
                 SETT_TYPE,                      
                 PARTY_CODE,                  
                 SCRIP_CD,                      
                 SERIES,                      
                 PQTY = SUM(CASE                       
                              WHEN SELL_BUY = 1 THEN TRADEQTY                      
                              ELSE 0                      
                            END),                      
                 SQTY = SUM(CASE                       
                              WHEN SELL_BUY = 2 THEN TRADEQTY                      
                              ELSE 0                      
                            END),                      
                 PRATE = (CASE                       
                            WHEN SUM(CASE                       
   WHEN SELL_BUY = 1 THEN TRADEQTY                      
                                  ELSE 0                      
                                     END) > 0 THEN SUM(CASE                       
                                                         WHEN SELL_BUY = 1 THEN TRADEQTY * MARKETRATE                      
                           ELSE 0                      
                                                       END) / SUM(CASE                       
                                                                    WHEN SELL_BUY = 1 THEN TRADEQTY                      
                                                                    ELSE 0                      
                                                                  END)                      
                        ELSE 0                      
                          END),                      
                 SRATE = (CASE                       
                            WHEN SUM(CASE                       
 WHEN SELL_BUY = 2 THEN TRADEQTY                      
                                       ELSE 0                      
                            END) > 0 THEN SUM(CASE                       
                                                         WHEN SELL_BUY = 2 THEN TRADEQTY * MARKETRATE                      
                                                         ELSE 0                      
                                                       END) / SUM(CASE                       
                                                            WHEN SELL_BUY = 2 THEN TRADEQTY                      
                                                                    ELSE 0                      
                                                              END)                      
                            ELSE 0                      
                          END)                      
        FROM     #REMBROK                      
        GROUP BY SETT_NO,                      
                 SETT_TYPE,                      
                 PARTY_CODE,                      
                 SCRIP_CD,                      
                 SERIES) C                      
WHERE  #REMBROK.REMCODE = R.REMCODE                      
       AND C.SETT_NO = #REMBROK.SETT_NO                      
       AND C.SETT_TYPE = #REMBROK.SETT_TYPE                      
       AND C.SETT_TYPE = #REMBROK.SETT_TYPE                      
       AND C.SCRIP_CD = #REMBROK.SCRIP_CD                      
       AND C.SERIES = #REMBROK.SERIES                      
       AND SAUDA_DATE BETWEEN FROM_DATE                      
                              AND TO_DATE                      
       AND TRDTABLENO = BROKTABLE.TABLE_NO                      
       AND R.RECTYPE = 'CAPITAL'                      
       AND BILLFLAG IN (2,                      
                        3)                      
       AND BROKTABLE.LINE_NO = (CASE                       
                                  WHEN R.BROKSCHEME = 2 THEN (SELECT MIN(BROKTABLE.LINE_NO)                      
                                                              FROM   BROKTABLE                      
           WHERE  TRDTABLENO = BROKTABLE.TABLE_NO                      
                                                                     AND TRD_DEL = (CASE                       
                                                                                      WHEN PQTY = SQTY THEN (CASE                       
                                                                                                               WHEN PRATE >= SRATE THEN (CASE                       
                                                                                                                                           WHEN (#REMBROK.SELL_BUY = 1) THEN 'F'                      
                                                                       ELSE 'S'                      
                                 END)                      
                                                                                                               ELSE (CASE                       
                                                                                                                       WHEN (#REMBROK.SELL_BUY = 2) THEN 'F'                      
         ELSE 'S'                      
                                                                                                            END)                      
                                                                                                             END)                      
                                                                                      ELSE (CASE                       
                                                                                              WHEN PQTY >= SQTY THEN (CASE                       
       WHEN (#REMBROK.SELL_BUY = 1) THEN 'F'         
                                                                              ELSE 'S'                      
                                                                                           END)                      
                                                                                              ELSE (CASE                       
                                   WHEN (#REMBROK.SELL_BUY = 2) THEN 'F'                      
                                                                                                      ELSE 'S'                      
                                                                                                    END)                      
                                END)                      
                                                                                    END)                      
        AND #REMBROK.REMCODE = R.REMCODE                      
                                                                     AND #REMBROK.MARKETRATE <= BROKTABLE.UPPER_LIM)                      
                                  ELSE (CASE                       
                                          WHEN R.BROKSCHEME = 1 THEN (SELECT MIN(BROKTABLE.LINE_NO)                      
                                                                      FROM   BROKTABLE                      
                                                                      WHERE  TRDTABLENO = BROKTABLE.TABLE_NO                      
                                                              AND TRD_DEL = (CASE                       
                                                                                              WHEN PQTY >= SQTY THEN (CASE                       
                                                                                                                        WHEN (#REMBROK.SELL_BUY = 1) THEN 'F'                      
                                                                                                                        ELSE 'S'                      
                                                                                                                      END)                      
                                                                                          ELSE (CASE                       
                                                                                                      WHEN (#REMBROK.SELL_BUY = 2) THEN 'F'                      
                                                                                                      ELSE 'S'                      
                                                                                                    END)                      
                                                                                            END)                      
                                                                             AND #REMBROK.REMCODE = R.REMCODE                  
                                                                             AND #REMBROK.MARKETRATE <= BROKTABLE.UPPER_LIM)                      
                                          ELSE (CASE                       
                                                  WHEN R.BROKSCHEME = 3 THEN (SELECT MIN(BROKTABLE.LINE_NO)                      
                                                                              FROM   BROKTABLE                      
                                                                              WHERE  TRDTABLENO = BROKTABLE.TABLE_NO                      
                                                                                     AND TRD_DEL = (CASE                       
                                             WHEN SQTY >= PQTY THEN (CASE                       
                                                                                                                                WHEN (#REMBROK.SELL_BUY = 2) THEN 'F'                      
                                                    ELSE 'S'                      
        END)                      
                                                                                                      ELSE (CASE                       
                                                 WHEN (#REMBROK.SELL_BUY = 1) THEN 'F'                      
                                                                                                              ELSE 'S'                      
                                                                                                            END)                      
                    END)                      
                                                                                     AND #REMBROK.REMCODE = R.REMCODE            
                                                                                     AND #REMBROK.MARKETRATE <= BROKTABLE.UPPER_LIM)                      
                                                  ELSE (SELECT MIN(BROKTABLE.LINE_NO)                      
                                                        FROM   BROKTABLE                      
                                                        WHERE  TRDTABLENO = BROKTABLE.TABLE_NO                      
                                                    AND TRD_DEL = 'T'                      
                                                               AND #REMBROK.REMCODE = R.REMCODE                      
                                                               AND #REMBROK.MARKETRATE <= BROKTABLE.UPPER_LIM)                      
        END)                      
                                        END)                      
                                END)                      
                      
UPDATE #REMBROK                      
SET    REM_NBROKAPP = (CASE                       
                         WHEN (BROKTABLE.VAL_PERC = 'V') THEN ((Floor((BROKTABLE.NORMAL * Power(10,BROKTABLE.ROUND_TO) + BROKTABLE.ROFIG + BROKTABLE.ERRNUM) / (BROKTABLE.ROFIG + BROKTABLE.NOZERO)) * (BROKTABLE.ROFIG + BROKTABLE.NOZERO)) / Power(10,BROKTABLE.ROUND_TO))                      
                         WHEN (BROKTABLE.VAL_PERC = 'P') THEN ((Floor((((BROKTABLE.NORMAL / 100) *#REMBROK.MARKETRATE) * Power(10,BROKTABLE.ROUND_TO) + BROKTABLE.ROFIG + BROKTABLE.ERRNUM) / (BROKTABLE.ROFIG + BROKTABLE.NOZERO)) * (BROKTABLE.ROFIG + BROKTABLE.NOZERO)) / Power(10,BROKTABLE.ROUND_TO))                      
                         ELSE BROKAPPLIED                      
                       END),   
       SLABTYPE = R.SLABTYPE,                      
       REMPARTYCD = R.REMPARTYCD                      
FROM   BROKTABLE,                      
       #REMBROK,                      
       REMISSOR_BROK_SCHEME R                      
WHERE  #REMBROK.REMCODE = R.REMCODE                      
       AND R.RECTYPE = 'CAPITAL'                      
       AND DELTABLENO = BROKTABLE.TABLE_NO                      
       AND BROKTABLE.LINE_NO = (SELECT MIN(BROKTABLE.LINE_NO)                      
                                FROM   BROKTABLE                      
                                WHERE  DELTABLENO = BROKTABLE.TABLE_NO                      
                                       AND TRD_DEL = 'd'                      
           AND #REMBROK.REMCODE = R.REMCODE                      
                                       AND #REMBROK.MARKETRATE <= BROKTABLE.UPPER_LIM)           
       AND #REMBROK.BILLFLAG IN (1,                      
                                 4,                      
                                 5)                      
       AND SAUDA_DATE BETWEEN FROM_DATE                      
                              AND TO_DATE                      
                      
Update #FOREMBROK set                         
 REM_BROKAPPLIED =                      
  (((case when ( #FOREMBROK.SettFlag = 1 and broktable.val_perc ='V' and #FOREMBROK.sell_buy = 1)                        
  Then ((floor(( broktable.Normal*MultiPlier * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                          
   (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ))/power(10,broktable.round_to))                        
  when ( #FOREMBROK.SettFlag = 1 and broktable.val_perc ='V' and #FOREMBROK.sell_buy = 2)                
  Then ((floor(( broktable.Normal*MultiPlier * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                          
   (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ))/power(10,broktable.round_to))                        
  when ( #FOREMBROK.SettFlag = 1 and broktable.val_perc ='P' and #FOREMBROK.sell_buy = 1)                        
  Then ((floor((((broktable.Normal*MultiPlier /100 ) * MPrice)  * power(10,Broktable.round_to) + broktable.roFig + broktable.errnum ) /                          
   (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))                        
  when ( #FOREMBROK.SettFlag = 1 and broktable.val_perc ='P' and #FOREMBROK.sell_buy = 2)                        
  Then                         
   ((floor(( ((broktable.Normal*MultiPlier /100 )* MPrice) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                          
   (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                         
   power(10,broktable.round_to))                        
  when (#FOREMBROK.SettFlag = 2  and broktable.val_perc ='V' )       Then                         
   ((floor(( ((Broktable.Day_puc*MultiPlier))  * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                          
   (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                         
   power(10,broktable.round_to))                        
  when (#FOREMBROK.SettFlag = 2  and broktable.val_perc ='P' )                         
  Then                         
   ((floor(( ((Broktable.Day_puc*MultiPlier/100) * MPrice) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                          
   (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                         
   power(10,broktable.round_to))                        
  when (#FOREMBROK.SettFlag = 3  and broktable.val_perc ='V' )                        
  Then                         
   ((floor(( Broktable.day_sales*MultiPlier * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                          
   (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                         
   power(10,broktable.round_to))                        
  when (#FOREMBROK.SettFlag = 3  and broktable.val_perc ='P' )                        
  Then                       
   ((floor(( ((Broktable.day_sales*MultiPlier/ 100) * MPrice) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                          
   (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                         
   power(10,broktable.round_to))                        
  when ( #FOREMBROK.SettFlag = 4  and broktable.val_perc ='V' )                        
  Then                         
   ((floor(( Broktable.Sett_purch*MultiPlier * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                          
   (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                         
   power(10,broktable.round_to))                        
  when ( #FOREMBROK.SettFlag = 4  and broktable.val_perc ='P' )                        
  Then                         
   ((floor(( ((Broktable.Sett_purch*MultiPlier/100) * MPrice) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                          
   (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                         
   power(10,broktable.round_to))                        
  when ( #FOREMBROK.SettFlag = 5  and broktable.val_perc ='V' )                        
  Then                         
   ((floor(( Broktable.Sett_sales*MultiPlier * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                          
   (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                         
   power(10,broktable.round_to))                        
  when ( #FOREMBROK.SettFlag = 5  and broktable.val_perc ='P' )                        
  Then                         
   ((floor(( ((Broktable.Sett_sales*MultiPlier/100) * MPrice) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                          
   (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                         
   power(10,broktable.round_to))                        
        when (#FOREMBROK.SettFlag = 8  and broktable.val_perc ='V' )                       
                                    Then                       
          ((floor(( ((MultiPlier*broktable.Sett_purch))  * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                        
          (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                       
          power(10,broktable.round_to))                      
                              when (#FOREMBROK.SettFlag = 8  and broktable.val_perc ='P' )                       
                                     Then                       
          ((floor(( ((MultiPlier*Broktable.Sett_purch/100) * (MPrice)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                        
          (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                       
          power(10,broktable.round_to))                      
                          
        when (#FOREMBROK.SettFlag = 9  and broktable.val_perc ='V' )                      
                                     Then                       
          ((floor(( MultiPlier*Broktable.Sett_sales * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                        
          (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                       
          power(10,broktable.round_to))                      
                          when (#FOREMBROK.SettFlag = 9  and broktable.val_perc ='P' )                      
                                     Then                       
          ((floor(( ((MultiPlier*Broktable.Sett_sales/ 100) * (MPrice)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                        
          (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                       
          power(10,broktable.round_to))                 
                        when ( #FOREMBROK.SettFlag = 6  and broktable.val_perc ='V' )                      
                                     Then                       
          ((floor((MultiPlier* Broktable.Sett_purch * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                        
          (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                       
     power(10,broktable.round_to))                      
                                 when ( #FOREMBROK.SettFlag = 6  and broktable.val_perc ='P' )                      
                                Then                       
 ((floor(( ((MultiPlier*Broktable.Sett_purch/100) * (MPrice)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                        
          (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                       
          power(10,broktable.round_to))                      
                     when ( #FOREMBROK.SettFlag = 7  and broktable.val_perc ='V' )                      
                                     Then                       
          ((floor((MultiPlier* Broktable.Sett_sales * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                        
          (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                       
          power(10,broktable.round_to))                      
                     when ( #FOREMBROK.SettFlag = 7  and broktable.val_perc ='P' )                      
                                     Then                       
          ((floor(( ((MultiPlier*Broktable.Sett_sales/100) * (MPrice)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                        
          (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                       
          power(10,broktable.round_to))                      
  Else  0                         
  End                         
 ))),                      
       SLABTYPE = R.SLABTYPE,                      
       REMPARTYCD = R.REMPARTYCD                      
FROM                       
 #Broktable BrokTable,                      
 #FOREMBROK,                      
 REMISSOR_BROK_SCHEME R,                      
                      
      ( SELECT RemCode,inst_type,symbol,expirydate,                        
   PQty=SUM(Case When Sell_buy = 1 Then TradeQty Else 0 End),                        
   SQty=SUM(Case When Sell_buy = 2 Then TradeQty Else 0 End),                        
   PRate=(Case When SUM(Case When Sell_buy = 1 Then TradeQty Else 0 End) > 0                      
          Then SUM(Case When Sell_buy = 1 Then TradeQty*Price Else 0 End) /                      
        SUM(Case When Sell_buy = 1 Then TradeQty Else 0 End)                      
          Else 0 End),                        
   SRate=(Case When SUM(Case When Sell_buy = 2 Then TradeQty Else 0 End) > 0                      
          Then SUM(Case When Sell_buy = 2 Then TradeQty*Price Else 0 End) /                      
        SUM(Case When Sell_buy = 2 Then TradeQty Else 0 End)                      
          Else 0 End),                        
   SDate=Left(Convert(Varchar,sauda_date,109),11),option_type,strike_price,AuctionPart                      
   FROM #FOREMBROK                      
   group by RemCode,inst_type,symbol,expirydate,Left(Convert(Varchar,sauda_date,109),11),option_type,strike_price,AuctionPart                      
       ) S                      
WHERE                      
 #FOREMBROK.RemCode = s.RemCode and                       
 #FOREMBROK.RemCode = R.RemCode and                        
 #FOREMBROK.AuctionPart = S.AuctionPart and                        
 #FOREMBROK.inst_type=S.inst_type and                       
 #FOREMBROK.symbol=S.symbol and                        
 #FOREMBROK.expirydate=S.expirydate  AND                        
 #FOREMBROK.strike_price = s.strike_price and                                        
 #FOREMBROK.option_type = s.option_type and                      
 #FOREMBROK.sauda_date between From_Date and To_Date and                       
 R.RECTYPE = 'FUTURES' And                       
 #FOREMBROK.sauda_date like S.sdate + '%' AND                        
 Broktable.Table_no = (                       
    CASE                       
        WHEN Left(S.Inst_Type,3) = 'FUT' And #FOREMBROK.AuctionPart = ''                      
        THEN FutTableNo                      
        WHEN Left(S.Inst_Type,3) = 'FUT' And #FOREMBROK.AuctionPart = 'EA'                      
        THEN FutFinalTableNo                       
        WHEN Left(S.Inst_Type,3) = 'OPT' And #FOREMBROK.AuctionPart <> 'EA'                      
      THEN OptTableNo                      
        WHEN Left(S.Inst_Type,3) = 'OPT' And #FOREMBROK.AuctionPart = 'EA'                      
 THEN OptExTableNo                      
    END                       
    )                       
    AND Broktable.Line_no = (                       
    CASE                
        WHEN BrokScheme  = 1                      
        THEN                       
        (                       
        SELECT                       
            Min(Broktable.line_no)                       
 FROM #Broktable Broktable                       
        WHERE Broktable.Table_no =(                       
            CASE                       
                WHEN Left(S.Inst_Type,3) = 'FUT' And #FOREMBROK.AuctionPart = ''                      
 THEN FutTableNo                      
         WHEN Left(S.Inst_Type,3) = 'FUT' And #FOREMBROK.AuctionPart = 'EA'                      
         THEN FutFinalTableNo                       
         WHEN Left(S.Inst_Type,3) = 'OPT' And #FOREMBROK.AuctionPart <> 'EA'                      
         THEN OptTableNo                      
         WHEN Left(S.Inst_Type,3) = 'OPT' And #FOREMBROK.AuctionPart = 'EA'                      
  THEN OptExTableNo         
            END                       
            )                       
            AND Trd_Del = (                       
            CASE                       
                WHEN ((s.Pqty >= s.Sqty)                       
                AND #FOREMBROK.Settflag in (1,2,3,4,5))                       
                THEN (                  
                CASE                       
                    WHEN ( #FOREMBROK.Sell_Buy = 1 )                       
                    THEN 'F'                       
                    ELSE 'S'                       
                END                       
                )                       
                WHEN #FOREMBROK.Settflag in(6,7)                       
                THEN 'S'                       
                WHEN #FOREMBROK.Settflag in(8,9)                       
                THEN 'F'                       
                WHEN ((s.Pqty < s.Sqty)                       
                AND #FOREMBROK.Settflag in (1,2,3,4,5))                       
                THEN (                       
       CASE                       
                    WHEN ( #FOREMBROK.Sell_Buy = 2 )                       
                    THEN 'F'                       
                    ELSE 'S'                       
                END                       
                )                       
                WHEN #FOREMBROK.Settflag in(6,7)                       
                THEN 'S'                       
                WHEN #FOREMBROK.Settflag in(8,9)                       
                THEN 'F'                       
                WHEN #FOREMBROK.settflag = 0                       
                THEN 'F'                       
            END                       
            )                       
            AND #FOREMBROK.RemCode = s.RemCode                       
            AND MPrice <= Broktable.upper_lim                       
     )                       
        WHEN BrokScheme = 3                  
        THEN                       
        (                       
        SELECT                       
            min(Broktable.line_no)                       
        FROM #Broktable broktable                       
        WHERE Broktable.table_no = (                       
            CASE    WHEN Left(S.Inst_Type,3) = 'FUT' And #FOREMBROK.AuctionPart = ''                      
  THEN FutTableNo                      
  WHEN Left(S.Inst_Type,3) = 'FUT' And #FOREMBROK.AuctionPart = 'EA'                      
  THEN FutFinalTableNo                       
  WHEN Left(S.Inst_Type,3) = 'OPT' And #FOREMBROK.AuctionPart <> 'EA'                      
  THEN OptTableNo                      
  WHEN Left(S.Inst_Type,3) = 'OPT' And #FOREMBROK.AuctionPart = 'EA'                      
  THEN OptExTableNo                      
            END                       
            )                       
            AND Trd_Del = (               
            CASE                       
                WHEN ((s.Pqty > s.Sqty)                       
                AND #FOREMBROK.Settflag in (1,2,3,4,5))                       
                THEN (                       
                CASE                       
                    WHEN ( #FOREMBROK.Sell_Buy = 1 )                       
                    THEN 'F'                       
                    ELSE 'S'                       
                END                       
                )                       
                WHEN #FOREMBROK.Settflag in(6,7)                       
                THEN 'S'                       
                WHEN #FOREMBROK.Settflag in(8,9)                       
                THEN 'F'                       
                WHEN ((s.Pqty <= s.Sqty)                       
                AND #FOREMBROK.Settflag in (1,2,3,4,5))                       
                THEN (                       
                CASE                       
   WHEN ( #FOREMBROK.Sell_Buy = 2 )                       
                    THEN 'F'                       
                    ELSE 'S'       
                END                       
                )                       
                WHEN #FOREMBROK.Settflag in(6,7)                       
                THEN 'S'                       
                WHEN #FOREMBROK.Settflag in(8,9)                       
                THEN 'F'                       
                WHEN #FOREMBROK.settflag = 0                       
                THEN 'F'                       
         END                       
            )                       
            AND #FOREMBROK.RemCode = s.RemCode                       
            AND MPrice <= Broktable.upper_lim                       
        )                       
        WHEN BrokScheme = 2                      
        THEN                       
        (                       
        SELECT                       
            min(Broktable.line_no)                       
        FROM #Broktable broktable                       
        WHERE Broktable.table_no = (                       
            CASE                       
  WHEN Left(S.Inst_Type,3) = 'FUT' And #FOREMBROK.AuctionPart = ''                      
  THEN FutTableNo                      
  WHEN Left(S.Inst_Type,3) = 'FUT' And #FOREMBROK.AuctionPart = 'EA'                      
  THEN FutFinalTableNo                       
  WHEN Left(S.Inst_Type,3) = 'OPT' And #FOREMBROK.AuctionPart <> 'EA'                      
  THEN OptTableNo                      
  WHEN Left(S.Inst_Type,3) = 'OPT' And #FOREMBROK.AuctionPart = 'EA'                      
  THEN OptExTableNo                      
            END                       
            )                       
            AND Trd_Del = (Case When S.Pqty = S.Sqty                       
       Then (Case When S.Prate >= S.Srate                       
                  Then (Case When #FOREMBROK.Sell_Buy = 1                      
                             Then 'F'                       
    Else 'S'                      
                 End )                      
           Else                      
                              (Case When ( #FOREMBROK.Sell_Buy = 2 )                       
                                      Then 'F'                      
                             Else 'S'                      
                        End )                           
                   End)                      
                            Else (Case When S.Pqty >= S.Sqty                       
                                              Then (Case When ( #FOREMBROK.Sell_Buy = 1 )                       
                                                         Then 'F'                        
                                                         Else 'S'                      
                                                    End )                      
                                              Else                      
                                                   (Case When ( #FOREMBROK.Sell_Buy = 2 )                       
       Then 'F'                        
                                          Else 'S'                      
                                                    End )                           
                  End )                      
                 End )                       
            AND #FOREMBROK.RemCode = s.RemCode                       
            AND MPrice <= Broktable.upper_lim                       
        )                       
        ELSE                       
        (                       
        SELECT                       
            min(line_no)                       
        FROM #Broktable broktable                       
        WHERE MPrice <= Broktable.upper_lim                       
            AND broktable.table_no = (                       
            CASE                       
  WHEN Left(S.Inst_Type,3) = 'FUT' And #FOREMBROK.AuctionPart = ''                      
  THEN FutTableNo                      
  WHEN Left(S.Inst_Type,3) = 'FUT' And #FOREMBROK.AuctionPart = 'EA'                      
  THEN FutFinalTableNo                       
  WHEN Left(S.Inst_Type,3) = 'OPT' And #FOREMBROK.AuctionPart <> 'EA'                      
  THEN OptTableNo                      
  WHEN Left(S.Inst_Type,3) = 'OPT' And #FOREMBROK.AuctionPart = 'EA'                   
  THEN OptExTableNo                      
            END                       
            )                       
        )                       
    END                       
    )                        
              
Select PARTY_CODE,INST_TYPE,SYMBOL,EXPIRYDATE,STRIKE_PRICE,OPTION_TYPE,AUCTIONPART,              
SAUDA_DATE,TRADE_NO=Pradnya.DBO.ReplaceTradeNo(Trade_No),ORDER_NO,              
SELL_BUY,TRADEQTY=Sum(TRADEQTY),PRICE,Brokerage=Sum(Brokerage),              
REMCODE,BRANCH_CD,REM_Brokerage=Sum(REM_BROKAPPLIED*TradeQty),              
REM_NBROKAPP=0,Status,SLABTYPE,FROMDATE,              
TODATE,MPrice,Multiplier,REMPARTYCD,ExchangeId              
Into #FOREMBROK_1 From #FOREMBROK              
Group By PARTY_CODE,INST_TYPE,SYMBOL,EXPIRYDATE,STRIKE_PRICE,OPTION_TYPE,AUCTIONPART,              
SAUDA_DATE,Pradnya.DBO.ReplaceTradeNo(Trade_No),ORDER_NO,              
SELL_BUY,PRICE,REMCODE,BRANCH_CD,Status,SLABTYPE,FROMDATE,              
TODATE,MPrice,Multiplier,REMPARTYCD,ExchangeId              
              
UPDATE                 
 #FOREMBROK_1                
SET                
 Brokerage = (Case When Sell_Buy =1 then CD_Tot_BuyBrok Else CD_Tot_SellBrok End)              
FROM                
 NSEFO.DBO.CHARGES_DETAIL                
WHERE                
 Convert(Varchar,CD_Sauda_Date,103) = Convert(Varchar,Sauda_Date,103)                
 And CD_Party_Code = #FOREMBROK_1.Party_Code                 
 And CD_Inst_Type = Inst_Type              
 And CD_Symbol = Symbol                
 And Convert(Varchar,CD_Expiry_Date,106) = Convert(Varchar,ExpiryDate,106)                
 And CD_Option_Type = Option_Type                
 And CD_Strike_Price = Strike_Price                
 And CD_Trade_No = Trade_No                
 And CD_Order_No = Order_No               
              
SELECT   REMCODE,                      
         BRANCH_CD,                      
         SLABTYPE,                      
         TURNOVER = SUM(TURNOVER),                  
  NSECMBrok = Sum(NSECMBrok),                  
  BSECMBrok = Sum(BSECMBrok),             
  NSEFOBrok = Sum(NSEFOBrok),                           
   CL_BROKERAGE = SUM(CL_BROKERAGE),                      
   REM_BROKERAGE = SUM(REM_BROKERAGE),                      
   REM_PAYBROKERAGE = SUM(REM_PAYBROKERAGE),                      
   BALANCE_BROKERAGE = SUM(BALANCE_BROKERAGE),                      
   FROMDATE, TODATE,                      
   REMPARTYCD,        
   REM_NSECMBrok  = SUM(CASE WHEN ExchangeId = 'NSECM' THEN REM_PAYBROKERAGE ELSE 0 END),        
   REM_BSECMBrok  = SUM(CASE WHEN ExchangeId = 'BSECM' THEN REM_PAYBROKERAGE ELSE 0 END),        
   REM_NSEFOBrok  = SUM(CASE WHEN ExchangeId = 'NSEFO' THEN REM_PAYBROKERAGE ELSE 0 END)        
        
INTO     #REMBROK_1                       
FROM (        
        
SELECT   REMCODE,                      
         BRANCH_CD,                   
         SLABTYPE,                      
         TURNOVER = SUM(TRADEQTY * MARKETRATE),                   
      NSECMBrok = Sum(Case When ExchangeId = 'NSECM' Then TRADEQTY * NBROKAPP Else 0 End),                  
        BSECMBrok = Sum(Case When ExchangeId = 'BSECM' Then TRADEQTY * NBROKAPP Else 0 End),                   
         NSEFOBrok = 0,                              
         CL_BROKERAGE = SUM(TRADEQTY * NBROKAPP),                      
         REM_BROKERAGE = SUM(TRADEQTY * REM_BROKAPPLIED) + SUM(TRADEQTY * REM_NBROKAPP),                      
         REM_PAYBROKERAGE = (CASE                       
                               WHEN SLABTYPE = 'CUT-OFF-1' THEN (CASE                       
                                WHEN SUM(TRADEQTY * NBROKAPP) > (SUM(TRADEQTY * REM_BROKAPPLIED) + SUM(TRADEQTY * REM_NBROKAPP)) THEN SUM(TRADEQTY * NBROKAPP) - (SUM(TRADEQTY * REM_BROKAPPLIED) + SUM(TRADEQTY * REM_NBROKAPP))                      
                                                                   ELSE 0                      
                                                                 END)                      
                               WHEN SLABTYPE = 'CUT-OFF-2' THEN (CASE                       
                                                                   WHEN SUM(TRADEQTY * NBROKAPP) > (SUM(TRADEQTY * REM_BROKAPPLIED) + SUM(TRADEQTY * REM_NBROKAPP)) THEN SUM(TRADEQTY * REM_BROKAPPLIED) + SUM(TRADEQTY * REM_NBROKAPP)                      
                                                                   ELSE SUM(TRADEQTY * NBROKAPP)                      
                  END)                      
                               ELSE 0                      
                             END),                      
         BALANCE_BROKERAGE = CONVERT(NUMERIC(18,4),0),                      
         FROMDATE,                      
         TODATE,                      
         REMPARTYCD,        
   EXCHANGEID        
FROM     #REMBROK                      
GROUP BY REMCODE,                      
         BRANCH_CD,                      
         SLABTYPE,                      
         FROMDATE,                      
         TODATE,                      
         REMPARTYCD,        
   EXCHANGEID                     
UNION ALL                      
                      
SELECT   REMCODE,                      
         BRANCH_CD,                      
      SLABTYPE,                      
         TURNOVER = SUM(TRADEQTY * PRICE),   
   NSECMBrok = 0,                  
   BSECMBrok = 0,                   
       NSEFOBrok = Sum(Case When ExchangeId = 'NSEFO' Then Brokerage Else 0 End),                       
         CL_BROKERAGE = SUM(Brokerage),                      
         REM_BROKERAGE = SUM(REM_Brokerage),                      
         REM_PAYBROKERAGE = (CASE                       
                               WHEN SLABTYPE = 'CUT-OFF-1' THEN (CASE                       
                                                                   WHEN SUM(Brokerage) > SUM(REM_Brokerage) THEN SUM(Brokerage) - SUM(REM_Brokerage)                      
                                ELSE 0                      
                                                                 END)                      
                               WHEN SLABTYPE = 'CUT-OFF-2' THEN (CASE                       
                                                                   WHEN SUM(Brokerage) > SUM(REM_Brokerage) THEN SUM(REM_Brokerage)                      
                                                                   ELSE SUM(Brokerage)                      
                                                                 END)                      
                               ELSE 0                      
                             END),                      
         BALANCE_BROKERAGE = CONVERT(NUMERIC(18,4),0),                      
         FROMDATE,                      
         TODATE,                      
         REMPARTYCD,        
   ExchangeId                    
FROM     #FOREMBROK_1          
GROUP BY REMCODE,         
         BRANCH_CD,                      
         SLABTYPE,                      
         FROMDATE,                      
         TODATE,         
   REMPARTYCD,        
   ExchangeId) A                      
GROUP BY REMCODE,                      
         BRANCH_CD,                      
         SLABTYPE,                      
  FROMDATE,                      
  TODATE,                      
  REMPARTYCD               
  
  
UPDATE #REMBROK_1                      
SET    BALANCE_BROKERAGE = CL_BROKERAGE - REM_PAYBROKERAGE                      
                      
SELECT   R.REMCODE,                      
         R.BRANCH_CD,                      
         SHARE_PER = Isnull(SHARE_PER,0),                  
  NSECMBrok = Sum(NSECMBrok),                  
  BSECMBrok = Sum(BSECMBrok),                   
  NSEFOBrok = Sum(NSEFOBrok),                      
         CL_BROKERAGE = SUM(CL_BROKERAGE),                      
         REM_PAYBROKERAGE = SUM(REM_PAYBROKERAGE) + SUM(BALANCE_BROKERAGE) * (CASE                       
                                                                                WHEN Isnull(SHARE_PER,0) > 0 THEN Isnull(SHARE_PER,0) / 100                      
                                       ELSE 0                      
                                                                              END),                      
         BALANCE_BROKERAGE = SUM(BALANCE_BROKERAGE) - SUM(BALANCE_BROKERAGE) * (CASE                       
                  WHEN Isnull(SHARE_PER,0) > 0 THEN Isnull(SHARE_PER,0) / 100                      
                                                                                  ELSE 0                      
                                                                                END),                      
         REMTYPE = Isnull(S.REMTYPE,'SUB'),                      
         FROMDATE,                      
         TODATE,                      
         REMPARTYCD = ISNULL(S.REMPARTYCD, R.REMPARTYCD),                
      SLABTYPE = IsNull(S.SLABTYPE,R.SLABTYPE),        
   REM_NSECMBrok = SUM(CASE WHEN S.SLABTYPE IS NULL THEN REM_NSECMBrok ELSE 0 END),        
   REM_BSECMBrok = SUM(CASE WHEN S.SLABTYPE IS NULL THEN REM_BSECMBrok ELSE 0 END),        
   REM_NSEFOBrok = SUM(CASE WHEN S.SLABTYPE IS NULL THEN REM_NSEFOBrok ELSE 0 END)        
INTO     #REMBROK_2                      
FROM     #REMBROK_1 R        
         LEFT OUTER JOIN REM_BRANCH_SHARE_MASTER S                      
           ON (R.REMCODE = S.REMCODE                      
               AND FROMDATE >= FROM_DATE                      
               AND TODATE <= TO_DATE                      
               AND S.SLABTYPE = 'FLAT'                      
               AND REMTYPE = 'SUB')                      
GROUP BY R.REMCODE,                      
         R.BRANCH_CD,                      
         SHARE_PER,                      
         LOWER_LIMIT,                      
         UPPER_LIMIT,                      
         S.REMTYPE,                      
         FROMDATE,                      
         TODATE,                      
         ISNULL(S.REMPARTYCD, R.REMPARTYCD),                
      IsNull(S.SLABTYPE,R.SLABTYPE)        
                      
HAVING   SUM(BALANCE_BROKERAGE) BETWEEN Isnull(LOWER_LIMIT,0)                      
                                        AND Isnull(UPPER_LIMIT,9999999999)                      
  
DECLARE  @REMCUR               CURSOR,                      
         @REMCODE              VARCHAR(10),                      
         @CUR_REMCODE          VARCHAR(10),                      
         @BRANCH_CD            VARCHAR(10),                      
         @CUR_BRANCH_CD        VARCHAR(10),                      
   @REM_PARTYCODE        VARCHAR(10),                      
   @CUR_REM_PARTYCODE    VARCHAR(10),                      
         @SHARE_PER            NUMERIC(18,4),                      
   @BALANCE_BROKERAGE    NUMERIC(18,4),                      
         @REM_BROKERAGE        NUMERIC(18,4),                      
         @CURBALANCE_BROKERAGE NUMERIC(18,4),                      
         @REMTYPE              VARCHAR(10),                      
         @LOWER_LIMIT          NUMERIC(18,4),                      
         @UPPER_LIMIT          NUMERIC(18,4)                      
                      
SET @REMCUR = CURSOR FOR SELECT R.REMCODE,                      
                                R.BRANCH_CD,                      
                SHARE_PER = Isnull(S.SHARE_PER,0),                      
                                BALANCE_BROKERAGE,                      
                                REMTYPE = Isnull(R.REMTYPE,'SUB'),                      
                                LOWER_LIMIT = Isnull(LOWER_LIMIT,0),                      
                                UPPER_LIMIT = Isnull(UPPER_LIMIT,9999999999),                      
                   REMPARTYCD = ISNULL(S.REMPARTYCD,R.REMPARTYCD)                      
                         FROM   #REMBROK_2 R                      
                                LEFT OUTER JOIN REM_BRANCH_SHARE_MASTER S                      
                                  ON (R.REMCODE = S.REMCODE                      
                                      AND FROMDATE >= FROM_DATE                      
                                      AND TODATE <= TO_DATE                      
                                      AND S.SLABTYPE = 'INCR'                  
                                      AND S.REMTYPE = R.REMTYPE)                      
                         WHERE  R.REMTYPE = 'SUB'      
       ORDER BY R.BRANCH_CD, R.REMCODE, LOWER_LIMIT      
                      
OPEN @REMCUR                      
                      
FETCH NEXT FROM @REMCUR         
INTO @REMCODE,                      
     @BRANCH_CD,                      
     @SHARE_PER,                      
     @BALANCE_BROKERAGE,                      
     @REMTYPE,                      
     @LOWER_LIMIT,                      
     @UPPER_LIMIT,                      
  @REM_PARTYCODE                      
                      
WHILE @@FETCH_STATUS = 0                      
  BEGIN                       
  --SELECT @BRANCH_CD, @SHARE_PER, @BALANCE_BROKERAGE, @REMTYPE, @FROMDATE, @TODATE, @LOWER_LIMIT, @UPPER_LIMIT                      
    SET @CUR_BRANCH_CD = @BRANCH_CD                      
    SET @CUR_REMCODE = @REMCODE                 
 SET @CUR_REM_PARTYCODE = @REM_PARTYCODE                      
    SET @REM_BROKERAGE = 0                      
    SET @CURBALANCE_BROKERAGE = @BALANCE_BROKERAGE                      
    IF @BALANCE_BROKERAGE > 0                      
       AND @SHARE_PER > 0                      
      BEGIN                      
        WHILE @CUR_REMCODE = @REMCODE                      
              AND @CUR_BRANCH_CD = @BRANCH_CD                      
              AND @@FETCH_STATUS = 0                      
          BEGIN                      
            IF @CUR_REMCODE = @REMCODE                      
               AND @CUR_BRANCH_CD = @BRANCH_CD                      
               AND @BALANCE_BROKERAGE > 0                      
               AND @CURBALANCE_BROKERAGE > 0                      
               AND @SHARE_PER > 0                      
               AND @@FETCH_STATUS = 0                      
              BEGIN                      
                IF @BALANCE_BROKERAGE >= @UPPER_LIMIT                      
                  BEGIN                      
                    SET @REM_BROKERAGE = @REM_BROKERAGE + ((@UPPER_LIMIT - @LOWER_LIMIT) * @SHARE_PER / 100)                      
                    SET @CURBALANCE_BROKERAGE = @CURBALANCE_BROKERAGE - (@UPPER_LIMIT - @LOWER_LIMIT)                      
                    IF @CURBALANCE_BROKERAGE < 0                      
                      SET @CURBALANCE_BROKERAGE = 0                      
                  END                      
                ELSE                      
                  BEGIN                      
                    SET @REM_BROKERAGE = @REM_BROKERAGE + @CURBALANCE_BROKERAGE * @SHARE_PER / 100                      
                    SET @CURBALANCE_BROKERAGE = 0                     
                    SET @BALANCE_BROKERAGE = 0             
                  END                      
              END                      
              --SELECT @REMCODE, @BRANCH_CD, @SHARE_PER, @CURBALANCE_BROKERAGE, @BALANCE_BROKERAGE, @REMTYPE, @FROMDATE, @TODATE, @LOWER_LIMIT, @UPPER_LIMIT, @REM_BROKERAGE                      
            FETCH NEXT FROM @REMCUR                      
            INTO @REMCODE,                      
                 @BRANCH_CD,                      
                 @SHARE_PER,                      
                 @BALANCE_BROKERAGE,                      
                 @REMTYPE,                      
                 @LOWER_LIMIT,                      
                 @UPPER_LIMIT,                      
        @REM_PARTYCODE                      
          END                      
        UPDATE #REMBROK_2                      
        SET    REM_PAYBROKERAGE = @REM_BROKERAGE,                      
               BALANCE_BROKERAGE = BALANCE_BROKERAGE - @REM_BROKERAGE,                      
           REMPARTYCD = @CUR_REM_PARTYCODE, SlabType = 'INCR'                      
        WHERE  REMCODE = @CUR_REMCODE                      
               AND BRANCH_CD = @CUR_BRANCH_CD                      
               AND REMTYPE = 'SUB'                      
      END                      
    ELSE                      
      BEGIN                      
      --SELECT @REMCODE, @BRANCH_CD, @SHARE_PER, @CURBALANCE_BROKERAGE, @BALANCE_BROKERAGE, @REMTYPE, @FROMDATE, @TODATE, @LOWER_LIMIT, @UPPER_LIMIT, @REM_BROKERAGE                      
        FETCH NEXT FROM @REMCUR                      
        INTO @REMCODE,                      
             @BRANCH_CD,                      
             @SHARE_PER,                      
             @BALANCE_BROKERAGE,                      
             @REMTYPE,                 
             @LOWER_LIMIT,                      
             @UPPER_LIMIT,                      
    @REM_PARTYCODE                       
      END                      
  END                      
                      
INSERT INTO #REMBROK_2                      
SELECT   REMCODE = '',                      
  R.BRANCH_CD,         
  SHARE_PER = Isnull(S.SHARE_PER,0),                  
  NSECMBrok = Sum(NSECMBrok),                  
  BSECMBrok = Sum(BSECMBrok),                   
  NSEFOBrok = Sum(NSEFOBrok),                       
         CL_BROKERAGE = SUM(CL_BROKERAGE),                      
         REM_PAYBROKERAGE = SUM(BALANCE_BROKERAGE) * (CASE                       
                                                        WHEN Isnull(S.SHARE_PER,0) > 0 THEN Isnull(S.SHARE_PER,0) / 100                      
                                                        ELSE 0                      
                                                      END),                      
         BALANCE_BROKERAGE = SUM(BALANCE_BROKERAGE) - SUM(BALANCE_BROKERAGE) * (CASE                       
                                                                                  WHEN Isnull(S.SHARE_PER,0) > 0 THEN Isnull(S.SHARE_PER,0) / 100                      
                                                                                  ELSE 0                      
    		END),                      
         REMTYPE = Isnull(S.REMTYPE,'BR'),                      
         FROMDATE,                      
         TODATE,                      
    REMPARTYCD = ISNULL(S.REMPARTYCD,R.REMPARTYCD),                
  SlabType=IsNull(S.SLABTYPE,R.SLABTYPE),        
 REM_NSECMBrok = 0,        
 REM_BSECMBrok = 0,        
 REM_NSEFOBrok = 0       
        
FROM     #REMBROK_2 R                      
         LEFT OUTER JOIN REM_BRANCH_SHARE_MASTER S                      
           ON (R.BRANCH_CD = S.REMCODE                      
               AND FROMDATE >= FROM_DATE                      
   AND TODATE <= TO_DATE                      
               AND S.SLABTYPE = 'FLAT'                      
               AND S.REMTYPE = 'BR')                      
GROUP BY R.BRANCH_CD,                      
         S.SHARE_PER,                      
         LOWER_LIMIT,                      
         UPPER_LIMIT,                      
 S.REMTYPE,                      
         FROMDATE,                      
         TODATE,                      
      ISNULL(S.REMPARTYCD,R.REMPARTYCD),                
   IsNull(S.SLABTYPE,R.SLABTYPE)                      
HAVING   SUM(BALANCE_BROKERAGE) BETWEEN Isnull(LOWER_LIMIT,0)                      
                                        AND Isnull(UPPER_LIMIT,9999999999)                      
                      
SET @REMCUR = CURSOR FOR SELECT R.BRANCH_CD,                      
                                SHARE_PER = Isnull(S.SHARE_PER,0),                      
                                BALANCE_BROKERAGE,                  
                                REMTYPE = Isnull(R.REMTYPE,'BR'),                      
                                LOWER_LIMIT = Isnull(LOWER_LIMIT,0),                      
                                UPPER_LIMIT = Isnull(UPPER_LIMIT,9999999999),                      
              REMPARTYCD = ISNULL(S.REMPARTYCD,R.REMPARTYCD)                      
                         FROM   #REMBROK_2 R                      
                                LEFT OUTER JOIN REM_BRANCH_SHARE_MASTER S                      
                                  ON (R.BRANCH_CD = S.REMCODE                      
                                      AND FROMDATE >= FROM_DATE                      
                                      AND TODATE <= TO_DATE                      
                                      AND S.SLABTYPE = 'INCR'                      
                                      AND S.REMTYPE = R.REMTYPE)                      
                         WHERE ISNULL(S.REMTYPE,'') = 'BR'      
       ORDER BY R.BRANCH_CD, LOWER_LIMIT      
OPEN @REMCUR                      
           
FETCH NEXT FROM @REMCUR                      
INTO @BRANCH_CD,                      
     @SHARE_PER,                      
     @BALANCE_BROKERAGE,                      
     @REMTYPE,                      
     @LOWER_LIMIT,                      
     @UPPER_LIMIT,                  
  @REM_PARTYCODE                      
                      
WHILE @@FETCH_STATUS = 0          BEGIN                       
  --SELECT @BRANCH_CD, @SHARE_PER, @BALANCE_BROKERAGE, @REMTYPE, @FROMDATE, @TODATE, @LOWER_LIMIT, @UPPER_LIMIT                      
    SET @CUR_BRANCH_CD = @BRANCH_CD                      
 SET @CUR_REM_PARTYCODE = @REM_PARTYCODE                      
    SET @REM_BROKERAGE = 0                      
    SET @CURBALANCE_BROKERAGE = @BALANCE_BROKERAGE                      
    IF @BALANCE_BROKERAGE > 0                      
       AND @SHARE_PER > 0                      
      BEGIN                      
        WHILE @CUR_BRANCH_CD = @BRANCH_CD                      
              AND @@FETCH_STATUS = 0                      
          BEGIN                      
            IF @CUR_BRANCH_CD = @BRANCH_CD                      
               AND @BALANCE_BROKERAGE > 0                      
               AND @CURBALANCE_BROKERAGE > 0                      
               AND @SHARE_PER > 0                      
               AND @@FETCH_STATUS = 0                      
              BEGIN                      
IF @BALANCE_BROKERAGE >= @UPPER_LIMIT                      
                  BEGIN                      
                    SET @REM_BROKERAGE = @REM_BROKERAGE + ((@UPPER_LIMIT - @LOWER_LIMIT) * @SHARE_PER / 100)                      
                    SET @CURBALANCE_BROKERAGE = @CURBALANCE_BROKERAGE - (@UPPER_LIMIT - @LOWER_LIMIT)                      
                    IF @CURBALANCE_BROKERAGE < 0                      
                      SET @CURBALANCE_BROKERAGE = 0                      
                  END                      
                ELSE                      
                  BEGIN                      
                    SET @REM_BROKERAGE = @REM_BROKERAGE + @CURBALANCE_BROKERAGE * @SHARE_PER / 100                      
                    SET @CURBALANCE_BROKERAGE = 0                      
                    SET @BALANCE_BROKERAGE = 0                      
                  END                      
END                      
              --SELECT @BRANCH_CD, @SHARE_PER, @CURBALANCE_BROKERAGE, @BALANCE_BROKERAGE, @REMTYPE, @FROMDATE, @TODATE, @LOWER_LIMIT, @UPPER_LIMIT, @REM_BROKERAGE                      
            FETCH NEXT FROM @REMCUR                      
            INTO @BRANCH_CD,                      
                 @SHARE_PER,                      
                 @BALANCE_BROKERAGE,                      
                 @REMTYPE,                      
                 @LOWER_LIMIT,                      
                @UPPER_LIMIT,                      
     @REM_PARTYCODE                      
          END                      
        UPDATE #REMBROK_2                      
        SET    REM_PAYBROKERAGE = @REM_BROKERAGE,                      
               BALANCE_BROKERAGE = BALANCE_BROKERAGE - @REM_BROKERAGE,                      
      REMPARTYCD = @CUR_REM_PARTYCODE, SlabType = 'INCR'                      
        WHERE  BRANCH_CD = @CUR_BRANCH_CD                      
               AND REMTYPE = 'BR'                      
      END                      
    ELSE                      
      BEGIN                      
      --SELECT @BRANCH_CD, @SHARE_PER, @CURBALANCE_BROKERAGE, @BALANCE_BROKERAGE, @REMTYPE, @FROMDATE, @TODATE, @LOWER_LIMIT, @UPPER_LIMIT, @REM_BROKERAGE                      
        FETCH NEXT FROM @REMCUR                      
        INTO @BRANCH_CD,                      
             @SHARE_PER,                      
             @BALANCE_BROKERAGE,                      
             @REMTYPE,                      
             @LOWER_LIMIT,                      
             @UPPER_LIMIT,                      
       @REM_PARTYCODE                      
      END                      
  END                      

Update #REMBROK_2 set Rem_NSECMBrok = NSECMBrok*Rem_PayBrokerage/(NSECMBrok+BSECMBrok+NSEFOBrok),
Rem_BSECMBrok = BSECMBrok*Rem_PayBrokerage/(NSECMBrok+BSECMBrok+NSEFOBrok),
Rem_NSEFOBrok = NSEFoBrok*Rem_PayBrokerage/(NSECMBrok+BSECMBrok+NSEFOBrok)
Where SlabType in ('INCR', 'FLAT')
                  
DELETE FROM REM_Brok_Trans WHERE SETT_NO = @SETT_NO AND SETT_TYPE = @SETT_TYPE                      
                  
Insert Into REM_Brok_Trans                  
Select SETT_NO = @SETT_NO, SETT_TYPE = @SETT_TYPE, *,   
Rem_NSECMTds = Rem_NSECMBrok * 5.61 / 100,  
Rem_BSECMTds = Rem_BSECMBrok * 5.61 / 100,  
Rem_NSEFOTds = Rem_NSEFOBrok * 5.61 / 100  
FROM #REMBROK_2 WHERE REM_PAYBROKERAGE > 0           
                  
DELETE FROM REM_ACCBILL WHERE SETT_NO = @SETT_NO AND SETT_TYPE = @SETT_TYPE                      
                      
INSERT INTO REM_ACCBILL                      
SELECT REMPARTYCD, BILLNO = 0, SELL_BUY = 2, SETT_NO = @SETT_NO, SETT_TYPE = @SETT_TYPE,                      
       Start_Date = @FROMDATE, End_Date = @TODATE + ' 23:59', Payin_Date = @Funds_Payin,                       
       Payout_Date = @Funds_Payout + ' 23:59', Rem_NSECMBrok, BRANCH_CD, Narration = @REMBROKNARR,  
       Exchange = 'NSE', Segment = 'CAPITAL'                      
FROM REM_Brok_Trans WHERE SETT_NO = @SETT_NO AND SETT_TYPE = @SETT_TYPE AND Rem_NSECMBrok > 0                      
                      
INSERT INTO REM_ACCBILL                      
SELECT ACCODE, BILLNO = 0, SELL_BUY = 1, SETT_NO = @SETT_NO, SETT_TYPE = @SETT_TYPE,                      
       Start_Date = @FROMDATE, End_Date = @TODATE + ' 23:59', Payin_Date = @Funds_Payin,                       
       Payout_Date = @Funds_Payout + ' 23:59',                       
       REM_PAYBROKERAGE = IsNull(SUM(Rem_NSECMBrok),0), BRANCH_CD, Narration = @REMBROKNARR,  
 Exchange = 'NSE', Segment = 'CAPITAL'                      
FROM REM_Brok_Trans, VALANACCOUNT WHERE SETT_NO = @SETT_NO AND SETT_TYPE = @SETT_TYPE AND Rem_NSECMBrok > 0 AND ACNAME = 'NSECM REMISSOR SHARING'                     
GROUP BY BRANCH_CD, ACCODE  
Having IsNull(SUM(Rem_NSECMBrok),0) > 0  
                      
INSERT INTO REM_ACCBILL             
SELECT ACCODE, BILLNO = 0, SELL_BUY = 1, SETT_NO = @SETT_NO, SETT_TYPE = @SETT_TYPE,                      
       Start_Date = @FROMDATE, End_Date = @TODATE + ' 23:59', Payin_Date = @Funds_Payin,                       
       Payout_Date = @Funds_Payout + ' 23:59',                       
       REM_PAYBROKERAGE = IsNull(SUM(Rem_NSECMBrok),0), BRANCH_CD = 'ZZZ', Narration = @REMBROKNARR,  
       Exchange = 'NSE', Segment = 'CAPITAL'                      
FROM REM_Brok_Trans, VALANACCOUNT WHERE SETT_NO = @SETT_NO AND SETT_TYPE = @SETT_TYPE AND Rem_NSECMBrok > 0 AND ACNAME = 'NSECM REMISSOR SHARING'  
GROUP BY ACCODE  
Having IsNull(SUM(Rem_NSECMBrok),0) > 0  
  
INSERT INTO REM_ACCBILL                      
SELECT REMPARTYCD, BILLNO = 0, SELL_BUY = 1, SETT_NO = @SETT_NO, SETT_TYPE = @SETT_TYPE,                      
       Start_Date = @FROMDATE, End_Date = @TODATE + ' 23:59', Payin_Date = @Funds_Payin,                       
       Payout_Date = @Funds_Payout + ' 23:59', Rem_NSECMTDS, BRANCH_CD, Narration = @REMTDSNARR,  
       Exchange = 'NSE', Segment = 'CAPITAL'                      
FROM REM_Brok_Trans WHERE SETT_NO = @SETT_NO AND SETT_TYPE = @SETT_TYPE AND Rem_NSECMTDS > 0                      
                      
INSERT INTO REM_ACCBILL                      
SELECT ACCODE, BILLNO = 0, SELL_BUY = 2, SETT_NO = @SETT_NO, SETT_TYPE = @SETT_TYPE,                      
       Start_Date = @FROMDATE, End_Date = @TODATE + ' 23:59', Payin_Date = @Funds_Payin,                       
       Payout_Date = @Funds_Payout + ' 23:59',                       
       REM_PAYBROKERAGE = IsNull(SUM(Rem_NSECMTDS),0), BRANCH_CD, Narration = @REMTDSNARR,  
 Exchange = 'NSE', Segment = 'CAPITAL'                      
FROM REM_Brok_Trans, VALANACCOUNT WHERE SETT_NO = @SETT_NO AND SETT_TYPE = @SETT_TYPE AND Rem_NSECMTDS > 0 AND ACNAME = 'NSECM TDS AMOUNT'                     
GROUP BY BRANCH_CD, ACCODE                  
Having IsNull(SUM(Rem_NSECMTDS),0) > 0  
                      
INSERT INTO REM_ACCBILL             
SELECT ACCODE, BILLNO = 0, SELL_BUY = 2, SETT_NO = @SETT_NO, SETT_TYPE = @SETT_TYPE,                      
       Start_Date = @FROMDATE, End_Date = @TODATE + ' 23:59', Payin_Date = @Funds_Payin,                       
       Payout_Date = @Funds_Payout + ' 23:59',                       
       REM_PAYBROKERAGE = IsNull(SUM(Rem_NSECMTDS),0), BRANCH_CD = 'ZZZ', Narration = @REMTDSNARR,  
       Exchange = 'NSE', Segment = 'CAPITAL'                      
FROM REM_Brok_Trans, VALANACCOUNT WHERE SETT_NO = @SETT_NO AND SETT_TYPE = @SETT_TYPE AND Rem_NSECMTDS > 0 AND ACNAME = 'NSECM TDS AMOUNT'  
GROUP BY ACCODE  
Having IsNull(SUM(Rem_NSECMTDS),0) > 0  
  
INSERT INTO REM_ACCBILL                      
SELECT REMPARTYCD, BILLNO = 0, SELL_BUY = 2, SETT_NO = @SETT_NO, SETT_TYPE = @SETT_TYPE,                      
       Start_Date = @FROMDATE, End_Date = @TODATE + ' 23:59', Payin_Date = @Funds_Payin,                       
       Payout_Date = @Funds_Payout + ' 23:59', Rem_BSECMBrok, BRANCH_CD, Narration = @REMBROKNARR,  
       Exchange = 'BSE', Segment = 'CAPITAL'                      
FROM REM_Brok_Trans WHERE SETT_NO = @SETT_NO AND SETT_TYPE = @SETT_TYPE AND Rem_BSECMBrok > 0                      
                      
INSERT INTO REM_ACCBILL                      
SELECT ACCODE, BILLNO = 0, SELL_BUY = 1, SETT_NO = @SETT_NO, SETT_TYPE = @SETT_TYPE,                      
       Start_Date = @FROMDATE, End_Date = @TODATE + ' 23:59', Payin_Date = @Funds_Payin,                       
       Payout_Date = @Funds_Payout + ' 23:59',                       
       REM_PAYBROKERAGE = IsNull(SUM(Rem_BSECMBrok),0), BRANCH_CD, Narration = @REMBROKNARR,  
 Exchange = 'BSE', Segment = 'CAPITAL'                      
FROM REM_Brok_Trans, VALANACCOUNT WHERE SETT_NO = @SETT_NO AND SETT_TYPE = @SETT_TYPE AND Rem_BSECMBrok > 0 AND ACNAME = 'BSECM REMISSOR SHARING'                    
GROUP BY BRANCH_CD, ACCODE                      
Having IsNull(SUM(Rem_BSECMBrok),0) > 0                       
                      
INSERT INTO REM_ACCBILL             
SELECT ACCODE, BILLNO = 0, SELL_BUY = 1, SETT_NO = @SETT_NO, SETT_TYPE = @SETT_TYPE,                      
       Start_Date = @FROMDATE, End_Date = @TODATE + ' 23:59', Payin_Date = @Funds_Payin,                       
       Payout_Date = @Funds_Payout + ' 23:59',                       
       REM_PAYBROKERAGE = IsNull(SUM(Rem_BSECMBrok),0), BRANCH_CD = 'ZZZ', Narration = @REMBROKNARR,  
       Exchange = 'BSE', Segment = 'CAPITAL'                      
FROM REM_Brok_Trans, VALANACCOUNT WHERE SETT_NO = @SETT_NO AND SETT_TYPE = @SETT_TYPE AND Rem_BSECMBrok > 0 AND ACNAME = 'BSECM REMISSOR SHARING'  
GROUP BY ACCODE  
Having IsNull(SUM(Rem_BSECMBrok),0) > 0  
  
INSERT INTO REM_ACCBILL                      
SELECT REMPARTYCD, BILLNO = 0, SELL_BUY = 1, SETT_NO = @SETT_NO, SETT_TYPE = @SETT_TYPE,                      
       Start_Date = @FROMDATE, End_Date = @TODATE + ' 23:59', Payin_Date = @Funds_Payin,                       
       Payout_Date = @Funds_Payout + ' 23:59', Rem_BSECMTDS, BRANCH_CD, Narration = @REMTDSNARR,  
       Exchange = 'BSE', Segment = 'CAPITAL'                      
FROM REM_Brok_Trans WHERE SETT_NO = @SETT_NO AND SETT_TYPE = @SETT_TYPE AND Rem_BSECMTDS > 0                      
                      
INSERT INTO REM_ACCBILL                      
SELECT ACCODE, BILLNO = 0, SELL_BUY = 2, SETT_NO = @SETT_NO, SETT_TYPE = @SETT_TYPE,                      
       Start_Date = @FROMDATE, End_Date = @TODATE + ' 23:59', Payin_Date = @Funds_Payin,                       
       Payout_Date = @Funds_Payout + ' 23:59',                       
       REM_PAYBROKERAGE = IsNull(SUM(Rem_BSECMTDS),0), BRANCH_CD, Narration = @REMTDSNARR,  
 Exchange = 'BSE', Segment = 'CAPITAL'                      
FROM REM_Brok_Trans, VALANACCOUNT WHERE SETT_NO = @SETT_NO AND SETT_TYPE = @SETT_TYPE AND Rem_BSECMTDS > 0 AND ACNAME = 'BSECM TDS AMOUNT'                     
GROUP BY BRANCH_CD, ACCODE                      
Having IsNull(SUM(Rem_BSECMTDS),0) > 0  
                      
INSERT INTO REM_ACCBILL             
SELECT ACCODE, BILLNO = 0, SELL_BUY = 2, SETT_NO = @SETT_NO, SETT_TYPE = @SETT_TYPE,                      
       Start_Date = @FROMDATE, End_Date = @TODATE + ' 23:59', Payin_Date = @Funds_Payin,                       
       Payout_Date = @Funds_Payout + ' 23:59',                       
       REM_PAYBROKERAGE = IsNull(SUM(Rem_BSECMTDS),0), BRANCH_CD = 'ZZZ', Narration = @REMTDSNARR,  
       Exchange = 'BSE', Segment = 'CAPITAL'                      
FROM REM_Brok_Trans, VALANACCOUNT WHERE SETT_NO = @SETT_NO AND SETT_TYPE = @SETT_TYPE AND Rem_BSECMTDS > 0 AND ACNAME = 'BSECM TDS AMOUNT'  
GROUP BY ACCODE  
Having IsNull(SUM(Rem_BSECMTDS),0) > 0  
  
INSERT INTO REM_ACCBILL                      
SELECT REMPARTYCD, BILLNO = 0, SELL_BUY = 2, SETT_NO = @SETT_NO, SETT_TYPE = @SETT_TYPE,                      
       Start_Date = @FROMDATE, End_Date = @TODATE + ' 23:59', Payin_Date = @Funds_Payin,                       
       Payout_Date = @Funds_Payout + ' 23:59', Rem_NSEFOBrok, BRANCH_CD, Narration = @REMBROKNARR,  
       Exchange = 'NSE', Segment = 'FUTURES'                      
FROM REM_Brok_Trans WHERE SETT_NO = @SETT_NO AND SETT_TYPE = @SETT_TYPE AND Rem_NSEFOBrok > 0                      
                      
INSERT INTO REM_ACCBILL                      
SELECT ACCODE, BILLNO = 0, SELL_BUY = 1, SETT_NO = @SETT_NO, SETT_TYPE = @SETT_TYPE,                      
       Start_Date = @FROMDATE, End_Date = @TODATE + ' 23:59', Payin_Date = @Funds_Payin,                       
       Payout_Date = @Funds_Payout + ' 23:59',                       
       REM_PAYBROKERAGE = IsNull(SUM(Rem_NSEFOBrok),0), BRANCH_CD, Narration = @REMBROKNARR,  
 Exchange = 'NSE', Segment = 'FUTURES'                      
FROM REM_Brok_Trans, VALANACCOUNT WHERE SETT_NO = @SETT_NO AND SETT_TYPE = @SETT_TYPE AND Rem_NSEFOBrok > 0 AND ACNAME = 'NSEFO REMISSOR SHARING'               
GROUP BY BRANCH_CD, ACCODE                      
Having IsNull(SUM(Rem_NSEFOBrok),0) > 0                       
  
INSERT INTO REM_ACCBILL             
SELECT ACCODE, BILLNO = 0, SELL_BUY = 1, SETT_NO = @SETT_NO, SETT_TYPE = @SETT_TYPE,                      
       Start_Date = @FROMDATE, End_Date = @TODATE + ' 23:59', Payin_Date = @Funds_Payin,                       
       Payout_Date = @Funds_Payout + ' 23:59',                       
       REM_PAYBROKERAGE = IsNull(SUM(Rem_NSEFOBrok),0), BRANCH_CD = 'ZZZ', Narration = @REMBROKNARR,  
       Exchange = 'NSE', Segment = 'FUTURES'                      
FROM REM_Brok_Trans, VALANACCOUNT WHERE SETT_NO = @SETT_NO AND SETT_TYPE = @SETT_TYPE AND Rem_NSEFOBrok > 0 AND ACNAME = 'NSEFO REMISSOR SHARING'  
GROUP BY ACCODE  
Having IsNull(SUM(Rem_NSEFOBrok),0) > 0  
                      
INSERT INTO REM_ACCBILL                      
SELECT REMPARTYCD, BILLNO = 0, SELL_BUY = 1, SETT_NO = @SETT_NO, SETT_TYPE = @SETT_TYPE,                      
       Start_Date = @FROMDATE, End_Date = @TODATE + ' 23:59', Payin_Date = @Funds_Payin,                       
       Payout_Date = @Funds_Payout + ' 23:59', Rem_NSEFOTDS, BRANCH_CD, Narration = @REMTDSNARR,  
       Exchange = 'NSE', Segment = 'FUTURES'                      
FROM REM_Brok_Trans WHERE SETT_NO = @SETT_NO AND SETT_TYPE = @SETT_TYPE AND Rem_NSEFOTDS > 0                      
                      
INSERT INTO REM_ACCBILL                      
SELECT ACCODE, BILLNO = 0, SELL_BUY = 2, SETT_NO = @SETT_NO, SETT_TYPE = @SETT_TYPE,                      
       Start_Date = @FROMDATE, End_Date = @TODATE + ' 23:59', Payin_Date = @Funds_Payin,                       
       Payout_Date = @Funds_Payout + ' 23:59',                       
       REM_PAYBROKERAGE = IsNull(SUM(Rem_NSEFOTDS),0), BRANCH_CD, Narration = @REMTDSNARR,  
 Exchange = 'NSE', Segment = 'FUTURES'                      
FROM REM_Brok_Trans, VALANACCOUNT WHERE SETT_NO = @SETT_NO AND SETT_TYPE = @SETT_TYPE AND Rem_NSEFOTDS > 0 AND ACNAME = 'NSEFO TDS AMOUNT'                     
GROUP BY BRANCH_CD, ACCODE                      
Having IsNull(SUM(Rem_NSEFOTDS),0) > 0  
                      
INSERT INTO REM_ACCBILL             
SELECT ACCODE, BILLNO = 0, SELL_BUY = 2, SETT_NO = @SETT_NO, SETT_TYPE = @SETT_TYPE,                      
       Start_Date = @FROMDATE, End_Date = @TODATE + ' 23:59', Payin_Date = @Funds_Payin,                       
       Payout_Date = @Funds_Payout + ' 23:59',                       
       REM_PAYBROKERAGE = IsNull(SUM(Rem_NSEFOTDS),0), BRANCH_CD = 'ZZZ', Narration = @REMTDSNARR,  
       Exchange = 'NSE', Segment = 'FUTURES'                      
FROM REM_Brok_Trans, VALANACCOUNT WHERE SETT_NO = @SETT_NO AND SETT_TYPE = @SETT_TYPE AND Rem_NSEFOTDS > 0 AND ACNAME = 'NSEFO TDS AMOUNT'  
GROUP BY ACCODE  
Having IsNull(SUM(Rem_NSEFOTDS),0) > 0  
  
DROP TABLE #REMBROK                       
                      
DROP TABLE #REMBROK_1                       
                      
DROP TABLE #REMBROK_2                       
                      
DROP TABLE #FOREMBROK

GO
