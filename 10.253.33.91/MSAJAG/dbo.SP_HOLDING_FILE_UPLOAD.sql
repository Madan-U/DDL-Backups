-- Object: PROCEDURE dbo.SP_HOLDING_FILE_UPLOAD
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE PROCEDURE [dbo].SP_HOLDING_FILE_UPLOAD  
(  
 @PARM VARCHAR(MAX)   
)  
AS   
BEGIN    
  EXEC (@PARM)   
  SELECT '1'  
END

GO
