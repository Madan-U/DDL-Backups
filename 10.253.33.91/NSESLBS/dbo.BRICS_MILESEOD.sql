-- Object: PROCEDURE dbo.BRICS_MILESEOD
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE PROC BRICS_MILESEOD                           
 (                 
 @STATUSID VARCHAR(15),              
 @STATUSNAME VARCHAR(15),                         
 @FROMDATE VARCHAR(15),                          
 @TODATE VARCHAR(15),                
 @FROMPARTYCODE VARCHAR(15),                          
 @TOPARTYCODE VARCHAR(15)                          
 )                          
                           
 AS                          
                      
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED                          
                          
SELECT                          
 Brokersebino='INB231205734',                       
 Contractno=contractno,                      
 Exchange='N',                      
TRADEDATE = CONVERT(VARCHAR,SAUDA_DATE,111),                       
SEGMENT=S.SETT_TYPE,                      
SETTNO=right(S.SETT_NO,3),                      
SETTYEAR='2007',                      
BACKOFFICECODE=S.PARTY_CODE ,                      
BSECODE=CONVERT(VARCHAR(6), ''),                      
NSESYMBOL=ISNULL(S.SCRIP_CD,'') ,                      
NSEGROUP=S.SERIES,                      
SCRIPISIN=CONVERT(VARCHAR(12), ''),                        
SCRIPNAME = S1.LONG_NAME,                       
SELLBUY = (CASE WHEN SELL_BUY = 1 THEN 'B' ELSE 'S'   END),                       
TRADEQTY = (CASE WHEN SELL_BUY = 1 THEN SUM(TRADEQTY) ELSE  SUM(TRADEQTY) END),                        
MARKETRATE =SUM(TRADEQTY*MARKETRATE)/SUM(TRADEQTY) ,                       
NETRATE=SUM(TRADEQTY*N_NETRATE)/SUM(TRADEQTY) ,                       
SERVICETAX=SUM(NSERTAX),                      
STT = SUM(INS_CHRG),                        
OTHERCHARGES=SUM(TURN_TAX+S.OTHER_CHRG+SEBI_TAX+BROKER_CHRG),                      
 STOCKPAYINDATE = CONVERT(VARCHAR,SM.FUNDS_PAYIN,111),                        
STOCKPAYOUTDATE = CONVERT(VARCHAR,SM.FUNDS_PAYOUT,111),                        
CASHPAYINDATE = CONVERT(VARCHAR,SM.FUNDS_PAYIN,111),                        
CASHPAYOUTDATE = CONVERT(VARCHAR,SM.FUNDS_PAYOUT,111)                        
INTO #NSEDATA 
FROM                         
MSAJAG.DBO.SETTLEMENT S WITH(NOLOCK),                          
MSAJAG.DBO.SETT_MST SM WITH(NOLOCK),                          
MSAJAG.DBO.CLIENT1 C1 WITH(NOLOCK),                          
MSAJAG.DBO.CLIENT2 C2 WITH(NOLOCK),                          
MSAJAG.DBO.SCRIP1 S1 WITH(NOLOCK),                          
MSAJAG.DBO.SCRIP2 S2 WITH(NOLOCK)  
                     
WHERE                                  
-- AND S.SERIES = M.SERIES /* changed on Feb 11 08 for eq/be series */        
C1.CL_CODE = C2.CL_CODE                          
 AND C2.PARTY_CODE = S.PARTY_CODE                          
 AND SM.SETT_NO = S.SETT_NO                          
 AND SM.SETT_TYPE = S.SETT_TYPE                          
 AND TRADEQTY > 0                          
 AND S.SCRIP_CD = S2.SCRIP_CD                          
 AND S.SERIES = S2.SERIES                          
 AND S1.CO_CODE = S2.CO_CODE                          
 AND S1.SERIES = S2.SERIES                           
 AND S.PARTY_CODE BETWEEN @FROMPARTYCODE AND @TOPARTYCODE                          
 AND S.SAUDA_DATE>=@FROMDATE AND S.SAUDA_DATE <=@TODATE + ' 23:59:59'                     
 AND S.MARKETRATE<>0                
