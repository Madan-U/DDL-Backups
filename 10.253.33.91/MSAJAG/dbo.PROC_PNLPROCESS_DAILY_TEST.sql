-- Object: PROCEDURE dbo.PROC_PNLPROCESS_DAILY_TEST
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE PROC [dbo].[PROC_PNLPROCESS_DAILY_TEST]                                              
(                                                                          
 @SAUDA_DATE VARCHAR(11),                                                                           
 @FROMPARTY  VARCHAR(10),                                                                          
 @TOPARTY    VARCHAR(10)                                                                         
)                                                                          
AS                                                                      
                                                                          
DECLARE                             
    @EXCHANGE   VARCHAR(3),                                                 
       @PREVDATE   VARCHAR(11),                                                                                    
       @PARTY_CODE VARCHAR(10),                                                                           
       @SCRIP_CD   VARCHAR(12),                                                                                    
       @BSECODE    VARCHAR(12),                                                                                    
       @SERIES     VARCHAR(3),                                                                                    
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
       @ISIN    VARCHAR(12)                                                                           
                                                                          
SELECT @PREVDATE = ISNULL(LEFT(MAX(MARGINDATE),11),'APR  1 2004')                                                                                    
FROM  TBL_PNL_DATA_test                                                                          
WHERE MARGINDATE < CONVERT(DATETIME,@SAUDA_DATE)                                                                          
AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY

DELETE FROM TBL_PNL_DATA_test                                                              
WHERE SAUDA_DATE >= @SAUDA_DATE                                                                       
AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY                                                                          
                                               
UPDATE TBL_PNL_DATA_TEST SET BILLFLAG = (CASE WHEN SELL_BUY = 1 THEN 4 ELSE 5 END),                                                                          
MARGINDATE = LEFT(SAUDA_DATE, 11),OPPDATE='DEC 31 2049'                                                                          
WHERE MARGINDATE >= @SAUDA_DATE                                               
AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY                                                                          
                         
TRUNCATE TABLE TBL_PNL_DATA_TMP_TEST            
        
---- NSECM ----                                             
                                                                          
INSERT INTO TBL_PNL_DATA_TMP_TEST                                                       
SELECT EXCHANGE,MARGINDATE=@SAUDA_DATE,TRADETYPE='BF',SETT_NO,SETT_TYPE,PARTY_CODE,SCRIP_CD,SERIES,                                                                    
BSECODE,ISIN,USER_ID,CONTRACTNO,ORDER_NO,TRADE_NO,SAUDA_DATE,TRADEQTY,MARKETRATE,                                                                       
PNLRATE,MARKETTYPE,SELL_BUY,INS_CHRG,TURN_TAX,OTHER_CHRG,SEBI_TAX,BROKER_CHRG,                                                              
BILLFLAG,NBROKAPP,NSERTAX,N_NETRATE,OPPDATE='DEC 31 2049', ORGDATE, SNO, 0, RECTYPE = 'OPEN'                                                                    
FROM TBL_PNL_DATA_TEST                                                  
WHERE /*MARGINDATE = @PREVDATE                                                             
AND*/PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY                                                                          
AND BILLFLAG = 4                        
    
INSERT INTO TBL_PNL_DATA_TMP_TEST                                                       
SELECT EXCHANGE,MARGINDATE=@SAUDA_DATE,TRADETYPE='BT',SETT_NO,SETT_TYPE,PARTY_CODE,SCRIP_CD,SERIES,                                                                    
BSECODE,ISIN,USER_ID,CONTRACTNO,ORDER_NO,TRADE_NO,SAUDA_DATE,TRADEQTY,MARKETRATE,                                                                       
PNLRATE,MARKETTYPE,SELL_BUY,INS_CHRG,TURN_TAX,OTHER_CHRG,SEBI_TAX,BROKER_CHRG,                                                              
BILLFLAG,NBROKAPP,NSERTAX,N_NETRATE,OPPDATE='DEC 31 2049', ORGDATE, 0, 1, RECTYPE = 'OPEN'                                                                    
FROM BAK_TBL_PNL_DATA                                                                          
WHERE SAUDA_DATE = @SAUDA_DATE   
AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY                                                                          

