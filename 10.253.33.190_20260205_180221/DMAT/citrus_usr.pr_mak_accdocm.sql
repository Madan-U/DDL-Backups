-- Object: PROCEDURE citrus_usr.pr_mak_accdocm
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE [citrus_usr].[pr_mak_accdocm](@pa_id                VARCHAR(8000)
                             ,@pa_action            VARCHAR(20)
                             ,@pa_login_name        VARCHAR(20)
                             ,@pa_accdocm_doc_id    INT
                             ,@pa_accdocm_cd        VARCHAR(20)
                             ,@pa_accdocm_desc      VARCHAR(20)
                             ,@pa_accdocm_acct_type VARCHAR(20) 
                             ,@pa_accdocm_rmks      VARCHAR(200)
                             ,@pa_values            VARCHAR(8000)--'EXCH|*~|seg|*~|prom_id|*~|enttm_id|*~|clicm_id|*~|m|*~|*|~*'
                             ,@pa_chk_yn            NUMERIC
                             ,@rowdelimiter         CHAR(4)
                             ,@coldelimiter         CHAR(4)
                             ,@pa_errmsg            VARCHAR(8000) OUTPUT)
AS
/*
*********************************************************************************
 system         : citrus
 module name    : pr_mak_accdm
 description    : this procedure will contain the maker checker facility for account_document_mstr
 copyright(c)   : marketplase technologies pvt ltd.
 version history:
 vers.  author            date         reason
 -----  -------------     ----------   -------------------------------------------------
 1.0    TUSHAR            12/05/07     INITIAL
-----------------------------------------------------------------------------------*/
--
BEGIN
--
  SET nocount ON
  --
  DECLARE @@remainingstring_val    VARCHAR(8000)
        , @@currstring_val         VARCHAR(8000)
        , @@foundat_val            INT
        , @@remainingstring_id     VARCHAR(8000)
        , @@currstring_id          VARCHAR(8000)
        , @@foundat_id             INT
        , @@delimeterlength        INT
        , @l_errorstr              VARCHAR(8000)
        , @l_accdocm_id            NUMERIC
        , @l_accdocmm_id           NUMERIC
        , @l_accdocm_doc_id        NUMERIC
        , @l_accdocm_doc_id_mak    NUMERIC
        --, @l_docmm_doc_id       NUMERIC
        , @l_delimeter             VARCHAR(10)
        , @l_exch_cd               VARCHAR(25)
        , @l_seg_cd                VARCHAR(25)
        , @l_err_enttm_desc        VARCHAR(100)
        , @l_err_clicm_desc        VARCHAR(100)
        , @l_err_excpm_id          NUMERIC
        , @l_err_excpm_prom_id     NUMERIC
        , @l_err_docm_cd           VARCHAR(25)
        , @l_err_docm_desc         VARCHAR(100)
        , @l_err_docm_doc_id       NUMERIC

        , @l_err_docm_rmks         VARCHAR(250)
        , @l_err_docm_mdty         CHAR(2)
        , @l_err_excsm_exch_cd     VARCHAR(25)
        , @l_err_excsm_seg_cd      VARCHAR(25)
        , @l_excsm_exch_cd         VARCHAR(25)
        , @l_excsm_seg_cd          VARCHAR(25)
        , @l_prom_desc             VARCHAR(100)
        , @l_prom_id               NUMERIC
        , @l_enttm_id              NUMERIC
        , @l_clicm_id              NUMERIC
        , @l_mnd_flg               SMALLINT
        , @l_excpm_id              NUMERIC
        , @l_error                 BIGINT
        , @l_node                  CHAR(5)
        , @l_exists                NUMERIC
        , @l_deleted_ind            SMALLINT
        ,@@c_excpm_id              NUMERIC
  DECLARE @@c_excpm  CURSOR
  --

  create table #t_accdocm
  ([accdocm_id]          [NUMERIC](10, 0),
   [accdocm_doc_id]      [NUMERIC](10, 0),
   [accdocm_clicm_id]    [NUMERIC](18, 0),
   [accdocm_enttm_id]    [NUMERIC](18, 0),
   [accdocm_excpm_id]    [NUMERIC](18, 0),
   [accdocm_cd]          [VARCHAR] (20),
   [accdocm_desc]        [VARCHAR] (100),
   [accdocm_acct_type]   [VARCHAR] (20),
   [accdocm_rmks]        [VARCHAR] (250),
   [accdocm_mdty]        [SMALLINT],
   [accdocm_created_by]  [VARCHAR] (25),
   [accdocm_created_dt]  [DATETIME],
   [accdocm_lst_upd_by]  [VARCHAR] (25),
   [accdocm_lst_upd_dt]  [VARCHAR] (25),
   [accdocm_deleted_ind] [SMALLINT])
   
   create table #t_doc_mstr
   ([accdocm_id]          [NUMERIC](10, 0),
    [accdocm_doc_id]      [NUMERIC](10, 0),
    [accdocm_clicm_id]    [NUMERIC](18, 0),
    [accdocm_enttm_id]    [NUMERIC](18, 0),
    [accdocm_excpm_id]    [NUMERIC](18, 0),
    [accdocm_cd]          [VARCHAR] (20),
    [accdocm_desc]        [VARCHAR] (100),
    [accdocm_acct_type]   [VARCHAR] (20),
    [accdocm_rmks]        [VARCHAR] (250),
    [accdocm_mdty]        [SMALLINT],
    [accdocm_created_by]  [VARCHAR] (25),
    [accdocm_created_dt]  [DATETIME],
    [accdocm_lst_upd_by]  [VARCHAR] (25),
    [accdocm_lst_upd_dt]  [VARCHAR] (25),
    [accdocm_deleted_ind] [SMALLINT])

  
  
  
  INSERT INTO #t_accdocm
   (accdocm_id         
   ,accdocm_doc_id     
   ,accdocm_clicm_id   
   ,accdocm_enttm_id   
   ,accdocm_excpm_id   
   ,accdocm_cd         
   ,accdocm_desc       
   ,accdocm_acct_type  
   ,accdocm_rmks       
   ,accdocm_mdty       
   ,accdocm_created_by 
   ,accdocm_created_dt 
   ,accdocm_lst_upd_by 
   ,accdocm_lst_upd_dt 
   ,accdocm_deleted_ind)
   SELECT accdocm_id         
         ,accdocm_doc_id     
         ,accdocm_clicm_id   
         ,accdocm_enttm_id   
         ,accdocm_excpm_id   
         ,accdocm_cd         
         ,accdocm_desc 
         ,accdocm_acct_type 
         ,accdocm_rmks       
         ,accdocm_mdty       
         ,accdocm_created_by 
         ,accdocm_created_dt 
         ,accdocm_lst_upd_by 
         ,accdocm_lst_upd_dt 
         ,accdocm_deleted_ind
   FROM   accdocm_mak
   WHERE  accdocm_deleted_ind = 0
   AND    accdocm_doc_id      = @pa_accdocm_doc_id
   
   INSERT INTO #t_doc_mstr
      (accdocm_id         
      ,accdocm_doc_id     
      ,accdocm_clicm_id   
      ,accdocm_enttm_id   
      ,accdocm_excpm_id   
      ,accdocm_cd         
      ,accdocm_desc       
      ,accdocm_acct_type  
      ,accdocm_rmks       
      ,accdocm_mdty       
      ,accdocm_created_by 
      ,accdocm_created_dt 
      ,accdocm_lst_upd_by 
      ,accdocm_lst_upd_dt 
      ,accdocm_deleted_ind)
      SELECT accdocm_id         
            ,accdocm_doc_id     
            ,accdocm_clicm_id   
            ,accdocm_enttm_id   
            ,accdocm_excpm_id   
            ,accdocm_cd         
            ,accdocm_desc 
            ,accdocm_acct_type 
            ,accdocm_rmks       
            ,accdocm_mdty       
            ,accdocm_created_by 
            ,accdocm_created_dt 
            ,accdocm_lst_upd_by 
            ,accdocm_lst_upd_dt 
            ,accdocm_deleted_ind
      FROM   account_document_mstr
      WHERE  accdocm_deleted_ind = 1
      AND    accdocm_doc_id=@pa_accdocm_doc_id
   
   
  
  --
  SET @l_error = 0
  SET @l_errorstr          = ''
  SET @l_delimeter         = '%'+ @rowdelimiter + '%'
  SET @@delimeterlength    = len(@rowdelimiter)
  SET @@remainingstring_id = @pa_id
  SET @l_accdocm_doc_id = 0
  --
  WHILE @@remainingstring_id <> ''
  BEGIN --#1
    --
     SET @@foundat_id  = 0
     SET @@foundat_id  =  patindex('%'+@l_delimeter+'%', @@remainingstring_id)
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
      SET @@currstring_id = @@remainingstring_id
      SET @@remainingstring_id = ''
     --
     END
     --
     IF @@currstring_id <> ''
     BEGIN --#2
     --
       IF @pa_chk_yn=0
       BEGIN--#@pa_chk_yn=0
       --
         IF @pa_action='EDTMSTR'
         BEGIN --#@pa_action='edtmstr'
         --
           BEGIN TRANSACTION

           UPDATE account_document_mstr
           SET    accdocm_cd          = @pa_accdocm_cd
                , accdocm_desc        = @pa_accdocm_desc
                , accdocm_rmks        = @pa_accdocm_rmks
           WHERE  accdocm_doc_id      = @pa_accdocm_doc_id
           AND    accdocm_deleted_ind = 1
           --
           SET @l_error = @@error
           IF @l_error > 0
           BEGIN
           --
             ROLLBACK TRANSACTION
           --
           SET @l_errorstr = convert(varchar, @l_error)+@rowdelimiter
           END
           ELSE
           BEGIN
           --
             COMMIT TRANSACTION
           --
           END
         --
         END
         IF @pa_action='DELMSTR'
         BEGIN
         --
           UPDATE account_document_mstr
           SET    accdocm_deleted_ind = 0
           WHERE  accdocm_doc_id      = @pa_id
           AND    accdocm_deleted_ind    = 1
         --
         END
         ELSE IF ISNULL(@pa_action,'')=''
         BEGIN  --#@pa_action is null
         --
         
          SET @@remainingstring_val = @pa_values
          WHILE @@remainingstring_val <> ''
          BEGIN--#3

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
            BEGIN--#4
            --
              SET @l_exch_cd  = citrus_usr.fn_splitval(@@currstring_val,1)
              SET @l_seg_cd   = citrus_usr.fn_splitval(@@currstring_val,2)
              SET @l_prom_id  = convert(numeric, citrus_usr.fn_splitval(@@currstring_val,3))
              SET @l_enttm_id = citrus_usr.fn_splitval(@@currstring_val,4)
              SET @l_clicm_id = citrus_usr.fn_splitval(@@currstring_val,5)
              SET @l_node     = citrus_usr.fn_splitval(@@currstring_val,6)
              SET @l_mnd_flg  = case citrus_usr.fn_splitval(@@currstring_val,7) when 'm' then 1 when 'n' then 0 else 2 end
            --
     
            /*select top 1 @l_excpm_id     = excpm.excpm_id
            from exch_seg_mstr excsm   with(nolock)
               , excsm_prod_mstr excpm with(nolock)
            where excpm.excpm_excsm_id   = excsm.excsm_id
            and excsm.excsm_exch_cd      = @l_exch_cd
            and excsm.excsm_seg_cd       = @l_seg_cd
            and excpm.excpm_prom_id      = @l_prom_id
            and excsm_deleted_ind        = 1
            and excpm_deleted_ind        = 1 */
            
            
            SET @@c_excpm  = CURSOR fast_forward FOR  
            SELECT  excpm.excpm_id
            FROM    exch_seg_mstr excsm   with(nolock)
                  , excsm_prod_mstr excpm with(nolock)
            WHERE   excpm.excpm_excsm_id   = excsm.excsm_id
            AND     excsm.excsm_exch_cd      = @l_exch_cd
            AND     excsm.excsm_seg_cd       = @l_seg_cd
            AND     excpm.excpm_prom_id      = @l_prom_id
            AND     excsm_deleted_ind        = 1
            AND     excpm_deleted_ind        = 1 
            
            OPEN  @@c_excpm  
            FETCH NEXT FROM @@c_excpm INTO @@c_excpm_id                 

            WHILE @@fetch_status = 0  
            BEGIN
            --  
            
               IF @l_mnd_flg=1 OR @l_mnd_flg=0
               BEGIN
               --

                 IF isnull(@pa_accdocm_cd,'')<>''
                 BEGIN
                 --

                   SELECT @l_accdocm_doc_id            = isnull(accdocmm.accdocm_doc_id,0)
                   FROM   accdocm_mak                    accdocmm
                   WHERE  accdocmm.accdocm_cd          = @pa_accdocm_cd
                   AND    accdocmm.accdocm_deleted_ind IN (1,0)

                   IF @l_accdocm_doc_id=0
                   BEGIN
                   --
                     SELECT @l_accdocm_doc_id           = isnull(max(accdocm.accdocm_doc_id), 0)
                     FROM   account_document_mstr         accdocm
                     WHERE  accdocm.accdocm_cd          = @pa_accdocm_cd
                     AND    accdocm.accdocm_deleted_ind IN (0,1);
                   --
                   END
                   IF @l_accdocm_doc_id = 0
                   BEGIN
                   --
                     SELECT @l_accdocm_doc_id_mak=isnull(max(accdocmm.accdocm_doc_id), 0) + 1
                     FROM   accdocm_mak  accdocmm;
                     --
                     SELECT @l_accdocm_doc_id=isnull(max(accdocm.accdocm_doc_id), 0) + 1
                     FROM   account_document_mstr  accdocm
                     --
                     IF @l_accdocm_doc_id_mak>@l_accdocm_doc_id
                     BEGIN
                     --
                       SET @l_accdocm_doc_id=@l_accdocm_doc_id_mak
                     --
                     END
                     --
                   END 

                   --
                   IF EXISTS(SELECT * FROM   account_document_mstr  accdocm
                             WHERE  accdocm.accdocm_doc_id      = @l_accdocm_doc_id
                             AND    accdocm.accdocm_clicm_id    = @l_clicm_id
                             AND    accdocm.accdocm_enttm_id    = @l_enttm_id
                             AND    accdocm.accdocm_excpm_id    = @@c_excpm_id    
                             AND    accdocm.accdocm_deleted_ind = 1 
                             )
                   BEGIN
                   --
                     SET @l_exists = 1
                   --
                   END
                   ELSE
                   BEGIN
                   --
                     SET @l_exists = 0
                   --
                   END

                   IF @l_exists=0
                   BEGIN
                   --
                     SELECT @l_accdocm_id = isnull(max(accdocm_id),0)+1
                     FROM   account_document_mstr

                     BEGIN TRANSACTION
                     --
                     
                      INSERT INTO account_document_mstr
                       (accdocm_id         
                       ,accdocm_doc_id     
                       ,accdocm_clicm_id   
                       ,accdocm_enttm_id   
                       ,accdocm_excpm_id   
                       ,accdocm_cd         
                       ,accdocm_desc       
                       ,accdocm_acct_type  
                       ,accdocm_rmks       
                       ,accdocm_mdty       
                       ,accdocm_created_by 
                       ,accdocm_created_dt 
                       ,accdocm_lst_upd_by 
                       ,accdocm_lst_upd_dt 
                       ,accdocm_deleted_ind
                       )
                       VALUES
                       (@l_accdocm_id
                       ,@l_accdocm_doc_id
                       ,@l_clicm_id
                       ,@l_enttm_id
                       ,@@c_excpm_id 
                       ,@pa_accdocm_cd
                       ,@pa_accdocm_desc
                       ,@pa_accdocm_acct_type
                       ,@pa_accdocm_rmks
                       ,@l_mnd_flg
                       ,@pa_login_name
                       ,getdate()
                       ,@pa_login_name
                       ,getdate()
                       ,1
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
                   END
                   IF @l_exists = 1
                   BEGIN
                   --
                     BEGIN TRANSACTION
                    
                     UPDATE account_document_mstr  with(rowlock)
                     SET    accdocm_cd           = upper(@pa_accdocm_cd)
                          , accdocm_desc         = @pa_accdocm_desc
                          , accdocm_acct_type    = @pa_accdocm_acct_type
                          , accdocm_rmks         = @pa_accdocm_rmks
                          , accdocm_mdty         = @l_mnd_flg
                          , accdocm_lst_upd_by   = @pa_login_name
                          , accdocm_lst_upd_dt   = getdate()
                          , accdocm_deleted_ind  = 1   --after remove then insert same record--tushar.13.03.2007
                     WHERE  accdocm_doc_id       = @pa_accdocm_doc_id
                     AND    accdocm_clicm_id     = @l_clicm_id
                     AND    accdocm_enttm_id     = @l_enttm_id
                     AND    accdocm_excpm_id     = @@c_excpm_id
                     AND    accdocm_deleted_ind  = 1

                     --
                     SET @l_error = @@error
                     --
                     IF @l_error > 0
                     BEGIN
                     --
                       ROLLBACK TRANSACTION
                     --
                       SET @l_errorstr = convert(varchar, @l_error)+@rowdelimiter
                     END
                     ELSE
                     BEGIN
                     --
                       COMMIT TRANSACTION
                     --
                     END
                     --
                    --
                   END -- @L_EXISTS
                 --
                 END --CD
                 ELSE
                 BEGIN
                 --
                   SET @l_errorstr = 'one or all of the parameters is/are null'
                 --
                 END
                --
                END --@l_mnd_flg=1 or @l_mnd_flg=0
                ELSE IF @l_mnd_flg=2
                BEGIN
                --

                  IF EXISTS(SELECT *
                            FROM   account_document_mstr        accdocm
                            WHERE  accdocm.accdocm_doc_id     = @pa_accdocm_doc_id
                            AND    accdocm.accdocm_clicm_id   = @l_clicm_id
                            AND    accdocm.accdocm_enttm_id   = @l_enttm_id
                            AND    accdocm.accdocm_excpm_id   = @@c_excpm_id 
                            AND    accdocm.accdocm_deleted_ind= 1)
                  BEGIN
                  --
                   BEGIN TRANSACTION
                   --

                     UPDATE account_document_mstr  WITH(ROWLOCK)
                     SET    accdocm_deleted_ind = 0
                          , accdocm_lst_upd_by  = @pa_login_name
                          , accdocm_lst_upd_dt  = getdate()
                     WHERE  accdocm_doc_id      = @pa_accdocm_doc_id
                     AND    accdocm_clicm_id    = @l_clicm_id
                     AND    accdocm_enttm_id    = @l_enttm_id
                     AND    accdocm_excpm_id    = @@c_excpm_id 
                    --
                    SET @l_error = @@error

                    IF @l_error > 0
                    BEGIN
                    --
                      ROLLBACK TRANSACTION
                    --
                      SET @l_errorstr = convert(varchar, @l_error)+@rowdelimiter
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
                  ELSE
                  BEGIN
                  --
                    SET @l_errorstr = 'one or all of the parameters is/are null'
                  --
                  END
                --
                END
                --
                FETCH NEXT FROM @@c_excpm INTO @@c_excpm_id
              --
              END --#CURSOR WHILE
            END --#4
            --
          END--#3
         END--#PA_ACTION IS NULL
        END --CKH_YN
        IF @pa_chk_yn=1
         BEGIN
         --
           IF @pa_action ='EDTMSTR'
           BEGIN
           --
             BEGIN TRANSACTION
           --
            
             UPDATE accdocm_mak  with (rowlock)
             SET    accdocm_deleted_ind = 2
                   ,accdocm_lst_upd_by  = @pa_login_name
                   ,accdocm_lst_upd_dt  = getdate()
             WHERE  accdocm_doc_id      = @pa_accdocm_doc_id
             AND    accdocm_deleted_ind = 0
           --
             SET @l_error = @@error
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
              
              
              UPDATE #t_accdocm
              SET    accdocm_cd         = @pa_accdocm_cd
                   , accdocm_desc       = @pa_accdocm_desc
                   , accdocm_rmks       = @pa_accdocm_rmks
                   , accdocm_created_by = @pa_login_name
                   , accdocm_created_dt = getdate()
                   , accdocm_lst_upd_by = @pa_login_name
                   , accdocm_lst_upd_dt = getdate()
              WHERE  accdocm_doc_id     = @pa_accdocm_doc_id
             
   
             
              
              INSERT INTO accdocm_mak
              (accdocm_id         
              ,accdocm_doc_id     
              ,accdocm_clicm_id   
              ,accdocm_enttm_id   
              ,accdocm_excpm_id   
              ,accdocm_cd         
              ,accdocm_desc       
              ,accdocm_acct_type  
              ,accdocm_rmks       
              ,accdocm_mdty       
              ,accdocm_created_by 
              ,accdocm_created_dt 
              ,accdocm_lst_upd_by 
              ,accdocm_lst_upd_dt 
              ,accdocm_deleted_ind
              )
              SELECT accdocm_id         
                    ,accdocm_doc_id     
                    ,accdocm_clicm_id   
                    ,accdocm_enttm_id   
                    ,accdocm_excpm_id   
                    ,accdocm_cd         
                    ,accdocm_desc       
                    ,accdocm_acct_type  
                    ,accdocm_rmks       
                    ,accdocm_mdty       
                    ,accdocm_created_by 
                    ,accdocm_created_dt 
                    ,accdocm_lst_upd_by 
                    ,accdocm_lst_upd_dt 
                    ,accdocm_deleted_ind
              FROM   #t_docm
              WHERE  accdocm_doc_id=@pa_accdocm_doc_id

             
              SET @l_error = @@error
            
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
             END
           END
           ELSE IF @pa_action='DELMSTR'
           BEGIN
           --
             UPDATE #t_accdoc_mstr
             SET    accdocm_deleted_ind = 4
             WHERE  accdocm_doc_id      = @pa_accdocm_doc_id
             AND    docm_deleted_ind    = 1
             
             
             INSERT INTO accdocm_mak
             (accdocm_id         
             ,accdocm_doc_id     
             ,accdocm_clicm_id   
             ,accdocm_enttm_id   
             ,accdocm_excpm_id   
             ,accdocm_cd         
             ,accdocm_desc       
             ,accdocm_acct_type  
             ,accdocm_rmks       
             ,accdocm_mdty       
             ,accdocm_created_by 
             ,accdocm_created_dt 
             ,accdocm_lst_upd_by 
             ,accdocm_lst_upd_dt 
             ,accdocm_deleted_ind
             )
             SELECT accdocm_id         
                   ,accdocm_doc_id     
                   ,accdocm_clicm_id   
                   ,accdocm_enttm_id   
                   ,accdocm_excpm_id   
                   ,accdocm_cd         
                   ,accdocm_desc       
                   ,accdocm_acct_type  
                   ,accdocm_rmks       
                   ,accdocm_mdty       
                   ,accdocm_created_by 
                   ,accdocm_created_dt 
                   ,accdocm_lst_upd_by 
                   ,accdocm_lst_upd_dt 
                   ,accdocm_deleted_ind
              FROM  #t_accdoc_mstr
              WHERE accdocm_doc_id      = @pa_accdocm_doc_id
             
          
           --
           END
           
           ELSE IF @pa_action='app'
           BEGIN
              
              
              SELECT @l_deleted_ind = isnull(accdocm_deleted_ind ,0)
              FROM   accdocm_mak
              WHERE  accdocm_id = convert(int, @@currstring_id)
              
              IF @l_deleted_ind = 4
              BEGIN
              --
                UPDATE accdocm_mak
                SET    accdocm_deleted_ind = 5
                     , accdocm_lst_upd_by  = @pa_login_name
                     , accdocm_lst_upd_dt  = getdate()
                WHERE  accdocm_doc_id      = convert(int, @@currstring_id)
                AND    accdocm_deleted_ind = 4  
              --
                 UPDATE account_document_mstr           
                 SET    accdocm_deleted_ind = 0
                      , accdocm_lst_upd_by  = @pa_login_name
                      , accdocm_lst_upd_dt  = getdate()
                 WHERE  accdocm_doc_id      = convert(int, @@currstring_id)
                 AND    accdocm_deleted_ind = 1
              --
              END
              ELSE IF @l_deleted_ind = 6
              BEGIN
              --
                UPDATE accdocm_mak
                SET    accdocm_deleted_ind = 7
                     , accdocm_lst_upd_by  = @pa_login_name
                     , accdocm_lst_upd_dt  = getdate()
                WHERE  accdocm_id          = convert(int, @@currstring_id)
                AND    accdocm_deleted_ind = 6
                --
                
                UPDATE account_document_mstr           
                SET    accdocm_deleted_ind = 0
                     , accdocm_lst_upd_by  = @pa_login_name
                     , accdocm_lst_upd_dt  = getdate()
                WHERE  accdocm_id          = convert(int, @@currstring_id)
                AND    accdocm_deleted_ind = 1
              --
              END
              ELSE IF EXISTS(SELECT accdocm_id
                             FROM   account_document_mstr  WITH(NOLOCK)
                             WHERE  accdocm_id            = convert(int, @@currstring_id)
                             AND    accdocm_deleted_ind   = 1)
                             
              BEGIN --#EXIST
              --
                BEGIN TRANSACTION
              --
                UPDATE accdocm WITH(ROWLOCK)
                SET    accdocm.accdocm_doc_id       = accdocmm.accdocm_doc_id
                     , accdocm.accdocm_cd           = accdocmm.accdocm_cd
                     , accdocm.accdocm_desc         = accdocmm.accdocm_desc
                     , accdocm.accdocm_rmks         = accdocmm.accdocm_rmks
                     , accdocm.accdocm_mdty         = accdocmm.accdocm_mdty
                     , accdocm.accdocm_lst_upd_by   = @pa_login_name
                     , accdocm.accdocm_lst_upd_dt   = getdate()
                     , accdocm.accdocm_deleted_ind  = 1
                FROM   account_document_mstr accdocm
                      ,accdocm_mak           accdocmm
                WHERE accdocm.accdocm_id     = convert(int, @@currstring_id)
                AND   accdocm.accdocm_deleted_ind  = 1
                AND   accdocmm.accdocm_deleted_ind = 0
                AND   accdocmm.accdocm_created_by <> @pa_login_name
              --
                SET @l_error = @@error
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
                  UPDATE accdocm_mak  with(rowlock)
                  SET    accdocm_deleted_ind = 1
                       , accdocm_lst_upd_by  = @pa_login_name
                       , accdocm_lst_upd_dt  = getdate()
                  WHERE  accdocm_id          = convert(int, @@currstring_id)
                  AND    accdocm_created_by <> @pa_login_name
                  AND    accdocm_deleted_ind = 0
                --
                  SET @l_error = @@error
                  IF @l_error> 0
                  BEGIN
                  --
                    ROLLBACK TRANSACTION
                  --
                    SET @l_errorstr = convert(varchar, @l_error)+@rowdelimiter
                  --
                  END
                  ELSE
                  BEGIN
                  --
                    COMMIT TRANSACTION
                  --
                  END
                  --
                END --#002
                --
              END  --#exist
              ELSE
              BEGIN --#not exist
              --
                BEGIN TRANSACTION
              --
                INSERT INTO account_document_mstr
                 (accdocm_id         
                 ,accdocm_doc_id     
                 ,accdocm_clicm_id   
                 ,accdocm_enttm_id   
                 ,accdocm_excpm_id   
                 ,accdocm_cd         
                 ,accdocm_desc       
                 ,accdocm_acct_type  
                 ,accdocm_rmks       
                 ,accdocm_mdty       
                 ,accdocm_created_by 
                 ,accdocm_created_dt 
                 ,accdocm_lst_upd_by 
                 ,accdocm_lst_upd_dt 
                 ,accdocm_deleted_ind
                 )
                 SELECT accdocmm.accdocm_id
                       ,accdocmm.accdocm_doc_id
                       ,accdocmm.accdocm_clicm_id
                       ,accdocmm.accdocm_enttm_id
                       ,accdocmm.accdocm_excpm_id
                       ,accdocmm.accdocm_cd
                       ,accdocmm.accdocm_desc
                       ,accdocmm.accdocm_acct_type
                       ,accdocmm.accdocm_rmks
                       ,accdocmm.accdocm_mdty
                       ,accdocmm.accdocm_created_by
                       ,accdocmm.accdocm_created_dt
                       ,@pa_login_name
                       ,getdate()
                       ,1
                  FROM  accdocm_mak                    accdocmm  with(nolock)
                  WHERE accdocmm.accdocm_id          = convert(int, @@currstring_id)
                  AND   accdocmm.accdocm_created_by  <> @pa_login_name
                  AND   accdocmm.accdocm_deleted_ind = 0
                  --
                  SET @l_error = @@error
                  IF @l_error> 0
                  BEGIN --#1
                  --
                    ROLLBACK TRANSACTION
    
                    SET @l_errorstr = CONVERT(VARCHAR, @l_error)+@rowdelimiter
                  --
                  END--#1
                  ELSE
                  BEGIN--#2
                  --
                    UPDATE accdocm_mak  with(rowlock)
                    SET    accdocm_deleted_ind = 1
                          ,accdocm_lst_upd_by  = @pa_login_name
                          ,accdocm_lst_upd_dt  = getdate()
                    WHERE accdocm_id           = convert(int,@@currstring_id)
                    AND   accdocm_created_by  <> @pa_login_name
                    AND   accdocm_deleted_ind  = 0
                    -- 
                    SET @l_error = @@error
                    IF @l_error > 0
                    BEGIN --#001
                    --
                      ROLLBACK TRANSACTION
                      SET @l_errorstr = convert(varchar, @l_error)+@rowdelimiter
                    --
                    END   --#001
                    ELSE
                    BEGIN--#002
                    --
                      COMMIT TRANSACTION
                    --
                    END  --#002
                    --
                  END --#2
                  --
              END  --#not exist
            END--APp
            ELSE IF @pa_action='REJ'
            BEGIN
            --
              BEGIN TRANSACTION
              --
               UPDATE accdocm_mak  with (rowlock)
               SET    accdocm_deleted_ind = 3
                     ,accdocm_lst_upd_by  = @pa_login_name
                     ,accdocm_lst_upd_dt  = getdate()
               WHERE  accdocm_id          = convert(int, @@currstring_id)
               AND    accdocm_deleted_ind in (0,4,6)
              --
              SET @l_error = @@error
              IF @l_error > 0
              BEGIN
              --
                ROLLBACK TRANSACTION
                SET @l_errorstr = convert(varchar, @l_error)+@rowdelimiter
              -- 
              END
              ELSE
              BEGIN
              --
                COMMIT TRANSACTION
              --
              END
              --
            END --REJ
            ELSE IF isnull(@pa_action,'')=''
            BEGIN
            --
              SET @@remainingstring_val = @pa_values
              WHILE @@remainingstring_val <> ''
              BEGIN--#3
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
               BEGIN--#4
               --
                 SET @l_exch_cd  = citrus_usr.fn_splitval(@@currstring_val,1)
                 SET @l_seg_cd   = citrus_usr.fn_splitval(@@currstring_val,2)
                 SET @l_prom_id  = convert(numeric, citrus_usr.fn_splitval(@@currstring_val,3))
                 SET @l_enttm_id = citrus_usr.fn_splitval(@@currstring_val,4)
                 SET @l_clicm_id = citrus_usr.fn_splitval(@@currstring_val,5)
                 SET @l_node     = citrus_usr.fn_splitval(@@currstring_val,6)
                 SET @l_mnd_flg  = case citrus_usr.fn_splitval(@@currstring_val,7) when 'm' then 1 when 'n' then 0 else 2 end
               --
                 SELECT top 1 @l_excpm_id     = excpm.excpm_id
                 FROM exch_seg_mstr excsm   with(nolock)
                    , excsm_prod_mstr excpm with(nolock)
                 WHERE excpm.excpm_excsm_id   = excsm.excsm_id
                 AND excsm.excsm_exch_cd      = @l_exch_cd
                 AND excsm.excsm_seg_cd       = @l_seg_cd
                 AND excpm.excpm_prom_id      = @l_prom_id
                 AND excsm_deleted_ind        = 1
                 AND excpm_deleted_ind        = 1 

                  IF isnull(@pa_accdocm_cd,'')<>''
                  BEGIN
                  --
                    IF @l_mnd_flg=1 or @l_mnd_flg=0
                    BEGIN
                    --
                      SELECT @l_accdocm_doc_id            = isnull(accdocmm.accdocm_doc_id,0)
                      FROM   accdocm_mak                    accdocmm
                      WHERE  accdocmm.accdocm_cd          = @pa_accdocm_cd
                      AND    accdocmm.accdocm_deleted_ind IN (1,0)

                      IF @l_accdocm_doc_id=0
                      BEGIN
                      --
                        SELECT @l_accdocm_doc_id      = isnull(max(accdocm.accdocm_doc_id), 0)
                        FROM   account_document_mstr    accdocm
                        WHERE  accdocm.accdocm_cd     = @pa_accdocm_cd
                        AND    accdocm.accdocm_deleted_ind in (0,1);
                      --
                      END
                      IF @l_accdocm_doc_id = 0
                      BEGIN
                      --
                        SELECT @l_accdocm_doc_id_mak=isnull(max(accdocmm.accdocm_doc_id), 0) + 1
                        FROM   accdocm_mak  accdocmm
                        --
                        SELECT @l_accdocm_doc_id=isnull(max(accdocm.accdocm_doc_id), 0) + 1
                        FROM   account_document_mstr  accdocm
                        --
                        IF @l_accdocm_doc_id_mak>@l_accdocm_doc_id
                        BEGIN
                        --
                          SET @l_accdocm_doc_id=@l_accdocm_doc_id_mak
                        -- 
                        END
                        -- 
                       END --@l_docm_doc_id = 0
          
                       IF EXISTS(SELECT * FROM   accdocm_mak accdocmm
                       WHERE  accdocmm.accdocm_doc_id      = @l_accdocm_doc_id
                       AND    accdocmm.accdocm_clicm_id    = @l_clicm_id
                       AND    accdocmm.accdocm_enttm_id    = @l_enttm_id
                       AND    accdocmm.accdocm_excpm_id    = @l_excpm_id
                       AND    accdocmm.accdocm_deleted_ind = 0)
                       BEGIN
                       --
                         SET @l_exists = 1
                       --
                       END
                       ELSE
                       BEGIN
                       --
                         SET @l_exists = 0
                       --
                       END
                       
                       IF @l_exists=0
                       BEGIN
                       --
                         BEGIN TRANSACTION

                         SELECT @l_accdocmm_id = isnull(max(accdocm_id),0)+1
                         FROM    accdocm_mak
                         
                         SELECT @l_accdocm_id = isnull(max(accdocm_id),0)+1
                         FROM   account_document_mstr
                         
                         IF @l_accdocmm_id>@l_accdocm_id
                         BEGIN
                         --
                           SET @l_accdocm_id = @l_accdocmm_id
                         --
                         END

                         INSERT INTO accdocm_mak
                         (accdocm_id         
                         ,accdocm_doc_id     
                         ,accdocm_clicm_id   
                         ,accdocm_enttm_id   
                         ,accdocm_excpm_id   
                         ,accdocm_cd         
                         ,accdocm_desc       
                         ,accdocm_acct_type  
                         ,accdocm_rmks       
                         ,accdocm_mdty       
                         ,accdocm_created_by 
                         ,accdocm_created_dt 
                         ,accdocm_lst_upd_by 
                         ,accdocm_lst_upd_dt 
                         ,accdocm_deleted_ind
                         )
                         VALUES
                         (@l_accdocm_id
                         ,@l_accdocm_doc_id
                         ,@l_clicm_id
                         ,@l_enttm_id
                         ,@l_excpm_id
                         ,@pa_accdocm_cd
                         ,@pa_accdocm_desc
                         ,@pa_accdocm_acct_type
                         ,@pa_accdocm_rmks
                         ,@l_mnd_flg
                         ,@pa_login_name 
                         ,getdate()
                         ,@pa_login_name
                         ,getdate()
                         ,0
                         )
                         --
                           set @l_error = @@error
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
                       END --exist=0
                       IF @l_exists=1
                       BEGIN
                       --
                         BEGIN TRANSACTION
                       --
                         UPDATE accdocm_mak     with (rowlock)
                         SET    accdocm_deleted_ind = 2
                               ,accdocm_lst_upd_by  = @pa_login_name
                               ,accdocm_lst_upd_dt  = getdate()
                         WHERE  accdocm_doc_id      = @l_accdocm_doc_id
																									AND    accdocm_clicm_id    = @l_clicm_id
																									AND    accdocm_enttm_id    = @l_enttm_id
																									AND    accdocm_excpm_id    = @l_excpm_id
                         AND    accdocm_deleted_ind = 0
                       --
                         SET @l_error = @@error
                         IF @l_error> 0
                         BEGIN
                         --
                           ROLLBACK TRANSACTION
                         --
                           set @l_errorstr = convert(varchar, @l_error)+@rowdelimiter
                         --
                         END
                         ELSE
                         BEGIN
                         --
                           SELECT @l_accdocm_id = isnull(max(accdocm_id),0)+1
                           FROM   accdocm_mak

                           INSERT INTO accdocm_mak
                           (accdocm_id         
                           ,accdocm_doc_id     
                           ,accdocm_clicm_id   
                           ,accdocm_enttm_id   
                           ,accdocm_excpm_id   
                           ,accdocm_cd         
                           ,accdocm_desc       
                           ,accdocm_acct_type  
                           ,accdocm_rmks       
                           ,accdocm_mdty       
                           ,accdocm_created_by 
                           ,accdocm_created_dt 
                           ,accdocm_lst_upd_by 
                           ,accdocm_lst_upd_dt 
                           ,accdocm_deleted_ind
                           ) 
                           VALUES
                           (@l_accdocm_id
                           ,@l_accdocm_doc_id
                           ,@l_clicm_id
                           ,@l_enttm_id
                           ,@l_excpm_id
                           ,@pa_accdocm_cd
                           ,@pa_accdocm_desc
                           ,@pa_accdocm_acct_type
                           ,@pa_accdocm_rmks
                           ,@l_mnd_flg
                           ,@pa_login_name 
                           ,getdate()
                           ,@pa_login_name
                           ,getdate()
                           ,0
                           )
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
                         END
                         --
                       END--Exist=1
                       ELSE
                       BEGIN
                       --
                         SET @l_errorstr = 'one or all of the parameters is/are null'
                       --
                       END
                  --
                  END
                  ELSE IF @l_mnd_flg=2
                  BEGIN
                  --
                    BEGIN TRANSACTION
                    --
                    SELECT @l_accdocm_id     = isnull(accdocm_id ,0)
                    FROM  account_document_mstr 
                    WHERE accdocm_doc_id     = @pa_accdocm_doc_id
                    AND   accdocm_enttm_id   = @l_enttm_id
                    AND   accdocm_clicm_id   = @l_clicm_id
                    AND   accdocm_excpm_id   = @l_excpm_id
                    AND   accdocm_deleted_ind= 1
                   
                    IF @l_accdocm_id<>0
                    BEGIN
                    --
                      INSERT INTO accdomc_mak
                      (accdocm_id         
                      ,accdocm_doc_id     
                      ,accdocm_clicm_id   
                      ,accdocm_enttm_id   
                      ,accdocm_excpm_id   
                      ,accdocm_cd         
                      ,accdocm_desc       
                      ,accdocm_acct_type  
                      ,accdocm_rmks       
                      ,accdocm_mdty       
                      ,accdocm_created_by 
                      ,accdocm_created_dt 
                      ,accdocm_lst_upd_by 
                      ,accdocm_lst_upd_dt 
                      ,accdocm_deleted_ind
                      )
                      VALUES
                      ( @l_accdocm_id
                      , @pa_accdocm_doc_id
                      , @l_clicm_id
                      , @l_enttm_id
                      , @l_excpm_id
                      , @pa_accdocm_cd
                      , @pa_accdocm_desc
                      , @pa_accdocm_acct_type
                      , @pa_accdocm_rmks
                      , @l_mnd_flg 
                      , @pa_login_name, getdate(), @pa_login_name, getdate(), 6
                      )
                    --
                    END
                    ELSE
                    BEGIN
                    --
                      UPDATE accdocm_mak  with (rowlock)
                      SET    accdocm_deleted_ind = 6
                            ,accdocm_lst_upd_by  = @pa_login_name
                            ,accdocm_lst_upd_dt  = getdate()
                      WHERE accdocm_doc_id=@pa_accdocm_doc_id
                      AND   accdocm_enttm_id= @l_enttm_id
                      AND   accdocm_clicm_id= @l_clicm_id
                      AND   accdocm_excpm_id= @l_excpm_id
                    --
                    END
                    IF @@error > 0
                    BEGIN
                    --
                      ROLLBACK TRANSACTION
                      SET @l_errorstr = convert(varchar, @l_error)+@rowdelimiter
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
                  ELSE
                  BEGIN
                  --
                    SET @l_errorstr = 'one or all of the parameters is/are null'
                  --
                  END
                 --
               END--CD
              --
             END --#4
            --
           END--#3
         END
        --
       END
       --
      END--#2
       --
    END--#1

    IF isnull(rtrim(ltrim(@l_errorstr)),'') = ''
    BEGIN
    --
      SET @l_errorstr = 'documents successfully inserted\edited '+ @rowdelimiter
    --
    END
    ELSE
    BEGIN
    --
      SET @pa_errmsg = @l_errorstr
    --
    END

END --main begin

GO
