-- Object: PROCEDURE dbo.CBO_GETMULTIBANK
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------





--select * from account.dbo.multibankid


CREATE     PROCEDURE CBO_GETMULTIBANK

@PARTYCODE varchar(50),
@STATUSID VARCHAR(25) = 'BROKER',
@STATUSNAME VARCHAR(25) = 'BROKER' 
AS
BEGIN

	DECLARE @SQL VARCHAR(500)
	SET @SQL='SELECT account.dbo.MultiBankId.Cltcode, isnull(account.dbo.MultiBankId.BankID,'''') as BankId, POBank.Bank_Name as Bank_Name, branch_name, AccNo,
	AccType, ChequeName, DefaultBank, Acname from account.dbo.MultiBankId , account.dbo.ACMAST , msajag.dbo.pobank AS POBank
	WHERE account.dbo.MultiBankId.Cltcode = '+ char(39)+LTRIM(RTRIM(@PARTYCODE))+char(39)+' and POBank.BankId = account.dbo.MultiBankId.BankId AND account.dbo.MultiBankId.Cltcode = account.dbo.ACMAST.Cltcode'

	EXEC(@sql)
--'+ @SHAREDB +'


END

GO
