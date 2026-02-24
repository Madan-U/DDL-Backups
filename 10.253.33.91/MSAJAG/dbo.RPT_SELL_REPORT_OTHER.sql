-- Object: PROCEDURE dbo.RPT_SELL_REPORT_OTHER
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE PROC RPT_SELL_REPORT_OTHER
(
	@STATUSID	VARCHAR(20),
	@STATUSNAME VARCHAR(50),	
	@PARTY_CODE	VARCHAR(10),
	@SAUDA_DATE	VARCHAR(11),
	@NOOFDAYS	INT
)
AS

SELECT EXCHANGE, C.PARTY_CODE, SCRIP_CD, SERIES, QTY=SUM(QTY), CL_RATE, SELLAMT=SUM(SELLAMT),TOSELLQTY = SUM(TOSELLQTY)
FROM TBL_RMS_SALE_OTHER T, CLIENT_DETAILS C
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
AND NOOFDAYS = @NOOFDAYS
GROUP BY EXCHANGE, C.PARTY_CODE, SCRIP_CD, SERIES, CL_RATE
ORDER BY EXCHANGE, SCRIP_CD, SERIES

GO
