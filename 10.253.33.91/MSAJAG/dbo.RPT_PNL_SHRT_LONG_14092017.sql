-- Object: PROCEDURE dbo.RPT_PNL_SHRT_LONG_14092017
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



CREATE PROC [dbo].[RPT_PNL_SHRT_LONG]                                
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
 @RptOpenSell Varchar(1)                                
)                                  
                                
AS      
      
        
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
                            
 SELECT SAUDA_DATE=SAUDA_DATE, SETT_NO, SETT_TYPE, T.PARTY_CODE,                                   
 SCRIP_CD, SERIES, BSECODE, ISIN,                                   
 SELLQTY = (CASE WHEN SELL_BUY = 2 THEN TRADEQTY ELSE 0 END),                                   
 SELLRATE = (CASE WHEN SELL_BUY = 2 THEN MARKETRATE ELSE 0 END),                                  
 SELLVAL = (CASE WHEN SELL_BUY = 2 THEN MARKETRATE*TRADEQTY ELSE 0 END),                                  
 BUYQTY = (CASE WHEN SELL_BUY = 1 THEN TRADEQTY ELSE 0 END),                                   
 BUYRATE = (CASE WHEN SELL_BUY = 1 THEN MARKETRATE ELSE 0 END),                                  
 BUYVAL = -(CASE WHEN SELL_BUY = 1 THEN MARKETRATE*TRADEQTY ELSE 0 END),                                  
 PNL = (CASE WHEN SELL_BUY = 1 THEN -MARKETRATE*TRADEQTY ELSE MARKETRATE*TRADEQTY END),                                  
 OPPDATE=OPPDATE,                                  
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
 MARKETTYPE = CONVERT(VARCHAR(2),'')               
 INTO #TBL_PNL_DATA                                  
 FROM TBL_PNL_DATA T                            
 WHERE 1 = 2                             
                                