And C1.Branch_Cd Like (Case When @StatusId = 'branch' then @Statusname else '%' End)                           
And C1.Sub_broker Like (Case When @StatusId = 'subbroker' then @Statusname else '%' End)                          
And C1.Trader Like (Case When @StatusId = 'trader' then @Statusname else '%' End)                          
And C1.Family Like (Case When @StatusId = 'family' then @Statusname else '%' End)                          
And C1.Region Like (Case When @StatusId = 'region' then @Statusname else '%' End)                          
And C1.Area Like (Case When @StatusId = 'area' then @Statusname else '%' End)
And C2.Party_Code Like (Case When @StatusId = 'client' then @Statusname else '%' End)                      
GROUP BY                          
 S.PARTY_CODE,S.CONTRACTNO,S.SETT_TYPE,S.SETT_NO,S.SERIES,         
 CONVERT(VARCHAR,SAUDA_DATE,111),                          
 S.SCRIP_CD,                          
 S1.LONG_NAME,                          
 C1.LONG_NAME,                          
 CONVERT(VARCHAR,SM.FUNDS_PAYIN,111),                          
 CONVERT(VARCHAR,SM.FUNDS_PAYOUT,111),                        
 SELL_BUY                   
UNION ALL                   
SELECT                          
 Brokersebino='INB231205734',               
 Contractno=contractno,                      
 Exchange='N',                      
TRADEDATE = CONVERT(VARCHAR,SAUDA_DATE,111),                       
SEGMENT=S.SETT_TYPE,                      
SETTNO=right(S.SETT_NO,3),                      
SETTYEAR='2007',                      
BACKOFFICECODE=S.PARTY_CODE ,                      
BSECODE=CONVERT(VARCHAR(6), ''),                      
NSESYMBOL=ISNULL(S.SCRIP_CD,'') ,                      
NSEGROUP=S.SERIES,                      
SCRIPISIN=CONVERT(VARCHAR(12), ''),                        
SCRIPNAME = S1.LONG_NAME,                       
SELLBUY = (CASE WHEN SELL_BUY = 1 THEN 'B' ELSE 'S'   END),                       
TRADEQTY = (CASE WHEN SELL_BUY = 1 THEN SUM(TRADEQTY) ELSE  SUM(TRADEQTY) END),                        
MARKETRATE =SUM(TRADEQTY*MARKETRATE)/SUM(TRADEQTY) ,                       
NETRATE=SUM(TRADEQTY*N_NETRATE)/SUM(TRADEQTY) ,                       
SERVICETAX=SUM(NSERTAX),                      
STT = SUM(INS_CHRG),                        
OTHERCHARGES=SUM(TURN_TAX+S.OTHER_CHRG+SEBI_TAX+BROKER_CHRG),                      
 STOCKPAYINDATE = CONVERT(VARCHAR,SM.FUNDS_PAYIN,111),                        
STOCKPAYOUTDATE = CONVERT(VARCHAR,SM.FUNDS_PAYOUT,111),                        
CASHPAYINDATE = CONVERT(VARCHAR,SM.FUNDS_PAYIN,111),                        
CASHPAYOUTDATE = CONVERT(VARCHAR,SM.FUNDS_PAYOUT,111)                        
FROM                         
MSAJAG.DBO.HISTORY S WITH(NOLOCK),                          
MSAJAG.DBO.SETT_MST SM WITH(NOLOCK),                          
MSAJAG.DBO.CLIENT1 C1 WITH(NOLOCK),                   
MSAJAG.DBO.CLIENT2 C2 WITH(NOLOCK),                          
MSAJAG.DBO.SCRIP1 S1 WITH(NOLOCK),                          
MSAJAG.DBO.SCRIP2 S2 WITH(NOLOCK)                         
WHERE                         
C1.CL_CODE = C2.CL_CODE                          
 AND C2.PARTY_CODE = S.PARTY_CODE                          
 AND SM.SETT_NO = S.SETT_NO                          
 AND SM.SETT_TYPE = S.SETT_TYPE                          
 AND TRADEQTY > 0                          
 AND S.SCRIP_CD = S2.SCRIP_CD                          
 AND S.SERIES = S2.SERIES                          
 AND S1.CO_CODE = S2.CO_CODE                          
 AND S1.SERIES = S2.SERIES                           
 AND S.PARTY_CODE BETWEEN @FROMPARTYCODE AND @TOPARTYCODE                          
