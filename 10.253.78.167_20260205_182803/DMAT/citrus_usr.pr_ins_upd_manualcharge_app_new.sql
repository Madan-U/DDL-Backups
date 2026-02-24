-- Object: PROCEDURE citrus_usr.pr_ins_upd_manualcharge_app_new
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE procedure  [citrus_usr].[pr_ins_upd_manualcharge_app_new](@pa_id  varchar(25)    
                                           , @pa_action     varchar(20)    
                                           , @pa_login_name varchar(20)    
                                           , @pa_dpid       varchar(20)    
                                           , @pa_charge_for  varchar(10)     
                                           , @pa_cli_acc     varchar(20)     
                                           , @pa_post_toacct varchar(20)    
                                           , @pa_charge_dt   varchar(11)    
                                           , @pa_charge_desc varchar(100)    
                                           , @pa_charge_amt  NUMERIC(18,2)    
                                           , @pa_values      varchar(8000)    
                                           , @pa_chk_yn      int    
                                           , @pa_login_pr_entm_id numeric                      
										   , @pa_login_entm_cd_chain  varchar(8000)                        
										   , @pa_brom_id varchar(100)	
										   , @pa_group_id char(1)												
                                           , @rowdelimiter      CHAR(4)       = '*|~*'      
                                           , @coldelimiter      CHAR(4)       = '|*~|'      
                                           , @pa_errmsg         VARCHAR(8000) output      
                                           )    
AS    
BEGIN    
--    
  DECLARE @t_errorstr      VARCHAR(8000)    
         , @l_error           BIGINT    
         , @delimeter       VARCHAR(10)    
         , @remainingstring VARCHAR(8000)    
         , @currstring      VARCHAR(8000)    
         , @foundat         INTEGER    
         , @delimeterlength  INT    
         , @delimeter_value    VARCHAR(10)    
         , @delimeterlength_value VARCHAR(10)    
         , @remainingstring_value VARCHAR(8000)    
         , @currstring_value VARCHAR(8000)    
         , @l_dpam_id         NUMERIC    
         , @l_id              INT    
         , @l_idm             INT    
         , @l_dpm_id          NUMERIC    
         , @l_deleted_ind     INT    
         , @@l_child_entm_id numeric
         CREATE TABLE #ACLIST(dpam_id BIGINT,dpam_sba_no VARCHAR(16),dpam_sba_name VARCHAR(150),eff_from DATETIME,eff_to DATETIME)
		  
          select @@l_child_entm_id    =  citrus_usr.fn_get_child(@pa_login_pr_entm_id , @pa_login_entm_cd_chain)

            if @pa_cli_acc     = '' 
            begin
            
            SELECT @l_dpm_id    = dpm_id FROM dp_mstr WHERE dpm_deleted_ind = 1   and dpm_dpid = @pa_dpid    
             
			
		  
		    if @pa_brom_id = ''
			INSERT INTO #ACLIST SELECT DPAM_ID,dpam_sba_no,dpam_sba_name,EFF_FROM,EFF_TO FROM citrus_usr.fn_acct_list(@l_dpm_id    ,@pa_login_pr_entm_id,@@l_child_entm_id) 
			where convert(datetime,@pa_charge_dt,103)    between eff_from and eff_to
			PRINT @l_dpm_id
			PRINT @pa_login_pr_entm_id
			PRINT @@l_child_entm_id
			PRINT @pa_charge_dt
			PRINT @pa_brom_id
			if @pa_brom_id <> ''
			INSERT INTO #ACLIST SELECT DPAM_ID,dpam_sba_no,dpam_sba_name,EFF_FROM,EFF_TO FROM citrus_usr.fn_acct_list(@l_dpm_id    ,@pa_login_pr_entm_id,@@l_child_entm_id) 
			, client_dp_brkg 
			where convert(datetime,@pa_charge_dt,103) between eff_from and eff_to
			and   dpam_id = clidb_dpam_id 
			and   convert(datetime,@pa_charge_dt,103) between clidb_eff_from_dt and clidb_eff_to_dt
			and   clidb_deleted_ind = 1 
			and clidb_brom_id = @pa_brom_id 
			
			
			
			end 
			if @pa_cli_acc     <> '' 
            begin
            
            SELECT @l_dpm_id    = dpm_id FROM dp_mstr WHERE dpm_deleted_ind = 1   and dpm_dpid = @pa_dpid    
             
			
		  
		    if @pa_brom_id = ''
			INSERT INTO #ACLIST SELECT DPAM_ID,dpam_sba_no,dpam_sba_name,EFF_FROM,EFF_TO FROM citrus_usr.fn_acct_list(@l_dpm_id    ,@pa_login_pr_entm_id,@@l_child_entm_id) 
			where convert(datetime,@pa_charge_dt,103)    between eff_from and eff_to
			and dpam_sba_no = @pa_cli_acc     
			
			end 

  /*by latesh on apr 12 2012 for group master join */		  
  if @pa_group_id ='Y'
  begin
  delete from #ACLIST where dpam_sba_no not in (select grp_client_code from group_mstr)
  end
  /*by latesh on apr 12 2012 for group master join */					
       
  SET @l_error          = 0    
  SET @t_errorstr       = ''    
  SET @delimeter        = '%'+ @ROWDELIMITER + '%'    
  SET @delimeterlength  = LEN(@ROWDELIMITER)    
  SET @remainingstring  = @pa_id       
    
  WHILE @remainingstring <> ''    
  BEGIN    
  --    
    SET @foundat = 0    
    SET @foundat =  PATINDEX('%'+@delimeter+'%',@remainingstring)    
    --    
    IF @foundat > 0    
    BEGIN    
    --    
      SET @currstring      = SUBSTRING(@remainingstring, 0,@foundat)    
      SET @remainingstring = SUBSTRING(@remainingstring, @foundat+@delimeterlength,LEN(@remainingstring)- @foundat+@delimeterlength)    
    --    
    END    
    ELSE     
    BEGIN    
    --    
      SET @currstring      = @remainingstring    
      SET @remainingstring = ''    
    --    
    END    
    --    
    IF @currstring <> ''    
    BEGIN    
    --    
      IF @pa_chk_yn = 0           
        BEGIN    
        --    
          IF @pa_action ='INS'    
          BEGIN    
          --    
            SELECT @l_dpm_id    = dpm_id FROM dp_mstr WHERE dpm_deleted_ind = 1   and dpm_dpid = @pa_dpid    
                
    
            IF @pa_charge_for = 'C'    
            BEGIN    
            --    
              SELECT  @l_dpam_id  = dpam_id FROM dp_acct_mstr ,dp_mstr WHERE dpm_deleted_ind = 1  and dpm_id = dpam_dpm_id and dpm_dpid = @pa_dpid and dpam_sba_no = @pa_cli_acc    
    
    
              IF @pa_values ='NSDL'    
              BEGIN    
              --    
                SELECT @l_id = ISNULL(MAX(clic_id),0) + 1 FROM client_charges_nsdl    
                BEGIN TRANSACTION    
    
                INSERT INTO client_charges_nsdl    
                ( CLIC_ID    
                  ,CLIC_TRANS_DT    
                  ,CLIC_DPM_ID    
                  ,CLIC_DPAM_ID    
                  ,CLIC_CHARGE_NAME    
                  ,CLIC_CHARGE_AMT    
                  ,CLIC_FLG    
                  ,CLIC_CREATED_BY    
                  ,CLIC_CREATED_DT    
                  ,CLIC_LST_UPD_BY    
                  ,CLIC_LST_UPD_DT    
                  ,CLIC_DELETED_IND    
               ,CLIC_POST_TOACCT    
                )    
                VALUES    
                (@l_id    
                 ,convert(datetime,@pa_charge_dt,103)    
                 ,@l_dpm_id    
                 ,@l_dpam_id    
                 ,@pa_charge_desc    
                 ,convert(numeric(10,2),@pa_charge_amt)    
                 ,'M'    
                 ,@pa_login_name    
                 ,getdate()    
                 ,@pa_login_name    
                 ,getdate()    
                 ,1    
                 ,convert(numeric,@pa_post_toacct)    
                )    
    
                IF @l_error <> 0    
                BEGIN    
                --    
                  IF EXISTS(SELECT Err_Description FROM tblerror WHERE Err_Code = @l_error)    
                  BEGIN    
                  --    
                    SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': '+ Err_Description FROM tblerror WHERE Err_Code = CONVERT(VARCHAR,@l_error)    
                  --    
                  END    
                  ELSE    
                  BEGIN    
                  --    
                    SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': Can not process, Please contact your administrator!'    
                  --    
                  END    
    
                  ROLLBACK TRANSACTION     
    
                  RETURN    
                --    
                END    
                ELSE    
                BEGIN    
                --    
                  COMMIT TRANSACTION    
                --    
              END    
              --    
              END       /* nsdl */    
             ELSE IF @pa_values ='CDSL'    
             BEGIN    
             --    
              SELECT @l_id = ISNULL(MAX(clic_id),0) + 1 FROM client_charges_cdsl    
              select identity(numeric,1,1) id ,* into #ACLIST_FILTER from #ACLIST
              
    
              BEGIN TRANSACTION    
    PRINT 'PANKAJ'
              INSERT INTO client_charges_cdsl    
              ( CLIC_ID    
                ,CLIC_TRANS_DT    
                ,CLIC_DPM_ID    
                ,CLIC_DPAM_ID    
                ,CLIC_CHARGE_NAME    
                ,CLIC_CHARGE_AMT    
                ,CLIC_FLG    
                ,CLIC_CREATED_BY    
                ,CLIC_CREATED_DT    
                ,CLIC_LST_UPD_BY    
                ,CLIC_LST_UPD_DT    
                ,CLIC_DELETED_IND    
                ,CLIC_POST_TOACCT    
              )    
              
              select @l_id    + id 
               ,convert(datetime,@pa_charge_dt,103)    
               ,@l_dpm_id    
               ,dpam_id 
               ,@pa_charge_desc    
               ,convert(numeric(10,2),@pa_charge_amt)    
               ,'M'    
               ,@pa_login_name    
               ,getdate()    
               ,@pa_login_name    
               ,getdate()    
               ,1    
               ,convert(numeric,@pa_post_toacct)    
              from #ACLIST_FILTER 
    
              IF @l_error <> 0    
              BEGIN    
              --    
                IF EXISTS(SELECT Err_Description FROM tblerror WHERE Err_Code = @l_error)    
                BEGIN    
                --    
                  SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': '+ Err_Description FROM tblerror WHERE Err_Code = CONVERT(VARCHAR,@l_error)    
                --    
                END    
                ELSE    
                BEGIN    
                --    
                  SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': Can not process, Please contact your administrator!'    
                --    
                END    
    
                ROLLBACK TRANSACTION     
    
                RETURN    
              --    
              END    
              ELSE    
              BEGIN    
              --    
                COMMIT TRANSACTION    
              --    
              END    
            --    
            END /*cdsl*/    
            --    
            END    
            ELSE IF @pa_charge_for = 'D'    
            BEGIN    
            --    
    
               IF @pa_values ='NSDL'    
               BEGIN    
               --    
                SELECT @l_id = ISNULL(MAX(dpch_id),0) + 1 FROM dp_charges_nsdl    
    
                BEGIN TRANSACTION    
    
                INSERT INTO dp_charges_nsdl    
                (DPCH_ID    
                 ,DPCH_TRANC_DT    
                 ,DPCH_DPM_ID    
                 ,DPCH_CHARGE_NAME    
                 ,DPCH_CHARGE_AMT    
                 ,DPCH_POST_TOACCT    
                 ,DPCH_FLG    
                 ,DPCH_CREATED_BY    
                 ,DPCH_CREATED_DT    
                 ,DPCH_LST_UPD_BY    
                 ,DPCH_LST_UPD_DT    
                 ,DPCH_DELETED_IND    
                )    
                VALUES    
                (@l_id     
                 ,convert(datetime,@pa_charge_dt,103)    
                 ,@l_dpm_id    
                 ,@pa_charge_desc    
                 ,convert(numeric(10,2),@pa_charge_amt)    
                 ,convert(numeric,@pa_post_toacct)    
                 ,'M'    
                 ,@pa_login_name    
                 ,getdate()    
                 ,@pa_login_name    
                 ,getdate()    
                 ,1    
                )    
    
                IF @l_error <> 0    
                BEGIN    
                --    
                  IF EXISTS(SELECT Err_Description FROM tblerror WHERE Err_Code = @l_error)    
                  BEGIN    
                  --    
                    SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': '+ Err_Description FROM tblerror WHERE Err_Code = CONVERT(VARCHAR,@l_error)    
                  --    
                  END    
                  ELSE    
                  BEGIN    
                  --    
                    SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': Can not process, Please contact your administrator!'    
                  --    
                  END    
    
                  ROLLBACK TRANSACTION     
    
                  RETURN    
                --    
               END    
               ELSE    
               BEGIN    
               --    
                 COMMIT TRANSACTION    
               --    
               END    
             --    
             END /*NSDL*/    
             ELSE IF @pa_values ='CDSL'    
             BEGIN    
             --    
               SELECT @l_id = ISNULL(MAX(dpch_id),0) + 1 FROM dp_charges_cdsl    
    
               BEGIN TRANSACTION    
    
               INSERT INTO dp_charges_cdsl    
               (DPCH_ID    
                ,DPCH_TRANC_DT    
                ,DPCH_DPM_ID    
                ,DPCH_CHARGE_NAME    
                ,DPCH_CHARGE_AMT    
                ,DPCH_POST_TOACCT    
                ,DPCH_FLG    
                ,DPCH_CREATED_BY    
                ,DPCH_CREATED_DT    
                ,DPCH_LST_UPD_BY    
                ,DPCH_LST_UPD_DT    
                ,DPCH_DELETED_IND    
               )    
               VALUES    
               (@l_id     
                ,convert(datetime,@pa_charge_dt,103)    
                ,@l_dpm_id    
                ,@pa_charge_desc    
                ,convert(numeric(10,2),@pa_charge_amt)    
                ,convert(numeric,@pa_post_toacct)    
                ,'M'    
                ,@pa_login_name    
                ,getdate()    
                ,@pa_login_name    
                ,getdate()    
                ,1    
               )    
    
               IF @l_error <> 0    
               BEGIN    
               --    
                 IF EXISTS(SELECT Err_Description FROM tblerror WHERE Err_Code = @l_error)    
                 BEGIN    
                 --    
                   SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': '+ Err_Description FROM tblerror WHERE Err_Code = CONVERT(VARCHAR,@l_error)    
                 --    
                 END    
                 ELSE    
                 BEGIN    
                 --    
                   SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': Can not process, Please contact your administrator!'    
                 --    
