-- Object: PROCEDURE citrus_usr.pr_mak_ream
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

create PROCEDURE [citrus_usr].[pr_mak_ream](@pa_id             varchar(8000)
                            ,@pa_action        varchar(5)
                            ,@pa_login_name    varchar(20)
                            ,@pa_excm_id       numeric
                            ,@pa_trantm_id     numeric
                            ,@pa_cd            varchar(50)
                            ,@pa_desc          varchar(200)
                            ,@pa_chk_yn        int
                            ,@rowdelimiter     char(4)       = '*|~*'
                            ,@coldelimiter     char(4)       = '|*~|'
                            ,@pa_errmsg        varchar(8000) output
                            )
AS
/*
*********************************************************************************
SYSTEM          : DP
MODULE NAME     : pr_mak_ream
DESCRIPTION     : this procedure will contain the maker checker facility for reason_mstr
COPYRIGHT(C)    : Marketplace Technologies Pvt Ltd
VERSION HISTORY : 1.0
VERS.  AUTHOR            DATE          REASON
-----  -------------     ------------  -----------------------------------------
1.0    Sukhvinder        29-oct-2007   version.
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
        , @l_reamm_id        numeric
        , @l_ream_id         numeric
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
          SELECT @l_reamm_id = ISNULL(MAX(ream_id),0)+ 1 FROM  ream_mak WITH (NOLOCK)

          SELECT @l_ream_id = ISNULL(MAX(ream_id),0)+ 1 FROM  reason_mstr WITH (NOLOCK)

          IF @l_reamm_id  > @l_ream_id
          BEGIN
          --
            SET @l_ream_id = @l_reamm_id
          --
          END
          --
          INSERT INTO reason_mstr
          ( ream_id
          , ream_excm_id
          , ream_trantm_id
          , ream_code
          , ream_desc
          , ream_created_dt
          , ream_created_by
          , ream_lst_upd_dt
          , ream_lst_upd_by
          , ream_deleted_ind
          )
          VALUES
          ( @l_ream_id
          , @pa_excm_id
          , @pa_trantm_id
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

          UPDATE reason_mstr     WITH (ROWLOCK)
          SET    ream_excm_id     = @pa_excm_id
               , ream_trantm_id   = @pa_trantm_id
               , ream_code        = @pa_cd
               , ream_desc        = @pa_desc
               , ream_lst_upd_by  = @pa_login_name
               , ream_lst_upd_dt  = getdate()
          WHERE  ream_id          = CONVERT(INT,@currstring)
          AND    ream_deleted_ind = 1
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
          UPDATE reason_mstr     WITH (ROWLOCK)
          SET    ream_lst_upd_dt  = getdate()
                ,ream_lst_upd_by  = @pa_login_name
                ,ream_deleted_ind = 0
          WHERE  ream_id          = CONVERT(INT,@currstring)
          AND    ream_deleted_ind = 1
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

          SELECT @l_reamm_id = ISNULL(MAX(ream_id),0)+ 1 FROM ream_mak WITH (NOLOCK)

          SELECT @l_ream_id = ISNULL(MAX(ream_id),0)+ 1 FROM  reason_mstr WITH (NOLOCK)

          IF @l_reamm_id  > @l_ream_id
          BEGIN
          --
            SET @l_ream_id = @l_reamm_id
          --
          END
          --
          INSERT INTO ream_mak
          ( ream_id
          , ream_excm_id
          , ream_trantm_id
          , ream_code
          , ream_desc
          , ream_created_dt
          , ream_created_by
          , ream_lst_upd_dt
          , ream_lst_upd_by
          , ream_deleted_ind
          )
          VALUES
          ( @l_ream_id
          , @pa_excm_id
          , @pa_trantm_id
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
          UPDATE ream_mak           WITH (ROWLOCK)
          SET    ream_deleted_ind = 2
               , ream_lst_upd_dt  = getdate()
               , ream_lst_upd_by  = @pa_login_name
          WHERE  ream_id          = CONVERT(INT,@currstring)
          AND    ream_deleted_ind = 0
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
            SELECT @l_reamm_id = ISNULL(MAX(ream_id),0)+ 1 FROM ream_mak WITH (NOLOCK)
            --
            SELECT @l_ream_id = ISNULL(MAX(ream_id),0)+ 1 FROM  reason_mstr WITH (NOLOCK)

            IF @l_reamm_id  > @l_ream_id
            BEGIN
            --
              SET @l_ream_id = @l_reamm_id
            --
            END
            --
            INSERT INTO ream_mak
            ( ream_id
            , ream_excm_id
            , ream_trantm_id
            , ream_code
            , ream_desc
            , ream_created_dt
            , ream_created_by
            , ream_lst_upd_dt
            , ream_lst_upd_by
            , ream_deleted_ind
            )
            VALUES
            ( @l_ream_id
            , @pa_excm_id
            , @pa_trantm_id
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
        IF EXISTS(SELECT * FROM reason_mstr WHERE ream_id = convert(numeric,@currstring) and ream_deleted_ind = 1)
        BEGIN--exts
        --
          UPDATE reason_mstr               WITH (ROWLOCK)
          SET    ream_excm_id            = reamm.ream_excm_id
               , ream_trantm_id           = reamm.ream_trantm_id
               , ream_code               = reamm.ream_code
               , ream_desc               = reamm.ream_desc
               , ream_lst_upd_by         = reamm.ream_lst_upd_by
               , ream_lst_upd_dt         = reamm.ream_lst_upd_dt
          FROM   ream_mak                  reamm
          WHERE  reamm.ream_id           = convert(numeric,@currstring)
          AND    reamm.ream_deleted_ind  = 0
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
            UPDATE ream_mak           WITH (ROWLOCK)
            SET    ream_deleted_ind = 1
                 , ream_lst_upd_by  = @pa_login_name
                 , ream_lst_upd_dt  = getdate()
            WHERE  ream_id          = convert(numeric,@currstring)
            AND    ream_deleted_ind = 0
            --
            COMMIT TRANSACTION
          --
          END
        --
        END--exts
        ELSE
        BEGIN--n_exts
        --
          INSERT INTO reason_mstr
          ( ream_id
          , ream_excm_id
          , ream_trantm_id
          , ream_code
          , ream_desc
          , ream_created_dt
          , ream_created_by
          , ream_lst_upd_dt
          , ream_lst_upd_by
          , ream_deleted_ind
          )
          SELECT ream_id
               , ream_excm_id
               , ream_trantm_id
               , ream_code
               , ream_desc
               , ream_created_dt
               , ream_created_by
               , ream_lst_upd_dt
               , ream_lst_upd_by
               , 1
          FROM  ream_mak
          WHERE ream_id          = convert(numeric,@currstring)
          AND   ream_deleted_ind = 0

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
            UPDATE ream_mak           WITH (ROWLOCK)
            SET    ream_deleted_ind = 1
                 , ream_lst_upd_by  = @pa_login_name
                 , ream_lst_upd_dt  = getdate()
            WHERE  ream_id          = convert(numeric,@currstring)
            AND    ream_deleted_ind = 0
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

        UPDATE ream_mak           WITH (ROWLOCK)
        SET    ream_deleted_ind = 3
             , ream_lst_upd_by  = @pa_login_name
             , ream_lst_upd_dt  = getdate()
        WHERE  ream_id          = convert(numeric,@currstring)
        AND    ream_deleted_ind = 0
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
