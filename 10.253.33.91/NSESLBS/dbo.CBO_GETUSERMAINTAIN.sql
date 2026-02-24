-- Object: PROCEDURE dbo.CBO_GETUSERMAINTAIN
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------




CREATE    PROC CBO_GETUSERMAINTAIN
	
	@STATUSID VARCHAR(25) = 'BROKER',
	@STATUSNAME VARCHAR(25) = 'BROKER'
AS
	IF @STATUSID <> 'BROKER'
		BEGIN
			RAISERROR ('This Procedure is accessible to Broker', 16, 1)
			RETURN
		END				
	SELECT
		Fldauto_Admin,
                Fldname,
		Fldcompany = ISNULL(Fldcompany, ''),
		Fldstatus,
		Flddesc = ISNULL(Flddesc, '')
		
		
	FROM
		TBLADMIN
	
	ORDER BY
		Fldname

GO
