-- Object: PROCEDURE citrus_usr.pr_dp_ins_upd_addr_tushar
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

/*step 1 : insert into temp table all existing data for particular account id
step 2 : split the value as per address code 
   step 3 : check if same addresses code already exist for particular account id
     step 4 : compare old addresses and new addresses 
      step 5 : if same then nothig to do and delete from temp table  
      step 6 : else different then check addresses id used for other account id
        step 7 : if addresses id used for other account id then insert new record in addresses and map with account id
        step 8 : else update addreeses table 
   step 9 : same addresses code not exist for particular account id  
     step 10 : particular address already exists (same value)
       step 11 : if exists then map with account id
       step 12 : if not exists then insert into addresses  and map with account id
   step 13 : delete from entity_adr_conc those records which are remaining in temp table
*/
--select * from addresses where adr_id in (select accac_adr_conc_id from account_adr_conc where accac_clisba_id = 61178)
--begin transaction
--[pr_dp_ins_upd_addr_tushar] 	'260462','EDT','HO','0','546','DP','AC_COR_ADR1|*~|HGFH|*~||*~||*~||*~||*~|INDIA|*~|145879*|~*AC_PER_ADR1|*~|HGFH|*~|GJ|*~|G|*~|JJ|*~|BIHAR|*~|INDIA|*~|145879|*~|ACCOUNT PERMANENT ADDRESS|*~|*|~*GUARD_ADR|*~|BBBBBB edited|*~|BNNBN|*~||*~||*~||*~||*~|*|~*NOMINEE_ADR1|*~|HJKHK|*~||*~||*~||*~||*~||*~||*~|NOMINEE ADDRESS|*~|*|~*NOM_GUARDIAN_ADDR|*~|RRRRRRRRRRRRR|*~||*~||*~||*~||*~||*~|123456|*~|NOMINEE GUARDIAN ADDRESS|*~|*|~*','0','*|~*','|*~|',''	
--rollback transaction
CREATE procedure [citrus_usr].[pr_dp_ins_upd_addr_tushar](@pa_id           varchar(8000)  
                                    ,@pa_action       varchar(20)  
                                    ,@pa_login_name   varchar(20)  
                                    ,@pa_clisba_id    numeric
                                    ,@pa_demat_no     varchar(20)  
                                    ,@pa_acct_type    varchar(20)
                                    ,@pa_values       varchar(8000)  
                                    ,@pa_chk_yn       int  
                                    ,@rowdelimiter    char(4)  
                                    ,@coldelimiter    char(4)  
                                    ,@pa_msg          varchar(8000) OUTPUT  
)  
as
begin
--
  SET NOCOUNT ON
  --
  DECLARE @remainingstring_id      varchar(8000)  
        , @currstring_id           varchar(8000)  
        , @remainingstring_val     varchar(8000)  
        , @currstring_val          varchar(8000)
        , @foundat                 int  
        , @delimeterlength         int 
        , @delimeter               char(4)
        , @l_errorstr              varchar(8000)
        , @l_error                 numeric
        , @l_concm_desc            varchar(50)
                      --Cursor--
        , @c_access_cursor         cursor
        , @c_accac_clisba_id       numeric
        , @c_accac_acct_no         varchar(25)
        , @c_accac_acct_type       varchar(20)
        , @c_accac_concm_id        numeric 
        , @c_adr_id                numeric 
        , @c_adr_1                 varchar(50)
        , @c_adr_2                 varchar(50)
        , @c_adr_3                 varchar(50)
        , @c_adr_city              varchar(50)
        , @c_adr_state             varchar(50)
        , @c_adr_country           varchar(50)
        , @c_adr_zip               varchar(50)
                     --Addresses--
        , @l_adr_id                varchar(20)
        , @l_adr_1                 varchar(50)
        , @l_adr_2                 varchar(50)
        , @l_adr_3                 varchar(50)
        , @l_adr_city              varchar(50)
        , @l_adr_state             varchar(50)
        , @l_adr_country           varchar(50)
        , @l_adr_zip               varchar(50)
        , @l_old_addr_value        varchar(8000) 
        , @l_old_adr_id            numeric
        , @l_adrm_id               numeric
        , @l_clisba_id             numeric
        , @l_concm_id              numeric
        , @l_concm_cd              varchar(20)
        , @l_acct_no               varchar(25)
        , @l_acct_type             varchar(20)
        , @l_deleted_ind           smallint
        , @l_accac_adr_conc_id     numeric
        , @l_dpam_id               numeric
        , @l_chk_in                varchar(5)  

  IF @pa_action <> 'APP' and @pa_action <> 'REJ'
  BEGIN--nt_ap_rj
  --
    CREATE TABLE #t_addr
    (accac_clisba_id      numeric
    ,accac_acct_no        varchar(20)
    ,accac_acct_type      varchar(20)
    ,accac_concm_id       numeric
    ,adr_id               numeric
    ,adr_1                varchar(20)
    ,adr_2                varchar(20)
    ,adr_3                varchar(20)
    ,adr_city             varchar(20)
    ,adr_state            varchar(20)
    ,adr_country          varchar(20)
    ,adr_zip              varchar(20)
    )
    --
    SELECT @l_dpam_id       = dpam_id
    FROM   dp_acct_mstr       WITH (NOLOCK)  
    WHERE  dpam_sba_no      = convert(varchar(30), @pa_demat_no)
    AND    dpam_deleted_ind = 1
    --
    INSERT INTO #t_addr
    SELECT a.accac_clisba_id
         , a.accac_acct_no
         , a.accac_acct_type
         , a.accac_concm_id
         , b.adr_id
         , b.adr_1
         , b.adr_2
         , b.adr_3
         , b.adr_city
         , b.adr_state
         , b.adr_country
         , b.adr_zip
    FROM   account_adr_conc a    WITH (NOLOCK) 
    JOIN   addresses        b    WITH (NOLOCK) 
    ON    (a.accac_adr_conc_id = b.adr_id)
    WHERE  a.accac_clisba_id   = @l_dpam_id --@pa_clisba_id
    AND    a.accac_deleted_ind = 1
    AND    b.adr_deleted_ind   = 1
    --
   
  --
  END--nt_ap_rj
  --
  SET @l_error             = 0       
  SET @l_errorstr          = ''
  SET @delimeter           = '%'+@rowdelimiter+'%'  
  SET @delimeterlength     = LEN(@rowdelimiter) 
  SET @remainingstring_val = @pa_values
  SET @remainingstring_id  = @pa_id
  --
  WHILE @remainingstring_id <> ''  
  BEGIN--w_id  
  --  
    SET @foundat = 0  
    SET @foundat = PATINDEX('%'+@delimeter+'%',@remainingstring_id)  
    --
    IF @foundat > 0  
    BEGIN  
    --  
      SET @currstring_id      = SUBSTRING(@remainingstring_id, 0,@foundat)  
      SET @remainingstring_id = SUBSTRING(@remainingstring_id, @foundat+@delimeterlength,LEN(@remainingstring_id)- @foundat+@delimeterlength)  
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
    IF @currstring_id <> ''
    BEGIN--cur_id
    --
      IF @pa_action <> 'APP' AND @pa_action <> 'REJ'
      BEGIN--not_app_rej
      --
        WHILE @remainingstring_val <> ''  
        BEGIN--w_val  
        --  
          SET @foundat = 0  
          SET @foundat =  PATINDEX('%'+@delimeter+'%',@remainingstring_val)  
          --
          IF @foundat > 0  
          BEGIN  
          --  
            SET @currstring_val      = SUBSTRING(@remainingstring_val, 0,@foundat)  
            SET @remainingstring_val = SUBSTRING(@remainingstring_val, @foundat+@delimeterlength,LEN(@remainingstring_val)- @foundat+@delimeterlength)  
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
          IF @currstring_val <> ''
          BEGIN--cur_val
          --
            SET @l_concm_cd       = citrus_usr.fn_splitval(@currstring_val,1)  
            SET @l_adr_1          = citrus_usr.fn_splitval(@currstring_val,2)
            SET @l_adr_2          = citrus_usr.fn_splitval(@currstring_val,3)
            SET @l_adr_3          = citrus_usr.fn_splitval(@currstring_val,4)
            SET @l_adr_city       = citrus_usr.fn_splitval(@currstring_val,5)
            SET @l_adr_state      = citrus_usr.fn_splitval(@currstring_val,6)
            SET @l_adr_country    = citrus_usr.fn_splitval(@currstring_val,7)
            SET @l_adr_zip        = CONVERT(varchar, citrus_usr.fn_splitval(@currstring_val,8))
            --
            SELECT @l_concm_id       = concm_id
            FROM   conc_code_mstr      WITH (NOLOCK)
            WHERE  concm_cd          = @l_concm_cd
            AND    concm_deleted_ind = 1
           
            set @l_dpam_id = 0 

            SET @l_chk_in = LEFT(@pa_demat_no,2)
            --
            IF rtrim(ltrim(@l_chk_in)) = 'IN' 
            BEGIN
            --
              SET @pa_demat_no = RIGHT(@pa_demat_no,len(@pa_demat_no)-8) 
            --
            END

            SELECT @l_dpam_id       = dpam_id
            FROM   dp_acct_mstr       WITH (NOLOCK)  
            WHERE  dpam_sba_no      = convert(varchar(30), @pa_demat_no)
            AND    dpam_deleted_ind = 1

            if @l_dpam_id = 0 
            SELECT @l_dpam_id       = dpam_id
            FROM   dp_acct_mstr_mak   WITH (NOLOCK)  
            WHERE  dpam_sba_no      = convert(varchar(30), @pa_demat_no)
            AND    dpam_deleted_ind in (0,4,6)

            if @pa_chk_yn = 0
            begin
            --
              if exists(select accac_concm_id from account_adr_conc where accac_clisba_id = @l_dpam_id and accac_concm_id = @l_concm_id and accac_deleted_ind =1 )
              begin
              --

                select @l_old_addr_value = isnull(ADR_1,'')+isnull(ADR_2,'')+isnull(ADR_3,'')+isnull(ADR_CITY,'')+isnull(ADR_STATE,'')+isnull(ADR_COUNTRY,'')+isnull(ADR_ZIP,'')
                , @l_old_adr_id = adr_id 
                from addresses 
                    ,account_adr_conc 
                where accac_adr_conc_id = adr_id 
                and   accac_concm_id  = @l_concm_id 
                and   accac_clisba_id = @l_dpam_id 
              
                if @l_old_addr_value  = isnull(@l_adr_1,'') +  isnull(@l_adr_2,'')+  isnull(@l_adr_3,'') + isnull( @l_adr_city,'') + isnull(@l_adr_state,'') +  isnull(@l_adr_country,'')  + isnull( @l_adr_zip,'')        
                begin 
                --
                   DELETE FROM #t_addr 
                   WHERE accac_concm_id   = @l_concm_id
                   AND   accac_clisba_id  = @l_dpam_id
                --
                end
                else 
                begin
                --
                  declare @l_adr_ins  char(1)
                  set @l_adr_ins = 'N'
                  if exists(select accac_clisba_id from account_adr_conc where accac_adr_conc_id = @l_old_adr_id and accac_clisba_id <> @l_dpam_id and accac_deleted_ind = 1)
                  set @l_adr_ins = 'Y'
                  if exists(select accac_clisba_id from account_adr_conc where accac_adr_conc_id = @l_old_adr_id and accac_concm_id <> @l_concm_id and accac_clisba_id = @l_dpam_id and accac_deleted_ind = 1)  
                  set @l_adr_ins = 'Y'
                  
                  if @l_adr_ins = 'Y'
                  begin
                  --
                    BEGIN TRANSACTION
                        --
                        SELECT @l_adr_id          = bitrm_bit_location
                        FROM   bitmap_ref_mstr      WITH (NOLOCK)
                        WHERE  bitrm_parent_cd    = 'ADR_CONC_ID'
                        AND    bitrm_child_cd     = 'ADR_CONC_ID'

                        UPDATE bitmap_ref_mstr      WITH (ROWLOCK)
                        SET    bitrm_bit_location = bitrm_bit_location + 1
                        WHERE  bitrm_parent_cd    = 'ADR_CONC_ID'
                        AND    bitrm_child_cd     = 'ADR_CONC_ID'
                        --
                        INSERT INTO addresses
                        (adr_id
                        ,adr_1
                        ,adr_2
                        ,adr_3
                        ,adr_city
                        ,adr_state
                        ,adr_country
                        ,adr_zip
                        ,adr_created_by
                        ,adr_created_dt
                        ,adr_lst_upd_by
                        ,adr_lst_upd_dt
                        ,adr_deleted_ind
                        )
                        VALUES
                        (@l_adr_id
                        ,@l_adr_1
                        ,@l_adr_2
                        ,@l_adr_3
                        ,@l_adr_city
                        ,@l_adr_state
                        ,@l_adr_country
                        ,@l_adr_zip
                        ,@pa_login_name
                        ,getdate()
                        ,@pa_login_name
                        ,getdate()
                        ,1
                        )
                        --
                        SET @l_error = @@ERROR
                        --
                        IF @l_error > 0  
                        BEGIN--#r
                        --
                          SELECT @l_concm_desc     = concm_desc
                          FROM   conc_code_mstr      WITH (NOLOCK)
                          WHERE  concm_id          = @l_concm_id
                          AND    concm_deleted_ind = 1
                          --
                          SET @l_errorstr = @l_concm_desc+' Could not be Inserted/Edited'+@rowdelimiter+@l_errorstr
                          --
                          ROLLBACK TRANSACTION
                        --
                        END--#r
                        ELSE
                        BEGIN--#c
                        --
                          UPDATE account_adr_conc    WITH (ROWLOCK)
                          SET    accac_adr_conc_id = @l_adr_id
                          WHERE  accac_clisba_id   = @l_dpam_id--@pa_clisba_id
                          AND    accac_concm_id    = @l_concm_id
                          AND    accac_deleted_ind = 1
                          --
                          SET @l_error = @@ERROR
                          --
                          IF @l_error > 0
                          BEGIN--#r1
                          --
                            SELECT @l_concm_desc     = concm_desc
                            FROM   conc_code_mstr      WITH (NOLOCK)
                            WHERE  concm_id          = @l_concm_id
                            AND    concm_deleted_ind = 1
                            --
                            SET @l_errorstr = @l_concm_desc+' Could not be Inserted'+@rowdelimiter+@l_errorstr
                            --
                            ROLLBACK TRANSACTION
                          --
                          END--#r1
                          ELSE
                          BEGIN--#c1
                          --
                            COMMIT TRANSACTION
                          --
                          END--#c1
                        --
                       end 

                  --
                  end
                  else if @l_adr_ins = 'N'
                  begin 
                  --
                     BEGIN TRANSACTION
                    --
                    UPDATE addresses      WITH (ROWLOCK)
                    SET    adr_1          = @l_adr_1
                         , adr_2          = @l_adr_2
                         , adr_3          = @l_adr_3
                         , adr_city       = @l_adr_city
                         , adr_state      = @l_adr_state
                         , adr_country    = @l_adr_country
                         , adr_zip        = @l_adr_zip
                         , adr_lst_upd_by = @pa_login_name
                         , adr_lst_upd_dt = getdate()
                    WHERE  adr_id         = @l_old_adr_id
                    AND    adr_deleted_ind= 1
                    --
                    SET @l_error = @@ERROR
                    --
                    IF @l_error > 0
                    BEGIN
                    --
                      SELECT @l_concm_desc    = concm_desc
                      FROM   conc_code_mstr    WITH (NOLOCK)
                      WHERE  concm_id          = @l_concm_id
                      AND    concm_deleted_ind = 1
                      --
                      SET @l_errorstr = @l_concm_desc+' Could not be Inserted'+@rowdelimiter+@l_errorstr
                      --
                      ROLLBACK TRANSACTION
                    --
                    END
                    ELSE
                    BEGIN
                    --
                      COMMIT TRANSACTION
                    --
                    END
                  --
                  end
                
                   DELETE FROM #t_addr 
                   WHERE accac_concm_id   = @l_concm_id
                   AND   accac_clisba_id  = @l_dpam_id

                --
                end   
              --
              end
              else
              begin
              --
                IF EXISTS(SELECT adr_id
                              FROM   addresses WITH (NOLOCK)
                              WHERE  adr_1           = @l_adr_1
                              AND    adr_2           = @l_adr_2
                              AND    adr_3           = @l_adr_3
                              AND    adr_city        = @l_adr_city
                              AND    adr_state       = @l_adr_state
                              AND    adr_country     = @l_adr_country
                              AND    adr_zip         = @l_adr_zip
                              AND    adr_deleted_ind = 1
                             )
                    BEGIN--a_exts2
                    --
                      BEGIN TRANSACTION
                      --
                      SELECT @l_adr_id      = adr_id
                      FROM   addresses       WITH (NOLOCK)
                      WHERE  adr_1           = @l_adr_1
                      AND    adr_2           = @l_adr_2
                      AND    adr_3           = @l_adr_3
                      AND    adr_city        = @l_adr_city
                      AND    adr_state       = @l_adr_state
                      AND    adr_country     = @l_adr_country
                      AND    adr_zip         = @l_adr_zip
                      AND    adr_deleted_ind = 1
                      --
                      INSERT INTO account_adr_conc
                      (accac_clisba_id
                      ,accac_acct_no
                      ,accac_acct_type
                      ,accac_concm_id
                      ,accac_adr_conc_id
                      ,accac_created_by
                      ,accac_created_dt
                      ,accac_lst_upd_by
                      ,accac_lst_upd_dt
                      ,accac_deleted_ind
                      )
                      VALUES
                      (@l_dpam_id--@pa_clisba_id
                      ,@pa_demat_no
                      ,@pa_acct_type
                      ,@l_concm_id
                      ,@l_adr_id
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
                        SELECT @l_concm_desc    = concm_desc
                        FROM   conc_code_mstr    WITH (NOLOCK)
                        WHERE  concm_id          = @l_concm_id
                        AND    concm_deleted_ind = 1
                        --
                        SET @l_errorstr = @l_concm_desc+' Could not be Inserted/Edited'+@rowdelimiter+ISNULL(@l_errorstr,'')
                        --
                        ROLLBACK TRANSACTION
                      --
                      END
                      BEGIN
                      --
                        COMMIT TRANSACTION
                      --
                      END
                    --
                    END--a_exts2
                    ELSE
                    BEGIN--a_n_exts2
                    --
                      BEGIN TRANSACTION
                      --
                      SELECT @l_adr_id         = bitrm_bit_location
                      FROM   bitmap_ref_mstr    WITH (NOLOCK)
                      WHERE  bitrm_parent_cd    = 'ADR_CONC_ID'
                      AND    bitrm_child_cd     = 'ADR_CONC_ID'
                      --
                      UPDATE bitmap_ref_mstr    WITH (ROWLOCK)
                      SET    bitrm_bit_location = bitrm_bit_location+1
                      WHERE  bitrm_parent_cd    = 'ADR_CONC_ID'
                      AND    bitrm_child_cd     = 'ADR_CONC_ID'
                      --
                      INSERT INTO addresses
                      (adr_id
                      ,adr_1
                      ,adr_2
                      ,adr_3
                      ,adr_city
                      ,adr_state
                      ,adr_country
                      ,adr_zip
                      ,adr_created_by
                      ,adr_created_dt
                      ,adr_lst_upd_by
                      ,adr_lst_upd_dt
                      ,adr_deleted_ind)
                      VALUES
                      (@l_adr_id
                      ,@l_adr_1
                      ,@l_adr_2
                      ,@l_adr_3
                      ,@l_adr_city
                      ,@l_adr_state
                      ,@l_adr_country
                      ,@l_adr_zip
                      ,@pa_login_name
                      ,getdate()
                      ,@pa_login_name
                      ,getdate()
                      ,1
                      )
                      --
                      SET @l_error = @@ERROR
                      --
                      IF @l_error > 0 
                      BEGIN
                      --
                        SELECT @l_concm_desc     = concm_desc
                        FROM   conc_code_mstr    WITH (NOLOCK)
                        WHERE  concm_id          = @l_concm_id
                        AND    concm_deleted_ind = 1
                        --
                        SET @l_errorstr = @l_concm_desc+' Could not be Inserted/Edited'+@rowdelimiter+ISNULL(@l_errorstr,'')
                        --
                        ROLLBACK TRANSACTION
                      --
                      END
                      ELSE 
                      BEGIN
                      --
                        INSERT INTO account_adr_conc
                        (accac_clisba_id
                        ,accac_acct_no
                        ,accac_acct_type
                        ,accac_concm_id
                        ,accac_adr_conc_id
                        ,accac_created_by
                        ,accac_created_dt
                        ,accac_lst_upd_by
                        ,accac_lst_upd_dt
                        ,accac_deleted_ind
                        )
                        VALUES
                        (@l_dpam_id--@pa_clisba_id
                        ,@pa_demat_no
                        ,@pa_acct_type
                        ,@l_concm_id
                        ,@l_adr_id
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
                          SELECT @l_concm_desc    = concm_desc
                          FROM   conc_code_mstr      WITH (NOLOCK)
                          WHERE  concm_id          = @l_concm_id
                          AND    concm_deleted_ind = 1
                          --
                          SET @l_errorstr = @l_concm_desc+' Could not be Inserted/Edited'+@rowdelimiter+ISNULL(@l_errorstr,'')
                          --
                          ROLLBACK TRANSACTION
                        --
                        END
                        ELSE
                        BEGIN
                        --
                          COMMIT TRANSACTION
                        --
                        END
                      --
                      END
                    --
                    END--a_n_exts2 
              --
              end 
             
              
            --
            end
            else if @pa_chk_yn = 1 or @pa_chk_yn = 2
            begin
            --
              if @pa_action ='INS'
              begin
              --
                BEGIN TRANSACTION
                  --
                  SELECT @l_adrm_id = ISNULL(MAX(adrm_id),0) + 1 
                  FROM   addr_acct_mak WITH (NOLOCK)
                  --
                  INSERT INTO addr_acct_mak
                  (adrm_id
                  ,adr_clisba_id
                  ,adr_acct_no
                  ,adr_acct_type
                  ,adr_concm_id
                  ,adr_concm_cd
                  ,adr_id
                  ,adr_1
                  ,adr_2
                  ,adr_3
                  ,adr_city
                  ,adr_state
                  ,adr_country
                  ,adr_zip
                  ,adr_created_by
                  ,adr_created_dt
                  ,adr_lst_upd_by
                  ,adr_lst_upd_dt
                  ,adr_deleted_ind
                  )
                  VALUES
                  (@l_adrm_id
                  ,@l_dpam_id --@pa_clisba_id
                  ,@pa_demat_no
                  ,@pa_acct_type
                  ,@l_concm_id
                  ,@l_concm_cd
                  ,0
                  ,@l_adr_1
                  ,@l_adr_2
                  ,@l_adr_3
                  ,@l_adr_city
                  ,@l_adr_state
                  ,@l_adr_country
                  ,@l_adr_zip
                  ,@pa_login_name
                  ,GETDATE()
                  ,@pa_login_name
                  ,GETDATE()
                  ,0
                  )
                  --
                  SET @l_error = @@ERROR
                  --
                  IF @l_error > 0  
                  BEGIN--#r
                  --
                    SELECT @l_concm_desc     = concm_desc
                    FROM   conc_code_mstr      WITH (NOLOCK)
                    WHERE  concm_id          = @l_concm_id
                    AND    concm_deleted_ind = 1
                    --
                    SET @l_errorstr = @l_concm_desc+' Could not be Inserted/Edited'+@rowdelimiter+@l_errorstr
                    --
                    ROLLBACK TRANSACTION
                  --
                  END--#r
                  ELSE
                  BEGIN--#c
                  --
                    COMMIT TRANSACTION
                  --
                  END--#c
                  --
                  --EXEC pr_ins_upd_list @pa_clisba_id, 'I','ADDRESSES', @pa_login_name,'*|~*','|*~|','' 
              --
              end
              else if   @pa_action ='EDT'
              begin 
              --
                 IF ISNULL(@pa_values,'') = ''
                  BEGIN--null
                  --
                    SET    @c_access_cursor    = CURSOR FAST_FORWARD FOR
					SELECT --accac_clisba_id
						 --, accac_acct_no
						 --, accac_acct_type
						 
						  adr_id
						 , adr_1
						 , adr_2
						 , adr_3
						 , adr_city
						 , adr_state
						 , adr_country
						 , adr_zip
					FROM   #t_addr

                    OPEN @c_access_cursor
                    --
                    FETCH NEXT FROM @c_access_cursor INTO @c_adr_id, @c_adr_1, @c_adr_2, @c_adr_3, @c_adr_city, @c_adr_state , @c_adr_country, @c_adr_zip
                    --                                      
                    WHILE @@fetch_status = 0
                    BEGIN--while
                    --
                      SELECT @l_adrm_id   = ISNULL(MAX(adrm_id),0) + 1 
                      FROM   addr_acct_mak  WITH (NOLOCK)
                      --
                      SELECT @l_concm_cd       = concm_cd
                      FROM   conc_code_mstr      WITH (NOLOCK)
                      WHERE  concm_id          = @l_concm_id
                      AND    concm_deleted_ind = 1
                      --
                      INSERT INTO addr_acct_mak
                      (adrm_id
                      ,adr_clisba_id
                      ,adr_acct_no
                      ,adr_acct_type
                      ,adr_concm_id
                      ,adr_concm_cd
                      ,adr_id
                      ,adr_1
                      ,adr_2
                      ,adr_3
                      ,adr_city
                      ,adr_state
                      ,adr_country
                      ,adr_zip
                      ,adr_created_by
                      ,adr_created_dt
                      ,adr_lst_upd_by
                      ,adr_lst_upd_dt
                      ,adr_deleted_ind
                      )
                      VALUES
                      (@l_adrm_id
                      ,@l_dpam_id--@pa_clisba_id
                      ,@pa_demat_no
                      ,@pa_acct_type
                      ,@l_concm_id
                      ,@l_concm_cd
                      ,0
                      ,@l_adr_1
                      ,@l_adr_2
                      ,@l_adr_3
                      ,@l_adr_city
                      ,@l_adr_state
                      ,@l_adr_country
                      ,@l_adr_zip
                      ,@pa_login_name
                      ,GETDATE()
                      ,@pa_login_name
                      ,GETDATE()
                      ,4
                      )
                      --
                      FETCH NEXT FROM @c_access_cursor INTO @c_adr_id, @c_adr_1, @c_adr_2, @c_adr_3, @c_adr_city, @c_adr_state , @c_adr_country, @c_adr_zip
                    --
                    END--while
                    --
                    CLOSE @c_access_cursor
                    DEALLOCATE @c_access_cursor
                    --
                    --EXEC pr_ins_upd_list @pa_clisba_id, 'D','ADDRESSES', @pa_login_name,'*|~*','|*~|','' 
                  --
                  END--null
                  ELSE
                  BEGIN
                  --
                    IF EXISTS(SELECT accac_clisba_id 
                              FROM   #t_addr
                              WHERE  accac_concm_id = @l_concm_id
                             )
                    BEGIN--exts_1
                    --
                      IF EXISTS(SELECT adr_clisba_id 
                                FROM   addr_acct_mak      WITH (NOLOCK)
                                WHERE  adr_deleted_ind IN (0,4,8)
                                AND    adr_clisba_id    = @l_dpam_id--@pa_clisba_id
                                AND    adr_concm_id     = @l_concm_id
                               )
                      BEGIN--exts_1_1
                      --
                        UPDATE addr_acct_mak       WITH (ROWLOCK)
                        SET    adr_deleted_ind   = 3
                             , adr_lst_upd_by    = @pa_login_name
                             , adr_lst_upd_dt    = GETDATE()
                        WHERE  adr_deleted_ind  IN(0,4,8)
                        AND    adr_clisba_id     = @l_dpam_id--@pa_clisba_id
                        AND    adr_concm_id      = @l_concm_id
                      --
                      END--exts_1_1 
                      
                      SELECT @l_old_addr_value = adr_1+ISNULL(adr_2,'')+ISNULL(adr_3,'')+ISNULL(adr_city,'')+ISNULL(adr_state,'')+ISNULL(adr_country,'')+ISNULL(adr_zip,'')
                           , @l_old_adr_id     = adr_id
                      FROM   #t_addr
                      WHERE  accac_concm_id    = @l_concm_id
                      --

                      IF @l_old_addr_value     =  @l_adr_1+ISNULL(@l_adr_2,'')+ISNULL(@l_adr_3,'')+ISNULL(@l_ADR_CITY,'')+ISNULL(@l_adr_state,'')+ISNULL(@l_adr_country,'')+ISNULL(@l_adr_zip,'')
                      BEGIN--s_1
                      --
                        DELETE FROM #t_addr 
                        WHERE accac_concm_id   = @l_concm_id
                        AND   accac_clisba_id  = @l_dpam_id--@pa_clisba_id
                      --
                      END--s_1	
                      ELSE
                      BEGIN
                      --
                        SELECT @l_adrm_id = ISNULL(MAX(adrm_id),0) + 1 
                          FROM addr_acct_mak WITH (NOLOCK)
                          --
                          SELECT @l_concm_cd     = concm_cd
                          FROM   conc_code_mstr     WITH (NOLOCK)
                          WHERE  concm_id         = @l_concm_id
                          AND    concm_deleted_ind = 1
                          --
                          INSERT INTO addr_acct_mak
                          (adrm_id
                          ,adr_clisba_id
                          ,adr_acct_no
                          ,adr_acct_type
                          ,adr_concm_id
                          ,adr_concm_cd
                          ,adr_id
                          ,adr_1
                          ,adr_2
                          ,adr_3
                          ,adr_city
                          ,adr_state
                          ,adr_country
                          ,adr_zip
                          ,adr_created_by
                          ,adr_created_dt
                          ,adr_lst_upd_by
                          ,adr_lst_upd_dt
                          ,adr_deleted_ind
                          )
                          VALUES
                          (@l_adrm_id
                          ,@l_dpam_id--@pa_clisba_id
                          ,@pa_demat_no
                          ,@pa_acct_type
                          ,@l_concm_id
                          ,@l_concm_cd
                          ,@c_adr_id
                          ,@l_adr_1
                          ,@l_adr_2
                          ,@l_adr_3
                          ,@l_adr_city
                          ,@l_adr_state
                          ,@l_adr_country
                          ,@l_adr_zip
                          ,@pa_login_name
                          ,GETDATE()
                          ,@pa_login_name
                          ,GETDATE()
                          ,8
                          )
                          --
                          DELETE FROM #t_addr
                          WHERE accac_concm_id   = @l_concm_id
                          AND   accac_clisba_id  = @l_dpam_id--@pa_clisba_id   
                      --
                      END
                    -- 
                    END--exts_1
                    ELSE
                    BEGIN
                    --
                       IF EXISTS(SELECT adr_clisba_id 
                                FROM   addr_acct_mak
                                WHERE  adr_deleted_ind IN (0,4,8)
                                AND    adr_clisba_id    = @l_dpam_id--@pa_clisba_id
                                AND    adr_concm_id     = @l_concm_id
                                )
                      BEGIN
                      --
                        UPDATE addr_acct_mak      WITH (ROWLOCK)
                        SET    adr_deleted_ind  = 3
                        WHERE  adr_deleted_ind IN (0,4,8)
                        AND    adr_clisba_id    = @l_dpam_id--@pa_clisba_id
                        AND    adr_concm_id     = @l_concm_id
                      --
                      END
                      --
                      SELECT @l_adrm_id = ISNULL(MAX(adrm_id),0) + 1 
                      FROM   addr_acct_mak WITH (NOLOCK)
                      --
                      SELECT @l_concm_cd     = concm_cd
                      FROM   conc_code_mstr     WITH (NOLOCK)
                      WHERE  concm_id         = @l_concm_id
                      AND    concm_deleted_ind = 1
                      --           
                      INSERT INTO addr_acct_mak
                      (adrm_id
                      ,adr_clisba_id
                      ,adr_acct_no
                      ,adr_acct_type
                      ,adr_concm_id
                      ,adr_concm_cd
                      ,adr_id
                      ,adr_1
                      ,adr_2
                      ,adr_3
                      ,adr_city
                      ,adr_state
                      ,adr_country
                      ,adr_zip
                      ,adr_created_by
                      ,adr_created_dt
                      ,adr_lst_upd_by
                      ,adr_lst_upd_dt
                      ,adr_deleted_ind
                      )
                      VALUES
                      (@l_adrm_id
                      ,@l_dpam_id--@pa_clisba_id
                      ,@pa_demat_no
                      ,@pa_acct_type
                      ,@l_concm_id
                      ,@l_concm_cd
                      ,0
                      ,@l_adr_1
                      ,@l_adr_2
                      ,@l_adr_3
                      ,@l_adr_city
                      ,@l_adr_state
                      ,@l_adr_country
                      ,@l_adr_zip
                      ,@pa_login_name
                      ,GETDATE()
                      ,@pa_login_name
                      ,GETDATE()
                      ,0
                      )

                    --
                    END  
                    
                       
                  --
                  END 
                   

              --
              end
              else if   @pa_action ='APP'
              begin 
              --
                SELECT @l_deleted_ind    = adr_deleted_ind
					 , @l_clisba_id      = adr_clisba_id
					 , @l_acct_no        = adr_acct_no
					 , @l_acct_type      = adr_acct_type
					 , @l_concm_id       = adr_concm_id                  
					 , @l_concm_cd       = adr_concm_cd                 
					 , @l_adr_id         = adr_id
					 , @l_adr_1          = adr_1          
					 , @l_adr_2          = adr_2        
					 , @l_adr_3          = adr_3
					 , @l_adr_city       = adr_city
					 , @l_adr_state      = adr_state
					 , @l_adr_country    = adr_country
					 , @l_adr_zip        = adr_zip
				FROM   addr_acct_mak        WITH (NOLOCK)
				WHERE  adrm_id            = CONVERT(numeric,@currstring_id)  
				AND    adr_deleted_ind   IN (0,4,8)
				--
				SELECT @l_accac_adr_conc_id = adr_id  
				FROM   addresses               WITH (NOLOCK)
				JOIN   account_adr_conc        WITH (NOLOCK) 
				ON     accac_adr_conc_id     = adr_id  
				WHERE  accac_clisba_id       = @l_clisba_id  
				AND    accac_concm_id        = @l_concm_id  
				AND    accac_deleted_ind     = 1  
				AND    adr_deleted_ind       = 1
              
                 IF @l_deleted_ind = 4
				 BEGIN--4
				 --
                    IF EXISTS(SELECT * 
                    FROM   account_adr_conc      WITH (NOLOCK) 
                    WHERE  accac_adr_conc_id  = @l_adr_id
                    AND    accac_clisba_id   <> @l_clisba_id
                    AND    accac_deleted_ind  = 1
                   )
				  BEGIN--exts_1
				  --
					UPDATE account_adr_conc    WITH (ROWLOCK)
					SET    accac_deleted_ind = 0
						 , accac_lst_upd_by  = @pa_login_name
						 , accac_lst_upd_dt  = GETDATE()
					WHERE  accac_deleted_ind = 1
					AND    accac_clisba_id   = @l_clisba_id
					AND    accac_concm_id    = @l_concm_id
				  --
				  END--exts_1
				  ELSE
				  BEGIN--n_exts_1
				  --
					UPDATE account_adr_conc    WITH (ROWLOCK)
					SET    accac_deleted_ind = 0
						 , accac_lst_upd_by  = @pa_login_name
						 , accac_lst_upd_dt  = GETDATE()
					WHERE  accac_deleted_ind = 1
					AND    accac_clisba_id   = @l_clisba_id
					AND    accac_concm_id    = @l_concm_id
					--  
					UPDATE addresses           WITH (ROWLOCK)
					SET    adr_deleted_ind   = 0
						 , adr_lst_upd_by    = @pa_login_name
						 , adr_lst_upd_dt    = GETDATE()
					WHERE  adr_deleted_ind   = 1
					AND    adr_id            = @l_adr_id 
				  --
				  END--n_exts_1
				  --
				  UPDATE addr_acct_mak         WITH (ROWLOCK)
				  SET    adr_deleted_ind     = 5
					   , adr_lst_upd_by      = @pa_login_name
					   , adr_lst_upd_dt      = GETDATE()
				  WHERE  adr_deleted_ind     = 4
				  AND    adrm_id             = CONVERT(numeric, @currstring_id)  
				 --
				 END   
                 IF @l_deleted_ind = 8
				 BEGIN--8
				 --
                   IF EXISTS(SELECT * FROM account_adr_conc   WITH (NOLOCK)
                    WHERE    accac_concm_id        = @l_concm_id
                    AND      accac_adr_conc_id     = @l_accac_adr_conc_id
                    AND      accac_clisba_id      <> @l_clisba_id
                    AND      accac_deleted_ind     = 1
                   )    
				  BEGIN--ext_1
				  --
					SELECT @l_adr_id         = bitrm_bit_location
					FROM   bitmap_ref_mstr      WITH (NOLOCK)
					WHERE  bitrm_parent_cd    = 'ADR_CONC_ID'
					AND    bitrm_child_cd     = 'ADR_CONC_ID'
					--   
					UPDATE bitmap_ref_mstr      WITH (ROWLOCK)
					SET    bitrm_bit_location = bitrm_bit_location+1
					WHERE  bitrm_parent_cd    ='ADR_CONC_ID'
					AND    bitrm_child_cd     ='ADR_CONC_ID'
					--
					INSERT INTO addresses
					(adr_id
					,adr_1
					,adr_2
					,adr_3
					,adr_city
					,adr_state
					,adr_country
					,adr_zip
					,adr_created_by
					,adr_created_dt
					,adr_lst_upd_by
					,adr_lst_upd_dt
					,adr_deleted_ind
					)
					VALUES
					(@l_adr_id
					,@l_adr_1
					,@l_adr_2
					,@l_adr_3
					,@l_adr_city
					,@l_adr_state
					,@l_adr_country
					,@l_adr_zip
					,@pa_login_name
					,GETDATE()
					,@pa_login_name
					,GETDATE()
					,1
					)
					--
					UPDATE account_adr_conc    WITH (ROWLOCK)
					SET    accac_adr_conc_id = @l_adr_id
						 , accac_lst_upd_by  = @pa_login_name
						 , accac_lst_upd_dt  = GETDATE() 
					WHERE  accac_clisba_id   = @l_clisba_id
					AND    accac_concm_id    = @l_concm_id
					AND    accac_deleted_ind = 1
				  --
				  END--ext_1
                  ELSE
                  BEGIN
                  --
					UPDATE addresses         WITH (ROWLOCK)
					SET    adr_1           = @l_adr_1
						  ,adr_2           = @l_adr_2
						  ,adr_3           = @l_adr_3
						  ,adr_city        = @l_adr_city
						  ,adr_state       = @l_adr_state
						  ,adr_country     = @l_adr_country
						  ,adr_zip         = @l_adr_zip
						  ,adr_lst_upd_by  = @pa_login_name
						  ,adr_lst_upd_dt  = GETDATE()
					WHERE  adr_id          = @l_adr_id
					AND    adr_deleted_ind = 1
                  --
                  END 
				 --
				 END   
                 IF @l_deleted_ind = 0
				 BEGIN--0
				 --
                   IF  EXISTS(SELECT adr_id
                     FROM   addresses         WITH (NOLOCK)
                     WHERE  adr_1           = @l_adr_1
                     AND    adr_2           = @l_adr_2
                     AND    adr_3           = @l_adr_3
                     AND    adr_city        = @l_adr_city
                     AND    adr_state       = @l_adr_state
                     AND    adr_country     = @l_adr_country
                     AND    adr_zip         = @l_adr_zip
                     AND    adr_deleted_ind = 1
                    )
					  BEGIN--exts_0
					  --
						SELECT @l_adr_id              = adr_id
						FROM   addresses                 WITH (NOLOCK)
						WHERE  adr_1                   = @l_adr_1
						AND    adr_2                   = @l_adr_2
						AND    adr_3                   = @l_adr_3
						AND    adr_city                = @l_adr_city
						AND    adr_state               = @l_adr_state
						AND    adr_country             = @l_adr_country
						AND    adr_zip                 = @l_adr_zip
						AND    adr_deleted_ind         = 1
						--
						INSERT INTO account_adr_conc
						(accac_clisba_id
						,accac_acct_no
						,accac_acct_type
						,accac_concm_id
						,accac_adr_conc_id
						,accac_created_by
						,accac_created_dt
						,accac_lst_upd_by
						,accac_lst_upd_dt
						,accac_deleted_ind
						)
						SELECT adr_clisba_id
							 , @l_acct_no
							 , @l_acct_type
							 , @l_concm_id
							 , @l_adr_id
							 , @pa_login_name
							 , GETDATE()
							 , @pa_login_name
							 , GETDATE()
							 , 1
						FROM   addr_acct_mak  WITH (NOLOCK)
						WHERE  adrm_id = CONVERT(numeric, @currstring_id)  
					  --
					  END--exts_0
					  ELSE
					  BEGIN--n_exts_0
					  --
						SELECT @l_adr_id         = bitrm_bit_location
						FROM   bitmap_ref_mstr      WITH(NOLOCK)
						WHERE  bitrm_parent_cd    = 'ADR_CONC_ID'
						AND    bitrm_child_cd     = 'ADR_CONC_ID'

						UPDATE bitmap_ref_mstr      WITH(ROWLOCK)
						SET    bitrm_bit_location = bitrm_bit_location + 1
						WHERE  bitrm_parent_cd    = 'ADR_CONC_ID'
						AND    bitrm_child_cd     = 'ADR_CONC_ID'
						--
						INSERT INTO addresses
						(adr_id
						,adr_1
						,adr_2
						,adr_3
						,adr_city
						,adr_state
						,adr_country
						,adr_zip
						,adr_created_by
						,adr_created_dt
						,adr_lst_upd_by
						,adr_lst_upd_dt
						,adr_deleted_ind
						)
						VALUES
						(@l_adr_id
						,@l_adr_1
						,@l_adr_2
						,@l_adr_3
						,@l_adr_city
						,@l_adr_state
						,@l_adr_country
						,@l_adr_zip
						,@pa_login_name
						,GETDATE()
						,@pa_login_name
						,GETDATE()
						,1
						)
						--
						INSERT INTO account_adr_conc
						(accac_clisba_id
						,accac_acct_no
						,accac_acct_type
						,accac_concm_id
						,accac_adr_conc_id
						,accac_created_by
						,accac_created_dt
						,accac_lst_upd_by
						,accac_lst_upd_dt
						,accac_deleted_ind
						)
						VALUES
						(@l_clisba_id
						,@l_acct_no
						,@l_acct_type 
						,@l_concm_id 
						,@l_adr_id
						,@pa_login_name
						,GETDATE()
						,@pa_login_name
						,GETDATE()
						,1
						)
					  --
					  END--n_exts_0
					  --
					  UPDATE addr_acct_mak     WITH (ROWLOCK)
					  SET    adr_deleted_ind = 1
						   , adr_lst_upd_by  = @pa_login_name
						   , adr_lst_upd_dt  = GETDATE()
					  WHERE  adr_deleted_ind = 0
					  AND    adrm_id         = CONVERT(numeric,@currstring_id)  
					--
										
				 --
				 END  
              --
              end
              else if   @pa_action ='REJ'
              begin 
              --
                 UPDATE addr_acct_mak       WITH (ROWLOCK)
                 SET    adr_deleted_ind   = 3
					  , adr_lst_upd_by    = @pa_login_name
					  , adr_lst_upd_dt    = GETDATE()
				 WHERE  adr_deleted_ind  IN(0,4,8)
				 AND    adrm_id           = CONVERT(numeric, @currstring_id)
              --
              end 
              
             --
            end

            
          --
          end
        --
        end
      --
      end
    --
    end
  --
  end    
  IF @PA_CHK_YN =0
  delete b from account_adr_conc b where  b.accac_concm_id in (select a.accac_concm_id from #t_addr a where a.accac_clisba_id = b.accac_clisba_id)  and b.accac_clisba_id = @l_dpam_id 
--
end

GO
