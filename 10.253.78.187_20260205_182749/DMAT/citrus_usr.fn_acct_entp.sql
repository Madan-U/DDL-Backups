-- Object: FUNCTION citrus_usr.fn_acct_entp
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE function [citrus_usr].[fn_acct_entp](@pa_clisba_id   NUMERIC   
                            ,@pa_accpm_cd    VARCHAR(20)      
                            )      
RETURNS VARCHAR(50)      
AS      
BEGIN      
--      
  DECLARE @l_accp_accpm_prop_cd   VARCHAR(22)      
        , @l_accp_value           VARCHAR(25)      
  --            
  SELECT @l_accp_value         = accp_value       
  FROM   account_properties            
  WHERE  accp_clisba_id        = @pa_clisba_id  
  AND    accp_accpm_prop_cd    = @pa_accpm_cd        
  AND    accp_deleted_ind      = 1      
  --      
  RETURN ISNULL(CONVERT(VARCHAR(50), @l_accp_value),'')        
--      
END

GO