IF @CHARGES = 'N'                                 
BEGIN                                
 INSERT INTO #TBL_PNL_DATA                              
 SELECT SAUDA_DATE=LEFT(SAUDA_DATE,11), SETT_NO, SETT_TYPE, T.PARTY_CODE,                                   
 SCRIP_CD, SERIES, BSECODE, ISIN,                                   
 SELLQTY = SUM(CASE WHEN SELL_BUY = 2 THEN TRADEQTY ELSE 0 END),                                   
 SELLRATE = (CASE WHEN SELL_BUY = 2 THEN MARKETRATE ELSE 0 END),                                  
 SELLVAL = SUM(CASE WHEN SELL_BUY = 2 THEN MARKETRATE*TRADEQTY ELSE 0 END),                                  
 BUYQTY = SUM(CASE WHEN SELL_BUY = 1 THEN TRADEQTY ELSE 0 END),                                   
 BUYRATE = (CASE WHEN SELL_BUY = 1 THEN MARKETRATE ELSE 0 END),                         
 BUYVAL = -SUM(CASE WHEN SELL_BUY = 1 THEN MARKETRATE*TRADEQTY ELSE 0 END),                                  
 PNL = SUM(CASE WHEN SELL_BUY = 1 THEN -MARKETRATE*TRADEQTY ELSE MARKETRATE*TRADEQTY END),                                  
 OPPDATE=LEFT(OPPDATE,11),                                  
 FLAG = RECTYPE,                               
 SCRIP_NAME = CONVERT(VARCHAR(50), ''), BRANCH_CD,                                 
 CL_RATE = CONVERT(NUMERIC(18,2), 0), CLVAL = CONVERT(NUMERIC(18,2), 0),              
 C.LONG_NAME,              
 L_ADDRESS1,              
 L_ADDRESS2,              
 L_ADDRESS3,         
 L_CITY,              
 L_STATE,              
 L_NATION,              
 L_ZIP,    
 MARKETTYPE = MAX(MARKETTYPE)             
 FROM TBL_PNL_DATA T WITH (NOLOCK), CLIENT_DETAILS C WITH (NOLOCK)                           
 WHERE C.CL_CODE BETWEEN @FROMPARTY AND @TOPARTY                                    
 AND C.CL_CODE = T.PARTY_CODE             
 AND BRANCH_CD = (CASE WHEN @BRANCH_CD = '' OR @BRANCH_CD = 'ALL' THEN BRANCH_CD ELSE @BRANCH_CD END)                                  
 AND (SAUDA_DATE BETWEEN @FROMDATE AND @TODATE + ' 23:59'                                   
   OR OPPDATE BETWEEN @FROMDATE AND @TODATE + ' 23:59')                                
 AND SAUDA_DATE <= @TODATE + ' 23:59'                                
 AND OPPDATE <= @TODATE + ' 23:59'                                
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
 AND BILLFLAG < 4                                  
 GROUP BY SAUDA_DATE, SETT_NO, SETT_TYPE, T.PARTY_CODE,EXCHANGE,                                   
 SCRIP_CD, SERIES, BSECODE, ISIN, MARKETRATE, SELL_BUY, MARGINDATE, OPPDATE, BRANCH_CD,C.LONG_NAME,              
 L_ADDRESS1,              
 L_ADDRESS2,              
 L_ADDRESS3,              
 L_CITY,              
 L_STATE,              
 L_NATION,              
 L_ZIP,RECTYPE                                  
                                
 INSERT  INTO #TBL_PNL_DATA                                  
 SELECT SAUDA_DATE=LEFT(SAUDA_DATE,11), SETT_NO, SETT_TYPE, T.PARTY_CODE,                                   
 SCRIP_CD, SERIES, BSECODE, ISIN,                                   
 SELLQTY = SUM(CASE WHEN SELL_BUY = 2 THEN TRADEQTY ELSE 0 END),                                   
 SELLRATE = (CASE WHEN SELL_BUY = 2 THEN MARKETRATE ELSE 0 END),                                  
 SELLVAL = SUM(CASE WHEN SELL_BUY = 2 THEN MARKETRATE*TRADEQTY ELSE 0 END),                                  
 BUYQTY = SUM(CASE WHEN SELL_BUY = 1 THEN TRADEQTY ELSE 0 END),                                   
 BUYRATE = (CASE WHEN SELL_BUY = 1 THEN MARKETRATE ELSE 0 END),                                  
 BUYVAL = -SUM(CASE WHEN SELL_BUY = 1 THEN MARKETRATE*TRADEQTY ELSE 0 END),                                  
 PNL = SUM(CASE WHEN SELL_BUY = 1 THEN -MARKETRATE*TRADEQTY ELSE MARKETRATE*TRADEQTY END),                                  
 OPPDATE=LEFT(OPPDATE,11),                                  
 FLAG = (CASE WHEN BILLFLAG = 5         
     THEN '1OPEN'        
     ELSE 'FREE'        
   END),                                  
 SCRIP_NAME = CONVERT(VARCHAR(50), ''), BRANCH_CD,                                 
 CL_RATE = CONVERT(NUMERIC(18,2), 0), CLVAL = CONVERT(NUMERIC(18,2), 0),              
 C.LONG_NAME,              
 L_ADDRESS1,              
 L_ADDRESS2,              
 L_ADDRESS3,              
 L_CITY,              
 L_STATE,              
 L_NATION,              
 L_ZIP,    
 MARKETTYPE = MAX(MARKETTYPE)                                 
 FROM TBL_PNL_DATA T WITH (NOLOCK), CLIENT_DETAILS C WITH (NOLOCK)                                   
 WHERE C.CL_CODE BETWEEN @FROMPARTY AND @TOPARTY                                    
 AND C.CL_CODE = T.PARTY_CODE                                     
 /*AND (SAUDA_DATE BETWEEN @FROMDATE AND @TODATE + ' 23:59'                                   
   OR OPPDATE BETWEEN @FROMDATE AND @TODATE + ' 23:59')*/          
 AND BRANCH_CD = (CASE WHEN @BRANCH_CD = '' OR @BRANCH_CD = 'ALL' THEN BRANCH_CD ELSE @BRANCH_CD END)                                  
 AND SAUDA_DATE <= @TODATE + ' 23:59'                                  
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
 AND OPPDATE > @TODATE                                 
 AND BILLFLAG <> (CASE WHEN @RptOpenSell = 'W' THEN 0 ELSE 5 END)        
 AND SAUDA_DATE >= (CASE WHEN BILLFLAG = 5 THEN @FINYEARFROM ELSE 'APR  1 2000' END)        
 GROUP BY SAUDA_DATE, SETT_NO, SETT_TYPE, T.PARTY_CODE,                                   
 SCRIP_CD, SERIES, BSECODE, ISIN, MARKETRATE, SELL_BUY, MARGINDATE, OPPDATE, BRANCH_CD,              
