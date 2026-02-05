-- Object: PROCEDURE citrus_usr.pr_app_client
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--begin transaction    
--PR_APP_CLIENT '54875|*~||*~|*|~*','','APP','HEAD','54875|*~||*~|*|~*',1,'*|~*','|*~|',''    
--rollback transaction    
    
    
CREATE  PROCEDURE [citrus_usr].[pr_app_client](@pa_id                VARCHAR(200)      
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
 MODULE NAME    : pr_app_client      
 DESCRIPTION    : This procedure will app client and entity      
 COPYRIGHT(C)   : enc software solutions pvt. ltd.      
 VERSION HISTORY:      
 VERS.  AUTHOR             DATE        REASON      
 -----  -------------      ----------  -------------------------------------------------      
 1.0    TUSHAR             23-APR-2007 INITIAL VERSION.      
--------------------------------------------------------------------------------------*/      
      
BEGIN      
--      
  IF @pa_app_sba = ''      
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
           ,@l_crn_no               numeric      
           ,@l_rmks                 varchar(8000)         
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
    SET @l_accd_id          = ''       
    SET @delimeter_id        = '%'+ @rowdelimiter + '%'      
    SET @@delimeterlength_id = LEN(@rowdelimiter)      
    SET @@remainingstring_id = @pa_id      
    --      
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
          /*      
          select * from client_mstr_mak-->clim_id       
                           OR       
          select * from entity_mstr_mak-->entmak_id      
          select * from addresses_mak-->adrm_id      
          select * from contact_channels_mak-->concmak_id      
          select * from client_accounts_mak-->clia_id      
          select * from client_sub_accts_mak-->clisba_id      
          select * from entity_relationship_mak-->entr_id      
          select * from client_bank_accts_mak-->cliba_id      
          select * from client_dp_accts_mak-->clidpa_id      
          */      
          BEGIN TRANSACTION      
          PRINT 'BEGIN TRANSACTION'      
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
            PRINT 'CLIENT MSTR'        
            PRINT CONVERT(VARCHAR,GETDATE(),109)      
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
              --print ''      
              EXEC pr_ins_upd_clim @l_clim_id ,@pa_action, @pa_login_name, @l_clim_id, 1, @rowdelimiter, @coldelimiter, @pa_output = @l_error, @pa_msg = @l_error1      
            --        
            END       
            PRINT CONVERT(VARCHAR,GETDATE(),109)       
            --print @l_clim_id + ' pr_ins_upd_clim client master'      
            --      
            IF CONVERT(NUMERIC,@l_error1) > 0      
            BEGIN      
            --      
              ROLLBACK TRANSACTION      
              PRINT 'ROLLBACK TRANSACTION'       
              PRINT CONVERT(VARCHAR,GETDATE(),109)      
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
          ELSE IF EXISTS(SELECT entmak_id       
                         FROM   entity_mstr_mak  WITH(NOLOCK)       
                         WHERE  entm_deleted_ind IN (0,4,8)       
                         AND    entm_id = @l_crn_no --CONVERT(NUMERIC,@@currstring_id)      
                        )      
          BEGIN      
          --      
            PRINT 'ENTITY_MSTR'        
            PRINT CONVERT(VARCHAR,GETDATE(),109)      
            SET    @@c_entm            =  CURSOR fast_forward FOR      
            SELECT entmak_id        
            FROM   entity_mstr_mak    WITH(NOLOCK)      
            WHERE  entm_deleted_ind   IN(0,4,8)      
            AND    entm_id             =  @l_crn_no --CONVERT(VARCHAR,@@currstring_id)      
            --         
            OPEN @@c_entm      
            --      
            FETCH NEXT FROM @@c_entm INTO @c_entmak_id            
            --      
            WHILE @@fetch_status = 0      
            BEGIN      
            --      
              --SET @l_entmak_id = @l_entmak_id +CONVERT(VARCHAR,@c_entmak_id)+@rowdelimiter      
              SET @l_entmak_id = @l_entmak_id+CONVERT(varchar,@c_entmak_id)+@coldelimiter+ISNULL(CONVERT(varchar,@l_rmks),'')+@coldelimiter+@rowdelimiter      
              --       
              FETCH NEXT FROM @@c_entm INTO @l_entmak_id      
            --      
            END      
            CLOSE      @@c_entm      
            DEALLOCATE @@c_entm      
            --      
            IF ISNULL(@l_entmak_id,'') <> ''      
            BEGIN      
            --      
              --print ''      
              EXEC pr_ins_upd_entm @l_entmak_id ,@pa_action, @pa_login_name, @l_entmak_id, 1, @rowdelimiter, @coldelimiter, @pa_output= @l_error, @pa_msg =@l_error1       
            --        
            END        
            PRINT CONVERT(VARCHAR,GETDATE(),109)      
            --                 
            IF CONVERT(NUMERIC,@l_error1) > 0      
            BEGIN      
            --      
              ROLLBACK TRANSACTION      
              PRINT 'ROLLBACK TRANSACTION'       
              PRINT CONVERT(VARCHAR,GETDATE(),109)      
              --        
              CONTINUE      
            --      
            END      
            ELSE      
            BEGIN      
            --      
              EXEC pr_ins_upd_list @l_crn_no, 'A','ENTITY MSTR', @pa_login_name,'*|~*','|*~|',''       
            --      
            END      
          --      
          END      
          --      
          IF EXISTS(SELECT adr_ent_id       
                    FROM   addresses_mak   WITH(NOLOCK)      
                    WHERE  adr_deleted_ind IN (0,4,8)       
                    AND    adr_ent_id = @l_crn_no --CONVERT(NUMERIC,@@currstring_id)      
                   )      
          BEGIN      
          --      
            PRINT 'ADDRESSES'      
            PRINT CONVERT(VARCHAR,GETDATE(),109)      
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
              SET @l_adrm_id = @l_adrm_id+CONVERT(VARCHAR,@c_adrm_id)+@rowdelimiter      
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
              --print ''      
            --      
            END      
            PRINT CONVERT(VARCHAR,GETDATE(),109)      
            --      
            IF CONVERT(NUMERIC,@l_error) > 0      
            BEGIN      
            --      
              ROLLBACK TRANSACTION      
              PRINT 'ROLLBACK TRANSACTION'       
              PRINT CONVERT(VARCHAR,GETDATE(),109)      
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
                    AND    conc_ent_id        = @l_crn_no --CONVERT(NUMERIC,@@currstring_id)      
                   )      
          BEGIN      
          --      
            PRINT 'CONC'      
            PRINT CONVERT(VARCHAR,GETDATE(),109)       
            SET    @@c_conc               = CURSOR fast_forward FOR      
            SELECT concmak_id      
            FROM   contact_channels_mak   WITH(NOLOCK)      
            WHERE  conc_deleted_ind       IN(0,4,8)      
            AND    conc_ent_id            = @l_crn_no --CONVERT(NUMERIC,@@currstring_id)      
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
              --print ''      
            --      
            END      
            --      
            PRINT CONVERT(VARCHAR,GETDATE(),109)      
            --      
            IF CONVERT(NUMERIC,@l_error) > 0      
            BEGIN      
            --      
              ROLLBACK TRANSACTION      
              PRINT 'ROLLBACK TRANSACTION'       
              PRINT CONVERT(VARCHAR,GETDATE(),109)      
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
            PRINT 'CLIENT ACCOUNT'      
            PRINT CONVERT(VARCHAR,GETDATE(),109)      
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
              --print ''      
            --      
            END      
            PRINT CONVERT(VARCHAR,GETDATE(),109)      
      
            IF CONVERT(NUMERIC,@l_error) > 0      
            BEGIN      
            --      
              ROLLBACK TRANSACTION      
              PRINT 'ROLLBACK TRANSACTION'       
              PRINT CONVERT(VARCHAR,GETDATE(),109)      
      
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
                    AND    clisba_crn_no = @l_crn_no --CONVERT(NUMERIC,@@currstring_id)      
                   )      
          BEGIN      
          --      
            PRINT 'CLIENT_SUB_ACCTS'      
            PRINT CONVERT(VARCHAR,GETDATE(),109)      
            SET    @@c_clisba               = CURSOR fast_forward FOR      
            SELECT clisbamak_id      
            FROM   client_sub_accts_mak     WITH(NOLOCK)      
            WHERE  clisba_deleted_ind       IN(0,4,8)      
            AND    clisba_crn_no            = @l_crn_no --CONVERT(VARCHAR,@@currstring_id)      
            --      
            OPEN @@c_clisba      
            FETCH NEXT FROM @@c_clisba INTO @c_clisbamak_id      
            --      
            WHILE @@fetch_status = 0      
            BEGIN      
            --      
              SET @l_clisbamak_id = @l_clisbamak_id + CONVERT(VARCHAR,@c_clisbamak_id)+@rowdelimiter      
      
              FETCH NEXT FROM @@c_clisba INTO @c_clisbamak_id      
            --      
            END      
            CLOSE      @@c_clisba      
            DEALLOCATE @@c_clisba      
            --      
            IF ISNULL(@l_clisbamak_id,'') <> ''      
            BEGIN      
            --      
              EXEC pr_ins_upd_clisba @l_clisbamak_id ,@pa_action, @pa_login_name, @l_crn_no, '', 1, @rowdelimiter, @coldelimiter, @pa_msg = @l_error      
              --print ''      
            --      
            END      
            PRINT CONVERT(VARCHAR,GETDATE(),109)      
            IF CONVERT(NUMERIC,@l_error) > 0      
            BEGIN      
            --      
              ROLLBACK TRANSACTION      
              PRINT 'ROLLBACK TRANSACTION'       
              PRINT CONVERT(VARCHAR,GETDATE(),109)      
      
              CONTINUE      
            --      
            END      
            ELSE      
            BEGIN      
            --      
              EXEC pr_ins_upd_list @l_crn_no, 'A','Client Sub Accts', @pa_login_name,'*|~*','|*~|',''       
            --      
            END      
          --      
          END      
          --      
          IF EXISTS(SELECT cliba_id       
                    FROM   client_bank_accts_mak       clibam   WITH(NOLOCK)      
                         , client_sub_accts_mak        clisbam  WITH(NOLOCK)      
                    WHERE  clibam.cliba_clisba_id    = clisbam.clisba_id       
                    AND    clisbaM.clisba_crn_no     = @l_crn_no --CONVERT(NUMERIC,@@currstring_id)      
                    AND    clibam.cliba_deleted_ind IN (0,4,8)      
                   )       
             OR EXISTS(SELECT cliba_id       
                       FROM   client_bank_accts_mak       clibam   WITH(NOLOCK)      
                            , client_sub_accts            clisba  WITH(NOLOCK)      
                       WHERE  clibam.cliba_clisba_id    = clisba.clisba_id       
                       AND    clisba.clisba_crn_no      = @l_crn_no --CONVERT(NUMERIC,@@currstring_id)      
                       AND    clibam.cliba_deleted_ind IN (0,4,8)      
                      )             
          BEGIN      
          --      
            PRINT 'CLIANT_BANK_ACCTS'      
            PRINT CONVERT(VARCHAR,GETDATE(),109)      
            SET    @@c_cliba                = CURSOR fast_forward FOR      
      
            SELECT cliba_id      
            FROM   client_bank_accts_mak      clibam      
                  ,client_sub_accts           clisba       
            WHERE  clibam.cliba_clisba_id   = clisba.clisba_id       
            AND    clisba.clisba_crn_no     = @l_crn_no --CONVERT(NUMERIC,@@currstring_id)       
            AND    clibam.cliba_deleted_ind IN (0,4,8)      
      
            /*SELECT cliba_id       
            FROM   client_bank_accts_mak       clibam   WITH(NOLOCK)      
                 , client_sub_accts_mak        clisbam  WITH(NOLOCK)      
            WHERE  clibam.cliba_clisba_id    = clisbam.clisba_id       
            AND    clisbaM.clisba_crn_no     = @l_crn_no --CONVERT(NUMERIC,@@currstring_id)      
            AND    clibam.cliba_deleted_ind IN (0,4,8)*/      
            --       
            OPEN @@c_cliba      
            FETCH NEXT FROM @@c_cliba INTO @c_cliba_id      
            --      
            WHILE @@fetch_status = 0      
            BEGIN      
            --      
              SET @l_cliba_id = @l_cliba_id + CONVERT(VARCHAR,@c_cliba_id)+@rowdelimiter      
              --       
              FETCH NEXT FROM @@c_cliba INTO @c_cliba_id      
            --      
            END      
            CLOSE      @@c_cliba      
            DEALLOCATE @@c_cliba      
            --      
            IF ISNULL(@l_cliba_id,'') <> ''      
            BEGIN      
            --      
              EXEC pr_ins_upd_cliba @l_cliba_id,@pa_action,@pa_login_name, @l_crn_no,'',1,@rowdelimiter,@coldelimiter,@pa_msg = @l_error      
              --print ''      
            --        
            END        
            PRINT CONVERT(VARCHAR,GETDATE(),109)      
            --      
            IF CONVERT(NUMERIC,@l_error) > 0      
            BEGIN      
            --      
              ROLLBACK TRANSACTION      
              PRINT 'ROLLBACK TRANSACTION'       
              PRINT CONVERT(VARCHAR,GETDATE(),109)      
      
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
                          ,client_sub_accts_mak           clisbam  WITH(NOLOCK)      
                    WHERE  clidpam.clidpa_clisba_id     = clisbam.clisba_id       
                    AND    clisbam.clisba_crn_no        = @l_crn_no --CONVERT(NUMERIC,@@currstring_id)      
                    AND    clidpam.clidpa_deleted_ind  IN (0,4,8)      
                      )      
             OR EXISTS(SELECT clidpa_id       
                       FROM   client_dp_accts_mak            clidpam  WITH(NOLOCK)      
                             ,client_sub_accts               clisba  WITH(NOLOCK)      
                       WHERE  clidpam.clidpa_clisba_id     = clisba.clisba_id       
                       AND    clisba.clisba_crn_no         = @l_crn_no --CONVERT(NUMERIC,@@currstring_id)      
                       AND    clidpam.clidpa_deleted_ind  IN (0,4,8)      
                      )                
          BEGIN      
          --      
            PRINT 'CLIENT_DP_ACCTS'      
            PRINT CONVERT(VARCHAR,GETDATE(),109)      
            SET    @@c_clidpa               = CURSOR fast_forward FOR      
            /*SELECT clidpa_id       
            FROM   client_dp_accts_mak            clidpam WITH(NOLOCK)      
                  ,client_sub_accts_mak           clisbam WITH(NOLOCK)      
            WHERE  clidpam.clidpa_clisba_id     = clisbam.clisba_id       
            AND    clisbam.clisba_crn_no        = @l_crn_no      
            AND    clidpam.clidpa_deleted_ind  IN (0,4,8)      
            */      
            SELECT clidpa_id       
            FROM   client_dp_accts_mak            clidpam WITH(NOLOCK)      
                  ,client_sub_accts               clisba  WITH(NOLOCK)      
            WHERE  clidpam.clidpa_clisba_id     = clisba.clisba_id       
            AND    clisba.clisba_crn_no         = @l_crn_no      
            AND    clidpam.clidpa_deleted_ind  IN (0,4,8)      
            --      
            OPEN @@c_clidpa      
            FETCH NEXT FROM @@c_clidpa INTO @c_clidpa_id      
            --      
            WHILE @@fetch_status = 0      
            BEGIN      
            --      
              SET @l_clidpa_id = @l_clidpa_id + CONVERT(VARCHAR,@c_clidpa_id)+@rowdelimiter      
      
              FETCH NEXT FROM @@c_clidpa INTO @c_clidpa_id      
            --      
            END      
            CLOSE      @@c_clidpa      
            DEALLOCATE @@c_clidpa      
            --      
            IF ISNULL(@l_clidpa_id,'') <> ''      
            BEGIN      
            --      
              EXEC pr_ins_upd_clidpa @l_clidpa_id,@pa_action,@pa_login_name, @l_crn_no,'',1,@rowdelimiter,@coldelimiter,@pa_msg = @l_error      
              --print ''      
            --      
            END      
            --       
            PRINT CONVERT(VARCHAR,GETDATE(),109)      
            --      
            IF CONVERT(NUMERIC,@l_error) > 0      
            BEGIN      
            --      
              ROLLBACK TRANSACTION      
              PRINT 'ROLLBACK TRANSACTION'       
              PRINT CONVERT(VARCHAR,GETDATE(),109)      
      
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
           PRINT 'ENTR'      
           PRINT CONVERT(VARCHAR,GETDATE(),109)      
           SET    @@c_entr                 = CURSOR fast_forward FOR      
           SELECT entr_id       
           FROM   entity_relationship_mak  WITH(NOLOCK)      
           WHERE  entr_deleted_ind         IN (0,4,8)      
           AND    entr_crn_no              = @l_crn_no --CONVERT(NUMERIC,@@currstring_id)      
           and    (entr_acct_no  in (select clia_acct_no from client_accounts_mak where clia_crn_no = @l_crn_no)  
           OR     entr_acct_no  in (select clia_acct_no from client_accounts where clia_crn_no = @l_crn_no))  
           --        
           OPEN @@c_entr      
           FETCH NEXT FROM @@c_entr INTO @c_entr_id      
           --      
           WHILE @@fetch_status = 0      
           BEGIN      
           --      
             SET @l_entr_id = @l_entr_id + CONVERT(VARCHAR, @c_entr_id)+@rowdelimiter      
      
             FETCH NEXT FROM @@c_entr INTO @c_entr_id      
           --      
           END      
           CLOSE      @@c_entr      
           DEALLOCATE @@c_entr      
           ---      
           IF ISNULL(@l_entr_id,'') <> ''      
           BEGIN      
           --      
             EXEC pr_ins_upd_entr @l_entr_id,@pa_action,@pa_login_name, @l_crn_no,'',1,@rowdelimiter,@coldelimiter,@pa_msg = @l_error      
             --print ''      
           --      
           END      
           PRINT CONVERT(VARCHAR,GETDATE(),109)      
      
        IF CONVERT(NUMERIC,@l_error) > 0      
           BEGIN      
           --      
             ROLLBACK TRANSACTION      
              PRINT 'ROLLBACK TRANSACTION'       
              PRINT CONVERT(VARCHAR,GETDATE(),109)      
      
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
           PRINT 'CLIENT DOCUMENTS'      
           PRINT CONVERT(VARCHAR,GETDATE(),109)      
           SET    @@c_clid                 = CURSOR fast_forward FOR      
           SELECT DISTINCT clid_id       
           FROM   client_documents_mak    WITH(NOLOCK)   
                , document_mstr           WITH(NOLOCK)     
           WHERE  clid_deleted_ind        IN (0,4,8)      
           AND    clid_crn_no              = @l_crn_no --CONVERT(NUMERIC,@@currstring_id)      
           AND    clid_docm_doc_id         = docm_doc_id   
           AND    (docm_excpm_id in (select clisba_excpm_id from client_sub_accts where clisba_crn_no = @l_crn_no AND clisba_deleted_ind =1 )  
     OR     docm_excpm_id in (select clisba_excpm_id from client_sub_accts_mak where clisba_crn_no = @l_crn_no AND clisba_deleted_ind in (0,4,8)))  
           --       
           OPEN @@c_clid      
           FETCH NEXT FROM @@c_clid INTO @c_clid_id      
           --      
           WHILE @@fetch_status = 0      
           BEGIN      
           --      
             SET @l_clid_id = @l_clid_id + CONVERT(VARCHAR, @c_clid_id)+@rowdelimiter      
             --       
             FETCH NEXT FROM @@c_clid INTO @c_clid_id      
           --      
           END      
           CLOSE      @@c_clid      
           DEALLOCATE @@c_clid      
           ---      
           IF isnull(@l_clid_id,'') <> ''      
           BEGIN      
           --      
             EXEC pr_ins_upd_clid @l_clid_id,@pa_action,@pa_login_name, @l_crn_no,'',1,@rowdelimiter,@coldelimiter,@pa_msg = @l_error                   --print ''      
           --      
           END      
           --      
           PRINT CONVERT(VARCHAR,GETDATE(),109)      
           IF CONVERT(NUMERIC,@l_error) > 0      
           BEGIN      
           --      
             ROLLBACK TRANSACTION      
              PRINT 'ROLLBACK TRANSACTION'       
              PRINT CONVERT(VARCHAR,GETDATE(),109)      
      
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
           PRINT 'ACCOUNT DOCUMENTS'      
           PRINT CONVERT(VARCHAR,GETDATE(),109)      
           SET    @@c_accd                   = CURSOR fast_forward FOR      
           SELECT DISTINCT accd_id       
           FROM   accd_mak                     accdmak   WITH(NOLOCK)      
                , client_sub_accts             clisba    WITH(NOLOCK)      
           WHERE  accdmak.accd_clisba_id     = clisba.clisba_id      
           AND    clisba.clisba_crn_no       = @l_crn_no --CONVERT(NUMERIC,@@currstring_id)      
           AND    accdmak.accd_deleted_ind  IN (0,4,8)      
           AND    clisba.clisba_deleted_ind  = 1      
           --       
           OPEN @@c_accd      
           FETCH NEXT FROM @@c_accd INTO @c_accd_id      
           --      
           WHILE @@fetch_status = 0      
           BEGIN      
           --      
             SET @l_accd_id = @l_accd_id + CONVERT(VARCHAR, @c_accd_id)+@rowdelimiter      
             --        
      
             FETCH NEXT FROM @@c_accd INTO @c_accd_id      
           --      
           END      
           CLOSE      @@c_accd      
           DEALLOCATE @@c_accd      
           ---      
           IF isnull(@l_accd_id,'') <> ''      
           BEGIN      
           --      
             EXEC pr_ins_upd_accd @l_accd_id,@pa_action,@pa_login_name, @l_crn_no,'','','',1,@rowdelimiter,@coldelimiter,@pa_msg = @l_error      
             --print ''      
           --      
           END      
      
           PRINT CONVERT(VARCHAR,GETDATE(),109)      
           IF CONVERT(NUMERIC,@l_error) > 0      
           BEGIN      
           --      
             ROLLBACK TRANSACTION      
             PRINT 'ROLLBACK TRANSACTION'       
             PRINT CONVERT(VARCHAR,GETDATE(),109)      
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
                   union
                   SELECT entp_id
                   FROM   entity_properties  WITH(NOLOCK)        
                   WHERE  entp_ent_id       = @l_crn_no --CONVERT(NUMERIC,@@currstring_id)         
                   AND    entp_deleted_ind  = 1         
                   )        
         BEGIN        
         --        
           PRINT 'ENTITY PROPERTY'        
           PRINT CONVERT(VARCHAR,GETDATE(),109)        
        
           SET    @@c_entp                 = CURSOR fast_forward FOR        
           SELECT DISTINCT entpmak_id         
           FROM   entity_properties_mak    WITH(NOLOCK)     
           ,entity_property_mstr     WITH(NOLOCK)       
           WHERE  entp_deleted_ind         IN (0,4,8)        
           AND    entp_ent_id              = @l_crn_no --CONVERT(NUMERIC,@@currstring_id)        
           AND    entp_entpm_prop_id       = entpm_prop_id     
           AND    (entpm_excpm_id in (select clisba_excpm_id from client_sub_accts where clisba_crn_no = @l_crn_no AND clisba_deleted_ind =1 )    
           OR     entpm_excpm_id in (select clisba_excpm_id from client_sub_accts_mak where clisba_crn_no = @l_crn_no AND clisba_deleted_ind in (0,4,8)))    
           union
           SELECT DISTINCT entp_id         
           FROM   entity_properties    WITH(NOLOCK)     
                 ,entity_property_mstr     WITH(NOLOCK)     
                 ,entity_property_dtls_mak  WITH(NOLOCK)     
           WHERE  entp_deleted_ind         = 1 
           AND    entp_ent_id              = @l_crn_no --CONVERT(NUMERIC,@@currstring_id)        
           AND    entp_entpm_prop_id       = entpm_prop_id     
           and    entpd_entp_id            = entp_id 
           and    entpd_deleted_ind  in (0,4,8)  
           AND    (entpm_excpm_id in (select clisba_excpm_id from client_sub_accts where clisba_crn_no = @l_crn_no AND clisba_deleted_ind =1 )    
           OR     entpm_excpm_id in (select clisba_excpm_id from client_sub_accts_mak where clisba_crn_no = @l_crn_no AND clisba_deleted_ind in (0,4,8)))    

           OPEN @@c_entp        
           FETCH NEXT FROM @@c_entp INTO @c_entpmak_id        
           --        
           WHILE @@fetch_status = 0        
           BEGIN        
           --        
             SET @l_entpmak_id = @l_entpmak_id + CONVERT(VARCHAR, @c_entpmak_id)+@rowdelimiter        
        
             FETCH NEXT FROM @@c_entp INTO @c_entpmak_id        
           --        
           END        
           CLOSE      @@c_entp        
           DEALLOCATE @@c_entp        
           ---        
           IF ISNULL(@l_entpmak_id,'') <> ''        
           BEGIN        
           --        
             print @l_entpmak_id
             EXEC pr_ins_upd_entp @l_entpmak_id,@pa_action,@pa_login_name, @l_crn_no,'','','',1,@rowdelimiter,@coldelimiter,@pa_msg = @l_error        
             --print ''        
           --        
           END        
           PRINT CONVERT(VARCHAR,GETDATE(),109)        
        
           IF CONVERT(NUMERIC,@l_error) > 0        
           BEGIN        
           --        
             ROLLBACK TRANSACTION        
             PRINT 'ROLLBACK TRANSACTION'         
             PRINT CONVERT(VARCHAR,GETDATE(),109)        
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
           PRINT 'ACCOUNT PROPERTIES'      
           PRINT CONVERT(VARCHAR,GETDATE(),109)      
           SET    @@c_accp                   = CURSOR fast_forward FOR      
           SELECT DISTINCT accpmak_id       
      FROM   accp_mak                     accpmak   WITH(NOLOCK)      
                , client_sub_accts             clisba    WITH(NOLOCK)      
           WHERE  accpmak.accp_clisba_id     = clisba.clisba_id      
           AND    clisba.clisba_crn_no       = @l_crn_no --CONVERT(NUMERIC,@@currstring_id)      
           AND    accpmak.accp_deleted_ind   IN (0,4,8)      
           AND    clisba.clisba_deleted_ind  = 1      
           --      
           OPEN @@c_accp      
           FETCH NEXT FROM @@c_accp INTO @c_accpmak_id      
           --      
           WHILE @@fetch_status = 0      
           BEGIN      
           --      
             SET @l_accpmak_id = @l_accpmak_id + CONVERT(VARCHAR, @c_accpmak_id)+@rowdelimiter      
             --       
             FETCH NEXT FROM @@c_accp INTO @c_accpmak_id      
           --      
           END      
           CLOSE      @@c_accp      
           DEALLOCATE @@c_accp      
           ---      
           IF ISNULL(@l_accpmak_id, '') <> ''      
           BEGIN      
           --      
             --print ''      
             EXEC pr_ins_upd_accp @l_accpmak_id,@pa_action,@pa_login_name, @l_crn_no,'','','','',1,@rowdelimiter,@coldelimiter,@pa_msg = @l_error      
             --      
           END      
           PRINT CONVERT(VARCHAR,GETDATE(),109)      
      
           IF CONVERT(NUMERIC,@l_error) > 0      
           BEGIN      
           --      
             ROLLBACK TRANSACTION      
             PRINT 'ROLLBACK TRANSACTION'       
             PRINT CONVERT(VARCHAR,GETDATE(),109)      
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
         PRINT 'COMMIT TRANSACTION'      
        --      
        END      
      --      
      END      
    --      
    END      
    ELSE IF @pa_app_sba <> ''       
    BEGIN      
    --      
      exec pr_app_client_sub @pa_id ,@pa_app_sba ,@pa_action ,@pa_login_name ,@pa_values ,@pa_chk_yn ,@rowdelimiter ,@coldelimiter,@pa_msg output       
    --      
    END      
          
  --      
  END

GO
