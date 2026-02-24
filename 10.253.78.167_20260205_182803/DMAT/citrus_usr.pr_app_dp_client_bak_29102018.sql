-- Object: PROCEDURE citrus_usr.pr_app_dp_client_bak_29102018
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

--SELECT * FROM CLIENT_MSTR WHERE CLIM_CRN_NO =56252
--BEGIN TRANSACTION  
--pr_app_dp_client '358204|*~|*|~*','','APP','head','0',1,'*|~*','|*~|',''  
--select * from client_list
--select * from accp_mak
--SELECT * FROM ACCPD_MAK
--SELECT * FROM ACCOUNT_PROPERTIES ORDER BY ACCP_CREATED_DT DESC
--COMMIT transaction
--rollback
/*SELECT *   
                    FROM   addr_acct_mak   WITH(NOLOCK)  
                         , dp_acct_mstr    WITH(NOLOCK)  
                    WHERE  adr_deleted_ind IN (0,4,8)   
                    AND    adr_clisba_id =dpam_id  --CONVERT(NUMERIC,@@currstring_id)  
                    AND    dpam_crn_no = 55126 */

create PROCEDURE [citrus_usr].[pr_app_dp_client_bak_29102018](@pa_id                VARCHAR(8000)  
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
 MODULE NAME    : pr_app_dp_client  
 DESCRIPTION    : This procedure will app client and entity  
 COPYRIGHT(C)   : MArketPlace Technologies Pvt. Ltd.  
 VERSION HISTORY:  
 VERS.  AUTHOR             DATE        REASON  
 -----  -------------      ----------  -------------------------------------------------  
 1.0    TUSHAR             24-AUG-2007 INITIAL VERSION.  
--------------------------------------------------------------------------------------*/  
  
BEGIN  
--  
  IF @pa_app_sba = ''  
  BEGIN  
  --  
    DECLARE @c_clim                 CURSOR  
           ,@c_dpam                 CURSOR  
           ,@c_addr                 CURSOR   
           ,@c_entr                 CURSOR  
           ,@c_dphd                 CURSOR  
           ,@c_conc                 CURSOR  
           ,@c_cliba                CURSOR  
           ,@c_clidpa               CURSOR  
           ,@c_entp                 CURSOR  
           ,@c_entpd                CURSOR  
           ,@c_accp                 CURSOR  
           ,@c_accpd                CURSOR  
           ,@c_clid                 CURSOR  
           ,@c_accd                 CURSOR  
           ,@l_dpam_id              VARCHAR(8000)  
           ,@l_clid_id              VARCHAR(8000)  
           ,@c_dpam_id              NUMERIC    
           ,@c_clid_id              NUMERIC  
           ,@c_accd_id              NUMERIC  
           ,@l_accd_id              VARCHAR(8000)  
           ,@c_dphdmak_id           NUMERIC  
           ,@l_dphdmak_id           VARCHAR(8000)    
           ,@c_clim_id              NUMERIC    
           ,@l_clim_id              VARCHAR(8000)  
           ,@c_adrm_id              NUMERIC    
           ,@l_adrm_id              VARCHAR(8000)  
           ,@c_concmak_id           NUMERIC    
           ,@l_concmak_id           VARCHAR(8000)  
           ,@c_cliba_id             NUMERIC    
           ,@l_cliba_id             VARCHAR(8000)  
           ,@l_clidpa_id            VARCHAR(8000)  
           ,@c_clidpa_id            NUMERIC    
           ,@l_entpmak_id           VARCHAR(8000)  
           ,@c_entpmak_id           NUMERIC  
           ,@l_entpd_id             VARCHAR(8000)  
           ,@c_entpd_id             NUMERIC  
           ,@l_accpmak_id           VARCHAR(8000)  
           ,@c_accpmak_id           NUMERIC  
           ,@l_entr_id              VARCHAR(8000)  
           ,@c_entr_id              NUMERIC  
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
             ,@c_dppd                 cursor  
           ,@l_dppd_id              varchar(8000)  
           ,@c_dppd_id              numeric 
           ,@c_addr_acct           cursor
           ,@c_adrm_acct_id        numeric
           ,@l_adrm_acct_id        varchar(8000)
           ,@c_conc_acct           cursor
           ,@c_conc_acct_id        numeric
           ,@l_conc_acct_id        varchar(8000)
               declare @l_mod_crn varchar(50),@l_dpam_sba_no varchar(16)
               
               set @l_mod_crn=''
    --      
      
      
    SET @l_clim_id           = ''  
    SET @l_dpam_id           = ''  
    SET @l_adrm_acct_id           = ''  
    SET @l_conc_acct_id           = ''  
    SET @l_adrm_id           = ''  
    SET @l_concmak_id        = ''  
    SET @l_cliba_id          = ''  
    SET @l_clidpa_id         = ''  
    SET @l_clid_id           = ''   
    SET @l_entpmak_id        = ''   
    SET @l_entpd_id          = ''   
    SET @l_accpmak_id        = ''   
    SET @l_accpd_id          = ''   
    SET @l_accd_id           = ''  
    SET @l_entr_id           = ''  
    SET @l_dphdmak_id        = ''  
    SET @l_dppd_id           = ''  
    SET @delimeter_id        = '%'+ @rowdelimiter + '%'  
    SET @@delimeterlength_id = LEN(@rowdelimiter)  
    SET @@remainingstring_id = @pa_id  
    --  
    WHILE @@remainingstring_id <> ''  
    BEGIN  
    --  
      SET @@foundat =  0  
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
            
            
            SET @c_clim               =  CURSOR fast_forward FOR  
            SELECT clim_id     
            FROM   client_mstr_mak    WITH(NOLOCK)  
            WHERE  clim_deleted_ind   IN(0,4,8)  
            AND    clim_crn_no        = @l_crn_no --CONVERT(VARCHAR,@@currstring_id)  
            --  
            OPEN @c_clim  
            --  
            FETCH NEXT FROM @c_clim INTO @c_clim_id        
            --  
            WHILE @@fetch_status = 0  
            BEGIN  
            --  
              SET @l_clim_id = @l_clim_id+CONVERT(varchar,@c_clim_id)+@coldelimiter+ISNULL(CONVERT(varchar,@l_rmks),'')+@coldelimiter+@rowdelimiter  
              --  
              FETCH NEXT FROM @c_clim INTO @l_clim_id  
            --  
            END  
            --  
            CLOSE      @c_clim  
            DEALLOCATE @c_clim  
            --   
            IF ISNULL(@l_clim_id,'') <> ''  
            BEGIN  
            --  
              --print ''  
              insert into applog
              select @l_crn_no,'Start' ,GETDATE()
              EXEC pr_ins_upd_clim @l_clim_id ,@pa_action, @pa_login_name, @l_clim_id, 1, @rowdelimiter, @coldelimiter, @pa_output = @l_error, @pa_msg = @l_error1  
              insert into applog
              select @l_crn_no,'pr_ins_upd_clim' ,GETDATE()
              IF @l_error = '' SET @l_error =  '0' 
              SET @l_clim_id = '' 
--              print getdate()
              --SELECT * FROM CLIENT_MSTR WHERE CLIM_CRN_NO = 650  
            --    
            END   
            
            --print @l_clim_id + ' pr_ins_upd_clim client master'  
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

          IF EXISTS(SELECT dpam_crn_no   
                    FROM   dp_acct_mstr_mak WITH(NOLOCK)   
                    WHERE  dpam_deleted_ind IN (0,4,8)   
                    AND    dpam_crn_no      = @l_crn_no --CONVERT(NUMERIC,@@currstring_id)  
                   )  
          BEGIN  
          --  
            
            
            SET @c_dpam               =  CURSOR fast_forward FOR  
            SELECT dpam_id  
            FROM   dp_acct_mstr_mak   WITH(NOLOCK)  
            WHERE  dpam_deleted_ind   IN(0,4,8)  
            AND    dpam_crn_no         = @l_crn_no --CONVERT(VARCHAR,@@currstring_id)  
            --  
            OPEN @c_dpam  
            --  
            FETCH NEXT FROM @c_dpam INTO @c_dpam_id        
            --  
            WHILE @@fetch_status = 0  
            BEGIN  
            --  
              SET @l_dpam_id = @l_dpam_id + CONVERT(varchar,@c_dpam_id)+@rowdelimiter  
              --  
              FETCH NEXT FROM @c_dpam INTO @c_dpam_id  
            --  
            END  
            --  
            CLOSE      @c_dpam  
            DEALLOCATE @c_dpam  
            --   
            IF ISNULL(@l_dpam_id,'') <> ''  
            BEGIN  
            --  
              EXEC pr_ins_upd_dpam @l_dpam_id ,@pa_action, @pa_login_name, 0, @l_dpam_id, 1, @rowdelimiter, @coldelimiter, @pa_msg = @l_error  
              insert into applog
              select @l_crn_no,'pr_ins_upd_dpam' ,GETDATE()
              --EXEC pr_ins_upd_client_brkg @l_dpam_id ,@pa_action, @pa_login_name, 0, '', 1, @rowdelimiter, @coldelimiter, @pa_msg = @l_error  
              IF @l_error = '' SET @l_error =  '0'  
              --SELECT * FROM DP_ACCT_MSTR WHERE DPAM_CRN_NO = 650  
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
              EXEC pr_ins_upd_list @l_crn_no,'A','dp acct mstr',@pa_login_name,'*|~*','|*~|',''   
            --  
            END  
          --  
          END  
          IF EXISTS( SELECT dpam_id  
            FROM   CLIB_MAK, DP_aCCT_MSTR    WITH(NOLOCK)  
            WHERE  CLIDB_DPAM_ID = DPAM_ID
            AND    CLIDB_deleted_ind   IN(0,4,8)  
            AND    dpam_crn_no         = @l_crn_no --CONVERT(NUMERIC,@@currstring_id)  
                   )  
          BEGIN  
          --  
            --PRINT 'DP ACCT MSTR'    
            --PRINT CONVERT(VARCHAR,GETDATE(),109)  
            SET @c_dpam               =  CURSOR fast_forward FOR  
            SELECT dpam_id  
            FROM   CLIB_MAK, DP_aCCT_MSTR    WITH(NOLOCK)  
            WHERE  CLIDB_DPAM_ID = DPAM_ID
            AND    CLIDB_deleted_ind   IN(0,4,8)  
            AND    dpam_crn_no         = @l_crn_no --CONVERT(VARCHAR,@@currstring_id)  
            --  
            OPEN @c_dpam  
            --  
            FETCH NEXT FROM @c_dpam INTO @c_dpam_id        
            --  
            WHILE @@fetch_status = 0  
            BEGIN  
            --  
              SET @l_dpam_id = @l_dpam_id + CONVERT(varchar,@c_dpam_id)+@rowdelimiter  
              --  
              FETCH NEXT FROM @c_dpam INTO @c_dpam_id  
            --  
            END  
            --  
            CLOSE      @c_dpam  
            DEALLOCATE @c_dpam  
            --   
            IF ISNULL(@l_dpam_id,'') <> ''  
            BEGIN  
            --  
              EXEC pr_ins_upd_client_brkg @l_dpam_id ,@pa_action, @pa_login_name, 0, '', 1, @rowdelimiter, @coldelimiter, @pa_msg = @l_error  IF @l_error = '' SET @l_error =  '0'  
               insert into applog
              select @l_crn_no,'pr_ins_upd_client_brkg' ,GETDATE()
              --SELECT * FROM DP_ACCT_MSTR WHERE DPAM_CRN_NO = 650  
            --    
            END   
--            PRINT CONVERT(VARCHAR,GETDATE(),109)   
            --  
            IF CONVERT(NUMERIC,@l_error1) > 0  
            BEGIN  
            --  
              ROLLBACK TRANSACTION  
              --PRINT 'ROLLBACK TRANSACTION'   
              --PRINT CONVERT(VARCHAR,GETDATE(),109)  
              --               
              CONTINUE  
            --  
            END  
            ELSE  
            BEGIN  
            --  
              EXEC pr_ins_upd_list @l_crn_no,'A','dp acct mstr',@pa_login_name,'*|~*','|*~|',''   
              
            --  
            END  
          --  
          END


         IF EXISTS(SELECT adr_ent_id   
                    FROM   addresses_mak   WITH(NOLOCK)  
                    WHERE  adr_deleted_ind IN (0,4,8)   
                    AND    adr_ent_id = @l_crn_no --CONVERT(NUMERIC,@@currstring_id)  
                   )  
          BEGIN  
          --  
            
            
            SET @c_addr               = CURSOR fast_forward FOR  
            SELECT adrm_id  
            FROM   addresses_mak       WITH(NOLOCK)   
            WHERE  adr_deleted_ind     IN(0,4,8)  
            AND    adr_ent_id          = @l_crn_no --CONVERT(NUMERIC,@@currstring_id)  
            --    
            OPEN @c_addr  
            FETCH NEXT FROM @c_addr INTO @c_adrm_id  
            --  
            WHILE @@fetch_status = 0  
            BEGIN  
            --  
              SET @l_adrm_id = @l_adrm_id+CONVERT(VARCHAR,@c_adrm_id)+@rowdelimiter  
              --  
              FETCH NEXT FROM @c_addr INTO @c_adrm_id  
            --  
            END  
            CLOSE      @c_addr  
            DEALLOCATE @c_addr  
            --    
            IF ISNULL(@l_adrm_id,'') <> ''  
            BEGIN  
            --  
              EXEC pr_ins_upd_addr @l_adrm_id ,@pa_action, @pa_login_name, @l_crn_no,'','|*~|', 1, @rowdelimiter, @coldelimiter, @pa_msg = @l_error   
                insert into applog
              select @l_crn_no,'pr_ins_upd_addr' ,GETDATE()
              --SELECT * FROM ENTITY_ADR_CONC WHERE ENTAC_ENT_ID  = 650  
              IF @l_error = '' SET @l_error =  '0'  
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
          IF EXISTS(SELECT adr_clisba_id   
                    FROM   addr_acct_mak   WITH(NOLOCK)  
                         , dp_acct_mstr    WITH(NOLOCK)  
                    WHERE  adr_deleted_ind IN (0,4,8)   
                    AND    adr_clisba_id =dpam_id  --CONVERT(NUMERIC,@@currstring_id)  
                    AND    dpam_crn_no = @l_crn_no
                   )  
          BEGIN  
          --  
            
            
            SET @c_addr_acct               = CURSOR fast_forward FOR  
            SELECT adrm_id   
            FROM   addr_acct_mak   WITH(NOLOCK)  
                 , dp_acct_mstr    WITH(NOLOCK)  
            WHERE  adr_deleted_ind IN (0,4,8)   
            AND    adr_clisba_id =dpam_id  --CONVERT(NUMERIC,@@currstring_id)  
            AND    dpam_crn_no = @l_crn_no --CONVERT(NUMERIC,@@currstring_id)  
            AND    isnull(adr_1,'') <> ''
            --    
            OPEN @c_addr_acct  
            FETCH NEXT FROM @c_addr_acct INTO @c_adrm_acct_id  
            --  
            WHILE @@fetch_status = 0  
            BEGIN  
            --  
              SET @l_adrm_acct_id = @l_adrm_acct_id+CONVERT(VARCHAR,@c_adrm_acct_id)+@rowdelimiter  
              --  
              FETCH NEXT FROM @c_addr_acct INTO @c_adrm_acct_id  
            --  
            END  
            CLOSE      @c_addr_acct  
            DEALLOCATE @c_addr_acct  
            --    
            IF ISNULL(@l_adrm_acct_id,'') <> ''  
            BEGIN  
            -- 
              
              
              EXEC pr_dp_ins_upd_addr @l_adrm_acct_id ,@pa_action, @pa_login_name, @l_crn_no,'','','|*~|', 1, @rowdelimiter, @coldelimiter, @pa_msg = @l_error   
                 insert into applog
              select @l_crn_no,'pr_dp_ins_upd_addr' ,GETDATE()
              IF @l_error = '' SET @l_error =  '0'  
              --SELECT * FROM ENTITY_ADR_CONC WHERE ENTAC_ENT_ID  = 650  
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
          IF EXISTS(SELECT concmak_id   
                    FROM   conc_acct_mak   WITH(NOLOCK)  
                         , dp_acct_mstr    WITH(NOLOCK)  
                    WHERE  conc_deleted_ind IN (0,4,8)   
                    AND    conc_clisba_id =dpam_id  --CONVERT(NUMERIC,@@currstring_id)  
                    AND    dpam_crn_no = @l_crn_no
                   )  
          BEGIN  
          --  
            
            
            SET @c_conc_acct               = CURSOR fast_forward FOR  
            SELECT concmak_id   
            FROM   conc_acct_mak   WITH(NOLOCK)  
                 , dp_acct_mstr    WITH(NOLOCK)  
            WHERE  conc_deleted_ind IN (0,4,8)   
            AND    conc_clisba_id =dpam_id  --CONVERT(NUMERIC,@@currstring_id)  
            AND    dpam_crn_no = @l_crn_no and conc_value <>'' --CONVERT(NUMERIC,@@currstring_id)  
            --    
            OPEN @c_conc_acct  
            FETCH NEXT FROM @c_conc_acct INTO @c_conc_acct_id  
            --  
            WHILE @@fetch_status = 0  
            BEGIN  
            --  
              
              SET @l_conc_acct_id = @l_conc_acct_id+CONVERT(VARCHAR,@c_conc_acct_id)+@rowdelimiter  
              --  
              FETCH NEXT FROM @c_conc_acct INTO @c_conc_acct_id  
            --  
            END  
            CLOSE      @c_conc_acct  
            DEALLOCATE @c_conc_acct  
            --    
            IF ISNULL(@l_conc_acct_id,'') <> ''  
            BEGIN  
            -- 
              
--              print @l_conc_acct_id
              EXEC pr_dp_ins_upd_conc @l_conc_acct_id ,@pa_action, @pa_login_name, @l_crn_no,'','','|*~|', 1, @rowdelimiter, @coldelimiter, @pa_msg = @l_error   
                 insert into applog
              select @l_crn_no,'pr_dp_ins_upd_conc' ,GETDATE()
              IF @l_error = '' SET @l_error =  '0'  
              
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
                    AND    conc_ent_id        = @l_crn_no --CONVERT(NUMERIC,@@currstring_id)  
                   )  
          BEGIN  
          --  

            
            SET    @c_conc               = CURSOR fast_forward FOR  
            SELECT concmak_id  
            FROM   contact_channels_mak   WITH(NOLOCK)  
            WHERE  conc_deleted_ind       IN(0,4,8)  
            AND    conc_ent_id            = @l_crn_no --CONVERT(NUMERIC,@@currstring_id)  
            --    
            OPEN @c_conc  
            --  
            FETCH NEXT FROM @c_conc INTO @c_concmak_id  
            --  
            WHILE @@fetch_status = 0  
            BEGIN  
            --  
              SET @l_concmak_id = @l_concmak_id+CONVERT(VARCHAR,@c_concmak_id)+@rowdelimiter  
              --   
              FETCH NEXT FROM @c_conc INTO @c_concmak_id  
            --  
            END  
            CLOSE      @c_conc  
            DEALLOCATE @c_conc  
            --  
            IF ISNULL(@l_concmak_id,'') <> ''  
            BEGIN  
            --  
