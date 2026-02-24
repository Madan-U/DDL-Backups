-- Object: PROCEDURE citrus_usr.pr_ins_upd_conc
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--begin transaction
--pr_ins_upd_conc '1496*|~*1495*|~*1494*|~*1493*|~*','APP','HEAD',58476,'','0',1,'*|~*','|*~|',''
--select * from contact_channels ORDER BY 1 DESC
--select * from contact_channels_MAK ORDER BY 1 DESC
--rollback transaction
CREATE PROCEDURE [citrus_usr].[pr_ins_upd_conc](@pa_id           VARCHAR(8000)        
                               ,@pa_action       VARCHAR(20)        
                               ,@pa_login_name   VARCHAR(20)        
                               ,@pa_ent_id       NUMERIC        
                               ,@pa_acct_no      VARCHAR(20)        
                               ,@pa_values       VARCHAR(8000)        
                               ,@pa_chk_yn       INT        
                               ,@rowdelimiter    CHAR(4)        
                               ,@coldelimiter    CHAR(4)        
                               ,@pa_msg          VARCHAR(8000) OUTPUT        
)        
AS        
BEGIN        
--        
   
--        
DECLARE @@t_errorstr         VARCHAR(8000)        
      , @l_cmconcm_id        BIGINT        
      , @l_concm_id          BIGINT        
      , @l_old_conc_id       BIGINT        
      , @@l_error            BIGINT        
      , @delimeter           VARCHAR(10)        
      , @delimeter1          VARCHAR(10)        
      , @@remainingstring    VARCHAR(8000)        
      , @@currstring         VARCHAR(8000)        
      , @@remainingstring1   VARCHAR(8000)        
      , @@currstring1        VARCHAR(8000)        
      , @@foundat            INTEGER        
      , @@delimeterlength    INT        
      , @@delimeterlength1   INT        
      , @l_counter           INT        
      , @l_entac_concm_cd    VARCHAR(20)        
      , @l_conc_value        VARCHAR(50)        
      , @l_conc_oldvalue     VARCHAR(50)        
      , @l_conc_value_new    VARCHAR(50)        
      , @l_entac_concm_id    VARCHAR(20)        
      , @l_entac_adr_conc_id NUMERIC        
      , @l_conc_id           INT        
      , @l_concm_desc        VARCHAR(50)        
      , @l_conc_value_old    VARCHAR(50)        
      , @l_deleted_ind       CHAR(1)        
      , @l_conc_ent_id       NUMERIC        
      , @l_concmak_id        NUMERIC         
      , @l_action            CHAR(1)       
      , @L_EDT_DEL_ID        NUMERIC        
