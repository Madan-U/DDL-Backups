-- Object: PROCEDURE dbo.CBO_GETSUBBROKERS
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

Create PROCEDURE CBO_GETSUBBROKERS
(
	--@BANKID VARCHAR(15) = '',
	@STATUSID VARCHAR(25) = 'BROKER',
	@STATUSNAME VARCHAR(25) = 'BROKER'
)
AS

	IF @STATUSID <> 'BROKER'
		BEGIN
			RAISERROR ('This Procedure is accessible to Broker', 16, 1)
			RETURN
		END
	SELECT
    Sub_Broker,
    Name,
    Address1,
    Address2,
    City,
    State,
    Nation,
    Zip,
    Fax,
    Phone1,
    Phone2,
    Reg_No,
    Registered,
    Main_Sub,
    Email,
    Com_Perc,
    Branch_Code,  
    Contact_Person,
    RemPartyCode
	FROM
		SUBBROKERS

GO
