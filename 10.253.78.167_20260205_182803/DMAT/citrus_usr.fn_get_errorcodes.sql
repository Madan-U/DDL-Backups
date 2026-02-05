-- Object: FUNCTION citrus_usr.fn_get_errorcodes
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

create function [citrus_usr].[fn_get_errorcodes](@pa_errcode  varchar(100)                                   
                            )      
RETURNS VARCHAR(50)      
AS      
BEGIN      
--          
 DECLARE @l_errdesc   VARCHAR(5000)     
DECLARE @l_errcode   VARCHAR(100) 
  --            
  SELECT @l_errdesc = [ERROR CODES DESCRIPTION],
		 @l_errcode = [ERROR CODES]
  FROM   error_codes            
  WHERE  [ERROR CODES] like '%' + @pa_errcode + '%'
  
  --      
  RETURN 'Rejection : ' + @l_errcode + ' - ' + ISNULL(CONVERT(VARCHAR(5000), @l_errdesc),'')        
--      
END

GO
