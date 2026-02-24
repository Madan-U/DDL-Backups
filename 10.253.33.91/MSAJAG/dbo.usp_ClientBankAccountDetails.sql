-- Object: PROCEDURE dbo.usp_ClientBankAccountDetails
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE proc [dbo].[usp_ClientBankAccountDetails]
@FromParty varchar(10),
@ToParty varchar(10),
@ExchangeSegment varchar(50)
as
/*
usp_ClientBankAccountDetails 'A74198','A74198','BSE-CAPITAL'

*/
BEGIN
	

	select BankName, Branch, AcType, AcNum   from AngelNSECM.msajag.dbo.party_bank_details with (nolock)  
	where party_code >=  @FromParty AND party_code <=  @ToParty AND Exchange LIKE @ExchangeSegment + '%'
	order by Exchange

END

GO
