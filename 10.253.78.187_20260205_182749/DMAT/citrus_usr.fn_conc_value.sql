-- Object: FUNCTION citrus_usr.fn_conc_value
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE function [citrus_usr].[fn_conc_value](@pa_crn_no   numeric      
                             ,@pa_cd       varchar(25)      
                             )      
RETURNS VARCHAR(1000)       
AS      
--      
BEGIN      
--      
  DECLARE @l_conc_value  VARCHAR(1000)      
         ,@l_email_list  VARCHAR(1000)      
         ,@l_list        VARCHAR(1000)      
       
  DECLARE @c_email       CURSOR      
  DECLARE @c_list        CURSOR      
  --      
        
  IF @pa_cd = 'EMAIL3'      
  BEGIN      
  --      
          
    SET @c_email = CURSOR FAST_FORWARD FOR      
    SELECT conc.conc_value       
    FROM   contact_channels          conc        
          ,entity_adr_conc           entac        
    WHERE  entac.entac_adr_conc_id = conc.conc_id        
    AND    entac_ent_id            = @pa_crn_no      
    AND    entac_concm_cd          LIKE '%EMAIL%'      
    AND    conc.conc_deleted_ind   = 1       
    AND    entac.entac_deleted_ind = 1      
      
      
    OPEN @c_email      
      
    FETCH NEXT FROM @c_email      
    INTO  @l_email_list      
      
    WHILE @@FETCH_STATUS = 0        
    BEGIN        
    --        
      
      IF ISNULL(@l_email_list,'') <> ''        
      BEGIN      
      --      
        SET @l_email_list = @l_email_list + ','      
      --      
      END      
      
      
      
      FETCH NEXT FROM @c_email      
      INTO  @l_email_list      
    --      
    END      
      
    CLOSE      @c_email      
    DEALLOCATE @c_email      
         
        
    SET @l_conc_value = @l_email_list      
  --      
  END      
  ELSE IF NOT EXISTS(select clim_crn_no from client_mstr where clim_crn_no = @pa_crn_no)      
  BEGIN      
  --      
    IF @pa_cd = 'FAX'      
    BEGIN      
    --      
      SET @c_list = CURSOR FAST_FORWARD FOR      
      SELECT conc.conc_value       
      FROM   contact_channels          conc        
            ,entity_adr_conc           entac        
      WHERE  entac.entac_adr_conc_id = conc.conc_id        
      AND    entac_ent_id            = @pa_crn_no      
      AND    entac_concm_cd          LIKE '%FAX%'      
      AND    conc.conc_deleted_ind   = 1       
      AND    entac.entac_deleted_ind = 1       
    --      
    END      
    ELSE IF @pa_cd ='PHONE'      
    BEGIN      
    --      
      SET @c_list = CURSOR FAST_FORWARD FOR      
      SELECT conc.conc_value       
      FROM   contact_channels          conc        
            ,entity_adr_conc           entac        
      WHERE  entac.entac_adr_conc_id = conc.conc_id        
      AND    entac_ent_id            = @pa_crn_no      
      AND    entac_concm_cd          LIKE '%PHO%'      
      AND    conc.conc_deleted_ind   = 1       
      AND    entac.entac_deleted_ind = 1       
    --      
    END      
    ELSE IF @pa_cd = 'TELEX'      
    BEGIN      
    --      
      SET @c_list = CURSOR FAST_FORWARD FOR      
      SELECT conc.conc_value       
      FROM   contact_channels          conc        
            ,entity_adr_conc           entac        
      WHERE  entac.entac_adr_conc_id = conc.conc_id        
      AND    entac_ent_id            = @pa_crn_no      
      AND    entac_concm_cd          LIKE '%TELEX%'      
      AND    conc.conc_deleted_ind   = 1       
      AND    entac.entac_deleted_ind = 1       
    --      
    END      
    ELSE IF @pa_cd = 'PC'      
    BEGIN      
    --      
      SET @c_list = CURSOR FAST_FORWARD FOR      
      SELECT conc.conc_value       
      FROM   contact_channels          conc        
            ,entity_adr_conc           entac        
      WHERE  entac.entac_adr_conc_id = conc.conc_id        
      AND    entac_ent_id            = @pa_crn_no      
      AND    entac_concm_cd          LIKE '%PC%'      
      AND    conc.conc_deleted_ind   = 1       
      AND    entac.entac_deleted_ind = 1       
    --      
    END      
    ELSE IF @pa_cd = 'MOBILE'      
    BEGIN      
    --      
      SET @c_list = CURSOR FAST_FORWARD FOR      
      SELECT conc.conc_value       
      FROM   contact_channels          conc   
            ,entity_adr_conc           entac        
      WHERE  entac.entac_adr_conc_id = conc.conc_id        
      AND    entac_ent_id            = @pa_crn_no      
      AND    entac_concm_cd          LIKE '%MOBILE%'      
      AND    conc.conc_deleted_ind   = 1       
      AND    entac.entac_deleted_ind = 1       
    --      
    END      
    ELSE IF @pa_cd = 'EMAIL'      
    BEGIN      
    --      
      SET @c_list = CURSOR FAST_FORWARD FOR      
      SELECT conc.conc_value       
      FROM   contact_channels          conc        
            ,entity_adr_conc           entac        
      WHERE  entac.entac_adr_conc_id = conc.conc_id        
      AND    entac_ent_id            = @pa_crn_no      
      AND    entac_concm_cd          LIKE '%MAIL%'      
      AND    conc.conc_deleted_ind   = 1       
      AND    entac.entac_deleted_ind = 1       
    --      
    END         
          
          
          
    IF @PA_CD IN ('OFF_PH1','OFF_PH2','OFF_PH3','OFF_PH4','FAX1','EMAIL1','FAX2','MOBILE1','EMAIL2','RES_PH1','RES_PH2','MOBSMS')   
    BEGIN      
    --      
      SELECT @l_conc_value           = conc.conc_value        
      FROM   contact_channels          conc        
            ,entity_adr_conc           entac        
      WHERE  entac.entac_adr_conc_id = conc.conc_id        
      AND    entac_ent_id            = @pa_crn_no      
      AND    entac_concm_cd          = @pa_cd      
      AND    conc.conc_deleted_ind   = 1       
      AND    entac.entac_deleted_ind = 1      
    --      
    END      
    ELSE      
    BEGIN      
    --      
      OPEN @c_list      
                
                
      FETCH NEXT FROM @c_list      
      INTO  @l_list      
      
      WHILE @@FETCH_STATUS = 0        
      BEGIN        
      --        
      
        IF ISNULL(@l_list,'') <> ''        
        BEGIN      
        --      
          SET @l_list = @l_list + ','      
        --      
        END      
      
      
      
        FETCH NEXT FROM @c_list      
        INTO  @l_list      
      --      
      END      
      
      CLOSE      @c_list      
      DEALLOCATE @c_list      
      
      SET @l_conc_value = @l_list      
    --      
    END      
  --      
  END      
      
  IF @PA_CD IN ('OFF_PH1','OFF_PH2','OFF_PH3','OFF_PH4','FAX1','EMAIL1','FAX2','MOBILE1','RES_PH1','EMAIL2','RES_PH2','MOBSMS')      
    BEGIN      
    --      
      SELECT @l_conc_value           = conc.conc_value        
      FROM   contact_channels          conc        
            ,entity_adr_conc           entac        
      WHERE  entac.entac_adr_conc_id = conc.conc_id        
      AND    entac_ent_id            = @pa_crn_no      
      AND    entac_concm_cd          = @pa_cd      
      AND    conc.conc_deleted_ind   = 1       
      AND    entac.entac_deleted_ind = 1      
    --      
    END      
      
  RETURN @l_conc_value        
--        
END

GO
