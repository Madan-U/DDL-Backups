-- Object: PROCEDURE dbo.CBO_GetSettType
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


-- exec CBO_GetSettType 'NSE'  
CREATE  Proc CBO_GetSettType  
(  
	@Exchange VARCHAR(5) = '',  
	@STATUSID VARCHAR(25) = 'BROKER',
	@STATUSNAME VARCHAR(25) = 'BROKER'
)
AS
BEGIN  

	IF @STATUSID <> 'BROKER'
		BEGIN
			RAISERROR ('This Procedure is accessible to Broker', 16, 1)
			RETURN
		END
  
	SELECT @Exchange = ISNULL(@Exchange, '')  
	
	IF @Exchange = ''   
		SELECT Sett_Type From Sett_Type  ORDER BY Sett_Type  
	ELSE IF @Exchange <> ''   
		SELECT Sett_Type From Sett_Type WHERE Exchange = @Exchange  ORDER BY Sett_Type  
   
END

GO
