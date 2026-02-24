-- Object: PROCEDURE dbo.RPT_TDS_SUMMARY
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE PROC RPT_TDS_SUMMARY (
@STATUSID VARCHAR(15),
@STATUSNAME VARCHAR(25),
@FROMPARTY VARCHAR(10), 
@TOPARTY VARCHAR(10), 
@FROMDATE VARCHAR(11), 
@TODATE VARCHAR(11))
AS
SELECT PARTY_CODE, LONG_NAME, L_ADDRESS1, L_ADDRESS2, L_ADDRESS3, L_CITY, L_STATE, L_ZIP, PAN_GIR_NO,
VNO, VDT=CONVERT(VARCHAR,VDT,103), 
BROKAMT=SUM(CASE WHEN NARRATION LIKE '%REM BROK SHARE' 
	         THEN (CASE WHEN DRCR = 'C' 
			    THEN VAMT 
			    ELSE -VAMT 
		       END)
	         ELSE 0 
	    END),
TDSAMT =SUM(CASE WHEN NARRATION LIKE '%REM TDS AMOUNT' 
	         THEN (CASE WHEN DRCR = 'D' 
			    THEN VAMT 
			    ELSE -VAMT 
		       END)
	         ELSE 0 
	    END),
TDSPER = 'TDS-5.61%',
DD = DAY(VDT), MM = MONTH(VDT), YY = YEAR(VDT)
FROM CLIENT1 C1, CLIENT2 C2, ACCOUNT.DBO.LEDGER L
WHERE C1.CL_CODE = C2.CL_CODE
AND C2.PARTY_CODE = L.CLTCODE
AND VTYP = 30
AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY
AND VDT BETWEEN @FROMDATE AND @TODATE + ' 23:59:59'
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

GROUP BY PARTY_CODE, LONG_NAME, L_ADDRESS1, L_ADDRESS2, 
L_ADDRESS3, L_CITY, L_STATE, PAN_GIR_NO, L_ZIP, VNO, CONVERT(VARCHAR,VDT,103),
DAY(VDT), MONTH(VDT), YEAR(VDT)
ORDER BY PARTY_CODE, YEAR(VDT), MONTH(VDT), DAY(VDT)

GO
