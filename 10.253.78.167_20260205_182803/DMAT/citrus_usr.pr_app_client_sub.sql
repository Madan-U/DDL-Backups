-- Object: PROCEDURE citrus_usr.pr_app_client_sub
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

--pr_app_client_sub '','54790|*~|59383|*~|0079808901|*~|*|~*54790|*~|59385|*~|0079808901|*~|*|~*','APP','HO','54790|*~|59383|*~|0079808901|*~|*|~*54790|*~|59385|*~|0079808901|*~|*|~*',2,'*|~*','|*~|',''
--SELECT * FROM client_list ORDER BY 1 desc
CREATE PROCEDURE [citrus_usr].[pr_app_client_sub](@pa_id                VARCHAR(200)                    
                                 ,@pa_app_sba           VARCHAR(500)                  
                                 ,@pa_action            VARCHAR(20)                    
                                 ,@pa_login_name        VARCHAR(20)                    
                                 ,@pa_values            VARCHAR(8000)                    
                                 ,@pa_chk_yn            VARCHAR(20)                    
                                 ,@rowdelimiter         CHAR(4) =  '*|~*'                    
                                 ,@coldelimiter         CHAR(4)  = '|*~|'                    
                                 ,@pa_msg               VARCHAR(8000) OUTPUT                    
                                 )                    
AS                    
                   
/*  
*********************************************************************************  
 SYSTEM         : CITRUS  
 MODULE NAME    : pr_app_client_sub  
 DESCRIPTION    : This procedure will app client and entity  
 COPYRIGHT(C)   : marketplace technologies pvt. ltd.  
 VERSION HISTORY:  
 VERS.  AUTHOR             DATE        REASON  
 -----  -------------      ----------  -------------------------------------------------  
 1.0    TUSHAR             1-Aug-2007 INITIAL VERSION.  
--------------------------------------------------------------------------------------*/  
                    
