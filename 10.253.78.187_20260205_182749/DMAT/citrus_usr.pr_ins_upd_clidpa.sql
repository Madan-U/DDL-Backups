-- Object: PROCEDURE citrus_usr.pr_ins_upd_clidpa
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--pr_ins_upd_clidpa '1','INS','SS',82,'1|*~|10|*~|A2504071|*~|SB001|*~|SUKHVINDER SINGH KAUSHAL|*~|11|*~|A001|*~|1|*~|1|*~||*~|A*|~*1|*~|11|*~|A2504072|*~|SB002|*~|SUKHVINDER SINGH KAUSHAL|*~|9|*~|A002|*~|1|*~|0|*~||*~|A*|~*1|*~|1|*~|A2504073|*~|SB003|*~|SUKHVINDER SINGH KAUSHAL|*~|42|*~|A003|*~|0|*~|1|*~||*~|A*|~*',2,'*|~*','|*~|',''   
CREATE      PROCEDURE [citrus_usr].[pr_ins_upd_clidpa] ( @pa_id            varchar(8000)  
                                  , @pa_action        varchar(20)  
                                  , @pa_login_name    varchar(20)  
                                  , @pa_ent_id        numeric  
                                  , @pa_values        varchar(8000)  
                                  , @pa_chk_yn        numeric  
                                  , @rowdelimiter     char(4)  =  '*|~*'  
                                  , @coldelimiter     char(4)  = '|*~|'  
                                  , @pa_msg           varchar(8000) output  
                                  )  
