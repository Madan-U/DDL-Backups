-- Object: PROCEDURE citrus_usr.pr_ins_upd_dpam
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--begin transaction
--exec pr_ins_upd_dpam '59138*|~*','app','HO',54742,'',1,'*|~*','|*~|',''  
--select * from dp_acct_mstr order by 1 desc
--select * from dp_acct_mstr_mak order by 1 desc
--rollback transaction
--exec pr_ins_upd_dpam '0','INS','HO','446','1|*~|9|*~|IN302679|*~|12121212|*~|RAAAMUI11|*~|FRN12311|*~|CA|*~|CLIENT|*~|AOP|*~|59|*~|A*|~*',1,'*|~*','|*~|',''  
CREATE PROCEDURE [citrus_usr].[pr_ins_upd_dpam] (@pa_id            varchar(8000)
                                ,@pa_action        varchar(20)
                                ,@pa_login_name    varchar(20)
                                ,@pa_crn_no        numeric
                                ,@pa_values        varchar(8000)
                                ,@pa_chk_yn        numeric
                                ,@rowdelimiter     char(4) = '*|~*'
                                ,@coldelimiter     char(4) = '|*~|'
                                ,@pa_msg           varchar(8000) output
                                )
AS
/*
********************************************************************************
 system         : citrus
 module name    : pr_ins_upd_dpam
 description    : this procedure will add new values to dp_acct_mstr
 copyright(c)   : MarketPlace Technolgies Pvt. Ltd.
 version history: 1.0
 VERS.  AUTHOR          DATE         REASON
 -----  -------------   ----------   -------------------------------------------
 1.0    Sukhvinder      11-aug-2007  Initial version.
 -------------------------------------------------------------------------------
 *******************************************************************************
*/
BEGIN
--
  DECLARE @l_errorstr            varchar(8000)
        , @remainingstring_id    varchar(8000)
        , @currstring_id         varchar(8000)
        , @remainingstring_val   varchar(8000)
        , @currstring_val        varchar(8000)
        , @delimeter             char(4)  
        , @foundat_id            integer
        , @foundat_val           integer
        , @delimeterlength       int
        , @l_error               int
        , @l_dpam_id             int
        , @l_acct_no             varchar(20)
        , @l_demat_id            varchar(20)
        , @l_comp_id             numeric
        , @l_excsm_id            numeric
        , @l_dpm_id              numeric
        , @l_dpm_dpid            varchar(20)
        , @l_enttm_cd            varchar(20)
        , @l_ctgry_cd            varchar(20)
        , @l_subcm_cd            varchar(20)
        , @l_status_cd           varchar(20)
        , @l_action_type         char(1)
        , @l_brokerage           numeric
        --
        , @l_old_crn_no          varchar(20)
        , @l_old_acct_no         varchar(20)
        , @l_old_demat_id        varchar(20)
        , @l_old_excsm_id        numeric
        , @l_old_dpm_id          numeric
        , @l_old_enttm_id        Varchar(20)
        , @l_old_ctgry_cd        varchar(20)
        , @l_old_subcm_cd        varchar(20)
        , @l_old_status_cd       varchar(20)
        --
        , @l_edt_del_id          int
        , @l_old_deleted_ind     numeric
        , @l_old_brom            Varchar(20)
        , @l_old_sba_name        varchar(100)
        , @l_sba_name            varchar(100)
        , @l_action              char(2) 
        , @l_crn_dpam            varchar(8000) 
        --, @l_dpammak_id          numeric
        --, @l_dpam_id1            numeric
  -- 
  IF @pa_action = 'APP' or @pa_action = 'REJ'
  BEGIN
  --
    CREATE TABLE #t_maker
    (dpam_id           numeric  
    ,dpam_crn_no       varchar(20)
    ,dpam_acct_no      varchar(20)
    ,dpam_sba_no       varchar(20)
    ,dpam_excsm_id     numeric
    ,dpam_dpm_id       numeric
    ,dpam_enttm_cd     varchar(20)
    ,dpam_clicm_cd     varchar(20)
    ,dpam_subcm_cd     varchar(20)
    ,dpam_stam_cd      varchar(25)
    ,dpam_deleted_ind  numeric
    ,dpam_sba_name     varchar(100)
    ,dpam_brom_id         varchar(20)  
    )
    --
    INSERT INTO #t_maker
    (dpam_id
    ,dpam_crn_no
    ,dpam_acct_no
    ,dpam_sba_no
    ,dpam_excsm_id
    ,dpam_dpm_id
    ,dpam_enttm_cd
    ,dpam_clicm_cd
    ,dpam_subcm_cd
    ,dpam_stam_cd
    ,dpam_deleted_ind
    ,dpam_sba_name
    ,dpam_brom_id
    )
    SELECT dpam_id
         , dpam_crn_no
         , dpam_acct_no
         , dpam_sba_no
         , dpam_excsm_id
         , dpam_dpm_id
         , dpam_enttm_cd
         , dpam_clicm_cd
         , dpam_subcm_cd
         , dpam_stam_cd
         , dpam_deleted_ind
         , dpam_sba_name
         , isnull(dpam_brom_id,0)
    FROM   dp_acct_mstr_mak WITH (NOLOCK)  
    WHERE  dpam_deleted_ind IN (0,4,8) 
  --
  END
  --  
  IF isnull(@pa_id,'') <> '' AND isnull(@pa_login_name,'') <> ''
  BEGIN--#1
  --
    SET @delimeter           = @rowdelimiter
    SET @delimeterlength     = len(@rowdelimiter)
    SET @remainingstring_id  = @pa_id
    SET @remainingstring_val = @pa_values
    --
    WHILE isnull(@remainingstring_id,'') <> ''
    BEGIN --while_id
    --
      SET @foundat_id = 0
      SET @foundat_id =  patindex('%'+@delimeter+'%', @remainingstring_id)

      IF @foundat_id > 0
      BEGIN
      --
        SET @currstring_id      = substring(@remainingstring_id, 0, @foundat_id)
        SET @remainingstring_id = substring(@remainingstring_id, @foundat_id+@delimeterlength, len(@remainingstring_id) - @foundat_id+@delimeterlength)
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
      BEGIN--if_id
      --
        IF @pa_action <> 'REJ' and @pa_action <> 'APP'
        BEGIN--01
        --
          WHILE isnull(@remainingstring_val,'') <> ''
          BEGIN--while_val
          --
            SET @foundat_val = 0
            SET @foundat_val =  patindex('%'+@delimeter+'%', @remainingstring_val)
            -- 
            IF @foundat_val > 0
            BEGIN
            --
              SET @currstring_val      = substring(@remainingstring_val, 0, @foundat_val)
              SET @remainingstring_val = substring(@remainingstring_val, @foundat_val+@delimeterlength, len(@remainingstring_val) - @foundat_val+@delimeterlength)
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
            BEGIN--if_val
            --
              --1|*~|9|*~|IN302679|*~|12121212|*~|RAAAMUI11|*~|FRN12311|*~|CA|*~|CLIENT|*~|AOP|*~|59|*~|A*|~*
              SET @l_comp_id        = convert(numeric, citrus_usr.fn_splitval(@currstring_val, 1))
              SET @l_excsm_id       = convert(numeric, citrus_usr.fn_splitval(@currstring_val, 2))
              SET @l_dpm_dpid       = convert(varchar(20), citrus_usr.fn_splitval(@currstring_val, 3))
              SET @l_demat_id       = citrus_usr.fn_splitval(@currstring_val, 4)
              SET @l_sba_name       = convert(varchar(100), citrus_usr.fn_splitval(@currstring_val, 5))
              SET @l_acct_no        = citrus_usr.fn_splitval(@currstring_val, 6)
              SET @l_status_cd      = citrus_usr.fn_splitval(@currstring_val, 7)
              SET @l_enttm_cd       = citrus_usr.fn_splitval(@currstring_val, 8)
              SET @l_ctgry_cd       = citrus_usr.fn_splitval(@currstring_val, 9)
              SET @l_subcm_cd       = citrus_usr.fn_splitval(@currstring_val, 10)
              SET @l_brokerage      = case when isnull(citrus_usr.fn_splitval(@currstring_val, 11),'') = '' then 0 end
              SET @l_action_type    = citrus_usr.fn_splitval(@currstring_val, 12)
              
              SELECT @l_dpm_id          = dpm_id 
              FROM   dp_mstr              WITH (NOLOCK) 
              WHERE  dpm_dpid           = @l_dpm_dpid
              AND    dpm_deleted_ind    = 1
              --
              IF @pa_chk_yn = 0
              BEGIN--chk_0
              --
                 IF ISNULL(@pa_action,'') <> ''
                 BEGIN--action=''
                 --
                   IF @l_action_type = 'A'
                   BEGIN--a_0
                   --
                     SELECT @l_dpam_id         = isnull(max(bitrm_bit_location),0)+1
                     FROM   bitmap_ref_mstr      WITH (NOLOCK)
                     WHERE  bitrm_parent_cd    = 'SBAID' 
                     AND    bitrm_child_cd     = 'SBAID'
                     AND    bitrm_deleted_ind  = 1
                     --
                     UPDATE bitmap_ref_mstr      WITH(ROWLOCK) 
                     SET    bitrm_bit_location = @l_dpam_id
                     WHERE  bitrm_parent_cd    = 'SBAID' 
                     AND    bitrm_child_cd     = 'SBAID'
                     AND    bitrm_deleted_ind  = 1
                     --
                     BEGIN TRANSACTION
                     --
                     INSERT INTO dp_acct_mstr
                     (dpam_id
                     ,dpam_crn_no
                     ,dpam_acct_no
                     ,dpam_sba_no
                     ,dpam_excsm_id
                     ,dpam_dpm_id
                     ,dpam_enttm_cd
                     ,dpam_clicm_cd
                     ,dpam_subcm_cd
                     ,dpam_stam_cd
                     ,dpam_created_by
                     ,dpam_created_dt
                     ,dpam_lst_upd_by
                     ,dpam_lst_upd_dt
                     ,dpam_deleted_ind
                     ,dpam_sba_name
                     )  
                     VALUES
                     (@l_dpam_id
                     ,@pa_crn_no
                     ,@l_acct_no  
                     ,@l_demat_id 
                     ,@l_excsm_id 
                     ,@l_dpm_id   
                     ,@l_enttm_cd 
                     ,@l_ctgry_cd
                     ,@l_subcm_cd
                     ,@l_status_cd
                     ,@pa_login_name
                     ,getdate()
                     ,@pa_login_name
                     ,getdate()
                     ,1
                     ,@l_sba_name
                     )
                     --
                     SET @l_error = @@error
                     --
                     IF @l_error > 0
                     BEGIN
                     --
                       SET @pa_msg = '#'+'could not change access for ' + convert(varchar, @l_demat_id) + isnull(@l_errorstr,'')
                       --
                       ROLLBACK TRANSACTION
                       --
                       RETURN
                     --
                     END
                     --
                     /*IF isnull(@l_brokerage,0) = 0
                     BEGIN
                     --
                       SELECT top 1 @l_brokerage = a.brom_id 
                       FROM   brokerage_mstr       a WITH (NOLOCK)
                            , excsm_prod_mstr      b WITH (NOLOCK)
                       WHERE  a.brom_excpm_id    = b.excpm_id
                       AND    b.excpm_excsm_id   = @l_excsm_id 
                     --  
                     END  
                     --
                     INSERT INTO client_dp_brkg
                     (clidb_dpam_id
                     ,clidb_brom_id
                     ,clidb_created_by
                     ,clidb_created_dt
                     ,clidb_lst_upd_by
                     ,clidb_lst_upd_dt
                     ,clidb_deleted_ind
                     )  
                     VALUES
                     (@l_dpam_id
                     ,@l_brokerage
                     ,@pa_login_name
                     ,getdate()
                     ,@pa_login_name
                     ,getdate()
                     ,1
                     )*/
                     --
                     SET @l_error = @@error
                     --
                     IF @l_error > 0
                     BEGIN
                     --
                       SET @pa_msg = '#'+'could not change access for ' + convert(varchar, @l_demat_id) + isnull(@l_errorstr,'') 
                       -- 
                       ROLLBACK TRANSACTION
                       --
                       RETURN
                     --
                     END
                     ELSE
                     BEGIN
                     --
                       SET @l_errorstr = 'dp-accounts successfully inserted\edited '+ @rowdelimiter
                       --
                       COMMIT TRANSACTION
                     --
                     END
                   --
                   END--a_0
                   --
                   IF @l_action_type = 'E'
                   BEGIN--e_0
                   --
                     BEGIN TRANSACTION
                     --
                     UPDATE dp_acct_mstr       WITH (ROWLOCK)
                     SET    dpam_excsm_id    = dpam_excsm_id
                          , dpam_acct_no     = @l_acct_no 
                          --dpam_sba_no      = dpam_sba_no 
                          , dpam_dpm_id      = @l_dpm_id
                          , dpam_enttm_cd    = @l_enttm_cd 
                          , dpam_clicm_cd    = @l_ctgry_cd
                          , dpam_subcm_cd    = @l_subcm_cd
                          , dpam_stam_cd     = @l_status_cd
                          , dpam_sba_name    = @l_sba_name
						  ,dpam_lst_upd_by   = @pa_login_name
						  ,dpam_lst_upd_dt   = getdate()
                     WHERE  dpam_crn_no      = @pa_crn_no 
                     --AND    dpam_acct_no     = @l_acct_no
                     AND    dpam_sba_no      = convert(varchar, @l_demat_id)
                     and    dpam_excsm_id    = @l_excsm_id 
                     AND    dpam_deleted_ind = 1
                     --
                     SET @l_error = @@error
                     --
                     IF @l_error > 0
                     BEGIN--r1
                     --
                       SET @pa_msg = '#'+'could not change access for ' + convert(varchar, @l_demat_id) + ISNULL(@l_errorstr,'') 
                       -- 
                       ROLLBACK TRANSACTION
                       --
                       RETURN
                     --
                     END--r1
                     --
                     /*IF isnull(@l_brokerage,0) = 0
                     BEGIN
                     --
                       SELECT top 1 @l_brokerage = a.brom_id 
                       FROM   brokerage_mstr       a WITH (NOLOCK)
                            , excsm_prod_mstr      b WITH (NOLOCK)
                       WHERE  a.brom_excpm_id    = b.excpm_id
                       AND    b.excpm_excsm_id   = @l_excsm_id 
                     --  
                     END  
                     --
                     SELECT @l_dpam_id  = dpam_id
                     FROM   dp_acct_mstr  WITH (NOLOCK)
                     WHERE  dpam_sba_no = convert(varchar, @l_demat_id)
                     --
                     UPDATE client_dp_brkg      WITH (ROWLOCK)
                     SET    clidb_brom_id     = @l_brokerage
                     WHERE  clidb_dpam_id     = @l_dpam_id
                     AND    clidb_deleted_ind = 1*/
                     --
                     SET @l_error = @@error
                     --
                     IF @l_error > 0
                     BEGIN--r2
                     --
                       SET @pa_msg = '#'+'could not change access for ' + convert(varchar, @l_demat_id) + ISNULL(@l_errorstr,'') 
                       -- 
                       ROLLBACK TRANSACTION
                       --
                       RETURN
                     --
                     END--r2
                     ELSE
                     BEGIN--c2
                     --
                       SET @l_errorstr = 'dp-accounts successfully inserted\edited '+ @rowdelimiter
                       --
                       COMMIT TRANSACTION
                     --
                     END--c2
                   --
                   END--e_0
                   --
                   IF @l_action_type = 'D'
                   BEGIN--d_0
                   --
                     BEGIN TRANSACTION
                     --
                     UPDATE dp_acct_mstr        WITH (ROWLOCK)
                     SET    dpam_deleted_ind  = 0
                          , dpam_lst_upd_by   = @pa_login_name
                          , dpam_lst_upd_dt   = getdate()
                     WHERE  dpam_crn_no       = @pa_crn_no 
                     AND    dpam_acct_no      = @l_acct_no 
                     AND    dpam_sba_no       = @l_demat_id
                     and    dpam_excsm_id    = @l_excsm_id
                     AND    dpam_deleted_ind  = 1
                     --
                     SET @l_error = @@error
                     --
                     IF @l_error > 0
                     BEGIN--d_r1
                     --
                       SET @pa_msg = '#'+'could not change access for ' + convert(varchar, @l_demat_id) + isnull(@l_errorstr,'')
                       --
                       ROLLBACK TRANSACTION
                       --
                       RETURN
                     --
                     END--d_r1
                     --
                     UPDATE dp_holder_dtls      WITH (ROWLOCK)
                     SET    dphd_deleted_ind  = 0
                     WHERE  dphd_dpam_sba_no  = @l_demat_id
                     AND    dphd_deleted_ind  = 1
                     --
                     SET @l_error = @@error
                     --
                     IF @l_error > 0
                     BEGIN--d_r1
                     --
                       SET @pa_msg = '#'+'could not change access for ' + convert(varchar, @l_demat_id) + isnull(@l_errorstr,'')
                       --
                       ROLLBACK TRANSACTION
                       --
                       RETURN
                     --
                     END--d_r1
                     --
                     SELECT @l_dpam_id        = dpam_id
                     FROM   dp_acct_mstr        WITH (NOLOCK)
                     WHERE  dpam_crn_no       = @pa_crn_no 
                     AND    dpam_acct_no      = @l_acct_no 
                     AND    dpam_sba_no       = @l_demat_id 
                     and    dpam_excsm_id    = @l_excsm_id
                     AND    dpam_deleted_ind  = 1      
                     --
                  /*   UPDATE client_dp_brkg       WITH (ROWLOCK)
                     SET    clidb_deleted_ind  = 0
                          , clidb_lst_upd_by   = @pa_login_name
                          , clidb_lst_upd_dt   = getdate()
                     WHERE  clidb_dpam_id      = @l_dpam_id
                  
                     AND    clidb_deleted_ind  = 1
*/
                     --
                     SET @l_error = @@error
                     --
                     IF @l_error > 0
                     BEGIN--d_r2
                     --
                       SET @pa_msg = '#'+'could not change access for ' + convert(varchar, @l_demat_id) + isnull(@l_errorstr,'') 
                       -- 
                       ROLLBACK TRANSACTION
                       --
                       RETURN
                     --
                     END--d_r2
                     ELSE
                     BEGIN--d_c2
                     --
                       SET @l_errorstr = 'dp-accounts successfully inserted\edited '+ @rowdelimiter
                       --
                       COMMIT TRANSACTION
                     --
                     END--d_c2
                   --
                   END--d_0
                 --
                 END  --action=''
              --
              END  --chk_0
              ELSE --chk_1_2
              BEGIN
              --
                IF @l_action_type IN ('A','D','E')
                BEGIN--action=''
                --
                  IF EXISTS(SELECT * 
                            FROM   dp_acct_mstr_mak    WITH (NOLOCK)
                            WHERE  dpam_crn_no       = @pa_crn_no
                            --AND    dpam_acct_no      = @l_acct_no
                            AND    dpam_sba_no       = @l_demat_id 
                            and    dpam_excsm_id     = @l_excsm_id
                            AND    dpam_deleted_ind IN (0,4,8)
                           )
                  BEGIN --exts
                  --
                    BEGIN TRANSACTION
                    --   
                    UPDATE dp_acct_mstr_mak    WITH (ROWLOCK)
                    SET    dpam_deleted_ind  = 3
                         , dpam_lst_upd_by   = @pa_login_name
                         , dpam_lst_upd_dt   = getdate()
                    WHERE  dpam_crn_no       = @pa_crn_no
                    --AND    dpam_acct_no      = @l_acct_no
                    AND    dpam_sba_no       = @l_demat_id 
                    and    dpam_excsm_id     = @l_excsm_id
                    AND    dpam_deleted_ind IN (0,4,8)
                    --
                    SET @l_error = @@error
                    --
                    IF @l_error > 0
                    BEGIN
                    --
                      SET @l_errorstr = '#'+'could not change access for ' + convert(varchar, @l_demat_id) + isnull(@l_errorstr,'')
                      --
                      ROLLBACK TRANSACTION
                    --
                    END
                    ELSE
                    BEGIN
                    --
                      SET @l_errorstr = 'dp-accounts successfully inserted\edited '+ @rowdelimiter
                      --
                      COMMIT TRANSACTION
                    --
                    END
                  --
                  END  --exts
                  --
                  BEGIN TRANSACTION
                  --
                  --SELECT @l_dpammak_id      = isnull(MAX(dpammak_id),0)+1          
                  --FROM   dp_acct_mstr_mak     WITH (NOLOCK)      
                  --
                  IF not exists(select dpam_id from dp_acct_mstr where dpam_acct_no = @l_acct_no  and dpam_deleted_ind = 1)
                  BEGIN
                  --
				  if not exists( SELECT top 1 dpam_id from dp_acct_mstr_mak 
				  where    dpam_crn_no       = @pa_crn_no                   
                    AND    dpam_sba_no       = @l_demat_id 
                    and    dpam_excsm_id     = @l_excsm_id
				    order by dpam_lst_upd_dt desc)
			      begin
				  --
                  SELECT @l_dpam_id         = isnull(max(bitrm_bit_location),0)+1
                  FROM   bitmap_ref_mstr      WITH (NOLOCK)
                  WHERE  bitrm_parent_cd    = 'SBAID' 
                  AND    bitrm_child_cd     = 'SBAID'
                  AND    bitrm_deleted_ind  = 1

                  --
                  UPDATE bitmap_ref_mstr      WITH(ROWLOCK) 
                  SET    bitrm_bit_location = @l_dpam_id
                  WHERE  bitrm_parent_cd    = 'SBAID' 
                  AND    bitrm_child_cd     = 'SBAID'
                  AND    bitrm_deleted_ind  = 1
				  -- 
				  end
				  else
				  begin
					SELECT top 1 @l_dpam_id = dpam_id from dp_acct_mstr_mak 
					 where    dpam_crn_no       = @pa_crn_no                   
                    AND    dpam_sba_no       = @l_demat_id 
                    and    dpam_excsm_id     = @l_excsm_id
				    order by dpam_lst_upd_dt desc
				  end				  
                  --
                  END
                  ELSE
				  BEGIN
				  --
					select @l_dpam_id = dpam_id from dp_acct_mstr where dpam_acct_no = @l_acct_no  and dpam_deleted_ind = 1
				  --
				  END
                  /*
                  SELECT @l_dpam_id1        = isnull(MAX(dpam_id),0)+1          
                  FROM   dp_acct_mstr         WITH (NOLOCK)  
                  --
                  IF @l_dpam_id > @l_dpam_id1          
                  BEGIN          
                  --          
                    SET @l_dpam_id1 = @l_dpam_id          
                  --            
                  END 
                  */
                  --
                  IF EXISTS(SELECT dpam_id 
                            FROM   dp_acct_mstr  WITH (NOLOCK)
                            WHERE  dpam_sba_no = @l_demat_id 
                            AND    dpam_crn_no = @pa_crn_no
                            and    dpam_excsm_id     = @l_excsm_id 
                            )  
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
                  INSERT INTO dp_acct_mstr_mak
                  (dpam_id
                  ,dpam_crn_no
                  ,dpam_acct_no
                  ,dpam_sba_no
                  ,dpam_excsm_id
                  ,dpam_dpm_id
                  ,dpam_enttm_cd
                  ,dpam_clicm_cd
                  ,dpam_subcm_cd
                  ,dpam_stam_cd
                  ,dpam_created_by
                  ,dpam_created_dt
                  ,dpam_lst_upd_by
                  ,dpam_lst_upd_dt
                  ,dpam_deleted_ind
                  ,dpam_sba_name
                  ,dpam_brom_id
                  )  
                  VALUES
                  (@l_dpam_id
                  ,@pa_crn_no
                  ,@l_acct_no  
                  ,@l_demat_id 
                  ,@l_excsm_id 
                  ,@l_dpm_id   
                  ,@l_enttm_cd 
                  ,@l_ctgry_cd 
                  ,@l_subcm_cd 
                  ,@l_status_cd
                  ,@pa_login_name
                  ,getdate()
                  ,@pa_login_name
                  ,getdate()
                  ,case @l_action_type WHEN 'A' then 0
                                       WHEN 'E' then @l_edt_del_id                    
                                       WHEN 'D' then 4
                                       END
                  ,@l_sba_name 
                  ,@l_brokerage 
                  )
                  --
                  SET @l_error = @@error
                  --
                  IF @l_error > 0
                  BEGIN
                  --
                    SET @l_errorstr = '#'+'could not change access for ' + CONVERT(varchar, @l_demat_id) + ISNULL(@l_errorstr,'')
                    --
                    ROLLBACK TRANSACTION
                  --
                  END
                  ELSE
                  BEGIN
                  --
                    SET @l_errorstr = 'dp-accounts successfully inserted\edited '+ @rowdelimiter
                    --
                    SELECT @l_action = case @l_action_type WHEN 'A' THEN 'I' WHEN 'E' THEN 'E' WHEN 'D' THEN 'D' END
                    --
                    COMMIT TRANSACTION
                    --
                    SET @l_crn_dpam = convert(varchar,@pa_crn_no) + '|*~|'+ convert(varchar, @l_dpam_id) +'|*~|'
                    --
                    EXEC pr_ins_upd_list @l_crn_dpam, @l_action, 'dp acct mstr',@pa_login_name,'*|~*','|*~|','' 
                    
                    