--            PRINT 'PANKAJ'
  --          PRINT @l_concmak_id
    --        PRINT @l_crn_no
      --      PRINT @l_error
         --   PRINT @pa_action
            PRINT 'yogesh'
              EXEC pr_ins_upd_conc @l_concmak_id ,@pa_action, @pa_login_name, @l_crn_no,'','|*~|', 1, @rowdelimiter, @coldelimiter, @pa_msg = @l_error  
                insert into applog
              select @l_crn_no,'pr_ins_upd_conc' ,GETDATE()
              IF @l_error = '' SET @l_error =  '0'  
              --SELECT * FROM ENTITY_ADR_CONC WHERE ENTAC_ENT_ID  = 650  
            --  
            END  
            --  
            
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
          IF EXISTS(SELECT dphdmak_id  
                    FROM   dp_holder_dtls_mak WITH(NOLOCK)   
                          ,dp_acct_mstr       WITH(NOLOCK)    
                    WHERE  dphd_deleted_ind   IN (0,4,8)   
                    AND    dphd_dpam_id        = dpam_id   
                    AND    dpam_crn_no         = @l_crn_no --CONVERT(NUMERIC,@@currstring_id)  
                   )  
          BEGIN  
          --  
            
            
            SET    @c_dphd               = CURSOR fast_forward FOR  
            SELECT dphdmak_id  
            FROM   dp_holder_dtls_mak WITH(NOLOCK)   
                  ,dp_acct_mstr       WITH(NOLOCK)    
            WHERE  dphd_deleted_ind   IN (0,4,8)   
            AND    dphd_dpam_id        = dpam_id   
            AND    dpam_crn_no         = @l_crn_no--CONVERT(NUMERIC,@@currstring_id)  
            --    
            OPEN @c_dphd  
            --  
            FETCH NEXT FROM @c_dphd INTO @c_dphdmak_id  
            --  
            WHILE @@fetch_status = 0  
            BEGIN  
            --  
              SET @l_dphdmak_id = @l_dphdmak_id+CONVERT(VARCHAR,@c_dphdmak_id)+@rowdelimiter  
              --   
              FETCH NEXT FROM @c_dphd INTO @c_dphdmak_id  
            --  
            END  
            CLOSE      @c_dphd  
            DEALLOCATE @c_dphd  
            --  
            IF ISNULL(@l_dphdmak_id,'') <> ''  
            BEGIN  
            --  
              EXEC pr_ins_upd_dphd @l_dphdmak_id, @l_crn_no ,'',@pa_action, @pa_login_name,'','','','','','', 1, @rowdelimiter, @coldelimiter, @pa_msg = @l_error  
               insert into applog
              select @l_crn_no,'pr_ins_upd_dphd' ,GETDATE()
              IF @l_error = '' SET @l_error =  '0'  
              --PRINT @l_dphdmak_id  
              --SELECT * FROM DP_HOLDER_DTLS WHERE DPHD_DPAM_ID IN (882,883)  
            --  
            END  
            --  
            
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
              EXEC pr_ins_upd_list @l_crn_no, 'A','dp holder dtls', @pa_login_name,'*|~*','|*~|',''  
            --  
            END  
          --  
          END  