/*==============================================================================*/                                                                                    
/*CURSOR TO COMPLETE FINAL MARKING FOR PART SQUARED-OFF POSITIONS*/                                                                     
/*==============================================================================*/      
    
    
  SET @SETTCUR = CURSOR FOR   
SELECT   SNO, PARTY_CODE, ISIN, TRADEQTY, ORGDATE1=LEFT(ORGDATE,11), ORGDATE, EXCHANGE                                                          
                            FROM     TBL_PNL_DATA_TMP_TEST P (NOLOCK)                                              
                            WHERE    SAUDA_DATE = @sauda_date and SELL_BUY = 1 AND OPPDATE = 'DEC 31 2049'    
       AND TRADEQTY > 0                                                   
       AND PARTY_CODE IN (SELECT PARTY_CODE FROM TBL_PNL_DATA_TMP_TEST P1                                                              
              WHERE SAUDA_DATE = @sauda_date  and p.PARTY_CODE = P1.PARTY_CODE                                                                                                                                
              AND P.ISIN = P1.ISIN             
              AND P1.SELL_BUY = 2 AND OPPDATE = 'DEC 31 2049'   
     AND P.EXCHANGE = P1.EXCHANGE and TRADEQTY > 0 )                                                                    
                          ORDER BY PARTY_CODE, ISIN, ORGDATE    
                                                                                                           
          
  OPEN @SETTCUR                                                           
                                                                                      
  FETCH NEXT FROM @SETTCUR                                                                                    
  INTO @BUYSNO, @PARTY_CODE,                                                         
       @ISIN,                                                                       
       @PQTY,                                                                                    
       @BUYSAUDA_DATE,                             
    @TEMPORGDATE,    
 @EXCHANGE                                                                          
                                                                          
  WHILE @@FETCH_STATUS = 0                                                                                    
    BEGIN                                                  
  SET @SETTREC = CURSOR FOR                                                                      
                                                  
   SELECT   SNO, TRADEQTY, ORGDATE=LEFT(ORGDATE,11)                                                                                    
   FROM     TBL_PNL_DATA_TMP_TEST (NOLOCK)                                                                                    
   WHERE    PARTY_CODE = @PARTY_CODE                                                                                    
   AND ISIN = @ISIN                                                                                   
   AND SELL_BUY = 2                                                                                    
   AND OPPDATE LIKE 'DEC 31 2049%'    
   AND EXCHANGE = @EXCHANGE  and TRADEQTY > 0                                                                   
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
                                                                    
  UPDATE TBL_PNL_DATA_TMP_TEST                                                        
  SET    BILLFLAG = 3, UPDFLAG = 1, OPPDATE = @BUYSAUDA_DATE, RECTYPE = 'SPEC'                                 
  WHERE  SNO = @SELLSNO                                                                                    
                           
  IF @PQTY = @SQTY                                                                     
  BEGIN                   
   UPDATE TBL_PNL_DATA_TMP_TEST                                                                                    
   SET    BILLFLAG = 2, UPDFLAG = 1, OPPDATE = @SELLSAUDA_DATE, RECTYPE = 'SPEC'                                                                             
   WHERE SNO = @BUYSNO      
                                                                       
 SET @PQTY = 0                                                                                    
     END                                                                                     
  ELSE                                                                    
  BEGIN                          
   INSERT INTO TBL_PNL_DATA_TMP_TEST                                                                                    
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
   FROM   TBL_PNL_DATA_TMP_TEST (NOLOCK)                                                                                    
   WHERE  SNO = @BUYSNO                              
                                                                    
   UPDATE TBL_PNL_DATA_TMP_TEST                                        
   SET TRADEQTY = @PDIFF, UPDFLAG = 1                                                             
   WHERE  SNO = @BUYSNO                                           
                                           SELECT @PQTY = @PDIFF                                                               
        END                                                      
 END                                   
