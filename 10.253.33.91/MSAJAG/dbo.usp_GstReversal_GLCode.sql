-- Object: PROCEDURE dbo.usp_GstReversal_GLCode
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE proc usp_GstReversal_GLCode 
@CltCode  varchar(20)
as
BEGIN

DECLARE @@ERROR_COUNT INT

SELECT @@ERROR_COUNT = COUNT(1)
FROM Account..ACMAST 
WHERE Accat = 3 AND CltCode = @CltCode 

IF @@ERROR_COUNT > 0          
BEGIN          
  
	SELECT  '0' as Output;
END
ELSE 
BEGIN

	SELECT  '1' as Output;
END 	 


END

GO
