-- Object: FUNCTION citrus_usr.fn_demrd_value
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE function [citrus_usr].[fn_demrd_value](@pa_demrd_id   numeric      
                             )        
RETURNS VARCHAR(100)         
AS        
--        
BEGIN        
--        
  DECLARE @l_value  varchar(100)        
  --        
  set @l_value = ''  
  SELECT @l_value = CASE WHEN DEMRD_DISTINCTIVE_NO_FR='M' THEN 'M' ELSE 'EQ' END  
  FROM DEMRD_MAK WHERE demrd_demrm_id = @pa_demrd_id    
  --        
  return @l_value        
--          
END

GO
