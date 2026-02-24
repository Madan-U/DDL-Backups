-- Object: PROCEDURE dbo.PROC_PNLPROCESS_TEST
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE PROC [DBO].[PROC_PNLPROCESS_TEST]                                          
(                                                                      
 @SAUDA_DATE VARCHAR(11),                                                                       
 @FROMPARTY  VARCHAR(10),                                                                      
 @TOPARTY    VARCHAR(10)                                                                      
)                                                                      
AS                                                                  
                                                                      
DECLARE                                                                                                      
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
                                      
/*                                                                      
DELETE FROM TBL_PNL_DATA                                                                      
WHERE MARGINDATE = @SAUDA_DATE                                                                      
AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY                                                                      
*/                                                
                                                    
DELETE FROM TBL_PNL_DATA_ORG                                                          
WHERE SAUDA_DATE >= @SAUDA_DATE                                                                   
AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY                                                                      
                                            
UPDATE TBL_PNL_DATA_ORG SET BILLFLAG = (CASE WHEN SELL_BUY = 1 THEN 4 ELSE 5 END),                                                                      
MARGINDATE = LEFT(SAUDA_DATE, 11),OPPDATE='DEC 31 2049'                                                                      
WHERE MARGINDATE >= @SAUDA_DATE                                                                      
AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY                                                                      
                         
TRUNCATE TABLE TBL_PNL_DATA_TMP        
    
---- NSECM ----                                         
                                                                      
INSERT INTO TBL_PNL_DATA_TMP                                                   
SELECT EXCHANGE,MARGINDATE=@SAUDA_DATE,TRADETYPE='BF',SETT_NO,SETT_TYPE,PARTY_CODE,SCRIP_CD,SERIES,                                                                
BSECODE,ISIN,USER_ID,CONTRACTNO,ORDER_NO,TRADE_NO,SAUDA_DATE,TRADEQTY,MARKETRATE,                                                                   
PNLRATE,MARKETTYPE,SELL_BUY,INS_CHRG,TURN_TAX,OTHER_CHRG,SEBI_TAX,BROKER_CHRG,                                                          
BILLFLAG,NBROKAPP,NSERTAX,N_NETRATE,OPPDATE='DEC 31 2049', ORGDATE, SNO, 0, RECTYPE = 'OPEN'                                                                
FROM TBL_PNL_DATA_ORG                                                                      
WHERE /*MARGINDATE = @PREVDATE                                                         
AND*/PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY                                                                      
AND BILLFLAG = 4                                                
                                                              
INSERT INTO TBL_PNL_DATA_TMP                                                                      
   SELECT EXCHANGE,                                                                   
         MARGINDATE = @SAUDA_DATE,                                                                                
         TRADETYPE='BT',                                                                    
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
         TRADEQTY,                                                         
         MARKETRATE,                                                                      
         PNLRATE,                                                           
         MARKETTYPE,                                                                                
         SELL_BUY,                                                                                
         INS_CHRG,                     
         TURN_TAX,                                                                                
         OTHER_CHRG,                                       
         SEBI_TAX,                                                                                
         BROKER_CHRG,                                                   
         BILLFLAG=(CASE WHEN BILLFLAG = 1 THEN SELL_BUY + 3 ELSE BILLFLAG END),                                                                                
         NBROKAPP,                                            
         NSERTAX,                                                                                
         N_NETRATE,                                                                  
		 OPPDATE=(CASE WHEN LEFT(OPPDATE,11) = LEFT(SAUDA_DATE,11) THEN LEFT(SAUDA_DATE,11) ELSE 'DEC 31 2049' END),                                                      
		 ORGDATE=LEFT(SAUDA_DATE,11),                                                                  
		 0, 1, RECTYPE = (CASE WHEN LEFT(OPPDATE,11) = LEFT(SAUDA_DATE,11) THEN 'SPEC' ELSE 'OPEN' END)                                                            
  FROM   MSAJAG.DBO.TBL_PNL_DATA WITH(NOLOCK)                                                                                
  WHERE  SAUDA_DATE = @SAUDA_DATE 
         AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY                                                                      
         --AND TRADETYPE = 'BT'

/*==============================================================================*/                                                                                
/*CURSOR TO COMPLETE FINAL MARKING FOR PART SQUARED-OFF POSITIONS*/                                                                 
/*==============================================================================*/                                                                                
  SET @SETTCUR = CURSOR FOR SELECT   SNO, PARTY_CODE, SCRIP_CD, SERIES, BSECODE, ISIN, TRADEQTY, ORGDATE1=LEFT(ORGDATE,11), ORGDATE                                                      
                            FROM     TBL_PNL_DATA_TMP P (NOLOCK)                                          
                            WHERE    SELL_BUY = 1 AND OPPDATE LIKE 'DEC 31 2049%'                                                                
       AND PARTY_CODE IN (SELECT PARTY_CODE FROM TBL_PNL_DATA_TMP P1                                                          
              WHERE P.PARTY_CODE = P1.PARTY_CODE                                                                
              AND P.SCRIP_CD = P1.SCRIP_CD                                                                
              AND P.SERIES = P1.SERIES                                                          
              AND P.BSECODE = P1.BSECODE                                                                
              AND P.ISIN = P1.ISIN                                                                
              AND P1.SELL_BUY = 2 AND OPPDATE LIKE 'DEC 31 2049%')                                                                
                          ORDER BY PARTY_CODE, SCRIP_CD, SERIES, BSECODE, ORGDATE                                                                                
                                                   
  OPEN @SETTCUR                                                                                
                                                                                  
  FETCH NEXT FROM @SETTCUR                                                                                
  INTO @BUYSNO, @PARTY_CODE,@SCRIP_CD,                                          
     @SERIES,                                                  
     @BSECODE,                                                      
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
   AND SCRIP_CD = @SCRIP_CD                                                                      
   AND SERIES = @SERIES                                        
   AND BSECODE = @BSECODE                                                                      
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
INTO @BUYSNO, @PARTY_CODE,@SCRIP_CD,                                                                      
     @SERIES,                                                                      
     @BSECODE,                                                                   
       @ISIN,                                                                                
       @PQTY,                                                                                
       @BUYSAUDA_DATE,                                                      
  @TEMPORGDATE                                                                 
END                                                                
                                                                
DELETE FROM TBL_PNL_DATA_ORG                            
WHERE SNO IN (SELECT ORGSNO FROM TBL_PNL_DATA_TMP WHERE UPDFLAG = 1 AND ORGSNO <> 0)                                                                    
                                            
INSERT INTO TBL_PNL_DATA_ORG                                                                      
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
FROM TBL_PNL_DATA_TMP                                                                      
WHERE UPDFLAG = 1

GO