--                     IF @l_action_type ='A'
--                    EXEC pr_pick_def_val @pa_crn_no,'DP' 
                  --
                  END
                --  
                END--action=''  
              --
              END --chk_1_2
            --
            END--if_val
          --  
          END--while_val  
        --
        END --01
        ELSE
        BEGIN
        --
          SELECT @l_old_crn_no      = dpam_crn_no  
               , @l_old_acct_no     = dpam_acct_no 
               , @l_old_demat_id    = dpam_sba_no  
               , @l_old_excsm_id    = dpam_excsm_id
               , @l_old_dpm_id      = dpam_dpm_id  
               , @l_old_enttm_id    = dpam_enttm_cd
               , @l_old_ctgry_cd    = dpam_clicm_cd
               , @l_old_subcm_cd    = dpam_subcm_cd
               , @l_old_status_cd   = dpam_stam_cd
               , @l_old_brom        = dpam_brom_id
               , @l_old_deleted_ind = dpam_deleted_ind
               , @l_old_sba_name    = dpam_sba_name
          FROM   #t_maker
          WHERE  dpam_id         =  convert(numeric, @currstring_id)
          --
          
          IF @pa_action = 'REJ'          
          BEGIN--rej          
          --          
            UPDATE dp_acct_mstr_mak    WITH (ROWLOCK)          
            SET    dpam_deleted_ind  = 3          
                 , dpam_lst_upd_by   = @pa_login_name          
                 , dpam_lst_upd_dt   = getdate()           
            WHERE  dpam_id           = convert(numeric, @currstring_id)          
            AND    dpam_deleted_ind IN (0,4,8)          
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
          END--rej
          --
          IF @pa_action = 'APP'
          BEGIN--app
          --
            IF @l_old_deleted_ind = 4           
            BEGIN--4          
            --          
              UPDATE dp_acct_mstr_mak    WITH (ROWLOCK)          
              SET    dpam_deleted_ind  = 5          
                   , dpam_lst_upd_by   = @pa_login_name          
                   , dpam_lst_upd_dt   = getdate()          
              WHERE  dpam_deleted_ind  = 4          
              AND    dpam_id           = convert(numeric, @currstring_id)          
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
              UPDATE dp_acct_mstr        WITH (ROWLOCK)          
              SET    dpam_deleted_ind  = 0          
                   , dpam_lst_upd_by   = @pa_login_name          
                   , dpam_lst_upd_dt   = getdate()          
              WHERE  dpam_deleted_ind  = 1          
              AND    dpam_acct_no      = @l_old_acct_no          
              AND    dpam_sba_no       = @l_old_demat_id
              AND    dpam_clicm_cd     = @l_old_ctgry_cd
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
              UPDATE client_dp_brkg       WITH (ROWLOCK)          
              SET    clidb_deleted_ind  = 0          
                   , clidb_lst_upd_by   = @pa_login_name          
                   , clidb_lst_upd_dt   = getdate()           
              WHERE  clidb_dpam_id      = convert(numeric, @currstring_id)              
              AND    clidb_deleted_ind  = 1          
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
            END--4
            --
            ELSE IF @l_old_deleted_ind    = 8          
            BEGIN--8          
            --          
              UPDATE dp_acct_mstr_mak     WITH (ROWLOCK)          
              SET    dpam_deleted_ind   = 9          
                   , dpam_lst_upd_by    = @pa_login_name          
                   , dpam_lst_upd_dt    = getdate()          
              WHERE  dpam_deleted_ind   = 8          
              AND    dpam_id            = convert(numeric, @currstring_id)          
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
              UPDATE dp_acct_mstr       WITH (ROWLOCK)
              SET    dpam_excsm_id    = @l_old_excsm_id
                   , dpam_dpm_id      = @l_old_dpm_id
                   , dpam_enttm_cd    = @l_old_enttm_id
                   , dpam_clicm_cd    = @l_old_ctgry_cd
                   , dpam_subcm_cd    = @l_old_subcm_cd
                   , dpam_stam_cd     = @l_old_status_cd
                   , dpam_sba_name    = @l_old_sba_name
                   , dpam_lst_upd_by  = @pa_login_name
                   , dpam_lst_upd_dt  = getdate()
              WHERE  dpam_crn_no      = @l_old_crn_no
              AND    dpam_acct_no     = @l_old_acct_no
              AND    dpam_sba_no      = @l_old_demat_id    
              AND    dpam_deleted_ind = 1
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
              /*UPDATE client_dp_brkg       WITH (ROWLOCK)          
              SET    clidb_brom_id      = @l_old_brom          
                   , clidb_lst_upd_by   = @pa_login_name          
                   , clidb_lst_upd_dt   = getdate()           
              WHERE  clidb_dpam_id      = convert(numeric, @currstring_id)              
              AND    clidb_deleted_ind  = 1       */
                        
              SET @l_error = @@ERROR          
                        
              IF @l_error > 0          
              BEGIN          
              --          
                SET @l_errorstr = convert(varchar(10), @l_error)          
              --          
              END          
            --          
            END--8
            --
            ELSE IF @l_old_deleted_ind = 0           
            BEGIN--0          
            --          
              UPDATE dp_acct_mstr_mak    WITH (ROWLOCK)          
              SET    dpam_deleted_ind  = 1          
                   , dpam_lst_upd_by   = @pa_login_name          
                   , dpam_lst_upd_dt   = GETDATE()          
              WHERE  dpam_deleted_ind  = 0          
              AND    dpam_id           = convert(numeric, @currstring_id)          
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
              INSERT INTO dp_acct_mstr
              (dpam_id
              ,dpam_crn_no
              ,dpam_acct_no
              ,dpam_sba_no
              ,dpam_excsm_id
              ,dpam_dpm_id
              ,dpam_enttm_cd
              ,dpam_clicm_cd
              ,dpam_subcm_cd
              ,dpam_stam_cd
              ,dpam_created_by
              ,dpam_created_dt
              ,dpam_lst_upd_by
              ,dpam_lst_upd_dt
              ,dpam_deleted_ind
              ,dpam_sba_name
              )     
              SELECT dpam_id
                   , dpam_crn_no
                   , dpam_acct_no
                   , dpam_sba_no
                   , dpam_excsm_id
                   , dpam_dpm_id
                   , dpam_enttm_cd
                   , dpam_clicm_cd
                   , dpam_subcm_cd
                   , dpam_stam_cd      
                   , @pa_login_name          
                   , getdate()          
                   , @pa_login_name          
                   , getdate()          
                   , 1
                   , dpam_sba_name
              FROM   #t_maker         
              WHERE  dpam_id   = convert(numeric, @currstring_id)          
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
              /*INSERT INTO client_dp_brkg          
              (clidb_dpam_id          
              ,clidb_brom_id          
              ,clidb_created_by          
              ,clidb_created_dt          
              ,clidb_lst_upd_by          
              ,clidb_lst_upd_dt          
              ,clidb_deleted_ind          
              )          
              SELECT convert(numeric, @currstring_id)          
                   , dpam_brom_id          
                   , @pa_login_name          
                   , getdate()          
                   , @pa_login_name          
                   , getdate()          
                   , 1          
              FROM  #t_maker          
              WHERE dpam_id = convert(numeric, @currstring_id)     */
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
            END --0          
          --
          END--app
        --
        END
      --
      END--if_id
    --  
    END --while_id   
  --
  END --#1
  --
  SET @pa_msg = @l_errorstr
-- 
END

GO