BEGIN                    
--                    
  DECLARE @@c_clim                CURSOR                    
         ,@@c_addr                CURSOR                     
         ,@@c_conc                CURSOR                    
         ,@@c_clia                CURSOR                    
         ,@@c_clisba              CURSOR                    
         ,@@c_entr                CURSOR                    
         ,@@c_cliba               CURSOR                    
         ,@@c_clidpa              CURSOR                    
         ,@@c_entm                CURSOR                    
         ,@@c_entp                CURSOR                    
         ,@@c_entpd               CURSOR                    
         ,@@c_accp                CURSOR                    
         ,@@c_accpd               CURSOR                    
         ,@@c_clid                CURSOR                    
         ,@@c_accd                CURSOR                    
         ,@l_clid_id              VARCHAR(8000)                    
         ,@c_clid_id              NUMERIC                    
         ,@c_accd_id              NUMERIC                    
         ,@l_accd_id              VARCHAR(8000)                    
         ,@c_clim_id              NUMERIC                      
         ,@l_clim_id              VARCHAR(8000)                    
         ,@c_entmak_id            NUMERIC                       
         ,@l_entmak_id            VARCHAR(8000)                    
         ,@c_adrm_id              NUMERIC                      
         ,@l_adrm_id              VARCHAR(8000)                    
         ,@c_concmak_id           NUMERIC                      
         ,@l_concmak_id           VARCHAR(8000)                    
         ,@c_clia_id              NUMERIC                      
         ,@l_clia_id              VARCHAR(8000)                    
         ,@c_clisbamak_id         NUMERIC                      
         ,@l_clisbamak_id         VARCHAR(8000)                    
         ,@c_cliba_id             NUMERIC                      
         ,@l_cliba_id             VARCHAR(8000)                    
         ,@l_clidpa_id            VARCHAR(8000)                    
         ,@c_clidpa_id            NUMERIC                      
         ,@l_entr_id              VARCHAR(8000)          
         ,@c_entr_id              NUMERIC                     
         ,@l_entpmak_id           VARCHAR(8000)                    
         ,@c_entpmak_id           NUMERIC                    
         ,@l_entpd_id             VARCHAR(8000)                    
         ,@c_entpd_id             NUMERIC                    
         ,@l_accpmak_id           VARCHAR(8000)                    
         ,@c_accpmak_id           NUMERIC                    
         ,@l_accpd_id             VARCHAR(8000)                    
         ,@c_accpd_id             NUMERIC                  
         ,@delimeter_id           VARCHAR(10)                    
         ,@@delimeterlength_id    INT                    
         ,@@remainingstring_id    VARCHAR(8000)                    
         ,@@currstring_id         VARCHAR(8000)                    
         ,@@foundat               INTEGER                    
         ,@l_error                VARCHAR(50)                    
         ,@l_error1               VARCHAR(50)                    
         ,@l_crn_no               NUMERIC                    
         ,@l_rmks                 VARCHAR(8000)  
         ,@c_clisba_no            VARCHAR(50)   
         ,@l_app_sub_str          VARCHAR(1000)  
         ,@l_app_sub              VARCHAR(1000)   
                       
  --                        
  SET @l_clia_id           = ''                    
  SET @l_clim_id           = ''                    
  SET @l_entmak_id         = ''                    
  SET @l_adrm_id           = ''                    
  SET @l_concmak_id        = ''                    
  SET @l_clia_id           = ''                    
  SET @l_clisbamak_id      = ''                    
  SET @l_cliba_id          = ''                    
  SET @l_clidpa_id         = ''                    
  SET @l_entr_id           = ''                    
  SET @l_clid_id           = ''                     
  SET @l_entpmak_id        = ''                     
  SET @l_entpd_id          = ''                     
  SET @l_accpmak_id        = ''                     
  SET @l_accpd_id          = ''                     
  SET @l_accd_id           = ''   
  SET @l_app_sub_str       = ''    
  SET @delimeter_id        = '%'+ @rowdelimiter + '%'                    
  SET @@delimeterlength_id = LEN(@rowdelimiter)                    
  --logic for separate sub accts app                   
  IF @pa_app_sba <> '' AND @pa_id = ''                
  BEGIN                
  --                
    DECLARE @l_count_row   NUMERIC                
           ,@l             NUMERIC                
           ,@l_select_row  VARCHAR(50)                
           ,@l_clim_crn_no NUMERIC                
           ,@l_clisba_id   NUMERIC                
           ,@l_clisba_ids  VARCHAR(50)                 
           ,@l_pa_id       VARCHAR(1000)                
                
    DECLARE @l_temp_clisba TABLE(clim_crn_no NUMERIC, clisba_id NUMERIC)                  
                    
    SET     @l = 1                
    SET     @l_count_row = citrus_usr.ufn_countstring(@pa_app_sba,@rowdelimiter)                
                
    WHILE @l <= @l_count_row                 
    BEGIN                
    --                
      SELECT @l_select_row = citrus_usr.fn_splitval_row(@pa_app_sba,@l)                    
                      
      SELECT @l_clim_crn_no = citrus_usr.fn_splitval(@l_select_row,1)               
                       
      SELECT @l_clisba_id   = citrus_usr.fn_splitval(@l_select_row,2)                      
                   
      --FOR PA_ID                
      SET @l_pa_id  = ISNULL(@l_pa_id,'') + convert(varchar(20),@l_clim_crn_no) + @coldelimiter + '' + @coldelimiter + @rowdelimiter                                
      --FOR PA_ID                
      INSERT INTO  @l_temp_clisba                
      (clim_crn_no                
      ,clisba_id)                 
      VALUES(@l_clim_crn_no, @l_clisba_id)                
                
      SET @l = @l + 1                
    --                
    END                
    SET @@remainingstring_id = @l_pa_id                
                  
  END                
  ELSE                
  BEGIN                
  --                
    SET @@remainingstring_id = @pa_id                  
  --                
  END                
  --logic for separate sub accts app                
         
  WHILE @@remainingstring_id <> ''                    
  BEGIN                    
  --                    
    SET @@foundat = 0                    
    SET @@foundat =  PATINDEX('%'+@delimeter_id+'%',@@remainingstring_id)                    
    --                    
    IF  @@FOUNDAT > 0                    
    BEGIN                 
    --                    
      SET @@currstring_id      = SUBSTRING(@@remainingstring_id, 0,@@foundat)                    
      SET @@remainingstring_id = SUBSTRING(@@remainingstring_id, @@foundat+@@delimeterlength_id,LEN(@@remainingstring_id)- @@foundat+@@delimeterlength_id)                    
    --                    
    END                    
    ELSE                    
    BEGIN                    
    --                    
      SET @@currstring_id = @@remainingstring_id                    
      SET @@remainingstring_id = ''                    
    --                    
    END                    
    --                    
    IF @@currstring_id <> ''                    
    BEGIN                    
    --                      
      BEGIN TRANSACTION                    
      --                    
        SET @l_crn_no = CONVERT(NUMERIC, citrus_usr.fn_splitval(@@currstring_id,1))                    
        SET @l_rmks   = CONVERT(VARCHAR, citrus_usr.fn_splitval(@@currstring_id,2))                    
        --                    
        IF EXISTS(SELECT clim_crn_no                     
                  FROM   client_mstr_mak  WITH(NOLOCK)                     
                  WHERE  clim_deleted_ind IN (0,4,8)                     
                  AND    clim_crn_no       = @l_crn_no --CONVERT(NUMERIC,@@currstring_id)                    
                 )                    
        BEGIN                    
        --                    
          SET @@c_clim               =  CURSOR fast_forward FOR                    
          SELECT clim_id                       
          FROM   client_mstr_mak    WITH(NOLOCK)                    
          WHERE  clim_deleted_ind   IN(0,4,8)                    
          AND    clim_crn_no         = @l_crn_no --CONVERT(VARCHAR,@@currstring_id)                    
          --                    
          OPEN @@c_clim                    
          --                    
          FETCH NEXT FROM @@c_clim INTO @c_clim_id                          
          --                    
          WHILE @@fetch_status = 0                    
          BEGIN                    
          --                    
            SET @l_clim_id = @l_clim_id+CONVERT(varchar,@c_clim_id)+@coldelimiter+ISNULL(CONVERT(varchar,@l_rmks),'')+@coldelimiter+@rowdelimiter                    
            --                    
            FETCH NEXT FROM @@c_clim INTO @l_clim_id                    
          --                    
          END                    
          --                    
          CLOSE      @@c_clim                    
          DEALLOCATE @@c_clim                    
          --                     
          IF ISNULL(@l_clim_id,'') <> ''                    
          BEGIN                    
          --                    
            EXEC pr_ins_upd_clim @l_clim_id ,@pa_action, @pa_login_name, @l_clim_id, 1, @rowdelimiter, @coldelimiter, @pa_output = @l_error, @pa_msg = @l_error1                    
          --                      
          END                     
          --                    
          IF CONVERT(NUMERIC,@l_error1) > 0                    
          BEGIN                    
          --                    
            ROLLBACK TRANSACTION                    
            --                                 
            CONTINUE                    
          --                    
          END                    
          ELSE                    
          BEGIN                    
          --                    
            EXEC pr_ins_upd_list @l_crn_no,'A','CLIENT MSTR',@pa_login_name,'*|~*','|*~|',''                     
          --                    
          END                    
        --                    
        END                    
                       
        IF EXISTS(SELECT adr_ent_id                     
                  FROM   addresses_mak   WITH(NOLOCK)                    
                  WHERE  adr_deleted_ind IN (0,4,8)                     
                  AND    adr_ent_id = @l_crn_no           
                 )                    
        BEGIN                    
        --                    
          SET @@c_addr               = CURSOR fast_forward FOR                    
          SELECT adrm_id                    
          FROM   addresses_mak       WITH(NOLOCK)                     
          WHERE  adr_deleted_ind     IN(0,4,8)                    
          AND    adr_ent_id          = @l_crn_no --CONVERT(NUMERIC,@@currstring_id)                    
          --                      
          OPEN @@c_addr                    
          FETCH NEXT FROM @@c_addr INTO @c_adrm_id                    
          --                    
          WHILE @@fetch_status = 0                    
          BEGIN                    
          --                    
            SET @l_adrm_id = @l_adrm_id + CONVERT(VARCHAR,@c_adrm_id)+@rowdelimiter                    
            --                    
            FETCH NEXT FROM @@c_addr INTO @c_adrm_id                    
          --                    
          END                    
          CLOSE      @@c_addr                    
          DEALLOCATE @@c_addr                    
          --                      
          IF ISNULL(@l_adrm_id,'') <> ''                    
          BEGIN                    
          --        
            EXEC pr_ins_upd_addr @l_adrm_id ,@pa_action, @pa_login_name, @l_crn_no,'','|*~|', 1, @rowdelimiter, @coldelimiter, @pa_msg = @l_error                     
          --                    
          END                    
          --                    
          IF CONVERT(NUMERIC,@l_error) > 0                    
          BEGIN                    
          --                    
            ROLLBACK TRANSACTION                    
            --                      
            CONTINUE                    
          --                    
          END                    
          ELSE                    
          BEGIN                    
          --                    
            EXEC pr_ins_upd_list @l_crn_no, 'A','ADDRESSES', @pa_login_name,'*|~*','|*~|',''                    
          --                    
          END                    
        --                    
        END                    
        --                    
        IF EXISTS(SELECT conc_ent_id                     
                  FROM   contact_channels_mak WITH(NOLOCK)                     
                  WHERE  conc_deleted_ind IN (0,4,8)                     
                  AND    conc_ent_id        = @l_crn_no           
                 )                    
        BEGIN                    
        --                    
          SET    @@c_conc               = CURSOR fast_forward FOR                    
          SELECT concmak_id                    
          FROM   contact_channels_mak   WITH(NOLOCK)                    
         WHERE  conc_deleted_ind       IN(0,4,8)                    
          AND    conc_ent_id            = @l_crn_no           
          --                      
          OPEN @@c_conc                    
          --                    
          FETCH NEXT FROM @@c_conc INTO @c_concmak_id                    
          --                    
          WHILE @@fetch_status = 0                    
          BEGIN                    
          --                    
            SET @l_concmak_id = @l_concmak_id+CONVERT(VARCHAR,@c_concmak_id)+@rowdelimiter                    
            --                     
            FETCH NEXT FROM @@c_conc INTO @c_concmak_id                    
 --                    
          END                    
          CLOSE      @@c_conc                    
          DEALLOCATE @@c_conc                    
          --                    
          IF ISNULL(@l_concmak_id,'') <> ''                    
          BEGIN                    
          --                    
            EXEC pr_ins_upd_conc @l_concmak_id ,@pa_action, @pa_login_name, @l_crn_no,'','|*~|', 1, @rowdelimiter, @coldelimiter, @pa_msg = @l_error                    
          --                    
          END                    
          --                    
          IF CONVERT(NUMERIC,@l_error) > 0                    
          BEGIN                    
          --                    
            ROLLBACK TRANSACTION                    
            --                    
            CONTINUE                    
          --                    
          END                    
          ELSE                    
          BEGIN                    
          --                    
            EXEC pr_ins_upd_list @l_crn_no, 'A','CONTACT CHANNELS', @pa_login_name,'*|~*','|*~|',''                    
          --                    
          END                    
        --                    
        END                    
        IF EXISTS(SELECT clia_crn_no                     
                  FROM   client_accounts_mak WITH(NOLOCK)                    
                  WHERE  clia_deleted_ind    IN (0,4,8)                     
                  AND    clia_crn_no         = @l_crn_no --CONVERT(NUMERIC,@@currstring_id)                    
                 )                    
        BEGIN                    
        --                    
          SET    @@c_clia               = CURSOR fast_forward FOR                    
          SELECT clia_id                    
          FROM   client_accounts_mak   WITH(NOLOCK)                    
          WHERE  clia_deleted_ind      IN (0,4,8)                    
          AND    clia_crn_no            = @l_crn_no --CONVERT(NUMERIC,@@currstring_id)                    
          --                    
          OPEN @@c_clia                    
          FETCH NEXT FROM @@c_clia INTO @c_clia_id                    
          --                    
          WHILE @@fetch_status = 0                    
          BEGIN                    
          --                    
            SET @l_clia_id = @l_clia_id+CONVERT(VARCHAR,@c_clia_id)+@rowdelimiter                    
            --                    
            FETCH NEXT FROM @@c_clia INTO @c_clia_id                    
          --                    
          END                    
          CLOSE      @@c_clia                    
          DEALLOCATE @@c_clia                    
          --                    
          IF ISNULL(@l_clia_id,'') <> ''                    
          BEGIN                    
          --                    
            EXEC pr_ins_upd_clia @l_clia_id ,@pa_action, @pa_login_name, @l_crn_no,'', 1, @rowdelimiter, @coldelimiter, @pa_msg = @l_error                    
          --                    
          END                    
                              
          IF CONVERT(NUMERIC,@l_error) > 0                    
          BEGIN                    
          --                    
            ROLLBACK TRANSACTION                    
            CONTINUE                    
          --                    
          END                    
          ELSE                    
          BEGIN                    
          --                    
            EXEC pr_ins_upd_list @l_crn_no, 'A','CLIENT ACCOUNTS', @pa_login_name,'*|~*','|*~|',''                    
          --                    
          END                    
        --                    
        END                    
        IF EXISTS(SELECT clisba_crn_no                     
                  FROM   client_sub_accts_mak WITH(NOLOCK)                    
                  WHERE  clisba_deleted_ind   IN (0,4,8)                     
                  AND    clisba_crn_no = @l_crn_no           
                 )                    
        BEGIN                    
        --                    
          IF @pa_app_sba <> ''                
          BEGIN                
          --   
            SELECT clisbamak_id                    
                 , clisba_id  
            FROM   client_sub_accts_mak     WITH(NOLOCK)                    
            WHERE  clisba_deleted_ind       IN(0,4,8)                    
            AND    clisba_crn_no            = @l_crn_no                
            AND    clisba_id                IN (SELECT clisba_id FROM @l_temp_clisba WHERE clim_crn_no = @l_crn_no)   --CONVERT(VARCHAR,@@currstring_id)                      
            
                         
            SET    @@c_clisba               = CURSOR fast_forward FOR                    
            SELECT clisbamak_id                    
                 , clisba_id  
            FROM   client_sub_accts_mak     WITH(NOLOCK)                    
            WHERE  clisba_deleted_ind       IN(0,4,8)                    
            AND    clisba_crn_no            = @l_crn_no                
            AND    clisba_id                IN (SELECT clisba_id FROM @l_temp_clisba WHERE clim_crn_no = @l_crn_no)   --CONVERT(VARCHAR,@@currstring_id)                      
          --                
          END                
          ELSE                  
          BEGIN                
          --                
            SET    @@c_clisba               = CURSOR fast_forward FOR                    
            SELECT clisbamak_id                    
            FROM   client_sub_accts_mak     WITH(NOLOCK)                    
            WHERE  clisba_deleted_ind       IN(0,4,8)                    
            AND    clisba_crn_no            = @l_crn_no --CONVERT(VARCHAR,@@currstring_id)                    
          --                    
          END                
                
          OPEN @@c_clisba                    
          FETCH NEXT FROM @@c_clisba INTO @c_clisbamak_id , @c_clisba_no                   
          --                    
          WHILE @@fetch_status = 0                    
          BEGIN                    
          --                    
            SET @l_clisbamak_id = @l_clisbamak_id + CONVERT(VARCHAR,@c_clisbamak_id)+@rowdelimiter                    
              
            SET @l_app_sub_str  = @l_app_sub_str + CONVERT(VARCHAR,@l_crn_no) +  @coldelimiter + ISNULL(@c_clisba_no,'') +  @coldelimiter + @rowdelimiter  
              
            FETCH NEXT FROM @@c_clisba INTO @c_clisbamak_id , @c_clisba_no                   
              
          --                    
          END                    
          CLOSE      @@c_clisba                    
          DEALLOCATE @@c_clisba                    
          --           
                    
          IF ISNULL(@l_clisbamak_id,'') <> ''                    
          BEGIN                    
          --     
            EXEC pr_ins_upd_clisba @l_clisbamak_id ,@pa_action, @pa_login_name, @l_crn_no, '', 1, @rowdelimiter, @coldelimiter, @pa_msg = @l_error                    
          --                    
          END                    
                    
          IF CONVERT(NUMERIC,@l_error) > 0                    
          BEGIN                    
          --                    
            ROLLBACK TRANSACTION                    
                    
            CONTINUE                    
          --                    
          END                    
          ELSE                    
          BEGIN                    
          --
            PRINT    @l_app_sub_str +'ddd'
            SET @l_count_row = citrus_usr.ufn_CountString(@l_app_sub_str, @rowdelimiter)  
            SET @l           = 1  
              
            WHILE @l <= @l_count_row  
            BEGIN  
            --  
              SET @l_app_sub  =  citrus_usr.fn_splitval_row(@l_app_sub_str, @l)  
                
              EXEC pr_ins_upd_list @l_app_sub, 'A','Client Sub Accts', @pa_login_name,'*|~*','|*~|',''                     
                
              SET @l = @l + 1  
                
            --  
            END  
          --                    
          END                    
        --                    
        END                    
        --                    
        IF EXISTS(SELECT cliba_id                   
                  FROM   client_bank_accts_mak       clibam  WITH(NOLOCK)                  
                       , client_sub_accts            clisba  WITH(NOLOCK)                  
             WHERE  clibam.cliba_clisba_id    = clisba.clisba_id                   
                  AND    clisba.clisba_crn_no      = @l_crn_no --CONVERT(NUMERIC,@@currstring_id)                  
                  AND    clibam.cliba_deleted_ind IN (0,4,8))                       
        OR EXISTS(SELECT cliba_id                   
                  FROM   client_bank_accts_mak       clibam  WITH(NOLOCK)                  
                       , client_sub_accts_mak        clisba  WITH(NOLOCK)                  
                  WHERE  clibam.cliba_clisba_id    = clisba.clisba_id                   
                  AND    clisba.clisba_crn_no      = @l_crn_no --CONVERT(NUMERIC,@@currstring_id)                  
                  AND    clibam.cliba_deleted_ind IN (0,4,8))     
        BEGIN                    
        --                    
          SET @l_cliba_id = citrus_usr.fn_get_App_string(@pa_app_sba,'CLIBA',1)          
          
          IF ISNULL(@l_cliba_id,'') <> ''                    
          BEGIN                    
          --           
                      
            EXEC pr_ins_upd_cliba @l_cliba_id,@pa_action,@pa_login_name, @l_crn_no,'',1,@rowdelimiter,@coldelimiter,@pa_msg = @l_error                    
                    
          --                      
          END                      
                    
                    
          IF CONVERT(NUMERIC,@l_error) > 0                    
          BEGIN                    
          --          
            ROLLBACK TRANSACTION          
            CONTINUE                    
          --                    
          END                    
          ELSE                    
          BEGIN                    
          --                    
            EXEC pr_ins_upd_list @l_crn_no,'A','Client Bank Accts',@pa_login_name,'*|~*','|*~|',''                     
          --                    
          END                    
        --                    
        END                    
        --                    
        IF EXISTS(SELECT clidpa_id                   
                  FROM   client_dp_accts_mak            clidpam  WITH(NOLOCK)                  
                        ,client_sub_accts               clisba   WITH(NOLOCK)                  
                  WHERE  clidpam.clidpa_clisba_id     = clisba.clisba_id                   
                  AND    clisba.clisba_crn_no      = @l_crn_no --CONVERT(NUMERIC,@@currstring_id)                  
                  AND    clidpam.clidpa_deleted_ind  IN (0,4,8)                  
                  )    
        OR EXISTS(SELECT clidpa_id                   
                  FROM   client_dp_accts_mak            clidpam  WITH(NOLOCK)                  
                        ,client_sub_accts_mak           clisba   WITH(NOLOCK)                  
                  WHERE  clidpam.clidpa_clisba_id     = clisba.clisba_id                   
                  AND    clisba.clisba_crn_no      = @l_crn_no --CONVERT(NUMERIC,@@currstring_id)                  
                  AND    clidpam.clidpa_deleted_ind  IN (0,4,8)                  
                  )                                   
        BEGIN                    
        --                    
          SET @l_clidpa_id = citrus_usr.fn_get_App_string(@pa_app_sba,'CLIDPA',1)          
              
          IF ISNULL(@l_clidpa_id,'') <> ''                    
          BEGIN                    
          --                    
             EXEC pr_ins_upd_clidpa @l_clidpa_id,@pa_action,@pa_login_name, @l_crn_no,'',1,@rowdelimiter,@coldelimiter,@pa_msg = @l_error                    
          --                    
          END                    
          --                     
                    
          IF CONVERT(NUMERIC,@l_error) > 0                    
          BEGIN                    
          --                    
            ROLLBACK TRANSACTION                    
            CONTINUE                    
          --                    
   END                    
          ELSE                    
          BEGIN                    
          --                    
            EXEC pr_ins_upd_list @l_crn_no,'A','Client DP Accts',@pa_login_name,'*|~*','|*~|',''                     
          --                    
          END                    
       --                    
       END                    
       --     
                        
       IF EXISTS(SELECT entr_id                     
                 FROM   entity_relationship_mak  WITH(NOLOCK)                    
                 WHERE  entr_crn_no       = @l_crn_no --CONVERT(NUMERIC,@@currstring_id)                     
                 AND    entr_deleted_ind IN (0,4,8))                    
       BEGIN                    
       --                    
         SET @l_entr_id = citrus_usr.fn_get_App_string(@pa_app_sba,'CLISBAENTR',1)          
             
         IF ISNULL(@l_entr_id,'') <> ''                    
         BEGIN                    
         --                    
           EXEC pr_ins_upd_entr @l_entr_id,@pa_action,@pa_login_name, @l_crn_no,'',1,@rowdelimiter,@coldelimiter,@pa_msg = @l_error                    
         --                    
         END                    
         PRINT CONVERT(VARCHAR,GETDATE(),109)                    
                             
         IF CONVERT(NUMERIC,@l_error) > 0                    
         BEGIN                    
         --                    
           ROLLBACK TRANSACTION                    
                      
           CONTINUE                    
         --                    
         END                    
         ELSE                    
         BEGIN                    
         --                    
           EXEC pr_ins_upd_list  @l_crn_no,'A','ENTITY RELATIONSHIP', @pa_login_name, '*|~*', '|*~|', ''                      
         --                    
         END                    
       --                    
       END                    
       IF EXISTS(SELECT clid_id                     
                 FROM   client_documents_mak  WITH(NOLOCK)                    
                 WHERE  clid_crn_no       = @l_crn_no --CONVERT(NUMERIC,@@currstring_id)                    
                 AND    clid_deleted_ind IN (0,4,8))                    
       BEGIN           
       --                    
         SET @l_clid_id = citrus_usr.fn_get_App_string(@pa_app_sba,'CLID',1)          
         
         IF isnull(@l_clid_id,'') <> ''                    
         BEGIN                    
         --                    
           EXEC pr_ins_upd_clid @l_clid_id,@pa_action,@pa_login_name, @l_crn_no,'',1,@rowdelimiter,@coldelimiter,@pa_msg = @l_error                    
         --                    
         END                    
         --                    
         IF CONVERT(NUMERIC,@l_error) > 0                    
         BEGIN                    
         --                    
           ROLLBACK TRANSACTION                    
                    
           CONTINUE                    
         --                    
         END                    
         ELSE                    
         BEGIN                    
         --                    
           EXEC pr_ins_upd_list @l_crn_no,'A','Client Documents',@pa_login_name,'*|~*','|*~|',''                     
         --                    
         END                    
                             
       --                    
       END                    
       --                    
                                
       IF EXISTS(SELECT accd_id                    
                 FROM   accd_mak                    accdmak  WITH(NOLOCK)                    
                      , client_sub_accts            clisba   WITH(NOLOCK)             
                 WHERE  accdmak.accd_clisba_id     = clisba.clisba_id                    
                 AND    clisba.clisba_crn_no       = @l_crn_no --CONVERT(NUMERIC,@@currstring_id)                    
       AND    accdmak.accd_deleted_ind  IN (0,4,8)                    
                 AND    clisba.clisba_deleted_ind  = 1                    
                )                    
       BEGIN                    
       --          
         SET @l_accd_id = citrus_usr.fn_get_App_string(@pa_app_sba,'ACCD',1)          
                 
         IF isnull(@l_accd_id,'') <> ''                    
         BEGIN                    
         --                    
           EXEC pr_ins_upd_accd @l_accd_id,@pa_action,@pa_login_name, @l_crn_no,'','','',1,@rowdelimiter,@coldelimiter,@pa_msg = @l_error                    
         --                    
         END                    
                   
         IF CONVERT(NUMERIC,@l_error) > 0                    
         BEGIN                    
         --                    
           ROLLBACK TRANSACTION                    
           --                    
           CONTINUE                    
         --                    
         END                    
         ELSE                    
         BEGIN                    
         --                    
           EXEC pr_ins_upd_list @l_crn_no, 'A','Account Documents', @pa_login_name,'*|~*','|*~|',''                 
         --                    
         END                    
       --                    
       END                    
       --                    
       IF EXISTS(SELECT entpmak_id                     
                 FROM   entity_properties_mak  WITH(NOLOCK)                    
                 WHERE  entp_ent_id       = @l_crn_no --CONVERT(NUMERIC,@@currstring_id)                     
                 AND    entp_deleted_ind IN (0,4,8)                    
                 )                    
       BEGIN                    
       --          
         SET @l_entpmak_id = citrus_usr.fn_get_App_string(@pa_app_sba,'ENTP',1)          
                 
         IF ISNULL(@l_entpmak_id,'') <> ''                    
         BEGIN                    
         --                    
           EXEC pr_ins_upd_entp @l_entpmak_id,@pa_action,@pa_login_name, @l_crn_no,'','','',1,@rowdelimiter,@coldelimiter,@pa_msg = @l_error                    
         --                    
         END                    
                   
                             
         IF CONVERT(NUMERIC,@l_error) > 0                    
         BEGIN                    
         --                    
           ROLLBACK TRANSACTION                    
           --                    
           CONTINUE                    
         --                    
         END                    
         ELSE                    
         BEGIN                    
         --                    
           EXEC pr_ins_upd_list @l_crn_no,'A','ENTITY PROPERTIES',@pa_login_name,'*|~*','|*~|',''                     
         --         
         END                    
       --                    
       END                    
       --                    
       IF EXISTS(SELECT accpmak_id                     
                 FROM   --account_properties_mak    accpmak                     
                        accp_mak                  accpmak  WITH(NOLOCK)                    
                      , client_sub_accts          clisba   WITH(NOLOCK)                    
                 WHERE  accpmak.accp_clisba_id    = clisba.clisba_id                    
                 AND    clisba.clisba_crn_no      = @l_crn_no --CONVERT(NUMERIC,@@currstring_id)                     
                 AND    accpmak.accp_deleted_ind       IN (0,4,8)                    
                 AND    clisba.clisba_deleted_ind = 1)                    
       BEGIN                    
       --          
         SET @l_accpmak_id = citrus_usr.fn_get_App_string(@pa_app_sba,'ACCP',1)          
                 
         IF ISNULL(@l_accpmak_id, '') <> ''                    
         BEGIN                    
         --                    
           EXEC pr_ins_upd_accp @l_accpmak_id,@pa_action,@pa_login_name, @l_crn_no,'','','','',1,@rowdelimiter,@coldelimiter,@pa_msg = @l_error                    
         --                    
         END                    
                             
         IF CONVERT(NUMERIC,@l_error) > 0                    
         BEGIN                    
         --                    
           ROLLBACK TRANSACTION                    
           --                    
           CONTINUE                    
         --                    
         END                    
         ELSE                    
         BEGIN              
         --                    
           EXEC pr_ins_upd_list @l_crn_no,'A','ACCOUNT PROPERTIES',@pa_login_name,'*|~*','|*~|',''                            
         --                    
         END                    
       --                    
       END                    
       --                    
       COMMIT TRANSACTION                    
      --                    
      END                    
    --                    
    END                    
  --                    
  END

GO
