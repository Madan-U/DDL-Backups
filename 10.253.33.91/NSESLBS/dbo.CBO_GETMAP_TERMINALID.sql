-- Object: PROCEDURE dbo.CBO_GETMAP_TERMINALID
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE      PROCEDURE [dbo].[CBO_GETMAP_TERMINALID]
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
		Userid,
                Party_Code,
                Exceptparty,
                procli
	FROM
		TERMPARTY

GO
