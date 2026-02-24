-- Object: PROCEDURE dbo.RPT_SECREGISTER
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE PROC RPT_SECREGISTER 
	(
	@STATUSID VARCHAR(25), 
	@STATUSNAME VARCHAR(25), 
	@FROMDATE VARCHAR(11), 
	@TODATE VARCHAR(11), 
	@FROMPARTY VARCHAR(10), 
	@TOPARTY VARCHAR(10)
	)

	AS

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SELECT 
		D.PARTY_CODE, 
		C1.LONG_NAME, 
		D.SCRIP_CD, 
		SCRIP_NAME=S1.LONG_NAME,
		TRANSDATE = CONVERT(VARCHAR,TRANSDATE,103),
		TORECORDEL = MEMBERCODE + ' ' + COMPANY,
		PURPOSE = (CASE WHEN DRCR = 'C' THEN 'PAYIN' ELSE 'PAYOUT' END),
		RECQTY = SUM(CASE WHEN DRCR = 'C' THEN QTY ELSE 0 END), 
		DELQTY = SUM(CASE WHEN DRCR = 'D' THEN QTY ELSE 0 END), 
		BALANCE = 0, 
		REMARK = '',
		CONVERT(VARCHAR,TRANSDATE,112)

	FROM 
		DELTRANS D, 
		SCRIP1 S1, 
		SCRIP2 S2, 
		CLIENT1 C1, 
		CLIENT2 C2, 
		OWNER
	WHERE 
		C1.CL_CODE = C2.CL_CODE
		AND C2.PARTY_CODE = D.PARTY_CODE
		AND S1.CO_CODE = S2.CO_CODE
		AND S1.SERIES = S2.SERIES
		AND S2.SCRIP_CD = D.SCRIP_CD
		AND S2.SERIES = D.SERIES
		AND FILLER2 = 1 
		AND SHARETYPE <> 'AUCTION'
		AND TRTYPE <> 906
		AND D.PARTY_CODE <> 'BROKER'
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
		AND TRANSDATE BETWEEN @FROMDATE AND @TODATE + ' 23:59'
		AND D.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY
	GROUP BY 
		D.PARTY_CODE, C1.LONG_NAME, 
		D.SCRIP_CD, S1.LONG_NAME,
		CONVERT(VARCHAR,TRANSDATE,103), DRCR,
		MEMBERCODE, COMPANY,
		CONVERT(VARCHAR,TRANSDATE,112)
	ORDER BY 
		D.PARTY_CODE,
		CONVERT(VARCHAR,TRANSDATE,112)

GO
