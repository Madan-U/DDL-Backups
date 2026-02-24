-- Object: PROCEDURE dbo.rptRemisierBrokerageBlockedDetails
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


--Report: Remisier Brokerage Blocked 
CREATE PROCEDURE rptRemisierBrokerageBlockedDetails
(
	@RemType VARCHAR(10),
	@Segment VARCHAR(10),
	@Exchange VARCHAR(5),
	@ExecDate VARCHAR(11)
)
AS
BEGIN

	IF @Segment = ''
		SET @Segment = 'ALL'

	IF @Exchange = ''
		SET @Exchange = 'ALL'

	SELECT 
		RemType = CASE R.RemType WHEN 'PARTY' THEN 'PARTY' WHEN 'SUB' THEN 'SBU' END,
		R.RemCode,
		RemName = CASE WHEN RemType = 'PARTY' THEN DBO.GetPartyNameForGivenPartyCode(RemCode) ELSE S.Sbu_Name END,
		R.Segment,
		R.Exchange,
		R.FromDate,
		R.ToDate,
		R.BlockedReason
	FROM RemisierBrokerageBlocked R LEFT JOIN Sbu_Master S ON R.RemCode = S.Sbu_Code
	WHERE R.Segment = CASE @Segment WHEN 'ALL' THEN R.Segment ELSE @Segment END
		AND R.Exchange = CASE @Exchange WHEN 'ALL' THEN R.Exchange ELSE @Exchange END
		AND R.RemType = CASE @RemType WHEN '' THEN R.RemType ELSE @RemType END
		AND R.FromDate <= CASE @ExecDate WHEN '' THEN R.FromDate ELSE @ExecDate END 
		AND R.ToDate >= CASE @ExecDate WHEN '' THEN R.ToDate ELSE @ExecDate END 
	ORDER BY	R.RemType, R.FromDate, R.RemCode 

	END

/*

	EXEC rptRemisierBrokerageBlockedDetails '', '', '', ''

*/

GO
