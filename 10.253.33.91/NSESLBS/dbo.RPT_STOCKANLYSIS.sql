-- Object: PROCEDURE dbo.RPT_STOCKANLYSIS
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE PROC RPT_STOCKANLYSIS (
@STATUSID VARCHAR(20),
@STATUSNAME VARCHAR(25),
@TDATE VARCHAR(11),
@BRANCH_CD VARCHAR(10),
@SUBBROKER VARCHAR(10),
@FROMPARTY VARCHAR(10),
@TOPARTY VARCHAR(10) 
)
AS
SELECT T.PARTY_CODE, LONG_NAME, LEDBAL, OUTLEDBAL, HOLDAMT, SCRIP_NAME, SCRIP_CD, SERIES, 
SETT_NO, SETT_TYPE, QTY, CL_RATE, AMT = CL_RATE * QTY, SOLDQTY, SOLDAMT = SOLDQTY * CL_RATE,
BRANCH_CD, SUB_BROKER, TRADER, DUMMY10, 
PAYFLAG = (CASE WHEN PAYFLAG = 0 THEN 'CHECK DEBIT'
		WHEN PAYFLAG = 1 THEN 'ALWAYS PAYOUT'
		ELSE 'TRANS TO BEN'
	   END)
FROM TBL_STOCK_HOLD T, CLIENT1 C1, CLIENT2 C2
WHERE C1.CL_CODE = C2.CL_CODE
AND C2.PARTY_CODE = T.PARTY_CODE
AND T.START_DATE LIKE @TDATE + '%'
AND BRANCH_CD LIKE @BRANCH_CD
AND SUB_BROKER LIKE @SUBBROKER
AND T.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY
AND FLAG = 1
And @StatusName =           
                  (case           
                        when @StatusId = 'BRANCH' then c1.branch_cd          
                        when @StatusId = 'SUBBROKER' then c1.sub_broker          
                        when @StatusId = 'Trader' then c1.Trader          
                        when @StatusId = 'Family' then c1.Family          
                        when @StatusId = 'Area' then c1.Area          
                        when @StatusId = 'Region' then c1.Region          
                        when @StatusId = 'Client' then c2.party_code          
                  else           
                        'BROKER'          
                  End)          

ORDER BY T.PARTY_CODE, LONG_NAME, SCRIP_NAME

GO