END    
    
                 ROLLBACK TRANSACTION     
    
                 RETURN    
               --    
              END    
              ELSE    
              BEGIN    
              --    
                COMMIT TRANSACTION    
              --    
              END    
             --    
             END /*CDSL*/    
            --    
            END    
          --    
          END    /* end ins*/    
    
          IF @pa_action ='EDT'    
          BEGIN    
          --    
            IF @pa_charge_for = 'C'    
            BEGIN    
            --    
              IF @pa_values = 'NSDL'    
              BEGIN    
              --    
                UPDATE client_charges_nsdl    
                SET  CLIC_TRANS_DT    = convert(datetime,@pa_charge_dt,103)    
                    ,CLIC_POST_TOACCT = convert(numeric,@pa_post_toacct)    
                    ,CLIC_CHARGE_NAME = @pa_charge_desc     
                    ,CLIC_CHARGE_AMT  = @pa_charge_amt    
                    ,CLIC_LST_UPD_BY  = @pa_login_name    
                    ,CLIC_LST_UPD_dt  = getdate()    
                WHERE CLIC_ID   = convert(numeric,@currstring)        
                AND   CLIC_DELETED_IND = 1    
              --    
              END    
              ELSE IF @pa_values = 'CDSL'    
              BEGIN    
              --    
                UPDATE client_charges_cdsl    
                SET  CLIC_TRANS_DT    = convert(datetime,@pa_charge_dt,103)    
                    ,CLIC_POST_TOACCT = convert(numeric,@pa_post_toacct)    
                    ,CLIC_CHARGE_NAME = @pa_charge_desc     
                    ,CLIC_CHARGE_AMT  = @pa_charge_amt    
                    ,CLIC_LST_UPD_BY  = @pa_login_name    
                    ,CLIC_LST_UPD_dt  = getdate()    
                WHERE CLIC_ID   = convert(numeric,@currstring)        
                AND   CLIC_DELETED_IND = 1    
              --      
              END    
            --    
            END    
            ELSE IF @pa_charge_for = 'D'    
            BEGIN    
            --    
              IF @PA_VALUES ='NSDL'    
              BEGIN    
              --    
                UPDATE dp_charges_nsdl    
                SET  DPCH_TRANC_DT = convert(datetime,@pa_charge_dt,103)    
                    ,DPCH_POST_TOACCT = convert(numeric,@pa_post_toacct)    
                    ,DPCH_CHARGE_NAME = @pa_charge_desc     
                    ,DPCH_CHARGE_AMT  = @pa_charge_amt    
                    ,DPCH_LST_UPD_BY  = @pa_login_name    
                    ,DPCH_LST_UPD_dt  = getdate()     
                WHERE DPCH_ID     = convert(numeric,@currstring)      
                AND   DPCH_DELETED_IND = 1     
              --    
              END    
             ELSE IF @PA_VALUES ='CDSL'    
             BEGIN    
             --    
               UPDATE dp_charges_cdsl    
               SET  DPCH_TRANC_DT = convert(datetime,@pa_charge_dt,103)    
                   ,DPCH_POST_TOACCT = convert(numeric,@pa_post_toacct)    
                   ,DPCH_CHARGE_NAME = @pa_charge_desc     
                   ,DPCH_CHARGE_AMT  = @pa_charge_amt    
                   ,DPCH_LST_UPD_BY  = @pa_login_name    
                   ,DPCH_LST_UPD_dt  = getdate()     
               WHERE DPCH_ID     = convert(numeric,@currstring)      
               AND   DPCH_DELETED_IND = 1     
             --    
             END    
    
            --    
            END    
          --    
          END     /* end EDT*/    
    
          IF @pa_action ='DEL'    
          BEGIN    
          --    
            IF @pa_charge_for = 'C'    
            BEGIN    
            --    
              IF @PA_VALUES = 'NSDL'    
              BEGIN    
              --    
                 UPDATE client_charges_nsdl    
                 SET CLIC_DELETED_IND = 0    
                     ,CLIC_LST_UPD_BY  = @pa_login_name    
                     ,CLIC_LST_UPD_dt  = getdate()    
                 WHERE CLIC_ID   = convert(numeric,@currstring)        
                 AND   CLIC_DELETED_IND = 1       
      --    
              END    
              IF @PA_VALUES = 'CDSL'    
              BEGIN    
              --    
                 UPDATE client_charges_cdsl    
                 SET CLIC_DELETED_IND = 0    
                     ,CLIC_LST_UPD_BY  = @pa_login_name    
                     ,CLIC_LST_UPD_dt  = getdate()    
                 WHERE CLIC_ID   = convert(numeric,@currstring)        
                 AND   CLIC_DELETED_IND = 1       
              --    
              END    
    
            --    
            END    
            ELSE IF @pa_charge_for = 'D'    
            BEGIN    
            --    
              IF @pa_values = 'NSDL'    
              BEGIN    
              --    
                UPDATE dp_charges_nsdl    
                SET  DPCH_DELETED_IND = 0    
                    ,DPCH_LST_UPD_BY  = @pa_login_name    
                    ,DPCH_LST_UPD_dt  = getdate()     
                WHERE DPCH_ID     = convert(numeric,@currstring)      
                AND   DPCH_DELETED_IND = 1     
              --    
              END    
              ELSE IF @pa_values = 'CDSL'    
              BEGIN    
              --    
                UPDATE dp_charges_cdsl    
                SET  DPCH_DELETED_IND = 0    
                    ,DPCH_LST_UPD_BY  = @pa_login_name    
                    ,DPCH_LST_UPD_dt  = getdate()     
                WHERE DPCH_ID     = convert(numeric,@currstring)      
                AND   DPCH_DELETED_IND = 1       
              --    
              END    
    
            --    
           END    
    
          --    
          END    /* end DEL*/    
    
        --    
        END     /*nomakrechecker ends */    
    
        IF @pa_chk_yn = 1    
        BEGIN    
        --    
          IF @pa_action = 'INS'    
          BEGIN    
          --    
            SELECT @l_dpm_id    = dpm_id FROM dp_mstr WHERE dpm_deleted_ind = 1   and dpm_dpid = @pa_dpid    
    
            IF @pa_charge_for = 'C'    
            BEGIN    
            --    
              SELECT  @l_dpam_id  = dpam_id FROM dp_acct_mstr ,dp_mstr WHERE dpm_deleted_ind = 1  and dpm_id = dpam_dpm_id and dpm_dpid = @pa_dpid and dpam_sba_no = @pa_cli_acc    
    
              IF @pa_values ='NSDL'    
              BEGIN    
              --    
                SELECT @l_id = ISNULL(MAX(clic_id),0) + 1 FROM client_charges_nsdl    
                SELECT @l_idm = ISNULL(MAX(clic_id),0) + 1 FROM client_charges_nsdl_mak    
    
                IF @l_id > @l_idm      
                BEGIN    
                --    
                  SET @l_idm  =  @l_id    
                --    
                END    
    
                BEGIN TRANSACTION    
    
                INSERT INTO client_charges_nsdl_mak    
                ( CLIC_ID    
                  ,CLIC_TRANS_DT    
                  ,CLIC_DPM_ID    
                  ,CLIC_DPAM_ID    
                  ,CLIC_CHARGE_NAME    
                  ,CLIC_CHARGE_AMT    
                  ,CLIC_FLG    
                  ,CLIC_CREATED_BY    
                  ,CLIC_CREATED_DT    
                  ,CLIC_LST_UPD_BY    
                  ,CLIC_LST_UPD_DT    
                  ,CLIC_DELETED_IND    
                  ,CLIC_POST_TOACCT    
                )    
                VALUES    
                (@l_idm    
                 ,convert(datetime,@pa_charge_dt,103)    
                 ,@l_dpm_id    
                 ,@l_dpam_id    
                 ,@pa_charge_desc    
                 ,convert(numeric(10,2),@pa_charge_amt)    
                 ,'M'    
                 ,@pa_login_name    
                 ,getdate()    
                 ,@pa_login_name    
                 ,getdate()    
                 ,0    
                 ,convert(numeric,@pa_post_toacct)    
                )    
    
                IF @l_error <> 0    
                BEGIN    
                --    
                  IF EXISTS(SELECT Err_Description FROM tblerror WHERE Err_Code = @l_error)    
                  BEGIN    
                  --    
                    SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': '+ Err_Description FROM tblerror WHERE Err_Code = CONVERT(VARCHAR,@l_error)    
                  --    
                  END    
                  ELSE    
                  BEGIN    
                  --    
                    SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': Can not process, Please contact your administrator!'    
                  --    
                  END    
    
                  ROLLBACK TRANSACTION     
    
                  RETURN    
                --    
                END    
                ELSE    
                BEGIN    
                --    
                  COMMIT TRANSACTION    
                --    
              END    
              --    
              END       /* nsdl */    
             ELSE IF @pa_values ='CDSL'    
             BEGIN    
             --    
              SELECT @l_id = ISNULL(MAX(clic_id),0) + 1 FROM client_charges_cdsl    
              SELECT @l_idm = ISNULL(MAX(clic_id),0) + 1 FROM client_charges_cdsl_mak    
    
              IF @l_id > @l_idm      
              BEGIN    
              --    
               SET @l_idm = @l_id    
              --    
              END    
    
              BEGIN TRANSACTION    
    
              INSERT INTO client_charges_cdsl_mak    
              ( CLIC_ID    
                ,CLIC_TRANS_DT    
                ,CLIC_DPM_ID    
                ,CLIC_DPAM_ID    
                ,CLIC_CHARGE_NAME    
                ,CLIC_CHARGE_AMT    
                ,CLIC_FLG    
                ,CLIC_CREATED_BY    
                ,CLIC_CREATED_DT    
                ,CLIC_LST_UPD_BY    
                ,CLIC_LST_UPD_DT    
                ,CLIC_DELETED_IND    
                ,CLIC_POST_TOACCT    
              )    
              VALUES    
              (@l_idm    
               ,convert(datetime,@pa_charge_dt,103)    
               ,@l_dpm_id    
               ,@l_dpam_id    
               ,@pa_charge_desc    
               ,convert(numeric(10,2),@pa_charge_amt)    
               ,'M'    
               ,@pa_login_name    
               ,getdate()    
               ,@pa_login_name    
               ,getdate()    
               ,0    
               ,convert(numeric,@pa_post_toacct)    
              )    
    
              IF @l_error <> 0    
              BEGIN    
              --    
                IF EXISTS(SELECT Err_Description FROM tblerror WHERE Err_Code = @l_error)    
                BEGIN    
                --    
                  SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': '+ Err_Description FROM tblerror WHERE Err_Code = CONVERT(VARCHAR,@l_error)    
                --    
                END    
                ELSE    
                BEGIN    
                --    
                  SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': Can not process, Please contact your administrator!'    
                --    
                END    
    
                ROLLBACK TRANSACTION     
    
                RETURN    
              --    
              END    
              ELSE    
              BEGIN    
              --    
                COMMIT TRANSACTION    
              --    
              END    
                  --    
            END /*cdsl*/    
           --    
          END    
    
          IF @pa_charge_for ='D'    
          BEGIN    
          --    
             IF @pa_values ='NSDL'    
             BEGIN    
             --    
              SELECT @l_id = ISNULL(MAX(dpch_id),0) + 1 FROM dp_charges_nsdl    
              SELECT @l_idm = ISNULL(MAX(dpch_id),0) + 1 FROM dp_charges_nsdl_mak    
    
              IF @l_id > @l_idm     
              BEGIN    
              --    
               SET  @l_idm = @l_id    
              --    
              END    
    
              BEGIN TRANSACTION    
    
              INSERT INTO dp_charges_nsdl_mak    
              (DPCH_ID    
               ,DPCH_TRANC_DT    
               ,DPCH_DPM_ID    
               ,DPCH_CHARGE_NAME    
               ,DPCH_CHARGE_AMT    
               ,DPCH_POST_TOACCT    
               ,DPCH_FLG    
               ,DPCH_CREATED_BY    
               ,DPCH_CREATED_DT    
               ,DPCH_LST_UPD_BY    
               ,DPCH_LST_UPD_DT    
               ,DPCH_DELETED_IND    
              )    
              VALUES    
              (@l_idm     
               ,convert(datetime,@pa_charge_dt,103)    
               ,@l_dpm_id    
               ,@pa_charge_desc    
               ,convert(numeric(10,2),@pa_charge_amt)    
               ,convert(numeric,@pa_post_toacct)    
               ,'M'    
               ,@pa_login_name    
               ,getdate()    
               ,@pa_login_name    
               ,getdate()    
               ,0    
              )    
    
              IF @l_error <> 0    
              BEGIN    
              --    
                IF EXISTS(SELECT Err_Description FROM tblerror WHERE Err_Code = @l_error)    
                BEGIN    
                --    
                  SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': '+ Err_Description FROM tblerror WHERE Err_Code = CONVERT(VARCHAR,@l_error)    
                --    
                END    
                ELSE    
                BEGIN    
                --    
                  SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': Can not process, Please contact your administrator!'    
                --    
                END    
    
                ROLLBACK TRANSACTION     
    
                RETURN    
              --    
             END    
             ELSE    
             BEGIN    
             --    
               COMMIT TRANSACTION    
             --    
             END    
           --    
           END /*NSDL*/    
           ELSE IF @pa_values ='CDSL'    
           BEGIN    
           --    
             SELECT @l_id = ISNULL(MAX(dpch_id),0) + 1 FROM dp_charges_cdsl    
             SELECT @l_idm = ISNULL(MAX(dpch_id),0) + 1 FROM dp_charges_cdsl_mak    
    
             IF @l_id > @l_idm     
             BEGIN    
             --    
              SET @l_idm = @l_id    
             --    
             END    
    
             BEGIN TRANSACTION    
    
             insert into dp_charges_cdsl_mak    
             (DPCH_ID    
              ,DPCH_TRANC_DT    
              ,DPCH_DPM_ID    
              ,DPCH_CHARGE_NAME    
              ,DPCH_CHARGE_AMT    
              ,DPCH_POST_TOACCT    
              ,DPCH_FLG    
              ,DPCH_CREATED_BY    
              ,DPCH_CREATED_DT    
              ,DPCH_LST_UPD_BY    
              ,DPCH_LST_UPD_DT    
              ,DPCH_DELETED_IND    
             )    
             VALUES    
             (@l_idm     
              ,convert(datetime,@pa_charge_dt,103)    
              ,@l_dpm_id    
              ,@pa_charge_desc    
              ,convert(numeric(10,2),@pa_charge_amt)    
              ,convert(numeric,@pa_post_toacct)    
              ,'M'    
              ,@pa_login_name    
              ,getdate()    
              ,@pa_login_name    
              ,getdate()    
              ,0    
             )    
    
             IF @l_error <> 0    
             BEGIN    
             --    
               IF EXISTS(SELECT Err_Description FROM tblerror WHERE Err_Code = @l_error)    
               BEGIN    
               --    
                 SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': '+ Err_Description FROM tblerror WHERE Err_Code = CONVERT(VARCHAR,@l_error)    
               --    
               END    
               ELSE    
               BEGIN    
               --    
                 SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': Can not process, Please contact your administrator!'    
               --    
               END    
    
               ROLLBACK TRANSACTION     
    
               RETURN    
             --    
            END    
            ELSE    
            BEGIN    
            --    
              COMMIT TRANSACTION    
            --    
            END    
           --    
           END /*CDSL*/    
    
          --    
          END     
