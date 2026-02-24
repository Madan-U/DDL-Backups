-- Object: PROCEDURE dbo.CBO_GetUserDetailTrader
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE   PROC CBO_GetUserDetailTrader
	@STATUSID VARCHAR(25) = 'ADMINISTRATOR',
	@STATUSNAME VARCHAR(25) = 'ADMINISTRATOR'
AS
	IF @STATUSID <> 'ADMINISTRATOR'
		BEGIN
			RAISERROR ('This Procedure is accessible to ADMINISTRATOR', 16, 1)
			RETURN
		END				
	
        SELECT distinct 
               
                Short_Name,
                Long_Name 
         FROM  
                branches 
   
         order by 
                
                long_name

GO
