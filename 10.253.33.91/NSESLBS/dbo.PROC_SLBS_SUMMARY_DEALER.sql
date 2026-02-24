-- Object: PROCEDURE dbo.PROC_SLBS_SUMMARY_DEALER
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- EXEC PROC_SLBS_SUMMARY_DEALER 'BROKER', 'BROKER', 'JUL 22 2012', '0', 'ZZZ'

CREATE  PROC PROC_SLBS_SUMMARY_DEALER  
(  
 @statusid	varchar(10),
 @statusname	varchar(50),
 @SAUDA_DATE VARCHAR(11),  
 @FROMDEALER VARCHAR(10),  
 @TODEALER VARCHAR(10)  
)  

AS  
 SELECT MARGIN_DATE=@SAUDA_DATE, TRADER, S.PARTY_CODE,  S.SCRIP_CD, S.SERIES,
 EXPIRYDATE  ,      
 LENDQTY=ABS(SUM(CASE WHEN S.SELL_BUY IN (1,3) THEN S.TRADEQTY ELSE -S.TRADEQTY END)),       
 BORROWQTY=0,
 RET_SETT_NO = CONVERT(VARCHAR(7),''),
 CL_RATE = CONVERT(NUMERIC(18,4),0)  
 INTO #MARGIN_REQ  
 FROM SETTLEMENT S, TRD_SETT_POS T, MSAJAG.DBO.CLIENT_DETAILS C      
 WHERE S.SAUDA_DATE = T.SAUDA_DATE      
 AND S.ORDER_NO = T.ORDER_NO      
 AND S.TRADE_NO = PRADNYA.DBO.REPLACETRADENO(T.TRADE_NO)      
 AND S.SCRIP_CD = T.SCRIP_CD      
 AND S.SCRIP_CD = T.SCRIP_CD      
 AND S.SERIES = T.SERIES             
 AND T.SELL_BUY IN (2,3)    
 AND CONVERT(DATETIME,EXPIRYDATE) >= @SAUDA_DATE    
 AND S.SAUDA_DATE  <= @SAUDA_DATE
 AND S.PARTY_CODE = C.PARTY_CODE
AND C.TRADER BETWEEN @FROMDEALER AND @TODEALER 
And @StatusName =           
                  (case           
                        when @StatusId = 'BRANCH' then C.branch_cd          
                        when @StatusId = 'SUBBROKER' then C.sub_broker          
                        when @StatusId = 'Trader' then C.Trader          
                        when @StatusId = 'Family' then C.Family          
                        when @StatusId = 'Area' then C.Area          
                        when @StatusId = 'Region' then C.Region          
                        when @StatusId = 'Client' then c.party_code          
                  else           
                        'BROKER'          
                  End)
 GROUP BY TRADER, S.SCRIP_CD, S.SERIES, S.PARTY_CODE, EXPIRYDATE      
 HAVING SUM(CASE WHEN S.SELL_BUY IN (1,3) THEN S.TRADEQTY ELSE -S.TRADEQTY END) <> 0

 INSERT INTO #MARGIN_REQ
 SELECT MARGIN_DATE=@SAUDA_DATE, TRADER, S.PARTY_CODE, S.SCRIP_CD, S.SERIES,       
 EXPIRYDATE      ,
 LENDQTY = 0,       
 BORROWQTY=ABS(SUM(CASE WHEN S.SELL_BUY IN (1,3) THEN S.TRADEQTY ELSE -S.TRADEQTY END)),
 RET_SETT_NO = CONVERT(VARCHAR(7),''),
 CL_RATE = CONVERT(NUMERIC(18,4),0)
 FROM SETTLEMENT S, TRD_SETT_POS T, MSAJAG.DBO.CLIENT_DETAILS C     
 WHERE S.SAUDA_DATE = T.SAUDA_DATE      
 AND S.ORDER_NO = T.ORDER_NO      
 AND S.TRADE_NO = PRADNYA.DBO.REPLACETRADENO(T.TRADE_NO)      
 AND S.SCRIP_CD = T.SCRIP_CD      
 AND S.SCRIP_CD = T.SCRIP_CD      
 AND S.SERIES = T.SERIES          
 AND T.SELL_BUY IN (1,4)    
 AND CONVERT(DATETIME,EXPIRYDATE) >= @SAUDA_DATE  
 AND S.SAUDA_DATE  <= @SAUDA_DATE
 AND S.PARTY_CODE = C.PARTY_CODE
AND C.TRADER BETWEEN @FROMDEALER AND @TODEALER 
And @StatusName =           
                  (case           
                        when @StatusId = 'BRANCH' then C.branch_cd          
                        when @StatusId = 'SUBBROKER' then C.sub_broker          
                        when @StatusId = 'Trader' then C.Trader          
                        when @StatusId = 'Family' then C.Family          
                        when @StatusId = 'Area' then C.Area          
                        when @StatusId = 'Region' then C.Region          
                        when @StatusId = 'Client' then c.party_code          
                  else           
                        'BROKER'          
                  End)
 GROUP BY TRADER, S.SCRIP_CD, S.SERIES, S.PARTY_CODE, EXPIRYDATE      
 HAVING SUM(CASE WHEN S.SELL_BUY IN (1,3) THEN S.TRADEQTY ELSE -S.TRADEQTY END) <> 0


UPDATE #MARGIN_REQ SET RET_SETT_NO = S.SETT_NO  
FROM SETT_MST S WHERE SETT_TYPE = 'P' AND SEC_PAYIN LIKE LEFT(EXPIRYDATE,11) + '%'  
AND RIGHT(SETT_NO,3) >= 501  

UPDATE #MARGIN_REQ SET CL_RATE = C.CL_RATE
FROM MSAJAG.DBO.CLOSING C
WHERE LEFT(C.SYSDATE,11) = (SELECT LEFT(MAX(SYSDATE),11) FROM MSAJAG.DBO.CLOSING WHERE SYSDATE <= @SAUDA_DATE + ' 23:59:59')
AND C.SCRIP_CD = #MARGIN_REQ.SCRIP_CD
AND C.SERIES IN ('EQ', 'BE')

SELECT PARTY_CODE, TRADER, SCRIP_CD,SERIES,EXPIRYDATE=REPLACE(CONVERT(VARCHAR,EXPIRYDATE,106),' ','-'),
	   LENDQTY=SUM(LENDQTY),BORROWQTY=SUM(BORROWQTY),CL_RATE,RET_SETT_NO, OPENVAL = (SUM(BORROWQTY)-SUM(LENDQTY))*CL_RATE
FROM   #MARGIN_REQ  
GROUP BY PARTY_CODE, TRADER, SCRIP_CD,SERIES,EXPIRYDATE,CL_RATE,RET_SETT_NO
ORDER BY TRADER, PARTY_CODE, RET_SETT_NO, SCRIP_CD, SERIES  
  
DROP TABLE #MARGIN_REQ

GO
