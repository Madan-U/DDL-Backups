-- Object: PROCEDURE dbo.MFUND_RPT_POSITIONCLOSE_MANUAL
-- Server: 10.253.33.91 | DB: MTFTRADE
--------------------------------------------------

  
CREATE PROC [dbo].[MFUND_RPT_POSITIONCLOSE_MANUAL](                    
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
  
SELECT @TOSCRIP = (CASE WHEN @TOSCRIP = '' AND @FROMSCRIP <> '' THEN @TOSCRIP   
      WHEN @TOSCRIP = '' AND @FROMSCRIP = '' THEN 'ZZZZZZZZZZ'  
      ELSE @TOSCRIP END)   
  
SELECT TRADE_DATE = CONVERT(VARCHAR,SAUDA_DATE,103),
T.PARTY_CODE, LONG_NAME,  
SCRIP_CD, SERIES, BSECODE, ISIN,  
QTY, ADDED_BY, ADDED_ON = CONVERT(VARCHAR,ADDED_ON,103) + ' ' + CONVERT(VARCHAR,ADDED_ON,108) 
INTO #DATA FROM TBL_PRODUCT_POS_ADJUST T, MSAJAG.DBO.CLIENT_DETAILS C1  
WHERE SAUDA_DATE = @FROMDATE    
AND C1.CL_CODE = T.PARTY_CODE  
AND T.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY  
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
                  
SELECT * FROM #DATA                
ORDER BY PARTY_CODE, LONG_NAME

GO
