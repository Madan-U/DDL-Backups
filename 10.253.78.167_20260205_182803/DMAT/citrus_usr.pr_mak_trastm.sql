-- Object: PROCEDURE citrus_usr.pr_mak_trastm
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

create PROCEDURE [citrus_usr].[pr_mak_trastm]( @pa_id            varchar(8000)
                              , @pa_action        varchar(5)
                              , @pa_login_name    varchar(20)
                              , @pa_excm_id       numeric
                              , @pa_tratm_id      numeric
                              , @pa_trastm_cd     varchar(25)
                              , @pa_trastm_desc   varchar(50)
                              , @pa_chk_yn        int
                              , @rowdelimiter     char(4)       = '*|~*'
                              , @coldelimiter     char(4)       = '|*~|'
                              , @pa_errmsg        varchar(8000) output
                              )
AS
/*
*********************************************************************************
SYSTEM          : DP
MODULE NAME     : pr_mak_trastm
DESCRIPTION     : this procedure will contain the maker checker facility for transaction_sub_type_mstr
COPYRIGHT(C)    : Marketplace Technologies Pvt Ltd
VERSION HISTORY : 1.0
VERS.  AUTHOR            DATE          REASON
-----  -------------     ------------  -----------------------------------------
1.0    Sukhvinder        28-NOV-2007   version.
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
        , @l_trastmm_id      numeric
        , @l_trastm_id       numeric
        , @l_deleted_ind     smallint
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
    SET @foundat =  patindex('%'+@delimeter+'%',@remainingstring)
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
          IF EXISTS(SELECT trastm_id 
                    FROM   transaction_sub_type_mstr WITH(NOLOCK) 
                    WHERE  trastm_excm_id    = @pa_excm_id
                    AND    trastm_cd         = @pa_trastm_cd
                    AND    trastm_desc       = @pa_trastm_desc
                    AND    trastm_deleted_ind = 1
                   ) 
          BEGIN
          --
             SELECT @pa_errmsg = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': Duplicate record not allowed!'
             --
             RETURN
          --   
          END
          --
          BEGIN TRANSACTION
          --
          SELECT @l_trastmm_id = ISNULL(MAX(trastm_id),0)+ 1 FROM  trastm_mak WITH (NOLOCK)

          SELECT @l_trastm_id = ISNULL(MAX(trastm_id),0)+ 1 FROM  transaction_sub_type_mstr WITH (NOLOCK)

          IF @l_trastmm_id  > @l_trastm_id
          BEGIN
          --
            SET @l_trastm_id = @l_trastmm_id
          --
          END
          --
          INSERT INTO transaction_sub_type_mstr
          ( trastm_id
          , trastm_excm_id
          , trastm_tratm_id 
          , trastm_cd
          , trastm_desc
          , trastm_created_dt
          , trastm_created_by
          , trastm_lst_upd_dt
          , trastm_lst_upd_by
          , trastm_deleted_ind
          )
          VALUES
          ( @l_trastm_id
          , @pa_excm_id
          , @pa_tratm_id
          , @pa_trastm_cd
          , @pa_trastm_desc
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

          UPDATE transaction_sub_type_mstr  WITH (ROWLOCK)
          SET    trastm_excm_id           = @pa_excm_id
               , trastm_tratm_id          = @pa_tratm_id
               , trastm_cd                = @pa_trastm_cd
               , trastm_desc              = @pa_trastm_desc
               , trastm_lst_upd_by        = @pa_login_name
               , trastm_lst_upd_dt        = getdate()
          WHERE  trastm_id                = CONVERT(INT,@currstring)
          AND    trastm_deleted_ind       = 1
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
          UPDATE transaction_sub_type_mstr  WITH (ROWLOCK)
          SET    trastm_lst_upd_dt        = getdate()
                ,trastm_lst_upd_by        = @pa_login_name
                ,trastm_deleted_ind       = 0
          WHERE  trastm_id                = CONVERT(INT,@currstring)
          AND    trastm_deleted_ind       = 1
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

          SELECT @l_trastmm_id = ISNULL(MAX(trastm_id),0)+ 1 FROM trastm_mak WITH (NOLOCK)

          SELECT @l_trastm_id = ISNULL(MAX(trastm_id),0)+ 1 FROM  transaction_sub_type_mstr WITH (NOLOCK)

          IF @l_trastmm_id  > @l_trastm_id
          BEGIN
          --
            SET @l_trastm_id = @l_trastmm_id
          --
          END
          --
          INSERT INTO trastm_mak
          ( trastm_id
          , trastm_excm_id
          , trastm_tratm_id 
          , trastm_cd
          , trastm_desc
          , trastm_created_dt
          , trastm_created_by
          , trastm_lst_upd_dt
          , trastm_lst_upd_by
          , trastm_deleted_ind
          )
          VALUES
          ( @l_trastm_id
          , @pa_excm_id
          , @pa_tratm_id
          , @pa_trastm_cd
          , @pa_trastm_desc
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
          UPDATE trastm_mak           WITH (ROWLOCK)
          SET    trastm_deleted_ind = 2
               , trastm_lst_upd_dt  = getdate()
               , trastm_lst_upd_by  = @pa_login_name
          WHERE  trastm_id          = CONVERT(INT,@currstring)
          AND    trastm_deleted_ind = 0
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
            IF EXISTS(SELECT * FROM transaction_sub_type_mstr WHERE trastm_id = convert(int,@currstring) AND trastm_deleted_ind = 1)  
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
            --
            SELECT @l_trastmm_id = ISNULL(MAX(trastm_id),0)+ 1 FROM trastm_mak WITH (NOLOCK)
            --
            SELECT @l_trastm_id = ISNULL(MAX(trastm_id),0)+ 1 FROM  transaction_sub_type_mstr WITH (NOLOCK)

            IF @l_trastmm_id  > @l_trastm_id AND @l_deleted_ind = 0 
            BEGIN
            --
              SET @l_trastm_id = @l_trastmm_id
            --
            END
            ELSE
            BEGIN
            --
              SELECT @l_trastm_id       = trastm_id 
              FROM   transaction_sub_type_mstr 
              WHERE  trastm_id          = convert(int,@currstring) 
              AND    trastm_deleted_ind = 1
            --
            END
            --
            INSERT INTO trastm_mak
            ( trastm_id
            , trastm_excm_id
            , trastm_tratm_id 
            , trastm_cd
            , trastm_desc
            , trastm_created_dt
            , trastm_created_by
            , trastm_lst_upd_dt
            , trastm_lst_upd_by
            , trastm_deleted_ind
            )
            VALUES
            ( @l_trastm_id
            , @pa_excm_id
            , @pa_tratm_id
            , @pa_trastm_cd
            , @pa_trastm_desc
            , getdate()
            , @pa_login_name
            , getdate()
            , @pa_login_name
            , @l_deleted_ind
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
        IF @pa_action = 'DEL'  
        BEGIN--del  
        --
          IF EXISTS(SELECT * FROM trastm_mak WHERE trastm_id = convert(numeric,@currstring) and trastm_deleted_ind in(0,4))  
          BEGIN  
          --  
            DELETE FROM trastm_mak   
            WHERE  trastm_id          = convert(numeric, @currstring)  
            AND    trastm_deleted_ind = 0  
          --  
          END  
          ELSE  
          BEGIN  
          --  
            INSERT INTO trastm_mak
            ( trastm_id
            , trastm_excm_id
            , trastm_tratm_id 
            , trastm_cd
            , trastm_desc
            , trastm_created_dt
            , trastm_created_by
            , trastm_lst_upd_dt
            , trastm_lst_upd_by
            , trastm_deleted_ind
            )
            SELECT trastm_id
                 , trastm_excm_id
                 , trastm_tratm_id 
                 , trastm_cd
                 , trastm_desc
                 , trastm_created_dt
                 , trastm_created_by
                 , trastm_lst_upd_dt
                 , trastm_lst_upd_by
                 , 4
            FROM  transaction_sub_type_mstr  
            WHERE trastm_id          = convert(numeric,@currstring)  
            AND   trastm_deleted_ind = 1       
          --  
          END  
        --
        END--del
      --
      END--chk_1
      --
      IF @pa_action = 'APP'
      BEGIN--app
      --
        BEGIN TRANSACTION
        --
        IF EXISTS(SELECT * from trastm_mak where trastm_id = convert(numeric,@currstring) and trastm_deleted_ind = 6)
        BEGIN--#1
        --
          UPDATE trastm                       WITH (ROWLOCK)
          SET    trastm.trastm_excm_id      = trastmm.trastm_excm_id
               , trastm.trastm_tratm_id     = trastmm.trastm_tratm_id
               , trastm.trastm_cd           = trastmm.trastm_cd
               , trastm.trastm_desc         = trastmm.trastm_desc
               , trastm.trastm_lst_upd_by   = trastmm.trastm_lst_upd_by
               , trastm.trastm_lst_upd_dt   = trastmm.trastm_lst_upd_dt
          FROM   trastm_mak                   trastmm
               , transaction_sub_type_mstr    trastm
          WHERE  trastmm.trastm_id          = convert(numeric,@currstring)
          AND    trastmm.trastm_id          = trastm.trastm_id
          AND    trastm.trastm_deleted_ind  = 1
          AND    trastmm.trastm_deleted_ind = 6
          --
          SET @l_error = @@error
          --
          IF @l_error <> 0
          BEGIN
          --
            ROLLBACK TRANSACTION
            --
            IF EXISTS(SELECT Err_Description FROM tblerror WHERE Err_Code = @l_error)
            BEGIN
            --
              SET @pa_errmsg = citrus_usr.fn_err_desc(@l_error)
            --
            END
            ELSE
            BEGIN
            --
              SELECT @pa_errmsg = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': Can not process, Please contact your administrator!'
            --
            END
            --
            RETURN
          --
          END
          ELSE
          BEGIN
          --
            UPDATE trastm_mak           WITH (ROWLOCK)
            SET    trastm_deleted_ind = 7
                 , trastm_lst_upd_by  = @pa_login_name
                 , trastm_lst_upd_dt  = getdate()
            WHERE  trastm_id          = convert(numeric,@currstring)
            AND    trastm_deleted_ind = 6
            --
            COMMIT TRANSACTION
          --
          END
        --
        END--#1
        ELSE IF exists(SELECT * FROM trastm_mak where trastm_id = convert(numeric,@currstring) and trastm_deleted_ind = 0)
        BEGIN--#2
        -- 
          INSERT INTO transaction_sub_type_mstr
          ( trastm_id
          , trastm_excm_id
          , trastm_tratm_id 
          , trastm_cd
          , trastm_desc
          , trastm_created_dt
          , trastm_created_by
          , trastm_lst_upd_dt
          , trastm_lst_upd_by
          , trastm_deleted_ind
          )
          SELECT trastm_id
               , trastm_excm_id
               , trastm_tratm_id
               , trastm_cd
               , trastm_desc
               , trastm_created_dt
               , trastm_created_by
               , trastm_lst_upd_dt
               , trastm_lst_upd_by
               , 1
          FROM  trastm_mak
          WHERE trastm_id = convert(numeric,@currstring)
          AND   trastm_deleted_ind = 0
          --
          SET @l_error = @@error
          --
          IF @l_error <> 0
          BEGIN
          --
            ROLLBACK TRANSACTION
            --
            IF EXISTS(SELECT Err_Description FROM tblerror WHERE Err_Code = @l_error)
            BEGIN
            --
              SET @pa_errmsg = citrus_usr.fn_err_desc(@l_error)
            --
            END
            ELSE
            BEGIN
            --
              SELECT @pa_errmsg = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': Can not process, Please contact your administrator!'
            --
            END
            --
            RETURN
          --
          END
          ELSE
          BEGIN
          --
            UPDATE trastm_mak           WITH (ROWLOCK)
            SET    trastm_deleted_ind = 1
                 , trastm_lst_upd_by  = @pa_login_name
                 , trastm_lst_upd_dt  = getdate()
            WHERE  trastm_id          = convert(numeric,@currstring)
            AND    trastm_deleted_ind = 0
            --
            COMMIT TRANSACTION
          --
          END
        --
        END--#2
        ELSE 
        BEGIN--#3
        --
          UPDATE transaction_sub_type_mstr
          SET    trastm_deleted_ind = 0
               , trastm_lst_upd_by  = @pa_login_name
               , trastm_lst_upd_dt  = getdate()
          WHERE  trastm_id          = convert(numeric,@currstring)
          AND    trastm_deleted_ind = 1

          UPDATE trastm_mak
          SET    trastm_deleted_ind = 5
               , trastm_lst_upd_by  = @pa_login_name
               , trastm_lst_upd_dt  = getdate()
          WHERE  trastm_id          = convert(numeric,@currstring)
          AND    trastm_deleted_ind = 4

          COMMIT TRANSACTION
        --
        END--#3
      --
      END--app
      --
      IF @pa_action = 'REJ'
      BEGIN--rej
      --
        BEGIN TRANSACTION

        UPDATE trastm_mak           WITH (ROWLOCK)
        SET    trastm_deleted_ind = 3
             , trastm_lst_upd_by  = @pa_login_name
             , trastm_lst_upd_dt  = getdate()
        WHERE  trastm_id          = convert(numeric,@currstring)
        AND    trastm_deleted_ind in (0,4,6)
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