C.LONG_NAME,              
 L_ADDRESS1,              
 L_ADDRESS2,              
 L_ADDRESS3,              
 L_CITY,              
 L_STATE,              
 L_NATION,              
 L_ZIP,BILLFLAG                                 
END                            
ELSE                            
BEGIN                 
           
 INSERT INTO #TBL_PNL_DATA   
 SELECT SAUDA_DATE, SETT_NO, sett_type, PARTY_CODE, SCRIP_CD, SERIES, BSECODE, ISIN,  
 SELLQTY = SUM(SELLQTY), 
 SELLRATE = (CASE WHEN SUM(SELLQTY) > 0 THEN SUM(SELLRATE*SELLQTY)/SUM(SELLQTY) ELSE 0 END),  
 SELLVAL = SUM(SELLVAL),  
 BUYQTY = SUM(BUYQTY), 
 BUYRATE = (CASE WHEN SUM(BUYQTY) > 0 THEN SUM(BUYRATE*BUYQTY)/SUM(BUYQTY) ELSE 0 END),  
 BUYVAL = SUM(BUYVAL),PNL=SUM(PNL),  
 OPPDATE,FLAG,SCRIP_NAME,BRANCH_CD,CL_RATE,CLVAL,LONG_NAME,              
 L_ADDRESS1,              
 L_ADDRESS2,              
 L_ADDRESS3,              
 L_CITY,              
 L_STATE,              
 L_NATION,              
 L_ZIP,    
 MARKETTYPE FROM (  
 SELECT   
 SAUDA_DATE=(CASE WHEN SELL_BUY = 1 THEN LEFT(SAUDA_DATE,11) ELSE LEFT(OPPDATE,11) END),   
 SETT_NO='', SETT_TYPE='', T.PARTY_CODE,                                   
 SCRIP_CD, SERIES, BSECODE, ISIN,                                   
 SELLQTY = SUM(CASE WHEN SELL_BUY = 2 THEN TRADEQTY ELSE 0 END),                                   
 SELLRATE = (CASE WHEN SELL_BUY = 2 THEN PNLRATE ELSE 0 END),                                  
 SELLVAL = SUM(CASE WHEN SELL_BUY = 2 THEN PNLRATE*TRADEQTY ELSE 0 END),                                  
 BUYQTY = SUM(CASE WHEN SELL_BUY = 1 THEN TRADEQTY ELSE 0 END),                                   
 BUYRATE = (CASE WHEN SELL_BUY = 1 THEN PNLRATE ELSE 0 END),                                  
 BUYVAL = -SUM(CASE WHEN SELL_BUY = 1 THEN PNLRATE*TRADEQTY ELSE 0 END),                                  
 PNL = SUM(CASE WHEN SELL_BUY = 1 THEN -PNLRATE*TRADEQTY ELSE PNLRATE*TRADEQTY END),                                  
 OPPDATE=(CASE WHEN SELL_BUY = 2 THEN LEFT(SAUDA_DATE,11) ELSE LEFT(OPPDATE,11) END),                                  
 FLAG = RECTYPE,                                  
 SCRIP_NAME = CONVERT(VARCHAR(50), ''), BRANCH_CD,                                 
 CL_RATE = CONVERT(NUMERIC(18,2), 0), CLVAL = CONVERT(NUMERIC(18,2), 0),              
 C.LONG_NAME,              
 L_ADDRESS1,              
 L_ADDRESS2,              
 L_ADDRESS3,              
 L_CITY,              
 L_STATE,              
 L_NATION,              
 L_ZIP,    
 MARKETTYPE = MAX(MARKETTYPE)                                   
 FROM TBL_PNL_DATA T WITH (NOLOCK), CLIENT_DETAILS C WITH (NOLOCK)                                   
 WHERE C.CL_CODE BETWEEN @FROMPARTY AND @TOPARTY                                    
 AND C.CL_CODE = T.PARTY_CODE                                     
 AND BRANCH_CD = (CASE WHEN @BRANCH_CD = '' OR @BRANCH_CD = 'ALL' THEN BRANCH_CD ELSE @BRANCH_CD END)                                  
 AND (SAUDA_DATE BETWEEN @FROMDATE AND @TODATE + ' 23:59'                                   
   OR OPPDATE BETWEEN @FROMDATE AND @TODATE + ' 23:59')                                
 AND SAUDA_DATE <= @TODATE + ' 23:59'                             
 AND OPPDATE <= @TODATE + ' 23:59'                                
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
 AND BILLFLAG < 4                                  
 GROUP BY (CASE WHEN SELL_BUY = 1 THEN LEFT(SAUDA_DATE,11) ELSE LEFT(OPPDATE,11) END), T.PARTY_CODE,EXCHANGE,                                   
 SCRIP_CD, SERIES, BSECODE, ISIN, PNLRATE, SELL_BUY, MARGINDATE, (CASE WHEN SELL_BUY = 2 THEN LEFT(SAUDA_DATE,11) ELSE LEFT(OPPDATE,11) END), BRANCH_CD,              
 C.LONG_NAME,              
 L_ADDRESS1,              
 L_ADDRESS2,              
 L_ADDRESS3,              
 L_CITY,              
 L_STATE,              
 L_NATION,              
 L_ZIP,RECTYPE     ) A  
 GROUP BY    SAUDA_DATE, SETT_NO, sett_type, PARTY_CODE, SCRIP_CD, SERIES, BSECODE, ISIN,  
 OPPDATE,FLAG,SCRIP_NAME,BRANCH_CD,CL_RATE,CLVAL,LONG_NAME,              
 L_ADDRESS1,              
 L_ADDRESS2,              
 L_ADDRESS3,              
 L_CITY,              
 L_STATE,              
 L_NATION,              
 L_ZIP,    
 MARKETTYPE                          
                                
 INSERT INTO #TBL_PNL_DATA                                 
 SELECT SAUDA_DATE=LEFT(SAUDA_DATE,11), SETT_NO, SETT_TYPE, T.PARTY_CODE,                                   
 SCRIP_CD, SERIES, BSECODE, ISIN,                                   
 SELLQTY = SUM(CASE WHEN SELL_BUY = 2 THEN TRADEQTY ELSE 0 END),                                   
 SELLRATE = (CASE WHEN SELL_BUY = 2 THEN PNLRATE ELSE 0 END),                                  
 SELLVAL = SUM(CASE WHEN SELL_BUY = 2 THEN PNLRATE*TRADEQTY ELSE 0 END),                                  
 BUYQTY = SUM(CASE WHEN SELL_BUY = 1 THEN TRADEQTY ELSE 0 END),                                   
 BUYRATE = (CASE WHEN SELL_BUY = 1 THEN PNLRATE ELSE 0 END),                                  
 BUYVAL = -SUM(CASE WHEN SELL_BUY = 1 THEN PNLRATE*TRADEQTY ELSE 0 END),                                  
 PNL = SUM(CASE WHEN SELL_BUY = 1 THEN -PNLRATE*TRADEQTY ELSE PNLRATE*TRADEQTY END),                                  
 OPPDATE=LEFT(OPPDATE,11),                 
 FLAG = (CASE WHEN BILLFLAG = 5         
     THEN '1OPEN'        
     ELSE 'FREE'        
   END),        
 SCRIP_NAME = CONVERT(VARCHAR(50), ''), BRANCH_CD,                                 
    CL_RATE = CONVERT(NUMERIC(18,2), 0), CLVAL = CONVERT(NUMERIC(18,2), 0),              
 C.LONG_NAME,              
 L_ADDRESS1,              
 L_ADDRESS2,              
 L_ADDRESS3,              
 L_CITY,              
 L_STATE,              
 L_NATION,              
 L_ZIP,    
 MARKETTYPE = MAX(MARKETTYPE)                                 
 FROM TBL_PNL_DATA T WITH (NOLOCK), CLIENT_DETAILS C WITH (NOLOCK)                                    
 WHERE C.CL_CODE BETWEEN @FROMPARTY AND @TOPARTY                                    
 AND C.CL_CODE = T.PARTY_CODE                                     
 AND BRANCH_CD = (CASE WHEN @BRANCH_CD = '' OR @BRANCH_CD = 'ALL' THEN BRANCH_CD ELSE @BRANCH_CD END)                                  
 /*AND (SAUDA_DATE BETWEEN @FROMDATE AND @TODATE + ' 23:59'                                   
   OR OPPDATE BETWEEN @FROMDATE AND @TODATE + ' 23:59')*/          
 AND SAUDA_DATE <= @TODATE + ' 23:59'                                  
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
 AND OPPDATE > @TODATE                          
 AND BILLFLAG <> (CASE WHEN @RptOpenSell = 'W' THEN 0 ELSE 5 END)        
 AND SAUDA_DATE >= (CASE WHEN BILLFLAG = 5 THEN @FINYEARFROM ELSE 'APR  1 2000' END)           
 GROUP BY SAUDA_DATE, SETT_NO, SETT_TYPE, T.PARTY_CODE,                                   
 SCRIP_CD, SERIES, BSECODE, ISIN, PNLRATE, SELL_BUY, MARGINDATE, OPPDATE, BRANCH_CD,              
 C.LONG_NAME,             
 L_ADDRESS1,              
 L_ADDRESS2,              
 L_ADDRESS3,              
 L_CITY,              
 L_STATE,              
 L_NATION,              
 L_ZIP,BILLFLAG                              
