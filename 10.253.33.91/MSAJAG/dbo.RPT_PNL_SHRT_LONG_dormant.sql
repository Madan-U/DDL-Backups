-- Object: PROCEDURE dbo.RPT_PNL_SHRT_LONG_dormant
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

  CREATE PROC [DBO].[RPT_PNL_SHRT_LONG_dormant]
  
  (
   @FROMPARTY VARCHAR(10),                                                                             
 @TOPARTY VARCHAR(10), 
 @fromdate VARCHAR(11)
 )
 as
   
                                         
 SELECT SAUDA_DATE, SETT_NO, SETT_TYPE, T.PARTY_CODE,                                                                         
 SCRIP_CD, SERIES, BSECODE, ISIN,                                                                         
 SELLQTY = (CASE WHEN SELL_BUY = 2 THEN TRADEQTY ELSE 0 END),                                                                         
 SELLRATE = (CASE WHEN SELL_BUY = 2 THEN MARKETRATE ELSE 0 END),                                                                        
 SELLVAL = (CASE WHEN SELL_BUY = 2 THEN MARKETRATE*TRADEQTY ELSE 0 END),                                                                        
 BUYQTY = (CASE WHEN SELL_BUY = 1 THEN TRADEQTY ELSE 0 END),                          
 BUYRATE = (CASE WHEN SELL_BUY = 1 THEN MARKETRATE ELSE 0 END),                                                               
 BUYVAL = -(CASE WHEN SELL_BUY = 1 THEN MARKETRATE*TRADEQTY ELSE 0 END),                                                                        
 PNL = (CASE WHEN SELL_BUY = 1 THEN -MARKETRATE*TRADEQTY ELSE MARKETRATE*TRADEQTY END),                                                              
 OPPDATE,                                                                        
 FLAG = CONVERT(VARCHAR(50), ''),                                                                        
 SCRIP_NAME = CONVERT(VARCHAR(50), '')                       
                                        
 INTO #TBL_PNL_DATA                                           
 FROM TBL_PNL_DATA T                                                                  
 WHERE 1 = 2                                        
               
                                        
 CREATE CLUSTERED INDEX  [INX_PNL_DATA]                                               
    ON [DBO].[#TBL_PNL_DATA]                                               
    (                                               
            [PARTY_CODE]                                         
    )                                               
                      
                            
                        
                                         
                                        
                                                                  
 INSERT INTO #TBL_PNL_DATA                                                                    
 SELECT SAUDA_DATE, SETT_NO, SETT_TYPE, T.PARTY_CODE,                                                                         
 SCRIP_CD, SERIES, BSECODE, ISIN,                                                                         
 SELLQTY = SUM(CASE WHEN SELL_BUY = 2 THEN TRADEQTY ELSE 0 END),                                                                         
 SELLRATE = (CASE WHEN SELL_BUY = 2 THEN MARKETRATE ELSE 0 END),                                                                        
 SELLVAL = SUM(CASE WHEN SELL_BUY = 2 THEN MARKETRATE*TRADEQTY ELSE 0 END),                                                                        
BUYQTY = SUM(CASE WHEN SELL_BUY = 1 THEN TRADEQTY ELSE 0 END),                                                                         
 BUYRATE = (CASE WHEN SELL_BUY = 1 THEN MARKETRATE ELSE 0 END),                                                                        
 BUYVAL = -SUM(CASE WHEN SELL_BUY = 1 THEN MARKETRATE*TRADEQTY ELSE 0 END),                                                                        
 PNL = SUM(CASE WHEN SELL_BUY = 1 THEN -MARKETRATE*TRADEQTY ELSE MARKETRATE*TRADEQTY END),                                
 OPPDATE,                                                                        
 FLAG=RECTYPE,                                           
 SCRIP_NAME = ''                    
 FROM TBL_PNL_DATA T WITH (NOLOCK) --, #CLIENT_DETAILS C WITH (NOLOCK)                                                          
     
 WHERE T.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY                                                        
 and MARGINDATE = @fromdate                                                     
 AND BILLFLAG < 4                                                                        
 GROUP BY SAUDA_DATE, SETT_NO, SETT_TYPE, T.PARTY_CODE,EXCHANGE,                                                                         
 SCRIP_CD, SERIES, BSECODE, ISIN, MARKETRATE, SELL_BUY, OPPDATE,        
 RECTYPE       
     
                      
                                                                         
 UPDATE #TBL_PNL_DATA SET SCRIP_NAME = LEFT(S1.LONG_NAME, 50)                                             
 FROM MSAJAG.DBO.SCRIP2 S2 WITH (NOLOCK), MSAJAG.DBO.SCRIP1 S1 WITH (NOLOCK)                                                             
 WHERE S2.CO_CODE = S1.CO_CODE                             
 AND S2.SERIES = S1.SERIES                                                                          
 AND #TBL_PNL_DATA.SCRIP_CD = S2.SCRIP_CD                                                       
 AND #TBL_PNL_DATA.SERIES = S2.SERIES                                                                          
 AND SCRIP_NAME = ''                                                                          
                                                                           
 UPDATE #TBL_PNL_DATA SET SCRIP_NAME = LEFT(S1.LONG_NAME, 50)                                                                          
 FROM ANAND.BSEDB_AB.DBO.SCRIP2 S2 WITH (NOLOCK), ANAND.BSEDB_AB.DBO.SCRIP1 S1 WITH (NOLOCK)                                                   
 WHERE S2.CO_CODE = S1.CO_CODE                                                    
 AND S2.SERIES = S1.SERIES                                                                          
 AND #TBL_PNL_DATA.BSECODE = S2.BSECODE                                                                          
 AND SCRIP_NAME = ''                                                                          
                                          
   
                                                        
                                                                      
                                        
                                                                 
 SELECT PARTY_CODE = T.PARTY_CODE,                                        
 --SCRIP_CD,                              
 --SERIES,                              
-- BSECODE,                            
ISIN,                                                                  
 SELLQTY=SUM(SELLQTY),                                                      
 SELLRATE=ROUND((CASE WHEN SUM(SELLQTY) > 0 THEN SUM(SELLRATE*SELLQTY)/SUM(SELLQTY) ELSE 0 END),2),                                                              
 SELLVAL=ROUND(SUM(SELLVAL),2),                                                      
 BUYQTY=SUM(BUYQTY),                                                      
 BUYRATE=ROUND((CASE WHEN SUM(BUYQTY) > 0 THEN SUM(BUYRATE*BUYQTY)/SUM(BUYQTY) ELSE 0 END),2),                                                      
 BUYVAL=ROUND(SUM(BUYVAL),2),                                                                  
 PNL=ROUND(SUM(PNL),2),FLAG,SCRIP_NAME                                       
 FROM                                         
 #TBL_PNL_DATA T                                        
                   
 WHERE T.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY          
                                                                            
 GROUP BY T.PARTY_CODE,/*SCRIP_CD/*,SERIES*/,BSECODE,*/ISIN,FLAG,SCRIP_NAME                                                   
 ORDER BY T.PARTY_CODE, FLAG DESC, SCRIP_NAME, /*SCRIP_CD, /*SERIES,*/ BSECODE,*/ ISIN                                                                        

DROP TABLE  #TBL_PNL_DATA

GO
