-- Object: PROCEDURE citrus_usr.pr_ins_upd_accd
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------




--6	pr_ins_upd_accd					add # in error message
--select * from accd_mak where accd_clisba_id = 13
--
--begin tran
--EXEC pr_ins_upd_accd '25*|~*','APP','HO', 761998,'','','',null,1,'*|~*','|*~|','' 
--SELECT * FROM account_documents WHERE accd_clisba_id = 498446
--rollback 
--pr_ins_upd_accd '','INS','HO','13','567','D','12|*~|1|*~||*~|../CCRSDocuments/13_567_12isin0510|*~|*|~*11|*~|1|*~||*~|../CCRSDocuments/13_567_11pujari.txt|*~|*|~*',2,'*|~*','|*~|',''	
CREATE PROCEDURE [citrus_usr].[pr_ins_upd_accd](@pa_id  varchar(8000)
                                ,@pa_action            varchar(20)
                               ,@pa_login_name        varchar(20)
                               ,@pa_clisba_id         numeric
                               ,@pa_acct_no           varchar(25)
                               ,@pa_acct_type         varchar(20)
                               ,@pa_values            varchar(8000)
							  --,@pa_img varbinary(max)
							   ,@pa_img Image							                               
							   ,@pa_img_poa Image
							   ,@pa_chk_yn            numeric
                               ,@rowdelimiter         char(4)  = '*|~*'
                               ,@coldelimiter         char(4)  = '|*~|'
                               ,@pa_msg               varchar(8000) OUTPUT
)
AS
/*
*********************************************************************************
 system         : class
 module name    : pr_ins_upd_accd
 description    : this procedure will add new values to  Accounts_Documents
 copyright(c)   : Marketplace Technolgies pvt. Ltd.
 version history:
 VERS.  AUTHOR           DATE        REASON
 -----  -------------   ----------   -------------------------------------------------
 1.0    Sukhvinder      04-may-2007  initial version.
-----------------------------------------------------------------------------------*/
BEGIN--#1
--
  SET NOCOUNT ON
  --
  DECLARE @@delimeter                  char(4)
        , @@remainingstring_id         varchar(8000)
        , @@currstring_id              varchar(8000)
        , @@remainingstring_val        varchar(8000)
        , @@currstring_val             varchar(8000)
        , @@foundat                    integer
        , @@delimeterlength            int
        -- 
        , @@l_errorstr                 varchar(8000) 
        , @@l_error                    numeric
        --
        , @@l_accd_accdocm_cd          varchar(20)
        , @@l_accd_accdocm_doc_id      numeric (10)
        , @@l_accd_valid_yn            smallint  
        , @@l_accd_remarks             varchar(200) 
        , @@l_accd_doc_path            varchar(200)
        --
        , @@l_old_accd_accdocm_doc_id  numeric
        , @@l_old_accd_valid_yn        smallint  
        , @@l_old_accd_remarks         varchar(200)
        , @@l_old_accd_doc_path        varchar(200)
        , @@l_action                   char(3)
        , @@l_clisba_id                varchar(10)
        --
        , @@l_accd_id                  numeric 
        , @@l_accd_clisba_id           numeric
        , @@l_accd_acct_no             varchar(25)
        , @@l_accd_acct_type           varchar(20)
        , @@l_accd_deleted_ind         smallint
        , @L_EDT_DEL_ID                NUMERIC
        , @@l_accd_img             varbinary(max)    
        --, @@l_accd_img				   Image    

  -- 
  SET @@l_clisba_id = CONVERT(varchar, @pa_clisba_id)
  --
  IF @pa_action <> 'APP' or @pa_action = 'REJ'
  BEGIN--001
  --
    CREATE TABLE #account_documents_mstr 
    (accd_clisba_id       numeric(10)
    ,accd_acct_no         varchar(25)
    ,accd_acct_type       varchar(20)
    ,accd_accdocm_doc_id  numeric(10)
    ,accd_valid_yn        smallint
    ,accd_remarks         varchar(200)
    ,accd_doc_path        varchar(200)
    )
    --
    INSERT INTO #account_documents_mstr
    (accd_clisba_id     
    ,accd_acct_no       
    ,accd_acct_type     
    ,accd_accdocm_doc_id
    ,accd_valid_yn      
    ,accd_remarks       
    ,accd_doc_path      
    )
    SELECT accd_clisba_id
         , accd_acct_no
         , accd_acct_type
         , accd_accdocm_doc_id
         , accd_valid_yn
         , accd_remarks
         , accd_doc_path
    FROM   account_documents  WITH (NOLOCK)
    WHERE  accd_clisba_id   = @pa_clisba_id
    AND    accd_deleted_ind = 1 
  --  
  END--001
  ELSE
  BEGIN--002
  --
  
    CREATE TABLE #account_documents_mak
    (accd_id               numeric 
    ,accd_clisba_id        numeric
    ,accd_acct_no          varchar(25)
    ,accd_acct_type        varchar(20)
    ,accd_accdocm_doc_id   numeric(10)
    ,accd_valid_yn         smallint
    ,accd_remarks          varchar(200)
    ,accd_doc_path         varchar(200)
    ,accd_deleted_ind      smallint
,ACCD_BINARY_IMAGE varbinary(max)
    )
    --
    INSERT INTO #account_documents_mak
    ( accd_id 
    , accd_clisba_id
    , accd_acct_no
    , accd_acct_type
    , accd_accdocm_doc_id
    , accd_valid_yn
    , accd_remarks
    , accd_doc_path
    , accd_deleted_ind,ACCD_BINARY_IMAGE
    )
    SELECT accd_id
         , accd_clisba_id
         , accd_acct_no
         , accd_acct_type
         , accd_accdocm_doc_id
         , accd_valid_yn
         , accd_remarks
         , accd_doc_path
         , accd_deleted_ind,ACCD_BINARY_IMAGE
    FROM   accd_mak  ,dp_acct_mstr_mak           WITH (NOLOCK)
        WHERE  accd_deleted_ind  IN (0,4,8)
        and DPAM_ID = ACCD_CLISBA_ID 
        and dpam_crn_no   = @pa_clisba_id
        UNION
    SELECT accd_id
         , accd_clisba_id
         , accd_acct_no
         , accd_acct_type
         , accd_accdocm_doc_id
         , accd_valid_yn
         , accd_remarks
         , accd_doc_path
         , accd_deleted_ind,ACCD_BINARY_IMAGE
    FROM   accd_mak  ,dp_acct_mstr        WITH (NOLOCK)
        WHERE  accd_deleted_ind  IN (0,4,8)
        and DPAM_ID = ACCD_CLISBA_ID 
        and dpam_crn_no   = @pa_clisba_id
        AND NOT EXISTS(SELECT 1 FROM dp_acct_mstr_mak WHERE DPAM_ID= ACCD_CLISBA_ID)
    
  --
  END--002
  --
  SET @@delimeter              = '%'+@rowdelimiter+'%'
  SET @@delimeterlength        = LEN(@rowdelimiter)
  SELECT @@remainingstring_id  = case @pa_id WHEN '' THEN '0' ELSE @pa_id END
  SET @@remainingstring_val    = @pa_values
  --
  WHILE @@remainingstring_id <> ''
  BEGIN--rem_id
  --
    SET @@foundat            = 0
    SET @@foundat            =  PATINDEX('%'+@@delimeter+'%',@@remainingstring_id)
    --
    IF @@foundat > 0
    BEGIN
    --
      SET @@currstring_id      = SUBSTRING(@@remainingstring_id, 0,@@foundat)
      SET @@remainingstring_id = SUBSTRING(@@remainingstring_id, @@foundat+@@delimeterlength,len(@@remainingstring_id)- @@foundat+@@delimeterlength)
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
        BEGIN--rem_val
        --
          SET @@foundat        = 0
          SET @@foundat        =  PATINDEX('%'+@@delimeter+'%',@@remainingstring_val)
          --
          IF @@foundat > 0
          BEGIN
          --
            SET @@currstring_val      = SUBSTRING(@@remainingstring_val, 0,@@foundat)
            SET @@remainingstring_val = SUBSTRING(@@remainingstring_val, @@foundat+@@delimeterlength,len(@@remainingstring_val)- @@foundat+@@delimeterlength)
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
            SET @@l_accd_accdocm_doc_id = CONVERT(numeric, citrus_usr.fn_splitval(@@currstring_val, 1))
            SET @@l_accd_valid_yn       = CONVERT(smallint, citrus_usr.fn_splitval(@@currstring_val, 2))
            SET @@l_accd_remarks        = citrus_usr.fn_splitval(@@currstring_val, 3)
            SET @@l_accd_doc_path       = citrus_usr.fn_splitval(@@currstring_val, 4)
            --
            IF @pa_chk_yn = 0
            BEGIN--chk_yn_0
            --
              IF @pa_action = 'INS'
              BEGIN--ins_0  
              --
                BEGIN TRANSACTION
                --
                INSERT INTO account_documents
                (accd_clisba_id
                ,accd_acct_no
                ,accd_acct_type
                ,accd_accdocm_doc_id
                ,accd_valid_yn
                ,accd_remarks
                ,accd_doc_path
                ,accd_created_by
                ,accd_created_dt
                ,accd_lst_upd_by
                ,accd_lst_upd_dt
                ,accd_deleted_ind
                 ,ACCD_BINARY_IMAGE
                )
                VALUES
                (@pa_clisba_id  
                ,@pa_acct_no       
                ,@pa_acct_type     
                ,@@l_accd_accdocm_doc_id
                ,@@l_accd_valid_yn      
                ,@@l_accd_remarks       
                ,@@l_accd_doc_path      
                ,@pa_login_name
                ,GETDATE()
                ,@pa_login_name
                ,GETDATE()
                ,1
                --,@pa_img
                ,CASE @@l_accd_accdocm_doc_id when '12' then @pa_img
											  when '13' then @pa_img_poa 
											  end
                )
                --
                SET @@l_error = @@ERROR
                --
                IF @@l_error > 0
                BEGIN--#r
                --
                  SELECT @@l_accd_accdocm_cd = accdocm_cd
                  FROM   account_document_mstr WITH (NOLOCK)
                  WHERE  accdocm_doc_id      = @@l_accd_accdocm_doc_id
                  --
                  SET @@l_errorstr = '#'+CONVERT(varchar, @@l_accd_accdocm_cd)+' could not be added'+@rowdelimiter+@@l_errorstr
                  --
                  ROLLBACK TRANSACTION
                --
                END --#r
                ELSE
                BEGIN--#c
                --
                  COMMIT TRANSACTION
                --
                END--#c
              --
              END--ins_0
              --
              IF @pa_action = 'EDT'
              BEGIN--edt_0 
              
              --
                IF EXISTS(SELECT * 
                          FROM  #account_documents_mstr
                          WHERE accd_clisba_id        = @pa_clisba_id
                          AND   accd_accdocm_doc_id   = @@l_accd_accdocm_doc_id 
                         )
                BEGIN--exts
                --
                  
                  SELECT @@l_old_accd_accdocm_doc_id  =  accd_accdocm_doc_id
                       , @@l_old_accd_valid_yn        =  accd_valid_yn      
                       , @@l_old_accd_remarks         =  accd_remarks       
                       , @@l_old_accd_doc_path        =  accd_doc_path      
                  FROM   #account_documents_mstr      WITH (NOLOCK)
                  WHERE  accd_clisba_id               =  @pa_clisba_id
                  AND    accd_accdocm_doc_id          =  @@l_accd_accdocm_doc_id 
                  
                  --
                  IF (@@l_old_accd_accdocm_doc_id     =  @@l_accd_accdocm_doc_id
                     AND @@l_old_accd_valid_yn        =  @@l_accd_valid_yn      
                     AND @@l_old_accd_remarks         =  @@l_accd_remarks       
                     AND @@l_old_accd_doc_path        =  @@l_accd_doc_path)
                  BEGIN--#eq   
                  --
                     DELETE FROM #account_documents_mstr 
                     WHERE  accd_clisba_id            = @pa_clisba_id
                     AND    accd_accdocm_doc_id       = @@l_accd_accdocm_doc_id
                  --
                  END--#eq
                  ELSE
                  BEGIN--#n_eq
                  --
                    BEGIN TRANSACTION
                    --
                    UPDATE account_documents          WITH (ROWLOCK)
                    SET    accd_acct_no               =  @pa_acct_no       
                         , accd_acct_type             =  @pa_acct_type     
                         , accd_accdocm_doc_id        =  @@l_accd_accdocm_doc_id
                         , accd_valid_yn              =  @@l_accd_valid_yn      
                         , accd_remarks               =  @@l_accd_remarks       
                         , accd_doc_path              =  @@l_accd_doc_path
                         , accd_lst_upd_by            =  @pa_login_name
                         , accd_lst_upd_dt            =  GETDATE()
                         --,ACCD_BINARY_IMAGE         =  @pa_img
                         ,ACCD_BINARY_IMAGE			  = CASE @@l_accd_accdocm_doc_id when '12' then @pa_img
																					 when '13' then @pa_img_poa 
																					 end
                    WHERE  accd_clisba_id             =  @pa_clisba_id
                    AND    accd_accdocm_doc_id        =  @@l_accd_accdocm_doc_id
                    AND    accd_deleted_ind           =  1
                    --
                    SET @@l_error = @@ERROR
                    --
                    IF @@l_error > 0
                    BEGIN--#r
                    --
                      SET @@l_errorstr = '#'+CONVERT(varchar, @@l_accd_accdocm_cd)+' could not be added'+@rowdelimiter+@@l_errorstr
                      --
                      ROLLBACK TRANSACTION
                    --
                    END --#r
                    ELSE
                    BEGIN--#c
                    --
                      COMMIT TRANSACTION
                      --
                      DELETE FROM #account_documents_mstr 
                      WHERE  accd_clisba_id            = @pa_clisba_id
                      AND    accd_accdocm_doc_id       = @@l_accd_accdocm_doc_id
                    --
                    END--#c
                  --
                  END--#n_eq
                --
                END  --exts
                ELSE
                BEGIN--n_exts
                --
                  BEGIN TRANSACTION
                  --
                  INSERT INTO account_documents
                  (accd_clisba_id
                  ,accd_acct_no
                  ,accd_acct_type
                  ,accd_accdocm_doc_id
                  ,accd_valid_yn
                  ,accd_remarks
                  ,accd_doc_path
                  ,accd_created_by
                  ,accd_created_dt
                  ,accd_lst_upd_by
                  ,accd_lst_upd_dt
                  ,accd_deleted_ind
				,ACCD_BINARY_IMAGE
                  )
                  VALUES
                  (@pa_clisba_id  
                  ,@pa_acct_no       
                  ,@pa_acct_type     
                  ,@@l_accd_accdocm_doc_id
                  ,@@l_accd_valid_yn      
                  ,@@l_accd_remarks       
                  ,@@l_accd_doc_path      
                  ,@pa_login_name
                  ,GETDATE()
                  ,@pa_login_name
                  ,GETDATE()
                  ,1
				  --,@pa_img
				  ,CASE @@l_accd_accdocm_doc_id when '12' then @pa_img
											  when '13' then @pa_img_poa 
											  end
                  )
                  --
                  SET @@l_error = @@ERROR
                  --
                  IF @@l_error > 0
                  BEGIN--#r
                  --
                    SET @@l_errorstr = '#'+CONVERT(varchar, @@l_accd_accdocm_cd)+' could not be added'+@rowdelimiter+@@l_errorstr
                    --
                    ROLLBACK TRANSACTION
                  --
                  END --#r
                  ELSE
                  BEGIN--#c
                  --
                    COMMIT TRANSACTION
                  --
                  END--#c
                --
                END--n_exts
              --
              END  --edt_0
            --
            END--chk_yn_0
            --
            IF @pa_chk_yn = 1 or @pa_chk_yn = 2
            BEGIN--chk_1_2
            --
            PRINT 'PANKAJ'
            PRINT @@l_accd_accdocm_doc_id
              IF @pa_action IN ('INS','EDT','DEL')
              BEGIN--i_d_e
              --
                IF EXISTS(SELECT accd_id
                          FROM   accd_mak              WITH(NOLOCK)
                          WHERE  accd_clisba_id      = @pa_clisba_id
                          AND    accd_accdocm_doc_id = @@l_accd_accdocm_doc_id
                         )
                BEGIN--exts
                --
                  BEGIN TRANSACTION
                  --
                  UPDATE  accd_mak               WITH (ROWLOCK)
                  SET     accd_deleted_ind     = 3
                        , accd_lst_upd_by      = @pa_login_name
                        , accd_lst_upd_dt      = GETDATE()
                  WHERE   accd_clisba_id       = @pa_clisba_id
                  AND     accd_accdocm_doc_id  = @@l_accd_accdocm_doc_id
                  --AND     accd_deleted_ind    IN (0,4,8)
                  AND     accd_deleted_ind    IN (0,4,8,1)
                  --
                  SET @@l_error = @@ERROR
                  --
                  IF @@l_error > 0
                  BEGIN
                  --
                    SELECT @@l_accd_accdocm_cd = accdocm_cd
                    FROM   account_document_mstr WITH (NOLOCK)
                    WHERE  accdocm_doc_id      = @@l_accd_accdocm_doc_id
                    --
                    SET @@l_errorstr = '#'+CONVERT(varchar, @@l_accd_accdocm_cd)+' could not be added to the entity'+@rowdelimiter+@@l_errorstr
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
                IF EXISTS(SELECT accd_clisba_id 
                          FROM   account_documents
                          WHERE  accd_clisba_id      = @pa_clisba_id 
                          AND    accd_acct_no        = @pa_acct_no     
                          AND    accd_accdocm_doc_id = @@l_accd_accdocm_doc_id
                          AND    ACCD_DELETED_IND    = 1) 
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
                
                SELECT @@l_accd_id = ISNULL(MAX(accd_id),0) + 1
                FROM   accd_mak      WITH (NOLOCK)

                --
                
                BEGIN TRANSACTION
                --
                INSERT INTO accd_mak
                (accd_id
                ,accd_clisba_id
                ,accd_acct_no
                ,accd_acct_type
                ,accd_accdocm_doc_id
                ,accd_valid_yn
                ,accd_remarks
                ,accd_doc_path
                ,accd_created_by
                ,accd_created_dt
                ,accd_lst_upd_by
                ,accd_lst_upd_dt
                ,accd_deleted_ind
			   ,ACCD_BINARY_IMAGE
                )
                VALUES
                (@@l_accd_id
                ,@pa_clisba_id  
                ,@pa_acct_no       
                ,@pa_acct_type     
                ,@@l_accd_accdocm_doc_id
                ,@@l_accd_valid_yn      
                ,@@l_accd_remarks       
                ,@@l_accd_doc_path      
                ,@pa_login_name
                ,GETDATE()
                ,@pa_login_name
                ,GETDATE()
                ,CASE @pa_action WHEN 'INS' then 0
                                 WHEN 'EDT' then @L_EDT_DEL_ID                     
                                 WHEN 'DEL' then 4
                                 END
				--,@pa_img
				,CASE @@l_accd_accdocm_doc_id when '12' then @pa_img
											  when '13' then @pa_img_poa 
											  end
                )
                --
                SET @@l_error = @@ERROR
                --
                IF @@l_error > 0
                BEGIN
                --
                  SELECT @@l_accd_accdocm_cd = accdocm_cd
                  FROM   account_document_mstr WITH (NOLOCK)
                  WHERE  accdocm_doc_id      = @@l_accd_accdocm_doc_id
                  --
                  SET @@l_errorstr = '#'+CONVERT(varchar, @@l_accd_accdocm_cd)+' could not be added to the entity'+@rowdelimiter+@@l_errorstr
                  --
                  ROLLBACK TRANSACTION
                --
                END
                ELSE
                BEGIN
                --
                  SELECT @@l_action = CASE @pa_action WHEN 'INS' THEN 'I' WHEN 'EDT' THEN 'E' WHEN 'DEL' THEN 'D' END
                  --
                   
                  DECLARE @l_crn_no numeric
                  SELECT @l_crn_no  = dpam_crn_no FROM dp_acct_mstr_mak WHERE dpam_id = @@l_clisba_id
				  if @l_crn_no is null
                  begin 
					SELECT @l_crn_no  = dpam_crn_no FROM dp_acct_mstr WHERE dpam_id = @@l_clisba_id
				  end
                  UPDATE client_mstr set clim_lst_upd_by = @pa_login_name WHERE clim_crn_no =@l_crn_no AND clim_deleted_ind = 1
                  EXEC pr_ins_upd_list @l_crn_no, @@l_action,'Account Documents', @pa_login_name,'*|~*','|*~|','' 
                  --
                  COMMIT TRANSACTION
                --
                END 
              --
              END--i_d_e
            --
            END--chk_1_2
          --
          END--cur_val
        --  
        END--rem_val   
      --
      END  --not_app_rej
      ELSE
      BEGIN--app_rej
      --
        IF @pa_action = 'REJ'
        BEGIN--rej
        --
          --BEGIN TRANSACTION
          --
          UPDATE accd_mak            WITH (ROWLOCK)
          SET    accd_deleted_ind  = 3
               , accd_lst_upd_by   = @pa_login_name
               , accd_lst_upd_dt   = GETDATE()
          WHERE  accd_id           = CONVERT(numeric, @@currstring_id)
          AND    accd_deleted_ind IN (0,4,8)
          --
          SET @@l_error = @@ERROR
          --
          IF @@l_error > 0
          BEGIN
          --
            --ROLLBACK TRANSACTION
            SET @@l_errorstr = CONVERT(VARCHAR(10), @@l_error)
          --
          END
            /*delete from sig_files 
            where clisbaid = @@l_accd_clisba_id 
            and doc_id = @@l_accd_accdocm_doc_id 
            and deleted_ind = 0
            and id in  
           (select max(id) from sig_files where clisbaid = @@l_accd_clisba_id and doc_id = @@l_accd_accdocm_doc_id and deleted_ind = 0)*/

         
        --
        END--rej
        --
        IF @pa_action = 'APP'
        BEGIN--app
        
        --
          SELECT @@l_accd_clisba_id      =  accd_clisba_id
               , @@l_accd_acct_no        =  accd_acct_no
               , @@l_accd_acct_type      =  accd_acct_type
               , @@l_accd_accdocm_doc_id =  accd_accdocm_doc_id
               , @@l_accd_valid_yn       =  accd_valid_yn
               , @@l_accd_remarks        =  accd_remarks
               , @@l_accd_doc_path       =  accd_doc_path
               , @@l_accd_deleted_ind    =  accd_deleted_ind
			   ,@@l_accd_img = accd_binary_image
          FROM   #account_documents_mak     WITH (NOLOCK)
          WHERE  accd_id                 =  CONVERT(numeric, @@currstring_id)
          --