END                            
                                   
 UPDATE #TBL_PNL_DATA SET SCRIP_NAME = LEFT(S1.LONG_NAME, 50)                                    
 FROM MSAJAG.DBO.SCRIP2 S2, MSAJAG.DBO.SCRIP1 S1                       
 WHERE S2.CO_CODE = S1.CO_CODE                                    
 AND S2.SERIES = S1.SERIES                                    
 AND #TBL_PNL_DATA.SCRIP_CD = S2.SCRIP_CD                                    
 AND #TBL_PNL_DATA.SERIES = S2.SERIES                                    
 AND SCRIP_NAME = ''                                    
                                     
 UPDATE #TBL_PNL_DATA SET SCRIP_NAME = LEFT(S1.LONG_NAME, 50)                                    
 FROM BSEDB.DBO.SCRIP2 S2, BSEDB.DBO.SCRIP1 S1                                    
 WHERE S2.CO_CODE = S1.CO_CODE                                    
 AND S2.SERIES = S1.SERIES                                    
 AND #TBL_PNL_DATA.BSECODE = S2.BSECODE                                    
 AND SCRIP_NAME = ''                                    
         UPDATE #TBL_PNL_DATA SET CL_RATE = C.CL_RATE FROM MSAJAG.DBO.CLOSING C              
 WHERE SYSDATE LIKE @CL_DATE + '%'        
 AND C.SCRIP_CD = #TBL_PNL_DATA.SCRIP_CD                                                                
 AND #TBL_PNL_DATA.SERIES IN ('EQ','BE')                                                                
 AND C.SERIES IN ('EQ','BE')                                         
 AND #TBL_PNL_DATA.CL_RATE = 0                                 
 AND FLAG = 'FREE'                                
                                
 UPDATE #TBL_PNL_DATA SET CL_RATE = C.CL_RATE FROM MSAJAG.DBO.CLOSING C                                 
 WHERE SYSDATE LIKE @CL_DATE + '%'                                                         
 AND C.SCRIP_CD = #TBL_PNL_DATA.SCRIP_CD                                                      
 AND C.SERIES = #TBL_PNL_DATA.SERIES                                                          
 AND #TBL_PNL_DATA.CL_RATE = 0                                   
 AND FLAG = 'FREE'                                                            
                                                                 
 UPDATE #TBL_PNL_DATA SET CL_RATE = C.CL_RATE FROM BSEDB.DBO.CLOSING C                                 
 WHERE SYSDATE LIKE @CL_DATE + '%'                                                          
 AND C.SCRIP_CD = #TBL_PNL_DATA.BSECODE                                                                
 AND #TBL_PNL_DATA.CL_RATE = 0                                
 AND FLAG = 'FREE'        
                                 
 UPDATE #TBL_PNL_DATA SET CL_RATE = C.CL_RATE FROM MSAJAG.DBO.CLOSING C              
 WHERE SYSDATE = (SELECT MAX(SYSDATE) FROM MSAJAG.DBO.CLOSING C1                                 
      WHERE C1.SCRIP_CD = C.SCRIP_CD                          
      AND C.SERIES IN ('EQ','BE')                                           
      AND C1.SERIES IN ('EQ','BE')                                                                 
      AND SYSDATE <= @TODATE + ' 23:59' )                                                          
 AND C.SCRIP_CD = #TBL_PNL_DATA.SCRIP_CD                                                                
 AND #TBL_PNL_DATA.SERIES IN ('EQ','BE')                                                                
 AND C.SERIES IN ('EQ','BE')                                         
 AND #TBL_PNL_DATA.CL_RATE = 0                                 
 AND FLAG = 'FREE'                                
                                
 UPDATE #TBL_PNL_DATA SET CL_RATE = C.CL_RATE FROM MSAJAG.DBO.CLOSING C              
 WHERE SYSDATE = (SELECT MAX(SYSDATE) FROM MSAJAG.DBO.CLOSING C1                                 
      WHERE C1.SCRIP_CD = C.SCRIP_CD                                                                
      AND C.SERIES = C.SERIES                                                          
      AND SYSDATE <= @TODATE + ' 23:59' )                                                          
 AND C.SCRIP_CD = #TBL_PNL_DATA.SCRIP_CD                                                      
 AND C.SERIES = #TBL_PNL_DATA.SERIES                                                 
 AND #TBL_PNL_DATA.CL_RATE = 0                                   
 AND FLAG = 'FREE'                                                            
                                                                 
 UPDATE #TBL_PNL_DATA SET CL_RATE = C.CL_RATE FROM BSEDB.DBO.CLOSING C                                 
 WHERE SYSDATE = (SELECT MAX(SYSDATE) FROM BSEDB.DBO.CLOSING C1                                 
      WHERE C1.SCRIP_CD = C.SCRIP_CD                                                             
      AND SYSDATE <= @TODATE + ' 23:59' )                         
 AND C.SCRIP_CD = #TBL_PNL_DATA.BSECODE                                                                
 AND #TBL_PNL_DATA.CL_RATE = 0                                
 AND FLAG = 'FREE'                     
                                
 UPDATE #TBL_PNL_DATA SET                                 
 CLVAL = (CASE WHEN BUYQTY = 0 THEN -SELLQTY*CL_RATE ELSE BUYQTY*CL_RATE END),                                
 PNL = (CASE WHEN BUYQTY = 0 THEN -SELLQTY*CL_RATE+PNL ELSE PNL+BUYQTY*CL_RATE END)                                
 WHERE FLAG = 'FREE'                                
                            
