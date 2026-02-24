-- Object: PROCEDURE dbo.CBO_GetSettNo
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

-- exec CBO_GetSettNo 'N', 'NSE'  
CREATE Proc CBO_GetSettNo  
(  
	@SettType VARCHAR(5),
	@Exchange VARCHAR(5) = '' , 
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
  SELECT Sett_No From Sett_Mst WHERE Sett_Type = @SettType ORDER BY Sett_No  
 ELSE IF @Exchange <> ''   
  SELECT Sett_No From Sett_Mst WHERE Sett_Type = @SettType AND Exchange = @Exchange ORDER BY Sett_No  
   
END

GO