select * from #account_documents_mak
          IF @@l_accd_deleted_ind = 4
          BEGIN--4
          --
            --BEGIN TRANSACTION
            --
            UPDATE accd_mak             WITH (ROWLOCK)
            SET    accd_deleted_ind   = 5
                 , accd_lst_upd_by    = @pa_login_name
                 , accd_lst_upd_dt    = GETDATE()
            WHERE  accd_deleted_ind   = 4
            AND    accd_id            = CONVERT(numeric, @@currstring_id)
            --
            SET @@l_error = @@ERROR
            --
            IF @@l_error > 0
            BEGIN
            --
              --ROLLBACK TRANSACTION
              --
              SET @@l_errorstr = CONVERT(VARCHAR(10), @@l_error)
            --
            END
            --
            UPDATE account_documents      WITH (ROWLOCK)
            SET    accd_deleted_ind     = 0
                 , accd_lst_upd_by      = @pa_login_name
                 , accd_lst_upd_dt      = GETDATE()
            WHERE  accd_deleted_ind     = 1
            AND    accd_clisba_id       = @@l_accd_clisba_id   
            AND    accd_accdocm_doc_id  = @@l_accd_accdocm_doc_id

            --delete from sig_files where clisbaid = @@l_accd_clisba_id  and doc_id = @@l_accd_accdocm_doc_id 
            --
            SET @@l_error = @@ERROR
            --
            IF @@l_error > 0
            BEGIN
            --
              --ROLLBACK TRANSACTION
              --
              SET @@l_errorstr = CONVERT(VARCHAR(10), @@l_error)
            --
            END
          --
          END--4
          --
          IF @@l_accd_deleted_ind = 8
          BEGIN--8
          
          -- 
           -- BEGIN TRANSACTION
            --
            UPDATE accd_mak            WITH(ROWLOCK)
            SET    accd_deleted_ind  = 9
                 , accd_lst_upd_by   = @pa_login_name
                 , accd_lst_upd_dt   = GETDATE()
            WHERE  accd_deleted_ind  = 8
            AND    accd_id           = CONVERT(numeric, @@currstring_id)
            --
            SET @@l_error = @@error
            --
            IF @@l_error > 0
            BEGIN
            --
              --ROLLBACK TRANSACTION
              --
              SET @@l_errorstr = CONVERT(VARCHAR(10), @@l_error)
            --
            END
            --
            UPDATE account_documents     WITH(ROWLOCK)
            SET    accd_acct_no        =  @@l_accd_acct_no        
                 , accd_acct_type      =  @@l_accd_acct_type      
                 , accd_accdocm_doc_id =  @@l_accd_accdocm_doc_id 
                 , accd_valid_yn       =  @@l_accd_valid_yn       
                 , accd_remarks        =  @@l_accd_remarks        
                 , accd_doc_path       =  @@l_accd_doc_path       
                 , accd_lst_upd_by     =  @pa_login_name
                 , accd_lst_upd_dt     =  GETDATE()
                 ,ACCD_BINARY_IMAGE	   =  @@l_accd_img	
            WHERE  accd_deleted_ind    =  1
            AND    accd_clisba_id      =  @@l_accd_clisba_id
            AND    accd_accdocm_doc_id =  @@l_accd_accdocm_doc_id

            /* delete from sig_files 
            where clisbaid = @@l_accd_clisba_id 
            and doc_id = @@l_accd_accdocm_doc_id 
            and id not in  
           (select max(id) from sig_files where clisbaid = @@l_accd_clisba_id and doc_id = @@l_accd_accdocm_doc_id)

           update sig_files 
            set    deleted_ind = 1
            where  clisbaid = @@l_accd_clisba_id 
            and    doc_id = @@l_accd_accdocm_doc_id 
 */
            --
            SET @@l_error = @@ERROR
            --
            IF @@l_error > 0
            BEGIN
            --
              --ROLLBACK TRANSACTION
              --
              SET @@l_errorstr = CONVERT(VARCHAR(10), @@l_error)
            --
            END
          --
          END--8
          --
          IF @@l_accd_deleted_ind = 0
          BEGIN--0
          --
            --BEGIN TRANSACTION
            --
            UPDATE accd_mak            WITH (ROWLOCK) 
            SET    accd_deleted_ind  = 1
                 , accd_lst_upd_by   = @pa_login_name
                 , accd_lst_upd_dt   = GETDATE()
            WHERE  accd_deleted_ind  = 0
            AND    accd_id           = CONVERT(numeric, @@currstring_id)

            --
            SET @@l_error = @@ERROR
            --
            IF @@l_error > 0
            BEGIN
            --
              --ROLLBACK TRANSACTION
              --
              SET @@l_errorstr = CONVERT(VARCHAR(10), @@l_error)
            --
            END
            --
            INSERT INTO Account_documents
            (accd_clisba_id
            ,accd_acct_no
            ,accd_acct_type
            ,accd_accdocm_doc_id
            ,accd_valid_yn
            ,accd_remarks
            ,accd_doc_path
            ,accd_created_by
            ,accd_created_dt
            ,accd_lst_upd_by
            ,accd_lst_upd_dt
            ,accd_deleted_ind
			,ACCD_BINARY_IMAGE
            )
            VALUES
            (@@l_accd_clisba_id
            ,@@l_accd_acct_no
            ,@@l_accd_acct_type
            ,@@l_accd_accdocm_doc_id
            ,@@l_accd_valid_yn
            ,@@l_accd_remarks
            ,@@l_accd_doc_path
            ,@pa_login_name
            ,GETDATE()
            ,@pa_login_name
            ,GETDATE()
            ,1
			,@@l_accd_img --@pa_img
            )
            --
            SET @@l_error = @@ERROR
            --
            IF @@l_error > 0
            BEGIN
            --
              --ROLLBACK TRANSACTION
              --
              SET @@l_errorstr = CONVERT(VARCHAR(10), @@l_error)
            --
            END

            /*delete from sig_files 
            where clisbaid = @@l_accd_clisba_id 
            and doc_id = @@l_accd_accdocm_doc_id 
            and id not in  
           (select max(id) from sig_files where clisbaid = @@l_accd_clisba_id and doc_id = @@l_accd_accdocm_doc_id)

            update sig_files 
            set    deleted_ind = 1
            where  clisbaid = @@l_accd_clisba_id 
            and    doc_id = @@l_accd_accdocm_doc_id */
 
          --
          END--0
          --move to pr_app_client
          --EXEC pr_ins_upd_list @@l_accd_clisba_id, 'A','Account Documents', @pa_login_name,'*|~*','|*~|','' 
        --
        END--app
      --
      END--app_rej
    --
    END  --cur_id
  --    
  END--rem_id
  --
  IF ISNULL(RTRIM(LTRIM(@@l_errorstr)),'') = ''
  BEGIN
  --
    SET @pa_msg = 'Client documents successfully inserted/edited'+ @rowdelimiter
     
  --
  END
  ELSE
  BEGIN
  --
    SET @pa_msg = @@l_errorstr
    
  --
  END
--  
END --#1

GO