--    
          END /*ins*/    
    
          IF @pa_action ='EDT'    
          BEGIN    
          --    
            SELECT @l_dpm_id    = dpm_id FROM dp_mstr WHERE dpm_deleted_ind = 1   and dpm_dpid = @pa_dpid    
                
           IF @pa_charge_for = 'C'    
           BEGIN    
           --    
                 
             SELECT  @l_dpam_id  = dpam_id FROM dp_acct_mstr ,dp_mstr WHERE dpm_deleted_ind = 1  and dpm_id = dpam_dpm_id and dpm_dpid = @pa_dpid and dpam_sba_no = @pa_cli_acc    
                 
             IF @pa_values = 'NSDL'    
             BEGIN    
             --    
               UPDATE client_charges_nsdl_mak    
               SET CLIC_DELETED_IND = 2    
                   ,CLIC_LST_UPD_BY  = @pa_login_name    
                   ,CLIC_LST_UPD_dt  = getdate()    
               WHERE CLIC_ID   = convert(numeric,@currstring)        
               AND   CLIC_DELETED_IND = 0    
    
               IF EXISTS(SELECT TOP 1 CLIC_ID FROM client_charges_nsdl WHERE clic_id = convert(numeric,@currstring) and clic_deleted_ind = 1)    
               BEGIN    
               --    
                 SET @l_deleted_ind = 6    
               --    
               END    
               ELSE    
               BEGIN    
               --    
                 SET @l_deleted_ind = 0    
               --    
               END    
    
               INSERT INTO  client_charges_nsdl_mak    
               (CLIC_ID    
                ,CLIC_TRANS_DT    
                ,CLIC_DPM_ID    
                ,CLIC_DPAM_ID    
                ,CLIC_CHARGE_NAME    
                ,CLIC_CHARGE_AMT    
                ,CLIC_FLG    
                ,CLIC_CREATED_BY    
                ,CLIC_CREATED_DT    
                ,CLIC_LST_UPD_BY    
                ,CLIC_LST_UPD_DT    
                ,CLIC_DELETED_IND    
                ,CLIC_POST_TOACCT    
    
               )VALUES    
               (    
                convert(numeric,@currstring)    
               ,convert(datetime,@pa_charge_dt,103)    
               ,@l_dpm_id    
               ,@l_dpam_id    
               ,@pa_charge_desc    
               ,convert(numeric(10,2),@pa_charge_amt)    
               ,'M'    
               ,@pa_login_name    
               ,getdate()    
               ,@pa_login_name    
               ,getdate()    
               ,@l_deleted_ind    
               ,convert(numeric,@pa_post_toacct)    
               )    
             --    
             END    
             ELSE IF @pa_values = 'CDSL'    
             BEGIN    
             --    
               UPDATE client_charges_cdsl_mak    
               SET clic_deleted_ind = 2    
                   ,clic_lst_upd_by  = @pa_login_name    
                   ,clic_lst_upd_dt  = getdate()    
               WHERE clic_id   = convert(numeric,@currstring)        
               AND   clic_deleted_ind = 0    
    
               IF EXISTS(SELECT TOP 1 clic_id FROM client_charges_cdsl WHERE clic_id = convert(numeric,@currstring) and clic_deleted_ind = 1)    
               BEGIN    
               --    
                 SET @l_deleted_ind = 6    
               --    
               END    
               ELSE    
               BEGIN    
               --    
                 SET @l_deleted_ind = 0    
               --    
               END    
    
               INSERT INTO  client_charges_cdsl_mak    
               (CLIC_ID    
                ,CLIC_TRANS_DT    
                ,CLIC_DPM_ID    
                ,CLIC_DPAM_ID    
                ,CLIC_CHARGE_NAME    
                ,CLIC_CHARGE_AMT    
                ,CLIC_FLG    
                ,CLIC_CREATED_BY    
                ,CLIC_CREATED_DT    
                ,CLIC_LST_UPD_BY    
                ,CLIC_LST_UPD_DT    
                ,CLIC_DELETED_IND    
                ,CLIC_POST_TOACCT    
    
               )VALUES    
               (    
                convert(numeric,@currstring)    
               ,convert(datetime,@pa_charge_dt,103)    
               ,@l_dpm_id    
               ,@l_dpam_id    
         ,@pa_charge_desc    
               ,convert(numeric(10,2),@pa_charge_amt)    
               ,'M'    
               ,@pa_login_name    
               ,getdate()    
               ,@pa_login_name    
               ,getdate()    
               ,@l_deleted_ind    
               ,convert(numeric,@pa_post_toacct)    
               )    
             --      
             END    
             --    
             END    
             ELSE IF @pa_charge_for = 'D'    
             BEGIN    
             --    
                IF @pa_values ='NSDL'    
                BEGIN    
                --    
                  UPDATE dp_charges_nsdl_mak    
                  SET dpch_deleted_ind = 2    
                      ,dpch_lst_upd_by  = @pa_login_name    
                      ,dpch_lst_upd_dt  = getdate()     
                  WHERE dpch_id     = convert(numeric,@currstring)      
                  AND   dpch_deleted_ind = 0    
    
    
                  IF EXISTS(SELECT TOP 1 dpch_id FROM dp_charges_nsdl WHERE  dpch_id = convert(numeric,@currstring) AND dpch_deleted_ind = 1 )    
                  BEGIN    
                  --    
                    SET @l_deleted_ind = 6    
                  --    
                  END    
                  ELSE    
                  BEGIN    
                  --    
                    SET @l_deleted_ind = 0    
                  --    
                  END    
    
                  INSERT INTO dp_charges_nsdl_mak    
                  (DPCH_ID    
                   ,DPCH_TRANC_DT    
                   ,DPCH_DPM_ID    
                   ,DPCH_CHARGE_NAME    
                   ,DPCH_CHARGE_AMT    
                   ,DPCH_POST_TOACCT    
                   ,DPCH_FLG    
                   ,DPCH_CREATED_BY    
                   ,DPCH_CREATED_DT    
                   ,DPCH_LST_UPD_BY    
                   ,DPCH_LST_UPD_DT    
                   ,DPCH_DELETED_IND    
                  )    
                  VALUES    
                  (convert(numeric,@currstring)    
                   ,convert(datetime,@pa_charge_dt,103)    
                   ,@l_dpm_id    
                   ,@pa_charge_desc    
                   ,convert(numeric(18,2),@pa_charge_amt)    
                   ,convert(numeric,@pa_post_toacct)    
                   ,'M'    
                   ,@pa_login_name    
                   ,getdate()    
                   ,@pa_login_name    
                   ,getdate()    
                   ,@l_deleted_ind    
                 )    
               --    
               END    
               ELSE IF @pa_values ='CDSL'    
               BEGIN    
               --    
                  UPDATE dp_charges_cdsl_mak    
                  SET dpch_deleted_ind = 2    
                      ,dpch_lst_upd_by  = @pa_login_name    
                      ,dpch_lst_upd_dt  = getdate()     
                  WHERE dpch_id     = convert(numeric,@currstring)      
                  AND   dpch_deleted_ind = 0    
    
    
                  IF EXISTS(SELECT TOP 1 dpch_id FROM dp_charges_cdsl WHERE  dpch_id = convert(numeric,@currstring) AND dpch_deleted_ind = 1 )    
                  BEGIN    
                  --    
                    SET @l_deleted_ind = 6    
                  --    
                  END    
                  ELSE    
                  BEGIN    
                  --    
                    SET @l_deleted_ind = 0    
                  --    
                  END    
    
                  INSERT INTO dp_charges_cdsl_mak    
                  (DPCH_ID    
                   ,DPCH_TRANC_DT    
                   ,DPCH_DPM_ID    
                   ,DPCH_CHARGE_NAME    
                   ,DPCH_CHARGE_AMT    
                   ,DPCH_POST_TOACCT    
                   ,DPCH_FLG    
                   ,DPCH_CREATED_BY    
                   ,DPCH_CREATED_DT    
                   ,DPCH_LST_UPD_BY    
                   ,DPCH_LST_UPD_DT    
                   ,DPCH_DELETED_IND    
                  )    
                  VALUES    
                  (convert(numeric,@currstring)    
                   ,convert(datetime,@pa_charge_dt,103)    
                   ,@l_dpm_id    
                   ,@pa_charge_desc    
                   ,convert(numeric(18,2),@pa_charge_amt)    
                   ,convert(numeric,@pa_post_toacct)    
                   ,'M'    
                   ,@pa_login_name    
                   ,getdate()    
                   ,@pa_login_name    
                   ,getdate()    
                   ,@l_deleted_ind    
                 )    
               --    
               END    
              --            
            END    
          --    
          END /*EDT*/    
          ELSE IF @pa_action = 'DEL'    
          BEGIN    
          --    
            IF @pa_charge_for = 'C'    
            BEGIN    
            --    
              IF @pa_values = 'NSDL'    
              BEGIN    
              --    
                IF EXISTS(SELECT TOP 1 clic_id FROM client_charges_nsdl_mak WHERE clic_id = convert(numeric,@currstring) AND clic_deleted_ind = 0  )    
                BEGIN    
                --    
                  DELETE FROM client_charges_nsdl_mak    
                  WHERE clic_id = convert(numeric,@currstring)     
                  AND clic_deleted_ind = 0      
                --    
                END    
                ELSE    
                BEGIN    
                --    
                  INSERT INTO client_charges_nsdl_mak    
                  ( CLIC_ID    
                    ,CLIC_TRANS_DT    
                    ,CLIC_DPM_ID    
                    ,CLIC_DPAM_ID    
                    ,CLIC_CHARGE_NAME    
                    ,CLIC_CHARGE_AMT    
                    ,CLIC_FLG    
                    ,CLIC_CREATED_BY    
                    ,CLIC_CREATED_DT    
                    ,CLIC_LST_UPD_BY    
                    ,CLIC_LST_UPD_DT    
                    ,CLIC_DELETED_IND    
                    ,CLIC_POST_TOACCT    
                  )    
                  SELECT    
                        CLIC_ID    
                       ,CLIC_TRANS_DT    
                       ,CLIC_DPM_ID    
                       ,CLIC_DPAM_ID    
                       ,CLIC_CHARGE_NAME    
                       ,CLIC_CHARGE_AMT    
                       ,CLIC_FLG    
                       ,CLIC_CREATED_BY    
                       ,CLIC_CREATED_DT    
                       ,@pa_login_name    
                       ,getdate()    
                       ,4    
                       ,CLIC_POST_TOACCT    
                  FROM client_charges_nsdl    
                  WHERE clic_id = convert(numeric,@currstring)     
                  AND clic_deleted_ind = 1    
                --    
                END    
              --    
              END    
              ELSE IF @pa_values = 'CDSL'    
              BEGIN    
              --    
                IF EXISTS(SELECT TOP 1 clic_id FROM client_charges_cdsl_mak WHERE clic_id = convert(numeric,@currstring) AND clic_deleted_ind = 0  )    
                BEGIN    
                --    
                  DELETE FROM client_charges_cdsl_mak    
                  WHERE clic_id = convert(numeric,@currstring)     
                  AND clic_deleted_ind = 0      
                --    
                END    
                ELSE    
                BEGIN    
                --    
                  INSERT INTO client_charges_cdsl_mak    
                  ( CLIC_ID    
                    ,CLIC_TRANS_DT    
                    ,CLIC_DPM_ID    
                    ,CLIC_DPAM_ID    
                    ,CLIC_CHARGE_NAME    
                    ,CLIC_CHARGE_AMT    
                    ,CLIC_FLG    
                    ,CLIC_CREATED_BY    
                    ,CLIC_CREATED_DT    
                    ,CLIC_LST_UPD_BY    
                    ,CLIC_LST_UPD_DT    
                    ,CLIC_DELETED_IND    
                    ,CLIC_POST_TOACCT    
                  )    
                  SELECT    
                        CLIC_ID    
                       ,CLIC_TRANS_DT    
                       ,CLIC_DPM_ID                           ,CLIC_DPAM_ID    
                       ,CLIC_CHARGE_NAME    
                       ,CLIC_CHARGE_AMT    
                       ,CLIC_FLG    
                       ,CLIC_CREATED_BY    
                       ,CLIC_CREATED_DT    
                       ,@pa_login_name    
                       ,getdate()    
                       ,4    
                       ,CLIC_POST_TOACCT    
                  FROM client_charges_cdsl    
                  WHERE clic_id = convert(numeric,@currstring)     
                  AND clic_deleted_ind = 1    
                --    
                END    
              --    
              END /*CDSL*/    
            --    
            END    
    
            ELSE IF @pa_charge_for = 'D'    
            BEGIN    
            --    
              IF @pa_values = 'NSDL'      
              BEGIN    
              --    
                IF EXISTS(SELECT TOP 1 dpch_id FROM dp_charges_nsdl_mak WHERE dpch_id = convert(numeric,@currstring) AND dpch_deleted_ind = 0 )    
                BEGIN    
                --    
                  DELETE FROM dp_charges_nsdl_mak     
                  WHERE dpch_id = convert(numeric,@currstring)     
                  AND dpch_deleted_ind = 0     
                --    
                END    
                ELSE     
                BEGIN    
                --    
                  INSERT INTO dp_charges_nsdl_mak    
                  (DPCH_ID    
                   ,DPCH_TRANC_DT    
                   ,DPCH_DPM_ID    
                   ,DPCH_CHARGE_NAME    
                   ,DPCH_CHARGE_AMT    
                   ,DPCH_POST_TOACCT    
                   ,DPCH_FLG    
                   ,DPCH_CREATED_BY    
                   ,DPCH_CREATED_DT    
                   ,DPCH_LST_UPD_BY    
                   ,DPCH_LST_UPD_DT    
                   ,DPCH_DELETED_IND    
                  )    
                  SELECT     
                        DPCH_ID    
                       ,DPCH_TRANC_DT    
                       ,DPCH_DPM_ID    
                       ,DPCH_CHARGE_NAME    
                       ,DPCH_CHARGE_AMT    
                       ,DPCH_POST_TOACCT    
                       ,DPCH_FLG    
                       ,DPCH_CREATED_BY    
                       ,DPCH_CREATED_DT    
                       ,@pa_login_name    
                       ,getdate()    
                       ,4    
                 FROM  dp_charges_nsdl    
                 WHERE dpch_id = convert(numeric,@currstring)    
                 AND   dpch_deleted_ind = 1    
                --    
                END    
              --    
              END    
              ELSE  IF @pa_values = 'CDSL'       
              BEGIN    
              --    
                 IF EXISTS(SELECT TOP 1 dpch_id FROM dp_charges_cdsl_mak WHERE dpch_id = convert(numeric,@currstring) AND dpch_deleted_ind = 0 )    
                 BEGIN    
                 --    
                   DELETE FROM dp_charges_cdsl_mak     
                   WHERE dpch_id = convert(numeric,@currstring)     
                   AND dpch_deleted_ind = 0     
                 --    
                 END    
                 ELSE     
                 BEGIN    
                 --    
                   INSERT INTO dp_charges_cdsl_mak    
                   (DPCH_ID    
                    ,DPCH_TRANC_DT    
                    ,DPCH_DPM_ID    
                    ,DPCH_CHARGE_NAME    
                    ,DPCH_CHARGE_AMT    
                    ,DPCH_POST_TOACCT    
                    ,DPCH_FLG    
                    ,DPCH_CREATED_BY    
                    ,DPCH_CREATED_DT    
                    ,DPCH_LST_UPD_BY    
                    ,DPCH_LST_UPD_DT    
                    ,DPCH_DELETED_IND    
                   )    
                   SELECT     
                         DPCH_ID    
                        ,DPCH_TRANC_DT    
                        ,DPCH_DPM_ID    
                        ,DPCH_CHARGE_NAME    
                        ,DPCH_CHARGE_AMT    
                        ,DPCH_POST_TOACCT    
                        ,DPCH_FLG    
                        ,DPCH_CREATED_BY    
                        ,DPCH_CREATED_DT    
                        ,@pa_login_name    
                        ,getdate()    
                        ,4    
                  FROM  dp_charges_cdsl    
                  WHERE dpch_id = convert(numeric,@currstring)    
                  AND   dpch_deleted_ind = 1    
                 --    
                END    
              --    
              END    
             --    
            END    
          --    
          END /*del*/    
    
         IF @pa_action ='APP'    
         BEGIN    
         --    
            IF @pa_charge_for = 'C'    
            BEGIN    
            --    
              IF @pa_values ='NSDL'    
              BEGIN    
              --    
                BEGIN TRANSACTION    
    
                IF EXISTS(SELECT TOP 1 clic_id FROM client_charges_nsdl WHERE  clic_id =convert(numeric,@currstring) AND clic_deleted_ind = 1)    
                BEGIN    
                --    
                  UPDATE client_charges_nsdl    
                  SET     
                      clic_trans_dt  = clicnm.clic_trans_dt    
                     ,clic_dpm_id    = clicnm.clic_dpm_id     
                     ,clic_dpam_id   = clicnm.clic_dpam_id    
                     ,clic_charge_name = clicnm.clic_charge_name    
                     ,clic_charge_amt  = clicnm.clic_charge_amt    
                     ,clic_flg         = clicnm.clic_flg     
                  FROM client_charges_nsdl_mak clicnm    
                  WHERE  clicnm.clic_id = convert(numeric,@currstring)        
                  AND    clicnm.clic_deleted_ind = 6    
                --    
    
                SET @l_error = @@error    
                IF @l_error <> 0    
                BEGIN    
                --    
                  ROLLBACK TRANSACTION     
    
                  SELECT @t_errorstr = @t_errorstr+@currstring+@coldelimiter+convert(varchar(11),clic_trans_dt,103)+@coldelimiter+isnull(clic_charge_name,'')+@COLDELIMITER+ISNULL(clic_charge_amt,'')+@coldelimiter+CONVERT(VARCHAR,@l_error)+@rowdelimiter   
 
                  FROM   client_charges_nsdl_mak    
                  WHERE  clic_id    = convert(numeric,@currstring)    
                  and    clic_deleted_ind  = 0    
                --    
                END    
                ELSE    
                BEGIN    
                --     
                  UPDATE client_charges_nsdl_mak    
                  SET    clic_deleted_ind = 7    
                        ,clic_lst_upd_by = @pa_login_name    
                        ,clic_lst_upd_dt = getdate()    
                  WHERE  clic_id = convert(numeric,@currstring)       
                  AND    clic_deleted_ind = 6    
    
                  COMMIT TRANSACTION    
                --    
                END    
               --     
               END     
               ELSE    
               BEGIN    
               --    
                 INSERT INTO client_charges_nsdl    
                 ( CLIC_ID    
                   ,CLIC_TRANS_DT    
                   ,CLIC_DPM_ID    
                   ,CLIC_DPAM_ID    
                   ,CLIC_CHARGE_NAME    
                   ,CLIC_CHARGE_AMT    
                   ,CLIC_FLG    
                   ,CLIC_CREATED_BY    
                   ,CLIC_CREATED_DT    
                   ,CLIC_LST_UPD_BY    
                   ,CLIC_LST_UPD_DT    
                   ,CLIC_DELETED_IND    
                   ,CLIC_POST_TOACCT    
                )    
                SELECT CLIC_ID    
                      ,CLIC_TRANS_DT    
                      ,CLIC_DPM_ID    
                      ,CLIC_DPAM_ID    
                      ,CLIC_CHARGE_NAME    
                      ,CLIC_CHARGE_AMT    
                      ,CLIC_FLG    
                      ,CLIC_CREATED_BY    
                      ,CLIC_CREATED_DT    
                      ,CLIC_LST_UPD_BY    
                      ,CLIC_LST_UPD_DT    
                      ,1    
                 ,CLIC_POST_TOACCT    
                FROM  client_charges_nsdl_mak    
                WHERE clic_id = convert(numeric,@currstring)       
                AND   clic_deleted_ind = 0    
               --    
               SET @l_error = @@error    
               IF @l_error <> 0    
               BEGIN    
               --    
                 ROLLBACK TRANSACTION     
    
                 SELECT @t_errorstr = @t_errorstr+@currstring+@coldelimiter+convert(varchar(11),clic_trans_dt,103)+@coldelimiter+isnull(clic_charge_name,'')+@COLDELIMITER+ISNULL(clic_charge_amt,'')+@coldelimiter+CONVERT(VARCHAR,@l_error)+@rowdelimiter    
                 FROM   client_charges_nsdl_mak    
                 WHERE  clic_id    = convert(numeric,@currstring)    
                 and    clic_deleted_ind  = 0    
               --    
              END    
               ELSE    
               BEGIN    
               --     
                 UPDATE client_charges_nsdl_mak    
                 SET    clic_deleted_ind = 1    
                       ,clic_lst_upd_by = @pa_login_name    
                       ,clic_lst_upd_dt = getdate()    
                 WHERE  clic_id = convert(numeric,@currstring)       
                 AND    clic_deleted_ind = 0    
    
                 COMMIT TRANSACTION    
               --    
              END    
             --     
             END    
              --    
              END    
              ELSE IF @pa_values ='CDSL'    
              BEGIN    
              --    
                BEGIN TRANSACTION    
    
                IF EXISTS(SELECT TOP 1 clic_id FROM client_charges_cdsl WHERE  clic_id =convert(numeric,@currstring) AND clic_deleted_ind = 1)    
                BEGIN    
                --    
                  UPDATE client_charges_cdsl    
                  SET     
                      clic_trans_dt  = clicnm.clic_trans_dt    
                     ,clic_dpm_id    = clicnm.clic_dpm_id     
                     ,clic_dpam_id   = clicnm.clic_dpam_id    
                     ,clic_charge_name = clicnm.clic_charge_name    
                     ,clic_charge_amt  = clicnm.clic_charge_amt    
                     ,clic_flg         = clicnm.clic_flg     
                  FROM client_charges_cdsl_mak clicnm    
                  WHERE  clicnm.clic_id = convert(numeric,@currstring)        
                  AND    clicnm.clic_deleted_ind = 6    
                --    
    
                SET @l_error = @@error    
                IF @l_error <> 0    
                BEGIN    
                --    
                  ROLLBACK TRANSACTION     
    
                  SELECT @t_errorstr = @t_errorstr+@currstring+@coldelimiter+convert(varchar(11),clic_trans_dt,103)+@coldelimiter+isnull(clic_charge_name,'')+@COLDELIMITER+ISNULL(clic_charge_amt,'')+@coldelimiter+CONVERT(VARCHAR,@l_error)+@rowdelimiter   
 
                  FROM   client_charges_cdsl_mak    
                  WHERE  clic_id    = convert(numeric,@currstring)    
                  and    clic_deleted_ind  = 0    
                --    
                END    
                ELSE    
                BEGIN    
                --     
                  UPDATE client_charges_cdsl_mak    
                  SET    clic_deleted_ind = 7    
                        ,clic_lst_upd_by = @pa_login_name    
                        ,clic_lst_upd_dt = getdate()    
                  WHERE  clic_id = convert(numeric,@currstring)       
                  AND    clic_deleted_ind = 6    
    
                  COMMIT TRANSACTION    
                --    
                END    
               --     
               END     
               ELSE    
               BEGIN    
               --    
                 INSERT INTO client_charges_cdsl    
                 ( CLIC_ID    
                   ,CLIC_TRANS_DT    
                   ,CLIC_DPM_ID    
                   ,CLIC_DPAM_ID    
                   ,CLIC_CHARGE_NAME    
                   ,CLIC_CHARGE_AMT    
                   ,CLIC_FLG    
                   ,CLIC_CREATED_BY    
                   ,CLIC_CREATED_DT    
                   ,CLIC_LST_UPD_BY    
                   ,CLIC_LST_UPD_DT    
                   ,CLIC_DELETED_IND    
                   ,CLIC_POST_TOACCT    
                )    
                SELECT CLIC_ID    
                      ,CLIC_TRANS_DT    
                      ,CLIC_DPM_ID    
                      ,CLIC_DPAM_ID    
                      ,CLIC_CHARGE_NAME    
                      ,CLIC_CHARGE_AMT    
                      ,CLIC_FLG    
                      ,CLIC_CREATED_BY    
                      ,CLIC_CREATED_DT    
                      ,CLIC_LST_UPD_BY    
                      ,CLIC_LST_UPD_DT    
                      ,1    
                      ,CLIC_POST_TOACCT    
                FROM  client_charges_cdsl_mak    
                WHERE clic_id = convert(numeric,@currstring)       
                AND   clic_deleted_ind = 0    
               --    
               SET @l_error = @@error    
               IF @l_error <> 0    
               BEGIN    
               --    
                 ROLLBACK TRANSACTION     
    
                 SELECT @t_errorstr = @t_errorstr+@currstring+@coldelimiter+convert(varchar(11),clic_trans_dt,103)+@coldelimiter+isnull(clic_charge_name,'')+@COLDELIMITER+ISNULL(clic_charge_amt,'')+@coldelimiter+CONVERT(VARCHAR,@l_error)+@rowdelimiter    
                 FROM   client_charges_cdsl_mak    
                 WHERE  clic_id    = convert(numeric,@currstring)    
                 and    clic_deleted_ind  = 0    
               --    
              END    
               ELSE    
               BEGIN    
               --     
                 UPDATE client_charges_cdsl_mak    
                 SET    clic_deleted_ind = 1    
                       ,clic_lst_upd_by = @pa_login_name    
                       ,clic_lst_upd_dt = getdate()    
                 WHERE  clic_id = convert(numeric,@currstring)       
                 AND    clic_deleted_ind = 0    
    
                 COMMIT TRANSACTION    
               --    
              END    
             --     
             END    
              --    
            END /*CDSL*/    
            --    
          END    
           ELSE IF @pa_charge_for = 'D'    
            BEGIN    
            --    
              IF @pa_values ='NSDL'    
              BEGIN    
              --    
                BEGIN TRANSACTION    
    
                IF EXISTS(SELECT TOP 1 dpch_id FROM dp_charges_nsdl WHERE dpch_id = convert(numeric,@currstring) AND dpch_deleted_ind = 1 )    
                BEGIN    
                --    
                  UPDATE dp_charges_nsdl    
                  SET   dpch_tranc_dt    = dpchnm.dpch_tranc_dt    
                       ,dpch_dpm_id      = dpchnm.dpch_dpm_id    
                       ,dpch_charge_name = dpchnm.dpch_charge_name    
                       ,dpch_charge_amt  = dpchnm.dpch_charge_amt    
                       ,dpch_post_toacct = dpchnm.dpch_post_toacct    
                       ,dpch_flg         = dpchnm.dpch_flg    
                       ,dpch_lst_upd_by  = dpchnm.dpch_lst_upd_by    
                       ,dpch_lst_upd_dt  = dpchnm.dpch_lst_upd_dt    
                  FROM dp_charges_nsdl_mak  dpchnm      
                  WHERE dpchnm.dpch_id = convert(numeric,@currstring)    
                  AND   dpchnm.dpch_deleted_ind = 6    
    
                 SET @l_error = @@error    
                 IF @l_error <> 0    
                 BEGIN    
                 --    
                   ROLLBACK TRANSACTION     
    
                   SELECT @t_errorstr = @t_errorstr+@currstring+@coldelimiter+convert(varchar(11),dpch_tranc_dt,103)+@coldelimiter+isnull(dpch_charge_name,'')+@COLDELIMITER+ISNULL(dpch_charge_amt,'')+@COLDELIMITER+ISNULL(dpch_post_toacct,'')+@coldelimiter
  