AND S.SAUDA_DATE>=@FROMDATE AND S.SAUDA_DATE <=@TODATE + ' 23:59:59'                               
AND S.MARKETRATE<>0                
And C1.Branch_Cd Like (Case When @StatusId = 'branch' then @Statusname else '%' End)                           
And C1.Sub_broker Like (Case When @StatusId = 'subbroker' then @Statusname else '%' End)                          
And C1.Trader Like (Case When @StatusId = 'trader' then @Statusname else '%' End)                          
And C1.Family Like (Case When @StatusId = 'family' then @Statusname else '%' End)                          
And C1.Region Like (Case When @StatusId = 'region' then @Statusname else '%' End)                          
And C1.Area Like (Case When @StatusId = 'area' then @Statusname else '%' End)                          
And C2.Party_Code Like (Case When @StatusId = 'client' then @Statusname else '%' End)                      
GROUP BY                          
 S.PARTY_CODE,S.CONTRACTNO,S.SETT_TYPE,S.SETT_NO,S.SERIES,                          
 CONVERT(VARCHAR,SAUDA_DATE,111),                          
 S.SCRIP_CD,                          
 S1.LONG_NAME,                          
 C1.LONG_NAME,                          
 CONVERT(VARCHAR,SM.FUNDS_PAYIN,111),                          
 CONVERT(VARCHAR,SM.FUNDS_PAYOUT,111),                        
 SELL_BUY

UPDATE #NSEDATA SET SCRIPISIN = M.ISIN
FROM MSAJAG.DBO.MULTIISIN M
WHERE M.SCRIP_CD = NSESYMBOL
AND M.SERIES = NSEGROUP
AND VALID = 1

UPDATE #NSEDATA SET SCRIPISIN = M.ISIN
FROM MSAJAG.DBO.MULTIISIN M
WHERE M.SCRIP_CD = NSESYMBOL
AND VALID = 1
AND M.SERIES IN ('EQ', 'BE')
AND NSEGROUP IN ('EQ', 'BE')
AND SCRIPISIN = ''

SELECT * FROM #NSEDATA                    
union all                     
SELECT                          
 Brokersebino='INB011205730',                       
 Contractno=contractno,                      
 Exchange='B',                      
TRADEDATE = CONVERT(VARCHAR,SAUDA_DATE,111),                       
SEGMENT=S.SETT_TYPE,                      
SETTNO=RIGHT(S.SETT_NO,3),                     
SETTYEAR='2007',                      
BACKOFFICECODE=S.PARTY_CODE ,                      
BSECODE=S2.BSECODE,                      
NSESYMBOL='',                      
NSEGROUP=S.SERIES,                      
SCRIPISIN=ISNULL(M.ISIN,''),                        
SCRIPNAME = S1.LONG_NAME,                       
SELLBUY = (CASE WHEN SELL_BUY = 1 THEN 'B' ELSE 'S'  END),                       
TRADEQTY = (CASE WHEN SELL_BUY = 1 THEN SUM(TRADEQTY) ELSE  SUM(TRADEQTY) END),                        
MARKETRATE =SUM(TRADEQTY*MARKETRATE)/SUM(TRADEQTY) ,                       
NETRATE=SUM(TRADEQTY*N_NETRATE)/SUM(TRADEQTY) ,                       
SERVICETAX=SUM(NSERTAX),                      
STT = SUM(INS_CHRG),                        
OTHERCHARGES=SUM(TURN_TAX+S.OTHER_CHRG+SEBI_TAX+BROKER_CHRG),                      
 STOCKPAYINDATE = CONVERT(VARCHAR,SM.FUNDS_PAYIN,111),                        