IF @RPTOPT = 'S'                             
BEGIN                            
 SELECT PARTY_CODE,SCRIP_CD,SERIES,BSECODE,ISIN,                            
 SELLQTY=SUM(SELLQTY),                
 SELLRATE=ROUND((CASE WHEN SUM(SELLQTY) > 0 THEN SUM(SELLRATE*SELLQTY)/SUM(SELLQTY) ELSE 0 END),2),                            
 SELLVAL=ROUND(SUM(SELLVAL),2),                
 BUYQTY=SUM(BUYQTY),                
 BUYRATE=ROUND((CASE WHEN SUM(BUYQTY) > 0 THEN SUM(BUYRATE*BUYQTY)/SUM(BUYQTY) ELSE 0 END),2),                
 BUYVAL=ROUND(SUM(BUYVAL),2),                            
 PNL=ROUND(SUM(PNL),2),FLAG,    
 SCRIP_NAME=(CASE WHEN MAX(MARKETTYPE) <> '' THEN SCRIP_NAME + ' -CA-*' ELSE SCRIP_NAME END),    
 BRANCH_CD,CL_RATE,CLVAL=SUM(CLVAL),                             
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
 L_ZIP,      
 CL_DATE=@CL_DATE,        
 NOOFDAYS = '-'      
 FROM #TBL_PNL_DATA                                    
 GROUP BY PARTY_CODE,SCRIP_CD,SERIES,BSECODE,ISIN,FLAG,SCRIP_NAME,BRANCH_CD,CL_RATE,               
 LONG_NAME,              
 L_ADDRESS1,              
 L_ADDRESS2,              
 L_ADDRESS3,              
 L_CITY,              
 L_STATE,              
 L_NATION,              
 L_ZIP                             
 ORDER BY PARTY_CODE, FLAG DESC, SCRIP_NAME, SCRIP_CD, SERIES, BSECODE, ISIN                                   