+CONVERT(VARCHAR,@l_error)+@rowdelimiter    
                   FROM   dp_charges_nsdl_mak    
                   WHERE  dpch_id    = convert(numeric,@currstring)    
                   and    dpch_deleted_ind  = 0    
                 --    
                 END    
                 ELSE    
                 BEGIN    
                 --    
                   UPDATE dp_charges_nsdl_mak     
                   SET    dpch_deleted_ind = 7    
                        , dpch_lst_upd_by  = @pa_login_name    
                        , dpch_lst_upd_dt  = getdate()    
                   WHERE  dpch_id          = convert(numeric,@currstring)    
                   AND    dpch_deleted_ind = 6    
    
                   COMMIT TRANSACTION    
                 --    
                 END    
               --    
               END    
               ELSE    
               BEGIN    
               --    
                    
    
                 INSERT INTO dp_charges_nsdl    
                 (dpch_id    
                 ,dpch_tranc_dt    
                 ,dpch_dpm_id    
                 ,dpch_charge_name    
                 ,dpch_charge_amt    
                 ,dpch_post_toacct    
                 ,dpch_flg    
                 ,dpch_created_by    
                 ,dpch_created_dt    
                 ,dpch_lst_upd_by    
                 ,dpch_lst_upd_dt    
                 ,dpch_deleted_ind    
                )    
                SELECT dpch_id    
                      ,dpch_tranc_dt    
                      ,dpch_dpm_id    
                      ,dpch_charge_name    
                      ,dpch_charge_amt    
                      ,dpch_post_toacct    
                      ,dpch_flg    
                      ,dpch_created_by    
                      ,dpch_created_dt    
                      ,dpch_lst_upd_by    
                      ,dpch_lst_upd_dt    
                      ,1    
                FROM  dp_charges_nsdl_mak         
                WHERE dpch_id  = convert(numeric,@currstring)    
                AND   dpch_deleted_ind = 0    
    
    
                SET @l_error = @@error    
                IF @l_error <> 0    
                BEGIN    
                --    
                  ROLLBACK TRANSACTION     
    
                  SELECT @t_errorstr = @t_errorstr+@currstring+@coldelimiter+convert(varchar(11),dpch_tranc_dt,103)+@coldelimiter+isnull(dpch_charge_name,'')+@COLDELIMITER+ISNULL(dpch_charge_amt,'')+@COLDELIMITER+ISNULL(dpch_post_toacct,'')+@coldelimiter