--SELECT dppd_id  
--                    FROM   dp_poa_dtls_mak    WITH(NOLOCK)   
--                          ,dp_acct_mstr  dpam     WITH(NOLOCK)    
--                    WHERE  dppd_deleted_ind   IN (0,4,8)   
--                    AND    dppd_dpam_id        = dpam.dpam_id   

--                    AND    dpam_crn_no         = @l_crn_no
          IF EXISTS(SELECT dppd_id  
                    FROM   dp_poa_dtls_mak    WITH(NOLOCK)   
                          ,dp_acct_mstr  dpam     WITH(NOLOCK)    
                    WHERE  dppd_deleted_ind   IN (0,4,8)   
                    AND    dppd_dpam_id        = dpam.dpam_id   
                    AND    dpam_crn_no         = @l_crn_no --CONVERT(NUMERIC,@@currstring_id)  
                   )  
          BEGIN  
          --  
            
            
              
            SET    @c_dppd               = CURSOR fast_forward FOR  
            SELECT dppd_id  
            FROM   dp_poa_dtls_mak    WITH(NOLOCK)   
                  ,dp_acct_mstr  dpam     WITH(NOLOCK)    
            WHERE  dppd_deleted_ind   IN (0,4,8)   
            AND    dppd_dpam_id        = dpam.dpam_id   
            AND    dpam_crn_no         = @l_crn_no--CONVERT(NUMERIC,@@currstring_id)  
            --    
            OPEN @c_dppd  
            --  
            FETCH NEXT FROM @c_dppd INTO @c_dppd_id  
            --  
            WHILE @@fetch_status = 0  
            BEGIN  
            --  
              SET @l_dppd_id = @l_dppd_id+CONVERT(VARCHAR,@c_dppd_id)+@rowdelimiter  
              --   
              FETCH NEXT FROM @c_dppd INTO @c_dppd_id  
            --  
            END  
            CLOSE      @c_dppd  
            DEALLOCATE @c_dppd  
            --  
            IF ISNULL(@l_dppd_id,'') <> ''  
            BEGIN  
            --  
              
              --EXEC pr_ins_upd_dppd @l_dppd_id, @l_crn_no ,'',@pa_action, @pa_login_name,'','','','','','', 1, @rowdelimiter, @coldelimiter, @pa_msg = @l_error OUT  
