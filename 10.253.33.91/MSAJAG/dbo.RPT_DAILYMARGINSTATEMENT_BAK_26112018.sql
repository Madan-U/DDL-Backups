-- Object: PROCEDURE dbo.RPT_DAILYMARGINSTATEMENT_BAK_26112018
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



  
CREATE PROC [dbo].[RPT_DAILYMARGINSTATEMENT_BAK_26112018]                                          
(                                          
@MDATE VARCHAR(11),                                          
@FROMPARTY VARCHAR(15),                                          
@TOPARTY VARCHAR(15),                                          
@FROMBRANCH VARCHAR(15)  = '',                                          
@TOBRANCH VARCHAR(15)  = 'ZZZZZZZZ',                                          
@FROMSUBBROKER VARCHAR(15) = '',                                          
@TOSUBBROKER VARCHAR(15) = 'ZZZZZZZZ',                                          
@STATUSID VARCHAR(15),                                          
@STATUSNAME VARCHAR(25),                                          
@WITHCOLL INT = 0,                                          
@BOUNCEDFLAG INT ,                                          
@SEGMENT CHAR(1) = 'N',                                          
@FLAG VARCHAR(10)                                           
)                                          
                                      
AS                                          
                                      
/*                                          
SELECT * FROM TBL_MAR_REPORT    
EXEC            RPT_DAILYMARGINSTATEMENT_ANGLE 'APR 13 2010', '0A141','0A141','','ZZZZZZZZZ',  '','ZZZZZZZZZ','BROKER','BROKER',1,0,'C',1                                          
*/                             
                                   
                                      
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED                                          
IF (CHARINDEX('/',@MDATE) > 0)                                          
BEGIN                                          
SELECT @MDATE = CONVERT(VARCHAR,CONVERT(DATETIME,@MDATE,103),109)                                          
END                                          
                                      
