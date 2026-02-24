-- Object: FUNCTION citrus_usr.fn_ucc_accp
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE function [citrus_usr].[fn_ucc_accp](@pa_crn_no     NUMERIC  
                          ,@pa_accp_cd    VARCHAR(20)  
                          ,@pa_exch       CHAR(4)    
                          )  
RETURNS VARCHAR(50)  
AS  
BEGIN  
--  
  DECLARE @l_accp_accpm_prop_cd   VARCHAR(22)  
        , @l_accp_value           VARCHAR(25)  
  --        
  SELECT @l_accp_accpm_prop_cd    = accp_accpm_prop_cd  
       , @l_accp_value            = accp_value   
  FROM   account_properties        accp
  WHERE  accp_accpm_prop_cd       = @pa_accp_cd  
  AND    accp_clisba_id              = @pa_crn_no  
  AND    accp_deleted_ind         = 1  
  --  
    
  /*RETURN CASE WHEN @pa_exch    = 'NSE' THEN   
                ISNULL(CONVERT(VARCHAR(30), @l_entp_value),'')  
              WHEN @pa_exch    = 'BSE' THEN  
                ISNULL(CONVERT(VARCHAR(50), @l_entp_value),'')  
              WHEN @pa_exch    = 'MCX' THEN  
                ISNULL(CONVERT(VARCHAR(25), @l_entp_value),'')  
              END  
 */  
 RETURN ISNULL(CONVERT(VARCHAR(50), @l_accp_value),'')    
--  
END

GO
