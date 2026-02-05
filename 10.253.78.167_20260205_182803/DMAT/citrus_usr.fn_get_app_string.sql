-- Object: FUNCTION citrus_usr.fn_get_app_string
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE function [citrus_usr].[fn_get_app_string](@pa_id        VARCHAR(8000)  
                                ,@pa_tab       VARCHAR(20)  
                                ,@pa_brok_dp    NUMERIC   
                                 )  
RETURNS VARCHAR(1000)  
AS  
BEGIN  
--  
   
  DECLARE @l_count_row   NUMERIC        
         ,@l             NUMERIC        
         ,@l_select_row  VARCHAR(50)        
         ,@l_clim_crn_no NUMERIC        
         ,@l_clisba_id   NUMERIC       
         ,@l_clisba_ids  VARCHAR(50)         
         ,@l_pa_id       VARCHAR(1000)       
         ,@l_id          VARCHAR(1000)   
         ,@l_id1         VARCHAR(1000)   
  DECLARE @l_clisba      TABLE(clim_crn_no NUMERIC, clisba_id numeric)   
  DECLARE @c_cursor      CURSOR  
  SET     @l_id1       = ' '  
  
    
    
  IF @pa_brok_dp = 1  
  BEGIN  
  --  
    
    IF @pa_id <> ''        
    BEGIN        
    --        
  
      SET     @l = 1        
      SET     @l_count_row = citrus_usr.ufn_countstring(@pa_id,'*|~*')        
  
      WHILE @l <= @l_count_row         
      BEGIN        
      --        
        SELECT @l_select_row = citrus_usr.fn_splitval_row(@pa_id,@l)            
  
        SELECT @l_clim_crn_no = citrus_usr.fn_splitval(@l_select_row,1)       
  
        SELECT @l_clisba_id   = citrus_usr.fn_splitval(@l_select_row,2)              
  
  
        INSERT INTO  @l_clisba        
        (clim_crn_no        
        ,clisba_id)         
        VALUES(@l_clim_crn_no, @l_clisba_id)        
  
        SET @l = @l + 1        
      --        
      END        
  
    --          
    END        
    
    IF @PA_TAB = 'CLIDPA'  
    BEGIN  
    --  
      SET     @c_cursor  = CURSOR fast_forward FOR SELECT DISTINCT clidpa_id FROM   client_dp_accts_mak WHERE  clidpa_deleted_ind IN (0,4,8)   AND clidpa_clisba_id  IN (SELECT clisba_id FROM @l_clisba)  
  
      OPEN    @c_cursor  
      --  
      FETCH next FROM @c_cursor INTO @l_id  
  
      WHILE @@fetch_status      = 0  
      BEGIN --#cursor  
      --  
  
        IF ISNULL(@l_id1,'') = ' '  
        BEGIN  
        --  
          SET @l_id1 = @l_id + '*|~*'  
        --  
        END  
        ELSE  
        BEGIN  
        --  
          SET @l_id1 = @l_id1 +  @l_id + '*|~*'  
        --  
        END  
  
  
        FETCH next FROM @c_cursor INTO @l_id  
      --    
      END  --#cursor  
  
      CLOSE      @c_cursor  
      DEALLOCATE @c_cursor  
  
  
    --  
    END  
    IF @PA_TAB = 'CLIBA'  
    BEGIN  
    --  
      SET     @c_cursor  = CURSOR fast_forward FOR SELECT DISTINCT cliba_id FROM   client_bank_accts_mak  WHERE  cliba_deleted_ind IN (0,4,8) AND    cliba_clisba_id  IN (SELECT clisba_id FROM @l_clisba)  
  
      OPEN    @c_cursor  
      --  
      FETCH next FROM @c_cursor INTO @l_id  
  
      WHILE @@fetch_status      = 0  
      BEGIN --#cursor  
      --  
  
        IF ISNULL(@l_id1,'') = ' '  
        BEGIN  
        --  
          SET @l_id1 = @l_id + '*|~*'  
        --  
        END  
        ELSE  
        BEGIN  
        --  
          SET @l_id1 = @l_id1  +  @l_id + '*|~*'  
        --  
        END  
  
        FETCH next FROM @c_cursor INTO @l_id  
      --    
      END  --#cursor  
  
      CLOSE      @c_cursor  
      DEALLOCATE @c_cursor  
    --  
    END  
    IF @PA_TAB = 'CLISBAENTR'  
    BEGIN  
    --  
      SET     @c_cursor  = CURSOR fast_forward FOR   
      SELECT DISTINCT entr_id FROM   entity_relationship_mak ,client_sub_accts WHERE  entr_deleted_ind IN (0,4,8) AND clisba_no =  entr_sba and clisba_excpm_id =  entr_excpm_id AND clisba_id IN (SELECT clisba_id FROM @l_clisba)  
        
  
      OPEN    @c_cursor  
      --  
      FETCH next FROM @c_cursor INTO @l_id  
  
      WHILE @@fetch_status      = 0  
      BEGIN --#cursor  
      --  
  
        IF ISNULL(@l_id1,'') = ' '  
        BEGIN  
        --  
          SET @l_id1 = @l_id + '*|~*'  
        --  
        END  
        ELSE  
        BEGIN  
        --  
          SET @l_id1 = @l_id1 +  @l_id + '*|~*'  
        --  
        END  
  
        FETCH next FROM @c_cursor INTO @l_id  
      --    
      END  --#cursor  
  
      CLOSE      @c_cursor  
      DEALLOCATE @c_cursor  
    --  
    END  
    IF @PA_TAB = 'ENTP'  
    BEGIN  
    --  
      SET     @c_cursor  = CURSOR fast_forward FOR  
      SELECT DISTINCT entpmak_id   
      FROM   entity_properties_mak  
            ,entity_property_mstr  
            ,client_sub_accts  
            ,excsm_prod_mstr  
            ,client_mstr   
      WHERE  entp_ent_id        = clim_crn_no  
      AND    entp_entpm_prop_id = entpm_prop_id  
      AND    clim_crn_no        = clisba_crn_no  
      AND    clisba_excpm_id    = excpm_id  
      AND    entpm_excpm_id     = excpm_id  
      AND    clisba_id          IN (SELECT clisba_id FROM @l_clisba)  
      AND    entp_deleted_ind   IN (0,4,8)   
  
      OPEN    @c_cursor  
      --  
      FETCH next FROM @c_cursor INTO @l_id  
  
      WHILE @@fetch_status      = 0  
      BEGIN --#cursor  
      --  
  
        IF ISNULL(@l_id1,'') =' '  
        BEGIN  
        --  
          SET @l_id1 = @l_id + '*|~*'  
        --  
        END  
        ELSE  
        BEGIN  
        --  
          SET @l_id1 = @l_id1 +  @l_id + '*|~*'  
        --  
        END  
  
        FETCH next FROM @c_cursor INTO @l_id  
      --    
      END  --#cursor  
  
      CLOSE      @c_cursor  
      DEALLOCATE @c_cursor  
    --  
    END  
    IF @PA_TAB = 'CLID'  
    BEGIN  
    --  
      SET     @c_cursor  = CURSOR fast_forward FOR  
      SELECT DISTINCT clid_id  
      FROM   client_documents_mak  
            ,document_mstr  
            ,client_sub_accts  
            ,excsm_prod_mstr  
            ,client_mstr   
      WHERE  clid_crn_no        = clim_crn_no  
      AND    clid_docm_doc_id   = docm_doc_id  
      AND    clim_crn_no        = clisba_crn_no  
      AND    clisba_excpm_id    = excpm_id  
      AND    docm_excpm_id      = excpm_id  
      AND    clisba_id          IN (SELECT clisba_id FROM @l_clisba)  
      AND    clid_deleted_ind IN (0,4,8)  
  
      OPEN    @c_cursor  
      --  
      FETCH next FROM @c_cursor INTO @l_id  
  
      WHILE @@fetch_status      = 0  
      BEGIN --#cursor  
      --  
  
        IF ISNULL(@l_id1,'') = ' '  
        BEGIN  
        --  
          SET @l_id1 = @l_id + '*|~*'  
        --  
        END  
        ELSE  
        BEGIN  
        --  
          SET @l_id1 = @l_id1 +  @l_id + '*|~*'  
        --  
        END  
  
        FETCH next FROM @c_cursor INTO @l_id  
      --    
      END  --#cursor  
  
      CLOSE      @c_cursor  
      DEALLOCATE @c_cursor  
    --  
    END  
    IF @PA_TAB = 'ACCP'  
    BEGIN  
    --  
      SET     @c_cursor  = CURSOR fast_forward FOR  
      SELECT DISTINCT accpmak_id  
      FROM   accp_mak  
      WHERE  accp_clisba_id   IN (SELECT clisba_id FROM @l_clisba)  
      AND    accp_deleted_ind IN (0,4,8)   
  
      OPEN    @c_cursor  
      --  
      FETCH next FROM @c_cursor INTO @l_id  
  
      WHILE @@fetch_status      = 0  
      BEGIN --#cursor  
      --  
  
        IF ISNULL(@l_id1,'') = ' '  
        BEGIN  
        --  
          SET @l_id1 = @l_id + '*|~*'  
        --  
        END  
        ELSE  
        BEGIN  
        --  
          SET @l_id1 = @l_id1 +  @l_id + '*|~*'  
        --  
        END  
  
        FETCH next FROM @c_cursor INTO @l_id  
      --    
      END  --#cursor  
  
      CLOSE      @c_cursor  
      DEALLOCATE @c_cursor  
  
    --  
    END  
    IF @PA_TAB = 'ACCD'  
    BEGIN  
    --  
  
      SET     @c_cursor  = CURSOR fast_forward FOR  
      SELECT DISTINCT accd_id  
      FROM   accd_mak  
      WHERE  accd_clisba_id IN (SELECT clisba_id FROM @l_clisba)  
      AND    accd_deleted_ind IN (0,4,8)  
  
      OPEN    @c_cursor  
      --  
      FETCH next FROM @c_cursor INTO @l_id  
  
      WHILE @@fetch_status      = 0  
      BEGIN --#cursor  
      --  
  
        IF ISNULL(@l_id1,'') = ' '  
        BEGIN  
        --  
          SET @l_id1 = @l_id + '*|~*'  
        --  
        END  
        ELSE  
        BEGIN  
        --  
          SET @l_id1 = @l_id1 +  @l_id + '*|~*'  
        --  
        END  
  
        FETCH next FROM @c_cursor INTO @l_id  
      --    
      END  --#cursor  
  
      CLOSE      @c_cursor  
      DEALLOCATE @c_cursor  
  
    --  
    END  
      
  --  
  END  
  ELSE IF @pa_brok_dp = 2  
  BEGIN  
  --  
    IF @pa_id <> ''        
    BEGIN        
    --        
      SET     @l = 1        
      SET     @l_count_row = citrus_usr.ufn_countstring(@pa_id,'*|~*')        
  
      WHILE @l <= @l_count_row         
      BEGIN        
      --        
        SELECT @l_select_row    = citrus_usr.fn_splitval_row(@pa_id,@l)            
  
        SELECT @l_clisba_id     = citrus_usr.fn_splitval(@l_select_row,2)       
          
        SELECT @l_clim_crn_no   = dpam_crn_no  FROM dp_acct_mstr where dpam_id = @l_clisba_id  and dpam_deleted_ind = 1  
          
        INSERT INTO  @l_clisba        
        (clim_crn_no        
        ,clisba_id)         
        VALUES(@l_clim_crn_no, @l_clisba_id)        
  
        SET @l = @l + 1        
      --        
      END        
  
    --          
    END        
    IF @PA_TAB = 'DPHLD'  
    BEGIN  
    --  
      SET     @c_cursor  = CURSOR fast_forward FOR SELECT DISTINCT dphdmak_id FROM   dp_holder_dtls_mak WHERE  dphd_deleted_ind IN (0,4,8) AND   dphd_dpam_id   IN (SELECT clisba_id FROM @l_clisba)  
  
      OPEN    @c_cursor  
      --  
      FETCH next FROM @c_cursor INTO @l_id  
  
      WHILE @@fetch_status      = 0  
      BEGIN --#cursor  
      --  
  
        IF ISNULL(@l_id1,'') = ' '  
        BEGIN  
        --  
          SET @l_id1 = @l_id + '*|~*'  
        --  
        END  
        ELSE  
        BEGIN  
        --  
          SET @l_id1 = @l_id1  +  @l_id + '*|~*'  
        --  
        END  
  
        FETCH next FROM @c_cursor INTO @l_id  
      --    
      END  --#cursor  
  
      CLOSE      @c_cursor  
      DEALLOCATE @c_cursor  
    --  
    END  
    IF @PA_TAB = 'DPPD'
				BEGIN
				--
						SET     @c_cursor  = CURSOR fast_forward FOR SELECT DISTINCT dppd_id FROM   dp_poa_dtls_mak WHERE  dppd_deleted_ind IN (0,4,8)	AND   dppd_dpam_id   IN (SELECT clisba_id FROM @l_clisba)

						OPEN    @c_cursor
						--
						FETCH next FROM @c_cursor INTO @l_id

						WHILE @@fetch_status      = 0
						BEGIN --#cursor
						--

								IF ISNULL(@l_id1,'') = ' '
								BEGIN
								--
										SET @l_id1 = @l_id + '*|~*'
								--
								END
								ELSE
								BEGIN
								--
										SET @l_id1 = @l_id1  +  @l_id + '*|~*'
								--
								END

								FETCH next FROM @c_cursor INTO @l_id
						--  
						END  --#cursor

						CLOSE      @c_cursor
						DEALLOCATE @c_cursor
				--
				END
    IF @PA_TAB = 'CLIBA'  
    BEGIN  
    --  
      SET     @c_cursor  = CURSOR fast_forward FOR SELECT DISTINCT cliba_id FROM   client_bank_accts_mak  WHERE  cliba_deleted_ind IN (0,4,8) AND    cliba_clisba_id  IN (SELECT clisba_id FROM @l_clisba)  
  
      OPEN    @c_cursor  
      --  
      FETCH next FROM @c_cursor INTO @l_id  
  
      WHILE @@fetch_status      = 0  
      BEGIN --#cursor  
      --  
  
        IF ISNULL(@l_id1,'') = ' '  
        BEGIN  
        --  
          SET @l_id1 = @l_id + '*|~*'  
        --  
        END  
        ELSE  
        BEGIN  
        --  
          SET @l_id1 = @l_id1  +  @l_id + '*|~*'  
        --  
        END  
  
        FETCH next FROM @c_cursor INTO @l_id  
      --    
      END  --#cursor  
  
      CLOSE      @c_cursor  
      DEALLOCATE @c_cursor  
    --  
    END  
    IF @PA_TAB = 'CLISBAENTR'  
    BEGIN  
    --  
      SET     @c_cursor  = CURSOR fast_forward FOR   
      SELECT DISTINCT entr_id FROM   entity_relationship_mak ,dp_acct_mstr,excsm_prod_mstr WHERE  entr_deleted_ind IN (0,4,8) AND dpam_sba_no =  entr_sba and excpm_id = entr_excpm_id AND excpm_Excsm_id = dpam_excsm_id  and  dpam_id IN (SELECT clisba_id FROM @l_clisba)  
      UNION  
      SELECT DISTINCT entr_id FROM   entity_relationship_mak ,dp_acct_mstr_mak,excsm_prod_mstr WHERE  entr_deleted_ind IN (0,4,8) AND dpam_sba_no =  entr_sba and excpm_id = entr_excpm_id  and excpm_Excsm_id = dpam_excsm_id AND dpam_id IN (SELECT clisba_id FROM @l_clisba)  
        
  
      OPEN    @c_cursor  
      --  
      FETCH next FROM @c_cursor INTO @l_id  
  
      WHILE @@fetch_status      = 0  
      BEGIN --#cursor  
      --  
  
        IF ISNULL(@l_id1,'') = ' '  
        BEGIN  
        --  
          SET @l_id1 = @l_id + '*|~*'  
        --  
        END  
        ELSE  
        BEGIN  
        --  
          SET @l_id1 = @l_id1 +  @l_id + '*|~*'  
        --  
        END  
  
        FETCH next FROM @c_cursor INTO @l_id  
      --    
      END  --#cursor  
  
      CLOSE      @c_cursor  
      DEALLOCATE @c_cursor  
    --  
    END  
    IF @PA_TAB = 'ENTP'  
    BEGIN  
    --  
      SET     @c_cursor  = CURSOR fast_forward FOR  
      SELECT DISTINCT entpmak_id   
      FROM   entity_properties_mak  
            ,entity_property_mstr  
            ,dp_acct_mstr  
            ,client_mstr   
            ,excsm_prod_mstr  
      WHERE  entp_ent_id        = clim_crn_no  
      AND    entp_entpm_prop_id = entpm_prop_id  
      AND    clim_crn_no        = dpam_crn_no  
      AND    entpm_excpm_id     = excpm_id  
      AND    dpam_excsm_id      = excpm_excsm_id  
      AND    dpam_id          IN (SELECT clisba_id FROM @l_clisba)  
      AND    entp_deleted_ind IN (0,4,8)   
  
      OPEN    @c_cursor  
      --  
      FETCH next FROM @c_cursor INTO @l_id  
  
      WHILE @@fetch_status      = 0  
      BEGIN --#cursor  
      --  
  
        IF ISNULL(@l_id1,'') =' '  
        BEGIN  
        --  
          SET @l_id1 = @l_id + '*|~*'  
        --  
        END  
        ELSE  
        BEGIN  
        --  
          SET @l_id1 = @l_id1 +  @l_id + '*|~*'  
        --  
        END  
  
        FETCH next FROM @c_cursor INTO @l_id  
      --    
      END  --#cursor  
  
      CLOSE      @c_cursor  
      DEALLOCATE @c_cursor  
    --  
    END  
    IF @PA_TAB = 'CLID'  
    BEGIN  
    --  
      SET     @c_cursor  = CURSOR fast_forward FOR  
      SELECT DISTINCT clid_id  
      FROM   client_documents_mak  
            ,document_mstr  
            ,dp_acct_mstr  
            ,excsm_prod_mstr  
            ,client_mstr   
      WHERE  clid_crn_no        = clim_crn_no  
      AND    clid_docm_doc_id   = docm_doc_id  
      AND    clim_crn_no        = dpam_crn_no  
      AND    docm_excpm_id      = excpm_id  
      AND    dpam_excsm_id      = excpm_excsm_id  
      AND    dpam_id          IN (SELECT clisba_id FROM @l_clisba)  
      AND    clid_deleted_ind IN (0,4,8)  
  
      OPEN    @c_cursor  
      --  
      FETCH next FROM @c_cursor INTO @l_id  
  
      WHILE @@fetch_status      = 0  
      BEGIN --#cursor  
      --  
  
        IF ISNULL(@l_id1,'') = ' '  
        BEGIN  
        --  
          SET @l_id1 = @l_id + '*|~*'  
        --  
        END  
        ELSE  
        BEGIN  
        --  
          SET @l_id1 = @l_id1 +  @l_id + '*|~*'  
        --  
        END  
  
        FETCH next FROM @c_cursor INTO @l_id  
      --    
      END  --#cursor  
  
      CLOSE      @c_cursor  
      DEALLOCATE @c_cursor  
    --  
    END  
    IF @PA_TAB = 'ACCP'  
    BEGIN  
    --  
      SET     @c_cursor  = CURSOR fast_forward FOR  
      SELECT DISTINCT accpmak_id  
      FROM   accp_mak  
      WHERE  accp_clisba_id   IN (SELECT clisba_id FROM @l_clisba)  
      AND    accp_deleted_ind IN (0,4,8)   
  
      OPEN    @c_cursor  
      --  
      FETCH next FROM @c_cursor INTO @l_id  
  
      WHILE @@fetch_status      = 0  
      BEGIN --#cursor  
      --  
  
        IF ISNULL(@l_id1,'') = ' '  
        BEGIN  
        --  
          SET @l_id1 = @l_id + '*|~*'  
        --  
        END  
        ELSE  
        BEGIN  
        --  
          SET @l_id1 = @l_id1 +  @l_id + '*|~*'  
        --  
        END  
  
        FETCH next FROM @c_cursor INTO @l_id  
      --    
      END  --#cursor  
  
      CLOSE      @c_cursor  
      DEALLOCATE @c_cursor  
  
    --  
    END  
    IF @PA_TAB = 'ACCD'  
    BEGIN  
    --  
  
      SET     @c_cursor  = CURSOR fast_forward FOR  
      SELECT DISTINCT accd_id  
      FROM   accd_mak  
      WHERE  accd_clisba_id IN (SELECT clisba_id FROM @l_clisba)  
      AND    accd_deleted_ind IN (0,4,8)  
  
      OPEN    @c_cursor  
      --  
      FETCH next FROM @c_cursor INTO @l_id  
  
      WHILE @@fetch_status      = 0  
      BEGIN --#cursor  
      --  
  
        IF ISNULL(@l_id1,'') = ' '  
        BEGIN  
        --  
          SET @l_id1 = @l_id + '*|~*'  
        --  
        END  
        ELSE  
        BEGIN  
        --  
          SET @l_id1 = @l_id1 +  @l_id + '*|~*'  
        --  
        END  
  
        FETCH next FROM @c_cursor INTO @l_id  
      --    
      END  --#cursor  
  
      CLOSE      @c_cursor  
      DEALLOCATE @c_cursor  
  
    --  
    END  
      
  --  
  END  
    
  RETURN @l_id1  
--  
END

GO
