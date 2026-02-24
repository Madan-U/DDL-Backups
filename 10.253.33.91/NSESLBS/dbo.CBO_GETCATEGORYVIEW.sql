-- Object: PROCEDURE dbo.CBO_GETCATEGORYVIEW
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------




CREATE    PROC CBO_GETCATEGORYVIEW
	
	@STATUSID VARCHAR(25) = 'BROKER',
	@STATUSNAME VARCHAR(25) = 'BROKER'
AS
	IF @STATUSID <> 'BROKER'
		BEGIN
			RAISERROR ('This Procedure is accessible to Broker', 16, 1)
			RETURN
		END
	
	
		Select 
		Fldcategorycode,
		Fldcategoryname,
		Fldadminauto,
		Flddesc
		
		From	
		tblCategory 
		order by  
		Fldcategorycode

GO
