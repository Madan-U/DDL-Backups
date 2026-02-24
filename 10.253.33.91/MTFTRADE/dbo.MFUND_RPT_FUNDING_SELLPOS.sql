-- Object: PROCEDURE dbo.MFUND_RPT_FUNDING_SELLPOS
-- Server: 10.253.33.91 | DB: MTFTRADE
--------------------------------------------------

  
CREATE PROC [dbo].[MFUND_RPT_FUNDING_SELLPOS](                    
  @STATUSID VARCHAR(50),                      
  @STATUSNAME VARCHAR(50),                      
  @FROMDATE VARCHAR(11),                      
  @TODATE  VARCHAR(11),                      
  @FROMPARTY VARCHAR(10),                      
  @TOPARTY VARCHAR(10),                      
  @FROMSCRIP VARCHAR(50)='',                      
  @TOSCRIP VARCHAR(50)='ZZZZZZZ',                      
  @OPT VARCHAR(20)=''                    
)              
AS       
SELECT @TOPARTY = (CASE WHEN @TOPARTY = '' AND @FROMPARTY <> '' THEN @FROMPARTY   
      WHEN @TOPARTY = '' AND @FROMPARTY = '' THEN 'ZZZZZZZZZZ'  
      ELSE @TOPARTY END)   
  
SELECT @TOSCRIP = (CASE WHEN @TOSCRIP = '' AND @FROMSCRIP <> '' THEN @FROMSCRIP   
      WHEN @TOSCRIP = '' AND @FROMSCRIP = '' THEN 'ZZZZZZZZZZ'  
      ELSE @TOSCRIP END)   
  
SELECT SAUDA_DATE = CONVERT(DATETIME,SAUDA_DATE),   
EXCHANGE = (CASE WHEN TRANSTYPE = 'TRBSE' THEN 'BSE' ELSE 'NSE' END),  
SETT_NO, SETT_TYPE,   
t.PARTY_CODE, LONG_NAME, SCRIP_NAME = CONVERT(VARCHAR(100),''),  
SCRIP_CD, SERIES, BSECODE, ISIN, QTY, MARKETVALUE=MKTAMT, NETVALUE = NETAMT, CL_RATE   
INTO #DATA  
FROM TBL_PRODUCT_POSITION T, MSAJAG.DBO.CLIENT_details C1  
WHERE SAUDA_DATE = @FROMDATE   
AND SELL_BUY = 2   
AND C1.CL_CODE = t.PARTY_CODE  
AND t.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY  
AND @STATUSNAME =            
                  (CASE            
                        WHEN @STATUSID = 'BRANCH' THEN C1.BRANCH_CD            
                        WHEN @STATUSID = 'SUBBROKER' THEN C1.SUB_BROKER            
                        WHEN @STATUSID = 'TRADER' THEN C1.TRADER            
                        WHEN @STATUSID = 'FAMILY' THEN C1.FAMILY            
                        WHEN @STATUSID = 'AREA' THEN C1.AREA            
                        WHEN @STATUSID = 'REGION' THEN C1.REGION            
                        WHEN @STATUSID = 'CLIENT' THEN C1.CL_CODE            
                  ELSE            
                        'BROKER'            
                  END)      
  
UPDATE #DATA SET SCRIP_NAME = S1.LONG_NAME FROM MSAJAG.DBO.SCRIP1 S1, MSAJAG.DBO.SCRIP2 S2              
WHERE S1.CO_CODE = S2.CO_CODE AND S1.SERIES = S2.SERIES              
AND S2.SCRIP_CD = #DATA.SCRIP_CD AND S2.SERIES = #DATA.SERIES              
              
UPDATE #DATA SET SCRIP_NAME = S1.LONG_NAME FROM ANGELDEMAT.BSEDB.DBO.SCRIP1 S1, ANGELDEMAT.BSEDB.DBO.SCRIP2 S2              
WHERE S1.CO_CODE = S2.CO_CODE AND S1.SERIES = S2.SERIES              
AND S2.BSECODE = #DATA.BSECODE        
AND SCRIP_NAME = ''       
  
SELECT * FROM #DATA  
WHERE SCRIP_NAME  >= @FROMSCRIP AND SCRIP_NAME  <= @TOSCRIP              
ORDER BY PARTY_CODE, LONG_NAME, SCRIP_NAME

GO