--        
SET @l_counter   = 1        
SET @@l_error    = 0        
SET @@t_errorstr = ''        
--        
IF @pa_id <> '' AND @pa_action <> '' AND @pa_login_name <> ''        
BEGIN        
  --        
  CREATE TABLE    #t_recordset        
  (entac_ent_id   NUMERIC        
  ,entac_concm_cd VARCHAR(20)        
  ,conc_value     VARCHAR(50)        
  ,conc_id        NUMERIC        
  ,entac_concm_id NUMERIC        
  )        
          
  INSERT INTO #t_recordset        
  SELECT a.entac_ent_id        
        ,a.entac_concm_cd        
        ,b.conc_value        
        ,b.conc_id        
        ,a.entac_concm_id        
  FROM  entity_adr_conc  a   WITH(NOLOCK)        
  JOIN  contact_channels b   WITH(NOLOCK)        
  ON    a.entac_adr_conc_id  = b.conc_id        
  WHERE a.entac_ent_id       = @pa_ent_id        
  AND   a.entac_deleted_ind  = 1        
  AND   b.conc_deleted_ind   = 1         


          
  CREATE TABLE #t_recordset_mak        
  (entac_ent_id   NUMERIC        
  ,entac_concm_cd VARCHAR(20)        
  ,conc_value     VARCHAR(50)        
  ,conc_id        NUMERIC        
  ,entac_concm_id NUMERIC        
  )        
  INSERT INTO #t_recordset_mak        
  SELECT b.conc_ent_id        
        ,b.conc_concm_cd        
        ,b.conc_value        
        ,b.conc_id        
        ,b.conc_concm_id        
  FROM  contact_channels_mak   b   WITH(NOLOCK)        
  WHERE b.conc_ent_id       = @pa_ent_id        
  AND   b.conc_deleted_ind   IN(0,4,6)        
          
  CREATE TABLE #t_recordset_mak1        
  (entac_ent_id   NUMERIC        
  ,entac_concm_cd VARCHAR(20)        
  ,conc_value     VARCHAR(50)        
  ,conc_id        NUMERIC        
  ,entac_concm_id NUMERIC        
  )        
  INSERT INTO #t_recordset_mak1        
  SELECT b.conc_ent_id        
        ,b.conc_concm_cd        
        ,b.conc_value        
        ,b.conc_id        
        ,b.conc_concm_id        
  FROM  contact_channels_mak   b   WITH(NOLOCK)        
  WHERE b.CONC_ENT_ID       = @pa_ent_id        
  and    b.conc_deleted_ind   IN(0,4,6)        
          
          
  --        
  SET @delimeter           = '%'+ @rowdelimiter + '%'        
  SET @@delimeterlength    = LEN(@rowdelimiter)        
        
  SET @@remainingstring    = @pa_values        
  WHILE @@remainingstring <> ''        
  BEGIN        
    --        
    SET @@foundat = 0        
    SET @@foundat =  PATINDEX('%'+@delimeter+'%',@@remainingstring)        
        
    IF @@foundat > 0        
    BEGIN        
      --        
      SET @@currstring      = SUBSTRING(@@remainingstring, 0,@@foundat)        
      SET @@remainingstring = SUBSTRING(@@remainingstring, @@foundat+@@delimeterlength,LEN(@@remainingstring)- @@foundat+@@delimeterlength)        
      --        
    END        
    ELSE        
    BEGIN        
      --        
      SET @@currstring      = @@remainingstring        
      SET @@remainingstring = ''        
      --        
    END        
        
    IF @@currstring <> ''        
    BEGIN        
      --        
      SET @l_entac_concm_cd = citrus_usr.FN_SPLITVAL(@@currstring,1)        
      SET @l_conc_value     = citrus_usr.FN_SPLITVAL(@@currstring,2)        
      -- 
      SELECT @l_entac_concm_id = concm_id        
      FROM   conc_code_mstr    WITH(NOLOCK)        
      WHERE  concm_cd          = @l_entac_concm_cd        
      AND    concm_deleted_ind = 1         
      --        

      IF @pa_chk_yn = 0        
      BEGIN        
      --        
        IF @pa_action = 'INS'        
        BEGIN        
        --        
          IF EXISTS(SELECT conc_id        
                    FROM   contact_channels  WITH(NOLOCK)        
                    WHERE  conc_value        = @l_conc_value        
                    AND    conc_deleted_ind  = 1        
                    )        
          BEGIN        
            --        
            SELECT @l_conc_id        = conc_id        
            FROM   contact_channels  WITH(NOLOCK)        
            WHERE  conc_value        = @L_CONC_VALUE        
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
            ,entac_deleted_ind)        
            VALUES        
            (@pa_ent_id        
            ,@pa_acct_no        
            ,@l_entac_concm_id        
            ,@l_entac_concm_cd        
            ,@l_conc_id        
            ,@pa_login_name        
            ,GETDATE()        
            ,@pa_login_name        
            ,GETDATE()        
            ,1)        
            --        
            SET @@l_error = @@error        
            --        
            IF @@l_error > 0        
            BEGIN        
              --        
              SELECT @l_concm_desc     = CONCM_DESC        
              FROM   conc_code_mstr    WITH(NOLOCK)        
              WHERE  concm_id          = @l_entac_concm_id        
              AND    concm_deleted_ind = 1        
              --        
              SET @@t_errorstr=@l_concm_desc+'Could not be Inserted'+@rowdelimiter+@@t_errorstr        
              --        
            END        
            --        
          END        
          ELSE        
          BEGIN        
            --        
            BEGIN TRANSACTION        
            --        
            SELECT @l_conc_id       = bitrm_bit_location        
            FROM   bitmap_ref_mstr  WITH(NOLOCK)        
            WHERE  bitrm_parent_cd  = 'ADR_CONC_ID'        
            AND    bitrm_child_cd   = 'ADR_CONC_ID'        
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
            (@l_conc_id        
            ,@l_conc_value        
            ,@pa_login_name        
            ,getdate()        
            ,@pa_login_name        
            ,getdate()        
            ,1)        
            --        
            SET @@l_error = @@error        
            --        
            IF @@l_error > 0        
            BEGIN        
            --        
              SELECT @l_concm_desc     = concm_desc        
              FROM   conc_code_mstr    WITH(NOLOCK)        
              WHERE  concm_id          = @l_entac_concm_id        
              AND    concm_deleted_ind = 1        
              --        
              SET @@t_errorstr='#'+@l_concm_desc+'Could not be Inserted'+@rowdelimiter+@@t_errorstr        
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
              ,@l_entac_concm_id        
              ,@l_entac_concm_cd        
              ,@l_conc_id        
              ,@pa_login_name        
              ,getdate()        
              ,@pa_login_name        
              ,getdate()        
              ,1)        
              --        
              SET @@l_error = @@error        
              --        
              IF @@l_error > 0      --if any error reports then generate the error string        
              BEGIN        
              --        
                SELECT @l_concm_desc     = concm_desc        
                FROM   conc_code_mstr    WITH(NOLOCK)        
                WHERE  concm_id          = @l_entac_concm_id        
                AND    concm_deleted_ind = 1        
                --        
                SET @@t_errorstr = '#'+@l_concm_desc+'Could not be Inserted'+@rowdelimiter+@@t_errorstr        
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
          END        
      --        
      END     --END OF ACTION        
        
      IF @pa_action = 'EDT'        
      BEGIN        
      --        
        IF @l_conc_value = ''        
        BEGIN        
          --        
          SELECT @l_entac_adr_conc_id = entac_adr_conc_id        
          FROM   entity_adr_conc      WITH(NOLOCK)        
          WHERE  entac_ent_id         = @pa_ent_id        
          AND    entac_concm_id       = @l_entac_concm_id        
          AND    entac_deleted_ind    = 1        
          --        
            IF EXISTS(SELECT entac_adr_conc_id        
                      FROM   entity_adr_conc   WITH(NOLOCK)        
                      WHERE  entac_ent_id      <> @pa_ent_id        
                      AND    entac_adr_conc_id = @l_entac_adr_conc_id        
                      AND    entac_deleted_ind = 1         
                      )        
            BEGIN        
            --        
              BEGIN TRANSACTION        
              --        
              
              DELETE FROM entity_adr_conc        
              WHERE  entac_ent_id      = @pa_ent_id        
              AND    entac_concm_id    = @l_entac_concm_id        
              AND    entac_deleted_ind = 1         
              --        
              SET @@l_error = @@error        
   --        
              IF @@l_error > 0      --if any error reports then generate the error string        
              BEGIN        
                --        
                SELECT @l_concm_desc     = concm_desc        
                FROM   conc_code_mstr    WITH(NOLOCK)        
                WHERE  concm_id          = @L_ENTAC_CONCM_ID        
                AND    concm_deleted_ind = 1        
                --        
                SET @@t_errorstr = '#'+@l_concm_desc+'Could not be Edited/Deleted'+@rowdelimiter+@@t_errorstr        
                --        
                ROLLBACK TRANSACTION        
                --        
              END   
              ELSE  
              BEGIN  
              --  
                commit transaction  
              --       
              end  
              --        
            END             --END OF EXISTS        
            ELSE            --ELSE OF EXIST        
            BEGIN        
          --        
              BEGIN TRANSACTION        
              --        