--select * from dp_poa_dtls order by 1 desc
              EXEC pr_ins_upd_dppd @l_dppd_id,@l_crn_no,@pa_action,@pa_login_name,'', 1, @rowdelimiter, @coldelimiter, @pa_msg = @l_error OUT   
               insert into applog
              select @l_crn_no,'pr_ins_upd_dppd' ,GETDATE()
--select * from dp_poa_dtls order by 1 desc
              IF @l_error = '' SET @l_error =  '0'  
              --PRINT @l_dphdmak_id  
              --SELECT * FROM DP_HOLDER_DTLS WHERE DPHD_DPAM_ID IN (882,883)  
            --  
            END  
            --  
            
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
              EXEC pr_ins_upd_list @l_crn_no, 'A','dp poa dtls', @pa_login_name,'*|~*','|*~|',''  
            --  
            END  
          --  
          END  
          IF EXISTS(SELECT entr_id   
                    FROM   entity_relationship_mak  WITH(NOLOCK)  
                    WHERE  entr_crn_no       = @l_crn_no --CONVERT(NUMERIC,@@currstring_id)   
                    AND    entr_deleted_ind IN (0,4,8))  
          BEGIN  
          --  
            
            
            SET    @c_entr                 = CURSOR fast_forward FOR  
            SELECT entr_id   
            FROM   entity_relationship_mak  WITH(NOLOCK)  
            WHERE  entr_deleted_ind         IN (0,4,8)  
            AND    entr_crn_no              = @l_crn_no --CONVERT(NUMERIC,@@currstring_id)  
            and (entr_sba in (select dpam_sba_no from dp_acct_mstr_mak where dpam_crn_no = @l_crn_no and dpam_deleted_ind in (0,4,8))  
            or entr_sba in (select dpam_sba_no from dp_acct_mstr where dpam_crn_no = @l_crn_no and dpam_deleted_ind = 1 ))  
            --    
            OPEN @c_entr  
            FETCH NEXT FROM @c_entr INTO @c_entr_id  
            --  
            WHILE @@fetch_status = 0  
            BEGIN  
            --  
              SET @l_entr_id = @l_entr_id + CONVERT(VARCHAR, @c_entr_id)+@rowdelimiter  
  
              FETCH NEXT FROM @c_entr INTO @c_entr_id  
            --  
            END  
            CLOSE      @c_entr  
            DEALLOCATE @c_entr  
            ---  
            IF ISNULL(@l_entr_id,'') <> ''  
            BEGIN  
            --  
              EXEC pr_ins_upd_dpentr @l_entr_id,@pa_action,@pa_login_name, @l_crn_no,'',1,@rowdelimiter,@coldelimiter,@pa_msg = @l_error  
                 insert into applog
              select @l_crn_no,'pr_ins_upd_dpentr' ,GETDATE()
              IF @l_error = '' SET @l_error =  '0'  
              --SELECT * FROM ENTITY_RELATIONSHIP WHERE ENTR_CRN_NO = 650   
            --  
            END  
            
