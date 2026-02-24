-- Object: PROCEDURE dbo.CBO_DELCUSTODIAN
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------





CREATE  PROCEDURE CBO_DELCUSTODIAN
(
      @CUSTODIANCODE  varchar(20),
      @STATUSID VARCHAR(25),
      @STATUSNAME VARCHAR(25)
)
AS
IF @STATUSID <> 'BROKER'
		BEGIN
			RAISERROR ('This Procedure is accessible to Broker', 16, 1)
			RETURN
		END

  
		DELETE CUSTODIAN where Custodiancode =@CUSTODIANCODE

GO