STOCKPAYOUTDATE = CONVERT(VARCHAR,SM.FUNDS_PAYOUT,111),                        
CASHPAYINDATE = CONVERT(VARCHAR,SM.FUNDS_PAYIN,111),                        
CASHPAYOUTDATE = CONVERT(VARCHAR,SM.FUNDS_PAYOUT,111)                        
FROM                         
BSEDB.DBO.SETT_MST SM WITH(NOLOCK),                          
BSEDB.DBO.CLIENT1 C1 WITH(NOLOCK),                          
BSEDB.DBO.CLIENT2 C2 WITH(NOLOCK),                          
BSEDB.DBO.SCRIP1 S1 WITH(NOLOCK),                          
BSEDB.DBO.SCRIP2 S2 WITH(NOLOCK),
BSEDB.DBO.SETTLEMENT S WITH(NOLOCK)
LEFT OUTER JOIN                          
BSEDB.DBO.MULTIISIN M WITH(NOLOCK)
ON S.SCRIP_CD = M.SCRIP_CD                           
 AND VALID = 1                          
WHERE                         
 C1.CL_CODE = C2.CL_CODE                          
 AND C2.PARTY_CODE = S.PARTY_CODE                          
 AND SM.SETT_NO = S.SETT_NO                          
 AND SM.SETT_TYPE = S.SETT_TYPE                          
 AND TRADEQTY > 0                          
 AND S.SCRIP_CD = S2.BSECODE                     
 AND S1.CO_CODE = S2.CO_CODE                          
  AND S.PARTY_CODE BETWEEN @FROMPARTYCODE AND @TOPARTYCODE                          
AND S.SAUDA_DATE>=@FROMDATE AND S.SAUDA_DATE <=@TODATE + ' 23:59:59'                            
AND S.MARKETRATE<>0         
AND S.TRADE_NO NOT LIKE '%C%'       
And C1.Branch_Cd Like (Case When @StatusId = 'branch' then @Statusname else '%' End)                           
And C1.Sub_broker Like (Case When @StatusId = 'subbroker' then @Statusname else '%' End)                          
And C1.Trader Like (Case When @StatusId = 'trader' then @Statusname else '%' End)                       
And C1.Family Like (Case When @StatusId = 'family' then @Statusname else '%' End)                          
And C1.Region Like (Case When @StatusId = 'region' then @Statusname else '%' End)                          
And C1.Area Like (Case When @StatusId = 'area' then @Statusname else '%' End)                          
And C2.Party_Code Like (Case When @StatusId = 'client' then @Statusname else '%' End)                      
GROUP BY                          
 S.PARTY_CODE,S.CONTRACTNO,S.SETT_TYPE,S.SETT_NO,S.SERIES, ISNULL(M.ISIN,''),         
 CONVERT(VARCHAR,SAUDA_DATE,111),                          
 S2.BSECODE,                          
 S1.LONG_NAME,                          
 C1.LONG_NAME,                          
 CONVERT(VARCHAR,SM.FUNDS_PAYIN,111),                          
 CONVERT(VARCHAR,SM.FUNDS_PAYOUT,111),                        
 SELL_BUY                  
UNION ALL                   
SELECT                          
 Brokersebino='INB011205730',                       
 Contractno=contractno,                      
 Exchange='B',                      