IF @l_error = '' SET @l_error =  '0'  
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
          IF EXISTS(SELECT cliba_id   
                    FROM   client_bank_accts_mak       clibam   WITH(NOLOCK)  
                         , dp_acct_mstr                dpam     WITH(NOLOCK)  
                    WHERE  clibam.cliba_clisba_id    = dpam.dpam_id  
                    AND    dpam.dpam_crn_no          = @l_crn_no --CONVERT(NUMERIC,@@currstring_id)  
                    AND    clibam.cliba_deleted_ind IN (0,4,8)  
                   ) OR  
             EXISTS(SELECT cliba_id   
                    FROM   client_bank_accts_mak       clibam   WITH(NOLOCK)  
                         , dp_acct_mstr_mak            dpam     WITH(NOLOCK)  
                    WHERE  clibam.cliba_clisba_id    = dpam.dpam_id  
                    AND    dpam.dpam_crn_no          = @l_crn_no --CONVERT(NUMERIC,@@currstring_id)  
                    AND    clibam.cliba_deleted_ind IN (0,4,8)  
                   )         
                     
          BEGIN  
          --  
            
            
            SET    @c_cliba                = CURSOR fast_forward FOR  
            SELECT cliba_id  
            FROM   client_bank_accts_mak      clibam  
                 , dp_acct_mstr               dpam  
            WHERE  clibam.cliba_clisba_id   = dpam.dpam_id   
            AND    dpam.dpam_crn_no         = @l_crn_no --CONVERT(NUMERIC,@@currstring_id)   
            AND    clibam.cliba_deleted_ind IN (0,4,8)  
  
            --   
            OPEN @c_cliba  
            FETCH NEXT FROM @c_cliba INTO @c_cliba_id  
            --  
            WHILE @@fetch_status = 0  
            BEGIN  
            --  
              SET @l_cliba_id = @l_cliba_id + CONVERT(VARCHAR,@c_cliba_id)+@rowdelimiter  
              --   
              FETCH NEXT FROM @c_cliba INTO @c_cliba_id  
            --  
            END  
            CLOSE      @c_cliba  
            DEALLOCATE @c_cliba  
            --  
            IF ISNULL(@l_cliba_id,'') <> ''  
            BEGIN  
            --  
              EXEC pr_ins_upd_cliba @l_cliba_id,@pa_action,@pa_login_name, @l_crn_no,'',1,@rowdelimiter,@coldelimiter,@pa_msg = @l_error  
               insert into applog
              select @l_crn_no,'pr_ins_upd_cliba' ,GETDATE()
              if @l_error = ''
              set  @l_error ='0'
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
            
          IF EXISTS(SELECT clid_id   
                    FROM   client_documents_mak  WITH(NOLOCK)  
                    WHERE  clid_crn_no       = @l_crn_no 
            --CONVERT(NUMERIC,@@currstring_id)  
                    AND    clid_deleted_ind IN (0,4,8))  
          BEGIN  
          --  
            
            
            SET    @c_clid                 = CURSOR fast_forward FOR  
            SELECT DISTINCT clid_id   
            FROM   client_documents_mak    WITH(NOLOCK)  
                 , document_mstr           WITH(NOLOCK)  
                 , excsm_prod_mstr         WITH(NOLOCK)  
            WHERE  clid_deleted_ind        IN (0,4,8)  
            AND    clid_crn_no              = @l_crn_no --CONVERT(NUMERIC,@@currstring_id)  
            AND    clid_docm_doc_id        = docm_doc_id--CONVERT(NUMERIC,@@currstring_id)  
            AND    docm_excpm_id             = excpm_id --CONVERT(NUMERIC,@@currstring_id)  
            AND    (excpm_excsm_id in (select dpam_excsm_id from dp_acct_mstr where dpam_crn_no = @l_crn_no and dpam_deleted_ind = 1)  
            OR      excpm_excsm_id in (select dpam_excsm_id from dp_acct_mstr_mak where dpam_crn_no = @l_crn_no and dpam_deleted_ind in(0,4,8)))  
            --   
            OPEN @c_clid  
            FETCH NEXT FROM @c_clid INTO @c_clid_id  
            --  
            WHILE @@fetch_status = 0  
            BEGIN  
            --  
              SET @l_clid_id = @l_clid_id + CONVERT(VARCHAR, @c_clid_id)+@rowdelimiter  
              --   
              FETCH NEXT FROM @c_clid INTO @c_clid_id  
            --  
            END  
            CLOSE      @c_clid  
            DEALLOCATE @c_clid  
            ---  
            IF isnull(@l_clid_id,'') <> ''  
            BEGIN  
            --  
              EXEC pr_ins_upd_clid @l_clid_id,@pa_action,@pa_login_name, @l_crn_no,'',1,@rowdelimiter,@coldelimiter,@pa_msg = @l_error  
                 insert into applog
              select @l_crn_no,'pr_ins_upd_clid' ,GETDATE()
              IF @l_error = '' SET @l_error =  '0'  
              --SELECT * FROM CLIENT_DOCUMENTS WHERE CLID_CRN_NO = 650  
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
                         , dp_acct_mstr                dpam     WITH(NOLOCK)  
                    WHERE  accdmak.accd_clisba_id     = dpam.dpam_id  
                    AND    dpam.dpam_crn_no           = @l_crn_no --CONVERT(NUMERIC,@@currstring_id)  
                    AND    accdmak.accd_deleted_ind   IN (0,4,8)  
                    AND    dpam.dpam_deleted_ind  = 1  
                   )  
          BEGIN  
          --  
            
            
            SET    @c_accd                   = CURSOR fast_forward FOR  
            SELECT DISTINCT accd_id
            FROM   accd_mak                     accdmak   WITH(NOLOCK)  
                 , dp_acct_mstr                 dpam      WITH(NOLOCK)  
            WHERE  accdmak.accd_clisba_id     = dpam.dpam_id  
            AND    dpam.dpam_crn_no           = @l_crn_no --CONVERT(NUMERIC,@@currstring_id)  
            AND    accdmak.accd_deleted_ind  IN (0,4,8)  
            AND    dpam.dpam_deleted_ind      = 1  
            --   
            OPEN @c_accd  
            FETCH NEXT FROM @c_accd INTO @c_accd_id
            --  
            WHILE @@fetch_status = 0  
            BEGIN  
            --  
              SET @l_accd_id = @l_accd_id + CONVERT(VARCHAR, @c_accd_id)+@rowdelimiter  
              --    
                                   
              FETCH NEXT FROM @c_accd INTO @c_accd_id 
            --  
            END  
            CLOSE      @c_accd  
            DEALLOCATE @c_accd  
            ---  
