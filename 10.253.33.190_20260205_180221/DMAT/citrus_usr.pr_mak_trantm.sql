-- Object: PROCEDURE citrus_usr.pr_mak_trantm
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

create  PROCEDURE [citrus_usr].[pr_mak_trantm]( @pa_id           varchar(8000)
                              , @pa_action       varchar(5)
                              , @pa_login_name   varchar(20)
                              , @pa_excm_id      numeric
                              , @pa_cd           varchar(25)
                              , @pa_desc         varchar(50)
                              , @pa_chk_yn       int
                              , @rowdelimiter    char(4)       = '*|~*'
                              , @coldelimiter    char(4)       = '|*~|'
                              , @pa_errmsg       varchar(8000) output
                              )
AS
/*
*********************************************************************************
SYSTEM          : DP
MODULE NAME     : pr_mak_trantm
DESCRIPTION     : this procedure will contain the maker checker facility for transaction_type_mstr
COPYRIGHT(C)    : Marketplace Technologies Pvt Ltd
VERSION HISTORY : 1.0
VERS.  AUTHOR            DATE          REASON
-----  -------------     ------------  -----------------------------------------
1.0    Sukhvinder        30-oct-2007   version.
--------------------------------------------------------------------------------
*********************************************************************************
*/
BEGIN--#1
--
  DECLARE @l_errorstr        varchar(8000)
        , @l_error           bigint
        , @delimeter         varchar(10)
        , @remainingstring   varchar(8000)
        , @currstring        varchar(8000)
        , @foundat           integer
        , @delimeterlength   int
        , @l_trantmm_id      numeric
        , @l_trantm_id       numeric
  --
  SET @l_error          = 0
  SET @l_errorstr       = ''
  SET @delimeter        = '%'+ @rowdelimiter + '%'
  SET @delimeterlength  = LEN(@rowdelimiter)
  SET @remainingstring  = @pa_id

  WHILE @remainingstring <> ''
  BEGIN--#2
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
    BEGIN--cur
    --
      IF @pa_chk_yn = 0
      BEGIN--chk_0
      --
        IF @pa_action = 'INS'
        BEGIN--ins_0
        --
          BEGIN TRANSACTION
          --
          SELECT @l_trantmm_id = ISNULL(MAX(trantm_id),0)+ 1 FROM  trantm_mak WITH (NOLOCK)

          SELECT @l_trantm_id = ISNULL(MAX(trantm_id),0)+ 1 FROM  transaction_type_mstr WITH (NOLOCK)

          IF @l_trantmm_id  > @l_trantm_id
          BEGIN
          --
            SET @l_trantm_id = @l_trantmm_id
          --
          END
          --
          INSERT INTO transaction_type_mstr
          ( trantm_id
          , trantm_excm_id
          , trantm_code
          , trantm_desc
          , trantm_created_dt
          , trantm_created_by
          , trantm_lst_upd_dt
          , trantm_lst_upd_by
          , trantm_deleted_ind
          )
          VALUES
          ( @l_trantm_id
          , @pa_excm_id
          , @pa_cd
          , @pa_desc
          , getdate()
          , @pa_login_name
          , getdate()
          , @pa_login_name
          , 1
          )
          --
          SET @l_error = @@error
          --
          IF @l_error <> 0
          BEGIN
          --
            ROLLBACK TRANSACTION
            --
            SET @pa_errmsg = citrus_usr.fn_err_desc(@l_error)
            --
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
        END--ins_0
        --
        ELSE IF @pa_action = 'EDT'
        BEGIN--edt_0
        --
          BEGIN TRANSACTION

          UPDATE transaction_type_mstr     WITH (ROWLOCK)
          SET    trantm_excm_id     = @pa_excm_id
               , trantm_code        = @pa_cd
               , trantm_desc        = @pa_desc
               , trantm_lst_upd_by  = @pa_login_name
               , trantm_lst_upd_dt  = getdate()
          WHERE  trantm_id          = CONVERT(INT,@currstring)
          AND    trantm_deleted_ind = 1
          --
          SET @l_error = @@error
          --
          IF @l_error <> 0
          BEGIN
          --
            ROLLBACK TRANSACTION
            --
            SET @pa_errmsg = citrus_usr.fn_err_desc(@l_error)
            --
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
        END--edt_0
        --
        ELSE IF @pa_action = 'DEL'
        BEGIN--del_0
        --
          BEGIN TRANSACTION
          --
          UPDATE transaction_type_mstr   WITH (ROWLOCK)
          SET    trantm_lst_upd_dt     = getdate()
                ,trantm_lst_upd_by     = @pa_login_name
                ,trantm_deleted_ind    = 0
          WHERE  trantm_id             = CONVERT(INT,@currstring)
          AND    trantm_deleted_ind    = 1
          --
          SET @l_error = @@error
          --
          IF @l_error <> 0
          BEGIN
          --
            ROLLBACK TRANSACTION
            --
            SET @pa_errmsg = citrus_usr.fn_err_desc(@l_error)
            --
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
        END--del_0
      --
      END--chk_0
      -------------------------
      ELSE IF @pa_chk_yn = 1
      BEGIN--chk_1
      --
        IF @pa_action = 'INS'
        BEGIN--ins_1
        --
          BEGIN TRANSACTION

          SELECT @l_trantmm_id = ISNULL(MAX(trantm_id),0)+ 1 FROM trantm_mak WITH (NOLOCK)

          SELECT @l_trantm_id = ISNULL(MAX(trantm_id),0)+ 1 FROM  transaction_type_mstr WITH (NOLOCK)

          IF @l_trantmm_id  > @l_trantm_id
          BEGIN
          --
            SET @l_trantm_id = @l_trantmm_id
          --
          END
          --
          INSERT INTO trantm_mak
          ( trantm_id
          , trantm_excm_id
          , trantm_code
          , trantm_desc
          , trantm_created_dt
          , trantm_created_by
          , trantm_lst_upd_dt
          , trantm_lst_upd_by
          , trantm_deleted_ind
          )
          VALUES
          ( @l_trantm_id
          , @pa_excm_id
          , @pa_cd
          , @pa_desc
          , getdate()
          , @pa_login_name
          , getdate()
          , @pa_login_name
          , 0
          )
          --
          SET @l_error = @@error
          --
          IF @l_error <> 0
          BEGIN
          --
            ROLLBACK TRANSACTION
            --
            SET @pa_errmsg = citrus_usr.fn_err_desc(@l_error)
            --
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
        END--ins_1
        --
        ELSE IF @pa_action = 'EDT'
        BEGIN--edt_1
        --
          BEGIN TRANSACTION
          --
          UPDATE trantm_mak           WITH (ROWLOCK)
          SET    trantm_deleted_ind = 2
               , trantm_lst_upd_dt  = getdate()
               , trantm_lst_upd_by  = @pa_login_name
          WHERE  trantm_id          = CONVERT(INT,@currstring)
          AND    trantm_deleted_ind = 0
          --
          SET @l_error = @@error
          --
          IF @l_error <> 0
          BEGIN
          --
            ROLLBACK TRANSACTION
            --
            SET @pa_errmsg = citrus_usr.fn_err_desc(@l_error)
            --
            RETURN
          --
          END
          ELSE
          BEGIN
          --
            SELECT @l_trantmm_id = ISNULL(MAX(trantm_id),0)+ 1 FROM trantm_mak WITH (NOLOCK)
            --
            SELECT @l_trantm_id = ISNULL(MAX(trantm_id),0)+ 1 FROM  transaction_type_mstr WITH (NOLOCK)

            IF @l_trantmm_id  > @l_trantm_id
            BEGIN
            --
              SET @l_trantm_id = @l_trantmm_id
            --
            END
            --
            INSERT INTO trantm_mak
            ( trantm_id
            , trantm_excm_id
            , trantm_code
            , trantm_desc
            , trantm_created_dt
            , trantm_created_by
            , trantm_lst_upd_dt
            , trantm_lst_upd_by
            , trantm_deleted_ind
            )
            VALUES
            ( @l_trantm_id
            , @pa_excm_id
            , @pa_cd
            , @pa_desc
            , getdate()
            , @pa_login_name
            , getdate()
            , @pa_login_name
            , 0
            )
            --
            SET @l_error = @@error
            --
            IF @l_error <> 0
            BEGIN
            --
              ROLLBACK TRANSACTION
              --
              SET @pa_errmsg = citrus_usr.fn_err_desc(@l_error)
              --
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
          END
        --
        END--edt_1
      --
      END--chk_1
      --
      IF @pa_action = 'APP'
      BEGIN--app
      --
        BEGIN TRANSACTION
        --
        IF EXISTS(SELECT * FROM transaction_type_mstr WHERE trantm_id = convert(numeric,@currstring) and trantm_deleted_ind = 1)
        BEGIN--exts
        --
          UPDATE transaction_type_mstr         WITH (ROWLOCK)
          SET    trantm_excm_id              = trantmm.trantm_excm_id
               , trantm_code                 = trantmm.trantm_code
               , trantm_desc                 = trantmm.trantm_desc
               , trantm_lst_upd_by           = trantmm.trantm_lst_upd_by
               , trantm_lst_upd_dt           = trantmm.trantm_lst_upd_dt
          FROM   trantm_mak                    trantmm
          WHERE  trantmm.trantm_id           = convert(numeric,@currstring)
          AND    trantmm.trantm_deleted_ind  = 0
          --
          SET @l_error = @@error
          --
          IF @l_error <> 0
          BEGIN
          --
            ROLLBACK TRANSACTION
            --
            SET @pa_errmsg = citrus_usr.fn_err_desc(@l_error)
            --
            RETURN
          --
          END
          ELSE
          BEGIN
          --
            UPDATE trantm_mak           WITH (ROWLOCK)
            SET    trantm_deleted_ind = 1
                 , trantm_lst_upd_by  = @pa_login_name
                 , trantm_lst_upd_dt  = getdate()
            WHERE  trantm_id          = convert(numeric,@currstring)
            AND    trantm_deleted_ind = 0
            --
            COMMIT TRANSACTION
          --
          END
        --
        END--exts
        ELSE
        BEGIN--n_exts
        --
          INSERT INTO transaction_type_mstr
          ( trantm_id
          , trantm_excm_id
          , trantm_code
          , trantm_desc
          , trantm_created_dt
          , trantm_created_by
          , trantm_lst_upd_dt
          , trantm_lst_upd_by
          , trantm_deleted_ind
          )
          SELECT trantm_id
               , trantm_excm_id
               , trantm_code
               , trantm_desc
               , trantm_created_dt
               , trantm_created_by
               , trantm_lst_upd_dt
               , trantm_lst_upd_by
               , 1
          FROM  trantm_mak
          WHERE trantm_id = convert(numeric,@currstring)
          AND   trantm_deleted_ind = 0

          SET @l_error = @@error
          --
          IF @l_error <> 0
          BEGIN
          --
            ROLLBACK TRANSACTION
            --
            SET @pa_errmsg = citrus_usr.fn_err_desc(@l_error)
            --
            RETURN
          --
          END
          ELSE
          BEGIN
          --
            UPDATE trantm_mak           WITH (ROWLOCK)
            SET    trantm_deleted_ind = 1
                 , trantm_lst_upd_by  = @pa_login_name
                 , trantm_lst_upd_dt  = getdate()
            WHERE  trantm_id          = convert(numeric,@currstring)
            AND    trantm_deleted_ind = 0
            --
            COMMIT TRANSACTION
          --
          END
        --
        END--n_exts
      --
      END--app
      --
      IF @pa_action = 'REJ'
      BEGIN--rej
      --
        BEGIN TRANSACTION

        UPDATE trantm_mak           WITH (ROWLOCK)
        SET    trantm_deleted_ind = 3
             , trantm_lst_upd_by  = @pa_login_name
             , trantm_lst_upd_dt  = getdate()
        WHERE  trantm_id          = convert(numeric,@currstring)
        AND    trantm_deleted_ind = 0
        --
        SET @l_error = @@error
        --
        IF @l_error <> 0
        BEGIN
        --
          ROLLBACK TRANSACTION
          --
          SET @pa_errmsg = citrus_usr.fn_err_desc(@l_error)
          --
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
      END--rej
    --
    END--cur
  --
  END--#2
--
END--#1

GO
