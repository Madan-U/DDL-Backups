-- Object: FUNCTION citrus_usr.fn_acct_entpD
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE function [citrus_usr].[fn_acct_entpD](@pa_clisba_id   NUMERIC    
                            ,@pa_accpm_cd    VARCHAR(50) 
                            ,@pa_accpm_dtls  VARCHAR(50)    
                            )    
RETURNS VARCHAR(50)    
AS    
BEGIN    
--    
  DECLARE @l_accp_accpm_prop_cd   VARCHAR(22)    
        , @l_accpd_value           VARCHAR(25)    
  --          
  SELECT @l_accpd_value         = accpd_value
  FROM   account_properties          
        ,account_property_dtls
  WHERE  accp_id               = accpd_accp_id
  and    accp_accpm_prop_cd    = @pa_accpm_cd    
  AND    accp_clisba_id        = @pa_clisba_id
  and    ACCPD_ACCDM_CD    = @pa_accpm_dtls      
  AND    accp_deleted_ind      = 1    
  --    
  RETURN ISNULL(CONVERT(VARCHAR(50), @l_accpd_value),'')      
--    
END

GO
