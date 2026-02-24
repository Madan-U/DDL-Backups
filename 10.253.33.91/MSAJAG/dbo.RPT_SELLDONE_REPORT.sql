-- Object: PROCEDURE dbo.RPT_SELLDONE_REPORT
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE PROC RPT_SELLDONE_REPORT
(
	@STATUSID	VARCHAR(20),
	@STATUSNAME VARCHAR(50),
	@PARTY_CODE	VARCHAR(10),
	@SAUDA_DATE	VARCHAR(11)
)
AS

SELECT EXCHANGE, C.PARTY_CODE, SCRIP_CD, SERIES, TOSELLQTY, CL_RATE, SELLAMT, 
ACT_QTY=TOSELLQTY, ACT_RATE=CL_RATE, ACT_AMT=SELLAMT 
INTO #TBL_RMS_SALE FROM TBL_RMS_SALE T, CLIENT_DETAILS C
WHERE PROCESS_DATE = @SAUDA_DATE
AND C.PARTY_CODE = T.PARTY_CODE
AND @StatusName =           
                  (case           
                        when @StatusId = 'BRANCH' then c.branch_cd          
                        when @StatusId = 'SUBBROKER' then c.sub_broker          
                        when @StatusId = 'Trader' then c.Trader          
                        when @StatusId = 'Family' then c.Family          
                        when @StatusId = 'Area' then c.Area          
                        when @StatusId = 'Region' then c.Region          
                        when @StatusId = 'Client' then c.party_code          
                  else           
                        'BROKER'          
                  End) 
AND C.PARTY_CODE = @PARTY_CODE 

UPDATE #TBL_RMS_SALE SET ACT_QTY=0, ACT_RATE=0, ACT_AMT=0

UPDATE #TBL_RMS_SALE SET ACT_QTY=QTY, ACT_RATE=RATE, ACT_AMT=AMT 
FROM (
		SELECT EXCHANGE='NSE', PARTY_CODE, SCRIP_CD, SERIES, QTY = SUM(TRADEQTY), RATE = SUM(TRADEQTY*MARKETRATE)/SUM(TRADEQTY), AMT = SUM(TRADEQTY*MARKETRATE)
		FROM TRADE_MATCH
		WHERE SAUDA_DATE LIKE @SAUDA_DATE + '%'
		AND PARTY_CODE = @PARTY_CODE
		GROUP BY PARTY_CODE, SCRIP_CD, SERIES
		UNION
		SELECT EXCHANGE='BSE', PARTY_CODE, SCRIP_CD, SERIES, QTY = SUM(TRADEQTY), RATE = SUM(TRADEQTY*MARKETRATE)/SUM(TRADEQTY), AMT = SUM(TRADEQTY*MARKETRATE)
		FROM Trade_Match_Bse
		WHERE SAUDA_DATE LIKE @SAUDA_DATE + '%'
		AND PARTY_CODE = @PARTY_CODE
		GROUP BY PARTY_CODE, SCRIP_CD, SERIES
	 ) A
WHERE #TBL_RMS_SALE.EXCHANGE = A.EXCHANGE
AND   #TBL_RMS_SALE.PARTY_CODE = A.PARTY_CODE
AND   #TBL_RMS_SALE.SCRIP_CD = (CASE WHEN A.EXCHANGE = 'NSE' THEN A.SCRIP_CD ELSE #TBL_RMS_SALE.SCRIP_CD END)
AND   #TBL_RMS_SALE.SERIES = (CASE WHEN A.EXCHANGE = 'NSE' THEN A.SERIES ELSE A.SCRIP_CD END)

SELECT * FROM #TBL_RMS_SALE
ORDER BY SCRIP_CD, SERIES

GO
