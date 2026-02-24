-- Object: PROCEDURE dbo.CBO_DELTERMINAL
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------







CREATE  PROCEDURE CBO_DELTERMINAL
(
      @USERID  varchar(20),
      @STATUSID VARCHAR(25),
      @STATUSNAME VARCHAR(25)
)
AS
IF @STATUSID <> 'BROKER'
		BEGIN
			RAISERROR ('This Procedure is accessible to Broker', 16, 1)
			RETURN
		END

  
		DELETE TERMLIMIT where Userid =@USERID

GO
