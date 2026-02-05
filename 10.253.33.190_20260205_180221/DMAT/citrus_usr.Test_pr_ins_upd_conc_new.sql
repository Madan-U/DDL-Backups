-- Object: PROCEDURE citrus_usr.Test_pr_ins_upd_conc_new
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE [citrus_usr].[Test_pr_ins_upd_conc_new] (@pa_id           varchar(8000)  
                                ,@pa_action       varchar(20)  
                                ,@pa_login_name   varchar(20)  
                                ,@pa_tab         char(4)
                                ,@pa_ent_id       numeric
                                ,@pa_clisba_id    numeric    
                                ,@pa_acct_no      varchar(20)  
                                ,@pa_acct_type    varchar(20)
                                ,@pa_concm_id     numeric
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
 module name    : pr_ins_upd_conc
 description    : this procedure will add new values to account_addr_conc & entity_addr_conc
 copyright(c)   : MarketPlace Technolgies Pvt. Ltd.
 version history: 1.0
 VERS.  AUTHOR          DATE         REASON
 -----  -------------   ----------   -----------------------------------------------
 1.0    Sukhvinder      05-may-2007  Initial version.
 -----------------------------------------------------------------------------------
*/
BEGIN  
--  
  SET NOCOUNT ON
  --
  DECLARE @@remainingstring_id      varchar(8000)  
        , @@currstring_id           varchar(8000)  
        , @@remainingstring_val     varchar(8000)  
        , @@currstring_val          varchar(8000)
        , @@foundat                 int  
        , @@delimeterlength         int 
        , @@delimeter               char(4)
        , @@l_errorstr              varchar(8000)
        , @@l_error                 numeric
        --
        , @@l_concm_desc            varchar(50)  
        , @@l_conc_id               numeric
        , @@l_concm_cd              varchar(20) 
        , @@l_conc_value            varchar(50)
        , @@l_old_conc_value        varchar(50)
        , @@l_old_conc_id           numeric
        , @@l_entac_adr_conc_id     numeric
        , @@l_concmak_id            numeric
        , @@l_concm_id              numeric
                    ---APP---
        , @@l_ent_id                numeric
        , @@l_deleted_ind           smallint
        , @@l_conc_value_new        varchar(50)
        , @@l_conc_value_old        varchar(50)
        , @@l_action                char(4)
  --
  --IF @pa_action <> 'APP' and @pa_action <> 'REJ'
  --BEGIN--nt_ap_rj
  --
    IF @pa_tab = 'ACCT'
    BEGIN--acct
    --
      CREATE TABLE #t_conc
      (clisba_id      numeric
      ,acct_no        varchar(20)
      ,acct_type      varchar(20)
      ,concm_id       numeric
      ,conc_id        numeric
      ,conc_value     varchar(50)
      )
      --
      INSERT INTO #t_conc  
      SELECT a.accac_clisba_id  
           , a.accac_acct_no 
           , a.accac_acct_type  
           , a.accac_concm_id
           , b.conc_id  
           , b.conc_value  
      FROM   account_adr_conc a   WITH(NOLOCK)  
      JOIN   contact_channels b   WITH(NOLOCK)  
      ON     a.accac_adr_conc_id  = b.conc_id  
      WHERE  a.accac_clisba_id    = @pa_clisba_id  
      AND    a.accac_deleted_ind  = 1  
      AND    b.conc_deleted_ind   = 1   
    --  
    END--acct
    --
    IF @pa_tab = 'ENT'
    BEGIN--ent
    --
      CREATE TABLE   #t_ent_conc  
      (entac_ent_id     numeric  
      ,entac_concm_cd   varchar(20)  
      ,conc_value       varchar(20)  
      ,conc_id          numeric  
      ,concm_id   numeric  
      )  

      INSERT INTO #t_ent_conc  
      SELECT a.entac_ent_id  
           , a.entac_concm_cd  
           , b.conc_value  
           , b.conc_id  
           , a.entac_concm_id  
      FROM   entity_adr_conc  a   WITH(NOLOCK)  
      JOIN   contact_channels b   WITH(NOLOCK)  
      ON     a.entac_adr_conc_id  = b.conc_id  
      WHERE  a.entac_ent_id       = @pa_ent_id  
      AND    a.entac_deleted_ind  = 1  
      AND    b.conc_deleted_ind   = 1 
    --
    END--ent
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
            IF @pa_tab  = 'ACCT'
            BEGIN--acct
            --
              SET @@l_conc_value     = citrus_usr.fn_splitval(@@currstring_val,1)
              --
              IF @pa_action = 'INS'
              BEGIN--ins_acct
              --
                IF @pa_chk_yn = 0
                BEGIN--ins_0
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
                    ,@pa_concm_id
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
                      WHERE  concm_id          = @pa_concm_id
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
                      SET @@l_error = @@ERROR  
                      --  
                      IF @@l_error > 0  
                      BEGIN--r1_1  
                      --  
                        SELECT @@l_concm_desc    = concm_desc  
                        FROM   conc_code_mstr    WITH(NOLOCK)  
                        WHERE  concm_id          = @pa_concm_id  
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
                        ,@pa_concm_id
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
                          WHERE  concm_id          = @pa_concm_id  
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
                END--ins_0
              --
              END --ins_acct
              --
              IF @pa_action = 'EDT'
              BEGIN--edt_acct
              --
                IF @pa_chk_yn = 0
                BEGIN--edt_0
                --
                  IF @@l_conc_value = ''  
                  BEGIN--null  
                  --
                    SELECT @@l_conc_id        = accac_adr_conc_id  
                    FROM   account_adr_conc   WITH(NOLOCK)  
                    WHERE  accac_clisba_id    = @pa_clisba_id  
                    AND    accac_concm_id     = @pa_concm_id  
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
                      AND    accac_concm_id    = @pa_concm_id  
                      AND    accac_deleted_ind = 1
                      --
                      SET @@l_error = @@ERROR  
                      --  
                      IF @@l_error > 0
                      BEGIN  
                      --  
                        SELECT @@l_concm_desc    = concm_desc  
                        FROM   conc_code_mstr    WITH(NOLOCK)  
                        WHERE  concm_id          = @pa_concm_id  
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
                        WHERE  concm_id          = @pa_concm_id  
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
                          WHERE  concm_id          = @pa_concm_id  
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
                  IF ISNULL(@@l_conc_value,'') <> ''
                  BEGIN--not_null
                  --
                    IF EXISTS(SELECT conc_value
                              FROM   #t_conc
                              WHERE  concm_id = @pa_concm_id
                                )
                    BEGIN--a_exts1
                    --
                      SELECT @@l_old_conc_value = conc_value
                           , @@l_old_conc_id    = conc_id
                      FROM   #t_conc
                      WHERE  concm_id           = @pa_concm_id
                      --
                      IF @@l_old_conc_value     = @@l_conc_value
                      BEGIN--#same
                      --
                         PRINT 'VALUES ARE SAME '--THEN DO NOTHING  
                      --  
                      END --#same
                      ELSE
                      BEGIN--#n_same
                      --
                        SELECT @@l_old_conc_id    = accac_adr_conc_id
                        FROM   account_adr_conc   WITH (NOLOCK)
                        WHERE  accac_clisba_id    = @pa_clisba_id
                        AND    accac_concm_id     = @pa_concm_id
                        AND    accac_deleted_ind  = 1
                        --
                        --DELETE FROM #t_conc
                        --WHERE  accac_concm_id  = @pa_concm_id
                        --AND    accac_clisba_id = @pa_clisba_id
                        --
                        IF EXISTS(SELECT * FROM account_adr_conc WITH (NOLOCK)
                                  WHERE    accac_concm_id     = @pa_concm_id
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
                            WHERE  concm_id          = @pa_concm_id
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
                            WHERE  accac_clisba_id   = @pa_clisba_id
                            AND    accac_concm_id    = @pa_concm_id
                            AND    accac_deleted_ind = 1
                            --
                            SET @@l_error = @@ERROR
                            --
                            IF @@l_error > 0
                            BEGIN--#r1
                            --
                              SELECT @@l_concm_desc    = concm_desc
                              FROM   conc_code_mstr      WITH (NOLOCK)
                              WHERE  concm_id          = @pa_concm_id
                              AND    concm_deleted_ind = 1
                              --
                              SET @@l_errorstr = @@l_concm_desc+' Could not be Inserted'+@rowdelimiter+@@l_errorstr
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
                          UPDATE contact_channels  WITH(ROWLOCK)  
                          SET    conc_value        = @@l_conc_value  
                                ,conc_lst_upd_by   = @pa_login_name  
                                ,conc_lst_upd_dt   = getdate()  
                          WHERE  conc_id           = @@l_old_conc_id  
                          AND    conc_deleted_ind  = 1  
                          --
                          SET @@l_error = @@ERROR
                          --
                          IF @@l_error > 0
                          BEGIN
                          --
                            SELECT @@l_concm_desc    = concm_desc
                            FROM   conc_code_mstr    WITH (NOLOCK)
                            WHERE  concm_id          = @pa_concm_id
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
                                FROM   contact_channels  WITH(NOLOCK)  
                                WHERE  conc_value        = @@l_conc_value  
                                AND    conc_deleted_ind  = 1
                               )  
                      BEGIN--e_1  
                      --
                        BEGIN TRANSACTION
                        --
                        SELECT @@l_conc_id      = conc_id  
                        FROM   contact_channels WITH(NOLOCK)  
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
                        ,@pa_concm_id  
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
                          FROM   conc_code_mstr    WITH(NOLOCK)  
                          WHERE  concm_id          = @pa_concm_id  
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
                        SELECT @@l_conc_id       = bitrm_bit_location  
                        FROM   bitmap_ref_mstr   WITH(NOLOCK)  
                        WHERE  bitrm_parent_cd   = 'ADR_CONC_ID'  
                        AND    bitrm_child_cd    = 'ADR_CONC_ID'  
                        --  
                        UPDATE bitmap_ref_mstr    WITH(ROWLOCK)  
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
                        ,conc_deleted_ind)  
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
                          WHERE  concm_id          = @pa_concm_id  
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
                          ,@pa_concm_id  
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
                            WHERE  concm_id          = @pa_concm_id  
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
                END--edt_0
              --
              END--edt_acct
            --
            END--acct
            --
            IF @pa_tab = 'ENT'
            BEGIN--ent
            --
              SET @@l_concm_cd    = citrus_usr.fn_splitval(@@currstring_val,1)  
              SET @@l_conc_value  = citrus_usr.fn_splitval(@@currstring_val,2)  
              --  
              SELECT @@l_concm_id      = concm_id  
              FROM   conc_code_mstr      WITH(NOLOCK)  
              WHERE  concm_cd          = @@l_concm_cd  
              AND    concm_deleted_ind = 1
              --
              IF @pa_action = 'INS'
              BEGIN--ins_ent
              --
                IF @pa_chk_yn = 0
                BEGIN--ins_0
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
                    FROM   contact_channels  WITH(NOLOCK)  
                    WHERE  conc_value        = @@l_conc_value  
                    AND    conc_deleted_ind  = 1  
                    --  
                    INSERT INTO entity_adr_conc  
                    (entac_ent_id  
                    ,entac_acct_no  
                    ,entac_concm_id  
                    ,entac_concm_cd  
                    ,entac_adr_conc_id  
                    ,entac_created_by  
                    ,entac_created_dt  
                    ,entac_lst_upd_by  
                    ,entac_lst_upd_dt  
                    ,entac_deleted_ind
                    )  
                    VALUES  
                    (@pa_ent_id  
                    ,@pa_acct_no  
                    ,@@l_concm_id  
                    ,@@l_concm_cd  
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
                  END--ext_1
                  ELSE
                  BEGIN--n_ext_1
                  --
                    BEGIN TRANSACTION  
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
                    BEGIN--#r1  
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
                    END--#r1  
                    ELSE
                    BEGIN--#c1
                    --
                      INSERT INTO entity_adr_conc  
                      (entac_ent_id  
                      ,entac_acct_no  
                      ,entac_concm_id  
                      ,entac_concm_cd  
                      ,entac_adr_conc_id  
                      ,entac_created_by  
                      ,entac_created_dt  
                      ,entac_lst_upd_by  
                      ,entac_lst_upd_dt  
                      ,entac_deleted_ind
                      )  
                      VALUES  
                      (@pa_ent_id  
                      ,@pa_acct_no  
                      ,@@l_concm_id  
                      ,@@l_concm_cd  
                      ,@@l_conc_id  
                      ,@pa_login_name  
                      ,getdate()  
                      ,@pa_login_name  
                      ,getdate()  
                      ,1
                      )
                      --
                      SET @@l_error = @@error  
                      --  
                      IF @@l_error > 0
                      BEGIN--#r1_1  
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
                      END--#r1_1    
                      ELSE  
                      BEGIN--#c1_1  
                      --  
                        COMMIT TRANSACTION  
                      --  
                      END--#c1_1  
                    --
                    END--#c1
                  --
                  END--n_ext_1
                --
                END--ins_0
              --
              END--ins_ent
              --
              IF @pa_action = 'EDT'
              BEGIN--edt_ent
              --
                IF @pa_chk_yn = 0
                BEGIN--edt_0
                --
                  IF @@l_conc_value = ''  
                  BEGIN--null  
                  --
                    SELECT @@l_conc_id        = entac_adr_conc_id  
                    FROM   entity_adr_conc      WITH(NOLOCK)  
                    WHERE  entac_ent_id       = @pa_ent_id  
                    AND    entac_concm_id     = @pa_concm_id  
                    AND    entac_deleted_ind  = 1
                    --
                    IF EXISTS(SELECT entac_adr_conc_id  
                              FROM   entity_adr_conc      WITH(NOLOCK)  
                              WHERE  entac_ent_id      <> @pa_ent_id  
                              AND    entac_adr_conc_id  = @@l_conc_id  
                              AND    entac_deleted_ind  = 1   
                              )  
                    BEGIN--exts1
                    --
                      BEGIN TRANSACTION  
                      --  
                      DELETE FROM entity_adr_conc
                      WHERE  entac_ent_id      = @pa_ent_id  
                      AND    entac_concm_id    = @pa_concm_id  
                      AND    entac_deleted_ind = 1
                      --
                      SET @@l_error = @@ERROR  
                      --  
                      IF @@l_error > 0
                      BEGIN  
                      --  
                        SELECT @@l_concm_desc    = concm_desc  
                        FROM   conc_code_mstr    WITH(NOLOCK)  
                        WHERE  concm_id          = @pa_concm_id  
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
                        WHERE  concm_id          = @pa_concm_id  
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
                        DELETE FROM entity_adr_conc  
                        WHERE  entac_ent_id      = @pa_ent_id  
                        AND    entac_adr_conc_id = @@l_conc_id  
                        AND    entac_deleted_ind = 1  
                        --  
                        SET @@l_error = @@ERROR  
                        --  
                        IF @@l_error > 0  
                        BEGIN  
                        --  
                          SELECT @@l_concm_desc    = concm_desc  
                          FROM   conc_code_mstr    WITH(NOLOCK)  
                          WHERE  concm_id          = @pa_concm_id  
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
                  IF @@l_conc_value <> ''
                  BEGIN--not_null
                  --
                    IF EXISTS(SELECT conc_value
                              FROM   #t_conc
                              WHERE  concm_id = @pa_concm_id
                                )
                    BEGIN--a_exts1
                    --
                      SELECT @@l_old_conc_value = conc_value
                           , @@l_old_conc_id    = conc_id
                      FROM   #t_conc
                      WHERE  concm_id           = @pa_concm_id
                      --
                      IF @@l_old_conc_value     = @@l_conc_value
                      BEGIN--#same
                      --
                         PRINT 'VALUES ARE SAME '--THEN DO NOTHING  
                      --  
                      END --#same
                      ELSE
                      BEGIN--#n_same
                      --
                        SELECT @@l_old_conc_id    = entac_adr_conc_id
                        FROM   entity_adr_conc      WITH (NOLOCK)
                        WHERE  entac_ent_id       = @pa_ent_id
                        AND    entac_concm_id     = @pa_concm_id
                        AND    entac_deleted_ind  = 1
                        --
                        --DELETE FROM #t_conc
                        --WHERE  accac_concm_id  = @pa_concm_id
                        --AND    accac_clisba_id = @pa_clisba_id
                        --
                        IF EXISTS(SELECT * FROM entity_adr_conc WITH (NOLOCK)
                                  WHERE    entac_concm_id     = @pa_concm_id
                                  AND      entac_adr_conc_id  = @@l_old_conc_id
                                  AND      entac_ent_id      <> @pa_ent_id
                                  AND      entac_deleted_ind  = 1
                                 )
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
                            WHERE  concm_id          = @pa_concm_id
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
                            UPDATE entity_adr_conc    WITH (ROWLOCK)
                            SET    entac_adr_conc_id = @@l_conc_id
                            WHERE  entac_ent_id      = @pa_ent_id
                            AND    entac_concm_id    = @pa_concm_id
                            AND    entac_deleted_ind = 1
                            --
                            SET @@l_error = @@ERROR
                            --
                            IF @@l_error > 0
                            BEGIN--#r1
                            --
                              SELECT @@l_concm_desc    = concm_desc
                              FROM   conc_code_mstr      WITH (NOLOCK)
                              WHERE  concm_id          = @pa_concm_id
                              AND    concm_deleted_ind = 1
                              --
                              SET @@l_errorstr = @@l_concm_desc+' Could not be Inserted'+@rowdelimiter+@@l_errorstr
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
                          UPDATE contact_channels  WITH(ROWLOCK)  
                          SET    conc_value        = @@l_conc_value  
                                ,conc_lst_upd_by   = @pa_login_name  
                                ,conc_lst_upd_dt   = getdate()  
                          WHERE  conc_id           = @@l_old_conc_id  
                          AND    conc_deleted_ind  = 1  
                          --
                          SET @@l_error = @@ERROR
                          --
                          IF @@l_error > 0
                          BEGIN
                          --
                            SELECT @@l_concm_desc    = concm_desc
                            FROM   conc_code_mstr    WITH (NOLOCK)
                            WHERE  concm_id          = @pa_concm_id
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
                                FROM   contact_channels  WITH(NOLOCK)  
                                WHERE  conc_value        = @@l_conc_value  
                                AND    conc_deleted_ind  = 1
                               )  
                      BEGIN--e_1  
                      --
                        BEGIN TRANSACTION
                        --
                        SELECT @@l_conc_id      = conc_id  
                        FROM   contact_channels WITH(NOLOCK)  
                        WHERE  conc_value       = @@l_conc_value  
                        AND    conc_deleted_ind = 1
                        --
                        INSERT INTO entity_adr_conc  
                        (entac_ent_id  
                        ,entac_acct_no  
                        ,entac_concm_id  
                        ,entac_concm_cd  
                        ,entac_adr_conc_id  
                        ,entac_created_by  
                        ,entac_created_dt  
                        ,entac_lst_upd_by  
                        ,entac_lst_upd_dt  
                        ,entac_deleted_ind)  
                        VALUES  
                        (@pa_ent_id  
                        ,@pa_acct_no  
                        ,@@l_concm_id  
                        ,@@l_concm_cd  
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
                          WHERE  concm_id          = @pa_concm_id  
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
                        SELECT @@l_conc_id       = bitrm_bit_location  
                        FROM   bitmap_ref_mstr   WITH(NOLOCK)  
                        WHERE  bitrm_parent_cd   = 'ADR_CONC_ID'  
                        AND    bitrm_child_cd    = 'ADR_CONC_ID'  
                        --  
                        UPDATE bitmap_ref_mstr    WITH(ROWLOCK)  
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
                        ,conc_deleted_ind)  
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
                          WHERE  concm_id          = @pa_concm_id  
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
                          INSERT INTO entity_adr_conc  
                          (entac_ent_id  
                          ,entac_acct_no  
                          ,entac_concm_id  
                          ,entac_concm_cd  
                          ,entac_adr_conc_id  
                          ,entac_created_by  
                          ,entac_created_dt  
                          ,entac_lst_upd_by  
                          ,entac_lst_upd_dt  
                          ,entac_deleted_ind)  
                          VALUES  
                          (@pa_ent_id  
                          ,@pa_acct_no  
                          ,@@l_concm_id  
                          ,@@l_concm_cd  
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
                            WHERE  concm_id          = @pa_concm_id  
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
                END--edt_0
              --
              END--edt_ent
              --
              IF @pa_action = 'INS' OR @pa_action = 'EDT' OR @pa_action = 'DEL' 
              BEGIN--i_e_d
              --
                IF @pa_chk_yn = 1 OR @pa_chk_yn = 2  
                BEGIN--chk_1_2  
                --
                  IF @pa_tab = 'ENT'
                  BEGIN--ent
                  --
                    IF EXISTS(SELECT conc_ent_id 
                              FROM   contact_channels_mak  WITH (NOLOCK)
                              WHERE  conc_deleted_ind     IN (0,4,8)
                              AND    conc_ent_id           = @pa_ent_id
                              AND    conc_concm_id         = @@l_concm_id
                             )

                    BEGIN--exts          
                    --
                      BEGIN TRANSACTION      
                      
                      UPDATE contact_channels_mak  WITH (ROWLOCK)
                      SET    conc_deleted_ind =  3 
                      WHERE  conc_ent_id      =  @pa_ent_id
                      AND    conc_deleted_ind IN (0,4,8)
                      AND    conc_concm_id    =  @@l_concm_id
                      -- 
                      SELECT @@l_concmak_id = ISNULL(MAX(concmak_id),0)+1 
                      FROM   contact_channels_mak WITH (NOLOCK)    
                      --  
                      INSERT INTO contact_channels_mak  
                      (concmak_id  
                      ,conc_id  
                      ,conc_value  
                      ,conc_ent_id  
                      ,conc_concm_id  
                      ,conc_concm_cd  
                      ,conc_created_by  
                      ,conc_created_dt  
                      ,conc_lst_upd_by  
                      ,conc_lst_upd_dt  
                      ,conc_deleted_ind  
                      )  
                      VALUES  
                      (@@l_concmak_id  
                      ,0 
                      ,@@l_conc_value  
                      ,@pa_ent_id  
                      ,@@l_concm_id  
                      ,@@l_concm_cd  
                      ,@pa_login_name  
                      ,GETDATE()  
                      ,@pa_login_name  
                      ,GETDATE()  
                      ,CASE @pa_action WHEN 'INS' THEN 0
                                       WHEN 'EDT' THEN (CASE @@l_conc_value WHEN '' THEN 4 ELSE 8  END) END
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
                        SET @@l_errorstr = @@l_concm_desc+'Could not be Inserted'+@rowdelimiter+@@l_errorstr  
                        --  
                        ROLLBACK TRANSACTION  
                      --  
                      END  
                      ELSE  
                      BEGIN  
                      --  
                        COMMIT TRANSACTION  
                        --
                        SELECT @@l_action = CASE @pa_action WHEN 'INS' THEN 'I'
                                                            WHEN 'EDT' THEN (CASE @@l_conc_value WHEN '' THEN 'D' ELSE 'E' END) END
                        --
                        EXEC pr_ins_upd_list @pa_ent_id, @@l_action,'CONTACT CHANNELS', @pa_login_name,'*|~*','|*~|',''
                        --  
                      END      
                    --
                    END--exts
                  --  
                  END--ent
                  --
                  IF @pa_tab = 'ACCT'
                  BEGIN--acct
                  --
                     print ''
                  --
                  END
                --
                END--chk_1_2  
              --
              END--i_e_d
            --
            END--ent
          --
          END--cur_val
        --
        END--w_val
      --
      END--not_app_rej
      --
      IF @pa_tab  = 'ENT'
      BEGIN--app_ent
      --
        IF @pa_action = 'APP'  
        BEGIN--app
        --
          SELECT @@l_deleted_ind         = conc_deleted_ind  
               , @@l_ent_id              = conc_ent_id  
               , @@l_concm_id            = conc_concm_id  
               , @@l_concm_cd            = conc_concm_cd  
               , @@l_conc_value_new      = conc_value  
          FROM   contact_channels_mak      WITH (NOLOCK)  
          WHERE  concmak_id              = CONVERT(numeric, @@currstring_id)  
          AND    conc_deleted_ind       IN (0,4,8)
          --
          SELECT @@l_conc_id             = conc.conc_id  
               , @@l_conc_value_old      = conc.conc_value    
          FROM   contact_channels          conc  
          JOIN   entity_adr_conc           entac    
          ON     entac.entac_adr_conc_id = conc.conc_id  
          WHERE  entac_ent_id            = @@l_ent_id  
          AND    entac_concm_id          = @@l_concm_id  
          AND    entac_concm_cd          = @@l_concm_cd  
          AND    entac_deleted_ind       = 1  
          AND    conc_deleted_ind        = 1
          --
          IF @@l_deleted_ind = 4  
          BEGIN--#4
          --  
            IF EXISTS(SELECT entac_adr_conc_id  
                      FROM   entity_adr_conc      WITH(NOLOCK)  
                      WHERE  entac_ent_id       <> @@l_ent_id    
                      AND    entac_adr_conc_id  =  @@l_conc_id  
                      AND    entac_deleted_ind  =  1   
                     )  
            BEGIN--exts  
            --  
              BEGIN TRANSACTION  
              --
              UPDATE entity_adr_conc       WITH (ROWLOCK)
              SET    entac_deleted_ind   = 0
                   , entac_lst_upd_by    = @pa_login_name
                   , entac_lst_upd_dt    = GETDATE()
              WHERE  entac_ent_id        = @@l_ent_id    
              AND    entac_concm_id      = @@l_concm_id  
              AND    entac_deleted_ind   = 1   
              --                              
              SET @@l_error = @@ERROR  
              --  
              IF @@l_error > 0
              BEGIN  
                --  
                SELECT @@l_concm_desc     = concm_desc  
                FROM   conc_code_mstr       WITH(NOLOCK)  
                WHERE  concm_id           = @@l_concm_id  
                AND    concm_deleted_ind  = 1  
                --  
                SET @@l_errorstr = @@l_concm_desc+'Could not be Edited/Deleted'+@rowdelimiter+@@l_errorstr  
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
            END--exts  
            ELSE  
            BEGIN--n_exts  
            --
              UPDATE entity_adr_conc      WITH (ROWLOCK)
              SET    entac_deleted_ind  = 0
                   , entac_lst_upd_by   = @pa_login_name
                   , entac_lst_upd_dt   = GETDATE()
              WHERE  entac_ent_id       = @@l_ent_id    
              AND    entac_adr_conc_id  = @@l_conc_id  
              AND    entac_deleted_ind  = 1  
              --  
              UPDATE contact_channels     WITH (ROWLOCK)
              SET    conc_deleted_ind   = 0
                   , conc_lst_upd_by    = @pa_login_name
                   , conc_lst_upd_dt    = GETDATE()
              WHERE  conc_deleted_ind   = 1
              AND    conc_id            = @@l_conc_id 
              --DELETE FROM contact_channels  WITH (ROWLOCK) 
              --WHERE  conc_id            = @@l_conc_id  
              --AND    conc_deleted_ind   = 1  
              --  
              --DELETE FROM entity_adr_conc   WITH (ROWLOCK)   
              --WHERE  entac_ent_id       = @@l_ent_id    
              --AND    entac_adr_conc_id  = @@l_conc_id  
              --AND    entac_deleted_ind  = 1  
            --  
            END--n_exts
            --
            UPDATE contact_channels_mak   WITH (ROWLOCK)       
            SET    conc_deleted_ind     = 5  
                 , conc_id              = @@l_conc_id  
                 , conc_lst_upd_by      = @pa_login_name  
                 , conc_lst_upd_dt      = GETDATE()  
            WHERE  conc_deleted_ind     = 4  
            AND    concmak_id           = CONVERT(numeric,@@currstring_id)  
          --  
          END--#4
          ELSE IF @@l_deleted_ind = 8  
          BEGIN--#8  
          --  
            IF EXISTS(SELECT b.conc_value  
                           , b.conc_id  
                           , a.entac_concm_cd  
                      FROM   entity_adr_conc   a    WITH(NOLOCK)  
                      JOIN   contact_channels  b    WITH(NOLOCK)  
                      ON     a.entac_adr_conc_id  = b.conc_id  
                      WHERE  a.entac_ent_id       = @@l_ent_id    
                      AND    a.entac_concm_cd     = @@l_concm_cd  
                      AND    a.entac_deleted_ind  = 1  
                      AND    b.conc_deleted_ind   = 1
                     )  
            BEGIN--exts1  
            --  
              IF @@l_conc_value_old = @@l_conc_value_new   
              BEGIN--same  
              --  
                PRINT 'SAME VALUE SO DO NOTHING'  
              --  
              END--same  
              ELSE  
              BEGIN--n_same  
              --  
                IF EXISTS(SELECT *   
                          FROM   entity_adr_conc      WITH(NOLOCK)  
                          WHERE  entac_concm_id     = @@l_concm_id  
                          AND    entac_adr_conc_id  = @@l_conc_id  
                          AND    entac_ent_id      <> @@l_ent_id    
                          AND    entac_deleted_ind  = 1  
                          )  
                BEGIN--exts1_1    
                --  
                  BEGIN TRANSACTION 

                  SELECT @@l_conc_id        = bitrm_bit_location  
                  FROM   bitmap_ref_mstr      WITH(NOLOCK)  
                  WHERE  bitrm_parent_cd    = 'ADR_CONC_ID'  
                  AND    bitrm_child_cd     = 'ADR_CONC_ID'  
                  --  
                  UPDATE bitmap_ref_mstr    WITH(ROWLOCK)  
                  SET    bitrm_bit_location = bitrm_bit_location+1  
                  WHERE  bitrm_parent_cd    = 'ADR_CONC_ID'  
                  AND    bitrm_child_cd     = 'ADR_CONC_ID'  

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
                  ,@@l_conc_value_new  
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
                    SET @@l_errorstr = @@l_concm_desc+'Could not be Inserted'+@rowdelimiter+@@l_errorstr  
                    --  
                    ROLLBACK TRANSACTION  
                  --  
                  END  
                  ELSE  
                  BEGIN  
                  --  
                    UPDATE entity_adr_conc   WITH(ROWLOCK)  
                    SET    entac_adr_conc_id = @@l_conc_id  
                    WHERE  entac_ent_id      = @@l_ent_id   
                    AND    entac_concm_id    = @@l_concm_id  
                    AND    entac_deleted_ind = 1  
                    --
                    COMMIT TRANSACTION  
                  --  
                  END  
                --  
                END--exts1_1      
                ELSE  
                BEGIN--n_exts1_1      
                --  
                  UPDATE contact_channels    WITH(ROWLOCK)  
                  SET    conc_value        = @@l_conc_value_new  
                        ,conc_lst_upd_by   = @pa_login_name  
                        ,conc_lst_upd_dt   = GETDATE()  
                  WHERE  conc_id           = @@l_conc_id   
                  AND    conc_deleted_ind  = 1  
                --  
                END--n_exts1_1        
              --  
              END--n_same  
            --  
            END--exts1  
            ELSE  
            BEGIN--n_exts1  
            --  
              BEGIN TRANSACTION
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
              ,@@l_conc_value_new  
              ,@pa_login_name  
              ,GETDATE()  
              ,@pa_login_name  
              ,GETDATE()  
              ,1
              )  
              --                                
              INSERT INTO entity_adr_conc  
              (entac_ent_id  
              ,entac_acct_no  
              ,entac_concm_id  
              ,entac_concm_cd  
              ,entac_adr_conc_id  
              ,entac_created_by  
              ,entac_created_dt  
              ,entac_lst_upd_by  
              ,entac_lst_upd_dt  
              ,entac_deleted_ind
              )  
              VALUES  
              (@@l_ent_id   
              ,@pa_acct_no  
              ,@@l_concm_id  
              ,@@l_concm_cd  
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
                FROM   conc_code_mstr      WITH(NOLOCK)  
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
                UPDATE contact_channels_mak WITH (ROWLOCK)         
                SET    conc_deleted_ind   = 9  
                     , conc_id            = @@l_conc_id  
                     , conc_lst_upd_by    = @pa_login_name  
                     , conc_lst_upd_dt    = GETDATE()  
                WHERE  conc_deleted_ind   = 8  
                AND    concmak_id         = CONVERT(NUMERIC,@@currstring_id)  
              --  
              END    
            --
            END--n_exts1  
          --  
          END--#8
          ELSE IF @@l_deleted_ind = 0  
          BEGIN--#0
          --
            IF EXISTS(SELECT conc_id  
                      FROM   contact_channels    WITH(NOLOCK)  
                      WHERE  conc_value        = @@l_conc_value_new  
                      AND    conc_deleted_ind  = 1  
                      )  
            BEGIN--exts1
            --
              SELECT @@l_conc_id        = conc_id  
              FROM   contact_channels     WITH(NOLOCK)  
              WHERE  conc_value         = @@l_conc_value_new  
              AND    conc_deleted_ind   = 1  
              --  
              INSERT INTO entity_adr_conc  
              (entac_ent_id  
              ,entac_acct_no  
              ,entac_concm_id  
              ,entac_concm_cd  
              ,entac_adr_conc_id  
              ,entac_created_by  
              ,entac_created_dt  
              ,entac_lst_upd_by  
              ,entac_lst_upd_dt  
              ,entac_deleted_ind)  
              VALUES  
              (@@l_ent_id  
              ,@pa_acct_no  
              ,@@l_concm_id  
              ,@@l_concm_cd  
              ,@@l_conc_id  
              ,@pa_login_name  
              ,GETDATE()  
              ,@pa_login_name  
              ,GETDATE()  
              ,1
              )   
            --
            END--exts1
            ELSE
            BEGIN--n_exts1
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
              ,@@l_conc_value_new  
              ,@pa_login_name  
              ,GETDATE()  
              ,@pa_login_name  
              ,GETDATE()  
              ,1
              )  
              --                                        
              INSERT INTO entity_adr_conc  
              (entac_ent_id  
              ,entac_acct_no  
              ,entac_concm_id  
              ,entac_concm_cd  
              ,entac_adr_conc_id  
              ,entac_created_by  
              ,entac_created_dt  
              ,entac_lst_upd_by  
              ,entac_lst_upd_dt  
              ,entac_deleted_ind
              )  
              VALUES  
              (@@l_ent_id   
              ,@pa_acct_no  
              ,@@l_concm_id  
              ,@@l_concm_cd  
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
                FROM   conc_code_mstr      WITH(NOLOCK)  
                WHERE  concm_id          = @@l_concm_id  
                AND    concm_deleted_ind = 1  
                --  
                SET @@l_errorstr = @@l_concm_desc+'Could not be Inserted'+@rowdelimiter+@@l_errorstr  
                --  
                ROLLBACK TRANSACTION  
              --  
              END  
              ELSE  
              BEGIN  
              --  
                COMMIT TRANSACTION  
                --  
                UPDATE contact_channels_mak   WITH(ROWLOCK)        
                SET    conc_deleted_ind     = 1  
                     , conc_id              = @@l_conc_id  
                     , conc_lst_upd_by      = @pa_login_name  
                     , conc_lst_upd_dt      = GETDATE()  
                WHERE  conc_deleted_ind     = 0  
                AND    concmak_id           = CONVERT(numeric, @@currstring_id)  
              --  
              END  
            --
            END--n_exts1
          --
          END--#0
          --
          EXEC pr_ins_upd_list @pa_ent_id, 'A','CONTACT CHANNELS', @pa_login_name,'*|~*','|*~|',''
        --
        END--app
        --
        IF @pa_action = 'REJ'  
        BEGIN  
        --  
          UPDATE contact_channels_mak   WITH (ROWLOCK)
          SET    conc_deleted_ind     = 3  
                ,conc_lst_upd_by      = @pa_login_name  
                ,conc_lst_upd_dt      = GETDATE()  
          WHERE  conc_deleted_ind     IN(0,4,8)  
          AND    concmak_id           = CONVERT(numeric, @@currstring_id)  
        --  
        END  
      --
      END--app_ent
      --
      IF @pa_tab  = 'ACCT'
      BEGIN--app_ent
      --
        IF @pa_action = 'APP'  
        BEGIN--app
        --
          print ''
        --
        END--app
      --  
      END--acct   
    --
    END--cur_id
  --
  END--w_id
  --
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
