-- Object: PROCEDURE dbo.POP_PNLDATA_Daily_test
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE PROC [DBO].[POP_PNLDATA_DAILY_TEST]                                                 
AS                                                    
                                                    
DECLARE @SAUDA_DATE VARCHAR(11),                                                    
  @YY  INT,                                                     
  @MM  INT,                                                     
  @DD  INT,                                                    
  @DATECUR    CURSOR,                                
  @MCUR CURSOR,                                
  @MDATE DATETIME,                                
  @MPARTY VARCHAR(10),                                
  @MISIN VARCHAR(12)                                                    
                                
TRUNCATE TABLE TBL_PNL_DATA_TEST_FINAL                                
/*                                
SELECT MARGINDATE=MIN(MARGINDATE),ISIN,PARTY_CODE INTO #DUPLI FROM BAK_DUPLICATE                                 
GROUP BY ISIN,PARTY_CODE                                
ORDER BY PARTY_CODE, ISIN                                 
*/                              
                              
TRUNCATE TABLE BAK_DUPLI                              
                            
--INSERT INTO BAK_DUPLI VALUES('A43555', 'INE110D01013', '2013-11-27 00:00:00.000')                      
                      
INSERT INTO BAK_DUPLI                              
SELECT TOP 2500 PARTY_CODE, ISIN='', SAUDA_DATE = MIN(sauda_date) FROM BAK_TOCHECK_DATA                              
-- ORDER BY MARGINDATE, PARTY_CODE, ISIN                            
--WHERE PARTY_CODE = 'R57273' AND ISIN = 'INE257A01026'                      
--WHERE 1  = 2                        
GROUP BY PARTY_CODE                      
ORDER BY PARTY_CODE                      
                              
TRUNCATE TABLE BAK_DUPLI_BAK                              
                              
SET @MCUR = CURSOR FOR                                
SELECT B.SAUDA_DATE, B.PARTY_CODE FROM BAK_DUPLI B                              
ORDER BY 1, 2                               
OPEN @MCUR                                
FETCH NEXT FROM @MCUR INTO @MDATE, @MPARTY                             
WHILE @@FETCH_STATUS = 0                                 
BEGIN                                
 --SELECT @MDATE, @MPARTY, @MISIN                                
 TRUNCATE TABLE TBL_PNL_DATA_TEST                                
/*                                
 INSERT INTO TBL_PNL_DATA_TEST                                
 SELECT EXCHANGE,MARGINDATE=SAUDA_DATE,TRADETYPE,SETT_NO,SETT_TYPE,PARTY_CODE,SCRIP_CD,SERIES,                                
     BSECODE,ISIN,USER_ID,CONTRACTNO,ORDER_NO,TRADE_NO,SAUDA_DATE,TRADEQTY,MARKETRATE,                                
     PNLRATE,MARKETTYPE,SELL_BUY,INS_CHRG,TURN_TAX,OTHER_CHRG,SEBI_TAX,BROKER_CHRG,BILLFLAG=SELL_BUY+3,                                
     NBROKAPP,NSERTAX,N_NETRATE,OPPDATE='DEC 31 2049',ORGDATE,RECTYPE='OPEN'                                
 FROM TBL_PNL_DATA_05MAY                                
 WHERE SAUDA_DATE >= @MDATE                                
 AND SAUDA_DATE <= @MDATE + ' 23:59:59'                      
 AND PARTY_CODE = @MPARTY                       
*/                                  
 TRUNCATE TABLE BAK_TBL_PNL_DATA                                
                                
 INSERT INTO BAK_TBL_PNL_DATA                                
 SELECT EXCHANGE,MARGINDATE=SAUDA_DATE,TRADETYPE='BT',SETT_NO,SETT_TYPE,PARTY_CODE,SCRIP_CD,SERIES,                                
 BSECODE,ISIN,USER_ID,CONTRACTNO,ORDER_NO,TRADE_NO,SAUDA_DATE,TRADEQTY,MARKETRATE,PNLRATE,                                
 MARKETTYPE,SELL_BUY,INS_CHRG,TURN_TAX,OTHER_CHRG,SEBI_TAX,BROKER_CHRG,BILLFLAG=SELL_BUY+3,NBROKAPP,                                
 NSERTAX,N_NETRATE,OPPDATE='DEC 31 2049',ORGDATE,RECTYPE='OPEN'                                 
 FROM TBL_PNL_DATA_05MAY                                
 WHERE SAUDA_DATE >= @MDATE                                
 AND PARTY_CODE = @MPARTY                         
                                 
 --SELECT * FROM TBL_PNL_DATA_TEST                                
                                                     
 SET @DATECUR = CURSOR FOR                                          
                                                     
 SELECT DISTINCT LEFT(SAUDA_DATE,11), YY=YEAR(SAUDA_DATE), MM=MONTH(SAUDA_DATE), DD=DAY(SAUDA_DATE)                                                     
 FROM BAK_TBL_PNL_DATA               
 ORDER BY 2, 3, 4                                                   
 OPEN @DATECUR                                                    
 FETCH NEXT FROM @DATECUR INTO @SAUDA_DATE, @YY, @MM, @DD                                                    
 WHILE @@FETCH_STATUS = 0                                                    
 BEGIN                                                
  EXEC PROC_PNLPROCESS_DAILY_TEST @SAUDA_DATE, @MPARTY, @MPARTY                             
  FETCH NEXT FROM @DATECUR INTO @SAUDA_DATE, @YY, @MM, @DD                                                    
 END                                                    
 CLOSE @DATECUR                                                    
 DEALLOCATE @DATECUR                                 
                                
 INSERT INTO TBL_PNL_DATA_TEST_FINAL                                
 SELECT EXCHANGE,MARGINDATE,TRADETYPE,SETT_NO,SETT_TYPE,PARTY_CODE,SCRIP_CD,SERIES,BSECODE,ISIN,                              
 USER_ID,CONTRACTNO,ORDER_NO,TRADE_NO,SAUDA_DATE,TRADEQTY,MARKETRATE,PNLRATE,MARKETTYPE,SELL_BUY,INS_CHRG,                              
 TURN_TAX,OTHER_CHRG,SEBI_TAX,BROKER_CHRG,BILLFLAG,NBROKAPP,NSERTAX,N_NETRATE,OPPDATE,ORGDATE,RECTYPE                                 
 FROM TBL_PNL_DATA_TEST                                
                              
 INSERT INTO BAK_DUPLI_BAK                              
 SELECT * FROM BAK_DUPLI                              
 WHERE SAUDA_DATE = @MDATE                                
 AND PARTY_CODE = @MPARTY                         
                               
 EXEC POP_PNLDATA_DAILY_POP                        
                             
 DELETE FROM BAK_DUPLI                              
 WHERE SAUDA_DATE = @MDATE                                
 AND PARTY_CODE = @MPARTY                             
                              
 DELETE FROM BAK_TOCHECK_DATA                               
 WHERE PARTY_CODE = @MPARTY                             
                                  
 FETCH NEXT FROM @MCUR INTO @MDATE, @MPARTY                             
END                                
CLOSE @MCUR                                
DEALLOCATE @MCUR

GO
