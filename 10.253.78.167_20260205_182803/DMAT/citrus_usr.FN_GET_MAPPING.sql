-- Object: FUNCTION citrus_usr.FN_GET_MAPPING
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE function [citrus_usr].[FN_GET_MAPPING](@PA_CD       VARCHAR(20)   
                             , @PA_EXCH     VARCHAR(8000)  
                             , @PA_VAL      VARCHAR(20)  
                              )        
RETURNS VARCHAR(20)        
AS        
BEGIN        
--        
   DECLARE  @l_val VARCHAR(20)  
   IF @pa_cd = 'setm_type'  
   BEGIN  
   --  
     SELECT @l_val = settm_id  
     FROM   file_lookup_mstr  
          , exchange_mstr  
          , settlement_type_mstr  
     WHERE  excm_cd          = fillm_excm_cd  
     AND    settm_type       = fillm_file_value  
     AND    fillm_excm_cd    = @pa_exch  
     AND    fillm_lookup_cd  = @pa_cd  
     AND    settm_type       = @pa_val   
       
   --  
   END  
   ELSE  
   BEGIN  
   --  
     SELECT @l_val = fillm_db_value  
     FROM   file_lookup_mstr  
          , exchange_mstr  
     WHERE  excm_cd          = fillm_excm_cd  
     AND    fillm_excm_cd    = @pa_exch  
     AND    fillm_lookup_cd  = @pa_cd  
     AND    (fillm_file_value = @pa_val or  fillm_db_code = @pa_val   )
     
   --  
   END  
     
     
   RETURN @l_val  
--        
END

GO