--              DELETE FROM contact_channels        
--              WHERE  conc_id          = @l_entac_adr_conc_id        
--              AND    conc_deleted_ind = 1        
              --        
              SET @@l_error = @@error        
              --        
              IF @@l_error > 0              
              BEGIN        
                --        
                SELECT @l_concm_desc     = concm_desc        
                FROM   conc_code_mstr    WITH(NOLOCK)        
                WHERE  concm_id          = @l_entac_concm_id        
                AND    concm_deleted_ind = 1        
                --        
                SET @@t_errorstr = '#'+@l_concm_desc+'Could not be Edited/Deleted'+@rowdelimiter+@@t_errorstr        
                --        
                ROLLBACK TRANSACTION        
              --        
              END        
              ELSE        
              BEGIN        
                --     
                
     
                DELETE FROM entity_adr_conc        
                WHERE  entac_ent_id      = @pa_ent_id        
                AND    entac_adr_conc_id = @l_entac_adr_conc_id        
                AND    entac_deleted_ind = 1        
                --        
                SET @@l_error = @@error        
                --        
                IF @@l_error > 0        
                BEGIN        
                  --        
                  SELECT @l_concm_desc     = concm_desc        
                  FROM   conc_code_mstr    WITH(NOLOCK)        
                  WHERE  concm_id          = @l_entac_concm_id        
                  AND    concm_deleted_ind = 1        
                  --        
                  SET @@t_errorstr='#'+@l_concm_desc+'Could not be Edited/Deleted'+@rowdelimiter+@@t_errorstr        
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
            END  --end of  exists        
           --        
        END    --end of @conc_value is null or not        
        ELSE   --if @pa_value <>'' then        
        BEGIN        
        --        
          IF EXISTS(SELECT conc_value         
                    FROM   #t_recordset        
                    WHERE  entac_concm_cd = @l_entac_concm_cd        
                   )        
          BEGIN        
          --        
              SELECT @l_conc_oldvalue = conc_value        
                    ,@l_old_conc_id   = conc_id        
              FROM  #t_recordset        
              WHERE entac_concm_cd=@l_entac_concm_cd        
              --        
              IF @l_conc_oldvalue=@l_conc_value        
              BEGIN        
              --        
                print 'do nothing'      
              --        
              END        
              ELSE        
              BEGIN        
                --        
                SELECT @l_old_conc_id    = entac_adr_conc_id        
                FROM   entity_adr_conc   WITH(NOLOCK)        
                WHERE  entac_ent_id      = @pa_ent_id        
                AND    entac_concm_id    = @l_entac_concm_id        
                AND    entac_deleted_ind = 1        
                      
                IF EXISTS(SELECT *         
                          FROM   entity_adr_conc  WITH(NOLOCK)        
                          WHERE  entac_concm_id          = @l_entac_concm_id        
                          AND    entac_adr_conc_id       = @l_old_conc_id        
                          AND    entac_ent_id           <> @pa_ent_id        
                          AND    entac_deleted_ind       = 1        
                          ) 
                          or EXISTS(SELECT *         
                          FROM   entity_adr_conc  WITH(NOLOCK)        
                          WHERE  entac_concm_id          <> @l_entac_concm_id        
                          AND    entac_adr_conc_id       = @l_old_conc_id        
                          AND    entac_ent_id           = @pa_ent_id        
                          AND    entac_deleted_ind       = 1        
                          )        
                BEGIN        
                --        
                  BEGIN TRANSACTION        
                  --        
                  SELECT @l_conc_id       =bitrm_bit_location        
                  FROM   bitmap_ref_mstr  WITH(NOLOCK)        
                  WHERE  bitrm_parent_cd  = 'ADR_CONC_ID'        
                  AND    bitrm_child_cd   = 'ADR_CONC_ID'        
                  --        
                  UPDATE bitmap_ref_mstr    WITH(ROWLOCK)        
                  SET    bitrm_bit_location = bitrm_bit_location+1        
                  WHERE  bitrm_parent_cd    = 'ADR_CONC_ID'        
                  AND    bitrm_child_cd     = 'ADR_CONC_ID'        
                  --        
                  SET @@l_error = @@error        
                  --        
                  IF @@l_error > 0      --IF ANY ERROR REPORTS THEN GENERATE THE ERROR STRING        
                  BEGIN        
                    --        
                    SELECT @l_concm_desc     = concm_desc        
                    FROM   conc_code_mstr    WITH(NOLOCK)        
                    WHERE  concm_id          = @l_entac_concm_id        
                    AND    concm_deleted_ind = 1        
                    --        
                    SET @@t_errorstr = '#'+@l_concm_desc+'Could not be Edited/Deleted'+@rowdelimiter+@@t_errorstr        
                    --        
                    ROLLBACK TRANSACTION        
                    --        
                  END        
                  ELSE        
                  BEGIN        
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
                    (@l_conc_id        
                    ,@l_conc_value        
                    ,@pa_login_name        
                    ,getdate()        
                    ,@pa_login_name        
                    ,getdate()        
                    ,1)        
                    --        
                    SET @@l_error = @@error        
                    --        
                    IF @@l_error > 0      --if any error reports then generate the error string        
                    BEGIN        
                      --        
                      SELECT @l_concm_desc     = concm_desc        
                      FROM   conc_code_mstr    WITH(NOLOCK)        
                      WHERE  concm_id          = @l_entac_concm_id        
                      AND    concm_deleted_ind = 1        
                      --        
                      SET @@t_errorstr = '#'+@l_concm_desc+'Could not be Edited/Deleted'+@rowdelimiter+@@t_errorstr        
                      --        
                      ROLLBACK TRANSACTION        
                      --        
                    END        
                    ELSE        
                    BEGIN        
                      --        
                      UPDATE entity_adr_conc   WITH(ROWLOCK)        
                      SET    entac_adr_conc_id = @l_conc_id        
                      WHERE  entac_ent_id      = @pa_ent_id        
                      AND    entac_concm_id    = @l_entac_concm_id        
                      AND    entac_deleted_ind = 1        
                      --        
                      SET @@l_error = @@error        
                      --        
                      IF @@l_error > 0      --if any error reports then generate the error string        
                      BEGIN        
                        --        
                        SELECT @l_concm_desc     = concm_desc        
                        FROM   conc_code_mstr    WITH(NOLOCK)        
                        WHERE  concm_id          = @l_entac_concm_id        
                        AND    concm_deleted_ind = 1        
                        --        
                        SET @@t_errorstr='#'+@l_concm_desc+'Could not be Edited/Deleted'+@rowdelimiter+@@t_errorstr        
                        --        
                        ROLLBACK TRANSACTION        
                        --        
                      END    --END IF UPDAT ERROR OCCOURS        
                      ELSE        
                      BEGIN        
                        --        
                        COMMIT TRANSACTION        
                        --        
                      END     --COMMIT TRANSACTION IF NO ERROR IN UPDATE OF ADR_CONC        
                      --        
                    END   --END OF INSERTION PART IF NO ERROR        
                    --        
                  END         --END OF UPDATE FOR BITMAP_REF_MSTR        
                  --        
                END    --END  IF EXISTS        
                ELSE   --STARTS IF NOT EXIST        
                BEGIN        
                --        
                  BEGIN TRANSACTION        
                  --        
                  UPDATE contact_channels  WITH(ROWLOCK)        
                  SET    conc_value        = @l_conc_value        
                        ,conc_lst_upd_by   = @pa_login_name        
                        ,conc_lst_upd_dt   = getdate()        
                  WHERE  conc_id           = @l_old_conc_id        
                  AND    conc_deleted_ind  = 1        
                  --        
                  set @@l_error = @@error        
                  --        
                  IF @@l_error > 0      --if any error reports then generate the error string        
                  BEGIN        
                    --        
                    SELECT @l_concm_desc     = concm_desc        
                    FROM   conc_code_mstr    WITH(NOLOCK)        
                    WHERE  concm_id          = @l_entac_concm_id        
                    AND    concm_deleted_ind = 1        
                    --        
                    SET @@t_errorstr='#'+@l_concm_desc+'Could not be Edited/Deleted'+@rowdelimiter+@@t_errorstr        
                    --        
                    ROLLBACK TRANSACTION    
                    --        
                  END    --END IF UPDATE ERROR OCCOURS        
                  ELSE        
                  BEGIN        
                    --        
                    COMMIT TRANSACTION        
                    --        
                  END        
                  --        
                END --IF EXISTS ENDED        
                --        
              END  --VALUES ARE NOT SAME ENDED        
              --        
            END        
            ELSE        
            BEGIN  --INSERT STATMENT IS BEING DONE AGAIN        
              --        
              IF EXISTS(SELECT conc_id        
                        FROM   contact_channels  WITH(NOLOCK)        
                        WHERE  conc_value        = @l_conc_value        
                        AND    conc_deleted_ind  = 1)        
              BEGIN        
                --        
                SELECT @l_conc_id       = conc_id        
                FROM   contact_channels WITH(NOLOCK)        
                WHERE  conc_value       = @l_conc_value        
                AND    conc_deleted_ind = 1       
                  
				  
    if not exists(select 1 from entity_adr_conc where entac_ent_id = @pa_ent_id and entac_concm_id = @l_entac_concm_id )
	begin
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
                ,@l_entac_concm_id        
                ,@l_entac_concm_cd        
                ,@l_conc_id        
                ,@pa_login_name        
                ,getdate()        
                ,@pa_login_name        
                ,getdate()        
                ,1)        

		end 
		else 
		begin 
		  UPDATE entity_adr_conc   WITH(ROWLOCK)        
                      SET    entac_adr_conc_id = @l_conc_id        
                      WHERE  entac_ent_id      = @pa_ent_id        
                      AND    entac_concm_id    = @l_entac_concm_id        
                      AND    entac_deleted_ind = 1     
		end 
      
                      
                      
                      
                --        
              END        
              ELSE        
              BEGIN        
              BEGIN TRANSACTION        
                --        
                
                SELECT @l_conc_id       = bitrm_bit_location        
                FROM   bitmap_ref_mstr  WITH(NOLOCK)        
                WHERE  bitrm_parent_cd  = 'ADR_CONC_ID'        
                AND    bitrm_child_cd   = 'ADR_CONC_ID'        
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
                (@l_conc_id        
                ,@l_conc_value        
                ,@pa_login_name        
                ,getdate()        
                ,@pa_login_name        
                ,getdate()        
                ,1)        
                 --        
                 SET @@l_error = @@error        
                 --        
                 IF @@l_error > 0        
                 BEGIN        
                   --        
                   SELECT @l_concm_desc     = concm_desc        
                   FROM   conc_code_mstr    WITH(NOLOCK)        
                   WHERE  concm_id          = @l_entac_concm_id        
                   AND    concm_deleted_ind = 1        
                   --        
                   SET @@t_errorstr = '#'+@l_concm_desc+'Could not be Edited/Deleted'+@rowdelimiter+@@t_errorstr        
                   --        
                   ROLLBACK TRANSACTION        
                   --        
                 END        
                 ELSE        
                 BEGIN        
                   --        
                   
                   if not exists(select entac_ent_id from entity_adr_conc where entac_ent_id = @pa_ent_id and entac_concm_id = @l_entac_concm_id)
                   begin        
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
                   ,@l_entac_concm_id        
                   ,@l_entac_concm_cd        
                   ,@l_conc_id        
                   ,@pa_login_name        
                   ,getdate()        
                   ,@pa_login_name        
                   ,getdate()        
                   ,1) 
                   end 
                   else 
                   begin
                     update entity_adr_conc set entac_adr_conc_id = @l_conc_id 
                     , entac_lst_upd_by= @pa_login_name
                     , entac_lst_upd_dt = getdate()
                     where entac_ent_id = @pa_ent_id 
                     and entac_concm_id = @l_entac_concm_id
                   end            
                   --        
                   SET @@l_error = @@error        
                   --        
                   IF @@l_error > 0        
                   BEGIN        
                     --        
                     SELECT @l_concm_desc     = concm_desc        
                     FROM   conc_code_mstr    WITH(NOLOCK)        
                     WHERE  concm_id          = @l_entac_concm_id        
                     AND    concm_deleted_ind = 1        
                     --        
                     SET @@t_errorstr = '#'+@l_concm_desc+' Could not be Edited/Deleted'+@rowdelimiter+@@t_errorstr        
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
                 END  --IF BOTH INSERT GOT SUCEED        
                 --        
              END  --END OF IF EXIST        
              --        
            END   --END OF INSERTION IN EDIT        
            --        
          END   --END OF THE CONC VALUE CHECK        
        --        
        END     --END OF EDT        
      --     DROP TABLE #T_RECORDSET        
      END   --END OF CHK_YN        
      IF @pa_chk_yn = 1   or @pa_chk_yn = 2        
      BEGIN        
      --        
              
        IF EXISTS(SELECT concmak.conc_ent_id       
                  FROM   contact_channels_mak       concmak      
                  WHERE  concmak.conc_deleted_ind   IN (0,4,8)      
                  AND    concmak.conc_ent_id      = @pa_ent_id      
                  AND    concmak.conc_concm_id    = @l_entac_concm_id)      
                        
        BEGIN                
        --      
          UPDATE contact_channels_mak      
          SET    conc_deleted_ind =  3       
          WHERE  conc_ent_id      = @pa_ent_id      
          AND    conc_deleted_ind IN (0,4,8)      
          AND    conc_concm_id    = @l_entac_concm_id      
        --      
        END      
               
            
                 
      
      
        IF @pa_action='INS' OR @pa_action='EDT' OR @pa_action='DEL'       
        BEGIN        
        --        
          BEGIN TRANSACTION            
                
          SELECT @l_concmak_id=isnull(MAX(concmak_id),0)+1 FROM contact_channels_mak          

          
          IF EXISTS(SELECT ENTAC.ENTAC_ENT_ID FROM ENTITY_ADR_CONC ENTAC WHERE  ENTAC.ENTAC_ENT_ID = @pa_ent_id AND ENTAC.ENTAC_CONCM_ID = @l_entac_concm_id)                          
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
      
          IF @L_EDT_DEL_ID = 8 OR @l_conc_value <> ''
          begin
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
          (@l_concmak_id        
          ,0      --@l_conc_id        
          ,@l_conc_value        
          ,@pa_ent_id        
          ,@l_entac_concm_id        
          ,@l_entac_concm_cd        
          ,@pa_login_name        
          ,getdate()        
          ,@pa_login_name        
          ,getdate()        
          ,CASE @pa_action WHEN 'INS' THEN 0      
                           WHEN 'EDT' THEN (CASE @l_conc_value WHEN '' THEN 4 ELSE @L_EDT_DEL_ID END) END)        
                                 
                                 
           end                      
             
          SET @@l_error = @@error        
          --        
          IF @@l_error > 0      --if any error reports then generate the error string        
          BEGIN        
          --        
            SELECT @l_concm_desc     = concm_desc        
            FROM   conc_code_mstr    WITH(NOLOCK)        
            WHERE  concm_id          = @l_entac_concm_id        
            AND    concm_deleted_ind = 1        
            --        
            SET @@t_errorstr = '#'+@l_concm_desc+'Could not be Inserted'+@rowdelimiter+@@t_errorstr       
            --        
            ROLLBACK TRANSACTION        
          --        
          END        
          ELSE        
          BEGIN        
            --        
            COMMIT TRANSACTION        
                  
            --      
            SELECT @l_action = CASE @pa_action WHEN 'INS' THEN 'I'      
                                               WHEN 'EDT' THEN (CASE @l_conc_value WHEN '' THEN 'D' ELSE 'E' END) END      
            --      
            EXEC pr_ins_upd_list @pa_ent_id, @l_action,'CONTACT CHANNELS', @pa_login_name,'*|~*','|*~|',''      
            --        
          END            
        --        
        END        
