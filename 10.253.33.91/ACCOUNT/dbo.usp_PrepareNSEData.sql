-- Object: PROCEDURE dbo.usp_PrepareNSEData
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


CREATE PROC [dbo].[usp_PrepareNSEData] (@SDTCUR DATETIME, @SDTNXT DATETIME)
AS
BEGIN
	DECLARE @vdt VARCHAR(11)

	SET @vdt = convert(VARCHAR(11), getdate())

	--select party_Code 
	--into #party_Code 
	--from [196.1.115.182].general.dbo.client_details
	-------------------------------------START NSE DATA PREPARATION----------------------------    
	SELECT cltcode = isnull(a.cltcode, b.cltcode), (
			CASE 
				WHEN isnull(a.balance, 0) > isnull(b.balance, 0)
					THEN isnull(a.balance, 0)
				ELSE isnull(b.balance, 0)
				END
			) AS ledger
	FROM (
		SELECT cltcode, Balance = sum(CASE 
					WHEN drcr = 'C'
						THEN - vamt
					ELSE vamt
					END)
		FROM dbo.ledger a WITH (NOLOCK)
		INNER MERGE JOIN [intranet].risk.dbo.tbl_partycode b(NOLOCK)
			ON a.cltcode = b.party_Code
		WHERE vdt >= @SDTCUR
			AND vdt <= @vdt + ' 23:59:59'
			AND NOT (
				vtyp = 18
				AND vdt >= @SDTNXT
				)
		GROUP BY cltcode
		) a
	FULL OUTER JOIN (
		SELECT cltcode, Balance = sum(CASE 
					WHEN drcr = 'C'
						THEN - vamt
					ELSE vamt
					END)
		FROM dbo.ledger a WITH (NOLOCK)
		INNER MERGE JOIN [intranet].risk.dbo.tbl_partycode b(NOLOCK)
			ON a.cltcode = b.party_Code
		WHERE vdt >= @SDTCUR
			AND edt <= @vdt + ' 23:59:59'
			AND NOT (
				vtyp = 18
				AND vdt >= @SDTNXT
				)
		GROUP BY cltcode
		) b
		ON a.cltcode = b.cltcode
END

GO
