-- Object: FUNCTION citrus_usr.fn_ucc_accpd
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

--select dbo. fn_ucc_entpd(40,'LICENCE_NO','LICENCE_ISSUED_AT')      
--select dbo. fn_ucc_entpd(46,'LICENCE_NO','LICENCE_ISSUED_AT')       
CREATE function [citrus_usr].[fn_ucc_accpd](@pa_clisba_id     NUMERIC      
                           ,@pa_accp_cd    VARCHAR(20)      
                           ,@pa_accdm_cd   VARCHAR(25)      
                           ,@pa_exch       CHAR(4)       
                           )      
RETURNS VARCHAR(8000)      
AS      
BEGIN      
--      
  DECLARE @l_accpd_accdm_cd     VARCHAR(25)      
        , @l_accpd_value        VARCHAR(25)      
  --      
  SELECT @l_accpd_accdm_cd    = b.accpd_accdm_cd      
       , @l_accpd_value       = b.accpd_value       
  FROM   account_properties      a  WITH (NOLOCK)      
       , account_property_dtls   b  WITH (NOLOCK)      
  WHERE  a.accp_accpm_prop_cd      = @pa_accp_cd      
  AND    b.accpd_accdm_cd     = @pa_accdm_cd      
  AND    a.accp_clisba_id        = CONVERT(NUMERIC, @pa_clisba_id)      
  AND    a.accp_id            = b.accpd_accp_id      
  AND    a.accp_deleted_ind   = 1      
  AND    b.accpd_deleted_ind  = 1      
  --      
  RETURN @l_accpd_value      
              
--      
END

GO
