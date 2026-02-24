-- Object: PROCEDURE dbo.RPT_STOCKANLYSIS_HOLDING
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE PROC RPT_STOCKANLYSIS_HOLDING (
@STATUSID VARCHAR(20),
@STATUSNAME VARCHAR(25),
@PARTY_CODE VARCHAR(10)
)
AS
SELECT T.PARTY_CODE, LONG_NAME, SCRIP_NAME, SCRIP_CD, SERIES, 
SETT_NO, SETT_TYPE, QTY, CL_RATE, AMT = CL_RATE * QTY
FROM TBL_STOCK_HOLD T, CLIENT1 C1, CLIENT2 C2
WHERE C1.CL_CODE = C2.CL_CODE
AND C2.PARTY_CODE = T.PARTY_CODE
AND T.PARTY_CODE = @PARTY_CODE
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
