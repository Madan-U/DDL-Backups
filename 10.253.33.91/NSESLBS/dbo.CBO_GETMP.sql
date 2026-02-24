-- Object: PROCEDURE dbo.CBO_GETMP
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------






CREATE      PROCEDURE [dbo].[CBO_GETMP]
(
	@BANKID VARCHAR(15) = '',
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
		Party_Code  
                
	FROM
		Client2

GO
