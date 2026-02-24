-- Object: PROCEDURE dbo.RPT_PNL_SHRT_LONG_ANG_UAT_Optimisation
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

                          
---EXEC RPT_PNL_SHRT_LONG 'BROKER','BROKER','APR  1 2011','MAR 31 2012','A0001','AZ999','','Y', 'S','W'--944                                    
                                      
CREATE PROC [dbo].[RPT_PNL_SHRT_LONG_ANG_UAT_Optimisation]                                                                    
(                                                                      
 @STATUSID VARCHAR(25),                                                                      
 @STATUSNAME VARCHAR(25),                                                                      
 @FROMDATE VARCHAR(11),                                                                       
 @TODATE VARCHAR(11),                                                                      
 @FROMPARTY VARCHAR(10),                                                                       
 @TOPARTY VARCHAR(10),                                                                      
 @BRANCH_CD VARCHAR(10),                                                                    
 @CHARGES VARCHAR(1),                                                              
 @RPTOPT VARCHAR(1),                                          
 @RPTOPENSELL VARCHAR(1),                                
@SINGLE     VARCHAR(1)  = 'N'                                                                    
)                                                                      
                                                                    
AS                                          
       
 --return 0




DECLARE @CL_DATE VARCHAR(11)                                          
                                          
DECLARE @FINYEARFROM DATETIME,                                          
  @FINYEARTO DATETIME                                          
                                          
SELECT @FINYEARFROM = (CASE WHEN MONTH(@FROMDATE) <= 3                                           
       THEN 'APR  1 ' + CONVERT(VARCHAR,YEAR(@FROMDATE) - 1)                                          
       ELSE 'APR  1 ' + CONVERT(VARCHAR,YEAR(@FROMDATE))                                          
        END),                                          
    @FINYEARTO   = (CASE WHEN MONTH(@FROMDATE) <= 3                                           
       THEN 'MAR 31 ' + CONVERT(VARCHAR,YEAR(@FROMDATE))                                          
       ELSE 'MAR 31 ' + CONVERT(VARCHAR,YEAR(@FROMDATE) + 1)                                          
        END)                                          
                                          
SELECT @CL_DATE = LEFT(MAX(SYSDATE),11) FROM MSAJAG.DBO.CLOSING                                          
WHERE CONVERT(DATETIME,LEFT(SYSDATE,11)) <= @TODATE                                                               
                    
--PRINT @FINYEARFROM         
  
--SET @TOPARTY = @FROMPARTY     
      
--RETURN 0        
                    
                                      
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
 SCRIP_NAME = CONVERT(VARCHAR(50), ''), BRANCH_CD = CONVERT(VARCHAR(10), ''),                 
 CL_RATE = CONVERT(NUMERIC(18,2), 0), CLVAL = CONVERT(NUMERIC(18,2), 0),                         
 LONG_NAME = CONVERT(VARCHAR(100),''),                                                
 L_ADDRESS1 = CONVERT(VARCHAR(50),''),                   
 L_ADDRESS2 = CONVERT(VARCHAR(50),''),                                                
 L_ADDRESS3 = CONVERT(VARCHAR(50),''),                                                
 L_CITY = CONVERT(VARCHAR(50),''),                                                
 L_STATE = CONVERT(VARCHAR(50),''),                                                
 L_NATION = CONVERT(VARCHAR(50),''),                                
 L_ZIP = CONVERT(VARCHAR(50),''),                                                 
