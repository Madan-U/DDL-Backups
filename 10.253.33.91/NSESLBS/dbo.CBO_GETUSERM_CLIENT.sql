-- Object: PROCEDURE dbo.CBO_GETUSERM_CLIENT
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE    PROC CBO_GETUSERM_CLIENT
	
	@cat VARCHAR(20),
	@STATUSID VARCHAR(25) = 'ADMINISTRATOR',
	@STATUSNAME VARCHAR(25) = 'ADMINISTRATOR'
AS
	IF @STATUSID <> 'ADMINISTRATOR'
		BEGIN
			RAISERROR ('This Procedure is accessible to ADMINISTRATOR', 16, 1)
			RETURN
		END				
	SELECT
		
               party_code     
		
		
	FROM
		client2
	
	WHERE 
		party_code=@cat

GO