SELECT DISTINCT PARTY_CODE                                          
INTO #MCLIENT                                          
FROM TBL_MAR_REPORT (NOLOCK)                                         
WHERE TRADE_DAY BETWEEN @MDATE AND @MDATE + ' 23:59:59'                                          
AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY                               
                         
                      
CREATE NONCLUSTERED INDEX [IND] ON [DBO].[#MCLIENT]                               
(                              
[PARTY_CODE] ASC                                
)                             
                            
---FOR PRINT OPTION FOR COMBINED           
       
SELECT DISTINCT CL_CODE,PRINT_OPTIONS INTO #CLIENT_BROK_DETAILS FROM CLIENT_BROK_DETAILS (NOLOCK)        
WHERE EXCHANGE NOT IN ('MCX','NCX') AND CL_CODE IN (SELECT * FROM #MCLIENT)          
       
CREATE NONCLUSTERED INDEX [IND1] ON [DBO].[#CLIENT_BROK_DETAILS]                               
(                              
[CL_CODE] ASC                                
)                              
                         
                      
                                
                        
                                       
SELECT                                          
 PARTY_CODE = CL_CODE,                                          
 PARTYNAME = LONG_NAME,                                          
 L_ADDRESS1,                                          
 L_ADDRESS2,                                          
 L_ADDRESS3,                                          
 L_CITY,                                          
 L_ZIP,                                          
 L_STATE,                                          
 L_NATION,                                          
 RES_PHONE = RES_PHONE1 + RES_PHONE2,                                          
 OFF_PHONE = OFF_PHONE1 + OFF_PHONE2,                                          
 EMAIL,      
 PAN_GIR_NO,           
 BRANCH_CD,                                          
 SUB_BROKER                                          
INTO                                          
#CLIENTMASTER                                          
FROM                                          
CLIENT_DETAILS C1 (NOLOCK)                                          
WHERE                                          
 CL_CODE BETWEEN @FROMPARTY AND @TOPARTY              
 AND CL_TYPE <>'NRI'                                         
 AND BRANCH_CD BETWEEN @FROMBRANCH AND @TOBRANCH                                          
 AND SUB_BROKER BETWEEN @FROMSUBBROKER AND @TOSUBBROKER                  
                              
 --AND CL_CODE IN (SELECT PARTY_CODE FROM #MCLIENT)                                          
 AND EXISTS (SELECT PARTY_CODE FROM #MCLIENT WHERE C1.CL_CODE = #MCLIENT.PARTY_CODE)                                      
 AND @STATUSNAME = (                                          
 CASE                                          
 WHEN @STATUSID = 'BRANCH'                                          
 THEN C1.BRANCH_CD                                          
 WHEN @STATUSID = 'SUBBROKER'                                          
 THEN C1.SUB_BROKER                                          
 WHEN @STATUSID = 'TRADER'                                          
 THEN C1.TRADER                                
 WHEN @STATUSID = 'FAMILY'                                          
 THEN C1.FAMILY                                          
 WHEN @STATUSID = 'AREA'                     
 THEN C1.AREA                                          
 WHEN @STATUSID = 'REGION'                                          
 THEN C1.REGION                                          
 WHEN @STATUSID = 'CLIENT'                                         
 THEN CL_CODE                                          
 ELSE 'BROKER'                                          
 END)                             
                                 
                          
CREATE NONCLUSTERED INDEX [IND] ON [DBO].#CLIENTMASTER                               
(                              
[PARTY_CODE] ASC                                
)                             
                                      
CREATE TABLE #MARGIN_DETAIL                                          
(                                          
 EXCHANGE VARCHAR(3),                                          
 SEGMENT     VARCHAR(7),                                          
 PARTY_CODE   VARCHAR(15),                               
 MARGINDATE   DATETIME,                                          
 LED_MARGIN_AMT  MONEY,                                          
 NONCASH_AMT   MONEY,                                          
 BGFD_AMT   MONEY,                                          
 OTHER_MARGIN  MONEY,                                          
 TOTAL_MARGIN_AVL MONEY,                                          
 INITIALMARGIN  MONEY,                                          
 EXPOSURE_MARGIN  MONEY,                                          
 TOTAL_MARGIN  MONEY,                                          
 EXCESS_SHORTFALL MONEY,                                          
 ADD_MARGIN   MONEY,                                          
 MARGIN_STATUS  MONEY,                                          
)                                          
                                      
INSERT INTO #MARGIN_DETAIL                                          
 SELECT                                          
 EXCHANGE = T.EXCHANGE,                                          
 SEGMENT = T.SEGMENT,                                          
 PARTY_CODE  = T.PARTY_CODE,                                          
 MARGINDATE  = LEFT(TRADE_DAY,11),                                          
 LED_MARGIN_AMT = SUM(CASH),                                          
 NONCASH_AMT  = SUM(NONCASH),                            
 BGFD_AMT  = SUM(FD_BG),                                          
 OTHER_MARGIN = SUM(ANY_OTHER_COLL),                                          
 TOTAL_MARGIN_AVL= SUM(TOTALCOLL),       
 INITIALMARGIN = ISNULL(SUM(INIT_MARGIN),0),                                          
 EXPOSURE_MARGIN = ISNULL(SUM(EXP_MARGIN),0),                                          
 TOTAL_MARGIN = ISNULL(SUM(TOTALMARGIN),0),                                          
 EXCESS_SHORTFALL= ISNULL(SUM(EXG_MAR_SHORT),0),                                 
 --ADD_MARGIN  = ISNULL(SUM(ADD_MARGIN),0),                                          
 --MARGIN_STATUS = ISNULL(SUM(MARGIN_STATUS),0) 
 ADD_MARGIN  = CASE WHEN  ISNULL(SUM(ADD_MARGIN),0)<0 THEN ABS(ISNULL(SUM(ADD_MARGIN),0))  ELSE 0 END ,                                  
 MARGIN_STATUS = CASE WHEN  ISNULL(SUM(ADD_MARGIN),0)<0 THEN ISNULL(SUM(MARGIN_STATUS),0)  ELSE ISNULL(SUM(EXG_MAR_SHORT),0) END                                           
FROM                                          
 TBL_MAR_REPORT T (NOLOCK),            
 #CLIENTMASTER  C (NOLOCK)                                          
WHERE                                          
 TRADE_DAY BETWEEN @MDATE AND @MDATE + ' 23:59:59'                                          
 AND T.PARTY_CODE = C.PARTY_CODE                                          
 --AND T.EXCHANGE = 'NSE'                                          
 --AND T.SEGMENT = 'CAPITAL'                                          
 GROUP BY                                       
 T.PARTY_CODE,                                          
 LEFT(TRADE_DAY,11),                                          
 EXCHANGE,                                          
 SEGMENT                                          
                                         
                                       
SELECT                                          
 PARTY_CODE  = M.PARTY_CODE,                                          
 MARGINDATE  = CONVERT(VARCHAR,MARGINDATE,103),                                          
 EXCHANGE,                                          
 SEGMENT,                                  
 LED_MARGIN_AMT = SUM(LED_MARGIN_AMT),                                          
 NONCASH_AMT  = SUM(NONCASH_AMT),                                          
 BGFD_AMT  = SUM(BGFD_AMT),                                          
 OTHER_MARGIN = SUM(OTHER_MARGIN),                                          
 TOTAL_MARGIN_AVL= SUM(TOTAL_MARGIN_AVL),                                    
 INITIALMARGIN = SUM(INITIALMARGIN),                                          
 EXPOSURE_MARGIN = SUM(EXPOSURE_MARGIN),                                          
 TOTAL_MARGIN = SUM(TOTAL_MARGIN),                                          
 EXCESS_SHORTFALL= SUM(EXCESS_SHORTFALL),                                          
 ADD_MARGIN  = SUM(ADD_MARGIN),                                          
 MARGIN_STATUS = SUM(MARGIN_STATUS),                                          
 PARTYNAME,                                          
 L_ADDRESS1,                                          
 L_ADDRESS2,                                          
 L_ADDRESS3,                                          
 L_CITY,                                          
 L_ZIP,                          
 L_STATE,                                          
 L_NATION,                                          
 RES_PHONE,                                          
 OFF_PHONE,                                          
 EMAIL,                                          
 PAN_GIR_NO,                                          
 BRANCH_CD,                                          
 SUB_BROKER,                                          
 RPT_ORD = '1DET',                                          
 SCRIP_CD= CONVERT(VARCHAR(20),''),                                          
 SERIES = CONVERT(VARCHAR(5),''),                                          
 QTY = CONVERT(NUMERIC(18,4),0),                                          
 SEC_CLRATE = CONVERT(NUMERIC(18,4),0),                                          
 SEC_AMOUNT = CONVERT(NUMERIC(18,4),0),                                          
 SEC_HAIRCUT = CONVERT(NUMERIC(18,4),0),         
 SEC_FAMOUNT = CONVERT(NUMERIC(18,4),0),                                          
 BGNO = CONVERT(VARCHAR(20),''),                                          
 BG_AMOUNT = CONVERT(NUMERIC(18,4),0),                                          
 BG_EXPIRYDATE = CONVERT(VARCHAR(11),''),            
 FDRNO = CONVERT(VARCHAR(20),''),                                          
 FDR_AMOUNT = CONVERT(NUMERIC(18,4),0),                                          
 FDR_EXPIRYDATE = CONVERT(VARCHAR(11),''),                                          
 SCRIPNAME = CONVERT(VARCHAR(100),''),  
 ISIN = CONVERT(VARCHAR(12),''),                                                                                  
 LEDGER_BAL = CONVERT(NUMERIC(18,4),0),  
 PLEDGE_VALUE_CLOSING = CONVERT(NUMERIC(18,4),0),    
 PLEDGE_QTY = CONVERT(NUMERIC(18,4),0),    
 BORROWING = CONVERT(NUMERIC(18,4),0),    
 PLD_DETAILS =  CONVERT(VARCHAR(100),'')   
INTO                             
#FINAL_REPORT                                          
FROM                                   
 #MARGIN_DETAIL M (NOLOCK),                                          
 #CLIENTMASTER  C (NOLOCK)                                          
WHERE                                          
 M.PARTY_CODE = C.PARTY_CODE                                          
 GROUP BY                                          
 M.PARTY_CODE,                                         
 CONVERT(VARCHAR,MARGINDATE,103),                                          
 EXCHANGE,                                          
 SEGMENT,                                          
 PARTYNAME,                                          
 L_ADDRESS1,                                          
 L_ADDRESS2,                                          
 L_ADDRESS3,                                          
 L_CITY,                                          
 L_ZIP,                                          
 L_STATE,                                          
 L_NATION,                                          
 RES_PHONE,                                          
 OFF_PHONE,                                          
 EMAIL,                                          
 PAN_GIR_NO,                                          
 BRANCH_CD,                                          
 SUB_BROKER  
  
ORDER BY                                          
PARTY_CODE                                          
   CREATE NONCLUSTERED INDEX [FIND] ON [DBO].[#FINAL_REPORT]                               
(                              
 [PARTY_CODE] ASC                                
 )     
  
--SELECT * INTO #COLL_DETAIL_PLDG FROM   [196.1.115.182].PLEDGE.DBO.CLIENTWISEDATEWISE_PLEDGEDETAILS  C  
--WHERE PROCESSDATE BETWEEN @MDATE AND @MDATE + ' 23:59:59'  
--AND EXISTS (SELECT DISTINCT PARTY_CODE FROM #FINAL_REPORT   
--WHERE C.PARTY_CODE = #FINAL_REPORT.PARTY_CODE)      
  
CREATE TABLE #COLL_DETAIL_PLDG  
(  
MDATE VARCHAR(11),                                          
PARTY_CODE VARCHAR(15),                                          
ISIN VARCHAR(20),                                          
QTY INT ,                                          
PLEDGE_QTY INT,                                          
AVG_CLOSING MONEY ,                                          
PLEDGE_VALUE MONEY,                                          
BANK_CODE VARCHAR(15),                                          
BANK_NAME VARCHAR(25),                                          
LEDGER_BAL MONEY,                                          
PERCENTAGE INT,  
BORROWING INT   
)  
  
INSERT INTO #COLL_DETAIL_PLDG  
EXEC CLIENTWISEDATEWISE_PLDDETAILS @MDATE  
  
   CREATE NONCLUSTERED INDEX [PLDG] ON [DBO].[#COLL_DETAIL_PLDG]                               
(                              
 [PARTY_CODE] ASC                                
 )     
                                  
                                      
IF (@WITHCOLL = 1)                                          
BEGIN                                          
SELECT * INTO #COLLATERALDETAILS                                      
FROM   MSAJAG.DBO.COLLATERALDETAILS C (NOLOCK)                                          
WHERE  EFFDATE BETWEEN @MDATE AND @MDATE + ' 23:59:59'                                          
AND EXISTS (SELECT DISTINCT PARTY_CODE FROM #FINAL_REPORT   
WHERE C.PARTY_CODE = #FINAL_REPORT.PARTY_CODE) AND  EXCHANGE NOT IN ('MCX','NCX')                                      
END                                      
                                      
                                      
IF (@WITHCOLL = 1)                                          
BEGIN                                          
SELECT                                          
 PARTY_CODE,                                          
 MARGINDATE,                  
 EXCHANGE,                                          
 SEGMENT,                                          
 SCRIP_CD,                                          
 SERIES,                                          
 QTY = SUM(QTY),                                          
 SEC_CLRATE = SEC_CLRATE,                            
 SEC_AMOUNT = SUM(SEC_AMOUNT),                                          
 SEC_HAIRCUT = SEC_HAIRCUT,                                          
 SEC_FAMOUNT = SUM(SEC_FAMOUNT),                                          
 BGNO,                                  
 BG_AMOUNT = SUM(BG_AMOUNT),                                          
 BG_EXPIRYDATE,                                       
 FDRNO,                    
 FDR_AMOUNT = SUM(FDR_AMOUNT),                                          
 FDR_EXPIRYDATE,                                          
 SCRIPNAME = CONVERT(VARCHAR(100),''),                                          
 COLL_TYPE = '2' + UPPER(COLL_TYPE),  
 ISIN  ,                                        
 LEDGER_BAL = CONVERT(NUMERIC(18,4),0),  
 PLEDGE_VALUE_CLOSING = CONVERT(NUMERIC(18,4),0),    
 PLEDGE_QTY = CONVERT(NUMERIC(18,4),0),    
 BORROWING = CONVERT(NUMERIC(18,4),0),    
 PLD_DETAILS = CONVERT(VARCHAR(100),'')  
INTO                                          
#COLL_DETAIL                                          
FROM                                          
(                                  
SELECT                                          
 PARTY_CODE=UPPER(PARTY_CODE),                                          
 MARGINDATE = CONVERT(VARCHAR,EFFDATE,103),                                          
 EXCHANGE,                                          
 SEGMENT,                                          
 SCRIP_CD = (                                          
 CASE                                           
  WHEN COLL_TYPE = 'SEC'                                           
  THEN SCRIP_CD ELSE ''                                           
 END),                                          
 SERIES,                                          
 QTY = (                        
 CASE                                           
  WHEN COLL_TYPE = 'SEC'                                           
  THEN QTY ELSE 0                                           
 END),                                          
 SEC_CLRATE = (                                          
 CASE                                           
  WHEN COLL_TYPE = 'SEC'                                           
  THEN CL_RATE ELSE 0                                           
 END),                                 
 SEC_AMOUNT = (                                          
 CASE                                           
  WHEN COLL_TYPE = 'SEC'                                           
  THEN AMOUNT ELSE 0                                           
 END),                                          
 SEC_HAIRCUT = (                                          
 CASE                                           
  WHEN COLL_TYPE = 'SEC'                                           
  THEN HAIRCUT ELSE 0                                           
 END),                                          
 SEC_FAMOUNT = (                                          
 CASE                                          
  WHEN COLL_TYPE = 'SEC'                                           
  THEN FINALAMOUNT ELSE 0                                           
 END),                                          
 BGNO =(                                          
 CASE                                          
  WHEN COLL_TYPE = 'BG'         
  THEN FD_BG_NO ELSE ''                            
 END),                                          
 BG_AMOUNT =(                                          
 CASE                                          
  WHEN COLL_TYPE = 'BG'                                          
  THEN FINALAMOUNT ELSE 0                                          
 END),                                          
 BG_EXPIRYDATE = (                                          
 CASE                                          
  WHEN COLL_TYPE = 'BG'                                          
  THEN CONVERT(VARCHAR,MATURITY_DATE,103) ELSE ''                                          
 END),              
 FDRNO =(                                          
 CASE                                          
  WHEN COLL_TYPE = 'FD'                                          
  THEN FD_BG_NO ELSE ''                                          
 END),                                          
 FDR_AMOUNT =(                                          
 CASE                                          
  WHEN COLL_TYPE = 'FD'                                 
  THEN FINALAMOUNT ELSE 0                                          
 END),                                          
 FDR_EXPIRYDATE = (                                          
 CASE                                          
  WHEN COLL_TYPE = 'FD'                                          
  THEN CONVERT(VARCHAR,MATURITY_DATE,103) ELSE ''                                          
 END),                                          
COLL_TYPE,ISIN                                          
FROM                                          
#COLLATERALDETAILS C (NOLOCK)                                           
WHERE                                          
--PARTY_CODE IN (SELECT DISTINCT PARTY_CODE FROM #FINAL_REPORT)                                          
EFFDATE BETWEEN @MDATE AND @MDATE + ' 23:59:59'                                          
AND COLL_TYPE <> 'MARGIN'                                          
/*    AND EXCHANGE <> 'NSE'                                          
AND SEGMENT <> 'FUTURES'                                          
*/                                          
) COLL                                          
GROUP BY                                          
PARTY_CODE,                                          
MARGINDATE,                                          
SCRIP_CD,                  
SERIES,                                          
SEC_CLRATE,                                          
SEC_HAIRCUT,                                          
BGNO,                                          
BG_EXPIRYDATE,                                          
FDRNO,                                          
FDR_EXPIRYDATE,                                          
UPPER(COLL_TYPE),                                          
EXCHANGE,                        
SEGMENT ,  
ISIN                                         
  
--SELECT * INTO COLL_DETAIL_12 FROM  #COLL_DETAIL  
  
  
  
INSERT INTO  #COLL_DETAIL  
SELECT                                          
PARTY_CODE ,                                          
MARGINDATE =CONVERT(VARCHAR,MDATE,103),                   
EXCHANGE='',                                          
SEGMENT='',                                          
SCRIP_CD='',                                          
SERIES='',                                          
QTY = SUM(QTY),                                           
SEC_CLRATE = SUM(AVG_CLOSING),                                          
SEC_AMOUNT = SUM(PLEDGE_VALUE),                                          
SEC_HAIRCUT ='',                                          
SEC_FAMOUNT =SUM(AVG_CLOSING*QTY)/2,                                          
BGNO='',                                  
BG_AMOUNT  ='',                                        
BG_EXPIRYDATE='',                         
FDRNO='',                    
FDR_AMOUNT = '',                                          
FDR_EXPIRYDATE='',     
SCRIPNAME  ='',                            
COLL_TYPE = '3' + 'PLD',  
ISIN =ISIN ,                                        
LEDGER_BAL =sum(LEDGER_BAL),  
PLEDGE_VALUE_CLOSING =SUM(AVG_CLOSING*QTY),  
PLEDGE_QTY =SUM(PLEDGE_QTY),    
BORROWING =SUM(BORROWING),    
PLD_DETAILS = MAX(BANK_NAME)  
FROM  #COLL_DETAIL_PLDG C   
WHERE EXISTS (SELECT DISTINCT PARTY_CODE FROM #FINAL_REPORT   
WHERE C.PARTY_CODE = #FINAL_REPORT.PARTY_CODE)    
--and party_code='jod17256'  
GROUP BY PARTY_CODE,ISIN,MDATE  
  
UPDATE C SET SCRIP_CD=M.SCRIP_CD ,SERIES=M.SERIES  
FROM MULTIISIN M, #COLL_DETAIL C  
WHERE M.ISIN=C.ISIN  
AND COLL_TYPE='3PLD'  
  
  
--return  
  
                              
                                                                      
                            
UPDATE T                                           
                                      
SET T.SEC_AMOUNT = T1.AMOUNT,                                          
SEC_FAMOUNT = T1.FINALAMOUNT ,      
SEC_CLRATE =T1.CL_RATE ,      
SEC_HAIRCUT =T1.HAIRCUT                                        
                                      
FROM #COLL_DETAIL T,  
--NSEFO.DBO.TBL_COLLATERAL_MARGIN T1 WITH (NOLOCK)                                          
ANGELFO.NSEFO.DBO.TBL_COLLATERAL_MARGIN T1 WITH (NOLOCK)                                          
WHERE                                           
T.PARTY_CODE=T1.PARTY_CODE                                          
AND EXCHANGE='NSE' AND SEGMENT='FUTURES'                                          
--AND CONVERT(VARCHAR(11),T.MARGINDATE,103)=CONVERT(VARCHAR(11),T1.EFFDATE,103)                                          
AND T1.EFFDATE BETWEEN @MDATE AND @MDATE + ' 23:59:59'                                       
AND T.ISIN=T1.ISIN  
AND T1.COLL_TYPE = 'SEC'                                                
-----------CHANGES FOR RATE ISSUE  
UPDATE T                                           
                                      
SET T.SEC_AMOUNT = T1.AMOUNT,                                          
SEC_FAMOUNT = T1.FINALAMOUNT ,      
SEC_CLRATE =T1.CL_RATE ,      
SEC_HAIRCUT =T1.HAIRCUT                                        
                                      
FROM #COLL_DETAIL T,   
--NSECURFO.DBO.TBL_COLLATERAL_MARGIN T1 WITH (NOLOCK)                                          
ANGELFO.NSECURFO.DBO.TBL_COLLATERAL_MARGIN T1 WITH (NOLOCK)                                          
WHERE                                           
T.PARTY_CODE=T1.PARTY_CODE                                          
AND EXCHANGE='NSX' AND SEGMENT='FUTURES'         
--AND CONVERT(VARCHAR(11),T.MARGINDATE,103)=CONVERT(VARCHAR(11),T1.EFFDATE,103)                                  
AND T1.EFFDATE BETWEEN @MDATE AND @MDATE + ' 23:59:59'                                       
AND T.ISIN=T1.ISIN                                         
AND T1.COLL_TYPE = 'SEC'        
  
  
----------------- END  
  
  
                                      
UPDATE T                                           
SET T.SEC_AMOUNT = T1.AMOUNT,                                          
SEC_FAMOUNT = T1.FINALAMOUNT,  
SEC_CLRATE =T1.CL_RATE ,      
SEC_HAIRCUT =T1.HAIRCUT   
                                    
FROM #COLL_DETAIL T,  
--MCDXCDS.DBO.TBL_COLLATERAL_MARGIN T1 WITH (NOLOCK)                                        
ANGELCOMMODITY.MCDXCDS.DBO.TBL_COLLATERAL_MARGIN T1 WITH (NOLOCK)                                       
WHERE                                           
T.PARTY_CODE=T1.PARTY_CODE                                          
AND EXCHANGE='MCD' AND SEGMENT='FUTURES'                                          
--AND CONVERT(VARCHAR(11),T.MARGINDATE,103)=CONVERT(VARCHAR(11),T1.EFFDATE,103)                                        
AND T1.EFFDATE BETWEEN @MDATE AND @MDATE + ' 23:59:59'   
AND T.ISIN=T1.ISIN                                         
AND T1.COLL_TYPE = 'SEC'   
  
                     
                                      
ALTER TABLE #FINAL_REPORT                                          
ALTER COLUMN  RPT_ORD VARCHAR(7)                      
  
  
--SELECT * INTO FINAL_REPORT_SURESH   
  
           
INSERT INTO #FINAL_REPORT                                          
SELECT                                          
PARTY_CODE  = M.PARTY_CODE,                                          
MARGINDATE,                                          
EXCHANGE,                                          
SEGMENT,                                          
LED_MARGIN_AMT = 0,                                          
NONCASH_AMT  = 0,                              
BGFD_AMT  = 0,                                          
OTHER_MARGIN = 0,                                          
TOTAL_MARGIN_AVL= 0,                                          
INITIALMARGIN = 0,                                          
EXPOSURE_MARGIN = 0,                          
TOTAL_MARGIN = 0,                                          
EXCESS_SHORTFALL= 0,                                          
ADD_MARGIN  = 0,                                          
MARGIN_STATUS = 0,                                          
PARTYNAME,                                          
L_ADDRESS1,                                          
L_ADDRESS2,                                          
L_ADDRESS3,                                       
L_CITY,                                  
L_ZIP,                                          
L_STATE,                                          
L_NATION,                                          
RES_PHONE,                                          
OFF_PHONE,                                          
EMAIL,                                          
PAN_GIR_NO,                                          
BRANCH_CD,                                          
SUB_BROKER,                                          
RPT_ORD = UPPER(COLL_TYPE),                                          
SCRIP_CD,                                          
SERIES,                                          
QTY ,                                          
SEC_CLRATE,                                          
SEC_AMOUNT,                                          
SEC_HAIRCUT,                                          
SEC_FAMOUNT,                                   
BGNO,                                          
BG_AMOUNT,                 
BG_EXPIRYDATE,                                          
FDRNO,                         
FDR_AMOUNT,                                          
FDR_EXPIRYDATE,                                          
SCRIPNAME = SCRIP_CD,  
ISIN ,                                         
LEDGER_BAL,  
PLEDGE_VALUE_CLOSING,PLEDGE_QTY,  
BORROWING,PLD_DETAILS   
--INTO COLL_DETAIL_1211  
FROM                                          
#COLL_DETAIL   M (NOLOCK),                                          
#CLIENTMASTER  C (NOLOCK)                                          
WHERE                                          
M.PARTY_CODE = C.PARTY_CODE                                 
  
  
END         
                             
UPDATE #FINAL_REPORT                                          
SET  SCRIPNAME = ISNULL(S1.LONG_NAME,#FINAL_REPORT.SCRIP_CD)                                  
FROM SCRIP1 S1 (NOLOCK),                                           
SCRIP2 S2 (NOLOCK)                                          
WHERE S1.CO_CODE = S2.CO_CODE                                          
AND S1.SERIES = S2.SERIES                                          
AND #FINAL_REPORT.SCRIP_CD = S2.SCRIP_CD                                          
AND #FINAL_REPORT.SERIES = S2.SERIES                                          
--AND #FINAL_REPORT.EXCHANGE = 'NSE'                                          
AND #FINAL_REPORT.RPT_ORD  in ( '2SEC' ,'3PLD')                                         
                                       
                                      
SELECT                                          
FI.PARTY_CODE,                                          
MARGINDATE,                                          
EXCHANGE = (      
CASE                                          
WHEN SEGMENT ='CAPITAL' THEN FI.EXCHANGE + '-CASH'                                          
WHEN SEGMENT ='FUTURES' THEN FI.EXCHANGE + '-F&O'                                          
ELSE FI.EXCHANGE + '-' + SEGMENT                                          
END),                                          
SEGMENT,                                          
LED_MARGIN_AMT = SUM(LED_MARGIN_AMT),                                          
NONCASH_AMT = SUM(NONCASH_AMT),                                          
BGFD_AMT = SUM(BGFD_AMT),                                          
OTHER_MARGIN = SUM(OTHER_MARGIN),                                          
TOTAL_MARGIN_AVL = SUM(TOTAL_MARGIN_AVL),                                          
INITIALMARGIN = SUM(INITIALMARGIN),                                          
EXPOSURE_MARGIN = SUM(EXPOSURE_MARGIN),                                          
TOTAL_MARGIN = SUM(TOTAL_MARGIN),                                          
EXCESS_SHORTFALL = SUM(EXCESS_SHORTFALL),                                          
ADD_MARGIN = SUM(ADD_MARGIN),                                          
MARGIN_STATUS = SUM(MARGIN_STATUS),                                          
PARTYNAME,                                          
L_ADDRESS1,        
L_ADDRESS2,                                          
L_ADDRESS3,                                          
L_CITY,                                          
L_ZIP,                                        
L_STATE,                                          
L_NATION,                                          
RES_PHONE,                                          
OFF_PHONE,                                          
EMAIL,                                          
PAN_GIR_NO,                                          
BRANCH_CD,                                          
SUB_BROKER,                                          
RPT_ORD,                                          
SCRIP_CD,                                          
SERIES,                                          
QTY = SUM(QTY),           
SEC_CLRATE,                                          
SEC_AMOUNT = SUM(SEC_AMOUNT)  , --(CASE WHEN SEGMENT <> 'CAPITAL' THEN SUM(SEC_AMOUNT)  ELSE 0 END),                                          
SEC_HAIRCUT = SUM(SEC_HAIRCUT),                                          
SEC_FAMOUNT = SUM(SEC_FAMOUNT),                                          
BGNO,                                          
BG_AMOUNT = SUM(BG_AMOUNT),                                          
BG_EXPIRYDATE,                                          
FDRNO,                                          
FDR_AMOUNT = SUM(FDR_AMOUNT),                                          
FDR_EXPIRYDATE,                                          
SCRIPNAME ,  
ISIN ,LEDGER_BAL=SUM(LEDGER_BAL),PLEDGE_VALUE_CLOSING=SUM(PLEDGE_VALUE_CLOSING),  
PLEDGE_QTY=SUM(PLEDGE_QTY),  
BORROWING=SUM(BORROWING),PLD_DETAILS =max(PLD_DETAILS)                                       
INTO #FINAL_REPORTNEW                                          
FROM                                           
#FINAL_REPORT FI,                       
#CLIENT_BROK_DETAILS C2  
,PRINTF_SETTINGS T                                  
--MSAJAG.DBO.FUN_PRINTF(@FLAG) C2                                           
                                       
WHERE                                           
 FI.PARTY_CODE=C2.CL_CODE                                                                         
AND T.PRINTF = C2.PRINT_OPTIONS                                          
AND T.PRINTF_FLAG = @FLAG   
                                      
                                       
GROUP BY                                          
FI.PARTY_CODE,                                          
MARGINDATE,                                          
CASE                                          
WHEN SEGMENT ='CAPITAL' THEN FI.EXCHANGE + '-CASH'                                          
WHEN SEGMENT ='FUTURES' THEN FI.EXCHANGE + '-F&O'         
ELSE FI.EXCHANGE + '-' + SEGMENT                                     
END,                                          
SEGMENT,                                          
PARTYNAME,                                          
L_ADDRESS1,                                          
L_ADDRESS2,                                          
L_ADDRESS3,                        
L_CITY,                                          
L_ZIP,                                          
L_STATE,                                          
L_NATION,                                          
RES_PHONE,                                          
OFF_PHONE,                                          
EMAIL,                                          
PAN_GIR_NO,                             
BRANCH_CD,                                          
SUB_BROKER,                                          
RPT_ORD,                                          
SCRIP_CD,                                          
SERIES,                                      
SEC_CLRATE,                                          
BGNO,                                          
BG_EXPIRYDATE,                                          
FDRNO,                                          
FDR_EXPIRYDATE,                                          
SCRIPNAME  
,ISIN   
                               
ORDER BY                      
BRANCH_CD,                   
SUB_BROKER,FI.PARTY_CODE,RPT_ORD,EXCHANGE,SEGMENT                              
                         
                         
                         
--PRINT @BOUNCEDFLAG                             
                        
                         
IF  @BOUNCEDFLAG = 0                             
BEGIN                             
-- PRINT 'SURESH'                                        
SELECT * FROM #FINAL_REPORTNEW                   
--WHERE (TOTAL_MARGIN <> 0 OR SEC_AMOUNT <> 0 )                    
ORDER BY                
BRANCH_CD,                                          
SUB_BROKER,PARTY_CODE,RPT_ORD,EXCHANGE,SEGMENT             
END                            
ELSE                            
BEGIN                             
-- PRINT 'SURESH1'         
                              
CREATE TABLE #PARTY                                          
(                                          
PARTYCODE VARCHAR(15)                          
)                                         
                                   
INSERT INTO #PARTY                                          
SELECT DISTINCT PARTY_CODE FROM TBL_ECNBOUNCED WITH (NOLOCK)   
WHERE SDATE BETWEEN @MDATE AND @MDATE + ' 23:59:59'                                          
                         
                  
CREATE NONCLUSTERED INDEX [IND] ON [DBO].[#PARTY]                               
(                              
[PARTYCODE] ASC                                
)                         
                   
SELECT * FROM #FINAL_REPORTNEW WHERE PARTY_CODE IN (SELECT PARTYCODE FROM #PARTY)                     
--AND (TOTAL_MARGIN <> 0 OR SEC_AMOUNT <> 0 )    
              
ORDER BY               
BRANCH_CD, SUB_BROKER,PARTY_CODE,RPT_ORD,EXCHANGE,SEGMENT               
                     
END                                          
--WHERE (TOTAL_MARGIN <> 0 OR (SEC_AMOUNT <> 0 AND EXCHANGE NOT LIKE 'MCX-F&O%' AND EXCHANGE NOT LIKE 'NCX-F&O%'))                                          
                                       
DROP TABLE #MARGIN_DETAIL                                     
DROP TABLE #MCLIENT                                          
DROP TABLE #CLIENTMASTER                                        
DROP TABLE #FINAL_REPORTNEW        
DROP TABLE #CLIENT_BROK_DETAILS

GO