ELSE                                                                    
 BEGIN                                                                    
  SELECT @PDIFF = @SQTY - @PQTY                                                                    
                                                    
  UPDATE TBL_PNL_DATA_TMP_TEST                                                                                    
  SET    BILLFLAG = 2, UPDFLAG = 1, OPPDATE = @SELLSAUDA_DATE, RECTYPE = 'SPEC'                             
  WHERE  SNO = @BUYSNO             
                                                                    
  INSERT INTO TBL_PNL_DATA_TMP_TEST                                                                                    
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
  FROM   TBL_PNL_DATA_TMP_TEST (NOLOCK)                                                                                    
  WHERE  SNO = @SELLSNO                                                          
                                                                    
  SET @PQTY = 0                                                                    
                                                                    
  UPDATE TBL_PNL_DATA_TMP_TEST                                                                                    
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
 @EXCHANGE                                                                     
END                                                                    
close @settcur  
deallocate @settcur  
  
                                                                          
  SET @SETTCUR = CURSOR FOR SELECT   SNO, PARTY_CODE, ISIN, TRADEQTY, ORGDATE1=LEFT(ORGDATE,11), ORGDATE                                                          
                            FROM     TBL_PNL_DATA_TMP_TEST P (NOLOCK)                                              
                            WHERE    SELL_BUY = 1 AND OPPDATE = 'DEC 31 2049'                                                                    
       AND PARTY_CODE IN (SELECT PARTY_CODE FROM TBL_PNL_DATA_TMP_TEST P1                                                              
              WHERE P.PARTY_CODE = P1.PARTY_CODE                                                                                                                                
              AND P.ISIN = P1.ISIN                                                                    
              AND P1.SELL_BUY = 2 AND OPPDATE = 'DEC 31 2049')                                                                    
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
   FROM     TBL_PNL_DATA_TMP_TEST (NOLOCK)                                                                                    
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
                                                                    
  UPDATE TBL_PNL_DATA_TMP_TEST                                                        
  SET    BILLFLAG = 3, UPDFLAG = 1, OPPDATE = @BUYSAUDA_DATE                                 
  WHERE  SNO = @SELLSNO                                                                                    
                                                                                                      
  IF @PQTY = @SQTY                                                                     
  BEGIN                   
   UPDATE TBL_PNL_DATA_TMP_TEST                                                                                    
   SET    BILLFLAG = 2, UPDFLAG = 1, OPPDATE = @SELLSAUDA_DATE                                                                                 
   WHERE SNO = @BUYSNO      
                                                                       
 SET @PQTY = 0                                                                                    
     END                                                                                     
  ELSE                                                                    
  BEGIN                          
   INSERT INTO TBL_PNL_DATA_TMP_TEST                                                                                    
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
   FROM   TBL_PNL_DATA_TMP_TEST (NOLOCK)                                                                                    
   WHERE  SNO = @BUYSNO                              
                                                                    
   UPDATE TBL_PNL_DATA_TMP_TEST                                        
   SET TRADEQTY = @PDIFF, UPDFLAG = 1                                                             
   WHERE  SNO = @BUYSNO                                           
                                           SELECT @PQTY = @PDIFF                                                                    
        END                                                      
 END                                            
ELSE                                                                    
 BEGIN                                                                    
  SELECT @PDIFF = @SQTY - @PQTY                                                                    
                                                    
  UPDATE TBL_PNL_DATA_TMP_TEST                                                                                    
  SET    BILLFLAG = 2, UPDFLAG = 1, OPPDATE = @SELLSAUDA_DATE                                                                                 
  WHERE  SNO = @BUYSNO             
                                                                    
  INSERT INTO TBL_PNL_DATA_TMP_TEST                                                                                    
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
  FROM   TBL_PNL_DATA_TMP_TEST (NOLOCK)                                                                                    
  WHERE  SNO = @SELLSNO                                                          
                                                                    
  SET @PQTY = 0                                                                    
                                                                    
  UPDATE TBL_PNL_DATA_TMP_TEST                                                                                    
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

--SELECT * FROM         TBL_PNL_DATA_TMP_TEST

DELETE FROM TBL_PNL_DATA_test                                
WHERE SNO IN (SELECT ORGSNO FROM TBL_PNL_DATA_TMP_TEST WHERE UPDFLAG = 1 AND ORGSNO <> 0)                                                                        
                                                
INSERT INTO TBL_PNL_DATA_test                                                                          
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
FROM TBL_PNL_DATA_TMP_TEST                                              
WHERE UPDFLAG = 1

GO