TRADEDATE = CONVERT(VARCHAR,SAUDA_DATE,111),                       
SEGMENT=S.SETT_TYPE,                      
SETTNO=RIGHT(S.SETT_NO,3),                     
SETTYEAR='2007',                      
BACKOFFICECODE=S.PARTY_CODE ,                      
BSECODE=S2.BSECODE,                      
NSESYMBOL='',                      
NSEGROUP=S.SERIES,                      
SCRIPISIN=ISNULL(M.ISIN,''),                        
SCRIPNAME = S1.LONG_NAME,                       
SELLBUY = (CASE WHEN SELL_BUY = 1 THEN 'B' ELSE 'S'   END),                       
TRADEQTY = (CASE WHEN SELL_BUY = 1 THEN SUM(TRADEQTY) ELSE  SUM(TRADEQTY) END),                        
MARKETRATE =SUM(TRADEQTY*MARKETRATE)/SUM(TRADEQTY) ,                       
NETRATE=SUM(TRADEQTY*N_NETRATE)/SUM(TRADEQTY) ,                       
SERVICETAX=SUM(NSERTAX),                      
STT = SUM(INS_CHRG),                        
OTHERCHARGES=SUM(TURN_TAX+S.OTHER_CHRG+SEBI_TAX+BROKER_CHRG),                      
 STOCKPAYINDATE = CONVERT(VARCHAR,SM.FUNDS_PAYIN,111),                        
STOCKPAYOUTDATE = CONVERT(VARCHAR,SM.FUNDS_PAYOUT,111),                        
CASHPAYINDATE = CONVERT(VARCHAR,SM.FUNDS_PAYIN,111),                        
CASHPAYOUTDATE = CONVERT(VARCHAR,SM.FUNDS_PAYOUT,111)                    
FROM                       
BSEDB.DBO.SETT_MST SM WITH(NOLOCK),                          
BSEDB.DBO.CLIENT1 C1 WITH(NOLOCK),                          
BSEDB.DBO.CLIENT2 C2 WITH(NOLOCK),                          
BSEDB.DBO.SCRIP1 S1 WITH(NOLOCK),                          
BSEDB.DBO.SCRIP2 S2 WITH(NOLOCK),
BSEDB.DBO.HISTORY S WITH(NOLOCK)                          
LEFT OUTER JOIN BSEDB.DBO.MULTIISIN M WITH(NOLOCK)
ON 
S.SCRIP_CD = M.SCRIP_CD                           
AND VALID = 1                      
WHERE                         
 C1.CL_CODE = C2.CL_CODE                          
 AND C2.PARTY_CODE = S.PARTY_CODE                          
 AND SM.SETT_NO = S.SETT_NO                          
 AND SM.SETT_TYPE = S.SETT_TYPE                          
 AND TRADEQTY > 0                          
 AND S.SCRIP_CD = S2.BSECODE                     
 AND S1.CO_CODE = S2.CO_CODE                          
  AND S.PARTY_CODE BETWEEN @FROMPARTYCODE AND @TOPARTYCODE                          
AND S.SAUDA_DATE>=@FROMDATE AND S.SAUDA_DATE <=@TODATE + ' 23:59:59'                              
AND S.MARKETRATE<>0      
AND S.TRADE_NO NOT LIKE '%C%'          
And C1.Branch_Cd Like (Case When @StatusId = 'branch' then @Statusname else '%' End)                           
And C1.Sub_broker Like (Case When @StatusId = 'subbroker' then @Statusname else '%' End)                          
And C1.Trader Like (Case When @StatusId = 'trader' then @Statusname else '%' End)                          
And C1.Family Like (Case When @StatusId = 'family' then @Statusname else '%' End)                          
And C1.Region Like (Case When @StatusId = 'region' then @Statusname else '%' End)                          
And C1.Area Like (Case When @StatusId = 'area' then @Statusname else '%' End)                          
And C2.Party_Code Like (Case When @StatusId = 'client' then @Statusname else '%' End)                      
GROUP BY                          
 S.PARTY_CODE,S.CONTRACTNO,S.SETT_TYPE,S.SETT_NO,S.SERIES, ISNULL(M.ISIN,''),                          
 CONVERT(VARCHAR,SAUDA_DATE,111),                          
 S2.BSECODE,                          
 S1.LONG_NAME,                          
 C1.LONG_NAME,                          
 CONVERT(VARCHAR,SM.FUNDS_PAYIN,111),                          
 CONVERT(VARCHAR,SM.FUNDS_PAYOUT,111),         
 SELL_BUY

GO
