-- Object: PROCEDURE dbo.Stp_GetExportedContractISO515
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE PROCEDURE Stp_GetExportedContractISO515
(
	@SaudaDate Varchar(11)  
)
AS  
BEGIN
	SET NOCOUNT ON

	DECLARE @T_ContractDetails TABLE (
		Exchange VARCHAR(5) DEFAULT(''),
		Batchno	VARCHAR(7) DEFAULT(''),
		Partycode VARCHAR(10) DEFAULT(''),
		PartyName VARCHAR(200) DEFAULT(''),
		ContractNo VARCHAR(10) DEFAULT(''),
		Creationdate VARCHAR(20) DEFAULT('')
		)

	INSERT INTO @T_ContractDetails( 
		Exchange,
		Batchno,
		Partycode,
		Contractno,
		Creationdate)
	SELECT	
		DISTINCT	
		LastDateTime,
		Batchno,
		Partycode,
		Contractno,
		Creationdate = Convert(DateTime, Creationdate + ' ' + SubString(Creationtime, 1,2) + ':' + SubString(Creationtime, 3,2) + ':' + SubString(Creationtime, 5,2) , 109)
	FROM Stp_Header_new
	WHERE SubString(Username, 2,11) = @SaudaDate 
	AND Serviceprovider ='ISO515'
	AND Recordtype = '515'

	UPDATE @T_ContractDetails SET PartyName = C1.Long_Name 
		FROM @T_ContractDetails T, Client1 C1, Client2 C2
		WHERE T.PartyCode = C2.Party_Code
		AND C1.CL_Code = C2.CL_Code

	SET NOCOUNT OFF

	SELECT * FROM @T_ContractDetails ORDER BY ContractNo

END

/*

EXEC Stp_GetExportedContractISO515 'MAY 28 2007', 'NSE'

EXEC Stp_GetExportedContractISO515 'FEB 15 2006', 'BSE'

EXEC Stp_TradeDetailsISO515  'BSE', '0000375'

EXEC Stp_TradeDetailsISO515  'NSE', '0000103'

	SELECT	
		DISTINCT	
		Batchno,
		Partycode,
		Contractno,
		Convert(DateTime, Creationdate , 109) ,
		Convert(DateTime, Creationdate + ' ' + SubString(Creationtime, 1,2) + ':' + SubString(Creationtime, 3,2) + ':' + SubString(Creationtime, 5,2) , 109) ,
		Creationtime
	FROM Stp_Header_new


*/

GO
