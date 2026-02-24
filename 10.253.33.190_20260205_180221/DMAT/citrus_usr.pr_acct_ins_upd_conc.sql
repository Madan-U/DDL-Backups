-- Object: PROCEDURE citrus_usr.pr_acct_ins_upd_conc
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE [citrus_usr].[pr_acct_ins_upd_conc](@pa_id           varchar(8000)  
                                    ,@pa_action       varchar(20)  
                                    ,@pa_login_name   varchar(20)  
                                    ,@pa_clisba_id    numeric
                                    ,@pa_acct_no      varchar(20)  
                                    ,@pa_acct_type    varchar(20)
                                    ,@pa_values       varchar(8000)  
                                    ,@pa_chk_yn       int  
                                    ,@rowdelimiter    char(4)  
                                    ,@coldelimiter    char(4)  
                                    ,@pa_msg          varchar(8000) OUTPUT  
)  
AS
/*
*********************************************************************************
 system         : class
 module name    : pr_acct_ins_upd_conc
 description    : this procedure will add new values to account_adr_conc & conctact_channel
 copyright(c)   : MarketPlace Technolgies Pvt. Ltd.
 version history: 1.0
 VERS.  AUTHOR          DATE          REASON
 -----  -------------   ----------    -----------------------------------------------
 1.0    Sukhvinder      05-may-2007   Initial version.
 -----------------------------------------------------------------------------------
*/
BEGIN  
--  
  SET NOCOUNT ON
  --
  DECLARE @@remainingstring_id        varchar(8000)  
        , @@currstring_id             varchar(8000)  
        , @@remainingstring_val       varchar(8000)  
        , @@currstring_val            varchar(8000)
        , @@foundat                   int  
        , @@delimeterlength           int 
        , @@delimeter                 char(4)
        , @@l_errorstr                varchar(8000)
        , @@l_error                   numeric
        --
        , @@l_concm_desc              varchar(50)  
        , @@l_conc_id                 numeric
        , @@l_conc_value              varchar(50)
        , @@l_old_conc_value          varchar(50)
        , @@l_old_conc_id             numeric
        , @@c_access_cursor           cursor
        , @@l_concmak_id              numeric
        --
        , @@l_deleted_ind             smallint 
        , @@l_clisba_id               numeric
        , @@l_acct_no                 varchar(25) 
        , @@l_acct_type               varchar(20)
        , @@l_concm_id                numeric
        , @@l_concm_cd                varchar(20)
        --         
        , @@c_clisba_id               numeric
        , @@c_acct_no                 varchar(25)
        , @@c_acct_type               varchar(20)
        , @@c_concm_id                numeric
        , @@c_conc_id                 numeric
        , @@c_conc_value              varchar(50)
        , @@l_accac_addr_conc_id      numeric
  --      
  --IF @pa_action <> 'APP' and @pa_action <> 'REJ'
  --BEGIN--nt_ap_rj
  --
    CREATE TABLE #t_conc
    (accac_clisba_id      numeric
    ,accac_acct_no        varchar(20)
    ,accac_acct_type      varchar(20)
    ,accac_concm_id       numeric
    ,accac_conc_id        numeric
    ,accac_conc_value     varchar(50)
    )
    --
    INSERT INTO #t_conc  
    SELECT a.accac_clisba_id  
         , a.accac_acct_no 
         , a.accac_acct_type  
         , a.accac_concm_id
         , b.conc_id  
         , b.conc_value  
    FROM   account_adr_conc a     WITH(NOLOCK)  
    JOIN   contact_channels b     WITH(NOLOCK)  
    ON     a.accac_adr_conc_id  = b.conc_id  
    WHERE  a.accac_clisba_id    = @pa_clisba_id  
    AND    a.accac_deleted_ind  = 1  
    AND    b.conc_deleted_ind   = 1
    --
    SET    @@c_access_cursor   = CURSOR FAST_FORWARD FOR
    SELECT accac_clisba_id
         , accac_acct_no    
         , accac_acct_type  
         , accac_concm_id   
         , accac_conc_id    
         , accac_conc_value 
    FROM   #t_conc  
  --
  --END--nt_ap_rj
  --
  SET @@l_error             = 0       
  SET @@l_errorstr          = ''
  SET @@delimeter           = '%'+@rowdelimiter+'%'  
  SET @@delimeterlength     = LEN(@rowdelimiter) 
  SET @@remainingstring_val = @pa_values
  SET @@remainingstring_id  = @pa_id
  --
  WHILE @@remainingstring_id <> ''  
  BEGIN--w_id  
  --  
    SET @@foundat = 0  
    SET @@foundat =  PATINDEX('%'+@@delimeter+'%',@@remainingstring_id)  
    --
    IF @@foundat > 0  
    BEGIN  
    --  
      SET @@currstring_id      = SUBSTRING(@@remainingstring_id, 0,@@foundat)  
      SET @@remainingstring_id = SUBSTRING(@@remainingstring_id, @@foundat+@@delimeterlength,LEN(@@remainingstring_id)- @@foundat+@@delimeterlength)  
    --  
    END  
    ELSE  
    BEGIN  
    --  
      SET @@currstring_id      = @@remainingstring_id  
      SET @@remainingstring_id = ''  
    --  
    END
    --
    IF @@currstring_id <> ''
    BEGIN--cur_id
    --
      
      IF @pa_action <> 'APP' AND @pa_action <> 'REJ'
      BEGIN--not_app_rej
      --
        WHILE @@remainingstring_val <> ''  
        BEGIN--w_val  
        --  
          SET @@foundat = 0  
          SET @@foundat =  PATINDEX('%'+@@delimeter+'%',@@remainingstring_val)  
          --
          IF @@foundat > 0  
          BEGIN  
          --  
            SET @@currstring_val      = SUBSTRING(@@remainingstring_val, 0,@@foundat)  
            SET @@remainingstring_val = SUBSTRING(@@remainingstring_val, @@foundat+@@delimeterlength,LEN(@@remainingstring_val)- @@foundat+@@delimeterlength)  
          --  
          END  
          ELSE  
          BEGIN  
          --  
            SET @@currstring_val      = @@remainingstring_val  
            SET @@remainingstring_val = ''  
          --  
          END
          --
          IF @@currstring_val <> ''
          BEGIN--cur_val
          --
            SET @@l_concm_cd       = citrus_usr.fn_splitval(@@currstring_val,1)
            SET @@l_conc_value     = citrus_usr.fn_splitval(@@currstring_val,2)
            --
            SELECT @@l_concm_id      = concm_id
            FROM   conc_code_mstr      WITH (NOLOCK)
            WHERE  concm_cd          = @@l_concm_cd
            AND    concm_deleted_ind = 1
            --            
            IF @pa_chk_yn = 1 OR @pa_chk_yn = 2
            BEGIN--chk_1_2
            --
              IF EXISTS(SELECT conc_clisba_id    
                        FROM   conc_acct_mak      WITH (NOLOCK)
                        WHERE  conc_deleted_ind IN (0,4,8)
                        AND    conc_clisba_id    = @pa_clisba_id
                        AND    conc_concm_id     = @@l_concm_id
                        )
              BEGIN--##
              --
                BEGIN TRANSACTION
                --
                UPDATE conc_acct_mak    WITH (ROWLOCK)
                SET    conc_deleted_ind  = 3
                     , conc_lst_upd_by   = @pa_login_name
                     , conc_lst_upd_dt   = GETDATE()
                WHERE  conc_deleted_ind IN (0,4,8)
                AND    conc_clisba_id    = @pa_clisba_id
                AND    conc_concm_id     = @@l_concm_id
                --
                SET @@l_error = @@ERROR
                --
                IF @@l_error > 0
                BEGIN
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
              END--##
            --
            END--chk_1_2
            --
            SELECT @@l_concm_cd      = concm_cd
            FROM   conc_code_mstr      WITH (NOLOCK)
            WHERE  concm_id          = @@l_concm_id
            AND    concm_deleted_ind = 1
            --
            IF @pa_action = 'INS'
            BEGIN--ins_c
            --
              IF @pa_chk_yn = 1 OR @pa_chk_yn = 2
              BEGIN--ins_1_2
              --
                BEGIN TRANSACTION
                --
                SELECT @@l_concmak_id = ISNULL(MAX(concmak_id),0) + 1 
                FROM conc_acct_mak WITH (NOLOCK)
                --
                INSERT INTO conc_acct_mak
                (concmak_id
                ,conc_clisba_id
                ,conc_acct_no
                ,conc_acct_type
                ,conc_concm_id
                ,conc_concm_cd
                ,conc_id
                ,conc_value
                ,conc_created_by
                ,conc_created_dt
                ,conc_lst_upd_by
                ,conc_lst_upd_dt
                ,conc_deleted_ind
                )
                VALUES
                (@@l_concmak_id
                ,@pa_clisba_id
                ,@pa_acct_no
                ,@pa_acct_type
                ,@@l_concm_id
                ,@@l_concm_cd
                ,0
                ,@@l_conc_value
                ,@pa_login_name
                ,GETDATE()
                ,@pa_login_name
                ,GETDATE()
                ,0
                )
                --
                SET @@l_error = @@ERROR
                --
                IF @@l_error > 0  
                BEGIN--#r
                --
                  SELECT @@l_concm_desc    = concm_desc
                  FROM   conc_code_mstr      WITH (NOLOCK)
                  WHERE  concm_id          = @@l_concm_id
                  AND    concm_deleted_ind = 1
                  --
                  SET @@l_errorstr = @@l_concm_desc+' Could not be Inserted/Edited'+@rowdelimiter+@@l_errorstr
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
                EXEC pr_ins_upd_list @pa_clisba_id, 'I','ADDRESSES', @pa_login_name,'*|~*','|*~|','' 
              --
              END--ins_1_2
              --
              IF @pa_chk_yn = 0
              BEGIN--chk_0
              --
                IF EXISTS(SELECT conc_id  
                          FROM   contact_channels  WITH(NOLOCK)  
                          WHERE  conc_value        = @@l_conc_value  
                          AND    conc_deleted_ind  = 1  
                         )  
                BEGIN--ext_1
                --
                  BEGIN TRANSACTION
                  --
                  SELECT @@l_conc_id       = conc_id  
                  FROM   contact_channels    WITH(NOLOCK)  
                  WHERE  conc_value        = @@l_conc_value 
                  AND    conc_deleted_ind  = 1
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
                  (@pa_clisba_id
                  ,@pa_acct_no
                  ,@pa_acct_type
                  ,@@l_concm_id
                  ,@@l_conc_id
                  ,@pa_login_name  
                  ,GETDATE()  
                  ,@pa_login_name  
                  ,GETDATE()  
                  ,1
                  )
                  --
                  SET @@l_error = @@ERROR
                  --
                  IF @@l_error > 0
                  BEGIN--r1
                  --
                    SELECT @@l_concm_desc    = concm_desc
                    FROM   conc_code_mstr    WITH (NOLOCK)
                    WHERE  concm_id          = @@l_concm_id
                    AND    concm_deleted_ind = 1
                    --
                    SET @@l_errorstr = ISNULL(@@l_concm_desc,'') +' Could not be Inserted/Edited'+@rowdelimiter+ISNULL(@@l_errorstr,'')
                    --
                    ROLLBACK TRANSACTION
                  --
                  END--r1
                  ELSE
                  BEGIN--c1
                  --
                    SELECT @@l_conc_id        = bitrm_bit_location  
                    FROM   bitmap_ref_mstr    WITH(NOLOCK)  
                    WHERE  bitrm_parent_cd    = 'ADR_CONC_ID'  
                    AND    bitrm_child_cd     = 'ADR_CONC_ID'  
                    --  
                    UPDATE bitmap_ref_mstr    WITH(ROWLOCK)  
                    SET    bitrm_bit_location = bitrm_bit_location + 1  
                    WHERE  bitrm_parent_cd    = 'ADR_CONC_ID'  
                    AND    bitrm_child_cd     = 'ADR_CONC_ID'  
                    --
                    INSERT INTO contact_channels  
                    (conc_id  
                    ,conc_value  
                    ,conc_created_by  
                    ,conc_created_dt  
                    ,conc_lst_upd_by  
                    ,conc_lst_upd_dt  
                    ,conc_deleted_ind
                    )  
                    VALUES  
                    (@@l_conc_id  
                    ,@@l_conc_value  
                    ,@pa_login_name  
                    ,GETDATE()  
                    ,@pa_login_name  
                    ,GETDATE()  
                    ,1
                    )  
                    --
                    SET @@l_error = @@error  
                    --  
                    IF @@l_error > 0  
                    BEGIN--r1_1  
                    --  
                      SELECT @@l_concm_desc    = concm_desc  
                      FROM   conc_code_mstr    WITH(NOLOCK)  
                      WHERE  concm_id          = @@l_concm_id  
                      AND    concm_deleted_ind = 1  
                      --  
                      SET @@l_errorstr = @@l_concm_desc+' Could not be Inserted'+@rowdelimiter+@@l_errorstr  
                      --  
                      ROLLBACK TRANSACTION  
                    --  
                    END--r1_1
                    ELSE
                    BEGIN--c1_1
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
                      (@pa_clisba_id
                      ,@pa_acct_no
                      ,@pa_acct_type
                      ,@@l_concm_id
                      ,@@l_conc_id
                      ,@pa_login_name  
                      ,GETDATE()  
                      ,@pa_login_name  
                      ,GETDATE()  
                      ,1
                      )
                      --  
                      SET @@l_error = @@error  
                      --  
                      IF @@l_error > 0
                      BEGIN--r_1_1  
                      --  
                        SELECT @@l_concm_desc    = concm_desc  
                        FROM   conc_code_mstr    WITH(NOLOCK)  
                        WHERE  concm_id          = @@l_concm_id  
                        AND    concm_deleted_ind = 1  
                        --  
                        SET @@l_errorstr = @@l_concm_desc+'Could not be Inserted'+@rowdelimiter+@@l_errorstr  
                        --  
                        ROLLBACK TRANSACTION  
                      --  
                      END--r_1_1    
                      ELSE  
                      BEGIN--c_1_1    
                      --  
                        COMMIT TRANSACTION  
                      --  
                      END  --c_1_1      
                    --
                    END--c1_1
                  --
                  END--c1
                --
                END--ext_1
              --
              END--chk_0
            --
            END --ins_c
            --
            IF @pa_action = 'EDT'
            BEGIN--edt_c
            --
              IF @pa_chk_yn = 1 or @pa_chk_yn = 2
              BEGIN--edt_1_2
              --
                IF ISNULL(@pa_values,'') = ''
                BEGIN--null
                --
                  OPEN @@c_access_cursor
                  --
                  FETCH NEXT FROM @@c_access_cursor INTO @@c_clisba_id, @@c_acct_no, @@c_acct_type, @@c_concm_id, @@c_conc_id, @@c_conc_value 
                  --                                      
                  WHILE @@fetch_status = 0
                  BEGIN--while
                  --
                    SELECT @@l_concmak_id    = ISNULL(MAX(concmak_id),0) + 1 
                    FROM   conc_acct_mak       WITH (NOLOCK)
                    --
                    SELECT @@l_concm_cd      = concm_cd
                    FROM   conc_code_mstr      WITH (NOLOCK)
                    WHERE  concm_id          = @@l_concm_id
                    AND    concm_deleted_ind = 1
                    --
                    INSERT INTO conc_acct_mak
                    (concmak_id
                    ,conc_clisba_id
                    ,conc_acct_no
                    ,conc_acct_type
                    ,conc_concm_id
                    ,conc_concm_cd
                    ,conc_id
                    ,conc_value
                    ,conc_created_by
                    ,conc_created_dt
                    ,conc_lst_upd_by
                    ,conc_lst_upd_dt
                    ,conc_deleted_ind
                    )
                    VALUES
                    (@@l_concmak_id
                    ,@pa_clisba_id
                    ,@pa_acct_no
                    ,@pa_acct_type
                    ,@@l_concm_id
                    ,@@l_concm_cd
                    ,0
                    ,@@l_conc_value
                    ,@pa_login_name
                    ,GETDATE()
                    ,@pa_login_name
                    ,GETDATE()
                    ,4
                    )
                    --
                    FETCH NEXT FROM @@c_access_cursor INTO @@c_clisba_id, @@c_acct_no, @@c_acct_type, @@c_concm_id, @@c_conc_id, @@c_conc_value 
                  --
                  END--while
                  --
                  CLOSE @@c_access_cursor
                  DEALLOCATE @@c_access_cursor
                  --
                  EXEC pr_ins_upd_list @pa_clisba_id, 'D','ADDRESSES', @pa_login_name,'*|~*','|*~|','' 
                --
                END--null
                ELSE
                BEGIN--n_null
                --
                  IF EXISTS(SELECT accac_clisba_id 
                            FROM   #t_conc
                            WHERE  accac_concm_id = @@l_concm_id
                           )
                  BEGIN--exts_1
                  --
                    IF EXISTS(SELECT conc_clisba_id 
                              FROM   conc_acct_mak       WITH (NOLOCK)
                              WHERE  conc_deleted_ind IN (0,4,8)
                              AND    conc_clisba_id    = @pa_clisba_id
                              AND    conc_concm_id     = @@l_concm_id
                             )
                    BEGIN--exts_1_1
                    --
                      UPDATE conc_acct_mak        WITH (ROWLOCK)
                      SET    conc_deleted_ind   = 3
                           , conc_lst_upd_by    = @pa_login_name
                           , conc_lst_upd_dt    = GETDATE()
                      WHERE  conc_deleted_ind  IN (0,4,8)
                      AND    conc_clisba_id     = @pa_clisba_id
                      AND    conc_concm_id      = @@l_concm_id
                    --
                    END--exts_1_1
                    --
                    SELECT @@l_old_conc_value   = accac_conc_value
                         , @@l_old_conc_id      = accac_conc_id
                    FROM   #t_conc
                    WHERE  accac_concm_id       = @@l_concm_id
                    --
                    IF @@l_old_conc_value = @@l_conc_value
                    BEGIN--s_1
                    --
                      DELETE FROM #t_conc 
                      WHERE accac_concm_id       = @@l_concm_id 
                      AND   accac_clisba_id      = @pa_clisba_id
                    --
                    END--s_1 
                    ELSE
                    BEGIN--n_s_1
                    --
                      OPEN @@C_ACCESS_CURSOR
                      --
                      FETCH NEXT FROM @@c_access_cursor INTO @@c_clisba_id, @@c_acct_no, @@c_acct_type, @@c_concm_id, @@c_conc_id, @@c_conc_value 
                      --                                      
                      WHILE @@fetch_status = 0
                      BEGIN--while
                      --
                        SELECT @@l_concmak_id = ISNULL(MAX(concmak_id),0) + 1 
                        FROM conc_acct_mak WITH (NOLOCK)
                        --
                        SELECT @@l_concm_cd      = concm_cd
                        FROM   conc_code_mstr      WITH (NOLOCK)
                        WHERE  concm_id          = @@l_concm_id
                        AND    concm_deleted_ind = 1
                        --
                        INSERT INTO conc_acct_mak
                        (concmak_id
                        ,conc_clisba_id
                        ,conc_acct_no
                        ,conc_acct_type
                        ,conc_concm_id
                        ,conc_concm_cd
                        ,conc_id
                        ,conc_value
                        ,conc_created_by
                        ,conc_created_dt
                        ,conc_lst_upd_by
                        ,conc_lst_upd_dt
                        ,conc_deleted_ind
                        )
                        VALUES
                        (@@l_concmak_id
                        ,@pa_clisba_id
                        ,@pa_acct_no
                        ,@pa_acct_type
                        ,@@l_concm_id
                        ,@@l_concm_cd
                        ,@@c_conc_id
                        ,@@c_conc_value
                        ,@pa_login_name
                        ,GETDATE()
                        ,@pa_login_name
                        ,GETDATE()
                        ,8
                        )
                        --
                        DELETE FROM #t_conc
                        WHERE accac_concm_id   = @@l_concm_id
                        AND   accac_clisba_id  = @pa_clisba_id
                        --
                        FETCH NEXT FROM @@c_access_cursor INTO @@c_clisba_id, @@c_acct_no, @@c_acct_type, @@c_concm_id, @@c_conc_id, @@c_conc_value 
                      --
                      END--while
                      --
                      CLOSE @@c_access_cursor
                      DEALLOCATE @@c_access_cursor
                      --
                      EXEC pr_ins_upd_list @pa_clisba_id, 'E','ADDRESSES', @pa_login_name,'*|~*','|*~|','' 
                    --
                    END--n_s_1
                  --
                  END--exts_1
                  ELSE
                  BEGIN--n_exts_1
                  --
                    IF EXISTS(SELECT conc_clisba_id 
                              FROM   conc_acct_mak        WITH (NOLOCK)
                              WHERE  conc_deleted_ind  IN (0,4,8)
                              AND    conc_clisba_id     = @pa_clisba_id
                              AND    conc_concm_id      = @@l_concm_id
                              )
                    BEGIN
                    --
                      UPDATE conc_acct_mak       WITH (ROWLOCK)
                      SET    conc_deleted_ind  = 3
                           , conc_lst_upd_by   = @pa_login_name
                           , conc_lst_upd_dt   = GETDATE()
                      WHERE  conc_deleted_ind IN (0,4,8)
                      AND    conc_clisba_id    = @pa_clisba_id
                      AND    conc_concm_id     = @@l_concm_id
                    --
                    END
                    --
                    SELECT @@l_concmak_id = ISNULL(MAX(concmak_id),0) + 1 
                    FROM   conc_acct_mak WITH (NOLOCK)
                    --
                    SELECT @@l_concm_cd      = concm_cd
                    FROM   conc_code_mstr      WITH (NOLOCK)
                    WHERE  concm_id          = @@l_concm_id
                    AND    concm_deleted_ind = 1
                    --           
                    INSERT INTO conc_acct_mak
                    (concmak_id
                    ,conc_clisba_id
                    ,conc_acct_no
                    ,conc_acct_type
                    ,conc_concm_id
                    ,conc_concm_cd
                    ,conc_id
                    ,conc_value
                    ,conc_created_by
                    ,conc_created_dt
                    ,conc_lst_upd_by
                    ,conc_lst_upd_dt
                    ,conc_deleted_ind
                    )
                    VALUES
                    (@@l_concmak_id
                    ,@pa_clisba_id
                    ,@pa_acct_no
                    ,@pa_acct_type
                    ,@@l_concm_id
                    ,@@l_concm_cd
                    ,0
                    ,@@l_conc_value
                    ,@pa_login_name
                    ,GETDATE()
                    ,@pa_login_name
                    ,GETDATE()
                    ,0
                    )
                    --
                    EXEC pr_ins_upd_list @pa_clisba_id, 'I','ADDRESSES', @pa_login_name,'*|~*','|*~|','' 
                  --
                  END --n_exts_1
                  --
                  IF EXISTS(SELECT * FROM #t_conc)
                  BEGIN--ext
                  --
                    OPEN @@c_access_cursor
                    --
                    FETCH NEXT FROM @@c_access_cursor INTO @@c_clisba_id, @@c_acct_no, @@c_acct_type, @@c_concm_id, @@c_conc_id, @@c_conc_value 
                    --
                    WHILE @@fetch_status = 0
                    BEGIN--while
                    --
                      SELECT @@l_concmak_id = ISNULL(MAX(concmak_id),0)+1 
                      FROM conc_acct_mak WITH (NOLOCK)
                      --
                      INSERT INTO conc_acct_mak
                      (concmak_id
                      ,conc_clisba_id
                      ,conc_acct_no
                      ,conc_acct_type
                      ,conc_concm_id
                      ,conc_concm_cd
                      ,conc_id
                      ,conc_value
                      ,conc_created_by
                      ,conc_created_dt
                      ,conc_lst_upd_by
                      ,conc_lst_upd_dt
                      ,conc_deleted_ind
                      )
                      VALUES
                      (@@l_concmak_id
                      ,@pa_clisba_id
                      ,@pa_acct_no
                      ,@pa_acct_type
                      ,@@l_concm_id
                      ,@@l_concm_cd
                      ,@@c_concm_id
                      ,@@c_conc_value
                      ,@pa_login_name
                      ,GETDATE()
                      ,@pa_login_name
                      ,GETDATE()
                      ,4
                      )
                      --
                      FETCH NEXT FROM @@c_access_cursor INTO @@c_clisba_id, @@c_acct_no, @@c_acct_type, @@c_concm_id, @@c_conc_id, @@c_conc_value 
                    --
                    END--while
                    --
                    EXEC pr_ins_upd_list @pa_clisba_id, 'D','ADDRESSES', @pa_login_name,'*|~*','|*~|',''                                  
                  -- 
                  END--ext
                --
                END--n_null
              --
              END--edt_1_2
              --
              IF @pa_chk_yn = 0
              BEGIN--chk_0
				
              --
                IF @@l_conc_value = ''  
                BEGIN--null  
                --
                  SELECT @@l_conc_id        = accac_adr_conc_id  
                  FROM   account_adr_conc   WITH(NOLOCK)  
                  WHERE  accac_clisba_id    = @pa_clisba_id  
                  AND    accac_concm_id     = @@l_concm_id  
                  AND    accac_deleted_ind  = 1
                  --
                  IF EXISTS(SELECT accac_adr_conc_id  
                            FROM   account_adr_conc   WITH(NOLOCK)  
                            WHERE  accac_clisba_id   <> @pa_clisba_id  
                            AND    accac_adr_conc_id  = @@l_conc_id  
                            AND    accac_deleted_ind  = 1   
                            )  
                  BEGIN--exts1
                  --
                    BEGIN TRANSACTION  
                    --  
                    DELETE FROM account_adr_conc
                    WHERE  accac_clisba_id   = @pa_clisba_id  
                    AND    accac_concm_id    = @@l_concm_id  
                    AND    accac_deleted_ind = 1
                    --
                    SET @@l_error = @@ERROR  
                    --  
                    IF @@l_error > 0
                    BEGIN  
                    --  
                      SELECT @@l_concm_desc    = concm_desc  
                      FROM   conc_code_mstr      WITH(NOLOCK)  
                      WHERE  concm_id          = @@l_concm_id  
                      AND    concm_deleted_ind = 1  
                      --  
                      SET @@l_errorstr = @@l_concm_desc+' Could not be Edited/Deleted'+@rowdelimiter+@@l_errorstr  
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
                  END--exts1
                  ELSE
                  BEGIN--n_exts1
                  --
                    BEGIN TRANSACTION  
                    --  
                    DELETE FROM contact_channels  
                    WHERE  conc_id          = @@l_conc_id  
                    AND    conc_deleted_ind = 1  
                    --  
                    SET @@l_error = @@ERROR
                    --  
                    IF @@l_error > 0        
                    BEGIN  
                    --  
                      SELECT @@l_concm_desc    = concm_desc  
                      FROM   conc_code_mstr    WITH(NOLOCK)  
                      WHERE  concm_id          = @@l_concm_id 
                      AND    concm_deleted_ind = 1  
                      --  
                      SET @@l_errorstr = @@l_concm_desc+' Could not be Edited/Deleted'+@rowdelimiter+@@l_errorstr  
                      --  
                      ROLLBACK TRANSACTION  
                    --  
                    END
                    ELSE  
                    BEGIN  
                    --  
                      DELETE FROM account_adr_conc  
                      WHERE  accac_clisba_id   = @pa_clisba_id  
                      AND    accac_adr_conc_id = @@l_conc_id  
                      AND    accac_deleted_ind = 1  

                      --  
                      SET @@l_error = @@ERROR  
                      --  
                      IF @@l_error > 0  
                      BEGIN  
                      --  
                        SELECT @@l_concm_desc    = concm_desc  
                        FROM   conc_code_mstr    WITH(NOLOCK)  
                        WHERE  concm_id          = @@l_concm_id  
                        AND    concm_deleted_ind = 1  
                        --  
                        SET @@l_errorstr = @@l_concm_desc+' Could not be Edited/Deleted'+@rowdelimiter+@@l_errorstr  
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
                  END --n_exts1
                --
                END--null
                --
                IF isnull(@@l_conc_value,'') <> ''
                BEGIN--not_null
                --
                  IF EXISTS(SELECT accac_conc_value
                            FROM   #t_conc
                            WHERE  accac_concm_id = @@l_concm_id
                              )
                  BEGIN--a_exts1
                  --
                    SELECT @@l_old_conc_value = accac_conc_value
                         , @@l_old_conc_id    = accac_conc_id
                    FROM   #t_conc
                    WHERE  accac_concm_id     = @@l_concm_id
                    --
                    IF @@l_old_conc_value     = @@l_conc_value
                    BEGIN--#same
                    --
                       DELETE FROM #t_conc 
                       WHERE accac_concm_id  = @@l_concm_id 
                       AND   accac_clisba_id = @pa_clisba_id
                    --  
                    END --#same
                    ELSE
                    BEGIN--#n_same
                    --
                      SELECT @@l_old_conc_id    = accac_adr_conc_id
                      FROM   account_adr_conc   WITH (NOLOCK)
                      WHERE  accac_clisba_id    = @pa_clisba_id
                      AND    accac_concm_id     = @@l_concm_id
                      AND    accac_deleted_ind  = 1
                      --
                      DELETE FROM #t_conc
                      WHERE  accac_concm_id  = @@l_concm_id
                      AND    accac_clisba_id = @pa_clisba_id
                      --
                      IF EXISTS(SELECT * FROM account_adr_conc WITH (NOLOCK)
                                WHERE    accac_concm_id     = @@l_concm_id
                                AND      accac_adr_conc_id  = @@l_old_conc_id
                                AND      accac_clisba_id   <> @pa_clisba_id
                                AND      accac_deleted_ind  = 1)
                      BEGIN--a_exts1_1
                      --
                        BEGIN TRANSACTION
                        --
                        SELECT @@l_conc_id        = bitrm_bit_location
                        FROM   bitmap_ref_mstr    WITH (NOLOCK)
                        WHERE  bitrm_parent_cd    = 'ADR_CONC_ID'
                        AND    bitrm_child_cd     = 'ADR_CONC_ID'

                        UPDATE bitmap_ref_mstr    WITH (ROWLOCK)
                        SET    bitrm_bit_location = bitrm_bit_location+1
                        WHERE  bitrm_parent_cd    = 'ADR_CONC_ID'
                        AND    bitrm_child_cd     = 'ADR_CONC_ID'
                        --
                        INSERT INTO contact_channels
                        (conc_id
                        ,conc_value
                        ,conc_created_by
                        ,conc_created_dt
                        ,conc_lst_upd_by
                        ,conc_lst_upd_dt
                        ,conc_deleted_ind
                        ) 
                        VALUES  
                        (@@l_conc_id
                        ,@@l_conc_value
                        ,@pa_login_name
                        ,GETDATE()
                        ,@pa_login_name
                        ,GETDATE()
                        ,1
                        )
                        --
                        SET @@l_error = @@ERROR
                        --
                        IF @@l_error > 0  
                        BEGIN--#r
                        --
                          SELECT @@l_concm_desc    = concm_desc
                          FROM   conc_code_mstr      WITH (NOLOCK)
                          WHERE  concm_id          = @@l_concm_id
                          AND    concm_deleted_ind = 1
                          --
                          SET @@l_errorstr = @@l_concm_desc+' Could not be Inserted/Edited'+@rowdelimiter+@@l_errorstr
                          --
                          ROLLBACK TRANSACTION
                        --
                        END--#r
                        ELSE
                        BEGIN--#c
                        --
                          UPDATE account_adr_conc    WITH (ROWLOCK)
                          SET    accac_adr_conc_id = @@l_conc_id
                               , accac_lst_upd_by  = @pa_login_name
                               , accac_lst_upd_dt  = GETDATE()
                          WHERE  accac_clisba_id   = @pa_clisba_id
                          AND    accac_concm_id    = @@l_concm_id
                          AND    accac_deleted_ind = 1
                          --
                          SET @@l_error = @@ERROR
                          --
                          IF @@l_error > 0
                          BEGIN--#r1
                          --
                            SELECT @@l_concm_desc    = concm_desc
                            FROM   conc_code_mstr      WITH (NOLOCK)
                            WHERE  concm_id          = @@l_concm_id
                            AND    concm_deleted_ind = 1
                            --
                            SET @@l_errorstr = @@l_concm_desc + ' Could not be Inserted'+@rowdelimiter+@@l_errorstr
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
                        END--#c
                      --
                      END--a_exts1_1
                      ELSE
                      BEGIN--a_n_exts1_1
                      --
                        BEGIN TRANSACTION
                        --
                        UPDATE contact_channels    WITH(ROWLOCK)  
                        SET    conc_value        = @@l_conc_value  
                              ,conc_lst_upd_by   = @pa_login_name  
                              ,conc_lst_upd_dt   = GETDATE()  
                        WHERE  conc_id           = @@l_old_conc_id  
                        AND    conc_deleted_ind  = 1  
                        --
                        SET @@l_error = @@ERROR
                        --
                        IF @@l_error > 0
                        BEGIN
                        --
                          SELECT @@l_concm_desc    = concm_desc
                          FROM   conc_code_mstr      WITH (NOLOCK)
                          WHERE  concm_id          = @@l_concm_id
                          AND    concm_deleted_ind = 1
                          --
                          SET @@l_errorstr = @@l_concm_desc+' Could not be Inserted'+@rowdelimiter+@@l_errorstr
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
                      END --a_n_exts1_1
                    --
                    END --#n_same
                  --
                  END--a_exts1
                  ELSE
                  BEGIN--n_a_exts1
                  --
                    IF EXISTS(SELECT conc_id  
                              FROM   contact_channels    WITH(NOLOCK)  
                              WHERE  conc_value        = @@l_conc_value  
                              AND    conc_deleted_ind  = 1
                             )  
                    BEGIN--e_1  
                    --
                      BEGIN TRANSACTION
                      --
                      SELECT @@l_conc_id      = conc_id  
                      FROM   contact_channels   WITH(NOLOCK)  
                      WHERE  conc_value       = @@l_conc_value  
                      AND    conc_deleted_ind = 1
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
                      (@pa_clisba_id  
                      ,@pa_acct_no  
                      ,@pa_acct_type
                      ,@@l_concm_id  
                      ,@@l_conc_id  
                      ,@pa_login_name  
                      ,getdate()  
                      ,@pa_login_name  
                      ,getdate()  
                      ,1
                      )
                      --
                      SET @@l_error = @@ERROR  
                      --  
                      IF @@l_error > 0  
                      BEGIN  
                      --  
                        SELECT @@l_concm_desc    = concm_desc  
                        FROM   conc_code_mstr      WITH(NOLOCK)  
                        WHERE  concm_id          = @@l_concm_id  
                        AND    concm_deleted_ind = 1  
                        --  
                        SET @@l_errorstr = @@l_concm_desc+' Could not be Edited/Deleted'+@rowdelimiter+@@l_errorstr  
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
                    END--e_1  
                    ELSE
                    BEGIN--n_e_1  
                    --
                      BEGIN TRANSACTION
                      -- 
                      SELECT @@l_conc_id        = bitrm_bit_location  
                      FROM   bitmap_ref_mstr      WITH(NOLOCK)  
                      WHERE  bitrm_parent_cd    = 'ADR_CONC_ID'  
                      AND    bitrm_child_cd     = 'ADR_CONC_ID'  
                      --  
                      UPDATE bitmap_ref_mstr      WITH(ROWLOCK)  
                      SET    bitrm_bit_location = bitrm_bit_location+1  
                      WHERE  bitrm_parent_cd    = 'ADR_CONC_ID'  
                      AND    bitrm_child_cd     = 'ADR_CONC_ID' 
                      --
                      INSERT INTO contact_channels  
                      (conc_id  
                      ,conc_value  
                      ,conc_created_by  
                      ,conc_created_dt  
                      ,conc_lst_upd_by  
                      ,conc_lst_upd_dt  
                      ,conc_deleted_ind
                      )  
                      VALUES  
                      (@@l_conc_id  
                      ,@@l_conc_value  
                      ,@pa_login_name  
                      ,GETDATE()  
                      ,@pa_login_name  
                      ,GETDATE()  
                      ,1
                      )
                      --
                      SET @@l_error = @@ERROR  
                      --  
                      IF @@l_error > 0  
                      BEGIN  
                      --  
                        SELECT @@l_concm_desc     = concm_desc  
                        FROM   conc_code_mstr    WITH(NOLOCK)  
                        WHERE  concm_id          = @@l_concm_id  
                        AND    concm_deleted_ind = 1  
                        --  
                        SET @@l_errorstr = @@l_concm_desc+'Could not be Edited/Deleted'+@rowdelimiter+@@l_errorstr  
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
                        (@pa_clisba_id  
                        ,@pa_acct_no  
                        ,@pa_acct_type
                        ,@@l_concm_id  
                        ,@@l_conc_id  
                        ,@pa_login_name  
                        ,GETDATE()  
                        ,@pa_login_name  
                        ,GETDATE()  
                        ,1
                        )
                        --
                        SET @@l_error = @@ERROR  
                        --  
                        IF @@l_error > 0  
                        BEGIN  
                        --  
                          SELECT @@l_concm_desc    = concm_desc  
                          FROM   conc_code_mstr    WITH(NOLOCK)  
                          WHERE  concm_id          = @@l_concm_id  
                          AND    concm_deleted_ind = 1  
                          --  
                          SET @@l_errorstr = @@l_concm_desc+' Could not be Edited/Deleted'+@rowdelimiter+@@l_errorstr  
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
                    END--n_e_1  
                  --
                  END--n_a_exts1
                --
                END--not_null
              --
              END--chk_0
            --
            END--edt_c
          --
          END--cur_val
        --
        END--w_val
      --
      END--not_app_rej
      --
      IF @pa_action = 'APP'
      BEGIN--app
      --
        SELECT @@l_deleted_ind      = conc_deleted_ind
             , @@l_clisba_id        = conc_clisba_id
             , @@l_acct_no          = conc_acct_no
             , @@l_acct_type        = conc_acct_type
             , @@l_concm_id         = conc_concm_id                  
             , @@l_concm_cd         = conc_concm_cd                 
             , @@l_conc_id          = conc_id
             , @@l_conc_value       = conc_value
        FROM   conc_acct_mak          WITH (NOLOCK)
        WHERE  concmak_id           = CONVERT(numeric, @@currstring_id)  
        AND    conc_deleted_ind     IN (0,4,8)
        
        
        --
        SELECT @@l_accac_addr_conc_id   = conc_id  
        FROM   conc_acct_mak              WITH (NOLOCK)
        JOIN   account_adr_conc           WITH (NOLOCK) 
        ON     accac_adr_conc_id        = conc_id  
        WHERE  accac_clisba_id          = @@l_clisba_id  
        AND    accac_concm_id           = @@l_concm_id  
        AND    accac_deleted_ind        = 1  
        AND    accac_deleted_ind        = 1
        --
        IF @@l_deleted_ind = 4
        BEGIN--4
        --
          IF EXISTS(SELECT * 
                    FROM   account_adr_conc      WITH (NOLOCK) 
                    WHERE  accac_adr_conc_id  = @@l_conc_id
                    AND    accac_clisba_id   <> @@l_clisba_id
                    AND    accac_deleted_ind  = 1
                   )
          BEGIN--exts_1
          --
            UPDATE account_adr_conc     WITH (ROWLOCK)
            SET    accac_deleted_ind  = 0
                 , accac_lst_upd_by   = @pa_login_name
                 , accac_lst_upd_dt   = GETDATE()
            WHERE  accac_deleted_ind  = 1
            AND    accac_clisba_id    = @@l_clisba_id
            AND    accac_concm_id     = @@l_concm_id
          --
          END--exts_1
          ELSE
          BEGIN--n_exts_1
          --
            UPDATE account_adr_conc     WITH (ROWLOCK)
            SET    accac_deleted_ind  = 0
                 , accac_lst_upd_by   = @pa_login_name
                 , accac_lst_upd_dt   = GETDATE()
            WHERE  accac_deleted_ind  = 1
            AND    accac_clisba_id    = @@l_clisba_id
            AND    accac_concm_id     = @@l_concm_id
            --  
            UPDATE conc_acct_mak        WITH (ROWLOCK)--error
            SET    conc_deleted_ind   = 1
                 , conc_lst_upd_by    = @pa_login_name
                 , conc_lst_upd_dt    = GETDATE()
            WHERE  conc_deleted_ind   = 0
            AND    conc_id            = @@l_conc_id 
          --
          END--n_exts_1
          --
          UPDATE conc_acct_mak          WITH (ROWLOCK)
          SET    conc_deleted_ind     = 5
               , conc_lst_upd_by      = @pa_login_name
               , conc_lst_upd_dt      = GETDATE()
          WHERE  conc_deleted_ind     = 4
          AND    concmak_id           = CONVERT(numeric, @@currstring_id)  
        --
        END--4
        --
        ELSE IF @@l_deleted_ind = 8
        BEGIN--8
        --
          IF EXISTS(SELECT * FROM account_adr_conc WITH (NOLOCK)
                    WHERE    accac_concm_id     = @@l_concm_id
                    AND      accac_adr_conc_id  = @@l_accac_addr_conc_id 
                    AND      accac_clisba_id   <> @@l_clisba_id
                    AND      accac_deleted_ind  = 1
                   )    
          BEGIN--ext_1
          --
            SELECT @@l_conc_id        = bitrm_bit_location
            FROM   bitmap_ref_mstr      WITH (NOLOCK)
            WHERE  bitrm_parent_cd    = 'ADR_CONC_ID'
            AND    bitrm_child_cd     = 'ADR_CONC_ID'
            --   
            UPDATE bitmap_ref_mstr      WITH (ROWLOCK)
            SET    bitrm_bit_location = bitrm_bit_location+1
            WHERE  bitrm_parent_cd    ='ADR_CONC_ID'
            AND    bitrm_child_cd     ='ADR_CONC_ID'
            --
            INSERT INTO contact_channels
            (conc_id
            ,conc_value
            ,conc_created_by
            ,conc_created_dt
            ,conc_lst_upd_by
            ,conc_lst_upd_dt
            ,conc_deleted_ind
            )
            VALUES
            (@@l_conc_id
            ,@@l_conc_value
            ,@pa_login_name
            ,GETDATE()
            ,@pa_login_name
            ,GETDATE()
            ,1
            )
            --
            UPDATE account_adr_conc     WITH (ROWLOCK)
            SET    accac_adr_conc_id  = @@l_conc_id
                 , accac_lst_upd_by   = @pa_login_name
                 , accac_lst_upd_dt   = GETDATE() 
            WHERE  accac_clisba_id    = @@l_clisba_id
            AND    accac_concm_id     = @@l_concm_id
            AND    accac_deleted_ind  = 1
          --
          END--ext_1
          ELSE
          BEGIN--n_ext_1
          --
             UPDATE contact_channels    WITH (ROWLOCK)
             SET    conc_value        = @@l_conc_value  
                   ,conc_lst_upd_by   = @pa_login_name
                   ,conc_lst_upd_dt   = GETDATE()
             WHERE  conc_id           = @@l_conc_id
             AND    conc_deleted_ind  = 1
          --
          END--n_ext_1
        --
        END--8
        --
        ELSE IF @@l_deleted_ind = 0
        BEGIN--0
        --
          IF EXISTS(SELECT conc_id
                    FROM   contact_channels   WITH (NOLOCK)
                    WHERE  conc_value       = @@l_conc_value
                    AND    conc_deleted_ind = 1
                   )
          BEGIN--exts_0
          --

           
            SELECT @@l_conc_id       = conc_id
            FROM   contact_channels    WITH (NOLOCK)
            WHERE  conc_value        = @@l_conc_value
            AND    conc_deleted_ind  = 1
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
            SELECT conc_clisba_id
                 , @@l_acct_no
                 , @@l_acct_type
                 , @@l_concm_id
                 , @@l_conc_id
                 , @pa_login_name
                 , GETDATE()
                 , @pa_login_name
                 , GETDATE()
                 , 1
            FROM  conc_acct_mak  WITH (NOLOCK)
            WHERE concmak_id = CONVERT(numeric, @@currstring_id)  
          --
          END--exts_0
          ELSE
          BEGIN--n_exts_0
          --
           
            SELECT @@l_conc_id        = bitrm_bit_location
            FROM   bitmap_ref_mstr      WITH(NOLOCK)
            WHERE  bitrm_parent_cd    = 'ADR_CONC_ID'
            AND    bitrm_child_cd     = 'ADR_CONC_ID'
            --        
            UPDATE bitmap_ref_mstr      WITH(ROWLOCK)
            SET    bitrm_bit_location = bitrm_bit_location + 1
            WHERE  bitrm_parent_cd    = 'ADR_CONC_ID'
            AND    bitrm_child_cd     = 'ADR_CONC_ID'
            --
            INSERT INTO contact_channels
            (conc_id
            ,conc_value
            ,conc_created_by
            ,conc_created_dt
            ,conc_lst_upd_by
            ,conc_lst_upd_dt
            ,conc_deleted_ind
            )
            VALUES
            (@@l_conc_id
            ,@@l_conc_value
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
            (@@l_clisba_id
            ,@@l_acct_no
            ,@@l_acct_type 
            ,@@l_concm_id 
            ,@@l_conc_id
            ,@pa_login_name
            ,GETDATE()
            ,@pa_login_name
            ,GETDATE()
            ,1
            )
          
            
          --
          END--n_exts_0
          --
          UPDATE conc_acct_mak       WITH (ROWLOCK)
          SET    conc_deleted_ind  = 1
               , conc_lst_upd_by   = @pa_login_name
               , conc_lst_upd_dt   = GETDATE()
          WHERE  conc_deleted_ind  = 0
          AND    concmak_id        = CONVERT(numeric,@@currstring_id)  

          
        --
        END--0
        --
        EXEC pr_ins_upd_list @pa_clisba_id, 'A','ADDRESSES', @pa_login_name,'*|~*','|*~|',''
	
      --
      END--app
      --
      IF @pa_action = 'REJ'
      BEGIN--rej
      --
        UPDATE conc_acct_mak        WITH (ROWLOCK)
        SET    conc_deleted_ind   = 3
             , conc_lst_upd_by    = @pa_login_name
             , conc_lst_upd_dt    = GETDATE()
        WHERE  conc_deleted_ind  IN (0,4,8)
        AND    concmak_id         = CONVERT(numeric, @@currstring_id)
      --
      END--rej



    --
    END--cur_id
    
  --
  END--w_id
  --
  IF @pa_action not in ('REJ','APP') 
  BEGIN
  --
  
  DELETE FROM account_adr_conc WITH (ROWLOCK)
  WHERE  accac_clisba_id    = @pa_clisba_id 
  AND    accac_deleted_ind  = 1
  AND    accac_concm_id    IN (SELECT accac_concm_id FROM #t_conc)
  --
  END
  
  --
  SELECT * FROM ACCOUNT_ADR_CONC WHERE ACCAC_CLISBA_ID = @@L_CLISBA_ID
  IF @@l_errorstr=''  
  BEGIN  
  --  
    SET @pa_msg = 'Contact Channels Successfully Inserted/Edited'+ @rowdelimiter  
  --  
  END  
  ELSE  
  BEGIN  
  --  
    SET @pa_msg = @@l_errorstr  
  --  
  END  
--
END

GO
