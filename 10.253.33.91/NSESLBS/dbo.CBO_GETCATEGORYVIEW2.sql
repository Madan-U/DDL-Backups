-- Object: PROCEDURE dbo.CBO_GETCATEGORYVIEW2
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE     PROC CBO_GETCATEGORYVIEW2
		@fldAdminAuto INT,
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
	
		Where 
		Fldadminauto=@fldAdminAuto		

		order by  
		Fldcategorycode

GO
