-- Object: PROCEDURE dbo.SEBI_BANNED_DATA
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



 

CREATE PROC [dbo].[SEBI_BANNED_DATA]   
       
 AS          
 begin     

	SELECT           
		CL_CODE,
		EXCHANGE,
		SEGMENT,
		ACTIVE_DATE,
		INACTIVE_FROM,
		DEACTIVE_REMARKS,
		Deactive_value
		        
	 FROM          
		CLIENT_BROK_DETAILS(NOLOCK) A       
	WHERE   
		DEACTIVE_VALUE='S'
		
	
     
END

GO
