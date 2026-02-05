-- Object: FUNCTION citrus_usr.FN_SELECT_ENTM
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE function [citrus_usr].[FN_SELECT_ENTM](@PA_ENT_ID  NUMERIC) RETURNS VARCHAR(50)    
AS    
BEGIN    
--    
  DECLARE     
  --    
  @L_SHORT_NAME VARCHAR(50)    
      
  BEGIN     
  --    
      SELECT @L_SHORT_NAME = ISNULL(ENTM.ENTM_SHORT_NAME, ' ')      
      FROM   ENTITY_MSTR             ENTM   WITH(NOLOCK) 
      WHERE  ENTM.ENTM_ID          = @PA_ENT_ID    
      AND    ENTM.ENTM_DELETED_IND = 1
  --         
      RETURN @L_SHORT_NAME    
          
  END    
    
END

GO
