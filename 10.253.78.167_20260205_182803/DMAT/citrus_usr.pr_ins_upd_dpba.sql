-- Object: PROCEDURE citrus_usr.pr_ins_upd_dpba
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

--exec pr_ins_upd_dpba '366','EDT','HO',366,'1|*~|9|*~|IN302679|*~|IN30267945678912|*~|JAFFER|*~|51|*~|SAVINGS|*~|56789|*~|1|*~|1|*~|A*|~*',0,'*|~*','|*~|',''  
--exec pr_ins_upd_dpba '649','EDT','HO',649,'1|*~|11|*~|IN30292755578888|*~|SANJANA  |*~|49|*~|SAVINGS|*~|676776|*~|1|*~|0|*~|D*|~*', 0,'*|~*','|*~|','' 
--begin transaction
--exec pr_ins_upd_dpba '55089','EDT','HO',55089,'1|*~|14|*~|12033300|*~|4565|*~|CASE1 ADDEDITDELETE |*~|2342|*~|SAVINGS|*~|34344|*~|1|*~|2|*~|D*|~*',1,'*|~*','|*~|',''

--rollback transaction
CREATE PROCEDURE [citrus_usr].[pr_ins_upd_dpba](@pa_id                varchar(8000)
                                 , @pa_action            char(3)
                                 , @pa_login_name        varchar(20)
                                 , @pa_crn_no            numeric
                                 , @pa_values            varchar(8000)
                                 , @pa_chk_yn            numeric
                                 , @rowdelimiter         char(4)  = '*|~*'
                                 , @coldelimiter         char(4)  = '|*~|'
                                 , @pa_msg               varchar(8000) output
)
as
/*
*********************************************************************************
 system         : Citrus
 module name    : pr_ins_upd_dpba
 description    : this procedure will add new client details values to  client_dp_bank_acct
 copyright(c)   : MarketPlace Technologies Pvt Ltd.
 version history: 1.0
 vers.  author            date         reason
 -----  -------------     ----------   ------------------------------------------
 1.0    Sukhvinder        08-AUG-2007  initial version.
 --------------------------------------------------------------------------------
*********************************************************************************
*/
BEGIN--#1
--
  
  --
  DECLARE @l_errorstr            varchar(8000)
        , @l_error               numeric
        , @delimeterlength       int
        --
        , @delimeter_id          char(4)
        , @remainingstring_id    varchar(8000)
        , @currstring_id         varchar(8000)
        , @foundat_id            integer
        --
        , @delimeter_val         char(4)
        , @remainingstring_val   varchar(8000)
        , @currstring_val        varchar(8000)
        , @foundat_val           integer
        --
        , @l_compm_id            numeric
        , @l_excsm_id            numeric
        , @l_dpam_demat_id       varchar(20)
        , @l_dpba_acct_name      varchar(200) 
        , @l_dpba_banm_id        numeric
        , @l_dpba_acct_type      varchar(20)
        , @l_dpba_acct_no        varchar(20) 
        , @l_dpba_def_flg        integer
        , @l_dpba_poa_flg        integer
        , @l_action_type         varchar(10)
        --
        , @l_old_dpba_acct_type  varchar(20)
        , @l_old_dpba_acct_name  varchar(200)
        , @l_old_dpba_poa_flg    integer
        , @l_old_dpba_def_flg    integer
        --
        , @l_dpba_flg            integer
        , @l_dpam_acct_no        varchar(20)
        , @l_dpam_id             numeric
        , @l_bitrm_bit_location  numeric
        , @l_edt_del_id          numeric 
        , @l_cliba_id            numeric
        , @l_dpba_deleted_ind    numeric
        , @l_action              varchar(5)  
  --
  set @l_dpba_flg = 0
  --
  IF @pa_action = 'EDT'
  BEGIN
  --
    CREATE TABLE #t_mstr
    (cliba_banm_id       numeric
    ,cliba_clisba_id     varchar(20)
    ,cliba_compm_id      numeric
    ,cliba_ac_no         varchar(20)
    ,cliba_ac_type       varchar(20)
    ,cliba_ac_name       varchar(200)
    ,cliba_flg           int
    ,cliba_deleted_ind   int
    )
    --
    INSERT INTO #t_mstr(cliba_banm_id    
                       ,cliba_clisba_id  
                       ,cliba_compm_id   
                       ,cliba_ac_no      
                       ,cliba_ac_type    
                       ,cliba_ac_name    
                       ,cliba_flg        
                       ,cliba_deleted_ind
                       )
    --                     
    SELECT cliba_banm_id    
         , cliba_clisba_id  
         , cliba_compm_id   
         , cliba_ac_no      
         , cliba_ac_type    
         , cliba_ac_name    
         , cliba_flg        
         , cliba_deleted_ind
    FROM   client_bank_accts   WITH (NOLOCK)
    WHERE  cliba_deleted_ind = 1
  --
  END
  --
  IF @pa_action = 'APP' or @pa_action = 'REJ'
  BEGIN--a
  --  
    CREATE TABLE #t_mak
    (cliba_id            numeric
    ,cliba_banm_id       numeric
    ,cliba_clisba_id     numeric
    ,cliba_compm_id      numeric
    ,cliba_ac_no         varchar(20)
    ,cliba_ac_type       varchar(20)
    ,cliba_ac_name       varchar(200)
    ,cliba_flg           int
    ,cliba_deleted_ind   int
    )
    INSERT INTO #t_mak(cliba_id
                      ,cliba_banm_id
                      ,cliba_clisba_id
                      ,cliba_compm_id
                      ,cliba_ac_no
                      ,cliba_ac_type
                      ,cliba_ac_name
                      ,cliba_flg
                      ,cliba_deleted_ind
                      )
    --                  
    SELECT cliba_id
         , cliba_banm_id
         , cliba_clisba_id
         , cliba_compm_id
         , cliba_ac_no
         , cliba_ac_type
         , cliba_ac_name
         , cliba_flg
         , cliba_deleted_ind
    FROM   client_bank_accts_mak WITH (NOLOCK)
    WHERE  cliba_deleted_ind IN (0,4,8)
  --  
  END--a
  --
  SET @delimeterlength       = len(@rowdelimiter)
  --
  IF isnull(@pa_id,'') <> '' AND isnull(@pa_action,'') <> '' AND isnull(@pa_login_name,'') <> ''
  BEGIN--<>''
  --
    SET @l_error             = 0
    SET @l_errorstr          = ''
    SET @delimeter_id        = '%'+@rowdelimiter+'%'
    SET @remainingstring_id  = @pa_id
    --
    WHILE isnull(@remainingstring_id,'') <> ''
    BEGIN
    --
      SET @foundat_id        = 0
      SET @foundat_id        = patindex('%'+@delimeter_id+'%',@remainingstring_id)
      --
      IF @foundat_id > 0
      BEGIN
      --
        SET @currstring_id      = substring(@remainingstring_id,0,@foundat_id)
        SET @remainingstring_id = substring(@remainingstring_id, @foundat_id+@delimeterlength,len(@remainingstring_id)-@foundat_id+@delimeterlength)
      --
      END
      ELSE
      BEGIN
      --
        SET @currstring_id      = @remainingstring_id
        SET @remainingstring_id = ''
      --
      END
      --
      IF isnull(@currstring_id,'') <> ''
      BEGIN--curr_id
      --
        SET @delimeter_val       = '%'+@rowdelimiter+'%'
        SET @remainingstring_val = @pa_values
        --
        WHILE isnull(@remainingstring_val,'') <> ''
        BEGIN--rem_val
        --
          SET @foundat_val       = 0
          SET @foundat_val       = patindex('%'+@delimeter_val+'%',@remainingstring_val)
          --
          IF @foundat_val > 0
          BEGIN
          --
            SET @currstring_val      = substring(@remainingstring_val,0,@foundat_val)
            SET @remainingstring_val = substring(@remainingstring_val,@foundat_val+@delimeterlength,len(@remainingstring_val)- @foundat_val+@delimeterlength)
          --
          END
          ELSE
          BEGIN
          --
            SET @currstring_val      = @remainingstring_val
            SET @remainingstring_val = ''
          --
          END
          --
          IF isnull(@currstring_val,'') <> ''
          BEGIN--curr_val
          --
            --1|*~|9|*~|IN302679|*~|IN30267945678912|*~|JAFFER|*~|51|*~|SAVINGS|*~|56789|*~|1|*~|1|*~|A*|~*' 
            set @l_dpba_flg = 0
            SET @l_compm_id        = convert(numeric, citrus_usr.fn_splitval(@currstring_val,1))
            SET @l_excsm_id        = convert(numeric, citrus_usr.fn_splitval(@currstring_val,2))
            SET @l_dpam_acct_no    = convert(varchar, citrus_usr.fn_splitval(@currstring_val,3))--dpm_id
            SET @l_dpam_demat_id   = convert(varchar, citrus_usr.fn_splitval(@currstring_val,4))  
            SET @l_dpba_acct_name  = citrus_usr.fn_splitval(@currstring_val,5)
            SET @l_dpba_banm_id    = convert(numeric, citrus_usr.fn_splitval(@currstring_val,6))
            SET @l_dpba_acct_type  = citrus_usr.fn_splitval(@currstring_val,7)
            SET @l_dpba_acct_no    = convert(varchar, citrus_usr.fn_splitval(@currstring_val,8))
            SET @l_dpba_def_flg    = convert(integer, citrus_usr.fn_splitval(@currstring_val,9)) 
            SET @l_dpba_poa_flg    = CONVERT(integer, citrus_usr.fn_splitval(@currstring_val, 10))
            SET @l_action_type     = citrus_usr.fn_splitval(@currstring_val,11)
            --
            DECLARE @l_chk_in   char(2)
            --
            SET @l_chk_in = LEFT(@l_dpam_demat_id,2)
            --
            IF rtrim(ltrim(@l_chk_in)) = 'IN' 
            BEGIN
            --
             SET @l_dpam_demat_id = substring(@l_dpam_demat_id,9,len(@l_dpam_demat_id)-8)
            --
            END
            --
            SET  @l_dpam_id           = NULL
            --
            SELECT @l_dpam_id         = dpam_id
            FROM   dp_acct_mstr         WITH (NOLOCK)
            WHERE  dpam_crn_no        = @pa_crn_no
            AND    dpam_sba_no        = @l_dpam_demat_id
            and    dpam_excsm_id      = @l_excsm_id 
            AND    dpam_deleted_ind   = 1
            --
            IF @PA_CHK_YN = 0
            BEGIN--chk_0
            --
              IF @l_action_type = 'A'
              BEGIN--a_0
              --
                IF @l_dpba_poa_flg = 1
                BEGIN
                --
                  SELECT @l_bitrm_bit_location = bitrm_bit_location
                  FROM   bitmap_ref_mstr         WITH (NOLOCK)
                  WHERE  bitrm_parent_cd       = 'BANK'
                  AND    bitrm_child_cd        = 'POA_FLG'
                  --
                  SET @l_dpba_flg = power(2,@l_bitrm_bit_location-1) | @l_dpba_flg
                --
                END
                --
                IF @l_dpba_def_flg = 1
                BEGIN
                --
                  SELECT @l_bitrm_bit_location = bitrm_bit_location
                  FROM   bitmap_ref_mstr         WITH (NOLOCK)
                  WHERE  bitrm_parent_cd       = 'BANK'
                  AND    bitrm_child_cd        = 'DEF_FLG'
                  --
                  SET @l_dpba_flg = power(2, @l_bitrm_bit_location-1) | @l_dpba_flg
                --
                END
                --
                BEGIN TRANSACTION
                --
                INSERT INTO client_bank_accts
                (cliba_banm_id
                ,cliba_clisba_id
                ,cliba_compm_id
                ,cliba_ac_no
                ,cliba_ac_type
                ,cliba_ac_name
                ,cliba_flg
                ,cliba_created_by
                ,cliba_created_dt
                ,cliba_lst_upd_by
                ,cliba_lst_upd_dt
                ,cliba_deleted_ind
                )
                VALUES
                (@l_dpba_banm_id
                ,@l_dpam_id --@l_dpam_demat_id
                ,@l_compm_id
                ,@l_dpba_acct_no
                ,@l_dpba_acct_type
                ,@l_dpba_acct_name
                ,@l_dpba_flg
                ,@pa_login_name
                ,getdate()
                ,@pa_login_name
                ,getdate()
                ,1
                )
                --
                SET @l_error = @@error
                --
                IF @l_error > 0
                BEGIN
                --
                  SET @pa_msg = '#'+'could not change access for ' + convert(varchar, @l_dpba_acct_name) + isnull(@l_errorstr,'')
                  --
                  ROLLBACK TRANSACTION
                  --
                  RETURN
                --
                END
                ELSE
                BEGIN
                --
                  SET @l_errorstr = 'client bank account successfully inserted\edited '+ @rowdelimiter
                  --
                  COMMIT TRANSACTION
                --
                END
              --
              END  --a_0
              --
              IF @l_action_type = 'E'
              BEGIN--e_0
              --
                SELECT @l_old_dpba_acct_type = cliba_ac_type
                     , @l_old_dpba_acct_name = cliba_ac_name
                     , @l_old_dpba_poa_flg   = cliba_flg & 1
                     , @l_old_dpba_def_flg   = cliba_flg & 2
                FROM   #t_mstr
                WHERE  cliba_banm_id     = @l_dpba_banm_id
                AND    cliba_compm_id    = @l_compm_id
                AND    cliba_clisba_id   = @l_dpam_demat_id
                AND    cliba_ac_no       = @l_dpba_acct_no
                --
                IF (@l_dpba_acct_type     <> @l_old_dpba_acct_type)
                   AND (@l_dpba_acct_name <> @l_old_dpba_acct_name)
                   AND (@l_dpba_poa_flg   <> @l_old_dpba_poa_flg)
                   AND (@l_dpba_def_flg   <> @l_old_dpba_def_flg)
                BEGIN--not_exist
                --
                  IF @l_dpba_poa_flg = 1
                  BEGIN
                  --
                    SELECT @l_bitrm_bit_location = bitrm_bit_location
                    FROM   bitmap_ref_mstr         WITH (NOLOCK)
                    WHERE  bitrm_parent_cd       = 'BANK'
                    AND    bitrm_child_cd        = 'POA_FLG'
                    --
                    SET @l_dpba_flg = power(2,@l_bitrm_bit_location-1) | @l_dpba_flg
                  --
                  END
                  --
                  IF @l_dpba_def_flg = 1
                  BEGIN
                  --
                    SELECT @l_bitrm_bit_location = bitrm_bit_location
                    FROM   bitmap_ref_mstr         WITH (NOLOCK)
                    WHERE  bitrm_parent_cd       = 'BANK'
                    AND    bitrm_child_cd        = 'DEF_FLG'
                    --
                    SET @l_dpba_flg = power(2, @l_bitrm_bit_location-1) | @l_dpba_flg
                  --
                  END
                  --
                  BEGIN TRANSACTION
                  --
                  INSERT INTO client_bank_accts
                  (cliba_banm_id
                  ,cliba_clisba_id
                  ,cliba_compm_id
                  ,cliba_ac_no
                  ,cliba_ac_type
                  ,cliba_ac_name
                  ,cliba_flg
                  ,cliba_created_by
                  ,cliba_created_dt
                  ,cliba_lst_upd_by
                  ,cliba_lst_upd_dt
                  ,cliba_deleted_ind
                  )
                  VALUES
                  (@l_dpba_banm_id
                  ,@l_dpam_id --@l_dpam_demat_id
                  ,@l_compm_id
                  ,@l_dpba_acct_no
                  ,@l_dpba_acct_type
                  ,@l_dpba_acct_name
                  ,@l_dpba_flg
                  ,@pa_login_name
                  ,getdate()
                  ,@pa_login_name
                  ,getdate()
                  ,1
                  )
                  --
                  SET @l_error = @@error
                  --
                  IF @l_error > 0
                  BEGIN
                  --
                    SET @pa_msg = '#'+'could not change access for ' + convert(varchar, @l_dpba_acct_name) + isnull(@l_errorstr,'')
                    --
                    ROLLBACK TRANSACTION
                    --
                    RETURN
                  --
                  END
                  ELSE
                  BEGIN
                  --
                    SET @l_errorstr = 'client bank account successfully inserted\edited '+ @rowdelimiter
                    --
                    COMMIT TRANSACTION
                  --
                  END
                --
                END--not_exist
                ELSE
                BEGIN--exist
                -- 
                  BEGIN TRANSACTION
                  
                  IF @l_dpba_poa_flg = 1
                  BEGIN
                  --
                    SELECT @l_bitrm_bit_location = bitrm_bit_location
                    FROM   bitmap_ref_mstr         WITH (NOLOCK)
                    WHERE  bitrm_parent_cd       = 'BANK'
                    AND    bitrm_child_cd        = 'POA_FLG'
                    --
                    SET @l_dpba_flg = power(2,@l_bitrm_bit_location-1) | @l_dpba_flg
                  --
                  END
                  --
                  IF @l_dpba_def_flg = 1
                  BEGIN
                  --
                    SELECT @l_bitrm_bit_location = bitrm_bit_location
                    FROM   bitmap_ref_mstr         WITH (NOLOCK)
                    WHERE  bitrm_parent_cd       = 'BANK'
                    AND    bitrm_child_cd        = 'DEF_FLG'
                    --
                    SET @l_dpba_flg = power(2, @l_bitrm_bit_location-1) | @l_dpba_flg
                  --
                  END
                  --
                  DELETE FROM #t_mstr
                  WHERE  cliba_ac_no = @l_dpba_acct_no
                  --
                  UPDATE client_bank_accts   WITH(ROWLOCK)
                  SET    cliba_ac_type     = @l_dpba_acct_type
                        ,cliba_ac_name     = @l_dpba_acct_name
                        ,cliba_flg         = @l_dpba_flg
                        ,cliba_lst_upd_by  = @pa_login_name
                        ,cliba_lst_upd_dt  = GETDATE()
                  WHERE  cliba_banm_id     = @l_dpba_banm_id
                  AND    cliba_clisba_id   = @l_dpam_id --@l_dpam_demat_id
                  AND    cliba_compm_id    = @l_compm_id
                  AND    cliba_ac_no       = @l_dpba_acct_no
                  AND    cliba_deleted_ind = 1
                  --
                  SET @l_error = @@error
                  --
                  IF @l_error > 0
                  BEGIN
                  --
                   SET @pa_msg = '#'+'could not change access for ' + convert(varchar, @l_dpba_acct_name) + ISNULL(@l_errorstr,'')
                   --
                   ROLLBACK TRANSACTION
                   --
                   RETURN
                  --
                  END
                  ELSE
                  BEGIN
                  --
                    SET @l_errorstr = 'client bank account successfully inserted\edited '+ @rowdelimiter
                    --
                    COMMIT TRANSACTION
                  --
                  END
                --
                END--exist
              --
              END  --e_0
              --
              IF @l_action_type = 'D'
              BEGIN--d_0
              --
                BEGIN TRANSACTION
                --
                UPDATE client_bank_accts     WITH (ROWLOCK)
                SET    cliba_deleted_ind   = 0 
                      ,cliba_lst_upd_by    = @pa_login_name
                      ,cliba_lst_upd_dt    = GETDATE()
                WHERE  cliba_clisba_id     = @l_dpam_id
                AND    cliba_ac_no         = @l_dpba_acct_no
                AND    cliba_deleted_ind   = 1
                --
                SET @l_error = @@error
                --
                IF @l_error > 0
                BEGIN
                --
                  SET @pa_msg = '#'+'could not change access for ' + convert(varchar, @l_dpba_acct_name) + ISNULL(@l_errorstr,'')
                  --
                  ROLLBACK TRANSACTION
                  --
                  RETURN
                --
                END
                ELSE
                BEGIN
                --
                  SET @l_errorstr = 'client bank account successfully inserted\edited '+ @rowdelimiter
                  --
                  COMMIT TRANSACTION
                --
                END
              --
              END  --d_0
            --
            END--chk_0
            --***
            IF @pa_chk_yn = 1 OR @pa_chk_yn = 2
            BEGIN--chk_1
            --
              IF ISNULL(@l_dpam_id, 0) = 0
              BEGIN
              --
                SELECT @l_dpam_id         = dpam_id
                FROM   dp_acct_mstr_mak     WITH (NOLOCK)
                WHERE  dpam_crn_no        = @pa_crn_no
                AND    dpam_sba_no        = @l_dpam_demat_id
                and    dpam_excsm_id      = @l_excsm_id 
                AND    dpam_deleted_ind   = 0
              --  
              END
              --
              IF ISNULL(@l_dpam_id, 0) = 0
              BEGIN
              --
                SELECT @l_dpam_id         = dpam_id
                FROM   dp_acct_mstr         WITH (NOLOCK)
                WHERE  dpam_crn_no        = @pa_crn_no
                AND    dpam_sba_no        = @l_dpam_demat_id
                and    dpam_excsm_id      = @l_excsm_id 
                AND    dpam_deleted_ind   = 1
              --
              END
              --
              IF @l_action_type IN ('A','D','E')
              BEGIN--**
              --
                IF EXISTS(SELECT cliba_id
                          FROM   client_bank_accts_mak WITH (NOLOCK)
                          WHERE  cliba_compm_id      = @l_compm_id
                          and    cliba_banm_id        = @l_dpba_banm_id
                          AND    cliba_clisba_id     = @l_dpam_id
                          AND    cliba_ac_no         = @l_dpba_acct_no
                          AND    cliba_deleted_ind  IN (0,4,8)
                          )
                BEGIN--#exist
                --
                  BEGIN TRANSACTION
                  --
                  UPDATE client_bank_accts_mak  WITH (ROWLOCK)
                  SET    cliba_deleted_ind    = 3
                        ,cliba_lst_upd_by     = @pa_login_name
                        ,cliba_lst_upd_dt     = GETDATE()
                  WHERE  cliba_compm_id       = @l_compm_id
                  and    cliba_banm_id        = @l_dpba_banm_id
                  AND    cliba_clisba_id      = @l_dpam_id
                  AND    cliba_ac_no          = @l_dpba_acct_no
                  AND    cliba_deleted_ind   IN (0,4,8)
                  --
                  SET @l_error = @@error
                  --
                  IF @l_error > 0
                  BEGIN
                  --
                    SET @pa_msg = '#'+'could not change access for ' + convert(varchar, @l_dpba_acct_name) + ISNULL(@l_errorstr,'')
                    --
                    ROLLBACK TRANSACTION
                    --
                    RETURN
                  --
                  END
                  ELSE
                  BEGIN
                  --
                    SET @l_errorstr = 'client bank account successfully inserted\edited '+ @rowdelimiter
                    --
                    COMMIT TRANSACTION
                  --
                  END
                 --
                 END  --#exist
                 --
                 IF @l_action_type ='D' and not EXISTS(SELECT cliba_clisba_id FROM client_bank_accts WHERE cliba_clisba_id = @l_dpam_id AND cliba_banm_id = @l_dpba_banm_id and cliba_ac_no = @l_dpba_acct_no and cliba_deleted_ind =1 )
                 BEGIN--***
                 --
                
                  delete from client_bank_Accts_mak
                  WHERE  cliba_banm_id        = @l_dpba_banm_id
                  AND    cliba_compm_id       = @l_compm_id
                  AND    cliba_clisba_id      = @l_dpam_id
                  AND    cliba_ac_no          = @l_dpba_acct_no
                  AND    cliba_deleted_ind    = 0
                 --
                 END
                 IF @l_action_type IN ('A','E')
                 BEGIN--***
                 --
                   IF @l_dpba_poa_flg = 1
                   BEGIN
                   --
                     SELECT @l_bitrm_bit_location = bitrm_bit_location
                     FROM   bitmap_ref_mstr         WITH (NOLOCK)
                     WHERE  bitrm_parent_cd       = 'BANK'
                     AND    bitrm_child_cd        = 'POA_FLG'
                     --
                     SET @l_dpba_flg  = power(2, @l_bitrm_bit_location-1) | @l_dpba_flg
                   --
                   END
                   --
                   IF @l_dpba_def_flg = 1
                   BEGIN
                   --
                     SELECT @l_bitrm_bit_location = bitrm_bit_location
                     FROM   bitmap_ref_mstr         WITH (NOLOCK)
                     WHERE  bitrm_parent_cd       = 'BANK'
                     AND    bitrm_child_cd        = 'DEF_FLG'
                     --
                     SET @l_dpba_flg = power(2, @l_bitrm_bit_location - 1) | @l_dpba_flg
                   --
                   END
                 -- 
                 END--*** 
                 --
                 IF EXISTS(SELECT cliba_clisba_id FROM client_bank_accts WHERE cliba_clisba_id = @l_dpam_id AND cliba_banm_id = @l_dpba_banm_id)
                 BEGIN
                 --
                   SET @l_edt_del_id = 8
                 --
                 END
                 ELSE
                 BEGIN
                 --
                   SET @l_edt_del_id = 0
                 --
                 END 
                 --
                 SELECT @l_cliba_id = ISNULL(MAX(cliba_id),0) + 1
                 FROM   client_bank_accts_mak WITH (NOLOCK)
                 --
                 BEGIN TRANSACTION
                 --
                 INSERT into client_bank_accts_mak
                 (cliba_id
                 ,cliba_banm_id
                 ,cliba_clisba_id
                 ,cliba_compm_id
                 ,cliba_ac_no
                 ,cliba_ac_type
                 ,cliba_ac_name
                 ,cliba_flg
                 ,cliba_created_by
                 ,cliba_created_dt
                 ,cliba_lst_upd_by
                 ,cliba_lst_upd_dt
                 ,cliba_deleted_ind
                 )
                 VALUES
                 (@l_cliba_id
                 ,@l_dpba_banm_id
                 ,@l_dpam_id
                 ,@l_compm_id
                 ,@l_dpba_acct_no
                 ,@l_dpba_acct_type
                 ,@l_dpba_acct_name
                 ,@l_dpba_flg
                 ,@pa_login_name
                 ,getdate()
                 ,@pa_login_name
                 ,getdate()
                 ,CASE @l_action_type WHEN 'A' then 0
                                      WHEN 'E' then @l_edt_del_id                     
                                      WHEN 'D' then 4
                                      END
                 )
                 --
                 SET @l_error = @@error
                 --
                 IF @l_error > 0
                 BEGIN
                 --
                   SET @pa_msg = '#'+'could not change access for ' + convert(varchar, @l_dpba_acct_name) + ISNULL(@l_errorstr,'')
                   --
                   ROLLBACK TRANSACTION
                   --
                   RETURN
                 --
                 END
                 ELSE
                 BEGIN
                 --
                   SET @l_errorstr = 'client bank account successfully inserted\edited '+ @rowdelimiter
                   --
                   SELECT @l_action = CASE @l_action_type WHEN 'A' THEN 'I' WHEN 'E' THEN 'E' WHEN 'D' THEN 'D' END
                   --
                   EXEC pr_ins_upd_list @pa_crn_no, @l_action, 'Client Bank Accts',@pa_login_name,'*|~*','|*~|','' 
                   --
                   COMMIT TRANSACTION
                 --
                 END
              --
              END--**
            --
            END--chk_1
          --
          END  --curr_val
        --  
        END --rem_val
        --
        IF ISNULL(@l_action_type,'') = '' 
        BEGIN--action_type=''  
        --
          IF @pa_action = 'REJ'
          BEGIN--rej
          --
            UPDATE client_bank_accts_mak WITH (ROWLOCK)
            SET    cliba_deleted_ind   = 3 
                  ,cliba_lst_upd_by    = @pa_login_name
                  ,cliba_lst_upd_dt    = getdate()
            WHERE  cliba_id            = convert(numeric, @currstring_id)
            AND    cliba_deleted_ind  IN (0,4,8)  
            --
            SET @l_error = @@error
            --
            IF @l_error > 0
            BEGIN
            --
              SET @l_errorstr  = CONVERT(varchar(10), @l_error) 
            --
            END
          --
          END--rej
          --
          IF @pa_action = 'APP'
          BEGIN--app
          --
            SELECT @l_dpba_banm_id     = cliba_banm_id    
                 , @l_dpam_id          = cliba_clisba_id  
                 , @l_compm_id         = cliba_compm_id   
                 , @l_dpba_acct_no     = cliba_ac_no      
                 , @l_dpba_acct_type   = cliba_ac_type    
                 , @l_dpba_acct_name   = cliba_ac_name    
                 , @l_dpba_flg         = cliba_flg        
                 , @l_dpba_deleted_ind = cliba_deleted_ind
            FROM   #t_mak
            WHERE  cliba_id            = convert(numeric, @currstring_id)
            --
            IF @l_dpba_deleted_ind = 4
            BEGIN --4
            --
              UPDATE client_bank_accts_mak  WITH(ROWLOCK)
              SET    cliba_deleted_ind    = 5
                    ,cliba_lst_upd_by     = @pa_login_name
                    ,cliba_lst_upd_dt     = getdate()
              WHERE  cliba_id             = convert(numeric, @currstring_id)
              AND    cliba_deleted_ind    = 4
              --
              SET @l_error = @@ERROR 
              --
              IF @l_error > 0
              BEGIN
              --
                SET @l_errorstr = convert(varchar(10), @l_error)
              --
              END
              --           
              UPDATE client_bank_accts   WITH(ROWLOCK)
              SET    cliba_deleted_ind = 0
                    ,cliba_lst_upd_by  = @pa_login_name
                    ,cliba_lst_upd_dt  = getdate()
              WHERE  cliba_banm_id     = @l_dpba_banm_id
              AND    cliba_clisba_id   = @l_dpam_id
              AND    cliba_compm_id    = @l_compm_id
              AND    cliba_ac_no       = @l_dpba_acct_no
              AND    cliba_deleted_ind = 1   
              --
              SET @l_error = @@ERROR 
              --
              IF @l_error > 0
              BEGIN
              --
                SET @l_errorstr = CONVERT(VARCHAR(10), @l_error)
              --
              END
            --              
            END --4
            --
            ELSE IF @l_dpba_deleted_ind = 8
            BEGIN --8
            --
              UPDATE client_bank_accts_mak  WITH(ROWLOCK)
              SET    cliba_deleted_ind    = 9
                    ,cliba_lst_upd_by     = @pa_login_name
                    ,cliba_lst_upd_dt     = getdate()
              WHERE  cliba_id             = convert(numeric, @currstring_id)
              AND    cliba_deleted_ind    = 8
              --
              SET @l_error = @@ERROR 
              --
              IF @l_error > 0
              BEGIN
              --
                SET @l_errorstr = convert(varchar(10), @l_error)
              --
              END
              --           
              UPDATE client_bank_accts  WITH(ROWLOCK)
              SET    cliba_ac_type     = @l_dpba_acct_type
                    ,cliba_ac_name     = @l_dpba_acct_name
                    ,cliba_flg         = @l_dpba_flg
                    ,cliba_lst_upd_by  = @pa_login_name
                    ,cliba_lst_upd_dt  = GETDATE()
              WHERE  cliba_banm_id     = @l_dpba_banm_id
              AND    cliba_clisba_id   = @l_dpam_id
              AND    cliba_compm_id    = @l_compm_id
              AND    cliba_ac_no       = @l_dpba_acct_no
              AND    cliba_deleted_ind = 1
              --
              SET @l_error = @@ERROR 
              --
              IF @l_error > 0
              BEGIN
              --
                SET @l_errorstr = convert(varchar(10), @l_error)
              --
              END
            --
            END --8
            --
            ELSE IF @l_dpba_deleted_ind = 0
            BEGIN --0
            --
              UPDATE client_bank_accts_mak  WITH(ROWLOCK)
              SET    cliba_deleted_ind = 1
                    ,cliba_lst_upd_by  = @pa_login_name
                    ,cliba_lst_upd_dt  = GETDATE()
              WHERE  cliba_id          = convert(numeric, @currstring_id)
              AND    cliba_deleted_ind = 0  
              --
              SET @l_error = @@ERROR 
              --
              IF @l_error > 0
              BEGIN
              --
                SET @l_errorstr = CONVERT(varchar(10), @l_error)
              --
              END
              --             
              INSERT into client_bank_accts
              (cliba_banm_id
              ,cliba_clisba_id
              ,cliba_compm_id
              ,cliba_ac_no
              ,cliba_ac_type
              ,cliba_ac_name
              ,cliba_flg
              ,cliba_created_by
              ,cliba_created_dt
              ,cliba_lst_upd_by
              ,cliba_lst_upd_dt
              ,cliba_deleted_ind
              )

              SELECT cliba_banm_id
                   , cliba_clisba_id
                   , cliba_compm_id
                   , cliba_ac_no
                   , cliba_ac_type
                   , cliba_ac_name
                   , cliba_flg
                   , @pa_login_name
                   , GETDATE()
                   , @pa_login_name
                   , GETDATE()
                   , 1
              FROM   #t_mak
              WHERE  cliba_id  = CONVERT(numeric, @currstring_id)
              --
              SET @l_error = @@ERROR 
              --
              IF @l_error > 0
              BEGIN
              --
                SET @l_errorstr = CONVERT(VARCHAR(10), @l_error)
              --
              END
            --
            END--0 
          --  
          END--app
        --
        END--action_type=''
      --  
      END  --curr_id
    --  
    END--while_id  
  --
  END  --<>''
  --
  SET @pa_msg = @l_errorstr
--  
END  --#1

GO
