-- Object: PROCEDURE citrus_usr.pr_mak_narm
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

create  PROCEDURE [citrus_usr].[pr_mak_narm](@pa_id           varchar(8000)  
                           , @pa_action       varchar(5)
                           , @pa_login_name   varchar(20)  
                           , @pa_excm_id      numeric       
                           , @pa_trantm_id    numeric
                           , @pa_short_desc   varchar(50) 
                           , @pa_long_desc    varchar(200)  
                           , @pa_chk_yn       int  
                           , @rowdelimiter    char(4)       = '*|~*'  
                           , @coldelimiter    char(4)       = '|*~|'  
                           , @pa_errmsg       varchar(8000) output  
)  
AS
/*
*********************************************************************************
SYSTEM          : DP
MODULE NAME     : pr_mak_narm
DESCRIPTION     : this procedure will contain the maker checker facility for narration_mstr
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
        , @l_narmm_id        numeric
        , @l_narm_id         numeric 
        , @l_deleted_ind        smallint
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
          SELECT @l_narmm_id = ISNULL(MAX(narm_id),0)+ 1 FROM  narm_mak WITH (NOLOCK)

          SELECT @l_narm_id = ISNULL(MAX(narm_id),0)+ 1 FROM  narration_mstr WITH (NOLOCK)

          IF @l_narmm_id  > @l_narm_id 
          BEGIN
          --
            SET @l_narm_id = @l_narmm_id
          --
          END
          --
          INSERT INTO narration_mstr
          ( narm_id
          , narm_excm_id
          , narm_trantm_id
          , narm_short_desc
          , narm_long_desc
          , narm_created_dt
          , narm_created_by
          , narm_lst_upd_dt
          , narm_lst_upd_by
          , narm_deleted_ind
          )
          VALUES
          ( @l_narm_id 
          , @pa_excm_id   
          , @pa_trantm_id     
          , @pa_short_desc
          , @pa_long_desc 
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

          UPDATE narration_mstr     WITH (ROWLOCK)
          SET    narm_excm_id     = @pa_excm_id
               , narm_trantm_id   = @pa_trantm_id
               , narm_short_desc  = @pa_short_desc
               , narm_long_desc   = @pa_long_desc
               , narm_lst_upd_by  = @pa_login_name
               , narm_lst_upd_dt  = getdate()
          WHERE  narm_id          = CONVERT(INT,@currstring)
          AND    narm_deleted_ind = 1
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
          UPDATE narration_mstr     WITH (ROWLOCK)
          SET    narm_lst_upd_dt  = getdate()
                ,narm_lst_upd_by  = @pa_login_name
                ,narm_deleted_ind = 0
          WHERE  narm_id          = CONVERT(INT,@currstring)
          AND    narm_deleted_ind = 1
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

          SELECT @l_narmm_id = ISNULL(MAX(narm_id),0)+ 1 FROM narm_mak WITH (NOLOCK)

          SELECT @l_narm_id = ISNULL(MAX(narm_id),0)+ 1 FROM  narration_mstr WITH (NOLOCK)

          IF @l_narmm_id  > @l_narm_id 
          BEGIN
          --
            SET @l_narm_id = @l_narmm_id
          --
          END
          -- 
          INSERT INTO narm_mak
          ( narm_id
          , narm_excm_id
          , narm_trantm_id
          , narm_short_desc
          , narm_long_desc
          , narm_created_dt
          , narm_created_by
          , narm_lst_upd_dt
          , narm_lst_upd_by
          , narm_deleted_ind
          )
          VALUES
          ( @l_narm_id 
          , @pa_excm_id   
          , @pa_trantm_id     
          , @pa_short_desc
          , @pa_long_desc 
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
          UPDATE narm_mak           WITH (ROWLOCK)
          SET    narm_deleted_ind = 2
               , narm_lst_upd_dt  = getdate()
               , narm_lst_upd_by  = @pa_login_name
          WHERE  narm_id          = CONVERT(INT,@currstring)
          AND    narm_deleted_ind = 0
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
            IF EXISTS(select * from narration_mstr where narm_id = CONVERT(INT,@currstring) and narm_deleted_ind = 1)
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
								  
          
          
            SELECT @l_narmm_id = ISNULL(MAX(narm_id),0)+ 1 FROM narm_mak WITH (NOLOCK)
            --
            SELECT @l_narm_id = ISNULL(MAX(narm_id),0)+ 1 FROM  narration_mstr WITH (NOLOCK)

            IF @l_narmm_id  > @l_narm_id 
            BEGIN
            --
              SET @l_narm_id = @l_narmm_id
            --
            END
            --        
            INSERT INTO narm_mak
            ( narm_id
            , narm_excm_id
            , narm_trantm_id
            , narm_short_desc
            , narm_long_desc
            , narm_created_dt
            , narm_created_by
            , narm_lst_upd_dt
            , narm_lst_upd_by
            , narm_deleted_ind
            )
            VALUES
            ( @l_narm_id 
            , @pa_excm_id   
            , @pa_trantm_id     
            , @pa_short_desc
            , @pa_long_desc 
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
      END--chk_1
      -- 
      IF @pa_action = 'DEL'
						BEGIN
						--
									IF exists(SELECT * FROM narm_mak WHERE narm_id = convert(numeric,@currstring) and narm_deleted_ind in(0,4))
									BEGIN
									--
											DELETE FROM narm_mak 
											WHERE narm_id = convert(numeric,@currstring)
											AND   narm_deleted_ind = 0
									--
									END
									ELSE
									BEGIN
									--
											INSERT INTO narm_mak
											( narm_id
            , narm_excm_id
            , narm_trantm_id
            , narm_short_desc
            , narm_long_desc
            , narm_created_dt
            , narm_created_by
            , narm_lst_upd_dt
            , narm_lst_upd_by
            , narm_deleted_ind  
											)
											SELECT narm_id
											, narm_excm_id
											, narm_trantm_id
											, narm_short_desc
											, narm_long_desc
											, narm_created_dt
											, narm_created_by
           , @pa_login_name
											, getdate()
											, 4
											FROM  narration_mstr
											WHERE narm_id          = convert(numeric,@currstring)
											AND   narm_deleted_ind = 1
									--
									END
						--
						END
      IF @pa_action = 'APP'
      BEGIN--app
      --
        BEGIN TRANSACTION
        --        
        IF EXISTS(SELECT * FROM narration_mstr WHERE narm_id = convert(numeric,@currstring) and narm_deleted_ind = 1)
        BEGIN--exts
        --
          UPDATE narration_mstr            WITH (ROWLOCK)
          SET    narm_excm_id            = narmm.narm_excm_id
               , narm_trantm_id          = narmm.narm_trantm_id
               , narm_short_desc         = narmm.narm_short_desc
               , narm_long_desc          = narmm.narm_long_desc
               , narm_lst_upd_by         = narmm.narm_lst_upd_by
               , narm_lst_upd_dt         = narmm.narm_lst_upd_dt
          FROM   narm_mak                  narmm     
          WHERE  narmm.narm_id           = convert(numeric,@currstring)
          AND    narmm.narm_deleted_ind  = 6  
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
            UPDATE narm_mak           WITH (ROWLOCK)
            SET    narm_deleted_ind = 7
                 , narm_lst_upd_by  = @pa_login_name
                 , narm_lst_upd_dt  = getdate()
            WHERE  narm_id          = convert(numeric,@currstring)
            AND    narm_deleted_ind = 6
            --
            COMMIT TRANSACTION
          --
          END
        --
        END--exts
        ELSE IF exists(select * from narm_mak where narm_id = convert(numeric,@currstring) and narm_deleted_ind = 0)
        BEGIN--n_exts
        --
          INSERT INTO narration_mstr
          ( narm_id
          , narm_excm_id
          , narm_trantm_id
          , narm_short_desc
          , narm_long_desc
          , narm_created_dt
          , narm_created_by
          , narm_lst_upd_dt
          , narm_lst_upd_by
          , narm_deleted_ind
          )
          SELECT narm_id
               , narm_excm_id
               , narm_trantm_id
               , narm_short_desc
               , narm_long_desc
               , narm_created_dt
               , narm_created_by
               , narm_lst_upd_dt
               , narm_lst_upd_by
               , 1
          FROM  narm_mak
          WHERE narm_id = convert(numeric,@currstring)
          AND   narm_deleted_ind = 0

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
            UPDATE narm_mak           WITH (ROWLOCK)
            SET    narm_deleted_ind = 1
                 , narm_lst_upd_by  = @pa_login_name
                 , narm_lst_upd_dt  = getdate()
            WHERE  narm_id          = convert(numeric,@currstring)
            AND    narm_deleted_ind = 0
            --  
            COMMIT TRANSACTION
          --
          END
        --
        END--n_exts
        ELSE 
								BEGIN
								--
										UPDATE narration_mstr 
										SET    narm_deleted_ind = 0
															, narm_lst_upd_by  = @pa_login_name
															, narm_lst_upd_dt  = getdate()
										WHERE  narm_id          = convert(numeric,@currstring)
										AND    narm_deleted_ind = 1

										UPDATE narm_mak
										SET    narm_deleted_ind = 5
															, narm_lst_upd_by  = @pa_login_name
															, narm_lst_upd_dt  = getdate()
										WHERE  narm_id          = convert(numeric,@currstring)
										AND    narm_deleted_ind = 4

										COMMIT TRANSACTION
								--
						  END
      --
      END--app
      --
      IF @pa_action = 'REJ'
      BEGIN--rej
      --
        BEGIN TRANSACTION

        UPDATE narm_mak           WITH (ROWLOCK)
        SET    narm_deleted_ind = 3
             , narm_lst_upd_by  = @pa_login_name
             , narm_lst_upd_dt  = getdate()
        WHERE  narm_id          = convert(numeric,@currstring)
        AND    narm_deleted_ind = 0
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
