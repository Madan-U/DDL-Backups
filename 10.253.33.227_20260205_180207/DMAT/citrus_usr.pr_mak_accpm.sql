-- Object: PROCEDURE citrus_usr.pr_mak_accpm
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE [citrus_usr].[pr_mak_accpm] (@pa_id              VARCHAR(8000)
                              ,@pa_action          VARCHAR(20)
                              ,@pa_login_name      VARCHAR(20)
                              ,@pa_accpm_prop_id   INT
                              ,@pa_accpm_prop_cd   VARCHAR(200)
                              ,@pa_accpm_prop_desc VARCHAR(8000)
                              ,@pa_accpm_acct_type VARCHAR(20)
                              ,@pa_accpm_prop_rmks VARCHAR(200)
                              ,@pa_accpm_datatype  VARCHAR(5)
                              ,@pa_values          VARCHAR(8000)
                              ,@pa_chk_yn          INT
                              ,@rowdelimiter       CHAR(4)
                              ,@coldelimiter       CHAR(4)
                              ,@pa_errmsg          VARCHAR(8000) OUTPUT
 )
as
/*
*********************************************************************************
 SYSTEM         : CITRUS
 MODULE NAME    : PR_MAK_ACCPM
 DESCRIPTION    : this procedure will contain the maker checker facility for account_property_mstr
 COPYRIGHT(C)   : MARKETPLACE TECHNOLOGIES PVT. LTD.
 VERSION HISTORY: 
 VERS.  AUTHOR            DATE         REASON
 -----  -------------     ----------   -------------------------------------------------
 1.0    tushar            12-may-2007  
-----------------------------------------------------------------------------------*/
--
begin
--
  set nocount on
  --
  declare @@remainingstring_val VARCHAR(8000)
        , @@currstring_val      VARCHAR(8000)
        , @@foundat_val         INT
        , @@remainingstring_id  VARCHAR(8000)
        , @@currstring_id       VARCHAR(8000)
        , @@foundat_id          INT
        , @@delimeterlength     INT
        , @l_errorstr           VARCHAR(8000)
        , @l_accpm_id           NUMERIC
        , @l_accpmm_id          NUMERIC
        , @l_accpm_prop_id      NUMERIC
        , @l_accpm_prop_id_mak  NUMERIC
        , @l_delimeter          VARCHAR(10)
        , @l_exch_cd            VARCHAR(25)
        , @l_seg_cd             VARCHAR(25)
        , @l_excsm_exch_cd      VARCHAR(25)
        , @l_excsm_seg_cd       VARCHAR(25)
        , @l_prom_desc          VARCHAR(100)
        , @l_prom_id            NUMERIC
        , @l_enttm_id           NUMERIC
        , @l_clicm_id           NUMERIC
        , @l_mnd_flg            SMALLINT
        , @l_excpm_id           NUMERIC
        , @l_error              BIGINT
        , @l_node               CHAR(5)
        , @l_exists             NUMERIC
        , @l_deleted_ind        SMALLINT
   --
  IF @pa_chk_yn = 1
  BEGIN--#table
  --
    IF @pa_action <> 'APP' and @pa_action <> 'REJ'
    BEGIN --actions
    --
      CREATE TABLE #t_accpmm
      (accpm_id          NUMERIC
      ,accpm_prop_id     NUMERIC
      ,accpm_clicm_id    NUMERIC
      ,accpm_enttm_id    NUMERIC
      ,accpm_excpm_id    CHAR (10)
      ,accpm_mdty        SMALLINT
      ,accpm_prop_cd     VARCHAR(20)
      ,accpm_prop_desc   VARCHAR(100)
      ,accpm_acct_type   VARCHAR(20)
      ,accpm_prop_rmks   VARCHAR(250)
      ,accpm_created_by  VARCHAR(25)
      ,accpm_created_dt  DATETIME 
      ,accpm_lst_upd_by  VARCHAR(25)
      ,accpm_lst_upd_dt  DATETIME
      ,accpm_deleted_ind SMALLINT
      ,accpm_datatype    VARCHAR(5) 
      ) 
      --
      INSERT INTO #t_accpmm
      (accpm_id         
      ,accpm_prop_id    
      ,accpm_clicm_id   
      ,accpm_enttm_id   
      ,accpm_excpm_id   
      ,accpm_mdty       
      ,accpm_prop_cd    
      ,accpm_prop_desc  
      ,accpm_acct_type  
      ,accpm_prop_rmks  
      ,accpm_created_by 
      ,accpm_created_dt 
      ,accpm_lst_upd_by 
      ,accpm_lst_upd_dt 
      ,accpm_deleted_ind
      ,accpm_datatype   
      )
      SELECT accpm_id         
           , accpm_prop_id    
           , accpm_clicm_id   
           , accpm_enttm_id   
           , accpm_excpm_id   
           , accpm_mdty       
           , accpm_prop_cd    
           , accpm_prop_desc  
           , accpm_acct_type  
           , accpm_prop_rmks  
           , accpm_created_by 
           , accpm_created_dt 
           , accpm_lst_upd_by 
           , accpm_lst_upd_dt 
           , accpm_deleted_ind
           , accpm_datatype   
      FROM   accpm_mak         WITH(nolock)   
      WHERE  accpm_deleted_ind = 0
      AND    accpm_prop_id     = @pa_accpm_prop_id     
      --
      create table #t_entpm
      (accpm_id          NUMERIC
      ,accpm_prop_id     NUMERIC
      ,accpm_clicm_id    NUMERIC
      ,accpm_enttm_id    NUMERIC
      ,accpm_excpm_id    CHAR (10)
      ,accpm_mdty        SMALLINT
      ,accpm_prop_cd     VARCHAR(20)
      ,accpm_prop_desc   VARCHAR(100)
      ,accpm_acct_type   VARCHAR(20)
      ,accpm_prop_rmks   VARCHAR(250)
      ,accpm_created_by  VARCHAR(25)
      ,accpm_created_dt  DATETIME 
      ,accpm_lst_upd_by  VARCHAR(25)
      ,accpm_lst_upd_dt  DATETIME
      ,accpm_deleted_ind SMALLINT
      ,accpm_datatype    VARCHAR(5) 
      )
      --
      INSERT INTO #t_entpm
      (accpm_id         
      ,accpm_prop_id    
      ,accpm_clicm_id   
      ,accpm_enttm_id   
      ,accpm_excpm_id   
      ,accpm_mdty       
      ,accpm_prop_cd    
      ,accpm_prop_desc  
      ,accpm_acct_type  
      ,accpm_prop_rmks  
      ,accpm_created_by 
      ,accpm_created_dt 
      ,accpm_lst_upd_by 
      ,accpm_lst_upd_dt 
      ,accpm_deleted_ind
      ,accpm_datatype   
      )
      SELECT accpm_id         
           , accpm_prop_id    
           , accpm_clicm_id   
           , accpm_enttm_id   
           , accpm_excpm_id   
           , accpm_mdty       
           , accpm_prop_cd    
           , accpm_prop_desc  
           , accpm_acct_type  
           , accpm_prop_rmks  
           , accpm_created_by 
           , accpm_created_dt 
           , accpm_lst_upd_by 
           , accpm_lst_upd_dt 
           , accpm_deleted_ind
           , accpm_datatype   
      FROM   account_property_mstr WITH(nolock)
      WHERE  accpm_deleted_ind     = 1
      AND    accpm_prop_id         = @pa_accpm_prop_id
    --  
    END--actions  
  --
  END--#table
  --
  SET @l_error             = 0
  SET @l_errorstr          = ''
  SET @l_delimeter         = '%'+ @rowdelimiter + '%'
  SET @@delimeterlength    = len(@rowdelimiter)
  SET @@remainingstring_id = @pa_id
  SET @l_accpm_prop_id     = 0
  --
  WHILE @@remainingstring_id <> ''
  BEGIN--rvid
  --
    SET @@foundat_id  = 0
    SET @@foundat_id  = patindex('%'+@l_delimeter+'%', @@remainingstring_id)
    --
    IF @@foundat_id > 0
    BEGIN
    --
     SET @@currstring_id      = substring(@@remainingstring_id, 0, @@foundat_id)
     SET @@remainingstring_id = substring(@@remainingstring_id, @@foundat_id+@@delimeterlength, len(@@remainingstring_id)- @@foundat_id+@@delimeterlength)
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
    BEGIN--cid
    --
      IF @pa_chk_yn = 0
      BEGIN--chk0
      --
        IF @pa_action = 'EDTMSTR'
        BEGIN--edtmstr0
        --
          BEGIN TRANSACTION
          --
          UPDATE account_property_mstr WITH(rowlock)
          SET    accpm_prop_cd     = @pa_accpm_prop_cd
               , accpm_prop_desc   = @pa_accpm_prop_desc
               , accpm_prop_rmks   = @pa_accpm_prop_rmks
               , accpm_datatype    = @pa_accpm_datatype
               , accpm_acct_type   = @pa_accpm_acct_type
          WHERE  accpm_prop_id     = @pa_accpm_prop_id
          AND    accpm_deleted_ind = 1
          --
          SET @l_error = @@error
          --
          IF @l_error > 0
          BEGIN
          --
            ROLLBACK TRANSACTION
            --
            SET @l_errorstr = convert(VARCHAR, @l_error)+@rowdelimiter
          --
          END
          ELSE
          BEGIN
          --
            COMMIT TRANSACTION
          --
          END
        --
        END--edtmstr0
        ELSE IF @pa_action = 'DELMSTR'
        BEGIN--delmstr0
        --
          BEGIN TRANSACTION
          --
          UPDATE account_property_mstr WITH(rowlock)
          SET    accpm_deleted_ind  = 0
               , accpm_lst_upd_by   = @pa_login_name
               , accpm_lst_upd_dt   = getdate()
          WHERE  accpm_prop_id      = convert(numeric, @@currstring_id)
          AND    accpm_deleted_ind  = 1
          --
          SET @l_error = @@error
          --
          IF @l_error > 0
          BEGIN
          --
            ROLLBACK TRANSACTION
            --
            SET @l_errorstr = convert(VARCHAR, @l_error)+@rowdelimiter
          --
          END
          ELSE
          BEGIN
          --
            COMMIT TRANSACTION
          --
          END
        --
        END--delmstr0
        ELSE IF ISNULL(RTRIM(LTRIM(@pa_action)),'') = ''
        BEGIN--isnull0
        --
          SET @@remainingstring_val = @pa_values
          --
          WHILE @@remainingstring_val <> ''
          BEGIN--rv2
          --
            SET @@foundat_val  = 0
            SET @@foundat_val  =  patindex('%'+@l_delimeter+'%', @@remainingstring_val)
            --
            IF @@foundat_val > 0
            BEGIN
            --
              SET @@currstring_val      = substring(@@remainingstring_val, 0, @@foundat_val)
              SET @@remainingstring_val = substring(@@remainingstring_val, @@foundat_val+@@delimeterlength, len(@@remainingstring_val)- @@foundat_val+@@delimeterlength)
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
            BEGIN--cid2
            --
              SET @l_exch_cd  = citrus_usr.fn_splitval(@@currstring_val,1)
              SET @l_seg_cd   = citrus_usr.fn_splitval(@@currstring_val,2)
              SET @l_prom_id  = convert(numeric, citrus_usr.fn_splitval(@@currstring_val,3))
              SET @l_enttm_id = citrus_usr.fn_splitval(@@currstring_val,4)
              SET @l_clicm_id = citrus_usr.fn_splitval(@@currstring_val,5)
              SET @l_node     = citrus_usr.fn_splitval(@@currstring_val,6)
              SET @l_mnd_flg  = case citrus_usr.fn_splitval(@@currstring_val,7) when 'm' then 1 when 'n'then 0 else 2 end
              --
              SELECt top 1 @l_excpm_id     = excpm.excpm_id
              FROM  exch_seg_mstr excsm    WITH(nolock)
                  , excsm_prod_mstr excpm  WITH(nolock)
              WHERE excpm.excpm_excsm_id   = excsm.excsm_id
              AND   excsm.excsm_exch_cd    = @l_exch_cd
              AND   excsm.excsm_seg_cd     = @l_seg_cd
              AND   excpm.excpm_prom_id    = @l_prom_id
              AND   excsm_deleted_ind      = 1
              AND   excpm_deleted_ind      = 1
              --
              IF @l_mnd_flg = 1 OR @l_mnd_flg = 0
              BEGIN--flg=1/0
              --
                IF ISNULL(@pa_accpm_prop_cd,'') <> ''
                BEGIN--cd
                --
                  SELECT @l_accpm_prop_id      = ISNULL(accpmm.accpm_prop_id,0)
                  FROM   accpm_mak               accpmm WITH(nolock)
                  WHERE  accpmm.accpm_prop_cd  = @pa_accpm_prop_cd
                  AND    accpmm.accpm_deleted_ind IN (1,0)
                  --
                  IF @l_accpm_prop_id = 0
                  BEGIN--#111
                  --
                    SELECT @l_accpm_prop_id     = ISNULL(MAX(accpm.accpm_prop_id), 0)
                    FROM   account_property_mstr  accpm WITH(nolock)
                    WHERE  accpm.accpm_prop_cd  = @pa_accpm_prop_cd
                    AND    accpm.accpm_deleted_ind IN (0,1)
                  --
                  end--#111
                  --
                  IF @l_accpm_prop_id = 0
                  BEGIN--#222
                  --
                    SELECT @l_accpm_prop_id_mak = ISNULL(MAX(accpmm.accpm_prop_id), 0) + 1
                    FROM   accpm_mak  accpmm WITH(nolock)
                    --
                    SELECT @l_accpm_prop_id = ISNULL(MAX(accpm.accpm_prop_id), 0) + 1
                    FROM   account_property_mstr  accpm  WITH(nolock)
                    --
                    IF @l_accpm_prop_id_mak > @l_accpm_prop_id
                    BEGIN
                    --
                      SET @l_accpm_prop_id = @l_accpm_prop_id_mak
                    --
                    END                               
                    --
                  END--#222
                  --
                  IF EXISTS(SELECT * FROM account_property_mstr accpm WITH (nolock)
                            WHERE accpm.accpm_prop_id     = @l_accpm_prop_id
                            AND   accpm.accpm_clicm_id    = @l_clicm_id
                            AND   accpm.accpm_enttm_id    = @l_enttm_id
                            AND   accpm.accpm_excpm_id    = @l_excpm_id
                            AND   accpm.accpm_deleted_ind = 1
                            )
                  BEGIN--a
                  --
                    SET @l_exists = 1
                  --
                  END--A
                  ELSE
                  BEGIN--b
                  --
                    SET @l_exists = 0
                  --
                  END--B
                  --
                  IF @l_exists = 0
                  BEGIN--#0
                  --
                    SELECT @l_accpm_id = ISNULL(MAX(accpm_id),0)+1
                    FROM account_property_mstr WITH(nolock)
                    --
                    BEGIN TRANSACTION
                    --
                    INSERT INTO account_property_mstr
                    (accpm_id
                    ,accpm_prop_id
                    ,accpm_clicm_id
                    ,accpm_enttm_id
                    ,accpm_excpm_id
                    ,accpm_prop_cd
                    ,accpm_prop_desc
                    ,accpm_prop_rmks
                    ,accpm_acct_type
                    ,accpm_created_by
                    ,accpm_created_dt
                    ,accpm_lst_upd_by
                    ,accpm_lst_upd_dt
                    ,accpm_deleted_ind
                    ,accpm_mdty
                    ,accpm_datatype
                    )
                    VALUES
                    (@l_accpm_id
                    ,@l_accpm_prop_id
                    ,@l_clicm_id
                    ,@l_enttm_id
                    ,@l_excpm_id
                    ,@pa_accpm_prop_cd
                    ,@pa_accpm_prop_desc
                    ,@pa_accpm_prop_rmks
                    ,@pa_accpm_acct_type
                    ,@pa_login_name
                    ,getdate()
                    ,@pa_login_name
                    ,getdate()
                    ,1
                    ,@l_mnd_flg
                    ,@pa_accpm_datatype
                    )
                    --
                    SET @l_error = @@error
                    --
                    IF @l_error > 0
                    BEGIN
                    --
                      ROLLBACK TRANSACTION
                    --
                      SET @l_errorstr = convert(VARCHAR, @l_error)+@rowdelimiter
                    --
                    END
                    ELSE
                    BEGIN
                    --
                      COMMIT TRANSACTION
                    --
                    END
                  --
                  END --#0
                  IF @l_exists = 1
                  BEGIN--#1
                  --
                    BEGIN TRANSACTION
                    --
                    UPDATE account_property_mstr WITH(rowlock)
                    SET    accpm_prop_cd       = UPPER(@pa_accpm_prop_cd)
                         , accpm_prop_desc     = @pa_accpm_prop_desc
                         , accpm_prop_rmks     = @pa_accpm_prop_rmks
                         , accpm_acct_type     = @pa_accpm_acct_type
                         , accpm_mdty          = @l_mnd_flg
                         , accpm_datatype      = @pa_accpm_datatype
                         , accpm_lst_upd_by    = @pa_login_name
                         , accpm_lst_upd_dt    = getdate()
                         , accpm_deleted_ind   = 1
                    WHERE  accpm_prop_id       = @pa_accpm_prop_id
                    AND    accpm_clicm_id      = @l_clicm_id
                    AND    accpm_enttm_id      = @l_enttm_id
                    AND    accpm_excpm_id      = @l_excpm_id
                    AND    accpm_deleted_ind   = 1
                    --
                    SET @l_error = @@error
                    --
                    IF @l_error > 0
                    BEGIN
                    --
                      ROLLBACK TRANSACTION
                    --
                      SET @l_errorstr = CONVERT(VARCHAR, @l_error)+@rowdelimiter
                    END
                    ELSE
                    BEGIN
                    --
                      COMMIT TRANSACTION
                    --
                    END
                  --
                  END--#1
                --
                END --CD
                ELSE
                BEGIN
                --
                  SET @l_errorstr = 'one or all of the parameters is/are null'
                --
                END
              --
              END--FLG=1/0
              ELSE IF @l_mnd_flg=2
              BEGIN--Flg=2
              --
                /*if exists(select *
                          from  entity_property_mstr   entpm
                          where entpm.entpm_prop_id     = @pa_entpm_prop_id
                          and   entpm.entpm_clicm_id    = @l_clicm_id
                          and   entpm.entpm_enttm_id    = @l_enttm_id
                          and   entpm.entpm_excpm_id    = @l_excpm_id
                          and   entpm.entpm_deleted_ind = 1)
                begin--exists*/
                --
                  BEGIN TRANSACTION
                  --
                  UPDATE account_property_mstr  with(rowlock)
                  SET    accpm_deleted_ind  = 0
                       , accpm_lst_upd_by   = @pa_login_name
                       , accpm_lst_upd_dt   = getdate()
                  WHERE  accpm_prop_id      = @pa_accpm_prop_id
                  AND    accpm_clicm_id     = @l_clicm_id
                  AND    accpm_enttm_id     = @l_enttm_id
                  AND    accpm_excpm_id     = @l_excpm_id
                  AND    accpm_deleted_ind  = 1
                  --
                  SET @l_error = @@error
                  --
                  IF @l_error > 0
                  BEGIN
                  --
                    ROLLBACK TRANSACTION
                  --
                    SET @l_errorstr = CONVERT(VARCHAR, @l_error)+@rowdelimiter
                  --
                  END
                  ELSE
                  BEGIN
                  --
                    COMMIT TRANSACTION
                  --
                  END
                --
                /*end--exists
                else
                begin--notexists
                --
                  set @l_errorstr = 'one or all of the parameters is/are null'
                --
                end--notexists*/
              --
              END--FLG=2
            --
            END--CID2
          --
          END--RV2
        --
        END--ISNULL0
      --
      END--CHK=0
      ELSE IF @pa_chk_yn = 1
      BEGIN--CHK=1
      ----
        IF @pa_action = 'EDTMSTR'
        BEGIN--edtmstr
        --
          BEGIN TRANSACTION
          --
          UPDATE accpm_mak  WITH (rowlock)
          SET    accpm_deleted_ind = 2
               , accpm_lst_upd_by  = @pa_login_name
               , accpm_lst_upd_dt  = getdate()
          WHERE  accpm_prop_id     = @pa_accpm_prop_id
          AND    accpm_deleted_ind = 0
          --
          UPDATE #t_accpmm
          SET    accpm_prop_cd  = @pa_accpm_prop_cd
               , accpm_prop_desc= @pa_accpm_prop_desc
               , accpm_prop_rmks= @pa_accpm_prop_rmks
               , accpm_datatype = @pa_accpm_datatype
          WHERE  accpm_prop_id  = @pa_accpm_prop_id
          --
          INSERT INTO accpm_mak
          (accpm_id         
          ,accpm_prop_id    
          ,accpm_clicm_id   
          ,accpm_enttm_id   
          ,accpm_excpm_id   
          ,accpm_mdty       
          ,accpm_prop_cd    
          ,accpm_prop_desc  
          ,accpm_acct_type  
          ,accpm_prop_rmks  
          ,accpm_created_by 
          ,accpm_created_dt 
          ,accpm_lst_upd_by 
          ,accpm_lst_upd_dt 
          ,accpm_deleted_ind
          ,accpm_datatype   
          )
          SELECT accpm_id         
                ,accpm_prop_id    
                ,accpm_clicm_id   
                ,accpm_enttm_id   
                ,accpm_excpm_id   
                ,accpm_mdty       
                ,accpm_prop_cd    
                ,accpm_prop_desc  
                ,accpm_acct_type  
                ,accpm_prop_rmks  
                ,accpm_created_by 
                ,accpm_created_dt 
                ,accpm_lst_upd_by 
                ,accpm_lst_upd_dt 
                ,accpm_deleted_ind
                ,accpm_datatype   
          FROM   #t_accpmm
          WHERE  accpm_prop_id = @pa_accpm_prop_id
          --
          SET @l_error = @@error
          --
          IF @l_error> 0
          BEGIN
          --
            ROLLBACK TRANSACTION
            --
            SET @l_errorstr = CONVERT(VARCHAR, @l_error)+@rowdelimiter
          --
          END
          ELSE
          BEGIN
          --
            COMMIT TRANSACTION
          --
          END
        --
        END--EDTMSTR
        ELSE IF @pa_action = 'DELMSTR'
        begin--delmstr1
        --
          BEGIN TRANSACTION
          --
          UPDATE #t_accpm
          SET    accpm_deleted_ind = 4
          WHERE  accpm_id          = convert(numeric, @@currstring_id)
          AND    accpm_deleted_ind = 1
          --
          INSERT INTO accpm_mak
          (accpm_id         
          ,accpm_prop_id    
          ,accpm_clicm_id   
          ,accpm_enttm_id   
          ,accpm_excpm_id   
          ,accpm_mdty       
          ,accpm_prop_cd    
          ,accpm_prop_desc  
          ,accpm_acct_type  
          ,accpm_prop_rmks  
          ,accpm_created_by 
          ,accpm_created_dt 
          ,accpm_lst_upd_by 
          ,accpm_lst_upd_dt 
          ,accpm_deleted_ind
          ,accpm_datatype   
          )
          SELECT accpm_id         
                ,accpm_prop_id    
                ,accpm_clicm_id   
                ,accpm_enttm_id   
                ,accpm_excpm_id   
                ,accpm_mdty       
                ,accpm_prop_cd    
                ,accpm_prop_desc  
                ,accpm_acct_type  
                ,accpm_prop_rmks  
                ,accpm_created_by 
                ,accpm_created_dt 
                ,accpm_lst_upd_by 
                ,accpm_lst_upd_dt 
                ,accpm_deleted_ind
                ,accpm_datatype   
          FROM   #t_accpmm   
          WHERE  accpm_prop_id     = convert(numeric, @@currstring_id)
          --
          SET @l_error = @@error
          --
          IF @l_error> 0
          BEGIN
          --
            ROLLBACK TRANSACTION
            --
            SET @l_errorstr = CONVERT(VARCHAR, @l_error)+@rowdelimiter
          --
          END
          ELSE
          BEGIN
          --
            COMMIT TRANSACTION
          --
          END
        --
        END--delmstr1
        ELSE IF @pa_action = 'REJ'
        BEGIN--rej
        --
          BEGIN TRANSACTION
          --
          UPDATE accpm_mak  WITH (rowlock)
          SET    accpm_deleted_ind = 3
               , accpm_lst_upd_by  = @pa_login_name
               , accpm_lst_upd_dt  = getdate()
          WHERE  accpm_id          = convert(numeric, @@currstring_id)
          AND    accpm_deleted_ind IN (0,4,6)
          --
          SET @l_error = @@error
          --
          IF @l_error > 0
          BEGIN
          --
            ROLLBACK TRANSACTION
            --
            SET @l_errorstr = CONVERT(VARCHAR, @l_error)+@rowdelimiter
          --
          END
          ELSE
          BEGIN
          --
            COMMIT TRANSACTION
          --
          END
        --
        END--REJ
        ELSE IF @pa_action = 'APP'
        BEGIN--app
        --
          SELECT @l_deleted_ind = accpm_deleted_ind
          FROM   accpm_mak with(nolock)
          WHERE  accpm_id        = convert(numeric, @@currstring_id)
          --
          IF @l_deleted_ind = 4
          BEGIN--ind=4
          --
            BEGIN TRANSACTION
            --
            UPDATE accpm_mak  with(rowlock)
            SET    accpm_deleted_ind  = 5
                 , accpm_lst_upd_by   = @pa_login_name
                 , accpm_lst_upd_dt   = getdate()
            WHERE  accpm_id           = convert(numeric, @@currstring_id)
            AND    accpm_deleted_ind  = 4
            --
            SET @l_error = @@error
            --
            IF @l_error > 0
            BEGIN--rins
            --
              SET @l_errorstr = @coldelimiter + CONVERT(VARCHAR, @l_error)+@rowdelimiter
              --
              ROLLBACK TRANSACTION
              --
              RETURN
            --
            END--RINS
            --
            UPDATE account_property_mstr   with(rowlock)
            SET    accpm_deleted_ind  = 0
                 , accpm_lst_upd_by   = @pa_login_name
                 , accpm_lst_upd_dt   = getdate()
            WHERE  accpm_id           = convert(numeric, @@currstring_id)
            AND    accpm_deleted_ind  = 1
            --
            SET @l_error = @@error
            --
            IF @l_error > 0
            BEGIN--rins
            --
              SET @l_errorstr = @coldelimiter + convert(varchar, @l_error)+@rowdelimiter
              --
              ROLLBACK TRANSACTION
              --
              RETURN
            --
            END--RINS
            --
            COMMIT TRANSACTION
            --
          END--IND=4
          ELSE IF @l_deleted_ind = 6
          BEGIN--ind=6
          --
            BEGIN TRANSACTION
            --
            UPDATE accpm_mak with(rowlock)
            SET    accpm_deleted_ind  = 7
                 , accpm_lst_upd_by   = @pa_login_name
                 , accpm_lst_upd_dt   = getdate()
            WHERE  accpm_id           = convert(numeric, @@currstring_id)
            AND    accpm_deleted_ind  = 6
            --
            /*UPDATE account_property_mstr  with(rowlock)
            SET    accpm_deleted_ind  = 0
                 , accpm_lst_upd_by   = @pa_login_name
                 , accpm_lst_upd_dt   = getdate()
            WHERE  accpm_prop_id      = @pa_accpm_prop_id
            AND    entpm_deleted_ind  = 1*/
            
            
            UPDATE accpm with(rowlock)
            SET    accpm.accpm_prop_id        = accpmm.accpm_prop_id
                 , accpm.accpm_prop_cd        = accpmm.accpm_prop_cd
                 , accpm.accpm_prop_desc      = accpmm.accpm_prop_desc
                 , accpm.accpm_prop_rmks      = accpmm.accpm_prop_rmks
                 , accpm.accpm_mdty           = accpmm.accpm_mdty
                 , accpm.accpm_datatype       = accpmm.accpm_datatype
                 , accpm.accpm_lst_upd_by     = @pa_login_name
                 , accpm.accpm_lst_upd_dt     = getdate()
                 , accpm.accpm_deleted_ind    = 1
            FROM   account_property_mstr      accpm
                 , accpm_mak   accpmm
            WHERE  accpm.accpm_id             = convert(numeric, @@currstring_id)
            AND    accpm.accpm_deleted_ind    = 1
            AND    accpmm.accpm_deleted_ind   = 0
            --AND    accpmm.accpm_created_by   <> @pa_login_name
            
            
            --
            SET @l_error = @@error
            --
            IF @l_error > 0
            BEGIN--rins
            --
              SET @l_errorstr = @coldelimiter + CONVERT(VARCHAR, @l_error)+@rowdelimiter
              --
              ROLLBACK TRANSACTION
              --
              RETURN
            --
            END--RINS
            --
            COMMIT TRANSACTION
          --
          END--IND=6 
          --
          ELSE
          BEGIN
          --
            IF EXISTS(SELECT accpm_id
                      FROM   account_property_mstr  with(nolock)
                      WHERE  accpm_id=convert(numeric, @@currstring_id))
            BEGIN--#EXIST
            --
              BEGIN TRANSACTION
              --
                UPDATE accpm with(rowlock)
                SET    accpm.accpm_prop_id        = accpmm.accpm_prop_id
                     , accpm.accpm_prop_cd        = accpmm.accpm_prop_cd
                     , accpm.accpm_prop_desc      = accpmm.accpm_prop_desc
                     , accpm.accpm_prop_rmks      = accpmm.accpm_prop_rmks
                     , accpm.accpm_mdty           = accpmm.accpm_mdty
                     , accpm.accpm_datatype       = accpmm.accpm_datatype
                     , accpm.accpm_lst_upd_by     = @pa_login_name
                     , accpm.accpm_lst_upd_dt     = getdate()
                     , accpm.accpm_deleted_ind    = 1
                FROM   account_property_mstr      accpm
                     , accpm_mak   accpmm
                WHERE  accpm.accpm_id             = convert(numeric, @@currstring_id)
                AND    accpm.accpm_deleted_ind    = 1
                AND    accpmm.accpm_deleted_ind   = 0
                --AND    entpmm.entpm_created_by   <> @pa_login_name
              --
              UPDATE accpm_mak  with(rowlock)
              SET    accpm_deleted_ind          = 1
                   , accpm_lst_upd_by           = @pa_login_name
                   , accpm_lst_upd_dt           = getdate()
              WHERE  accpm_id                   = convert(int, @@currstring_id)
              AND    accpm_created_by          <> @pa_login_name
              AND    accpm_deleted_ind          = 0
              --
              SET @l_error = @@error
              --
              IF @l_error > 0
              BEGIN
              --
                ROLLBACK TRANSACTION
              --
                SET @l_errorstr = CONVERT(VARCHAR, @l_error)+@rowdelimiter
              --
              END
              ELSE
              BEGIN
              --
                COMMIT TRANSACTION
              --
              END
            --
            END--#EXIST
            ELSE
            BEGIN--NOTEXIST
            --
              BEGIN TRANSACTION
              --
              INSERT INTO account_property_mstr
              (accpm_id         
              ,accpm_prop_id    
              ,accpm_clicm_id   
              ,accpm_enttm_id   
              ,accpm_excpm_id   
              ,accpm_mdty       
              ,accpm_prop_cd    
              ,accpm_prop_desc  
              ,accpm_acct_type  
              ,accpm_prop_rmks  
              ,accpm_created_by 
              ,accpm_created_dt 
              ,accpm_lst_upd_by 
              ,accpm_lst_upd_dt 
              ,accpm_deleted_ind
              ,accpm_datatype   
              )
              SELECT accpm_id         
                    ,accpm_prop_id    
                    ,accpm_clicm_id   
                    ,accpm_enttm_id   
                    ,accpm_excpm_id   
                    ,accpm_mdty       
                    ,accpm_prop_cd    
                    ,accpm_prop_desc  
                    ,accpm_acct_type  
                    ,accpm_prop_rmks  
                    ,accpm_created_by 
                    ,accpm_created_dt 
                    ,accpm_lst_upd_by 
                    ,accpm_lst_upd_dt 
                    ,1
                    ,accpm_datatype   
               FROM  accpm_mak                accpmm  with(nolock)
               WHERE accpmm.accpm_id          = convert(int, @@currstring_id)
               AND   accpmm.accpm_created_by <> @pa_login_name
               AND   accpmm.accpm_deleted_ind = 0
               --
               UPDATE accpm_mak  with(rowlock)
               SET    accpm_deleted_ind       = 1
                    , accpm_lst_upd_by        = @pa_login_name
                    , accpm_lst_upd_dt        = getdate()
               WHERE  accpm_id = convert(int,@@currstring_id)
               AND    accpm_created_by       <> @pa_login_name
               AND    accpm_deleted_ind       = 0
               --
               SET @l_error = @@error
               --
               IF @l_error > 0
               BEGIN --#1
               --
                 ROLLBACK TRANSACTION
                 --
                 SET @l_errorstr = CONVERT(VARCHAR, @l_error)+@rowdelimiter
               --
               END   --#1
               ELSE
               BEGIN--#2
               --
                 COMMIT TRANSACTION
               --
               END  --#2
            --
            END--NOTEXIST
          --
          END
        --
        END --App
        ELSE IF ISNULL(rtrim(ltrim(@pa_action)),'') = ''
        BEGIN--null
        --
          SET @@remainingstring_val = @pa_values
          --
          WHILE @@remainingstring_val <> ''
          BEGIN--rv3
          --
            SET @@foundat_val  = 0
            SET @@foundat_val  =  patindex('%'+@l_delimeter+'%', @@remainingstring_val)
            --
            IF @@foundat_val > 0
            BEGIN
            --
              SET @@currstring_val      = substring(@@remainingstring_val, 0, @@foundat_val)
              SET @@remainingstring_val = substring(@@remainingstring_val, @@foundat_val+@@delimeterlength, len(@@remainingstring_val)-@@foundat_val+@@delimeterlength)
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
            BEGIN--cv3
            --
              SET @l_exch_cd  = citrus_usr.fn_splitval(@@currstring_val,1)
              SET @l_seg_cd   = citrus_usr.fn_splitval(@@currstring_val,2)
              SET @l_prom_id  = convert(numeric, citrus_usr.fn_splitval(@@currstring_val,3))
              SET @l_enttm_id = citrus_usr.fn_splitval(@@currstring_val,4)
              SET @l_clicm_id = citrus_usr.fn_splitval(@@currstring_val,5)
              SET @l_node     = citrus_usr.fn_splitval(@@currstring_val,6)
              SET @l_mnd_flg  = case citrus_usr.fn_splitval(@@currstring_val,7) when 'm' then 1 when 'n' then 0 else 2 end
              --
              SELECT top 1 @l_excpm_id        = excpm.excpm_id
              FROM   exch_seg_mstr excsm   with(nolock)
                 ,   excsm_prod_mstr excpm with(nolock)
              WHERE  excpm.excpm_excsm_id     = excsm.excsm_id
              AND    excsm.excsm_exch_cd      = @l_exch_cd
              AND    excsm.excsm_seg_cd       = @l_seg_cd
              AND    excpm.excpm_prom_id      = @l_prom_id
              --
              IF @l_mnd_flg = 1 or @l_mnd_flg = 0
              BEGIN--flg1/0
              --
                 IF isnull(@pa_accpm_prop_cd,'') <> ''
                 BEGIN--cd
                 --
                   SELECT @l_accpm_prop_id      = isnull(accpmm.accpm_prop_id,0)
                   FROM   accpm_mak             accpmm with(nolock)
                   WHERE  accpmm.accpm_prop_cd  = @pa_accpm_prop_cd
                   AND    accpmm.accpm_deleted_ind in (1,0)
                   --
                   IF @l_accpm_prop_id=0
                   BEGIN
                   --
                     SELECT @l_accpm_prop_id         = isnull(max(accpm.accpm_prop_id), 0)
                     FROM   account_property_mstr      accpm  with(nolock)
                     WHERE  accpm.accpm_prop_cd      = @pa_accpm_prop_cd
                     AND    accpm.accpm_deleted_ind in (0,1);
                   --
                   END
                   --
                   IF @l_accpm_prop_id = 0
                   BEGIN--prop_id = 0
                   --
                     SELECT @l_accpm_prop_id_mak = isnull(max(accpmm.accpm_prop_id), 0) + 1
                     FROM   accpm_mak    accpmm  with(nolock)
                     --
                     SELECT @l_accpm_prop_id = isnull(max(accpm.accpm_prop_id), 0) + 1
                     FROM   account_property_mstr  accpm  with(nolock)
                     --
                     IF @l_accpm_prop_id_mak > @l_accpm_prop_id
                     BEGIN--001
                     --
                       SET @l_accpm_prop_id = @l_accpm_prop_id_mak
                     --
                     END--001
                   --
                   END--prop_id = 0
                   --
                   IF EXISTS(SELECT * FROM accpm_mak  accpmm  with(nolock)
                             WHERE  accpmm.accpm_prop_id    = @l_accpm_prop_id
                             AND    accpmm.accpm_clicm_id    = @l_clicm_id
                             AND    accpmm.accpm_enttm_id    = @l_enttm_id
                             AND    accpmm.accpm_excpm_id    = @l_excpm_id
                             AND    accpmm.accpm_deleted_ind = 0)
                   BEGIN--#1
                   --
                     SET @l_exists = 1
                   --
                   END--#1
                   ELSE
                   BEGIN--#0
                   --
                     SET @l_exists = 0
                   --
                   END--#0
                   --
                   IF @l_exists = 0
                   BEGIN--@l_exists=0
                   --
                     BEGIN TRANSACTION
                     --
                     SELECT @l_accpmm_id = isnull(max(accpm_id),0)+1
                     FROM   accpm_mak  with(nolock)

                     SELECT @l_accpm_id  = isnull(max(accpm_id),0)+1
                     FROM   account_property_mstr   with(nolock)

                     IF @l_accpmm_id > @l_accpm_id
                     BEGIN
                     --
                       SET @l_accpm_id = @l_accpmm_id
                     --
                     END
                     --
                     INSERT INTO accpm_mak
                     (accpm_id         
                     ,accpm_prop_id    
                     ,accpm_clicm_id   
                     ,accpm_enttm_id   
                     ,accpm_excpm_id   
                     ,accpm_mdty       
                     ,accpm_prop_cd    
                     ,accpm_prop_desc  
                     ,accpm_acct_type  
                     ,accpm_prop_rmks  
                     ,accpm_created_by 
                     ,accpm_created_dt 
                     ,accpm_lst_upd_by 
                     ,accpm_lst_upd_dt 
                     ,accpm_deleted_ind
                     ,accpm_datatype   
                      )
                      VALUES
                     (@l_accpm_id
                     ,@l_accpm_prop_id
                     ,@l_clicm_id
                     ,@l_enttm_id
                     ,@l_excpm_id
                     ,@l_mnd_flg
                     ,@pa_accpm_prop_cd
                     ,@pa_accpm_prop_desc
                     ,@pa_accpm_acct_type
                     ,@pa_accpm_prop_rmks
                     ,@pa_login_name
                     ,getdate()
                     ,@pa_login_name
                     ,getdate()
                     ,0
                     ,@pa_accpm_datatype
                     )
                     --
                     SET @l_error = @@error
                     --
                     IF @l_error > 0
                     BEGIN
                     --
                       ROLLBACK TRANSACTION
                       --
                       SET @l_errorstr = CONVERT(VARCHAR, @l_error)+@rowdelimiter
                     --
                     END
                     ELSE
                     BEGIN
                     --
                       COMMIT TRANSACTION
                     --
                     END
                   --
                   END--@l_exists=0
                   IF @l_exists=1
                   BEGIN--@l_exists=1
                   --
                     BEGIN TRANSACTION
                     --
                     UPDATE accpm_mak  with (rowlock)
                     SET    accpm_deleted_ind = 2
                          , accpm_lst_upd_by  = @pa_login_name
                          , accpm_lst_upd_dt  = getdate()
                     WHERE  accpm_prop_id    = @l_accpm_prop_id
																					AND    accpm_clicm_id    = @l_clicm_id
																					AND    accpm_enttm_id    = @l_enttm_id
																					AND    accpm_excpm_id    = @l_excpm_id
                     AND    accpm_deleted_ind = 0
                     --
                     SELECT @l_accpm_id      = isnull(max(accpm_id),0)+1
                     FROM   accpm_mak        with(nolock)
                     --
                     INSERT INTO accpm_mak
                     (accpm_id         
                     ,accpm_prop_id    
                     ,accpm_clicm_id   
                     ,accpm_enttm_id   
                     ,accpm_excpm_id   
                     ,accpm_mdty       
                     ,accpm_prop_cd    
                     ,accpm_prop_desc  
                     ,accpm_acct_type  
                     ,accpm_prop_rmks  
                     ,accpm_created_by 
                     ,accpm_created_dt 
                     ,accpm_lst_upd_by 
                     ,accpm_lst_upd_dt 
                     ,accpm_deleted_ind
                     ,accpm_datatype   
                      )
                      VALUES
                     (@l_accpm_id
                     ,@l_accpm_prop_id
                     ,@l_clicm_id
                     ,@l_enttm_id
                     ,@l_excpm_id
                     ,@l_mnd_flg
                     ,@pa_accpm_prop_cd
                     ,@pa_accpm_prop_desc
                     ,@pa_accpm_acct_type
                     ,@pa_accpm_prop_rmks
                     ,@pa_login_name
                     ,getdate()
                     ,@pa_login_name
                     ,getdate()
                     ,0
                     ,@pa_accpm_datatype
                     )
                     --
                     SET @l_error = @@error
                     --
                     IF @l_error > 0
                     BEGIN
                     --
                       ROLLBACK TRANSACTION
                       --
                       SET @l_errorstr = CONVERT(VARCHAR, @l_error)+@rowdelimiter
                     --
                     END
                     ELSE
                     BEGIN
                     --
                       COMMIT TRANSACTION
                     --
                     END
                   --
                   END----@L_EXISTS=1
                 --
                 END--CD
                 ELSE
                 BEGIN--NO_CD
                 --
                   SET @l_errorstr = 'one or all of the parameters is/are null'
                 --
                 END--no_cd
              --
              END--FLg1/0
              ELSE IF @l_mnd_flg = 2
              BEGIN--flg/2
              --
                BEGIN TRANSACTION
                --
                SELECT @l_accpm_id             = isnull(accpm_id,0) 
                FROM   account_property_mstr     accpm  with(nolock)
                WHERE  accpm.accpm_prop_id     = @pa_accpm_prop_id
                AND    accpm.accpm_clicm_id    = @l_clicm_id
                AND    accpm.accpm_enttm_id    = @l_enttm_id
                AND    accpm.accpm_excpm_id    = @l_excpm_id
                AND    accpm.accpm_deleted_ind = 1
                --
                IF @l_accpm_id  <> 0
                BEGIN --<>0
                --
                  INSERT INTO accpm_mak
                  (accpm_id         
                  ,accpm_prop_id    
                  ,accpm_clicm_id   
                  ,accpm_enttm_id   
                  ,accpm_excpm_id   
                  ,accpm_mdty       
                  ,accpm_prop_cd    
                  ,accpm_prop_desc  
                  ,accpm_acct_type  
                  ,accpm_prop_rmks  
                  ,accpm_created_by 
                  ,accpm_created_dt 
                  ,accpm_lst_upd_by 
                  ,accpm_lst_upd_dt 
                  ,accpm_deleted_ind
                  ,accpm_datatype   
                  )
                  VALUES
                  ( @l_accpm_id
                  , @pa_accpm_prop_id
                  , @l_clicm_id
                  , @l_enttm_id
                  , @l_excpm_id
                  , @l_mnd_flg
                  , @pa_accpm_prop_cd
                  , @pa_accpm_prop_desc
                  , @pa_accpm_acct_type
                  , @pa_accpm_prop_rmks
                  , @pa_login_name
                  , getdate()
                  , @pa_login_name
                  , getdate()
                  , 6
                  , @pa_accpm_datatype
                  )
                  --
                  SET @l_error = @@error
                  --
                  IF @l_error > 0
                  BEGIN--#1
                  --
                    SET @l_errorstr = CONVERT(VARCHAR, @l_error)+@rowdelimiter
                    --
                    ROLLBACK TRANSACTION
                    --
                    RETURN
                  --
                  END--#1
                  ELSE
                  BEGIN--#2
                  --
                    COMMIT TRANSACTION
                  --
                  END--#2
                --  
                END --<>0
                ELSE
                BEGIN--=0
                --
                  UPDATE accpm_mak  with (rowlock)
                  SET    accpm_deleted_ind = 6
                        ,accpm_lst_upd_by  = @pa_login_name
                        ,accpm_lst_upd_dt  = getdate()
                  WHERE  accpm_prop_id     = @pa_accpm_prop_id
                  AND    accpm_clicm_id    = @l_clicm_id
                  AND    accpm_enttm_id    = @l_enttm_id
                  AND    accpm_excpm_id    = @l_excpm_id
                  --
                  SET @l_error = @@error
                  --
                  IF @l_error > 0
                  BEGIN--#1
                  --
                    SET @l_errorstr = convert(VARCHAR, @l_error)+@rowdelimiter
                    --
                    ROLLBACK TRANSACTION
                    --
                    RETURN
                  --
                  END--#1
                  ELSE
                  BEGIN--#2
                  --
                    COMMIT TRANSACTION
                  --
                  END--#2
                --
                end--=0
              --
              END--FLG/2
              ELSE
              BEGIN--NOFLAG
              --
                SET @L_ERRORSTR = 'one or all of the parameters is/are null'
              --
              END--NOFLAG
            --
            END--CV3
          --
          END--RV3
        --
        END--NULL
      ----
      END--CHK=1
    --
    END--CID
  ---------
  END--RVID
  --
  IF isnull(rtrim(ltrim(@l_errorstr)),'') = ''
  BEGIN
  --
    SET @l_errorstr = 'Account properties successfully inserted\edited '+ @rowdelimiter
  --
  END
  ELSE
  BEGIN
  --
    SET @pa_errmsg = @l_errorstr
  --
  END
--
END--main begin

GO
