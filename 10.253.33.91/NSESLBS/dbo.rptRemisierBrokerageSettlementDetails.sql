-- Object: PROCEDURE dbo.rptRemisierBrokerageSettlementDetails
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


--Report: Remisier Sharing Settlement Details
CREATE PROCEDURE rptRemisierBrokerageSettlementDetails
(
	@Status VARCHAR(10),
	@Flag SMALLINT = 0,			-- 0-> TDS Voucher Posted & Not Posted; 1->TDS Voucher Not Posted ; 2-> TDS Voucher Posted; 
	@ExecDate VARCHAR(11)
)
AS
BEGIN

	IF @Status = 'A' 
		SET @Status = NULL

	IF @ExecDate <> ''
		SET @ExecDate = CONVERT(CHAR(11), @ExecDate, 109)
	
	print CONVERT(CHAR(11), @ExecDate, 109)

	IF @ExecDate = '' 
		SELECT
			Sett_No,
			Start_Date,
			End_Date,
			Fund_Date = Funds_PayIn,
			CASE ISNull(Status,'O') WHEN 'C' THEN 'Closed' ELSE 'Open' END AS Status,
			TDSPercentage,
			IsNull(TDSChequeNo,'') AS TDSChequeNo,
			IsNull(TDSVNo, '') AS TDSVNo,
			CASE IsNull(TDSVDate, '') WHEN 'JAN 01 1900' THEN '' ELSE CONVERT(CHAR(11), IsNull(TDSVDate, ''), 109) END AS TDSVDate
			FROM Rem_Sett_Mst
			WHERE ISNULL(Status, '') = ISNULL(@Status, ISNULL(Status, ''))
			AND ISNULL(TDSChequeNo, '') = CASE @Flag 
														WHEN 0 THEN ISNULL(TDSChequeNo, '') 
														WHEN 1 THEN '' ELSE 
														(CASE WHEN ISNULL(TDSChequeNo, '') <> '' THEN TDSChequeNo ELSE '00000000' END) 
													END
		ORDER BY Start_Date
	ELSE IF @ExecDate <> '' 
		SELECT
			Sett_No,
			Start_Date,
			End_Date,
			Fund_Date = Funds_PayIn,
			CASE ISNull(Status,'O') WHEN 'C' THEN 'Closed' ELSE 'Open' END AS Status,
			TDSPercentage,
			IsNull(TDSChequeNo,'') AS TDSChequeNo,
			IsNull(TDSVNo, '') AS TDSVNo,
			CASE IsNull(TDSVDate, '') WHEN 'JAN 01 1900' THEN '' ELSE CONVERT(CHAR(11), IsNull(TDSVDate, ''), 109) END AS TDSVDate
			FROM Rem_Sett_Mst
			WHERE ISNULL(Status, '') = ISNULL(@Status, ISNULL(Status, ''))
			AND ISNULL(TDSChequeNo, '') = CASE @Flag 
														WHEN 0 THEN ISNULL(TDSChequeNo, '') 
														WHEN 1 THEN '' ELSE 
														(CASE WHEN ISNULL(TDSChequeNo, '') <> '' THEN TDSChequeNo ELSE '00000000' END) 
													END
			AND (@ExecDate BETWEEN Start_Date AND End_Date  OR End_Date <= @ExecDate)
		ORDER BY Start_Date	
END


/*

EXEC rptRemisierBrokerageSettlementDetails 'A', 0,'01/02/2006' 

Select * From Rem_Sett_Mst where TDSVDate = '01/02/2006'


*/

GO