---            print @l_accd_id
            IF isnull(@l_accd_id,'') <> ''  
            BEGIN  
            --

			  --select @l_accd_id,@pa_action,@pa_login_name, @l_crn_no,'','','',1,@rowdelimiter,@coldelimiter,@l_error  
              EXEC pr_ins_upd_accd @l_accd_id,@pa_action,@pa_login_name, @l_crn_no,'','','',null,null,1,@rowdelimiter,@coldelimiter,@pa_msg = @l_error  
               insert into applog
              select @l_crn_no,'pr_ins_upd_accd' ,GETDATE()
              IF @l_error = '' SET @l_error =  '0'  
              --SELECT * FROM ACCOUNT_DOCUMENTS WHERE ACCD_CLISBA_ID IN(882,883)  
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
                   union
                   SELECT entp_id
                   FROM   entity_properties  WITH(NOLOCK)        
                   WHERE  entp_ent_id       = @l_crn_no --CONVERT(NUMERIC,@@currstring_id)         
                   AND    entp_deleted_ind  = 1  
                    )  
          BEGIN  
          --  
            
            
  
            SET    @c_entp                 = CURSOR fast_forward FOR  
           	   SELECT DISTINCT entpmak_id         
			   FROM   entity_properties_mak    WITH(NOLOCK)     
			   ,entity_property_mstr     WITH(NOLOCK)       
               ,excsm_prod_mstr          WITH(NOLOCK)       
			   WHERE  entp_deleted_ind         IN (0,4,8)        
			   AND    entp_ent_id              = @l_crn_no --CONVERT(NUMERIC,@@currstring_id)        
			   AND    entp_entpm_prop_id       = entpm_prop_id     
               and    excpm_id                 = entpm_excpm_id
			   AND    (excpm_excsm_id in (select dpam_excsm_id from dp_acct_mstr where dpam_crn_no = @l_crn_no AND dpam_deleted_ind =1 )    
			   OR     excpm_excsm_id in (select dpam_excsm_id from dp_acct_mstr_mak where dpam_crn_no = @l_crn_no AND dpam_deleted_ind in (0,4,8)))    
			   union
			   SELECT DISTINCT entp_id         
			   FROM   entity_properties    WITH(NOLOCK)     
					 ,entity_property_mstr     WITH(NOLOCK)     
					 ,entity_property_dtls_mak  WITH(NOLOCK)
                     ,excsm_prod_mstr          WITH(NOLOCK)            
			   WHERE  entp_deleted_ind         = 1 
			   AND    entp_ent_id              = @l_crn_no --CONVERT(NUMERIC,@@currstring_id)        
			   AND    entp_entpm_prop_id       = entpm_prop_id     
               and    excpm_id                 = entpm_excpm_id
			   and    entpd_entp_id            = entp_id 
			   and    entpd_deleted_ind  in (0,4,8)  
               AND    (excpm_excsm_id in (select dpam_excsm_id from dp_acct_mstr where dpam_crn_no = @l_crn_no AND dpam_deleted_ind =1 )    
			   OR     excpm_excsm_id in (select dpam_excsm_id from dp_acct_mstr_mak where dpam_crn_no = @l_crn_no AND dpam_deleted_ind in (0,4,8)))                --  
            OPEN @c_entp  
            FETCH NEXT FROM @c_entp INTO @c_entpmak_id  
            --  
            WHILE @@fetch_status = 0  
            BEGIN  
            --  
              SET @l_entpmak_id = @l_entpmak_id + CONVERT(VARCHAR, @c_entpmak_id)+@rowdelimiter  
  
              FETCH NEXT FROM @c_entp INTO @c_entpmak_id  
            --  
            END  
            CLOSE      @c_entp  
            DEALLOCATE @c_entp  
            ---  
            IF ISNULL(@l_entpmak_id,'') <> ''  
            BEGIN  
            --  
              EXEC pr_ins_upd_entp @l_entpmak_id,@pa_action,@pa_login_name, @l_crn_no,'','','',1,@rowdelimiter,@coldelimiter,@pa_msg = @l_error  
               insert into applog
              select @l_crn_no,'pr_ins_upd_entp' ,GETDATE()
              IF @l_error = '' SET @l_error =  '0'  
              --SELECT * FROM ENTITY_PROPERTIES WHERE ENTP_ENT_ID = 650  
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
                         , dp_acct_mstr              dpam     WITH(NOLOCK)  
                    WHERE  accpmak.accp_clisba_id    = dpam.dpam_id  
                    AND    dpam.dpam_crn_no          = @l_crn_no --CONVERT(NUMERIC,@@currstring_id)   
                    AND    accpmak.accp_deleted_ind       IN (0,4,8)  
                    AND    dpam.dpam_deleted_ind = 1
                    union
                    SELECT accp_id   
                    FROM   account_properties        accpmak
                          ,dp_acct_mstr              dpam     WITH(NOLOCK)  
                          ,accpd_mak   
                    WHERE  accpmak.accp_clisba_id    = dpam.dpam_id  
                    AND    dpam.dpam_crn_no          = @l_crn_no --CONVERT(NUMERIC,@@currstring_id)   
                    and    accpmak.accp_id           = accpd_accp_id  
                    AND    accpmak.accp_deleted_ind     =1
                    and    accpd_deleted_ind in (0,4,8)
                    AND    dpam.dpam_deleted_ind = 1    )  
          BEGIN  
          --  

            
            
            SET    @c_accp                   = CURSOR fast_forward FOR  
            SELECT DISTINCT accpmak_id 
            FROM   accp_mak                     accpmak   WITH(NOLOCK)  
                 , dp_acct_mstr                 dpam    WITH(NOLOCK)  
            WHERE  accpmak.accp_clisba_id     = dpam.dpam_id  
            AND    dpam.dpam_crn_no           = @l_crn_no --CONVERT(NUMERIC,@@currstring_id)  
            AND    accpmak.accp_deleted_ind   IN (0,4,8)  
            AND    dpam.dpam_deleted_ind  = 1  
            union
            SELECT DISTINCT accp_id 
            FROM   account_properties           accpmak   WITH(NOLOCK)  
                 , dp_acct_mstr                 dpam    WITH(NOLOCK)  
                 , accpd_mak                    WITH(NOLOCK)  
            WHERE  accpmak.accp_clisba_id     = dpam.dpam_id  
            AND    accpmak.accp_id = accpd_accp_id
            AND    dpam.dpam_crn_no           = @l_crn_no --CONVERT(NUMERIC,@@currstring_id)  
            AND    accpmak.accp_deleted_ind   = 1 
            AND    dpam.dpam_deleted_ind  = 1  
            --  
            OPEN @c_accp  
            FETCH NEXT FROM @c_accp INTO @c_accpmak_id
            --  
            WHILE @@fetch_status = 0  
            BEGIN  
            --  
              SET @l_accpmak_id = @l_accpmak_id + CONVERT(VARCHAR, @c_accpmak_id)+@rowdelimiter  
  
                                                      
              --   
              FETCH NEXT FROM @c_accp INTO @c_accpmak_id
            --  
            END  
            CLOSE      @c_accp  
            DEALLOCATE @c_accp  
            ---  
            IF ISNULL(@l_accpmak_id, '') <> ''  
            BEGIN  
            --  
              
              
              EXEC pr_ins_upd_accp @l_accpmak_id,@pa_action,@pa_login_name, @l_crn_no,'','','','',1,@rowdelimiter,@coldelimiter,@pa_msg = @l_error  
                insert into applog
              select @l_crn_no,'pr_ins_upd_accp' ,GETDATE()
              IF @l_error = '' SET @l_error =  '0'  
              --PRINT  @l_accpmak_id  
              --SELECT * FROM ACCOUNT_PROPERTIES WHERE ACCP_CLISBA_ID IN (882,883)  
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
          update dpam set dpam_sba_name = CLIM_NAME1 + ' ' + isnull(CLIM_NAME2,'') + ' ' + isnull(CLIM_NAME3,'') from dp_acct_mstr dpam ,client_mstr where clim_crn_no = dpam_crn_no and dpam_crn_no = @l_crn_no and CLIM_DELETED_IND = 1 and dpam_DELETED_IND = 1
          update clil set clim_deleted_ind = 2 from client_mstr clim, client_list clil 
          where clil.clim_crn_no = clim.clim_crn_no and clim.clim_deleted_ind = 1 and clim.clim_crn_no = @l_crn_no
          
          
             select  @l_mod_crn = convert(varchar,@l_crn_no)
			-- exec PR_INS_UPD_CLILM 'APP',@l_mod_crn,@l_mod_crn,'',@pa_login_name,'' 
			 
			 
			 IF EXISTS(SELECT 1 FROM name_change_reason_cd WHERE nmcrcd_crn_no = @l_crn_no AND nmcrcd_deleted_ind = '0')
			BEGIN
		--		set @CLIM_RMKS_FINAL = ''
		--		set @CLIM_RMKS = ''
		--		set @CLIM_RMKS_MAK = ''
		--		
		--		select @CLIM_RMKS_MAK = clim_rmks from client_mstr_mak 
		--		where clim_crn_no = @PA_CLIC_MOD_DPAM_SBA_NO 
		--		and clim_deleted_ind in ('0','8','1')
		--	 
		--		select @CLIM_RMKS = clim_rmks from client_mstr 
		--		where clim_crn_no = @PA_CLIC_MOD_DPAM_SBA_NO
		--		and clim_deleted_ind  = '1'
		--		
		--		set @CLIM_RMKS_FINAL = @CLIM_RMKS + '</BR>' + @CLIM_RMKS_MAK

				update name_change_reason_cd set nmcrcd_deleted_ind = '1' 
				where nmcrcd_crn_no = @l_crn_no 
				AND nmcrcd_deleted_ind = '0'
				

				--update client_mstr set CLIM_RMKS = @CLIM_RMKS_FINAL where clim_crn_no = @l_crn_no
			END