/*        ELSE IF @pa_action='EDT'        
        BEGIN        
        --        
          IF @l_conc_value = ''        
          BEGIN        
          --        
            BEGIN TRANSACTION      
                  
            SELECT @l_concmak_id=isnull(MAX(concmak_id),0)+1 FROM contact_channels_mak           
        
            INSERT INTO contact_channels_mak        
            (concmak_id        
            ,conc_id        
            ,conc_value        
            ,conc_created_by        
            ,conc_created_dt        
            ,conc_lst_upd_by        
            ,conc_lst_upd_dt        
            ,conc_ent_id        
            ,conc_concm_id        
            ,conc_concm_cd        
            ,conc_deleted_ind)        
            VALUES        
            (@l_concmak_id        
            ,0        
            ,@l_conc_value        
            ,@pa_login_name        
            ,getdate()        
            ,@pa_login_name        
            ,getdate()        
            ,@pa_ent_id        
            ,@l_entac_concm_id        
            ,@l_entac_concm_cd        
            ,4)        
        
            SET @@l_error = @@error        
            --        
            IF @@l_error > 0      --if any error reports then generate the error string        
            BEGIN        
            --        
              SELECT @l_concm_desc     = concm_desc        
              FROM   conc_code_mstr    WITH(NOLOCK)     
              WHERE  concm_id          = @l_entac_concm_id        
              AND    concm_deleted_ind = 1        
              --        
              SET @@t_errorstr = @l_concm_desc+'Could not be Inserted'+@rowdelimiter+@@t_errorstr        
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
          ELSE        
          BEGIN        
          --        
             BEGIN TRANSACTION      
                   
             SELECT @l_concmak_id=isnull(MAX(concmak_id),0)+1 FROM contact_channels_mak           
        
             INSERT INTO contact_channels_mak        
             (concmak_id        
             ,conc_id        
             ,conc_value        
             ,conc_created_by        
             ,conc_created_dt        
             ,conc_lst_upd_by        
             ,conc_lst_upd_dt        
             ,conc_ent_id        
             ,conc_concm_id        
             ,conc_concm_cd        
             ,conc_deleted_ind)        
             VALUES        
             (@l_concmak_id        
             ,0        
             ,@l_conc_value        
             ,@pa_login_name        
             ,getdate()        
             ,@pa_login_name        
             ,getdate()        
             ,@pa_ent_id        
             ,@l_entac_concm_id        
             ,@l_entac_concm_cd        
             ,8)        
        
             SET @@l_error = @@error        
             --        
             IF @@l_error > 0      --if any error reports then generate the error string        
             BEGIN        
             --        
               SELECT @l_concm_desc     = concm_desc        
               FROM   conc_code_mstr    WITH(NOLOCK)        
               WHERE  concm_id          = @l_entac_concm_id        
               AND    concm_deleted_ind = 1        
               --        
               SET @@t_errorstr = @l_concm_desc+'Could not be Inserted'+@rowdelimiter+@@t_errorstr        
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
                
          END        
        --        
        END  */      
        set @@remainingstring1 = @pa_id        
        WHILE @@remainingstring1 <> ''        
        BEGIN--1        
        --        
          SET @@foundat = 0        
          SET @@foundat =  PATINDEX('%'+@delimeter+'%',@@remainingstring1)        
          --        
          IF  @@foundat > 0        
          BEGIN        
          --        
            SET @@currstring1      = SUBSTRING(@@remainingstring1, 0,@@foundat)        
            SET @@remainingstring1 = SUBSTRING(@@remainingstring1, @@foundat+@@delimeterlength,LEN(@@remainingstring1)- @@foundat+@@delimeterlength)        
          --        
          END        
          ELSE        
          BEGIN        
          --        
            SET @@currstring1 = @@remainingstring1        
            SET @@remainingstring1 = ''        
          --        
          END        
          --        
          
          IF @@currstring1 <> ''        
          BEGIN--2        
          --           
            IF @pa_action='APP'        
            BEGIN        
            --        
              SELECT @l_deleted_ind       = conc_deleted_ind        
                    ,@l_conc_ent_id       = conc_ent_id        
                    ,@l_entac_concm_id    = conc_concm_id        
                    ,@l_entac_concm_cd    = conc_concm_cd        
                    ,@l_conc_value_new    = conc_value        
              FROM   contact_channels_mak        
              WHERE  concmak_id           = CONVERT(NUMERIC,@@currstring1)        
              AND    conc_deleted_ind       IN (0,4,8)        
                      
              SELECT @l_entac_adr_conc_id    = conc.conc_id        
                    ,@l_conc_value_old       = conc.conc_value          
              FROM   contact_channels          conc        
              JOIN   entity_adr_conc           entac          
              ON     entac.entac_adr_conc_id = conc.conc_id        
              WHERE  entac_ent_id            = @l_conc_ent_id        
              AND    entac_concm_id          = @l_entac_concm_id        
              AND    entac_concm_cd          = @l_entac_concm_cd        
              AND    entac_deleted_ind       = 1        
              AND    conc_deleted_ind        = 1        
              --     
                 
              IF @l_deleted_ind = 4        
              BEGIN        
              --        
                IF EXISTS(SELECT entac_adr_conc_id        
                          FROM   entity_adr_conc      WITH(NOLOCK)        
                         WHERE  ((entac_ent_id      <> @l_conc_ent_id) OR (entac_ent_id      = @l_conc_ent_id AND entac_concm_cd <>  @l_entac_concm_cd))              
                          AND    entac_adr_conc_id =  @l_entac_adr_conc_id   
                          AND    entac_concm_cd    =  @l_entac_concm_cd            
                          AND    entac_deleted_ind =  1         
                          )        
                BEGIN        
                --        
                         
                    --        
                    UPDATE contact_channels_mak               
                    SET    conc_deleted_ind = 5        
                         , conc_id          = @l_entac_adr_conc_id        
                         , conc_lst_upd_by  = @pa_login_name        
                         , conc_lst_upd_dt  = GETDATE()        
                    WHERE  conc_deleted_ind = 4        
                    AND    concmak_id       = CONVERT(NUMERIC,@@currstring1)        
                    --      
                    SET @@l_error = @@ERROR        
                    --        
                    IF @@l_error > 0      
                    BEGIN        
                    --        
                      SET @@t_errorstr = convert(varchar,@@l_error)       
                      --        
                            
                    --        
           END          
                    --         
                    DELETE FROM entity_adr_conc        
                    WHERE  entac_ent_id      = @l_conc_ent_id          
                    AND    entac_concm_id    = @l_entac_concm_id        
                    AND    entac_deleted_ind = 1         
                    --       
                    SET @@l_error = @@error        
                    --        
                    IF @@l_error > 0      --if any error reports then generate the error string        
                    BEGIN        
                      --        
                      SET @@t_errorstr = convert(varchar,@@l_error)       
                      --       
                    --        
                    END        
                        
                --        
                END        
                ELSE        
                BEGIN        
                --        
                  DELETE FROM contact_channels        
                  WHERE  conc_id          = @l_entac_adr_conc_id        
                  AND    conc_deleted_ind = 1        
                  --      
                  SET @@l_error = @@ERROR        
                  --        
                  IF @@l_error > 0      
                  BEGIN        
                  --        
                    SET @@t_errorstr = convert(varchar,@@l_error)       
                    --        
                          
                  --        
                  END          
                  --                     
                  DELETE FROM entity_adr_conc        
                  WHERE  entac_ent_id      = @l_conc_ent_id          
                  AND    entac_adr_conc_id = @l_entac_adr_conc_id        
                  AND    entac_deleted_ind = 1        
                  --      
                  SET @@l_error = @@ERROR        
                  --        
                  IF @@l_error > 0      
                  BEGIN        
                  --        
                    SET @@t_errorstr = convert(varchar,@@l_error)       
                    --        
                          
                   --        
                  END          
                --        
                END        
              --        
              END        
              ELSE IF @l_deleted_ind = 8        
              BEGIN        
              --        
              PRINT @l_conc_ent_id
              PRINT @l_entac_concm_cd
                IF EXISTS(SELECT b.conc_value        
                                ,b.conc_id        
                                ,a.entac_concm_cd        
                          FROM  entity_adr_conc  a     WITH(NOLOCK)        
                          JOIN  contact_channels b     WITH(NOLOCK)        
                          ON    a.entac_adr_conc_id  = b.conc_id        
                          WHERE a.entac_ent_id       = @l_conc_ent_id          
                          AND   a.entac_concm_cd     = @l_entac_concm_cd        
                          AND   a.entac_deleted_ind  = 1        
                          AND   b.conc_deleted_ind   = 1)        
                BEGIN        
                -- 
                --PRINT 'PP'
                --PRINT @l_conc_value_old
                --PRINT @l_conc_value
                --PRINT 'PP1'
                  IF @l_conc_value_old = @l_conc_value_new         
                  BEGIN        
                  --        
                    PRINT 'SAME VALUE SO DO NOTHING'        
                  --        
                  END        
                  ELSE        
                  BEGIN        
                  --        
                     
    
                     IF EXISTS(SELECT entac_adr_conc_id         
                               FROM   entity_adr_conc       WITH(NOLOCK)        
                               WHERE  entac_concm_id          = @l_entac_concm_id        
                               AND    entac_adr_conc_id       = @l_entac_adr_conc_id        
                               AND    entac_ent_id           <> @l_conc_ent_id          
                               AND    entac_deleted_ind       = 1        
                               )  or (@l_conc_value_old <> @l_conc_value_new )
                      BEGIN          
                      --        
                  
                               
                         SELECT @l_conc_id       =bitrm_bit_location        
                         FROM   bitmap_ref_mstr  WITH(NOLOCK)        
                         WHERE  bitrm_parent_cd  = 'ADR_CONC_ID'        
                         AND    bitrm_child_cd   = 'ADR_CONC_ID'        
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
                         (@l_conc_id        
                         ,@l_conc_value_new        
                         ,@pa_login_name        
                         ,getdate()        
                         ,@pa_login_name        
                         ,getdate()        
                         ,1      
                         )        
                         --                                    
                         SET @@l_error = @@error        
                         --        
                    IF @@l_error > 0      --if any error reports then generate the error string        
                         BEGIN        
                         --        
                           SET @@t_errorstr = convert(varchar,@@l_error)       
                           --        
                                 
                         --        
                         END        
                         ELSE        
                         BEGIN        
                           --        
                                 
                           UPDATE entity_adr_conc     WITH(ROWLOCK)        
                           SET    entac_adr_conc_id = @l_conc_id          
                           WHERE  entac_ent_id      = @l_conc_ent_id         
                           AND    entac_concm_id    = @l_entac_concm_id        
                           AND    entac_deleted_ind = 1        
                           --      
                           SET @@l_error = @@ERROR        
                           --        
                           IF @@l_error > 0      
                           BEGIN        
                           --        
                             SET @@t_errorstr = convert(varchar,@@l_error)       
                             --        
                                   
                           --        
                           END          
                         --        
                         END        
                      --        
                      END        
                      --ELSE UPDATE IT IN CONTACT_CHANNELS        
                      ELSE        
                      BEGIN        
                      --        

                        UPDATE contact_channels    WITH(ROWLOCK)        
                        SET    conc_value        = @l_conc_value_new        
                              ,conc_lst_upd_by   = @pa_login_name        
                              ,conc_lst_upd_dt   = getdate()        
                        WHERE  conc_id           = @l_entac_adr_conc_id         
                        AND    conc_deleted_ind  = 1        
                        --      
                        SET @@l_error = @@ERROR        
                        --        
                        IF @@l_error > 0      
                        BEGIN        
                        --        
                          SET @@t_errorstr = convert(varchar,@@l_error)       
                          --        
                                
                        --        
                        END          
                      --        
                      END        
                  --        
                  END        
                --        
                END        
                ELSE        
                BEGIN        
                --        
                   --INSERT INTO CONTACT_CHANNELS AND ALSO IN ENTAC        
                        
                         
                   SELECT @l_conc_id       = bitrm_bit_location        
                   FROM   bitmap_ref_mstr    WITH(NOLOCK)        
                   WHERE  bitrm_parent_cd  = 'ADR_CONC_ID'        
                   AND    bitrm_child_cd   = 'ADR_CONC_ID'        
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
                   (@l_conc_id                           ,@l_conc_value_new        
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
                     SET @@t_errorstr = convert(varchar,@@l_error)       
                     --        
                           
                   --        
                   END          
                   -- 
                   if not exists (select entac_ent_id , entac_concm_id from entity_adr_conc where entac_ent_id = @l_conc_ent_id and entac_concm_id = @l_entac_concm_id and entac_deleted_ind = 1)       
                   begin
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
                   (@l_conc_ent_id         
                   ,@pa_acct_no        
                   ,@l_entac_concm_id        
                   ,@l_entac_concm_cd        
                   ,@l_conc_id        
                   ,@pa_login_name        
                   ,getdate()        
                   ,@pa_login_name        
                   ,getdate()        
                   ,1)  
                   end 
                   else 
                   begin
                   update  entity_adr_conc
                   set  entac_adr_conc_id = @l_conc_id
                       ,entac_lst_upd_by = @pa_login_name
                       ,entac_lst_upd_dt = getdate()
                   where entac_ent_id =  @l_conc_ent_id
                   and   entac_concm_id =  @l_entac_concm_id
                   and   entac_deleted_ind = 1 
                   end          
                           
                   SET @@l_error = @@error        
                   --        
                   IF @@l_error > 0      --if any error reports then generate the error string        
                   BEGIN        
                   --        
                     SET @@t_errorstr = convert(varchar,@@l_error)       
                     --        
                           
                   --        
                   END        
                   ELSE        
                   BEGIN        
                     --        
                     UPDATE contact_channels_mak  WITH(ROWLOCK)              
                     SET    conc_deleted_ind = 9        
                          , conc_lst_upd_by  = @pa_login_name        
                          , conc_lst_upd_dt  = GETDATE()        
                     WHERE  conc_deleted_ind = 8        
                     AND    concmak_id       = CONVERT(NUMERIC,@@currstring1)        
                     --      
                     SET @@l_error = @@ERROR        
                     --        
                     IF @@l_error > 0      
                     BEGIN        
                     --        
                       SET @@t_errorstr = convert(varchar,@@l_error)       
                       --        
                             
                     --        
                     END          
                     --        
                  END          
                --        
                END        
                --        
             
              --        
              END        
              ELSE IF @l_deleted_ind = 0        
              BEGIN        
              --        
                IF EXISTS(SELECT conc_id        
                          FROM   contact_channels    WITH(NOLOCK)        
                          WHERE  conc_value        = @l_conc_value_new        
                          AND    conc_deleted_ind  = 1        
                         )        
                BEGIN        
                  --      
           
                  SELECT @l_conc_id        = conc_id        
                  FROM   contact_channels    WITH(NOLOCK)        
                  WHERE  conc_value        = @l_conc_value_new        
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
                  (@l_conc_ent_id        
                  ,@pa_acct_no        
                  ,@l_entac_concm_id        
                  ,@l_entac_concm_cd        
                  ,@l_conc_id        
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
                    SET @@t_errorstr = convert(varchar,@@l_error)       
                    --        
               
                  --        
                  END          
                --        
                END        
                ELSE        
                BEGIN        
                --        
                     
                   --      
                   SELECT @l_conc_id       = bitrm_bit_location        
                   FROM   bitmap_ref_mstr  WITH(NOLOCK)        
                   WHERE  bitrm_parent_cd  = 'ADR_CONC_ID'        
                   AND    bitrm_child_cd   = 'ADR_CONC_ID'        
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
                   (@l_conc_id        
                   ,@l_conc_value_new        
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
                     SET @@t_errorstr = convert(varchar,@@l_error)       
                   --        
                           
                   --        
                   END                             
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
                   (@l_conc_ent_id         
                   ,@pa_acct_no        
                   ,@l_entac_concm_id        
                   ,@l_entac_concm_cd    
                   ,@l_conc_id        
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
                     SET @@t_errorstr = convert(varchar,@@l_error)       
                     --        
                           
                   --        
                   END        
                   ELSE        
                   BEGIN        
                     --        
                     UPDATE contact_channels_mak  WITH(ROWLOCK)              
                     SET    conc_deleted_ind = 1        
                          , conc_id          = @l_conc_id        
                          , conc_lst_upd_by  = @pa_login_name        
                          , conc_lst_upd_dt  = GETDATE()        
                     WHERE  conc_deleted_ind = 0        
                     AND    concmak_id       = CONVERT(NUMERIC,@@currstring1)        
                     --      
                     SET @@l_error = @@ERROR      
                     --      
                     IF @@l_error > 0      
                     BEGIN      
                     --      
                       SET @@t_errorstr = convert(varchar,@@l_error)      
                       --      
                             
                     --      
                     END      
                   --        
                   END        
                     UPDATE contact_channels_mak  WITH(ROWLOCK)              
                     SET    conc_deleted_ind = 1        
                          , conc_id          = @l_conc_id        
                          , conc_lst_upd_by  = @pa_login_name        
                          , conc_lst_upd_dt  = GETDATE()        
                     WHERE  conc_deleted_ind = 0        
                     AND    concmak_id       = CONVERT(NUMERIC,@@currstring1)    
                --        
                END        
              --        
              END        
              --move to pr_app_client      
              --EXEC pr_ins_upd_list @pa_ent_id, 'A','CONTACT CHANNELS', @pa_login_name,'*|~*','|*~|',''      
              --      
            --        
            END        
            ELSE IF @pa_action='REJ'        
            BEGIN        
            --        
              UPDATE contact_channels_mak   WITH(ROWLOCK)       
              SET    conc_deleted_ind = 3        
              ,conc_lst_upd_by  = @pa_login_name        
                    ,conc_lst_upd_dt  = GETDATE()        
              WHERE  conc_deleted_ind IN(0,4,8)        
              AND    concmak_id       = CONVERT(numeric,@@currstring1)        
              --      
              SET @@l_error = @@ERROR      
              --      
              IF @@l_error > 0      
              BEGIN      
              --      
                SET @@t_errorstr = convert(varchar,@@l_error)      
                --      
                      
              --      
              END      
            --        
            END        
          --          
          END  --2        
        --        
        END--1        
      --        
      END --@pa_chk_yn = 1        
    --        
    END -- END OF FOR CURRSTRING        
    --        
  END  --END OF WHILE CURRSTRING        
        
  IF @@t_errorstr=''        
  BEGIN        
    --        
   SET @pa_msg = 'Contact Channels Successfully Inserted/Edited'+ @rowdelimiter        
    --        
  END        
  ELSE        
  BEGIN        
--        
    SET @pa_msg = @@t_errorstr        
    --        
  END        
  --        
  END --END FOR CONDITION CHECKING PA_IS,PA_ACTION,PA_LOGIN_NAME IS NULL OR NOT        
--        
END  --END OF MAIN BEGIN

GO