SUB_BROKER = CONVERT(VARCHAR(20),''),                                    
TRADER = CONVERT(VARCHAR(20),''),                                    
FAMILY  = CONVERT(VARCHAR(20),''),                                    
AREA  = CONVERT(VARCHAR(20),''),                                    
REGION  = CONVERT(VARCHAR(20),'')                                    
                                    
 INTO #TBL_PNL_DATA                                       
 FROM TBL_PNL_DATA T                                                              
 WHERE 1 = 2                                    
           
                                    
 CREATE CLUSTERED INDEX  [INX_PNL_DATA]                                           
    ON [DBO].[#TBL_PNL_DATA]                                           
    (                                           
            [PARTY_CODE]                                     
    )                                           
          
        
                  
  SELECT * INTO #TBL_PNL_DATA_N         
  FROM TBL_PNL_DATA WITH(NOLOCK)         
  WHERE PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY                  
  and SAUDA_DATE BETWEEN @FROMDATE AND @TODATE + ' 23:59'      -- Added by Anand D for optimisation                            
                                    
      
--RETURN 0        
                    
                                    
SELECT                                     
 CL_CODE,                                      
 LONG_NAME,                                                
 L_ADDRESS1,                                                
 L_ADDRESS2,                                                
 L_ADDRESS3,                                           
 L_CITY,                                                
 L_STATE,                                                
 L_NATION,                                                
 L_ZIP,                                               
 BRANCH_CD,                                                                           
 SUB_BROKER,                                                                                  
 TRADER,                                                                                  
 FAMILY,                                                                             
 AREA,                                                                                  
 REGION,                                                                                  
 PARTY_CODE  = C.PARTY_CODE                                        
INTO #CLIENT_DETAILS                                    
FROM                                          
 CLIENT_DETAILS C (NOLOCK)                                     
                    
 /*INNER JOIN TBL_PNL_DATA T (NOLOCK)                                     
 ON (C.PARTY_CODE = T.PARTY_CODE)*/                                    
WHERE                                          
CL_CODE BETWEEN @FROMPARTY AND @TOPARTY                                     
/*AND (SAUDA_DATE BETWEEN @FROMDATE AND @TODATE + ' 23:59'                                    
OR OPPDATE BETWEEN @FROMDATE AND @TODATE + ' 23:59')*/                                    
AND C.BRANCH_CD = (CASE WHEN @BRANCH_CD = '' OR @BRANCH_CD = 'ALL' THEN C.BRANCH_CD ELSE @BRANCH_CD END)                                    
AND @STATUSNAME = (CASE                                                                                   
   WHEN @STATUSID = 'BRANCH' THEN C.BRANCH_CD                             
   WHEN @STATUSID = 'SUBBROKER' THEN C.SUB_BROKER                                                                                  
   WHEN @STATUSID = 'TRADER' THEN C.TRADER                                          
   WHEN @STATUSID = 'FAMILY' THEN C.FAMILY                                                                                  
   WHEN @STATUSID = 'AREA' THEN C.AREA                                               
   WHEN @STATUSID = 'REGION' THEN C.REGION                                                                                  
   WHEN @STATUSID = 'CLIENT' THEN C.PARTY_CODE                                                                                  
   ELSE                                                  
   'BROKER'                                                                                  
   END)                                    
                                    
--PRINT CONVERT(VARCHAR(11),@FINYEARFROM,109)                    
      
--RETURN 0        
                               
SELECT * INTO #T FROM INTRANET.RISK.DBO.CLIENT_DETAILS WITH (NOLOCK)                    
WHERE LAST_INACTIVE_DATE < @FINYEARFROM                    
AND CL_CODE BETWEEN @FROMPARTY AND @TOPARTY                                     
                    
DELETE C1 FROM #CLIENT_DETAILS C1, #T C2 WITH (NOLOCK)                    
WHERE C1.CL_CODE=C2.CL_CODE                    
                    
                    
                    
                                    
 CREATE CLUSTERED INDEX  [INX_PNL_DATA_CL]                                           
    ON [DBO].[#CLIENT_DETAILS]                                           
    (                                           
            [PARTY_CODE]                         
    )                                           
                                    
                                                                  
IF @CHARGES = 'N'                                                                   
BEGIN                        
PRINT 'SURESH'                                                                
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
 SCRIP_NAME = '',                                     
 BRANCH_CD = '',                                               
 CL_RATE = CONVERT(NUMERIC(18,2), 0),                                     
 CLVAL = CONVERT(NUMERIC(18,2), 0),                                                
 LONG_NAME = '',                                  
 L_ADDRESS1 = '',                                                
 L_ADDRESS2 = '',                                                
 L_ADDRESS3 = '',                                           
 L_CITY = '',                                                
 L_STATE = '',                                                
 L_NATION = '',                                                
 L_ZIP = '',             
SUB_BROKER = '',                                    
TRADER  = '',                                    
FAMILY  = '',                                    
AREA  = '',                                    
REGION  = ''                                    
 FROM #TBL_PNL_DATA_N T WITH (NOLOCK) --, #CLIENT_DETAILS C WITH (NOLOCK)                                                      
 WHERE T.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY                                                                      
 --AND C.CL_CODE = T.PARTY_CODE                                               
 --AND BRANCH_CD = (CASE WHEN @BRANCH_CD = '' OR @BRANCH_CD = 'ALL' THEN BRANCH_CD ELSE @BRANCH_CD END)                                                                    
 AND (SAUDA_DATE BETWEEN @FROMDATE AND @TODATE + ' 23:59'                                    
   /*OR OPPDATE BETWEEN @FROMDATE AND @TODATE + ' 23:59'*/)                                    
 AND SAUDA_DATE <= @TODATE + ' 23:59'                                                   
 /*AND OPPDATE <= @TODATE + ' 23:59'                             
 AND @STATUSNAME = (CASE                                                                                   
       WHEN @STATUSID = 'BRANCH' THEN C.BRANCH_CD                                                                                  
       WHEN @STATUSID = 'SUBBROKER' THEN C.SUB_BROKER                                                                             
       WHEN @STATUSID = 'TRADER' THEN C.TRADER                                                                                  
       WHEN @STATUSID = 'FAMILY' THEN C.FAMILY                                                                                  
       WHEN @STATUSID = 'AREA' THEN C.AREA                                                                                  
       WHEN @STATUSID = 'REGION' THEN C.REGION                                                                                  
       WHEN @STATUSID = 'CLIENT' THEN C.PARTY_CODE                                                                 
       ELSE                                                                                   
       'BROKER'                                                                                  
       END)*/                                             
 AND BILLFLAG < 4                                                                    
 GROUP BY SAUDA_DATE, SETT_NO, SETT_TYPE, T.PARTY_CODE,EXCHANGE,                                                                     
 SCRIP_CD, SERIES, BSECODE, ISIN, MARKETRATE, SELL_BUY, OPPDATE,                                     
 /*BRANCH_CD,C.LONG_NAME,                                                
 L_ADDRESS1,                                               
 L_ADDRESS2,                                                
 L_ADDRESS3,                                                
 L_CITY,                                                
 L_STATE,                                                
 L_NATION,                                                
 L_ZIP,*/                                      
 RECTYPE                                                                  
                                                                  
 INSERT  INTO #TBL_PNL_DATA                                                                     SELECT SAUDA_DATE, SETT_NO, SETT_TYPE, T.PARTY_CODE,                                                                     
 SCRIP_CD, SERIES, BSECODE, ISIN,                                                                     
 SELLQTY = SUM(CASE WHEN SELL_BUY = 2 THEN TRADEQTY ELSE 0 END),                                            
 SELLRATE = (CASE WHEN SELL_BUY = 2 THEN MARKETRATE ELSE 0 END),                                                    
 SELLVAL = SUM(CASE WHEN SELL_BUY = 2 THEN MARKETRATE*TRADEQTY ELSE 0 END),                                                                    
 BUYQTY = SUM(CASE WHEN SELL_BUY = 1 THEN TRADEQTY ELSE 0 END),                                                                     
 BUYRATE = (CASE WHEN SELL_BUY = 1 THEN MARKETRATE ELSE 0 END),                                                  
 BUYVAL = -SUM(CASE WHEN SELL_BUY = 1 THEN MARKETRATE*TRADEQTY ELSE 0 END),                                                                    
 PNL = SUM(CASE WHEN SELL_BUY = 1 THEN -MARKETRATE*TRADEQTY ELSE MARKETRATE*TRADEQTY END),                                                                    
 OPPDATE,                                                
 FLAG = (CASE WHEN BILLFLAG = 5                                           
     THEN '1OPEN'                                          
     ELSE 'FREE'                                          
   END),                                                                    
 SCRIP_NAME = CONVERT(VARCHAR(50), ''),                                     
 BRANCH_CD = '',                                    
 CL_RATE = CONVERT(NUMERIC(18,2), 0), CLVAL = CONVERT(NUMERIC(18,2), 0),                                          
 LONG_NAME = '',                                                
 L_ADDRESS1 = '',                                                
 L_ADDRESS2 = '',                                                
 L_ADDRESS3 = '',                                                
 L_CITY = '',                                                
 L_STATE = '',                                                
 L_NATION = '',                                                
 L_ZIP = '',                       
SUB_BROKER = '',                                    
TRADER  = '',                                    
FAMILY  = '',                                    
AREA  = '',                                    
REGION  = ''                                    
 FROM #TBL_PNL_DATA_N T WITH (NOLOCK) --, #CLIENT_DETAILS C WITH (NOLOCK)                                                                     
 WHERE T.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY                                                                      
 --AND C.CL_CODE = T.PARTY_CODE                                                         
 /*AND (SAUDA_DATE BETWEEN @FROMDATE AND @TODATE + ' 23:59'                                                                     
   OR OPPDATE BETWEEN @FROMDATE AND @TODATE + ' 23:59')*/                                            
 --AND BRANCH_CD = (CASE WHEN @BRANCH_CD = '' OR @BRANCH_CD = 'ALL' THEN BRANCH_CD ELSE @BRANCH_CD END)                                    
 AND SAUDA_DATE <= @TODATE + ' 23:59'                                                                    
 /*AND @STATUSNAME = (CASE                                                                                   
       WHEN @STATUSID = 'BRANCH' THEN C.BRANCH_CD                                                                              
       WHEN @STATUSID = 'SUBBROKER' THEN C.SUB_BROKER                                                         
       WHEN @STATUSID = 'TRADER' THEN C.TRADER                                                                                  
       WHEN @STATUSID = 'FAMILY' THEN C.FAMILY                                                                                  
       WHEN @STATUSID = 'AREA' THEN C.AREA                                                                                  
       WHEN @STATUSID = 'REGION' THEN C.REGION                                                                                  
       WHEN @STATUSID = 'CLIENT' THEN C.PARTY_CODE                                                                                  
       ELSE                                                                        'BROKER'                                                                                       
 END)*/           
 AND OPPDATE > @TODATE                                                                   
 AND BILLFLAG <> (CASE WHEN @RPTOPENSELL = 'W' THEN 0 ELSE 5 END)                                          
 AND SAUDA_DATE >= (CASE WHEN BILLFLAG = 5 THEN @FINYEARFROM ELSE 'APR  1 2000' END)                                          
 GROUP BY SAUDA_DATE, SETT_NO, SETT_TYPE, T.PARTY_CODE,                                                                     
 SCRIP_CD, SERIES, BSECODE, ISIN, MARKETRATE, SELL_BUY, OPPDATE,                                     
 /*BRANCH_CD,                                                
 C.LONG_NAME,                                                
 L_ADDRESS1,                                                
 L_ADDRESS2,                                                
 L_ADDRESS3,                              
 L_CITY,                                                
 L_STATE,                                                
 L_NATION,                                                
L_ZIP,*/                                    
 BILLFLAG                                                                   
END                        
                      
ELSE                                                              
BEGIN                              
PRINT 'SURESH1'                                                      
 INSERT INTO #TBL_PNL_DATA                                                               
 SELECT SAUDA_DATE, SETT_NO, SETT_TYPE, T.PARTY_CODE,                                                                     
 SCRIP_CD, SERIES, BSECODE, ISIN,                                                                     
 SELLQTY = SUM(CASE WHEN SELL_BUY = 2 THEN TRADEQTY ELSE 0 END),                                                                     
 SELLRATE = (CASE WHEN SELL_BUY = 2 THEN PNLRATE ELSE 0 END),                                                                    
 SELLVAL = SUM(CASE WHEN SELL_BUY = 2 THEN PNLRATE*TRADEQTY ELSE 0 END),                                                                    
 BUYQTY = SUM(CASE WHEN SELL_BUY = 1 THEN TRADEQTY ELSE 0 END),                       
 BUYRATE = (CASE WHEN SELL_BUY = 1 THEN PNLRATE ELSE 0 END),                                                                    
 BUYVAL = -SUM(CASE WHEN SELL_BUY = 1 THEN PNLRATE*TRADEQTY ELSE 0 END),                                                                    
 PNL = SUM(CASE WHEN SELL_BUY = 1 THEN -PNLRATE*TRADEQTY ELSE PNLRATE*TRADEQTY END),                                                                    
 OPPDATE,                                                                    
 FLAG=RECTYPE,                                                     
 SCRIP_NAME = CONVERT(VARCHAR(50), ''),                              
 BRANCH_CD = '',                                                                   
 CL_RATE = CONVERT(NUMERIC(18,2), 0), CLVAL = CONVERT(NUMERIC(18,2), 0),                                                
 LONG_NAME = '',                                                
 L_ADDRESS1= '',                                                
 L_ADDRESS2= '',                                                
 L_ADDRESS3= '',                                                
 L_CITY= '',                                                
 L_STATE= '',                                                
 L_NATION= '',                                                
 L_ZIP= '',                                                        
SUB_BROKER = '',                                    
TRADER  = '',                     
FAMILY  = '',                                    
AREA  = '',                                    
REGION  = ''                                    
 FROM #TBL_PNL_DATA_N T WITH (NOLOCK) --, #CLIENT_DETAILS C WITH (NOLOCK)                                                                     
 WHERE T.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY                                                                      
 --AND C.CL_CODE = T.PARTY_CODE                                                 
 --AND BRANCH_CD = (CASE WHEN @BRANCH_CD = '' OR @BRANCH_CD = 'ALL' THEN BRANCH_CD ELSE @BRANCH_CD END)                                                                    
 AND (SAUDA_DATE BETWEEN @FROMDATE AND @TODATE + ' 23:59'                                                        
   OR OPPDATE BETWEEN @FROMDATE AND @TODATE + ' 23:59')                                                          
 AND SAUDA_DATE <= @TODATE + ' 23:59'                                                               
 AND OPPDATE <= @TODATE + ' 23:59'                                                        
 /*AND @STATUSNAME = (CASE                                                                                   
       WHEN @STATUSID = 'BRANCH' THEN C.BRANCH_CD                                                                           
       WHEN @STATUSID = 'SUBBROKER' THEN C.SUB_BROKER                                                                   
       WHEN @STATUSID = 'TRADER' THEN C.TRADER                                                                                  
       WHEN @STATUSID = 'FAMILY' THEN C.FAMILY                                                                                  
       WHEN @STATUSID = 'AREA' THEN C.AREA                                                                                  
       WHEN @STATUSID = 'REGION' THEN C.REGION                                                                          
       WHEN @STATUSID = 'CLIENT' THEN C.PARTY_CODE                                                                                  
       ELSE                                                                                   
       'BROKER'                                                                                  
       END)*/                             
 AND BILLFLAG < 4                                   
 GROUP BY SAUDA_DATE, SETT_NO, SETT_TYPE, T.PARTY_CODE,EXCHANGE,                                                                     
 SCRIP_CD, SERIES, BSECODE, ISIN, PNLRATE, SELL_BUY, OPPDATE,                                     
 /*                                    
 BRANCH_CD,                                                
 C.LONG_NAME,                                                
 L_ADDRESS1,                                                
 L_ADDRESS2,                                                
 L_ADDRESS3,                                                
 L_CITY,                                                
 L_STATE,             
 L_NATION,                                                
 L_ZIP,                                    
 */                                    
 RECTYPE                                                                    
                                   
 INSERT INTO #TBL_PNL_DATA                                                                   
 SELECT SAUDA_DATE, SETT_NO, SETT_TYPE, T.PARTY_CODE,                                                                     
 SCRIP_CD, SERIES, BSECODE, ISIN,                                                                     
 SELLQTY = SUM(CASE WHEN SELL_BUY = 2 THEN TRADEQTY ELSE 0 END),                                                                     
 SELLRATE = (CASE WHEN SELL_BUY = 2 THEN PNLRATE ELSE 0 END),                                            
 SELLVAL = SUM(CASE WHEN SELL_BUY = 2 THEN PNLRATE*TRADEQTY ELSE 0 END),                                                                    
 BUYQTY = SUM(CASE WHEN SELL_BUY = 1 THEN TRADEQTY ELSE 0 END),                                                                     
 BUYRATE = (CASE WHEN SELL_BUY = 1 THEN PNLRATE ELSE 0 END),                                                                    
 BUYVAL = -SUM(CASE WHEN SELL_BUY = 1 THEN PNLRATE*TRADEQTY ELSE 0 END),                                                                    
 PNL = SUM(CASE WHEN SELL_BUY = 1 THEN -PNLRATE*TRADEQTY ELSE PNLRATE*TRADEQTY END),                                                                    
 OPPDATE,                                               
 FLAG = (CASE WHEN BILLFLAG = 5                          
     THEN '1OPEN'                                          
     ELSE 'FREE'                                          
   END),                                          
 SCRIP_NAME = CONVERT(VARCHAR(50), ''),                                     
 BRANCH_CD = '',                                    
 CL_RATE = CONVERT(NUMERIC(18,2), 0), CLVAL = CONVERT(NUMERIC(18,2), 0),                                                
 LONG_NAME = '',                                                
 L_ADDRESS1= '',                                                
 L_ADDRESS2= '',                                                
 L_ADDRESS3= '',                                                
 L_CITY= '',                                                
 L_STATE= '',                                                
 L_NATION= '',                                                
 L_ZIP= '',                                    
SUB_BROKER = '',                                    
TRADER  = '',                                    
FAMILY  = '',                                    
AREA  = '',                                  
REGION  = ''                                    
 FROM #TBL_PNL_DATA_N T WITH (NOLOCK) --, #CLIENT_DETAILS C WITH (NOLOCK)                                                                      
 WHERE T.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY                                                                      
 --AND C.CL_CODE = T.PARTY_CODE                                                                       
 --AND BRANCH_CD = (CASE WHEN @BRANCH_CD = '' OR @BRANCH_CD = 'ALL' THEN BRANCH_CD ELSE @BRANCH_CD END)                                                       
 /*AND (SAUDA_DATE BETWEEN @FROMDATE AND @TODATE + ' 23:59'                                                                     
   OR OPPDATE BETWEEN @FROMDATE AND @TODATE + ' 23:59')*/                                            
 AND SAUDA_DATE <= @TODATE + ' 23:59'                                                
 /*AND @STATUSNAME = (CASE                                                                                   
       WHEN @STATUSID = 'BRANCH' THEN C.BRANCH_CD                                                                                  
       WHEN @STATUSID = 'SUBBROKER' THEN C.SUB_BROKER                                                                                  
       WHEN @STATUSID = 'TRADER' THEN C.TRADER                                                                                  
       WHEN @STATUSID = 'FAMILY' THEN C.FAMILY                                                                                  
       WHEN @STATUSID = 'AREA' THEN C.AREA                                                      
       WHEN @STATUSID = 'REGION' THEN C.REGION                                                                                  
       WHEN @STATUSID = 'CLIENT' THEN C.PARTY_CODE                                                                                  
       ELSE                                                                                   
       'BROKER'                                                                                  
       END)*/                                                                      
 AND OPPDATE > @TODATE                                                            
 AND BILLFLAG <> (CASE WHEN @RPTOPENSELL = 'W' THEN 0 ELSE 5 END)                                          
 AND SAUDA_DATE >= (CASE WHEN BILLFLAG = 5 THEN @FINYEARFROM ELSE 'APR  1 2000' END)                                             
 GROUP BY SAUDA_DATE, SETT_NO, SETT_TYPE, T.PARTY_CODE,                                         
 SCRIP_CD, SERIES, BSECODE, ISIN, PNLRATE, SELL_BUY, OPPDATE,                              
 /*                                    
 BRANCH_CD,                                                
 C.LONG_NAME,                                                
 L_ADDRESS1,                                                
 L_ADDRESS2,                                                
 L_ADDRESS3,                 
 L_CITY,                                                
 L_STATE,                                                
 L_NATION,                                                
 L_ZIP,*/                                    
 BILLFLAG                                                                
END                                      
                                    
                                    
                                                                     
 UPDATE #TBL_PNL_DATA SET SCRIP_NAME = LEFT(S1.LONG_NAME, 50)                                         
 FROM MSAJAG.DBO.SCRIP2 S2 WITH (NOLOCK), MSAJAG.DBO.SCRIP1 S1 WITH (NOLOCK)                                                         
 WHERE S2.CO_CODE = S1.CO_CODE                         
 AND S2.SERIES = S1.SERIES                                                                      
 AND #TBL_PNL_DATA.SCRIP_CD = S2.SCRIP_CD                                                                      
 AND #TBL_PNL_DATA.SERIES = S2.SERIES                                                                      
 AND SCRIP_NAME = ''                                                                      
                                                                       
 UPDATE #TBL_PNL_DATA SET SCRIP_NAME = LEFT(S1.LONG_NAME, 50)                                                                      
 FROM AngelBSECM.BSEDB_AB.DBO.SCRIP2 S2 WITH (NOLOCK), AngelBSECM.BSEDB_AB.DBO.SCRIP1 S1 WITH (NOLOCK)                                               
 WHERE S2.CO_CODE = S1.CO_CODE                                                
 AND S2.SERIES = S1.SERIES                                                                      
 AND #TBL_PNL_DATA.BSECODE = S2.BSECODE                                                                      
 AND SCRIP_NAME = ''                                                                      
                                      
 UPDATE #TBL_PNL_DATA SET CL_RATE = C.CL_RATE FROM MSAJAG.DBO.CLOSING C WITH (NOLOCK)                                                                  
 WHERE SYSDATE BETWEEN @CL_DATE AND @CL_DATE + ' 23:59'                                    
 AND C.SCRIP_CD = #TBL_PNL_DATA.SCRIP_CD                                                                                        
 AND C.SERIES = #TBL_PNL_DATA.SERIES                                       
 AND #TBL_PNL_DATA.CL_RATE = 0                                                              
 AND FLAG = 'FREE'                    
                     
                                     
                                       
 UPDATE #TBL_PNL_DATA SET CL_RATE = C.CL_RATE FROM MSAJAG.DBO.CLOSING C WITH (NOLOCK)                                               
 WHERE SYSDATE BETWEEN @CL_DATE AND @CL_DATE + ' 23:59'                                    
 AND C.SCRIP_CD = #TBL_PNL_DATA.SCRIP_CD                                                                                                  
 AND #TBL_PNL_DATA.SERIES IN ('EQ','BE')                                                                                                  
 AND C.SERIES IN ('EQ','BE')                                                                           
 AND #TBL_PNL_DATA.CL_RATE = 0                                        
 AND FLAG = 'FREE'                         
                     
                                    
                     
                                                                 
 UPDATE #TBL_PNL_DATA SET CL_RATE = C.CL_RATE FROM MSAJAG.DBO.CLOSING C WITH (NOLOCK)                                                                  
 WHERE SYSDATE BETWEEN @CL_DATE AND @CL_DATE + ' 23:59'                                    
 AND C.SCRIP_CD = #TBL_PNL_DATA.SCRIP_CD                                                                           
 AND C.SERIES = #TBL_PNL_DATA.SERIES                                       
 AND C.SERIES NOT IN ('EQ','BE')                                                                                           
 AND #TBL_PNL_DATA.CL_RATE = 0                                                           
 AND FLAG = 'FREE'                                 
                     
                                                                 
 UPDATE #TBL_PNL_DATA SET CL_RATE = C.CL_RATE FROM AngelBSECM.BSEDB_AB.DBO.CLOSING C WITH (NOLOCK)                                                                  
 WHERE SYSDATE BETWEEN @CL_DATE AND @CL_DATE + ' 23:59'                                    
 AND C.SCRIP_CD = #TBL_PNL_DATA.BSECODE                                                                                                  
 AND #TBL_PNL_DATA.CL_RATE = 0                                                                  
 AND FLAG = 'FREE'                                          
                     
                                      
               
 UPDATE #TBL_PNL_DATA SET CL_RATE = C.CL_RATE FROM MSAJAG.DBO.CLOSING C  WITH (NOLOCK)                                              
 WHERE SYSDATE = (SELECT MAX(SYSDATE) FROM MSAJAG.DBO.CLOSING C1 WITH (NOLOCK)                               
      WHERE C1.SCRIP_CD = C.SCRIP_CD                                                               
      AND C.SERIES IN ('EQ','BE')                                                                             
      AND C1.SERIES IN ('EQ','BE')                                                                        
      AND SYSDATE <= @TODATE + ' 23:59' )                                                                                            
 AND C.SCRIP_CD = #TBL_PNL_DATA.SCRIP_CD                                             
 AND #TBL_PNL_DATA.SERIES IN ('EQ','BE')                              
 AND C.SERIES IN ('EQ','BE')                                                                           
 AND #TBL_PNL_DATA.CL_RATE = 0                                                                   
 AND FLAG = 'FREE'                                                                  
                     
                                  
                                                      
 UPDATE #TBL_PNL_DATA SET CL_RATE = C.CL_RATE FROM MSAJAG.DBO.CLOSING C  WITH (NOLOCK)                                                                 
 WHERE SYSDATE = (SELECT MAX(SYSDATE) FROM MSAJAG.DBO.CLOSING C1 WITH (NOLOCK)                                                           
      WHERE C1.SCRIP_CD = C.SCRIP_CD                                                                                                  
      AND C.SERIES = C.SERIES                             
      AND SYSDATE <= @TODATE + ' 23:59' )                                                                                            
 AND C.SCRIP_CD = #TBL_PNL_DATA.SCRIP_CD                                                                                        
 AND C.SERIES = #TBL_PNL_DATA.SERIES                                      
 AND C.SERIES NOT IN ('EQ','BE')                                   
 AND #TBL_PNL_DATA.CL_RATE = 0                                                                     
 AND FLAG = 'FREE'                                                                                              
                     
                                     
                                                    
 UPDATE #TBL_PNL_DATA SET CL_RATE = C.CL_RATE FROM AngelBSECM.BSEDB_AB.DBO.CLOSING C WITH (NOLOCK)                                                                  
 WHERE SYSDATE = (SELECT MAX(SYSDATE) FROM AngelBSECM.BSEDB_AB.DBO.CLOSING C1 WITH (NOLOCK)                                           
      WHERE C1.SCRIP_CD = C.SCRIP_CD                                                                                               
      AND SYSDATE <= @TODATE + ' 23:59' )                                                           
 AND C.SCRIP_CD = #TBL_PNL_DATA.BSECODE                                                                                                  
 AND #TBL_PNL_DATA.CL_RATE = 0                                                                  
 AND FLAG = 'FREE'                                              
                     
                    
                                                                  
 UPDATE #TBL_PNL_DATA SET                                                                   
 CLVAL = (CASE WHEN BUYQTY = 0 THEN -SELLQTY*CL_RATE ELSE BUYQTY*CL_RATE END),                                                               
 PNL = (CASE WHEN BUYQTY = 0 THEN -SELLQTY*CL_RATE+PNL ELSE PNL+BUYQTY*CL_RATE END)                                                                  
 WHERE FLAG = 'FREE'                                                                  
                                    
                                    
 UPDATE                                     
 #TBL_PNL_DATA                                     
 SET                                    
 BRANCH_CD = ISNULL(C.BRANCH_CD,''),                                    
 LONG_NAME = ISNULL(C.LONG_NAME,''),                                    
 L_ADDRESS1 = ISNULL(C.L_ADDRESS1,''),                                    
 L_ADDRESS2 = ISNULL(C.L_ADDRESS2,''),                                    
 L_ADDRESS3 = ISNULL(C.L_ADDRESS3,''),                                    
 L_CITY  = ISNULL(C.L_CITY,''),                                    
 L_STATE  = ISNULL(C.L_STATE,''),                                    
 L_NATION = ISNULL(C.L_NATION,''),                                    
 L_ZIP  = ISNULL(C.L_ZIP,''),                                    
 SUB_BROKER = ISNULL(C.SUB_BROKER,''),                                    
    TRADER  = ISNULL(C.TRADER,''),                                    
    FAMILY  = ISNULL(C.FAMILY,''),                                    
    AREA  = ISNULL(C.AREA,''),                                    
    REGION  = ISNULL(C.REGION,'')                                    
 FROM                                    
 #CLIENT_DETAILS C                                    
 WHERE                                    
 #TBL_PNL_DATA.PARTY_CODE = C.CL_CODE                                     
                                    
                                    
/*                                    
SELECT * FROM #TBL_PNL_DATA                                    
RETURN                                    
*/                                    
                                                              
IF @RPTOPT = 'S'                                                               
BEGIN                                                              
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
 PNL=ROUND(SUM(PNL),2),FLAG,SCRIP_NAME,                                    
 BRANCH_CD = BRANCH_CD,CL_RATE,CLVAL=SUM(CLVAL),                                                               
 TAX = ROUND((CASE WHEN FLAG = 'SHORT TERM'                                           
       THEN SUM(PNL) * 15 / 100                                           
       WHEN FLAG = 'SPECULATION'                                           
       THEN SUM(PNL) * 30 / 100                                           
       ELSE 0                                           
     END),2),                                                 
 LONG_NAME,                                                
 L_ADDRESS1,                                                
 L_ADDRESS2,                      
 L_ADDRESS3,                                                
 L_CITY,                                                
 L_STATE,                                                
 L_NATION,                                                
 L_ZIP                                      
 FROM                                     
 #TBL_PNL_DATA T                                    
 WHERE                                    
 PARTY_CODE IN (SELECT DISTINCT PARTY_CODE FROM #CLIENT_DETAILS )         
    /*                                    
 BRANCH_CD = (CASE WHEN @BRANCH_CD = '' OR @BRANCH_CD = 'ALL' THEN BRANCH_CD ELSE @BRANCH_CD END)                                    
 AND @STATUSNAME = (CASE                                                                                   
       WHEN @STATUSID = 'BRANCH' THEN BRANCH_CD                                                                                  
       WHEN @STATUSID = 'SUBBROKER' THEN SUB_BROKER                          
       WHEN @STATUSID = 'TRADER' THEN TRADER                                                       
       WHEN @STATUSID = 'FAMILY' THEN FAMILY                                                                                  
       WHEN @STATUSID = 'AREA' THEN AREA                                                      
       WHEN @STATUSID = 'REGION' THEN REGION                                                                                  
       WHEN @STATUSID = 'CLIENT' THEN PARTY_CODE                                                                                  
       ELSE                                                  
     'BROKER'                                                                                  
       END)*/                                    
                                                                            
 GROUP BY T.PARTY_CODE,/*SCRIP_CD/*,SERIES*/,BSECODE,*/ISIN,FLAG,SCRIP_NAME,BRANCH_CD,CL_RATE,                                                 
 LONG_NAME,                  
 L_ADDRESS1,                                                
 L_ADDRESS2,                                                
 L_ADDRESS3,                                                
 L_CITY,                                          
 L_STATE,                     
 L_NATION,                                                
 L_ZIP                                                               
 ORDER BY T.PARTY_CODE, FLAG DESC, SCRIP_NAME, /*SCRIP_CD, /*SERIES,*/ BSECODE,*/ ISIN                                                                    
END                                                              
ELSE                                                              
BEGIN                                                               
 SELECT SAUDA_DATE1=SAUDA_DATE,SAUDA_DATE=CONVERT(VARCHAR,SAUDA_DATE,103),SETT_NO,/*SETT_TYPE,          */                          
 PARTY_CODE = C.PARTY_CODE,SCRIP_CD,/*SERIES,*/BSECODE,ISIN,                                                  
 SELLQTY,SELLRATE=ROUND(SELLRATE,2),SELLVAL=ROUND(SELLVAL,2),                                                  
 BUYQTY,BUYRATE=ROUND(BUYRATE,2),BUYVAL=ROUND(BUYVAL,2),                                                  
 PNL=ROUND(PNL,2),OPPDATE=CONVERT(VARCHAR,OPPDATE,103),FLAG,SCRIP_NAME,C.BRANCH_CD,CL_RATE,                                                  
 CLVAL,  TAX = ROUND((CASE WHEN FLAG = 'SHORT TERM'                                           
       THEN PNL * 15 / 100                                           
       WHEN FLAG = 'SPECULATION'                     
       THEN PNL * 30 / 100                                           
       ELSE 0                                           
     END),2),                                                
 C.LONG_NAME,                                                
 C.L_ADDRESS1,                                                
 C.L_ADDRESS2,                                                
 C.L_ADDRESS3,                                                
 C.L_CITY,                                                
 C.L_STATE,                   
 C.L_NATION,                                                
 C.L_ZIP                                                 
 FROM                                     
    #TBL_PNL_DATA C                                    
 WHERE                                    
 PARTY_CODE IN (SELECT DISTINCT PARTY_CODE FROM #CLIENT_DETAILS )     AND FLAG = 'LONG TERM'                                                         
 /*                                    
    C.BRANCH_CD = (CASE WHEN @BRANCH_CD = '' OR @BRANCH_CD = 'ALL' THEN C.BRANCH_CD ELSE @BRANCH_CD END)                                    
 AND @STATUSNAME = (CASE                                                                                   
       WHEN @STATUSID = 'BRANCH' THEN C.BRANCH_CD                                                                                  
       WHEN @STATUSID = 'SUBBROKER' THEN C.SUB_BROKER                                                   
       WHEN @STATUSID = 'TRADER' THEN C.TRADER                                                                                  
       WHEN @STATUSID = 'FAMILY' THEN C.FAMILY                                                                                  
       WHEN @STATUSID = 'AREA' THEN C.AREA                                                      
       WHEN @STATUSID = 'REGION' THEN C.REGION                                                                                  
       WHEN @STATUSID = 'CLIENT' THEN C.PARTY_CODE                                                                                  
       ELSE                                            
       'BROKER'                                                                                  
       END)*/                                    
 ORDER BY C.PARTY_CODE, FLAG DESC, SCRIP_NAME,/* SCRIP_CD, /*SERIES,*/ BSECODE,*/ ISIN, 1, SAUDA_DATE, OPPDATE         
                                                                  
END      
      
DROP TABLE  #TBL_PNL_DATA      
DROP TABLE  #TBL_PNL_DATA_N

GO
