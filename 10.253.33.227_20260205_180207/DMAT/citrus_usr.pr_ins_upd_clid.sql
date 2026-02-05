-- Object: PROCEDURE citrus_usr.pr_ins_upd_clid
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--7	pr_ins_upd_clid					add # in error message

CREATE       PROCEDURE [citrus_usr].[pr_ins_upd_clid](@pa_id                varchar(8000)
                               ,@pa_action            varchar(20)
                               ,@pa_login_name        varchar(20)
                               ,@pa_ent_id            numeric
                               ,@pa_VALUES            varchar(8000)
                               ,@pa_chk_yn            numeric
                               ,@rowdelimiter         char(4)  =  '*|~*'
                               ,@coldelimiter         char(4)  = '|*~|'
                               ,@pa_msg               varchar(8000) output
)
AS
/*
*********************************************************************************
 system         : class
 module name    : pr_ins_upd_clid
 description    : this procedure will add new VALUES to  client_documents
 copyright(c)   : enc software solutions pvt. ltd.
 version history:
 vers.  author           date        reason
 -----  -------------   ----------   -------------------------------------------------
 1.0    hari r         04-oct-2006   initial version.
 2.0    sukhi/tushar   26-dec-2006   error rectification
 3.0    sukhi/tushar   02-feb-2007   addition of new field "clid_doc_path"
 4.0    sukhi/tushar   15-feb-2007   'ins' action commented out
-----------------------------------------------------------------------------------*/
BEGIN
 --
 SET NOCOUNT ON
 --
 DECLARE @@t_errorstr         varchar(8000)
       , @l_cmconcm_id        bigint
       , @l_concm_id          bigint
       , @@l_error            bigint
       , @delimeter           varchar(10)
       , @@remainingstring    varchar(8000)
       , @@currstring         varchar(8000)
       , @@remainingstring2   varchar(8000)
       , @@currstring2        varchar(8000)
       , @@foundat            integer
       , @@delimeterlength    int
       , @l_counter           int
       --
       , @@l_clid_docm_doc_id numeric
       , @@l_clid_valid_yn    int
       , @@l_clid_remarks     varchar(8000)
       , @@l_clid_doc_path    varchar(500)
       , @@l_clid_crn_no      numeric
       --
       , @l_clid_docm_doc_id  numeric
       , @l_clid_valid_yn     int
       , @l_clid_remarks      varchar(8000)
       , @l_clid_doc_path     varchar(500)
       --
       , @@l_deleted_ind      int
       , @l_clid_id           numeric
       , @l_action            char(1)  
       , @l_crn_no            varchar(10)     
       ,@L_EDT_DEL_ID         NUMERIC
  --
  SET @l_counter    = 1
  SET @@l_error     = 0
  SET @@t_errorstr  = ''
  SET @l_crn_no    = CONVERT(VARCHAR, @pa_ent_id)
  --
  IF @pa_action = 'APP' or @pa_action = 'REJ'
  BEGIN--temp_app
  --
    CREATE TABLE #t_recordset2
    (clid_id            numeric 
    ,clid_crn_no        numeric
    ,clid_docm_doc_id   numeric
    ,clid_valid_yn      int
    ,clid_remarks       varchar(20)
    ,clid_doc_path      varchar(500)
    ,clid_deleted_ind   int
    ,clid_created_by    varchar(25)
    )
    --
    INSERT INTO #t_recordset2
    (clid_id 
    ,clid_crn_no
    ,clid_docm_doc_id
    ,clid_valid_yn
    ,clid_remarks
    ,clid_doc_path
    ,clid_deleted_ind
    ,clid_created_by
    )
    SELECT clid_id 
         , clid_crn_no
         , clid_docm_doc_id
         , clid_valid_yn
         , clid_remarks
         , clid_doc_path
         , clid_deleted_ind
         , clid_created_by
    FROM   client_documents_mak with (nolock)
    WHERE  clid_deleted_ind   in (0,4,8)
    --AND    clid_created_by    <> @pa_login_name
  --
  END--temp_app
  ELSE
  BEGIN--temp
  --
    CREATE TABLE #t_recordset
    (clid_crn_no        numeric
    ,clid_docm_doc_id   numeric
    ,clid_valid_yn      int
    ,clid_remarks       varchar(20)
    ,clid_doc_path      varchar(500)
    ,clid_deleted_ind   int
    ,clid_created_by    varchar(25)
    )
    --
    INSERT INTO #t_recordset
    (clid_crn_no
    ,clid_docm_doc_id
    ,clid_valid_yn
    ,clid_remarks
    ,clid_doc_path
    ,clid_deleted_ind
    ,clid_created_by
    )
    SELECT clid_crn_no
         , clid_docm_doc_id
         , clid_valid_yn
         , clid_remarks
         , clid_doc_path
         , clid_deleted_ind
         , clid_created_by
    FROM   client_documents WITH (NOLOCK)
    WHERE  clid_crn_no   = @pa_ent_id
  --
  END--temp
  --
  SET @delimeter             = '%'+ @rowdelimiter + '%'
  SET @@delimeterlength      = len(@rowdelimiter)
  SET @@remainingstring2     = @pa_id
  SET @@remainingstring      = @pa_VALUES
  --
  
  WHILE @@remainingstring2 <> ''
  BEGIN
    --
    SET @@foundat            = 0
    SET @@foundat            =  patindex('%'+@delimeter+'%',@@remainingstring2)
    --
    IF @@foundat > 0
    BEGIN
      --
      SET @@currstring2      = substring(@@remainingstring2, 0,@@foundat)
      SET @@remainingstring2 = substring(@@remainingstring2, @@foundat+@@delimeterlength,len(@@remainingstring2)- @@foundat+@@delimeterlength)
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
    IF isnull(@@currstring2,'') <> ''
    BEGIN--currstring2
    --
      IF @pa_action <> 'APP' AND @pa_action <> 'REJ'
      BEGIN--not_app_rej
      --
        WHILE @@remainingstring <> ''
        BEGIN
          --
          SET @@foundat        = 0
          SET @@foundat        =  patindex('%'+@delimeter+'%',@@remainingstring)
          --
          IF @@foundat > 0
          BEGIN
            --
            SET @@currstring      = substring(@@remainingstring, 0,@@foundat)
            SET @@remainingstring = substring(@@remainingstring, @@foundat+@@delimeterlength,len(@@remainingstring)- @@foundat+@@delimeterlength)
            --
          END
          ELSE
          BEGIN
           --
            SET @@currstring      = @@remainingstring
            SET @@remainingstring = ''
            --
          END
          --
          IF @@currstring <> ''
          BEGIN
          --
            SET @@l_clid_docm_doc_id = citrus_usr.fn_splitval(@@currstring, 1)
            SET @@l_clid_valid_yn    = citrus_usr.fn_splitval(@@currstring, 2)
            SET @@l_clid_remarks     = citrus_usr.fn_splitval(@@currstring, 3)
            SET @@l_clid_doc_path    = citrus_usr.fn_splitval(@@currstring, 4)
            --
            IF @pa_chk_yn = 0
            BEGIN--chk_yn_0
            --
              IF @pa_action = 'EDT'
              BEGIN--edt_0  
              --
                IF EXISTS(SELECT clid_crn_no
                          FROM   client_documents WITH(NOLOCK)
                          WHERE  clid_crn_no      = @pa_ent_id
                          AND    clid_docm_doc_id = @@l_clid_docm_doc_id
                         )
                BEGIN
                --
                  SELECT @l_clid_docm_doc_id = clid_docm_doc_id
                        ,@l_clid_valid_yn    = clid_valid_yn
                        ,@l_clid_remarks     = clid_remarks
                        ,@l_clid_doc_path    = clid_doc_path
                  FROM   #t_recordset
                  WHERE  clid_crn_no         = @pa_ent_id
                  AND    clid_docm_doc_id    = @@l_clid_docm_doc_id
                  --
                  IF (@l_clid_docm_doc_id    = @@l_clid_docm_doc_id)
                      AND (@l_clid_valid_yn  = @@l_clid_valid_yn)
                      AND (@l_clid_remarks   = @@l_clid_remarks)
                      AND (@l_clid_doc_path  = @@l_clid_doc_path)
                  BEGIN
                  --
                    DELETE FROM #t_recordset
                    WHERE  clid_crn_no       = @pa_ent_id
                    AND    clid_docm_doc_id  = @@l_clid_docm_doc_id
                  --
                  END
                  ELSE
                  BEGIN
                  --
                    BEGIN TRANSACTION
                    --
                    UPDATE client_documents  WITH (ROWLOCK)
                    SET    clid_valid_yn     = @@l_clid_valid_yn
                         , clid_remarks      = @@l_clid_remarks
                         , clid_lst_upd_by   = @pa_login_name
                         , clid_lst_upd_dt   = GETDATE()
                         , clid_doc_path     = @@l_clid_doc_path
                    WHERE  clid_crn_no       = @pa_ent_id
                    AND    clid_docm_doc_id  = @@l_clid_docm_doc_id
                    AND    clid_deleted_ind  = 1
                    --
                    SET @@l_error = @@error
                    --
                    IF @@l_error > 0
                    BEGIN
                    --
                      SET @@t_errorstr = '#'+CONVERT(VARCHAR, @@l_clid_docm_doc_id)+' could not be added to the entity'+@rowdelimiter+@@t_errorstr
                      --
                      ROLLBACK TRANSACTION
                    --
                    END
                    ELSE
                    BEGIN
                    --
                      DELETE FROM #t_recordset
                      WHERE  clid_crn_no    = @pa_ent_id
                      AND  clid_docm_doc_id = @@l_clid_docm_doc_id
                      --
                      COMMIT TRANSACTION
                    --
                    END
                  --
                  END
                --
                END--exists
                ELSE
                BEGIN--not_exist
                --
                  BEGIN TRANSACTION
                  --
                  INSERT INTO client_documents
                  (clid_crn_no
                  ,clid_docm_doc_id
                  ,clid_valid_yn
                  ,clid_remarks
                  ,clid_created_by
                  ,clid_created_dt
                  ,clid_lst_upd_by
                  ,clid_lst_upd_dt
                  ,clid_deleted_ind
                  ,clid_doc_path
                  )
                  VALUES
                  (@pa_ent_id
                  ,@@l_clid_docm_doc_id
                  ,@@l_clid_valid_yn
                  ,@@l_clid_remarks
                  ,@pa_login_name
                  ,getdate()
                  ,@pa_login_name
                  ,getdate()
                  ,1
                  ,@@l_clid_doc_path
                  )
                  --
                  SET @@l_error = @@ERROR
                  --
                  IF @@l_error > 0
                  BEGIN
                  --
                    SET @@t_errorstr = '#'+CONVERT(VARCHAR, @@l_clid_docm_doc_id)+' could not be added to the entity'+@rowdelimiter+@@t_errorstr
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
                END --not_exist
              --
              END --edt_0
              --
              IF @pa_action = 'INS'
              BEGIN--ins
              --
                BEGIN TRANSACTION
                --
                INSERT INTO client_documents
                (clid_crn_no
                ,clid_docm_doc_id
                ,clid_valid_yn
                ,clid_remarks
                ,clid_created_by
                ,clid_created_dt
                ,clid_lst_upd_by
                ,clid_lst_upd_dt
                ,clid_deleted_ind
                ,clid_doc_path
                )
                VALUES
                (@pa_ent_id
                ,@@l_clid_docm_doc_id
                ,@@l_clid_valid_yn
                ,@@l_clid_remarks
                ,@pa_login_name
                ,getdate()
                ,@pa_login_name
                ,getdate()
                ,1
                ,@@l_clid_doc_path
                )
                --
                SET @@l_error = @@ERROR
                --
                IF @@l_error > 0
                BEGIN
                --
                  SET @@t_errorstr = '#'+CONVERT(VARCHAR, @@l_clid_docm_doc_id)+' could not be added to the entity'+@rowdelimiter+@@t_errorstr
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
              END--ins
              --
              IF @pa_action = 'DEL'
              BEGIN--del
              --
                BEGIN TRANSACTION
                --
                UPDATE client_documents  WITH (ROWLOCK)
                SET    clid_deleted_ind  = 0
                     , clid_lst_upd_by   = @pa_login_name
                     , clid_lst_upd_dt   = getdate()
                WHERE  clid_crn_no       = @pa_ent_id
                AND    clid_docm_doc_id  = @@l_clid_docm_doc_id
                AND    clid_deleted_ind  = 1
                --
                SET @@l_error = @@error
                --
                IF @@l_error > 0
                BEGIN
                --
                  SET @@t_errorstr = '#'+CONVERT(varchar, @@l_clid_docm_doc_id)+' could not be added to the entity'+@rowdelimiter+@@t_errorstr
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
              END--del
            --
            END --chk_yn_0
            --
            IF @pa_chk_yn = 1 or @pa_chk_yn = 2
            BEGIN--chk_yn_1
            --
              IF @pa_action IN ('INS','EDT','DEL')
              BEGIN
              --
                IF EXISTS(SELECT clid_id
                          FROM   client_documents_mak WITH(NOLOCK)
                          WHERE  clid_crn_no      = @pa_ent_id
                          AND    clid_docm_doc_id = @@l_clid_docm_doc_id
                         )
                BEGIN--exts
                --
                  BEGIN TRANSACTION
                  --
                  UPDATE client_documents_mak 
                  SET    clid_deleted_ind  = 3
                        ,clid_lst_upd_by   = @pa_login_name
                        ,clid_lst_upd_dt   = GETDATE()
                  WHERE  clid_crn_no       = @pa_ent_id
                  AND    clid_docm_doc_id  = @@l_clid_docm_doc_id
                  AND    clid_deleted_ind IN (0,4,8)
                  --
                  SET @@l_error = @@error
                  --
                  IF @@l_error > 0
                  BEGIN
                  --
                    SET @@t_errorstr = '#'+CONVERT(varchar, @@l_clid_docm_doc_id)+' could not be added to the entity'+@rowdelimiter+@@t_errorstr
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
                --
                IF EXISTS(SELECT clid_crn_no FROM client_documents WHERE  clid_crn_no = @pa_ent_id AND clid_docm_doc_id = @@l_clid_docm_doc_id) 
                BEGIN
                --
                  SET @L_EDT_DEL_ID = 8
                --
                END
                ELSE
                BEGIN
                --
                  SET @L_EDT_DEL_ID = 0
                --
                END
                
                SELECT @l_clid_id = ISNULL(MAX(clid_id),0) + 1
                FROM   client_documents_mak WITH (NOLOCK)
                --
                BEGIN TRANSACTION
                --
                INSERT INTO client_documents_mak
                (clid_id
                ,clid_crn_no
                ,clid_docm_doc_id
                ,clid_valid_yn
                ,clid_remarks
                ,clid_created_by
                ,clid_created_dt
                ,clid_lst_upd_by
                ,clid_lst_upd_dt
                ,clid_deleted_ind
                ,clid_doc_path
                )
                VALUES
                (@l_clid_id
                ,@pa_ent_id
                ,@@l_clid_docm_doc_id
                ,@@l_clid_valid_yn
                ,@@l_clid_remarks
                ,@pa_login_name
                ,getdate()
                ,@pa_login_name
                ,getdate()
                ,CASE @pa_action WHEN 'INS' then 0
                                 WHEN 'EDT' then @L_EDT_DEL_ID                   
                                 WHEN 'DEL' then 4
                                 END
                ,@@l_clid_doc_path
                )
                --
                SET @@l_error = @@error
                --
                IF @@l_error > 0
                BEGIN
                --
                  SET @@t_errorstr = '#'+CONVERT(VARCHAR, @@l_clid_docm_doc_id)+' could not be added to the entity'+@rowdelimiter+@@t_errorstr
                  --
                  ROLLBACK TRANSACTION
                --
                END
                ELSE
                BEGIN
                --
                  SELECT @l_action = CASE @pa_action WHEN 'INS' THEN 'I' WHEN 'EDT' THEN 'E' WHEN 'DEL' THEN 'D' END
                  --
                  EXEC pr_ins_upd_list @l_crn_no, @l_action,'Client Documents', @pa_login_name,'*|~*','|*~|','' 
                  --
                  COMMIT TRANSACTION
                --
                END 
              --
              END
            --
            END
          --
          END --@@currstring
        --
        END --while @@remainingstring
      --  
      END--not_app_rej
      ELSE
      BEGIN--app_rej
      --
        IF @pa_action = 'REJ'
        BEGIN--rej
        --
         
          --
          UPDATE client_documents_mak with (rowlock)
          SET    clid_deleted_ind  = 3
          WHERE  clid_id           = CONVERT(numeric, @@currstring2)
          AND    clid_deleted_ind in (0,4,8)
          --
          SET @@l_error = @@error
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
        BEGIN--app
        --
          SET @@l_clid_crn_no         = null
          SET @@l_clid_docm_doc_id    = null
          SET @@l_deleted_ind         = null
          SET @@l_clid_remarks        = null
          SET @@l_clid_doc_path       = null
          --
          SELECT @@l_clid_crn_no      = clid_crn_no   
               , @@l_clid_docm_doc_id = clid_docm_doc_id
               , @@l_clid_valid_yn    = clid_valid_yn
               , @@l_clid_remarks     = clid_remarks
               , @@l_clid_doc_path    = clid_doc_path 
               , @@l_deleted_ind      = clid_deleted_ind
          FROM   #t_recordset2
          WHERE  clid_id              = CONVERT(numeric, @@currstring2)
          -- 
          select * from #t_recordset2         
          print   @@l_deleted_ind     
          IF @@l_deleted_ind = 4
          BEGIN--4
          --
            
            --
            UPDATE client_documents_mak WITH (ROWLOCK)
            SET    clid_deleted_ind   = 5
                 , clid_lst_upd_by    = @pa_login_name
                 , clid_lst_upd_dt    = getdate()
            WHERE  clid_deleted_ind   = 4
            AND    clid_id            = CONVERT(numeric, @@currstring2)
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
            UPDATE client_documents     WITH (ROWLOCK)
            SET    clid_deleted_ind   = 0
                 , clid_lst_upd_by    = @pa_login_name
                 , clid_lst_upd_dt    = getdate()
            WHERE  clid_deleted_ind   = 1
            AND    clid_crn_no        = @@l_clid_crn_no   
            AND    clid_docm_doc_id   = @@l_clid_docm_doc_id
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
           
          --
          END--4
          --
          IF @@l_deleted_ind = 8
          BEGIN--8
          -- 
           
            --
            UPDATE client_documents_mak  WITH(ROWLOCK)
            SET    clid_deleted_ind    = 9
                 , clid_lst_upd_by     = @pa_login_name
                 , clid_lst_upd_dt     = getdate()
            WHERE  clid_deleted_ind    = 8
            AND    clid_id             = CONVERT(numeric, @@currstring2)
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
            UPDATE client_documents     WITH(ROWLOCK)
            SET    clid_crn_no        = @@l_clid_crn_no   
                 , clid_docm_doc_id   = @@l_clid_docm_doc_id
                 , clid_valid_yn      = @@l_clid_valid_yn
                 , clid_remarks       = @@l_clid_remarks
                 , clid_doc_path      = @@l_clid_doc_path 
                 , clid_lst_upd_by    = @pa_login_name
                 , clid_lst_upd_dt    = getdate()
            WHERE  clid_deleted_ind   = 1
            AND    clid_crn_no        = @@l_clid_crn_no   
            AND    clid_docm_doc_id   = @@l_clid_docm_doc_id
            --
            SET @@l_error = @@error
            --
            IF @@l_error > 0
            BEGIN
            --
             
              SET @@t_errorstr = CONVERT(VARCHAR(10), @@l_error)
            --
            END
            --
            --COMMIT TRANSACTION
          --
          END--8
          --
          IF @@l_deleted_ind = 0
          BEGIN--0
          --
           
            --
            UPDATE client_documents_mak  WITH(ROWLOCK)
            SET    clid_deleted_ind    = 1
                 , clid_lst_upd_by     = @pa_login_name
                 , clid_lst_upd_dt     = getdate()
            WHERE  clid_deleted_ind    = 0
            AND    clid_id             = CONVERT(numeric, @@currstring2)

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
            INSERT INTO client_documents
            (clid_crn_no
            ,clid_docm_doc_id
            ,clid_valid_yn
            ,clid_remarks
            ,clid_created_by
            ,clid_created_dt
            ,clid_lst_upd_by
            ,clid_lst_upd_dt
            ,clid_deleted_ind
            ,clid_doc_path
            )
            VALUES
            (@@l_clid_crn_no
            ,@@l_clid_docm_doc_id
            ,@@l_clid_valid_yn
            ,@@l_clid_remarks
            ,@pa_login_name
            ,getdate()
            ,@pa_login_name
            ,getdate()
            ,1
            ,@@l_clid_doc_path
            )
            --
            SET @@l_error = @@ERROR
            --
            IF @@l_error > 0
            BEGIN
            --
              SET @@t_errorstr = CONVERT(VARCHAR(10), @@l_error)
              --
             
            --
            END
            --
            
          END--0
          --move to pr_app_client
          --EXEC pr_ins_upd_list @@l_clid_crn_no,'A','Client Documents',@pa_login_name,'*|~*','|*~|','' 
        -- 
        END--app 
      --  
      END--app_rej
    --  
    END --@@currstring2
    --
  END -- END while remainingstring2
  --
  IF ISNULL(RTRIM(LTRIM(@@t_errorstr)),'') = ''
   BEGIN
   --
     SET @pa_msg = 'Client documents successfully inserted/edited'+ @rowdelimiter
   --
   END
   ELSE
   BEGIN
   --
     SET @pa_msg = @@t_errorstr
   --
  END
  --SET @pa_msg = @@t_errorstr
--
END  --BEGIN END

GO