AS  
/*  
*********************************************************************************  
 system              : class  
 module name         : pr_ins_upd_clidpa  
 description         :  
 copyright(c)        : enc software solutions pvt. ltd.  
 version history     : 1.0  
 VERS.  AUTHOR            DATE               REASON  
 -----  -------------     ----------         ---------------------------------------------  
 2.0    sukhvinder/tushar 05-dec-2006        initial version.  
-----------------------------------------------------------------------------------*/  
BEGIN  
--  
  DECLARE @delimeter             varchar(10)  
        , @l_counter              int  
        , @@t_errorstr            varchar(8000)  
        , @@remainingstring_id    varchar(8000)  
        , @@currstring_id         varchar(8000)  
        , @@remainingstring_value varchar(8000)  
        , @@currstring_value      varchar(8000)  
        , @@foundat_id            integer  
        , @@foundat_value         integer  
        , @@delimeterlength       int  
        --  
        , @@l_clidpa_id           numeric  
        , @@l_cliddpa_id          numeric   
        , @@l_clidpa_dpm_id       numeric  
        , @@l_clidpa_clisba_id    numeric  
        , @@l_compm_id            numeric  
        , @@l_clidpa_dp_id        varchar(20)  
        , @@l_clidpa_name         varchar(50)  
        , @@l_def_flg             int  
        , @@l_poa_type            varchar(20)  
        , @@l_clidpa_deleted_ind  int  
        --  
        , @@l_clisba_id           numeric   
        , @@l_excsm_id            numeric  
        , @@l_clidpa_acct_no      varchar(25)  
        , @@l_sub_acct_no         varchar(25)  
        , @@l_poa_flg             int  
        , @@l_action_type         varchar(10)  
        , @@l_bitrm_bit_location  int  
        , @l_error                int  
        , @@l_clidpa_flg          int  
        --  
        , @@l_clidpa_dp_id_old    numeric  
        , @@l_clidpa_name_old     varchar(50)  
        , @@l_poa_flg_old         int  
        , @@l_def_flg_old         int  
        , @@l_poa_type_old        varchar(10)  
        , @l_action               char(1)  
        , @l_crn_no               varchar(10)   
        ,@L_EDT_DEL_ID            NUMERIC   
  
       --  
      /* , @l_clisba_acct_no  VARCHAR(25)   
       , @l_clisba_no          VARCHAR(25)   
       , @l_clisba_id           NUMERIC    
       , @l_clisba_crn_no    numeric*/  
       --   
  --  
  SET @l_crn_no               = CONVERT(varchar, @pa_ent_id)  
  SET @l_counter              = 1  
  SET @@t_errorstr            = ''  
  SET @@l_clidpa_flg          = 0  
  --  
  SET @delimeter              = '%'+ @rowdelimiter + '%'  
  SET @@delimeterlength       = len(@rowdelimiter)  
  SET @@remainingstring_id    = @pa_id  
  SET @@remainingstring_value = @pa_values   
  --  
  IF @pa_action = 'APP' or @pa_action = 'REJ'  
  BEGIN--A  
  --  
    CREATE TABLE #t_mak  
    (clidpa_id           numeric(10)  
    ,clidpa_dpm_id       numeric(10)  
    ,clidpa_clisba_id    numeric(10)  
    ,clidpa_compm_id     numeric(10)  
    ,clidpa_dp_id        varchar(20)  
    ,clidpa_name         varchar(50)  
    ,clidpa_flg          int  
    ,clidpa_poa_type     varchar(20)  
    ,clidpa_created_by   varchar(25)  
    ,clidpa_deleted_ind  int   
    )  
    --  
    INSERT INTO #t_mak  
    (clidpa_id          
    ,clidpa_dpm_id      
    ,clidpa_clisba_id   
    ,clidpa_compm_id    
    ,clidpa_dp_id       
    ,clidpa_name        
    ,clidpa_flg         
    ,clidpa_poa_type    
    ,clidpa_created_by  
    ,clidpa_deleted_ind  
    )  
    SELECT clidpa_id          
         , clidpa_dpm_id      
         , clidpa_clisba_id   
         , clidpa_compm_id    
         , clidpa_dp_id       
         , clidpa_name        
         , clidpa_flg         
         , clidpa_poa_type    
         , clidpa_created_by  
         , clidpa_deleted_ind  
    FROM   client_dp_accts_mak  
    WHERE  clidpa_deleted_ind IN (0,4,8)  
    --AND    clidpa_created_by  <> @pa_login_name  
  --                           
  END --A                           
  ELSE  
  BEGIN--B  
  --  
    CREATE TABLE #t_mstr(clidpa_dpm_id       numeric  
                        ,clidpa_clisba_id    numeric  
                        ,clidpa_compm_id     numeric  
                        ,clidpa_dp_id        varchar(25)  
                        ,clisba_acct_no      varchar(25)  
                        ,clidpa_name         varchar(50)  
                        ,clidpa_flg          int  
                        ,clidpa_poa_type     varchar(20)  
                        ,clidpa_deleted_ind  smallint  
                        )  
    --                           
    INSERT INTO #t_mstr  
    (clidpa_dpm_id  
    ,clidpa_clisba_id  
    ,clidpa_compm_id  
    ,clidpa_dp_id  
    ,clisba_acct_no  
    ,clidpa_name  
    ,clidpa_flg  
    ,clidpa_poa_type  
    ,clidpa_deleted_ind  
    )  
    SELECT clidpa.clidpa_dpm_id         clidpa_dpm_id  
          ,clidpa.clidpa_clisba_id      clidpa_clisba_id  
          ,clidpa.clidpa_compm_id       clidpa_compm_id  
          ,clidpa.clidpa_dp_id          clidpa_dp_id  
          ,clisba.clisba_acct_no        clisba_acct_no  
          ,clidpa.clidpa_name           clidpa_name  
          ,clidpa.clidpa_flg            clidpa_flg  
          ,clidpa.clidpa_poa_type       clidpa_poa_type  
          ,clidpa.clidpa_deleted_ind    clidpa_deleted_ind  
    FROM   client_dp_accts              clidpa  WITH (NOLOCK)  
          ,client_sub_accts             clisba  WITH (NOLOCK)  
    WHERE  clidpa.clidpa_clisba_id    = clisba.clisba_id  
    AND    clisba.clisba_crn_no       = @pa_ent_id  
    AND    clidpa.clidpa_deleted_ind  = 1  
    AND    clisba.clisba_deleted_ind  = 1  
  --  
  END--B  
  --  
  WHILE @@remainingstring_id <> ''  
  BEGIN--rem_id  
  --  
    SET @@foundat_id           = 0  
    SET @@foundat_id           =  patindex('%'+@delimeter+'%', @@remainingstring_id)  
  
    IF @@foundat_id > 0  
    BEGIN  
    --  
      SET @@currstring_id      = substring(@@remainingstring_id, 0, @@foundat_id)  
      SET @@remainingstring_id = substring(@@remainingstring_id, @@foundat_id+@@delimeterlength, len(@@remainingstring_id) - @@foundat_id+@@delimeterlength)  
    --  
    END  
    --  
    ELSE  
    BEGIN  
    --  
      SET @@currstring_id      = @@remainingstring_id  
      SET @@remainingstring_id = ''  
    --  
    END  
    --  
    IF @@currstring_id <> ''  
    BEGIN--@@currstring_id<>''  
    --  
      IF ISNULL(@pa_action,'') <> ''   
      BEGIN--Action <> ''    
      --  
        WHILE @@remainingstring_value <> ''  
        BEGIN--rem_val  
        --  
          SET @@foundat_value = 0  
          SET @@foundat_value =  patindex('%'+@delimeter+'%', @@remainingstring_value)  
  
          IF @@foundat_value > 0  
          BEGIN  
          --  
            SET @@currstring_value      = substring(@@remainingstring_value, 0, @@foundat_value)  
            SET @@remainingstring_value = substring(@@remainingstring_value, @@foundat_value+@@delimeterlength, len(@@remainingstring_value) - @@foundat_value+@@delimeterlength)  
          --  
          END  
          ELSE  
          BEGIN  
          --  
            SET @@currstring_value      = @@remainingstring_value  
            SET @@remainingstring_value = ''  
          --  
          END  
          --    
          IF @@currstring_value <> ''  
          BEGIN --@@currstring_value<>''  
          --  
            SET @@l_compm_id                 = citrus_usr.fn_splitval(@@currstring_value, 1)  
            SET @@l_excsm_id                 = citrus_usr.fn_splitval(@@currstring_value, 2)  
            SET @@l_clidpa_acct_no           = citrus_usr.fn_splitval(@@currstring_value, 3)  
            SET @@l_sub_acct_no              = citrus_usr.fn_splitval(@@currstring_value, 4)  
            SET @@l_clidpa_name              = citrus_usr.fn_splitval(@@currstring_value, 5)  
            SET @@l_clidpa_dpm_id            = citrus_usr.fn_splitval(@@currstring_value, 6)  
            SET @@l_clidpa_dp_id             = citrus_usr.fn_splitval(@@currstring_value, 7)  
            SET @@l_def_flg                  = CONVERT(NUMERIC,citrus_usr.fn_splitval(@@currstring_value, 8))  
            SET @@l_poa_flg                  = CONVERT(NUMERIC,citrus_usr.fn_splitval(@@currstring_value, 9))  
            SET @@l_poa_type                 = citrus_usr.fn_splitval(@@currstring_value, 10)  
            SET @@l_action_type              = citrus_usr.fn_splitval(@@currstring_value, 11)  
            --  
              
            SET  @@l_clisba_id = NULL  
              
            SELECT @@l_clisba_id      = clisba_id  
            FROM   client_sub_accts   WITH (NOLOCK)  
                 , exch_seg_mstr      WITH (NOLOCK)  
                 , excsm_prod_mstr    WITH (NOLOCK)  
                 , product_mstr       WITH (NOLOCK)  
            WHERE  clisba_crn_no      = @pa_ent_id  
            AND    clisba_acct_no     = @@l_clidpa_acct_no  
            AND    clisba_no          = @@l_sub_acct_no  
            AND    excpm_excsm_id     = excsm_id  
            AND    excpm_prom_id      = prom_id  
            AND    excsm_id           = @@l_excsm_id  
            AND    excpm_id           = clisba_excpm_id  
            AND    prom_cd           = right(@@l_sub_acct_no,2)  
              
              
              
            AND    clisba_deleted_ind = 1  
            --  
            IF @PA_CHK_YN = 0  
            BEGIN--CHK_YN_0  
            --  
              IF @@l_action_type = 'A'  
              BEGIN--A  
              --  
                BEGIN TRANSACTION  
                --  
                IF @@l_poa_flg = 1  
                BEGIN  
                --  
                  SELECT @@l_bitrm_bit_location = bitrm_bit_location  
                  FROM   bitmap_ref_mstr WITH (NOLOCK)  
                  WHERE  bitrm_parent_cd        = 'DEPOSITORY'  
                  AND    bitrm_child_cd         = 'POA_FLG'  
                  --  
                  SET @@l_clidpa_flg = power(2,@@l_bitrm_bit_location-1) | @@l_clidpa_flg  
                --  
                END  
                --  
                IF @@l_def_flg = 1  
                BEGIN  
                --  
                  SELECT @@l_bitrm_bit_location = bitrm_bit_location  
                  FROM   bitmap_ref_mstr WITH (NOLOCK)  
                  WHERE  bitrm_parent_cd        = 'DEPOSITORY'  
                  AND    bitrm_child_cd         = 'DEF_FLG'  
                  --  
                  SET @@l_clidpa_flg = power(2, @@l_bitrm_bit_location-1) | @@l_clidpa_flg  
                --  
                END  
                --  
                INSERT INTO client_dp_accts  
                (clidpa_dpm_id  
                ,clidpa_clisba_id  
                ,clidpa_compm_id  
                ,clidpa_dp_id  
                ,clidpa_name  
                ,clidpa_flg  
                ,clidpa_poa_type  
                ,clidpa_created_by  
                ,clidpa_created_dt  
                ,clidpa_lst_upd_by  
                ,clidpa_lst_upd_dt  
                ,clidpa_deleted_ind  
                )  
                VALUES  
                (@@l_clidpa_dpm_id  
                ,@@l_clisba_id  
                ,@@l_compm_id  
                ,@@l_clidpa_dp_id  
                ,@@l_clidpa_name  
                ,@@l_clidpa_flg  
                ,@@l_poa_type  
                ,@pa_login_name  
                ,GETDATE()  
                ,@pa_login_name  
                ,GETDATE()  
                ,1  
                )  
                --  
                SET @l_error = @@ERROR  
                --  
                IF @l_error > 0  
                BEGIN  
                --  
                  SET @@t_errorstr = '#'+'Could Not Change Access For ' + convert(varchar, @@l_clidpa_name) + isnull(@@t_errorstr,'')  
                  --  
                  ROLLBACK TRANSACTION  
                --  
                END  
                ELSE  
                BEGIN  
                --  
                  COMMIT TRANSACTION  
                  --  
                  SET @@t_errorstr = 'DP-Accounts Successfully Inserted/Edited '+ @rowdelimiter  
                --  
                END  
              --  
              END--A  
              --  
              IF @@l_action_type = 'E'  
              BEGIN--e_0  
              --  
                SELECT @@l_clidpa_dp_id_old  = clidpa_dp_id  
                     , @@l_clidpa_name_old   = clidpa_name  
                     , @@l_poa_flg_old       = clidpa_flg & 1  
                     , @@l_def_flg_old       = clidpa_flg & 2  
                     , @@l_poa_type_old      = clidpa_poa_type  
                FROM   #t_mstr  
                WHERE  clidpa_dpm_id         = @@l_clidpa_dpm_id  
                AND    clidpa_clisba_id      = @@l_sub_acct_no  
                AND    clidpa_compm_id       = @@l_compm_id  
                --  
                IF (@@l_clidpa_dp_id_old     <> @@l_clidpa_dp_id)  
                   AND (@@l_clidpa_name_old  <> @@l_clidpa_name)  
                   AND (@@l_poa_flg_old      <> @@l_poa_flg)  
                   AND (@@l_def_flg_old      <> @@l_def_flg)  
                   AND (@@l_poa_type_old     <> @@l_poa_type)  
                BEGIN --NOT_EXIST  
                --  
                  BEGIN TRANSACTION  
                  --  
                  IF @@L_POA_FLG = 1  
                  BEGIN  
                  --  
                    SELECT @@l_bitrm_bit_location = bitrm_bit_location  
                    FROM   bitmap_ref_mstr WITH (NOLOCK)  
                    WHERE  bitrm_parent_cd        = 'DEPOSITORY'  
                    AND    bitrm_child_cd         = 'POA_FLG'  
                    --  
                    SET @@l_clidpa_flg            = power(2, @@l_bitrm_bit_location-1) | @@l_clidpa_flg  
                  --  
                  END  
                  --  
                  IF @@L_DEF_FLG = 1  
                  BEGIN  
                  --  
                    SELECT @@l_bitrm_bit_location = bitrm_bit_location  
                    FROM   bitmap_ref_mstr WITH (NOLOCK)  
                    WHERE  bitrm_parent_cd        = 'DEPOSITORY'  
                    AND    bitrm_child_cd         = 'DEF_FLG'  
                    --  
                    SET @@l_clidpa_flg            = power(2, @@l_bitrm_bit_location - 1) | @@l_clidpa_flg  
                  --  
                  END  
                  --  
                  INSERT INTO client_dp_accts  
                  (clidpa_dpm_id  
                  ,clidpa_clisba_id  
                  ,clidpa_compm_id  
                  ,clidpa_dp_id  
                  ,clidpa_name  
                  ,clidpa_flg  
                  ,clidpa_poa_type  
                  ,clidpa_created_by  
                  ,clidpa_created_dt  
                  ,clidpa_lst_upd_by  
                  ,clidpa_lst_upd_dt  
                  ,clidpa_deleted_ind  
                  )  
                  VALUES  
                  (@@l_clidpa_dpm_id  
                  ,@@l_clisba_id  
                  ,@@l_compm_id  
                  ,@@l_clidpa_dp_id  
                  ,@@l_clidpa_name  
                  ,@@l_clidpa_flg  
                  ,@@l_poa_type  
                  ,@pa_login_name  
                  ,GETDATE()  
                  ,@pa_login_name  
                  ,GETDATE()  
                  ,1  
                  )  
                  --  
                  SET @l_error = @@error  
                  --  
                  IF @l_error > 0  
                  BEGIN  
                  --  
                    SET @@t_errorstr = '#'+'Could not change access for ' + CONVERT(VARCHAR, @@L_CLIDPA_NAME) + ISNULL(@@T_ERRORSTR,'')  
                    --  
                    ROLLBACK TRANSACTION  
                  --  
                  END  
                  ELSE  
                  BEGIN  
                  --  
                    COMMIT TRANSACTION  
                    --  
                    SET @@t_errorstr = 'DP-Accounts Successfully Inserted/Edited '+ @ROWDELIMITER  
                  --  
                  END  
                --  
                END  --NOT_EXIST  
                ELSE  
                BEGIN --EXIST  
                --  
                  BEGIN TRANSACTION  
                  --  
                  IF @@L_POA_FLG = 1  
                  BEGIN  
                  --  
                    SELECT @@l_bitrm_bit_location = bitrm_bit_location  
                    FROM   bitmap_ref_mstr WITH(NOLOCK)  
                    WHERE  bitrm_parent_cd        = 'DEPOSITORY'  
                    AND    bitrm_child_cd         = 'POA_FLG'  
                    --  
                    SET @@l_clidpa_flg            = @@l_bitrm_bit_location | @@l_clidpa_flg  
                  --  
                  END  
  
                  IF @@L_DEF_FLG = 1  
                  BEGIN  
                  --  
                    SELECT @@l_bitrm_bit_location = bitrm_bit_location  
                    FROM   bitmap_ref_mstr WITH(NOLOCK)  
                    WHERE  bitrm_parent_cd        = 'DEPOSITORY'  
                    AND    bitrm_child_cd         = 'DEF_FLG'  
                    --  
                    SET @@l_clidpa_flg = @@l_bitrm_bit_location | @@l_clidpa_flg  
                  --  
                  END  
                  --  
                  UPDATE client_dp_accts   WITH(ROWLOCK)  
                  SET    clidpa_name        = @@l_clidpa_name  
                       , clidpa_flg         = @@l_clidpa_flg  
                       , clidpa_poa_type    = @@l_poa_type  
                       , clidpa_lst_upd_by  = @pa_login_name  
                       , clidpa_lst_upd_dt  = GETDATE()  
                  WHERE  clidpa_dpm_id      = @@l_clidpa_dpm_id  
                  AND    clidpa_clisba_id   = @@l_clisba_id  
                  AND    clidpa_dp_id       = @@l_clidpa_dp_id  
                  AND    clidpa_compm_id    = @@l_compm_id  
                  AND    clidpa_deleted_ind = 1  
                  --  
                  DELETE FROM #t_mstr  
                  WHERE  clidpa_dpm_id      = @@l_clidpa_dpm_id  
                  AND    clidpa_clisba_id   = @@l_clidpa_clisba_id  
                  AND    clidpa_compm_id    = @@l_compm_id  
                  AND    clidpa_dp_id       = @@l_clidpa_dp_id  
                  AND    clidpa_deleted_ind = 1  
                  --  
                  SET @l_error = @@ERROR  
                  --   
                  IF @l_error > 0  
                  BEGIN  
                  --  
                    SET @@t_errorstr = '#'+'Could not change access for ' + convert(varchar, @@l_clidpa_name) + isnull(@@t_errorstr,'')  
                    --  
                    ROLLBACK TRANSACTION  
                  --  
                  END  
                  ELSE  
                  BEGIN  
                  --  
                    COMMIT TRANSACTION  
                    --  
                    SET @@t_errorstr = 'DP-Accounts Successfully Inserted/Edited '+ @rowdelimiter  
                  --  
                  END  
                --  
                END --EXIST     
              --  
              END--e_0  
              --  
            IF @@l_action_type = 'D'   
              BEGIN--d_0  
              --  
                BEGIN TRANSACTION  
                --  
                UPDATE client_dp_accts   WITH(ROWLOCK)  
                SET    clidpa_deleted_ind  = 0  
                     , clidpa_lst_upd_by   = @pa_login_name  
                     , clidpa_lst_upd_dt   = GETDATE()  
                WHERE  clidpa_dpm_id       = @@l_clidpa_dpm_id  
                AND    clidpa_clisba_id    = @@l_clisba_id  
                AND    clidpa_compm_id     = @@l_compm_id  
                AND    clidpa_dp_id        = @@l_clidpa_dp_id  
                AND    clidpa_deleted_ind  = 1  
                --  
                SET @l_error = @@ERROR  
                --   
                IF @l_error > 0  
                BEGIN  
                --  
                  SET @@t_errorstr = '#'+'Could not change access for ' + convert(varchar, @@l_clidpa_name) + isnull(@@t_errorstr,'')  
                  --  
                  ROLLBACK TRANSACTION  
                --  
                END  
                ELSE  
                BEGIN  
                --  
                  COMMIT TRANSACTION  
                  --  
                  SET @@t_errorstr = 'DP-Accounts Successfully Inserted/Edited '+ @rowdelimiter  
                --  
                END  
              --  
              END  --d_0  
            --  
            END--chk_yn_0  
            --  
            IF @PA_CHK_YN = 1 OR @PA_CHK_YN = 2  
            BEGIN--CHK_YN_1  
            --  
              IF ISNULL(@@l_clisba_id, 0) = 0  
              BEGIN  
              --  
                SELECT @@l_clisba_id      = clisba_id  
				            FROM   client_sub_accts_mak   WITH (NOLOCK)  
				                 , exch_seg_mstr      WITH (NOLOCK)  
				                 , excsm_prod_mstr    WITH (NOLOCK)  
				                 , product_mstr       WITH (NOLOCK)  
				            WHERE  clisba_crn_no      = @pa_ent_id  
				            AND    clisba_acct_no     = @@l_clidpa_acct_no  
				            AND    clisba_no          = @@l_sub_acct_no  
				            AND    excpm_excsm_id     = excsm_id  
				            AND    excpm_prom_id      = prom_id  
				            AND    excsm_id           = @@l_excsm_id  
				            AND    excpm_id           = clisba_excpm_id  
				            AND    prom_cd           = right(@@l_sub_acct_no,2)  
                AND    clisba_deleted_ind in (0,4,8) 
              --    
              END  
              --   
              IF @@l_action_type IN ('A','E')   
              BEGIN--A_E  
              --  
                IF @@l_poa_flg = 1  
                BEGIN  
                --  
                  SELECT @@l_bitrm_bit_location = bitrm_bit_location  
                  FROM   bitmap_ref_mstr WITH (NOLOCK)  
                  WHERE  bitrm_parent_cd        = 'DEPOSITORY'  
                  AND    bitrm_child_cd         = 'POA_FLG'  
                  --  
                  SET @@l_clidpa_flg            =  POWER(2,@@l_bitrm_bit_location-1) | @@l_clidpa_flg  
                --  
                END  
                --  
                IF @@l_def_flg = 1  
                BEGIN  
                --  
                  SELECT @@l_bitrm_bit_location = bitrm_bit_location  
                  FROM   bitmap_ref_mstr  WITH (NOLOCK)  
                  WHERE  bitrm_parent_cd        = 'DEPOSITORY'  
                  AND    bitrm_child_cd         = 'DEF_FLG'  
                  --  
                  SET @@l_clidpa_flg            =  POWER(2, @@l_bitrm_bit_location-1) | @@l_clidpa_flg  
                --  
                END  
              --  
              END--A_E  
              --  
              IF @@l_action_type IN ('A','D','E')  
              BEGIN--A_D_E  
              --  
                IF EXISTS(SELECT clidpa_id  
                          FROM   client_dp_accts_mak  WITH (NOLOCK)  
                          WHERE  clidpa_dpm_id        = @@l_clidpa_dpm_id  
                          AND    clidpa_clisba_id     = @@l_clisba_id  
                          AND    clidpa_compm_id      = @@l_compm_id  
                          AND    clidpa_deleted_ind  IN (0,4,8)   
                         )  
                BEGIN--exists  
                --  
                  BEGIN TRANSACTION  
                  --  
                  UPDATE client_dp_accts_mak  WITH (ROWLOCK)   
                  SET    clidpa_deleted_ind   = 3  
                       , clidpa_lst_upd_by    = @pa_login_name  
                       , clidpa_lst_upd_dt    = GETDATE()   
                  WHERE  clidpa_dpm_id        = @@l_clidpa_dpm_id  
                  AND    clidpa_clisba_id        = @@l_clisba_id  
                  AND    clidpa_compm_id      = @@l_compm_id  
                  AND    clidpa_deleted_ind  IN (0,4,8)  
                  --  
                  SET @l_error = @@error  
                  --  
                  IF @l_error > 0  
                  BEGIN  
                  --  
                    SET @@t_errorstr = '#'+'Could Not Change Access For ' + convert(varchar, @@l_clidpa_name) + isnull(@@t_errorstr,'')  
                    --  
                    ROLLBACK TRANSACTION  
                  --  
                  END  
                  ELSE  
                  BEGIN  
                  --  
                    COMMIT TRANSACTION  
                    --  
                    SET @@t_errorstr = 'Dp-accounts Successfully Inserted/Edited '+ @rowdelimiter  
                  --  
                  END  
                --  
                END  --exists  
                --  
                SELECT @@l_clidpa_id = ISNULL(MAX(clidpa_id),0) + 1  
                FROM   client_dp_accts_mak WITH (NOLOCK)  
                --  
                BEGIN TRANSACTION  
                --  
  
                IF EXISTS(SELECT clidpa_clisba_id FROM CLIENT_DP_ACCTS WHERE clidpa_clisba_id = @@l_clisba_id AND clidpa_dpm_id = @@l_clidpa_dpm_id)  
                BEGIN  
                --  
                  SET @L_EDT_DEL_ID = 8  
                --  
                END  
                ELSE  
                BEGIN  
                --  
                  SET @L_EDT_DEL_ID = 0  
                --  
                END  
                INSERT INTO client_dp_accts_mak  
                (clidpa_id  
                ,clidpa_dpm_id  
                ,clidpa_clisba_id  
                ,clidpa_compm_id  
                ,clidpa_dp_id  
                ,clidpa_name  
                ,clidpa_flg  
                ,clidpa_poa_type  
                ,clidpa_created_by  
                ,clidpa_created_dt  
                ,clidpa_lst_upd_by  
                ,clidpa_lst_upd_dt  
                ,clidpa_deleted_ind  
                )  
                VALUES  
                (@@l_clidpa_id  
                ,@@l_clidpa_dpm_id  
                ,@@l_clisba_id  
                ,@@l_compm_id  
                ,@@l_clidpa_dp_id  
                ,@@l_clidpa_name  
                ,@@l_clidpa_flg  
                ,@@l_poa_type  
                ,@pa_login_name  
                ,GETDATE()  
                ,@pa_login_name  
                ,GETDATE()  
                ,CASE @@l_action_type WHEN 'A' then 0  
                                      WHEN 'E' then @L_EDT_DEL_ID                       
                                      WHEN 'D' then 4  
                                      END  
                )  
                --  
                SET @l_error = @@error  
                --  
                IF @l_error > 0  
                BEGIN  
                --  
                  SET @@t_errorstr = '#'+'Could not change access for ' + CONVERT(VARCHAR, @@l_clidpa_name) + ISNULL(@@t_errorstr,'')  
                  --  
                  ROLLBACK TRANSACTION  
                --  
                END  
                ELSE  
                BEGIN  
                --  
                  SELECT @l_action = CASE @@l_action_type WHEN 'A' THEN 'I' WHEN 'E' THEN 'E' WHEN 'D' THEN 'D' END  
                  --  
                  EXEC pr_ins_upd_list @l_crn_no, @l_action,'Client DP Accts',@pa_login_name,'*|~*','|*~|',''   
                  --  
                  SET @@t_errorstr = 'Dp-Accounts Successfully Inserted/Edited '+ @rowdelimiter  
                  --  
                  COMMIT TRANSACTION  
                --  
                END  
              --  
              END--A_D_E  
            --  
            END  --CHK_YN_1  
          --  
          END   --@@currstring_value<>''  
        --    
        END--rem_val  
      --  
      END--Action <> ''    
      --  
      IF ISNULL(@@l_action_type,'') = ''   
      BEGIN--ACTION_TYPE=''    
      --  
        SET @@l_clidpa_dpm_id         = NULL  
        SET @@l_clidpa_clisba_id      = NULL  
        SET @@l_compm_id              = NULL  
        SET @@l_clidpa_dp_id          = NULL  
        SET @@l_clidpa_name           = NULL  
        SET @@l_def_flg               = NULL  
        SET @@l_poa_type              = NULL  
        SET @@l_clidpa_deleted_ind    = NULL  
        --        
        SELECT @@l_clidpa_dpm_id      = clidpa_dpm_id      
             , @@l_clidpa_clisba_id   = clidpa_clisba_id   
             , @@l_compm_id           = clidpa_compm_id    
             , @@l_clidpa_dp_id       = clidpa_dp_id       
             , @@l_clidpa_name        = clidpa_name        
             , @@l_def_flg            = clidpa_flg         
             , @@l_poa_type           = clidpa_poa_type    
             , @@l_clidpa_deleted_ind = clidpa_deleted_ind  
        FROM   #t_mak  
        WHERE  clidpa_id              = CONVERT(NUMERIC, @@currstring_id)  
        --   
        IF @PA_ACTION = 'REJ'  
        BEGIN--REJ  
        --  
          --BEGIN TRANSACTION  
          --  
          UPDATE client_dp_accts_mak    WITH(ROWLOCK)  
          SET    clidpa_deleted_ind   = 3  
               , clidpa_lst_upd_by    = @pa_login_name  
               , clidpa_lst_upd_dt    = GETDATE()  
          WHERE  clidpa_id            = CONVERT(NUMERIC, @@currstring_id)  
          AND    clidpa_deleted_ind  IN (0,4,8)  
          --  
          SET @l_error = @@ERROR  
          --  
          IF @l_error > 0  
          BEGIN  
          --  
            --SET @@t_errorstr = 'Could Not Change Access For ' + CONVERT(VARCHAR, @@l_clidpa_name) + ISNULL(@@t_errorstr,'')  
            --  
            --ROLLBACK TRANSACTION  
            SET @@t_errorstr = CONVERT(VARCHAR(10), @l_error)  
          --  
          END  
          --ELSE  
          --BEGIN  
          --  
          --  SET @@t_errorstr = 'Client DP Account Successfully Inserted\Edited '+ @rowdelimiter  
            --  
          --  COMMIT TRANSACTION  
          --  
          --END  
        --  
        END--REJ  
        --  
        IF @pa_action = 'APP'  
        BEGIN--APP  
        --  
          IF @@l_clidpa_deleted_ind    = 4  
          BEGIN--4  
          --  
             
            --  
            UPDATE client_dp_accts_mak WITH(ROWLOCK)  
            SET    clidpa_deleted_ind  = 5  
                 , clidpa_lst_upd_by   = @pa_login_name  
                 , clidpa_lst_upd_dt   = GETDATE()  
            WHERE  clidpa_id           = CONVERT(NUMERIC, @@currstring_id)  
            AND    clidpa_deleted_ind  = 4  
            --  
            SET @l_error = @@ERROR  
            --  
            IF @l_error > 0  
            BEGIN  
            --  
              --SET @@T_ERRORSTR = 'Could Not Change Access For ' + CONVERT(VARCHAR, @@L_CLIDPA_NAME) + ISNULL(@@T_ERRORSTR,'')  
              SET @@t_errorstr = CONVERT(VARCHAR(10), @l_error)  
              --  
               
            --  
            END  
             
            UPDATE client_dp_accts WITH(ROWLOCK)  
            SET    clidpa_deleted_ind  = 0  
                 , clidpa_lst_upd_by   = @pa_login_name  
                 , clidpa_lst_upd_dt   = GETDATE()  
            WHERE  clidpa_dpm_id       = @@l_clidpa_dpm_id  
            AND    clidpa_clisba_id    = @@l_clidpa_clisba_id  
            AND    clidpa_compm_id     = @@l_compm_id  
            AND    clidpa_dp_id        = @@l_clidpa_dp_id  
            AND    clidpa_deleted_ind  = 1  
            --  
            SET @l_error = @@ERROR  
            --  
            IF @l_error > 0  
            BEGIN  
            --  
              --SET @@t_errorstr = 'Could Not Change Access For ' + CONVERT(VARCHAR, @@l_clidpa_name) + ISNULL(@@t_errorstr,'')  
              SET @@t_errorstr = CONVERT(VARCHAR(10), @l_error)  
              --  
               
            --  
            END  
            --BEGIN  
            --  
            --  SET @@t_errorstr = 'Client DP Account Successfully Inserted\Edited '+ @rowdelimiter  
              --  
            --  COMMIT TRANSACTION  
            --  
            --END  
          --  
          END --4  
          ELSE IF  @@l_clidpa_deleted_ind = 8  
          BEGIN --8  
          --  
             
            --  
            UPDATE client_dp_accts_mak WITH(ROWLOCK)  
            SET    clidpa_deleted_ind = 9  
                 , clidpa_lst_upd_by  = @pa_login_name  
                 , clidpa_lst_upd_dt  = GETDATE()  
            WHERE  clidpa_id          = convert(numeric, @@currstring_id)  
            AND    clidpa_deleted_ind = 8  
            --  
            SET @l_error = @@ERROR  
            --  
            IF @l_error > 0  
            BEGIN  
            --  
              --SET @@t_errorstr = 'Could Not Change Access For ' + convert(varchar, @@l_clidpa_name) + isnull(@@t_errorstr,'')  
              SET @@t_errorstr = CONVERT(VARCHAR(10), @l_error)  
              --  
                
            --  
            END  
            --ELSE  
            --BEGIN  
            --  
            --  SET @@t_errorstr = 'Client DP Account Successfully Inserted\Edited '+ @rowdelimiter  
              --  
            --  COMMIT TRANSACTION  
            --  
            --END  
            --  
              
            UPDATE client_dp_accts      WITH(ROWLOCK)  
            SET    clidpa_name        = @@l_clidpa_name  
                 , clidpa_flg         = @@l_clidpa_flg  
                 , clidpa_poa_type    = @@l_poa_type  
                 , clidpa_lst_upd_by  = @pa_login_name  
                 , clidpa_lst_upd_dt  = GETDATE()  
            WHERE  clidpa_dpm_id      = @@l_clidpa_dpm_id  
            AND    clidpa_clisba_id   = @@l_clidpa_clisba_id  
            AND    clidpa_dp_id       = @@l_clidpa_dp_id  
            AND    clidpa_compm_id    = @@l_compm_id  
            AND    clidpa_deleted_ind = 1  
            --  
            SET @l_error = @@ERROR  
            --  
            IF @l_error > 0  
            BEGIN  
            --  
              --SET @@t_errorstr = 'Could Not Change Access For ' + convert(varchar, @@l_clidpa_name) + isnull(@@t_errorstr,'')  
              SET @@t_errorstr = CONVERT(VARCHAR(10), @l_error)  
              --  
               
            --  
            END  
            --ELSE  
            --BEGIN  
            --  
            --  SET @@t_errorstr = 'Client DP Account Successfully Inserted\Edited '+ @ROWDELIMITER  
              --  
            --  COMMIT TRANSACTION  
            --  
            --END  
          --  
          END--8  
          ELSE IF  @@l_clidpa_deleted_ind  = 0  
          BEGIN --0  
          --  
             
            --  
            UPDATE client_dp_accts_mak with(rowlock)  
            SET    clidpa_deleted_ind = 1  
                 , clidpa_lst_upd_by  = @pa_login_name  
                 , clidpa_lst_upd_dt  = GETDATE()  
            WHERE  clidpa_id          = convert(numeric, @@currstring_id)  
            and    clidpa_deleted_ind = 0  
            --  
            SET @l_error = @@ERROR  
            --  
            IF @l_error > 0  
            BEGIN  
            --  
              --SET @@T_ERRORSTR = 'Could Not Change Access For ' + CONVERT(VARCHAR, @@L_CLIDPA_NAME) + ISNULL(@@T_ERRORSTR,'')  
              SET @@t_errorstr = CONVERT(VARCHAR(10), @l_error)  
              --  
                
            --  
            END  
             
  
           /*SELECT @l_clisba_acct_no = clisba_acct_no  
                    , @l_clisba_no         = clisba_no  
                    , @l_clisba_crn_no  =  clisba_crn_no   
           FROM    client_sub_accts_mak  
           WHERE  clisbamak_id        = (SELECT cliba_clisba_id FROM  client_bank_accts_mak WHERE cliba_id = convert(numeric, @@currstring_id))  
                  
   
           SELECT @l_clisba_id = clisba_id   
           FROM   client_sub_accts   
           WHERE clisba_acct_no     =  @l_clisba_acct_no  
           and     clisba_no             =  @l_clisba_no    
     and     clisba_crn_no       =  @l_clisba_crn_no       
           and     clisba_deleted_ind = 1*/  
  
  
  
            INSERT INTO CLIENT_DP_ACCTS  
            (clidpa_dpm_id  
            ,clidpa_clisba_id  
            ,clidpa_compm_id  
            ,clidpa_dp_id  
            ,clidpa_name  
            ,clidpa_flg  
            ,clidpa_poa_type  
            ,clidpa_created_by  
            ,clidpa_created_dt  
            ,clidpa_lst_upd_by  
            ,clidpa_lst_upd_dt  
            ,clidpa_deleted_ind  
            )  
            SELECT clidpa_dpm_id      
                 , clidpa_clisba_id   
                 , clidpa_compm_id    
                 , clidpa_dp_id       
                 , clidpa_name        
                 , clidpa_flg         
                 , clidpa_poa_type    
                 , @pa_login_name  
                 , GETDATE()  
                 , @pa_login_name  
                 , GETDATE()  
                 , 1  
            FROM   #t_mak  
            WHERE  clidpa_id  = convert(numeric, @@currstring_id)  
              
            SET @l_error = @@ERROR  
            --  
            IF @l_error > 0  
            BEGIN  
            --  
              --SET @@t_errorstr = 'Could Not Change Access For ' + CONVERT(VARCHAR, @@l_clidpa_name) + ISNULL(@@t_errorstr,'')  
              SET @@t_errorstr = CONVERT(VARCHAR(10), @l_error)  
              --  
                
            --  
            END  
            --BEGIN  
            --  
            --  SET @@t_errorstr = 'Client DP Account Successfully Inserted\Edited '+ @ROWDELIMITER  
              --  
            --  COMMIT TRANSACTION  
            --  
            --END  
          --  
          END --0  
          --move to pr_app_client  
          --EXEC pr_ins_upd_list @l_crn_no,'A','Client DP Accts',@pa_login_name,'*|~*','|*~|',''   
        --  
        END--APP  
      --  
      END--ACTION_TYPE=''   
    --  
    END--@@currstring_id<>''  
  --    
  END --rem_id   
  --  
  SET @pa_msg = @@t_errorstr  
--  
END--begin

GO
