-- Object: PROCEDURE dbo.rptRemisierBrokerageTDSDetails
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


--Report: Remisier Brokerage TDS Details
CREATE PROCEDURE rptRemisierBrokerageTDSDetails
(
	@RemType VARCHAR(10),
	@ExecDate VARCHAR(11)
)
AS
BEGIN

	SELECT
		RemType = CASE RemType WHEN 'BR' THEN 'BRANCH' WHEN 'SUB' THEN 'SBU' END,
		R.RemCode,
		RemName = CASE R.RemType WHEN 'BR' THEN  S.BranchName WHEN 'SUB' THEN S.SBUName END,
		R.FromDate,
		R.ToDate,
		R.TDSPercentage,
		Remark =ISNULL(R.Remark, '')
	FROM RemisierBrokerageTDS R LEFT JOIN (
		SELECT SBUCode=Sbu_Code, SBUName=Sbu_Name, BranchCode= '', BranchName = '' FROM Sbu_Master WHERE Sbu_Type = 'SBU'
		UNION ALL
		SELECT SBUCode='', SBUName='', BranchCode= Branch_Code, BranchName = Branch  FROM Branch) S
	ON R.RemCode = CASE R.RemType WHEN 'BR' THEN S.BranchCode WHEN 'SUB' THEN S.SBUCode END
	WHERE R.RemType = CASE @RemType WHEN '' THEN R.RemType ELSE @RemType END
	AND R.FromDate <= CASE @ExecDate WHEN '' THEN R.FromDate ELSE @ExecDate END 
	AND R.ToDate >= CASE @ExecDate WHEN '' THEN R.ToDate ELSE @ExecDate END 
	ORDER BY	R.RemType, R.FromDate, R.RemCode 

END

/*

	EXEC rptRemisierBrokerageTDSDetails '', ''

*/

GO
