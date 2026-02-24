-- Object: PROCEDURE dbo.CBO_DELPOBANK
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE PROC [dbo].[CBO_DELPOBANK]
	@BANKID NUMERIC(18),
	@STATUSID VARCHAR(25) = 'BROKER',
	@STATUSNAME VARCHAR(25) = 'BROKER'
AS
	IF @STATUSID <> 'BROKER'
		BEGIN
			RAISERROR ('This Procedure is accessible to Broker', 16, 1)
			RETURN
		END
	DELETE FROM
		POBANK
	WHERE
		BANKID = @BANKID

GO
