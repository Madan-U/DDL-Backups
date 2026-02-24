-- Object: PROCEDURE dbo.rptSbuRegDetails
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


--Report: Remisier Brokerage TDS Details
CREATE PROCEDURE rptSbuRegDetails
(
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
		Sbu_Code=SubBroker,
		Sbu_Name,
		RegDate = RegFromDate,
		AccoutingStartSettNo, 
		Segment,
		Exchange,
		SBUParty=SubBrokerParty,
		SBUPartyName = DBO.GetPartyNameForGivenPartyCode(SubBrokerParty)
	FROM SubBrokerRegDetails S, Sbu_Master SBU
	WHERE Segment = CASE @Segment WHEN 'ALL' THEN Segment ELSE @Segment END
	AND Exchange = CASE @Exchange WHEN 'ALL' THEN Exchange ELSE @Exchange END
	AND RegFromDate <= CASE @ExecDate WHEN '' THEN RegFromDate ELSE @ExecDate END 
	AND S.SubBroker = SBU.Sbu_Code AND SBU.Sbu_Type = 'SBU'
	ORDER BY	BranchCode, SubBroker, RegFromDate 


END

/*

	EXEC rptSbuRegDetails '', '', 'MAY 01 2006'

Segment
Exchange
Reg. Date

*/

GO
