-- Object: PROCEDURE citrus_usr.pr_mak_insm
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE  PROCEDURE [citrus_usr].[pr_mak_insm]( @pa_id           varchar(8000)  
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
MODULE NAME     : pr_mak_insm  
DESCRIPTION     : this procedure will contain the maker checker facility for instrument_mstr  
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
        , @l_insmm_id        numeric  
        , @l_insm_id         numeric  
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
          SELECT @l_insmm_id = ISNULL(MAX(insm_id),0)+ 1 FROM  insm_mak WITH (NOLOCK)  
  
          SELECT @l_insm_id = ISNULL(MAX(insm_id),0)+ 1 FROM  instrument_mstr WITH (NOLOCK)  
  
          IF @l_insmm_id  > @l_insm_id  
          BEGIN  
          --  
            SET @l_insm_id = @l_insmm_id  
          --  
          END  
          --  
          INSERT INTO instrument_mstr  
          ( insm_id  
          , insm_excm_id  
          , insm_code  
          , insm_desc  
          , insm_created_dt  
          , insm_created_by  
          , insm_lst_upd_dt  
          , insm_lst_upd_by  
          , insm_deleted_ind  
          )  
          VALUES  
          ( @l_insm_id  
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
  
          UPDATE instrument_mstr     WITH (ROWLOCK)  
          SET    insm_excm_id     = @pa_excm_id  
               , insm_code        = @pa_cd  
               , insm_desc        = @pa_desc  
               , insm_lst_upd_by  = @pa_login_name  
               , insm_lst_upd_dt  = getdate()  
          WHERE  insm_id          = CONVERT(INT,@currstring)  
          AND    insm_deleted_ind = 1  
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
          UPDATE instrument_mstr    WITH (ROWLOCK)  
          SET    insm_lst_upd_dt  = getdate()  
                ,insm_lst_upd_by  = @pa_login_name  
                ,insm_deleted_ind = 0  
          WHERE  insm_id          = CONVERT(INT,@currstring)  
          AND    insm_deleted_ind = 1  
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
      IF @pa_chk_yn = 1  
      BEGIN--chk_1  
      --  
        IF @pa_action = 'INS'  
        BEGIN--ins_1  
        --  
          BEGIN TRANSACTION  
  
          SELECT @l_insmm_id = ISNULL(MAX(insm_id),0)+ 1 FROM insm_mak WITH (NOLOCK)  
  
          SELECT @l_insm_id = ISNULL(MAX(insm_id),0)+ 1 FROM  instrument_mstr WITH (NOLOCK)  
  
          IF @l_insmm_id  > @l_insm_id  
          BEGIN  
          --  
            SET @l_insm_id = @l_insmm_id  
          --  
          END  
          --  
          INSERT INTO insm_mak  
          ( insm_id  
          , insm_excm_id  
          , insm_code  
          , insm_desc  
          , insm_created_dt  
          , insm_created_by  
          , insm_lst_upd_dt  
          , insm_lst_upd_by  
          , insm_deleted_ind  
          )  
          VALUES  
          ( @l_insm_id  
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
          UPDATE insm_mak           WITH (ROWLOCK)  
          SET    insm_deleted_ind = 2  
               , insm_lst_upd_dt  = getdate()  
               , insm_lst_upd_by  = @pa_login_name  
          WHERE  insm_id          = CONVERT(INT,@currstring)  
          AND    insm_deleted_ind = 0  
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
            IF EXISTS(select * from instrument_mstr where insm_id = CONVERT(INT,@currstring) and insm_deleted_ind = 1)  
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
            
            
            SELECT @l_insmm_id = ISNULL(MAX(insm_id),0)+ 1 FROM insm_mak WITH (NOLOCK)  
            --  
            SELECT @l_insm_id = ISNULL(MAX(insm_id),0)+ 1 FROM  instrument_mstr WITH (NOLOCK)  
  
            IF @l_insmm_id  > @l_insm_id  
            BEGIN  
            --  
              SET @l_insm_id = @l_insmm_id  
            --  
            END  
            --  
            INSERT INTO insm_mak  
            ( insm_id  
            , insm_excm_id  
            , insm_code  
            , insm_desc  
            , insm_created_dt  
            , insm_created_by  
            , insm_lst_upd_dt  
            , insm_lst_upd_by  
            , insm_deleted_ind  
            )  
            VALUES  
            ( @l_insm_id  
            , @pa_excm_id  
            , @pa_cd  
            , @pa_desc  
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
         IF exists(SELECT * FROM insm_mak WHERE insm_id = convert(numeric,@currstring) and insm_deleted_ind in(0,4))  
         BEGIN  
         --  
           DELETE FROM insm_mak   
           WHERE insm_id          = convert(numeric,@currstring)  
           AND   insm_deleted_ind = 0  
         --  
         END  
         ELSE  
         BEGIN  
         --  
           INSERT INTO insm_mak  
           ( insm_id  
           , insm_excm_id  
           , insm_code  
           , insm_desc  
           , insm_created_dt  
           , insm_created_by  
           , insm_lst_upd_dt  
           , insm_lst_upd_by  
           , insm_deleted_ind  
           )  
           SELECT insm_id  
            , insm_excm_id  
            , insm_code  
            , insm_desc  
            , insm_created_dt  
            , insm_created_by  
            , getdate()  
            , @pa_login_name  
            , 4  
           FROM  instrument_mstr  
           WHERE insm_id          = convert(numeric,@currstring)  
           AND   insm_deleted_ind = 1  
         --  
         END  
      --  
      END  
      IF @pa_action = 'APP'  
      BEGIN--app  
      --  
        BEGIN TRANSACTION  
        --  
        IF EXISTS(SELECT * FROM insm_mak WHERE insm_id = convert(numeric,@currstring) and insm_deleted_ind = 4)  
        BEGIN--exts  
        --  
          UPDATE instrument_mstr            WITH (ROWLOCK)  
          SET    insm_excm_id            = insmm.insm_excm_id  
               , insm_code               = insmm.insm_code  
               , insm_desc               = insmm.insm_desc  
               , insm_lst_upd_by         = insmm.insm_lst_upd_by  
               , insm_lst_upd_dt         = insmm.insm_lst_upd_dt  
          FROM   insm_mak                  insmm  
          WHERE  insmm.insm_id           = convert(numeric,@currstring)  
          AND    insmm.insm_deleted_ind  = 6 
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
            UPDATE insm_mak           WITH (ROWLOCK)  
            SET    insm_deleted_ind = 7  
                 , insm_lst_upd_by  = @pa_login_name  
                 , insm_lst_upd_dt  = getdate()  
            WHERE  insm_id          = convert(numeric,@currstring)  
            AND    insm_deleted_ind = 6  
            --  
            COMMIT TRANSACTION  
          --  
          END  
        --  
        END--exts  
        ELSE IF exists(select * FROM  insm_mak WHERE insm_id = convert(numeric,@currstring) AND   insm_deleted_ind = 0)  
        BEGIN--n_exts  
        --  
          INSERT INTO instrument_mstr  
          ( insm_id  
          , insm_excm_id  
          , insm_code  
          , insm_desc  
          , insm_created_dt  
          , insm_created_by  
          , insm_lst_upd_dt  
          , insm_lst_upd_by  
          , insm_deleted_ind  
          )  
          SELECT insm_id  
               , insm_excm_id  
               , insm_code  
               , insm_desc  
               , insm_created_dt  
               , insm_created_by  
               , insm_lst_upd_dt  
               , insm_lst_upd_by  
               , 1  
          FROM  insm_mak  
          WHERE insm_id = convert(numeric,@currstring)  
          AND   insm_deleted_ind = 0  
  
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
            UPDATE insm_mak           WITH (ROWLOCK)  
            SET    insm_deleted_ind = 1  
                 , insm_lst_upd_by  = @pa_login_name  
                 , insm_lst_upd_dt  = getdate()  
            WHERE  insm_id          = convert(numeric,@currstring)  
            AND    insm_deleted_ind = 0  
            --  
            COMMIT TRANSACTION  
          --  
          END  
        --  
        END--n_exts  
        ELSE   
        BEGIN  
        --  
          UPDATE instrument_mstr  
          SET    insm_deleted_ind = 0  
               , insm_lst_upd_by  = @pa_login_name  
               , insm_lst_upd_dt  = getdate()  
          WHERE  insm_id          = convert(numeric,@currstring)  
          AND    insm_deleted_ind = 1  
  
          UPDATE insm_mak  
          SET    insm_deleted_ind = 5 
               , insm_lst_upd_by  = @pa_login_name  
               , insm_lst_upd_dt  = getdate()  
          WHERE  insm_id          = convert(numeric,@currstring)  
          AND    insm_deleted_ind = 4  
  
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
  
        UPDATE insm_mak           WITH (ROWLOCK)  
        SET    insm_deleted_ind = 3  
             , insm_lst_upd_by  = @pa_login_name  
             , insm_lst_upd_dt  = getdate()  
        WHERE  insm_id          = convert(numeric,@currstring)  
        AND    insm_deleted_ind IN (0,4,6)  
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