+  
CONVERT(VARCHAR,@l_error)+@rowdelimiter    
                  FROM   dp_charges_nsdl_mak    
                  WHERE  dpch_id    = convert(numeric,@currstring)    
                  and    dpch_deleted_ind  = 0    
                --    
                END    
                ELSE    
                BEGIN    
                --    
                  UPDATE dp_charges_nsdl_mak     
                  SET    dpch_deleted_ind = 1    
                       , dpch_lst_upd_by  = @pa_login_name    
                       , dpch_lst_upd_dt  = getdate()    
                  WHERE  dpch_id          = convert(numeric,@currstring)    
                  AND    dpch_deleted_ind = 0    
    
                  COMMIT TRANSACTION    
                --    
                END    
               --    
               END    
              --    
              END /*nsdl*/    
              ELSE IF @pa_values ='CDSL'    
              BEGIN    
              --    
                BEGIN TRANSACTION    
    
                IF EXISTS(SELECT TOP 1 dpch_id FROM dp_charges_cdsl WHERE dpch_id = convert(numeric,@currstring) AND dpch_deleted_ind = 1 )    
                BEGIN    
                --    
                  UPDATE dp_charges_cdsl    
                  SET   dpch_tranc_dt    = dpchnm.dpch_tranc_dt    
                       ,dpch_dpm_id      = dpchnm.dpch_dpm_id    
                       ,dpch_charge_name = dpchnm.dpch_charge_name    
                       ,dpch_charge_amt  = dpchnm.dpch_charge_amt    
                       ,dpch_post_toacct = dpchnm.dpch_post_toacct    
                       ,dpch_flg         = dpchnm.dpch_flg    
                       ,dpch_lst_upd_by  = dpchnm.dpch_lst_upd_by    
                       ,dpch_lst_upd_dt  = dpchnm.dpch_lst_upd_dt    
            FROM dp_charges_cdsl_mak  dpchnm      
                  WHERE dpchnm.dpch_id = convert(numeric,@currstring)    
                  AND   dpchnm.dpch_deleted_ind = 6    
    
                 SET @l_error = @@error    
                 IF @l_error <> 0    
                 BEGIN    
                 --    
                   ROLLBACK TRANSACTION     
    
    SELECT @t_errorstr = @t_errorstr+@currstring+@coldelimiter+convert(varchar(11),dpch_tranc_dt,103)+@coldelimiter+isnull(dpch_charge_name,'')+@COLDELIMITER+ISNULL(dpch_charge_amt,'')+@COLDELIMITER+ISNULL(dpch_post_toacct,'')+@coldelimiter+CONVERT(VARCHAR,@l_error)+@rowdelimiter    
                   FROM   dp_charges_cdsl_mak    
                   WHERE  dpch_id    = convert(numeric,@currstring)    
                   and    dpch_deleted_ind  = 0    
                 --    
                 END    
                 ELSE    
                 BEGIN    
                 --    
                   UPDATE dp_charges_cdsl_mak     
                   SET    dpch_deleted_ind = 7    
                        , dpch_lst_upd_by  = @pa_login_name    
                        , dpch_lst_upd_dt  = getdate()    
                   WHERE  dpch_id          = convert(numeric,@currstring)    
                   AND    dpch_deleted_ind = 6    
    
                   COMMIT TRANSACTION    
                 --    
                 END    
               --    
               END    
               ELSE    
               BEGIN    
               --    
                    
    
                 INSERT INTO dp_charges_cdsl    
                 (dpch_id    
                 ,dpch_tranc_dt    
                 ,dpch_dpm_id    
                 ,dpch_charge_name    
                 ,dpch_charge_amt    
                 ,dpch_post_toacct    
                 ,dpch_flg    
                 ,dpch_created_by    
                 ,dpch_created_dt    
                 ,dpch_lst_upd_by    
                 ,dpch_lst_upd_dt    
                 ,dpch_deleted_ind    
                )    
                SELECT dpch_id    
                      ,dpch_tranc_dt    
                      ,dpch_dpm_id    
                      ,dpch_charge_name    
                      ,dpch_charge_amt    
                      ,dpch_post_toacct    
                      ,dpch_flg    
                      ,dpch_created_by    
                      ,dpch_created_dt    
                      ,dpch_lst_upd_by    
                      ,dpch_lst_upd_dt    
                      ,1    
                FROM  dp_charges_cdsl_mak         
                WHERE dpch_id  = convert(numeric,@currstring)    
                AND   dpch_deleted_ind =0    
    
    
                SET @l_error = @@error    
                IF @l_error <> 0    
                BEGIN    
                --    
                  ROLLBACK TRANSACTION     
    
                  SELECT @t_errorstr = @t_errorstr+@currstring+@coldelimiter+convert(varchar(11),dpch_tranc_dt,103)+@coldelimiter+isnull(dpch_charge_name,'')+@COLDELIMITER+ISNULL(dpch_charge_amt,'')+@COLDELIMITER+ISNULL(dpch_post_toacct,'')+@coldelimiter+
  