--			 print @l_mod_crn
--			 print 'pankaj'
			select  @l_dpam_sba_no= dpam_sba_no from DP_ACCT_MSTR with(nolock) where DPAM_DELETED_IND=1 and DPAM_CRN_NO=@l_mod_crn
			 
			UPDATE Cl SET Cl.CLIC_MOD_DELETED_IND=1,Cl.CLIC_MOD_LST_UPD_BY=@PA_LOGIN_NAME ,  
			Cl.CLIC_MOD_LST_UPD_DT=GETDATE() from CLIENT_LIST_MODIFIED Cl
			WHERE CLIC_MOD_DELETED_IND=0 and  clic_mod_dpam_sba_no=@l_dpam_sba_no
			
			
			 
			 
         --  
         END  
      --  
      END  
    --  
    END  
    ELSE IF @pa_app_sba <> ''   
    BEGIN  
    --  
      exec pr_app_client_dp @pa_id ,@pa_app_sba ,@pa_action ,@pa_login_name ,@pa_values ,@pa_chk_yn ,@rowdelimiter ,@coldelimiter,@pa_msg output   

    --  
    END  
    -- declare @l_mod_crn varchar(50)
    --select  @l_mod_crn = convert(varchar,@l_crn_no)
    --exec PR_INS_UPD_CLILM 'APP',@l_mod_crn,@l_mod_crn,'',@pa_login_name,'' 
  --  
  END

GO
