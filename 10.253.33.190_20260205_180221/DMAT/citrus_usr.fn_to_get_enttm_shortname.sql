-- Object: FUNCTION citrus_usr.fn_to_get_enttm_shortname
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE function [citrus_usr].[fn_to_get_enttm_shortname](@pa_crn_no      NUMERIC  
                                         ,@pa_acct_no     VARCHAR(25)   
                                         ,@pa_enttm_cd    VARCHAR(20)  
                                         )  
RETURNS VARCHAR(50)  
AS  
BEGIN  
--  
  DECLARE @l_col_name        VARCHAR(50)  
         ,@l_entm_shortName  VARCHAR(50)   
  --  
  SELECT @l_col_name      = ENTEM_ENTR_COL_NAME  
  FROM   ENTTM_ENTR_MAPPING WITH (NOLOCK)  
  WHERE  ENTEM_ENTTM_CD   = @pa_enttm_cd  
  --  
  IF @l_col_name = 'ENTR_HO'  
  BEGIN  
  --  
      SELECT @l_entm_shortName = entm_short_name   
      FROM entity_mstr          entm WITH (NOLOCK)  
         , entity_relationship  entr WITH (NOLOCK)  
      WHERE entm.entm_id       = entr.ENTR_HO  
      AND   entr.entr_crn_no   = + CONVERT(VARCHAR(20), @pa_crn_no)  
      AND   entr.entr_acct_no  = + CONVERT(VARCHAR(25), @pa_acct_no)  
  --  
  END  
  ELSE IF @l_col_name = 'ENTR_SB'  
  BEGIN  
  --  
      SELECT @l_entm_shortName = entm_short_name   
      FROM entity_mstr          entm WITH (NOLOCK)  
         , entity_relationship  entr WITH (NOLOCK)  
      WHERE entm.entm_id       = entr.ENTR_SB  
      AND   entr.entr_crn_no   = + CONVERT(VARCHAR(20), @pa_crn_no)  
      AND   entr.entr_acct_no  = + CONVERT(VARCHAR(25), @pa_acct_no)  
  --  
  END  
  ELSE IF @l_col_name = 'ENTR_DL'  
  BEGIN  
  --  
      SELECT @l_entm_shortName = entm_short_name   
      FROM entity_mstr          entm WITH (NOLOCK)  
         , entity_relationship  entr WITH (NOLOCK)  
      WHERE entm.entm_id       = entr.ENTR_DL  
      AND   entr.entr_crn_no   = + CONVERT(VARCHAR(20), @pa_crn_no)  
      AND   entr.entr_acct_no  = + CONVERT(VARCHAR(25), @pa_acct_no)  
  --  
  END  
  ELSE IF @l_col_name = 'ENTR_RM'  
  BEGIN  
  --  
          SELECT @l_entm_shortName = entm_short_name   
          FROM entity_mstr          entm WITH (NOLOCK)  
             , entity_relationship  entr WITH (NOLOCK)  
          WHERE entm.entm_id       = entr.ENTR_RM  
          AND   entr.entr_crn_no   = + CONVERT(VARCHAR(20), @pa_crn_no)  
          AND   entr.entr_acct_no  = + CONVERT(VARCHAR(25), @pa_acct_no)  
  --  
  END  
  --  
  ELSE IF @l_col_name = 'ENTR_DUMMY1'  
  BEGIN  
  --  
          SELECT @l_entm_shortName = entm_short_name   
          FROM entity_mstr          entm WITH (NOLOCK)  
             , entity_relationship  entr WITH (NOLOCK)  
          WHERE entm.entm_id       = entr.ENTR_DUMMY1  
          AND   entr.entr_crn_no   = + CONVERT(VARCHAR(20), @pa_crn_no)  
          AND   entr.entr_acct_no  = + CONVERT(VARCHAR(25), @pa_acct_no)  
  --  
  END  
  ELSE IF @l_col_name = 'ENTR_DUMMY2'  
  BEGIN  
  --  
          SELECT @l_entm_shortName = entm_short_name   
          FROM entity_mstr          entm WITH (NOLOCK)  
             , entity_relationship  entr WITH (NOLOCK)  
          WHERE entm.entm_id       = entr.ENTR_DUMMY2  
          AND   entr.entr_crn_no   = + CONVERT(VARCHAR(20), @pa_crn_no)  
          AND   entr.entr_acct_no  = + CONVERT(VARCHAR(25), @pa_acct_no)  
  --  
  END  
  ELSE IF @l_col_name = 'ENTR_DUMMY3'  
  BEGIN  
  --  
          SELECT @l_entm_shortName = entm_short_name   
          FROM entity_mstr          entm WITH (NOLOCK)  
             , entity_relationship  entr WITH (NOLOCK)  
          WHERE entm.entm_id       = entr.ENTR_DUMMY3  
          AND   entr.entr_crn_no   = + CONVERT(VARCHAR(20), @pa_crn_no)  
          AND   entr.entr_acct_no  = + CONVERT(VARCHAR(25), @pa_acct_no)  
  --  
  END  
  ELSE IF @l_col_name = 'ENTR_DUMMY4'  
  BEGIN  
  --  
          SELECT @l_entm_shortName = entm_short_name   
          FROM entity_mstr          entm WITH (NOLOCK)  
             , entity_relationship  entr WITH (NOLOCK)  
          WHERE entm.entm_id       = entr.ENTR_DUMMY4  
          AND   entr.entr_crn_no   = + CONVERT(VARCHAR(20), @pa_crn_no)  
          AND   entr.entr_acct_no  = + CONVERT(VARCHAR(25), @pa_acct_no)  
  --  
  END  
  ELSE IF @l_col_name = 'ENTR_DUMMY5'  
  BEGIN  
  --  
          SELECT @l_entm_shortName = entm_short_name   
          FROM entity_mstr          entm WITH (NOLOCK)  
             , entity_relationship  entr WITH (NOLOCK)  
          WHERE entm.entm_id       = entr.ENTR_DUMMY5  
          AND   entr.entr_crn_no   = + CONVERT(VARCHAR(20), @pa_crn_no)  
          AND   entr.entr_acct_no  = + CONVERT(VARCHAR(25), @pa_acct_no)  
  --  
  END  
  ELSE IF @l_col_name = 'ENTR_DUMMY6'  
  BEGIN  
  --  
          SELECT @l_entm_shortName = entm_short_name   
          FROM entity_mstr          entm WITH (NOLOCK)  
             , entity_relationship  entr WITH (NOLOCK)  
          WHERE entm.entm_id       = entr.ENTR_DUMMY6  
          AND   entr.entr_crn_no   = + CONVERT(VARCHAR(20), @pa_crn_no)  
          AND   entr.entr_acct_no  = + CONVERT(VARCHAR(25), @pa_acct_no)  
  --  
  END  
  ELSE IF @l_col_name = 'ENTR_DUMMY7'  
  BEGIN  
  --  
          SELECT @l_entm_shortName = entm_short_name   
          FROM entity_mstr          entm WITH (NOLOCK)  
             , entity_relationship  entr WITH (NOLOCK)  
          WHERE entm.entm_id       = entr.ENTR_DUMMY7  
          AND   entr.entr_crn_no   = + CONVERT(VARCHAR(20), @pa_crn_no)  
          AND   entr.entr_acct_no  = + CONVERT(VARCHAR(25), @pa_acct_no)  
  --  
  END  
  ELSE IF @l_col_name = 'ENTR_DUMMY8'  
  BEGIN  
  --  
          SELECT @l_entm_shortName = entm_short_name   
          FROM entity_mstr          entm WITH (NOLOCK)  
             , entity_relationship  entr WITH (NOLOCK)  
          WHERE entm.entm_id       = entr.ENTR_DUMMY8  
          AND   entr.entr_crn_no   = + CONVERT(VARCHAR(20), @pa_crn_no)  
          AND   entr.entr_acct_no  = + CONVERT(VARCHAR(25), @pa_acct_no)  
  --  
  END  
  ELSE IF @l_col_name = 'ENTR_DUMMY9'  
  BEGIN  
  --  
          SELECT @l_entm_shortName = entm_short_name   
          FROM entity_mstr          entm WITH (NOLOCK)  
             , entity_relationship  entr WITH (NOLOCK)  
          WHERE entm.entm_id       = entr.ENTR_DUMMY9  
          AND   entr.entr_crn_no   = + CONVERT(VARCHAR(20), @pa_crn_no)  
          AND   entr.entr_acct_no  = + CONVERT(VARCHAR(25), @pa_acct_no)  
  --  
  END  
  ELSE IF @l_col_name = 'ENTR_DUMMY10'  
  BEGIN  
  --  
          SELECT @l_entm_shortName = entm_short_name   
          FROM   entity_mstr          entm WITH (NOLOCK)  
               , entity_relationship  entr WITH (NOLOCK)  
          WHERE entm.entm_id       = entr.ENTR_DUMMY10  
          AND   entr.entr_crn_no   = + CONVERT(VARCHAR(20), @pa_crn_no)  
          AND   entr.entr_acct_no  = + CONVERT(VARCHAR(25), @pa_acct_no)  
  --  
  END  
  --  
  RETURN isnull(@l_entm_shortName,'')  
--  
END  
--

GO
