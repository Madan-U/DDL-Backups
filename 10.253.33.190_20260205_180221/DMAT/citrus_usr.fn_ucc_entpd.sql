-- Object: FUNCTION citrus_usr.fn_ucc_entpd
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--select dbo. fn_ucc_entpd(40,'LICENCE_NO','LICENCE_ISSUED_AT')
--select dbo. fn_ucc_entpd(46,'LICENCE_NO','LICENCE_ISSUED_AT') 
CREATE function [citrus_usr].[fn_ucc_entpd](@pa_crn_no     NUMERIC
                           ,@pa_entp_cd    VARCHAR(20)
                           ,@pa_entpd_cd   VARCHAR(25)
                           ,@pa_exch       CHAR(4) 
                           )
RETURNS VARCHAR(8000)
AS
BEGIN
--
  DECLARE @l_entpd_entdm_cd     VARCHAR(25)
        , @l_entpd_value        VARCHAR(25)
  --
  SELECT @l_entpd_entdm_cd    = b.entpd_entdm_cd
       , @l_entpd_value       = b.entpd_value 
  FROM   entity_properties      a  WITH (NOLOCK)
       , entity_property_dtls   b  WITH (NOLOCK)
  WHERE  a.entp_entpm_cd      = @pa_entp_cd
  AND    b.entpd_entdm_cd     = @pa_entpd_cd
  AND    a.entp_ent_id        = CONVERT(NUMERIC, @pa_crn_no)
  AND    a.entp_id            = b.entpd_entp_id
  AND    a.entp_deleted_ind   = 1
  AND    b.entpd_deleted_ind  = 1
  --
  RETURN CASE WHEN @pa_exch = 'NSE' THEN
                   ISNULL(CONVERT(VARCHAR(25), @l_entpd_value),'')
              WHEN @pa_exch = 'BSE' THEN
                   ISNULL(CONVERT(VARCHAR(50), @l_entpd_value),'')
              WHEN @pa_exch = 'MCX' THEN
                   ISNULL(CONVERT(VARCHAR(25), @l_entpd_value),'')
              WHEN @pa_exch = '' THEN
                   @l_entpd_value
              END     
--
END

GO