END                            
ELSE                            
BEGIN                             
 SELECT SAUDA_DATE1= SAUDA_DATE, SAUDA_DATE=CONVERT(VARCHAR,SAUDA_DATE,103),      
 SETT_NO,SETT_TYPE,PARTY_CODE,SCRIP_CD,SERIES,BSECODE,ISIN,                
 SELLQTY,SELLRATE=ROUND(SELLRATE,2),SELLVAL=ROUND(SELLVAL,2),                
 BUYQTY,BUYRATE=ROUND(BUYRATE,2),BUYVAL=ROUND(BUYVAL,2),                
 PNL=ROUND(PNL,2),  
 OPPDATE=(CASE WHEN OPPDATE LIKE 'DEC 31 2049%' THEN '-' ELSE CONVERT(VARCHAR,OPPDATE,103) END),  
 FLAG,    
 SCRIP_NAME=(CASE WHEN MAX(MARKETTYPE) <> '' THEN SCRIP_NAME + ' -CA-*' ELSE SCRIP_NAME END),    
 BRANCH_CD,CL_RATE,                
 CLVAL,  TAX = ROUND((CASE WHEN FLAG = 'SHORT TERM'         
       THEN PNL * 15 / 100         
       WHEN FLAG = 'SPECULATION'         
       THEN PNL * 30 / 100         
       ELSE 0         
     END),2),              
 LONG_NAME,              
 L_ADDRESS1,              
 L_ADDRESS2,              
 L_ADDRESS3,              
 L_CITY,              
 L_STATE,              
 L_NATION,              
 L_ZIP,      
 CL_DATE=@CL_DATE,  
 NOOFDAYS = (CASE WHEN OPPDATE LIKE 'DEC 31 2049%' THEN CONVERT(VARCHAR,DATEDIFF(d,SAUDA_DATE,GETDATE())) ELSE CONVERT(VARCHAR,DATEDIFF(d,SAUDA_DATE,OPPDATE)) END)  
 FROM #TBL_PNL_DATA   
 --WHERE ISIN = 'INE323A01026'   
 GROUP BY SAUDA_DATE,SETT_NO,SETT_TYPE,PARTY_CODE,SCRIP_CD,SERIES,BSECODE,ISIN,SELLQTY,SELLRATE,SELLVAL,    
 BUYQTY,BUYRATE,BUYVAL,PNL,OPPDATE,FLAG,BRANCH_CD,CL_RATE,CLVAL,LONG_NAME,SCRIP_NAME,L_ADDRESS1,L_ADDRESS2,              
 L_ADDRESS3,L_CITY,L_STATE,L_NATION,L_ZIP                                    
 ORDER BY PARTY_CODE, FLAG DESC, SCRIP_NAME, SCRIP_CD, SERIES, BSECODE, ISIN, 1, SAUDA_DATE, OPPDATE                                  
END

GO