CONVERT(VARCHAR,@l_error)+@rowdelimiter    
                  FROM   dp_charges_cdsl_mak    
                  WHERE  dpch_id    = convert(numeric,@currstring)    
                  and    dpch_deleted_ind  = 0    
                --    
                END    
                ELSE    
                BEGIN    
                --    
                  UPDATE dp_charges_cdsl_mak     
                  SET    dpch_deleted_ind = 1    
                       , dpch_lst_upd_by  = @pa_login_name    
                       , dpch_lst_upd_dt  = getdate()    
                  WHERE  dpch_id          = convert(numeric,@currstring)    
                  AND    dpch_deleted_ind = 0    
    
                  COMMIT TRANSACTION    
                --    
                END    
               --    
               END    
              --    
              END /*cdsl*/    
            --    
            END    
         --    
         END    
    
     IF @pa_action ='REJ'    
         BEGIN    
         --    
             IF @pa_charge_for = 'C'    
             BEGIN    
             --    
               IF @pa_values = 'NSDL'    
               BEGIN    
               --    
                 UPDATE client_charges_nsdl_mak    
                 SET clic_deleted_ind = 3    
                     ,clic_lst_upd_by  = @pa_login_name    
                     ,clic_lst_upd_dt  = getdate()    
                 WHERE clic_id   = convert(numeric,@currstring)        
                 AND   clic_deleted_ind in (0,4,6)    
              --    
              END    
              ELSE IF @pa_values = 'CDSL'    
              BEGIN    
              --    
                UPDATE client_charges_cdsl_mak    
                SET clic_deleted_ind = 3    
                    ,clic_lst_upd_by  = @pa_login_name    
                    ,clic_lst_upd_dt  = getdate()    
                WHERE clic_id   = convert(numeric,@currstring)        
                AND   clic_deleted_ind in (0,4,6)    
              --    
              END    
             --    
             END    
             ELSE IF @pa_charge_for = 'D'    
             BEGIN    
             --    
                IF @pa_values ='NSDL'    
                 BEGIN    
                 --    
                   UPDATE dp_charges_nsdl_mak    
                   SET dpch_deleted_ind = 3    
                       ,dpch_lst_upd_by  = @pa_login_name    
                       ,dpch_lst_upd_dt  = getdate()     
                   WHERE dpch_id     = convert(numeric,@currstring)      
                   AND   dpch_deleted_ind in (0,4,6)    
                 --    
                 END    
                 ELSE IF @pa_values ='CDSL'    
                 BEGIN    
                 --    
                   UPDATE dp_charges_cdsl_mak    
                   SET dpch_deleted_ind = 3    
                       ,dpch_lst_upd_by  = @pa_login_name    
                       ,dpch_lst_upd_dt  = getdate()     
                   WHERE dpch_id     = convert(numeric,@currstring)      
                   AND   dpch_deleted_ind in (0,4,6)    
                 --    
                 END    
             --    
             END    
         --    
         END    
    
        --    
        END /*end makerchkr*/    
       --    
       END    
--    
END    
      
 SET @pa_errmsg = @t_errorstr    
--    
END

GO
