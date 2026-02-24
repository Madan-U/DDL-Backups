-- Object: FUNCTION citrus_usr.fn_to_get_entm_id
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE function [citrus_usr].[fn_to_get_entm_id](@pa_crn_no     NUMERIC  
                                 ,@pa_acct_no    VARCHAR(20)   
                                 ,@pa_enttm_cd   VARCHAR(20)  
                                 )  
RETURNS NUMERIC  
AS  
BEGIN  
--  
  DECLARE @l_col_name    VARCHAR(30)  
        , @l_val         NUMERIC  
  --  
  SELECT @l_col_name    = UPPER(entem_entr_col_name)  
  FROM   enttm_entr_mapping entem WITH (NOLOCK)  
       , entity_type_mstr   enttm WITH (NOLOCK)  
  WHERE  enttm.enttm_cd =   entem.entem_enttm_cd  
  AND    enttm_cd       =   @pa_enttm_cd  
  --  
  IF @l_col_name = 'ENTR_DUMMY6'  
  BEGIN  
  --  
    SELECT TOP 1 @l_val = entr_dummy6   
    FROM   entity_relationship entr  WITH (NOLOCK)  
    WHERE  entr.entr_crn_no  = @pa_crn_no  
    AND    entr.entr_acct_no = @pa_acct_no  
    ORDER BY  entr_dummy6 DESC   
  --  
  END  
  --  
  RETURN @l_val  
--  
END  
--

GO
