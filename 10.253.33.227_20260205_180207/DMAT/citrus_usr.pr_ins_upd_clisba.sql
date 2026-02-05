-- Object: PROCEDURE citrus_usr.pr_ins_upd_clisba
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE     PROCEDURE [citrus_usr].[pr_ins_upd_clisba] ( @pa_id            varchar(8000)                
                                  , @pa_action        varchar(20)                
                                  , @pa_login_name    varchar(20)                
                                  , @pa_ent_id        numeric                
                                  , @pa_values        varchar(8000)                
                                  , @pa_chk_yn        numeric                
                                  , @rowdelimiter     char(4) = '*|~*'                
                                  , @coldelimiter     char(4) = '|*~|'                
                                  , @pa_msg           varchar(8000) output                
                                  )                
AS                
BEGIN                
/*                
*********************************************************************************                
 system              : class                
 module name         : pr_ins_upd_clisba                
 description         : creating sub-account based on (comp_id, excsm_id, acct_no, sub-acct_no, name & prod_id                
 copyright(c)        : enc software solutions pvt. ltd.                
 version history     : 1.0                
 vers.    author            date               reason                
 -----    -------------     ----------         ---------------------------------------------                
 1.0      sukhvinder        05-dec-2006        initial version.                
-----------------------------------------------------------------------------------*/                
--                
DECLARE @delimeter           varchar(10)                
      , @l_counter           int                
      , @l_clisba_id         numeric                
      , @l_excpm_id          numeric                
      , @l_comp_id           numeric                
      , @l_excsm_id          numeric                
      , @l_acct_no           varchar(25)                
      , @clisba_id_old       numeric                
      , @clisba_crn_no_old   varchar(25)                
      , @clisba_acct_no_old  varchar(25)                
      , @clisba_no_old       varchar(25)                
      , @clisba_name_old     varchar(50)                
      , @clisba_excpm_id_old numeric                
      , @excpm_excsm_id_old  numeric                
      , @client_code_id_old  numeric                  
      , @l_clia_crn_no       varchar(25)                
      , @l_sub_acct_no       varchar(25)                
      , @l_name              varchar(50)                
      , @l_prod_id           numeric                
      , @l_clisba_name       varchar(50)                
      , @@t_errorstr         varchar(8000)                
      , @@remainingstring1   varchar(8000)                
      , @@currstring1        varchar(8000)                
      , @@remainingstring2   varchar(8000)                
      , @@currstring2        varchar(8000)                
      , @@foundat1           integer                
      , @@foundat2           integer                
      , @@delimeterlength    int                
      , @l_action_type       varchar(10)                
      , @@l_error            int                
      , @@l_deleted_ind      int                  
      , @l_clisbamak_id      numeric                
      , @l_action            varchar(5)                
      , @l_clisba_id1        numeric                
      , @L_EDT_DEL_ID        numeric                             
      , @l_client_code       varchar(20)                
      , @l_brokerage         varchar(20)                   
      , @l_client_code_id    numeric                 
      , @l_clisba_brom       varchar(20)      
      , @l_crn_clisba        VARCHAR(50)      
  --                
  SET @l_counter   = 1                
  SET @@t_errorstr = ''                
  --                
  IF ISNULL(@pa_id,'') <> '' AND isnull(@pa_login_name,'') <> ''                
  BEGIN --###                
  --                
    SET @delimeter         = '%'+RTRIM(LTRIM(@rowdelimiter))+'%'          
    SET @@delimeterlength  = len(@rowdelimiter)                
    SET @@remainingstring1 = @pa_id                
    SET @@remainingstring2 = @pa_values                
    --                
    IF @pa_action = 'APP'   or   @pa_action = 'REJ'              
    BEGIN--a                
    --                
      CREATE TABLE #t_recordset1(clisbamak_id         numeric                
                               ,clisba_id            numeric                
                                ,clisba_crn_no        numeric                
                                ,clisba_acct_no       varchar(25)                
                                ,clisba_no            varchar(25)                
                                ,clisba_name          varchar(50)                
                                ,clisba_excpm_id      numeric                
                                ,clisba_access2       numeric                
                                ,excpm_excsm_id       numeric                
                                ,clisba_deleted_ind   numeric                
                                ,clisba_brom          VARCHAR(20)                 
                                )                
      --                
      INSERT INTO #t_recordset1                
      (clisbamak_id                
      ,clisba_id                
      ,clisba_crn_no                
      ,clisba_acct_no                
      ,clisba_no                
      ,clisba_name                
      ,clisba_excpm_id                
      ,clisba_access2           
      ,clisba_deleted_ind                
      ,clisba_brom                
      )                
      SELECT a.clisbamak_id        clisbamak_id                  
           , a.clisba_id           clisba_id                
           , a.clisba_crn_no       clisba_crn_no                
           , a.clisba_acct_no      clisba_acct_no                
           , a.clisba_no           clisba_no                
           , a.clisba_name         clisba_name                
           , a.clisba_excpm_id     clisba_excpm_id                
           , a.clisba_access2      clisba_access2                
           , a.clisba_deleted_ind  clisba_deleted_ind                
           , isnull(a.clisba_brom,0) clisba_brom                
      FROM   client_sub_accts_mak  a    WITH (NOLOCK)                
      WHERE  a.clisba_deleted_ind IN (0,4,8)                
    --                
    END--a                
    ELSE                
    BEGIN--b                
    --                
      CREATE TABLE #t_recordset(clisba_id           numeric                
                               ,clisba_crn_no       numeric                
                               ,clisba_acct_no      varchar(25)                
                               ,clisba_no           varchar(25)                
                               ,clisba_name         varchar(50)                
                               ,clisba_excpm_id     numeric                
                               ,clisba_access2      numeric                
                               ,excpm_excsm_id      numeric                
                               ,clisba_deleted_ind  numeric                
                             )                
      --                                       
      INSERT INTO #t_recordset                
      (clisba_id                
      ,clisba_crn_no                
      ,clisba_acct_no                
      ,clisba_no                
      ,clisba_name                
      ,clisba_excpm_id                
      ,clisba_access2                
      ,excpm_excsm_id                
      ,clisba_deleted_ind                
      )                
      SELECT a.clisba_id           clisba_id                
           , a.clisba_crn_no       clisba_crn_no                
       , a.clisba_acct_no      clisba_acct_no                
           , a.clisba_no           clisba_no                
           , a.clisba_name         clisba_name                
           , a.clisba_excpm_id     clisba_excpm_id                
           , a.clisba_access2      clisba_access2                
           , b.excpm_excsm_id      excpm_excsm_id                
           , a.clisba_deleted_ind  clisba_deleted_ind                
      FROM   client_sub_accts a    WITH (NOLOCK)                
          ,  excsm_prod_mstr  b    WITH (NOLOCK)                
      WHERE  a.clisba_crn_no = @pa_ent_id                
      AND    a.clisba_excpm_id    = b.excpm_prom_id                
      AND    a.clisba_deleted_ind = 1                
    --                  
    END--b                
    --                
    WHILE @@remainingstring1 <> ''  --1st while                
    BEGIN --while_id                
    --                
      SET @@foundat1 = 0                
      SET @@foundat1 =  patindex('%'+@delimeter+'%', @@remainingstring1)                
                
      IF @@foundat1 > 0                
      BEGIN                
      --                
        SET @@currstring1      = substring(@@remainingstring1, 0, @@foundat1)                
        SET @@remainingstring1 = substring(@@remainingstring1, @@foundat1+@@delimeterlength, len(@@remainingstring1) - @@foundat1+@@delimeterlength)                
      --                
      END                
      ELSE                
      BEGIN                
      --                
        SET @@currstring1      = @@remainingstring1                
        SET @@remainingstring1 = ''                
      --                
      END                
      --                
      IF @@currstring1 <> ''                
      BEGIN--cur_id                
      --                
        IF @pa_action <> 'REJ' and @pa_action <> 'APP'                
        BEGIN--001                
        --                
          WHILE @@remainingstring2 <> ''                
          BEGIN--while_val                
          --                
            SET @@foundat2 = 0                
            SET @@foundat2 =  PATINDEX('%'+@delimeter+'%', @@remainingstring2)                
                
            IF @@foundat2 > 0                
            BEGIN                
            --                
              SET @@currstring2      = SUBSTRING(@@remainingstring2, 0, @@foundat2)                
              SET @@remainingstring2 = SUBSTRING(@@remainingstring2, @@foundat2+@@delimeterlength, len(@@remainingstring2) - @@foundat2+@@delimeterlength)                
            --                
            END                
            ELSE                
            BEGIN                
            --                
              SET @@currstring2      = @@remainingstring2                
              SET @@remainingstring2 = ''                
            --                
            END                
            --                
            IF @@currstring2 <> ''                
            BEGIN--cur_val                
            --                
              SET @l_comp_id        = citrus_usr.fn_splitval(@@currstring2, 1)                
              SET @l_excsm_id       = citrus_usr.fn_splitval(@@currstring2, 2)                
              SET @l_acct_no        = citrus_usr.fn_splitval(@@currstring2, 3)                
              SET @l_sub_acct_no    = citrus_usr.fn_splitval(@@currstring2, 4)                
              SET @l_name           = citrus_usr.fn_splitval(@@currstring2, 5)                
              --SET @l_prod_id        = citrus_usr.fn_splitval(@@currstring2, 6)                
              SET @l_excpm_id       = citrus_usr.fn_splitval(@@currstring2, 6)                
              SET @l_client_code    = citrus_usr.fn_splitval(@@currstring2, 7)                
              SET @l_brokerage      = CONVERT(VARCHAR,citrus_usr.fn_splitval(@@currstring2, 8))           
              SET @l_action_type    = citrus_usr.fn_splitval(@@currstring2, 9)                
              --                
              /*      
              SELECT @l_excpm_id       = excpm_id                
              FROM   excsm_prod_mstr     WITH (NOLOCK)                
              WHERE  excpm_excsm_id    = @l_excsm_id                
              AND    excpm_prom_id     = @l_prod_id      
              */                
              --                
              SELECT @l_client_code_id = stam_id                
              FROM   STATUS_MSTR         WITH (NOLOCK)                
              WHERE  STAM_CD           = @l_client_code                
              --                
              --SELECT @l_clisba_id      = ISNULL(max(clisba_id),0)+1                
              --FROM client_sub_accts      WITH (NOLOCK)      
              ---      
              SELECT @l_clisba_id      = isnull(max(bitrm_bit_location),0)+1      
              FROM   bitmap_ref_mstr     WITH (NOLOCK)      
              WHERE  bitrm_parent_cd   = 'SBAID'       
              AND    bitrm_child_cd    = 'SBAID'      
              AND    bitrm_deleted_ind = 1      
              --      
              UPDATE bitmap_ref_mstr      WITH(ROWLOCK)       
              SET    bitrm_bit_location = @l_clisba_id      
              WHERE  bitrm_parent_cd    = 'SBAID'       
              AND    bitrm_child_cd     = 'SBAID'      
              AND    bitrm_deleted_ind  = 1      
              --                
              SELECT @l_clia_crn_no    = clia_crn_no                
              FROM client_accounts       WITH (NOLOCK)                
              WHERE clia_acct_no       = @l_acct_no                
              --                
              IF @pa_chk_yn = 0                
              BEGIN--chk_yn=0                
              --                
                IF ISNULL(@pa_action,'') <> ''                
                BEGIN--action=''                
                --                
                  IF ISNULL(CONVERT(varchar,@l_excpm_id),'') <> '' AND ISNULL(@l_clia_crn_no,'') <> ''                
                  BEGIN--not null                
                  --                
                    IF @l_action_type = 'A'                
                    BEGIN--a_0                
                    --                
                      BEGIN TRANSACTION                
                      --                
                      INSERT INTO client_sub_accts                
                      (clisba_id                
                      ,clisba_crn_no                
                      ,clisba_acct_no                
                      ,clisba_no                
                      ,clisba_name                
                      ,clisba_excpm_id                
                      ,clisba_access2                
                      ,clisba_created_by                
                      ,clisba_created_dt                
                      ,clisba_lst_upd_by                
                      ,clisba_lst_upd_dt                
                      ,clisba_deleted_ind                
                      )                
                      VALUES                
                      (@l_clisba_id                
                      ,@pa_ent_id                
                      ,@l_acct_no                
                      ,@l_sub_acct_no                
                      ,@l_name                
                      ,@l_excpm_id                
                      ,@l_client_code_id                
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
                        SET @@t_errorstr = '#'+'could not change access for ' + CONVERT(varchar, @l_sub_acct_no) + ISNULL(@@t_errorstr,'')                
                        --        
                                  
                        ROLLBACK TRANSACTION                
                      --                
                      END      
                      --      
                      EXEC pr_ins_upd_mig_list @pa_ent_id, @l_sub_acct_no, '09', @l_action_type, 'Client Sub Accts', @pa_login_name,'*|~*', '|*~|',''      
                      --                
                      INSERT INTO client_brokerage                
                      (clib_clisba_id                
                      ,clib_brom_id                
                      ,clib_created_by                
                      ,clib_created_dt                
                      ,clib_lst_upd_by                
                      ,clib_lst_upd_dt                
                      ,clib_deleted_ind                
                      )                
                      VALUES                
                      (@l_clisba_id                
                      ,@l_brokerage                
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
                        SET @@t_errorstr = '#'+'could not change access for ' + CONVERT(varchar, @l_sub_acct_no) + ISNULL(@@t_errorstr,'')                         
                        --      
                        ROLLBACK TRANSACTION                
                      --                
                      END                
                      ELSE        
                      BEGIN         
                      --                
                        SET @@t_errorstr = 'sub-accounts successfully inserted\edited '+ @rowdelimiter                
                        --                
                        COMMIT TRANSACTION                
                      --        
                      END         
                    --                  
                    END --a_0                
                    --                
                    ELSE IF @l_action_type = 'E'                
                    BEGIN--e_0                
                    --                
                      SELECT @clisba_acct_no_old  = clisba_acct_no                
                           , @clisba_no_old       = clisba_no                
                           , @clisba_name_old     = clisba_name                
                           , @clisba_excpm_id_old = clisba_excpm_id                
                           , @excpm_excsm_id_old  = excpm_excsm_id                
                           , @client_code_id_old  = clisba_access2                 
                      FROM   #t_recordset                
                      WHERE  clisba_crn_no        = @pa_ent_id                
                      --                
                      IF  (@clisba_acct_no_old <> @l_acct_no)      AND (@clisba_no_old       <> @l_sub_acct_no)                 
                      AND (@clisba_name_old    <> @l_name)         AND (@clisba_excpm_id_old <> @l_excpm_id)                     
                      AND (@client_code_id_old <> @l_client_code_id)                
                      BEGIN --#001                
                      --            
                        BEGIN TRANSACTION                
                        --                
                        SELECT @l_clisba_id = ISNULL(MAX(clisba_id),0)+1                
                        FROM client_sub_accts WITH (NOLOCK)                
                        --                
                        INSERT INTO client_sub_accts                
                        (clisba_id                
                        ,clisba_crn_no                
                        ,clisba_acct_no                
                        ,clisba_no                
                        ,clisba_name                
                        ,clisba_excpm_id                
                        ,clisba_access2      
                        ,clisba_created_by                
                        ,clisba_created_dt                
                        ,clisba_lst_upd_by                
                        ,clisba_lst_upd_dt                
                        ,clisba_deleted_ind                
                        )                
                        VALUES                
                        (@l_clisba_id                
                        ,@pa_ent_id                
                        ,@l_acct_no                
                        ,@l_sub_acct_no                
                        ,@l_name                
                        ,@l_excpm_id                
                        ,@l_client_code_id                
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
                          SET @@t_errorstr = '#'+'could not change access for ' + CONVERT(varchar, @l_sub_acct_no) + ISNULL(@@t_errorstr,'')                
                          --                
                          ROLLBACK TRANSACTION                
                        --                
                        END      
                        --      
                        EXEC pr_ins_upd_mig_list @pa_ent_id, @l_sub_acct_no, '09', @l_action_type, 'Client Sub Accts', @pa_login_name,'*|~*', '|*~|',''      
                        --                
                        INSERT INTO client_brokerage                
                        (clib_clisba_id                
                        ,clib_brom_id                
                        ,clib_created_by                
                        ,clib_created_dt                
                        ,clib_lst_upd_by                
                        ,clib_lst_upd_dt                
                        ,clib_deleted_ind                
                        )                
                        VALUES                
                        (@l_clisba_id                
                        ,@l_brokerage                
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
                          SET @@t_errorstr = '#'+'could not change access for ' + CONVERT(varchar, @l_sub_acct_no) + ISNULL(@@t_errorstr,'')                
                          --                
                          ROLLBACK TRANSACTION                
                        --                
                        END                
                        ELSE        
                        BEGIN         
                        --                
                          COMMIT TRANSACTION                
                          --                
                          SET @@t_errorstr = 'sub-accounts successfully inserted\edited '+ @rowdelimiter                
                        --        
                        END         
                      --                
                      END--#001                
                      ELSE                
                      BEGIN--#002                
                        --                
                        BEGIN TRANSACTION        
                        --                
                        UPDATE client_sub_accts     WITH (ROWLOCK)                
                        SET    clisba_no          = @l_sub_acct_no                
                             , clisba_name        = @l_name                
                             , clisba_excpm_id    = @l_excpm_id                
                             , clisba_access2     = @l_client_code_id                
                             , clisba_lst_upd_by  = @pa_login_name                
                             , clisba_lst_upd_dt  = GETDATE()                
                        WHERE  clisba_crn_no      = @pa_ent_id                
                        AND    clisba_acct_no     = @l_acct_no                
                        AND    clisba_deleted_ind = 1                
                        --                
                        SET @@l_error = @@ERROR                
              --                
                        IF @@l_error > 0             
                        BEGIN                
                        --                
                          SET @@t_errorstr = '#'+'could not change access for ' + CONVERT(varchar, @l_sub_acct_no) + ISNULL(@@t_errorstr,'')                
                          --                
                          ROLLBACK TRANSACTION                
                        --                
                        END                
                        ELSE                
                        BEGIN                
                        --      
                          EXEC pr_ins_upd_mig_list @pa_ent_id, @l_sub_acct_no, '09', @l_action_type,'Client Sub Accts', @pa_login_name,'*|~*', '|*~|',''      
                          --      
                          UPDATE client_brokerage    WITH (ROWLOCK)                
                          SET    clib_brom_id      = @l_brokerage                
                               , clib_lst_upd_by   = @pa_login_name                
                               , clib_lst_upd_dt   = GETDATE()                
                          WHERE  clib_clisba_id    = @l_clisba_id                
                          and    clib_deleted_ind  = 1                
                          --                
                          SET @@l_error = @@ERROR                
                          --                
                          IF @@l_error > 0                
                          BEGIN                
                          --                
                            SET @@t_errorstr = '#'+'could not change access for ' + CONVERT(varchar, @l_sub_acct_no) + ISNULL(@@t_errorstr,'')                 
        
                            ROLLBACK TRANSACTION                
                          --                
                          END                
                          ELSE        
                          BEGIN        
                          --           
                            COMMIT TRANSACTION                
                            --                
         SET @@t_errorstr = 'sub-accounts successfully inserted\edited '+ @rowdelimiter          
                          --        
                          END        
                                      
                          DELETE FROM #t_recordset                
                          WHERE clisba_acct_no = @l_acct_no                
                          AND clisba_no        = @l_sub_acct_no                
                          AND clisba_excpm_id  = @l_excpm_id                
                          --                
                                        
                        --                
                        END                
                      --                
                      END--#002                
                    --                
                    END --e_0                
                    --                
                    ELSE IF @l_action_type = 'D'                
                    BEGIN--d_0                
                    --      
                      BEGIN TRANSACTION                
                      --                
                      UPDATE client_sub_accts    WITH (ROWLOCK)                
                      SET    clisba_deleted_ind  = 0                
                           , clisba_lst_upd_by   = @pa_login_name                
                           , clisba_lst_upd_dt   = GETDATE()                
                      WHERE  clisba_crn_no       = @pa_ent_id                
                      AND    clisba_acct_no      = @l_acct_no                
                      AND    clisba_no           = @l_sub_acct_no                
                      AND    clisba_deleted_ind  = 1                
                      --                
                      SET @@l_error = @@ERROR                
                                      
                      IF @@l_error > 0                
                      BEGIN                
                      --                
                        SET @@t_errorstr = '#'+'could not change access for ' + CONVERT(varchar, @l_sub_acct_no) + ISNULL(@@t_errorstr,'')                
                        --                
                        ROLLBACK TRANSACTION                
                      --                
                      END                
                      --ELSE                
                      --BEGIN                
                      --                
                      --  SET @@t_errorstr = 'sub-accounts successfully inserted\edited '+ @rowdelimiter                
                        --                
                      --  COMMIT TRANSACTION                
                      --                
                      --END                
                      UPDATE client_brokerage    WITH (ROWLOCK)                
                      SET    clib_deleted_ind  = 0                
                           , clib_lst_upd_by   = @pa_login_name                
                           , clib_lst_upd_dt   = GETDATE()                
                      WHERE  clib_clisba_id    = @l_clisba_id                
                      AND    clib_deleted_ind  = 1                
                      --                
                      SET @@t_errorstr = 'sub-accounts successfully inserted\edited '+ @rowdelimiter                
                      --                
                      COMMIT TRANSACTION                
                    --                
                    END--d_0                
                    ELSE                
                    BEGIN                
                    --                
                      SET @@t_errorstr = 'sub-party mapping details not provided'+ @rowdelimiter                
                    --                
                    END                
                  --                
                  END --not null                
                --                
                END--action=''                
              --                
              END--chk_yn=0                
              ELSE                
              BEGIN--chk_yn=1_2                
              --                
                IF @l_action_type IN ('A','D','E')                
                BEGIN--action=''                
                --                
                  IF EXISTS(SELECT *                 
                            FROM   client_sub_accts_mak  WITH (NOLOCK)                
                            WHERE  clisba_crn_no       = @pa_ent_id                
                            AND    clisba_acct_no      = @l_sub_acct_no                
                            AND    clisba_no           = @l_acct_no                 
                            AND    clisba_deleted_ind IN (0,4,8)                
                           )                
                  BEGIN--EXTS                
                  --                
                    BEGIN TRANSACTION                
                    --                   
                    UPDATE clisba_sub_accts_mak  WITH (ROWLOCK)                
                    SET    clisba_deleted_in   = 3                
                         , clisba_lst_upd_by   = @pa_login_name                
                         , clisba_lst_upd_dt   = GETDATE()                
                    WHERE  clisba_crn_no       = @pa_ent_id                
                    AND    clisba_acct_no      = @l_sub_acct_no                
                    AND    clisba_no           = @l_acct_no                 
                    AND    clisba_deleted_ind IN (0,4,8)                
                    --                
                    SET @@l_error = @@ERROR                
                    --                
                    IF @@l_error > 0                
                    BEGIN                
                    --                
                      SET @@t_errorstr = '#'+'could not change access for ' + CONVERT(varchar, @l_sub_acct_no) + ISNULL(@@t_errorstr,'')                
                      --                
                      ROLLBACK TRANSACTION                
                    --                
                    END                
                    ELSE                
                    BEGIN                
                    --                
                      COMMIT TRANSACTION                
                     --                
                      SET @@t_errorstr = 'sub-accounts successfully inserted\edited '+ @rowdelimiter                
                    --                
                    END                
                  --               
                  END--EXTS                
                  --                
                  BEGIN TRANSACTION                
                  --                
                   SELECT @l_clisbamak_id = ISNULL(MAX(clisbamak_id),0)+1                
                   FROM client_sub_accts_mak                
                   --       
                   --SELECT @l_clisba_id = ISNULL(MAX(clisba_id),0)+1                
                   --FROM client_sub_accts_mak      
                   --**--      
                   SELECT @l_clisba_id      = isnull(max(bitrm_bit_location),0)+1      
                   FROM   bitmap_ref_mstr     WITH (NOLOCK)      
                   WHERE  bitrm_parent_cd   = 'SBAID'       
                   AND    bitrm_child_cd    = 'SBAID'      
                   AND    bitrm_deleted_ind = 1      
                   --      
                   UPDATE bitmap_ref_mstr      WITH(ROWLOCK)       
                   SET    bitrm_bit_location = @l_clisba_id      
                   WHERE  bitrm_parent_cd    = 'SBAID'       
                   AND    bitrm_child_cd     = 'SBAID'      
                   AND    bitrm_deleted_ind  = 1      
                   --**--      
                   SELECT @l_clisba_id1      = ISNULL(MAX(clisba_id),0)+1                
                   FROM client_sub_accts       WITH (NOLOCK)                
                   --      
                         
                   IF @l_clisba_id > @l_clisba_id1                
                   BEGIN                
                   --                
                     SET @l_clisba_id1 = @l_clisba_id                
                   --                  
                   END                
                   --                
                         
                   IF EXISTS(SELECT clisba_id                 
                             FROM   client_sub_accts    WITH(NOLOCK)             
                             WHERE  clisba_no     =  @l_acct_no                 
                             AND    clisba_crn_no = @pa_ent_id      
                             )                  
                   BEGIN                
                   --                
                     SELECT @l_clisba_id1 = clisba_id                 
                                          FROM   client_sub_accts    WITH(NOLOCK)             
                                          WHERE  clisba_no     =  @l_acct_no                 
                                          AND    clisba_crn_no = @pa_ent_id      
                                                
                     SET @L_EDT_DEL_ID = 8                                  --                
                   END                
                   ELSE                
                   BEGIN                
                   --                
                     SET @L_EDT_DEL_ID = 0                
                   --                
                   END                
                   --                
                   INSERT INTO client_sub_accts_mak                
                   (clisbamak_id                
                   ,clisba_id                
                   ,clisba_crn_no                
                   ,clisba_acct_no                
                   ,clisba_no                
                   ,clisba_name                
                   ,clisba_excpm_id                
                   ,clisba_access2                
                   ,clisba_created_by                
                   ,clisba_created_dt                
                   ,clisba_lst_upd_by                
                   ,clisba_lst_upd_dt                
                   ,clisba_deleted_ind                
                   ,clisba_brom                
                   )                
                   VALUES                
                   (@l_clisbamak_id                
                   ,@l_clisba_id1                
                   ,@pa_ent_id                
                   ,@l_acct_no                
                   ,@l_sub_acct_no              
                   ,@l_name                
                   ,@l_excpm_id                
                   ,@l_client_code_id                
                   ,@pa_login_name                
                   ,GETDATE()                
                   ,@pa_login_name                
                   ,GETDATE()                
                   ,CASE @l_action_type WHEN 'A' then 0                
                                        WHEN 'E' then @l_edt_del_id                                    
                                        WHEN 'D' then 4                
                                        END                
                   ,@l_brokerage                                     
                   )                
                   --                
                   --                
                   SET @@l_error = @@ERROR                
                   --                
                   IF @@l_error > 0                
                   BEGIN                
                   --                
                     SET @@t_errorstr = '#'+'could not change access for ' + CONVERT(varchar, @l_sub_acct_no) + ISNULL(@@t_errorstr,'')                
                     --                
                     ROLLBACK TRANSACTION                
                   --                
                   END                
                   ELSE                
                   BEGIN                
                   --                
                     SET @@t_errorstr = 'sub-accounts successfully inserted\edited '+ @rowdelimiter                
                     --                
                     SELECT @l_action = CASE @l_action_type WHEN 'A' THEN 'I' WHEN 'E' THEN 'E' WHEN 'D' THEN 'D' END                
                     --                
                     COMMIT TRANSACTION                
                     --      
                     SET @l_crn_clisba = convert(varchar,@pa_ent_id) + '|*~|'+ convert(varchar,@l_clisba_id1) +'|*~|'      
                           
                     EXEC pr_ins_upd_list @l_crn_clisba, @l_action, 'Client Sub Accts',@pa_login_name,'*|~*','|*~|',''                 
                   --                
                END                
                --                
                END--action=''                
              --                
              END--chk_yn=1_2                
            --                
            END--cur_val                
          --                
          END--while_val                
        --                  
        END--001                  
        ELSE                
        BEGIN--002                
        --                
          SET @l_clisba_id    = NULL                        SET @l_sub_acct_no  = NULL                 
          SET @l_name         = NULL                
          SET @l_excpm_id     = NULL                
          SET @l_acct_no      = NULL                
          SET @l_clia_crn_no  = NULL                
          SET @@l_deleted_ind = NULL                
          SET @l_clisba_brom  = NULL                
          --          
                          
               
          SELECT @l_clisba_id       = clisba_id                    
               , @l_sub_acct_no     = CONVERT(NUMERIC,clisba_acct_no)          
               , @l_name            = clisba_name                
               , @l_excpm_id        = clisba_excpm_id                
               , @l_acct_no         = clisba_acct_no                
               , @l_clia_crn_no     = clisba_crn_no                
               , @l_clisba_brom     = clisba_brom                  
               , @@l_deleted_ind    = clisba_deleted_ind                
          FROM   #t_recordset1                
          WHERE  clisbamak_id       = CONVERT(numeric, @@currstring1)                
                        
                    
          --                
          IF @pa_action = 'REJ'                
          BEGIN--rej                
          --                
            UPDATE client_sub_accts_mak  WITH (ROWLOCK)                
            SET    clisba_deleted_ind  = 3                
                 , clisba_lst_upd_by   = @pa_login_name                
                 , clisba_lst_upd_dt   = GETDATE()                 
            WHERE  clisbamak_id     = CONVERT(numeric, @@currstring1)                
            AND    clisba_deleted_ind IN (0,4,8)                
            --                
            SET @@l_error = @@ERROR                
            --                
            IF @@l_error > 0                
            BEGIN                
            --                
              SET @@t_errorstr = CONVERT(VARCHAR(10), @@l_error)                
            --                
            END                
          --                
          END--rej                
          --                
          IF @pa_action = 'APP'                
          BEGIN--app_1                
          --                
            IF @@l_deleted_ind = 4                 
            BEGIN--4                
            --                
              UPDATE client_sub_accts_mak  WITH (ROWLOCK)                
              SET    clisba_deleted_ind  = 5                
               , clisba_lst_upd_by   = @pa_login_name                
                   , clisba_lst_upd_dt   = GETDATE()                
              WHERE  clisba_deleted_ind  = 4                
              AND    clisbamak_id        = CONVERT(numeric, @@currstring1)                
              --                
              SET @@l_error = @@ERROR                
              --                
              IF @@l_error > 0                
              BEGIN                
              --                
                SET @@t_errorstr = CONVERT(VARCHAR(10), @@l_error)                
              --                
              END                
                             
              UPDATE client_sub_accts      WITH (ROWLOCK)                
              SET    clisba_deleted_ind  = 0                
                   , clisba_lst_upd_by   = @pa_login_name                
                   , clisba_lst_upd_dt   = GETDATE()                
              WHERE  clisba_deleted_ind  = 1                
              AND    clisba_crn_no       = @l_clia_crn_no                
              AND    clisba_acct_no      = @l_acct_no                
              AND    clisba_no           = @l_sub_acct_no                
              --                
              SET @@l_error = @@ERROR                
              --                
              IF @@l_error > 0                
              BEGIN                
              --                
                SET @@t_errorstr = CONVERT(VARCHAR(10), @@l_error)                
              --                
              END                
              --               
              UPDATE client_brokerage      WITH (ROWLOCK)                
              SET    clib_deleted_ind  = 0                
                   , clib_lst_upd_by     = @pa_login_name                
                   , clib_lst_upd_dt     = GETDATE()                 
              WHERE  clib_clisba_id      = @l_clisba_id                 
              AND    clib_deleted_ind    = 1                
              --                
              SET @@l_error = @@ERROR                
              --                
              IF @@l_error > 0                
              BEGIN                
              --                
                SET @@t_errorstr = CONVERT(VARCHAR(10), @@l_error)                
              --                
              END                
            --                  
            END--4                
            ELSE IF @@l_deleted_ind    = 8                
            BEGIN--8                
            --                
              UPDATE client_sub_accts_mak   WITH (ROWLOCK)                
              SET    clisba_deleted_ind   = 9                
                   , clisba_lst_upd_by    = @pa_login_name                
                   , clisba_lst_upd_dt    = GETDATE()                
              WHERE  clisba_deleted_ind   = 8                
              AND    clisbamak_id         = CONVERT(numeric, @@currstring1)                
              --                
              SET @@l_error = @@ERROR                
              --                
              IF @@l_error > 0                
              BEGIN                
              --                
                SET @@t_errorstr = CONVERT(VARCHAR(10), @@l_error)                
              --                
              END            
              --                
              UPDATE client_sub_accts     WITH (ROWLOCK)                
              SET    clisba_no          = @l_sub_acct_no                
                   , clisba_name        = @l_name                
                 , clisba_excpm_id    = @l_excpm_id                
                   , clisba_acct_no     = @l_acct_no                
                   , clisba_lst_upd_by  = @pa_login_name                
                   , clisba_lst_upd_dt  = GETDATE()                
              WHERE  clisba_crn_no      = @l_clia_crn_no             
              AND    clisba_acct_no     = @l_acct_no                
              AND    clisba_no          = @l_sub_acct_no                
              AND    clisba_deleted_ind = 1                
              --                
              SET @@l_error = @@ERROR                
              --                
              IF @@l_error > 0                
              BEGIN                
              --                
                SET @@t_errorstr = CONVERT(VARCHAR(10), @@l_error)                
              --                
              END                
              --                
              UPDATE client_brokerage   WITH (ROWLOCK)                
              SET    clib_brom_id     = @l_clisba_brom                
                   , clib_lst_upd_by  = @pa_login_name                
                   , clib_lst_upd_dt  = GETDATE()                 
              WHERE  clib_clisba_id   = @l_clisba_id                 
              AND    clib_deleted_ind = 1                
              --                
              SET @@l_error = @@ERROR                
              --                
              IF @@l_error > 0                
              BEGIN                
              --                
                SET @@t_errorstr = CONVERT(VARCHAR(10), @@l_error)                
              --                
              END                
            --                
            END--8                
            ELSE IF @@l_deleted_ind = 0                 
            BEGIN--0                
            --                
              UPDATE client_sub_accts_mak WITH (ROWLOCK)                
              SET    clisba_deleted_ind  = 1                
                  , clisba_lst_upd_by   = @pa_login_name                
          , clisba_lst_upd_dt   = GETDATE()                
              WHERE  clisba_deleted_ind  = 0                
              AND    clisbamak_id        = CONVERT(numeric, @@currstring1)                
              --                
              SET @@l_error = @@ERROR                
              --                
              IF @@l_error > 0                
              BEGIN                
              --                
                 SET @@t_errorstr = CONVERT(VARCHAR(10), @@l_error)                
              --                
              END                
              --                
              INSERT INTO client_sub_accts                
              (clisba_id                
              ,clisba_crn_no                
              ,clisba_acct_no                
              ,clisba_no                
              ,clisba_name                
              ,clisba_excpm_id                
              ,clisba_access2                
              ,clisba_created_by                
              ,clisba_created_dt                
              ,clisba_lst_upd_by                
              ,clisba_lst_upd_dt                
              ,clisba_deleted_ind                
              )                
              SELECT clisba_id                
                   , clisba_crn_no                
                   , clisba_acct_no                
                   , clisba_no                
                   , clisba_name                
                   , clisba_excpm_id                
                   , clisba_access2                
                   , @pa_login_name                
                   , GETDATE()                
                   , @pa_login_name                
                   , GETDATE()                
                   , 1                
              FROM  #t_recordset1                
              WHERE  clisbamak_id = CONVERT(numeric, @@currstring1)                
         --                
              SET @@l_error = @@ERROR                
              --                
              IF @@l_error > 0                
              BEGIN                
       --                
                SET @@t_errorstr = CONVERT(VARCHAR(10), @@l_error)                
              --                
              END                
              --                
              INSERT INTO client_brokerage                
              (clib_clisba_id                
              ,clib_brom_id                
              ,clib_created_by                
              ,clib_created_dt                
              ,clib_lst_upd_by                
              ,clib_lst_upd_dt                
              ,clib_deleted_ind                
              )                
              SELect clisba_id                
                   , clisba_brom                
                   , @pa_login_name                
                   , GETDATE()                
                   , @pa_login_name                
                   , GETDATE()                
                   , 1                
              FROM  #t_recordset1                
              WHERE  clisbamak_id = CONVERT(numeric, @@currstring1)                
              --                
              SET @@l_error = @@ERROR                
              --                
              IF @@l_error > 0                
              BEGIN                
              --                
                               
                SET @@t_errorstr = CONVERT(VARCHAR(10), @@l_error)                
              --                
              END                
                           
            --                
            END --0                
            --move to pr_app_client                
            --EXEC pr_ins_upd_list @pa_ent_id, 'A','Client Sub Accts', @pa_login_name,'*|~*','|*~|',''                 
          --                
          END--app_1                
        --                
        END--002                
      --                
      END--cur_id                
      --                
      IF ISNULL(@@t_errorstr,'') = ''                
      BEGIN                
      --              
         SET @@t_errorstr = 'sub-accounts successfully Inserted/Edited '+ @rowdelimiter                
      --                
      END                
    --                  
    END--while_id                
    --                
    SET @pa_msg = @@t_errorstr          
                 
  --                
  END --###                
--                
END

GO
