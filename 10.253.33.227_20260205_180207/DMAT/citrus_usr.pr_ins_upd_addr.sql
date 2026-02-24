-- Object: PROCEDURE citrus_usr.pr_ins_upd_addr
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--select * from entity_adr_conc where entac_ent_id = 55099
--select * from addresses where adr_id in( 838,836)
--select * from addresses_mak where adr_ent_id = 55099 and adr_deleted_ind in (0,4,8)

--pr_ins_upd_addr '139','EDT','HO',139,'','',0,'*|~*','|*~|',''              
--SELECT * FROM ENTITY_ADR_CONC WHERE ENTAC_ADR_CONC_ID = 139              
--select * from addresses_mak where adr_ent_id = 55099
--begin transaction
--pr_ins_upd_addr '643*|~*644*|~*','APP','HO',55099,'','0',1,'*|~*','|*~|',''	
--	55100	EDT	HO	55100		COR_ADR1|*~|AA|*~|A|*~|A|*~|A|*~|ASSAM|*~|INDIA|*~|111111*|~*OFF_ADR1|*~|AA|*~|A|*~|A|*~|A|*~|ASSAM|*~|INDIA|*~|111111*|~*PER_ADR1|*~|AA|*~|A|*~|A|*~|A|*~|ASSAM|*~|INDIA|*~|111111*|~*VSETOFFICE|*~|AA|*~|A|*~|A|*~|A|*~|ASSAM|*~|INDIA|*~|111111*|~*	1	*|~*	|*~|	
--pr_ins_upd_addr '55100','EDT','HO',55100,'','COR_ADR1|*~|AA|*~|A|*~|A|*~|A|*~|ASSAM|*~|INDIA|*~|111111*|~*OFF_ADR1|*~|AA|*~|A|*~|A|*~|A|*~|ASSAM|*~|INDIA|*~|111111*|~*PER_ADR1|*~|AA|*~|A|*~|A|*~|A|*~|ASSAM|*~|INDIA|*~|111111*|~*VSETOFFICE|*~|AA|*~|A|*~|A|*~|A|*~|ASSAM|*~|INDIA|*~|111111*|~*',1,'*|~*','|*~|',''	
--select * from addresses_mak where adr_ent_id = 55100 and adr_deleted_ind = 0
--rollback transaction
CREATE PROCEDURE [citrus_usr].[pr_ins_upd_addr] (@pa_id                VARCHAR(8000)                
                                ,@pa_action            VARCHAR(20)                
                                ,@pa_login_name        VARCHAR(20)                
                                ,@pa_ent_id            NUMERIC                
                                ,@pa_acct_no           VARCHAR(20)                
                                ,@pa_values            VARCHAR(8000)                
                                ,@pa_chk_yn            NUMERIC                
                                ,@rowdelimiter         CHAR(4) =  '*|~*'                
                                ,@coldelimiter         CHAR(4)  = '|*~|'                
                                ,@pa_msg               VARCHAR(8000) OUTPUT                
)                
AS                
BEGIN                
--                
  SET NOCOUNT ON                
  --                
  DECLARE @@t_errorstr         VARCHAR(8000)                
         ,@@l_error            BIGINT                
         ,@delimeter           VARCHAR(10)                
         ,@delimeter1          VARCHAR(10)                 
         ,@@remainingstring    VARCHAR(8000)                
         ,@@currstring         VARCHAR(8000)                
         ,@@remainingstring2   VARCHAR(8000)                
         ,@@currstring2        VARCHAR(8000)                
         ,@@foundat            INTEGER                
         ,@@delimeterlength    INTEGER                
         ,@l_counter           NUMERIC                
         ,@l_entac_concm_id    NUMERIC                
         ,@l_entac_adr_conc_id NUMERIC                
         ,@l_entac_concm_cd    VARCHAR(20)                
         ,@l_adr_id            VARCHAR(20)                
         ,@l_adr_1             VARCHAR(50)                
         ,@l_adr_2             VARCHAR(50)                
         ,@l_adr_3             VARCHAR(50)                
         ,@l_adr_city          VARCHAR(50)                
         ,@l_adr_state         VARCHAR(50)                
         ,@l_adr_country       VARCHAR(50)                
         ,@l_adr_zip           VARCHAR(50)                
         ,@l_addr_oldvalue     VARCHAR(8000)                
         ,@l_old_adr_id        NUMERIC                
         ,@l_conc_oldvalue     VARCHAR(8000)                
         ,@l_concm_desc        VARCHAR(8000)                
         ,@@c_access_cursor    CURSOR                 
         ,@l_addrmak_id        NUMERIC                 
         ,@l_adrm_id           NUMERIC                
         ,@@c_entac_ent_id     NUMERIC                
         ,@@c_entac_concm_cd   VARCHAR(50)                
         ,@@c_adr_id           NUMERIC                
         ,@@c_entac_concm_id   NUMERIC                
         ,@@c_adr_1            VARCHAR(250)                  
         ,@@c_adr_2            VARCHAR(250)                  
         ,@@c_adr_3            VARCHAR(250)                  
         ,@@c_adr_city         VARCHAR(50)                  
         ,@@c_adr_state        VARCHAR(50)                  
         ,@@c_adr_country      VARCHAR(50)                  
         ,@@adr_zip         VARCHAR(10)               
         ,@l_adr_ent_id        NUMERIC                 
         ,@l_deleted_ind       CHAR(1)            
         ,@l_adr_concm_id      NUMERIC                
         ,@l_adr_concm_cd      VARCHAR(25)                
         ,@l_adr_value_old     varchar(1000)                
         ,@L_EDT_DEL_ID        NUMERIC             
         ,@l_count             int                 
                        
  --  SET @l_counter   = 1                
  SET @@l_error    = 0                
  SET @@t_errorstr = ''                
  --                
  IF @pa_id <> '' AND @pa_action <> '' AND @pa_login_name <> ''                
  --                
  BEGIN                
  --                
    CREATE TABLE #t_recordset                
    (entac_ent_id   NUMERIC                
    ,entac_concm_cd VARCHAR(50)                
    ,adr_id         NUMERIC                
    ,entac_concm_id NUMERIC                
    ,adr_1          VARCHAR(50)                
    ,adr_2          VARCHAR(50)                
    ,adr_3          VARCHAR(50)                
    ,adr_city       VARCHAR(50)                
    ,adr_state      VARCHAR(50)                
    ,adr_country    VARCHAR(50)                
    ,adr_zip        VARCHAR(50)                
    )                

    CREATE TABLE #t_recordset_mak                
    (entac_ent_id   NUMERIC                
    ,entac_concm_cd VARCHAR(50)                
    ,adr_id         NUMERIC                
    ,entac_concm_id NUMERIC                
    ,adr_1          VARCHAR(50)                
    ,adr_2          VARCHAR(50)                
    ,adr_3          VARCHAR(50)                
    ,adr_city       VARCHAR(50)                
    ,adr_state      VARCHAR(50)                
    ,adr_country    VARCHAR(50)                
    ,adr_zip        VARCHAR(50)                
    )         
    --                
                   
    SELECT @l_counter = COUNT(*)                 
    FROM   entity_adr_conc a                
    JOIN   addresses b                 
    ON    (a.entac_adr_conc_id = b.adr_id)                
    WHERE  entac_ent_id        = @pa_ent_id                
    AND    a.entac_deleted_ind = 1                
    AND    b.adr_deleted_ind   = 1                 
                    
    INSERT INTO #t_recordset                
    SELECT a.entac_ent_id                
          ,a.entac_concm_cd                
          ,b.adr_id                
          ,a.entac_concm_id                
          ,b.adr_1                
          ,b.adr_2                
          ,b.adr_3                
          ,b.adr_city                
          ,b.adr_state                
          ,b.adr_country                
          ,b.adr_zip                
    FROM   entity_adr_conc a                
    JOIN   addresses b                 
    ON    (a.entac_adr_conc_id = b.adr_id)                
    WHERE  entac_ent_id        = @pa_ent_id                
    AND    a.entac_deleted_ind = 1                
    AND    b.adr_deleted_ind   = 1   


    INSERT INTO #t_recordset_mak                
    SELECT b.adr_ent_id                
          ,b.adr_concm_cd                
          ,b.adr_id                
          ,b.adr_concm_id                
          ,b.adr_1                
          ,b.adr_2                
          ,b.adr_3                
          ,b.adr_city                
          ,b.adr_state                
          ,b.adr_country                
          ,b.adr_zip                
    FROM   addresses_mak  b                
    WHERE  adr_ent_id        = @pa_ent_id                
    AND    b.adr_deleted_ind   = 0                  

    SET    @@C_ACCESS_CURSOR  = CURSOR FAST_FORWARD FOR                
    SELECT entac_ent_id                
          ,entac_concm_cd                
          ,adr_id                
          ,entac_concm_id                
          ,adr_1                
          ,adr_2                
          ,adr_3                
          ,adr_city                
          ,adr_state                
          ,adr_country                
          ,adr_zip                
    FROM   #t_recordset                
                    
    --                
    SET @delimeter        = '%'+ @rowdelimiter + '%'                
    SET @@delimeterlength = LEN(@rowdelimiter)                
    SET @@remainingstring = @pa_values                
    set @@remainingstring2=@pa_id                
    --                
    WHILE @@remainingstring <> ''                 
    BEGIN                
      --                
      SET @@foundat = 0                
      SET @@foundat =  PATINDEX('%'+@delimeter+'%',@@remainingstring)                
                
      IF @@FOUNDAT > 0                
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
        SET @l_adr_1          = citrus_usr.FN_SPLITVAL(@@currstring,2)                
        SET @l_adr_2          = citrus_usr.FN_SPLITVAL(@@currstring,3)                
        SET @l_adr_3          = citrus_usr.FN_SPLITVAL(@@currstring,4)                
        SET @l_adr_city       = citrus_usr.FN_SPLITVAL(@@currstring,5)                
        SET @l_adr_state      = citrus_usr.FN_SPLITVAL(@@currstring,6)                
        SET @l_adr_country    = citrus_usr.FN_SPLITVAL(@@currstring,7)                
        SET @l_adr_zip        = CONVERT(VARCHAR, citrus_usr.FN_SPLITVAL(@@currstring,8))                
        --                
        SELECT @l_entac_concm_id  = concm_id                 
        FROM   conc_code_mstr     WITH (NOLOCK)                 
        WHERE  concm_cd           = @l_entac_concm_cd                
        AND    concm_deleted_ind  = 1              
                      
        --                
        
        IF @pa_chk_yn = 0    --CHECK STARTS HERE                
        BEGIN                
        --                
         IF @pa_action = 'INS'                
          BEGIN                
            --                
              IF EXISTS(SELECT adr_id                
                        FROM   addresses       WITH (NOLOCK)                
                        WHERE  adr_1           = @l_adr_1                
                        AND    adr_2           = @l_adr_2                
                        AND    adr_3           = @l_adr_3                
                        AND    adr_city        = @l_adr_city                
                        AND    adr_state       = @l_adr_state                
                        AND    adr_country     = @l_adr_country                
                        AND    adr_zip         = @l_adr_zip                
                        AND    adr_deleted_ind = 1                
                       )                
              BEGIN                
              --               
                BEGIN TRANSACTION                
                --                
                SELECT @l_adr_id               = adr_id                
                FROM   addresses               WITH (NOLOCK)                
                WHERE  adr_1                   = @l_adr_1                
                AND    adr_2                   = @l_adr_2                
                AND    adr_3                   = @l_adr_3                
                AND    adr_city                = @l_adr_city                
                AND    adr_state               = @l_adr_state                
                AND    adr_country             = @l_adr_country                
                AND    adr_zip                 = @l_adr_zip                
                AND    adr_deleted_ind         = 1                
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
                ,@l_adr_id                
                ,@pa_login_name                
                ,getdate()                
                ,@pa_login_name     
                ,getdate()                
                ,1)                
                --                
                SET @@l_error = @@error                
                --                
                IF @@L_ERROR > 0                
                BEGIN                
                  --                
                  SELECT @l_concm_desc     = concm_desc                
                  FROM   conc_code_mstr    WITH (NOLOCK)                
                  WHERE  concm_id     = @l_entac_concm_id                
                  AND    concm_deleted_ind = 1                
                  --                
                  SET @@t_errorstr = '#'+ISNULL(@l_concm_desc,'') +' Could not be Inserted/Edited'+@rowdelimiter+ISNULL(@@t_errorstr,'')                
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
              ELSE  --ELSE IF NO RECORD  EXISTS                
              BEGIN                
                --                
                BEGIN TRANSACTION                
                --                
                SELECT @l_adr_id       = bitrm_bit_location                
                FROM   bitmap_ref_mstr WITH(NOLOCK)                
                WHERE  bitrm_parent_cd = 'ADR_CONC_ID'                
                AND    bitrm_child_cd  = 'ADR_CONC_ID'                
                
                UPDATE bitmap_ref_mstr    WITH(ROWLOCK)                
                SET    bitrm_bit_location = bitrm_bit_location+1                
                WHERE  bitrm_parent_cd    = 'ADR_CONC_ID'                
                AND    bitrm_child_cd     = 'ADR_CONC_ID'   
				
				
             
                --                
                INSERT INTO addresses                
                (adr_id                
                ,adr_1                
                ,adr_2                
                ,adr_3                
                ,adr_city                
                ,adr_state                
                ,adr_country                
                ,adr_zip                
                ,adr_created_by                
                ,adr_created_dt                
                ,adr_lst_upd_by                
                ,adr_lst_upd_dt                
        ,adr_deleted_ind)                
                VALUES                
                (@l_adr_id                
                ,@l_adr_1                
                ,@l_adr_2                
                ,@l_adr_3                
                ,@l_adr_city                
                ,@l_adr_state                
                ,@l_adr_country                
                ,@l_adr_zip                
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
                  FROM   conc_code_mstr    WITH (NOLOCK)                
                  WHERE  concm_id          = @l_entac_concm_id       
                  AND    concm_deleted_ind = 1                
                  --                
                  SET @@t_errorstr = '#'+ISNULL(@l_concm_desc,'')+' Could not be Inserted/Edited'+@rowdelimiter+ISNULL(@@t_errorstr,'')                
                  --                
                  ROLLBACK TRANSACTION                
  --                
                 END                
                 ELSE   --NO ERROR FOR ADDRESS                
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
                   ,@l_adr_id                
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
                     FROM   conc_code_mstr    WITH (NOLOCK)                
                     WHERE  concm_id          = @l_entac_concm_id                
                     AND    concm_deleted_ind = 1                
                     --                
                     SET @@t_errorstr = '#'+ISNULL(@l_concm_desc,'')+' Could not be Inserted/Edited'+@rowdelimiter+ISNULL(@@t_errorstr,'')                
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
                 END  --END OF BOTH ADDRESS AND ENTITY_ADR_CONC           
                --                
              END                
          --                
          END     --END OF ACTION                
                
         IF @pa_action='EDT'                
         BEGIN                
           --                
             IF EXISTS(SELECT entac_ent_id                 
                       FROM   #t_recordset                
                       WHERE  entac_concm_cd = @l_entac_concm_cd)                
             BEGIN                
               --                
               SELECT @l_addr_oldvalue=adr_1+'|'+isnull(adr_2,'')+'|'+isnull(adr_3,'')+'|'+isnull(adr_city,'')+'|'+isnull(adr_state,'')+'|'+isnull(adr_country,'')+'|'+isnull(adr_zip,''), @l_old_adr_id=adr_id                
               FROM   #T_RECORDSET                
               WHERE  entac_concm_cd = @l_entac_concm_cd                
               --              
          
               IF @l_addr_oldvalue = @l_adr_1+'|'+isnull(@l_adr_2,'')+'|'+isnull(@l_adr_3,'')+'|'+isnull(@l_adr_city,'')+'|'+isnull(@l_adr_state,'')+'|'+isnull(@l_adr_country,'')+'|'+isnull(@l_adr_zip,'')                
               BEGIN                
                 --            
            
                 DELETE FROM #t_recordset WHERE entac_concm_cd = @l_entac_concm_cd AND entac_ent_id=@pa_ent_id                
                 --                
               END  --BOTH VALUES ARE SAME                
               ELSE                
               BEGIN                
                 --         
                 
                 SELECT @l_old_adr_id     = entac_adr_conc_id                
                 FROM   entity_adr_conc   WITH (NOLOCK)                
                 WHERE  entac_ent_id      = @pa_ent_id                
                 AND    entac_concm_id    = @l_entac_concm_id                
                 AND    entac_deleted_ind = 1                
                 --                
                 DELETE FROM #t_recordset                
                 WHERE  entac_concm_cd = @l_entac_concm_cd                
                 AND    entac_ent_id = @pa_ent_id                
                 --                
                 IF EXISTS(SELECT * FROM entity_adr_conc WITH (NOLOCK)                
                           WHERE    entac_concm_id     = @l_entac_concm_id                
                           AND      entac_adr_conc_id  = @l_old_adr_id                
                           AND      entac_ent_id      <> @pa_ent_id                
                           AND      entac_deleted_ind  = 1)                
                 BEGIN                
                 --             
       
                   BEGIN TRANSACTION                
                   --                
                   SELECT @l_adr_id       =bitrm_bit_location                
                   FROM   bitmap_ref_mstr WITH (NOLOCK)                
                   WHERE  bitrm_parent_cd ='ADR_CONC_ID'                
                   AND    bitrm_child_cd  ='ADR_CONC_ID'                
                
                   UPDATE bitmap_ref_mstr    WITH (ROWLOCK)                
                   SET    bitrm_bit_location = bitrm_bit_location+1                
                   WHERE  bitrm_parent_cd    ='ADR_CONC_ID'                
                   AND    bitrm_child_cd     ='ADR_CONC_ID'                
                   --                
                   INSERT INTO addresses                
                   (adr_id                
                   ,adr_1                
                   ,adr_2                
                   ,adr_3                
                   ,adr_city                
                   ,adr_state                
                   ,adr_country                
                   ,adr_zip                
                   ,adr_created_by                
                   ,adr_created_dt                
                   ,adr_lst_upd_by                
                   ,adr_lst_upd_dt                
                   ,adr_deleted_ind)                
                   VALUES                
                   (@l_adr_id                
                   ,@l_adr_1                
                   ,@l_adr_2                
                   ,@l_adr_3                
                   ,@l_adr_city                
                   ,@l_adr_state                
                   ,@l_adr_country                
                   ,@l_adr_zip                
                   ,@pa_login_name                
                   ,getdate()                
                   ,@pa_login_name                
                   ,getdate()                
                   ,1)                
                   --                
                   SET @@l_error = @@error                
                   --                
                   IF @@l_error > 0      --IF ANY ERROR REPORTS THEN GENERATE THE ERROR STRING                
                   BEGIN                
                     --                
                     SELECT @l_concm_desc     = concm_desc                
                     FROM   conc_code_mstr  WITH (NOLOCK)                
                     WHERE  concm_id          = @l_entac_concm_id                
                     AND    concm_deleted_ind = 1                
                     --                
                     SET @@t_errorstr = '#'+@l_concm_desc+'Could not be Inserted/Edited'+@rowdelimiter+@@t_errorstr                
                     --                
                     ROLLBACK TRANSACTION                
                     --                
                   END  --NO ERROR FOR INSERTION                
                   ELSE                
                   BEGIN        
                     --                
                     UPDATE entity_adr_conc   WITH (ROWLOCK)                
                     SET    entac_adr_conc_id = @l_adr_id                
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
                       FROM   conc_code_mstr    WITH (NOLOCK)                
                       WHERE  concm_id          = @l_entac_concm_id                
					   AND    concm_deleted_ind = 1                
                       --                
                       SET @@t_errorstr='#'+@l_concm_desc+'Could not be Inserted'+@rowdelimiter+@@t_errorstr                
                       --                
                       ROLLBACK TRANSACTION                
                       --                
                     END                
             ELSE --NO ERROR FOR UPDATION                
                     BEGIN                
                       --                
                         COMMIT TRANSACTION  --COMMITING THE ENTIER TRANSACTION                
                       --                
                     END                
                     --                
                   END -- END OF CHECKING FOR FIRST INSERT                
                
                 END   --END OF FIRST INSERT ORE REFERNECED                
                 ELSE                
                 BEGIN                
                   BEGIN TRANSACTION                
                   --              

                   SELECT @l_count = count(*) from entity_adr_conc where entac_ent_id =  @pa_ent_id and entac_adr_conc_id = @l_old_adr_id        
                           
                   IF @l_count = 1        
                   BEGIN        
                   --        
                     UPDATE addresses WITH (ROWLOCK)        
                     SET    adr_1=@l_adr_1        
                           ,adr_2=@l_adr_2        
                           ,adr_3=@l_adr_3        
                           ,adr_city=@l_adr_city        
                           ,adr_state=@l_adr_state        
                           ,adr_country=@l_adr_country        
                           ,adr_zip=@l_adr_zip        
                           ,adr_lst_upd_by=@pa_login_name        
                           ,adr_lst_upd_dt=getdate()        
                     WHERE  adr_id=@l_old_adr_id        
                     AND    adr_deleted_ind=1        
                   --        
                   END        
                   ELSE        
                   BEGIN        
                   --        
                     SELECT @l_adr_id       =bitrm_bit_location        
                     FROM   bitmap_ref_mstr WITH (NOLOCK)        
                     WHERE  bitrm_parent_cd ='ADR_CONC_ID'        
              AND    bitrm_child_cd  ='ADR_CONC_ID'        
        
                     UPDATE bitmap_ref_mstr    WITH (ROWLOCK)        
                     SET    bitrm_bit_location = bitrm_bit_location+1        
                     WHERE  bitrm_parent_cd    ='ADR_CONC_ID'        
                     AND    bitrm_child_cd     ='ADR_CONC_ID'        
                     --        
                     INSERT INTO addresses        
                     (adr_id        
                     ,adr_1        
                     ,adr_2        
                     ,adr_3        
                     ,adr_city        
                     ,adr_state        
                     ,adr_country        
                     ,adr_zip        
                     ,adr_created_by      
                     ,adr_created_dt        
                     ,adr_lst_upd_by        
                     ,adr_lst_upd_dt        
                     ,adr_deleted_ind)        
                     VALUES        
                     (@l_adr_id        
                     ,@l_adr_1        
                     ,@l_adr_2        
                     ,@l_adr_3        
                     ,@l_adr_city        
                     ,@l_adr_state        
                     ,@l_adr_country        
                     ,@l_adr_zip        
                     ,@pa_login_name        
                     ,getdate()        
                     ,@pa_login_name        
                     ,getdate()        
                     ,1)        
                             
                             
                   --        
                   END          
                   --                
                   SET @@l_error = @@error                
                   --                
                   IF @@l_error > 0      --if any error reports then generate the error string                
                   BEGIN                
                     --                
   SELECT @l_concm_desc     = concm_desc                
                     FROM   conc_code_mstr    WITH (NOLOCK)                
                     WHERE  concm_id          = @l_entac_concm_id                
                     AND    concm_deleted_ind = 1                
                     --                
                     SET @@t_errorstr='#'+@l_concm_desc+'Could not be Inserted'+@rowdelimiter+@@t_errorstr                
                     --                
                     ROLLBACK TRANSACTION              
                     --                
                   END                
                   ELSE --IF NO ERROR GENERATED FOR THE UPDATION OF THE ADDRESS                
                   BEGIN                
                   --          
        
                     UPDATE entity_adr_conc   WITH (ROWLOCK)        
                     SET    entac_adr_conc_id = @l_adr_id        
                     WHERE  entac_ent_id      = @pa_ent_id        
                     AND    entac_concm_id    = @l_entac_concm_id        
                     AND    entac_deleted_ind = 1                
        
        
                     COMMIT TRANSACTION                
                   --                
                   END   --UPDATE OF ENTITY_ADR_CONC                
                   --                
                 END      --END OF REFERENCED OR NOT REFERENCED  OR EXISTS                
                 --                
               END --VALUES ARE NOT SAME GETTING ENDED HERE                
               --                
             END --FIRST EXISTS                
             ELSE --ELSE OF FIRST EXISTS                
             BEGIN                
               --                
               IF EXISTS( SELECT adr_id                
                          FROM   addresses WITH (NOLOCK)                
                          WHERE  adr_1=@l_adr_1                
                          AND    adr_2=@l_adr_2                
                           AND    adr_3=@l_adr_3                
                          AND    adr_city=@l_adr_city                
                          AND    adr_state=@l_adr_state                
                          AND    adr_country=@l_adr_country                
                          AND    adr_zip=@l_adr_zip                
                          AND    adr_deleted_ind=1)                
               BEGIN                
                 --                
                 BEGIN TRANSACTION                
                 --                
                 SELECT @l_adr_id      = adr_id                
                 FROM   addresses      WITH (NOLOCK)                
                 WHERE  adr_1          = @l_adr_1                
                 AND    adr_2          = @l_adr_2                
                 AND    adr_3          = @l_adr_3                
                 AND    adr_city       = @l_adr_city                
                 AND    adr_state   = @l_adr_state                
                 AND    adr_country    = @l_adr_country                
                 AND    adr_zip        = @l_adr_zip                
                 AND    adr_deleted_ind= 1                
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
                 ,@l_adr_id                
                 ,@pa_login_name                
                 ,getdate()                
                 ,@pa_login_name                
                 ,getdate()                
                 ,1)                
                 --                
          SET @@l_error = @@error                
                 --                
                 IF @@l_error > 0    --if any error reports then generate the error string                
                 BEGIN                
                   --                
                   SELECT @l_concm_desc     = concm_desc                
                   FROM   conc_code_mstr    WITH (NOLOCK)                
                   WHERE  concm_id          = @l_entac_concm_id                
                   AND    concm_deleted_ind = 1                
                   --                
                   SET @@t_errorstr='#'+@l_concm_desc+'Could not be Inserted/Edited'+@rowdelimiter+ISNULL(@@t_errorstr,'')                
                   --                
                   ROLLBACK TRANSACTION                
                   --                
                 END                
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
                 -- 

              
                 SELECT @l_adr_id       = bitrm_bit_location                
                 FROM   bitmap_ref_mstr WITH (NOLOCK)                
                 WHERE  bitrm_parent_cd = 'ADR_CONC_ID'                
                 AND    bitrm_child_cd  = 'ADR_CONC_ID'                
                 --                
                 UPDATE bitmap_ref_mstr    WITH (ROWLOCK)                
    SET    bitrm_bit_location = bitrm_bit_location+1                
                 WHERE  bitrm_parent_cd    = 'ADR_CONC_ID'                
                 AND    bitrm_child_cd     = 'ADR_CONC_ID'                
                 --                
                 INSERT INTO addresses                
                 ( adr_id                
                  ,adr_1                
                  ,adr_2                
                  ,adr_3                
                  ,adr_city                
                  ,adr_state                
                  ,adr_country                
                  ,adr_zip                
                  ,adr_created_by                
                  ,adr_created_dt                
                  ,adr_lst_upd_by                
                  ,adr_lst_upd_dt                
                  ,adr_deleted_ind)                
                  VALUES                
                  (@l_adr_id                
                  ,@l_adr_1                
                  ,@l_adr_2                
                  ,@l_adr_3          
                  ,@l_adr_city                
          ,@l_adr_state                
                  ,@l_adr_country                
                  ,@l_adr_zip                
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
                    FROM   conc_code_mstr    WITH (NOLOCK)                
                    WHERE  concm_id          = @l_entac_concm_id                
                    AND    concm_deleted_ind = 1                
                    --                
                    SET @@t_errorstr='#'+@l_concm_desc+'Could not be Inserted/Edited'+@rowdelimiter+ISNULL(@@t_errorstr,'')                
                    --                
                    ROLLBACK TRANSACTION                
                    --                
                  END                
                  ELSE  --IF NO ERROR IN ADDRESS                
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
                    ,@l_adr_id                
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
                      FROM   conc_code_mstr    WITH (NOLOCK)                
                      WHERE  concm_id          = @l_entac_concm_id                
                      AND    concm_deleted_ind = 1                
                      --                
                      SET @@t_errorstr='#'+@l_concm_desc+'Could not be Inserted/Edited'+@rowdelimiter+ISNULL(@@t_errorstr,'')                
                      --                
                      ROLLBACK TRANSACTION                
                      --                
                    END                
                    ELSE                
                    BEGIN                
                  --                
                      COMMIT TRANSACTION                
                      --                
                    END  --END OF SUCESSFULLY INSERTION                
                   --                
                  END                
                 --                
               END  --IF EXISTS ENDS HERE                
              --                
             END                
             --                
             SELECT @L_COUNTER= COUNT(*) FROM #T_RECORDSET                
             --                
             BEGIN TRANSACTION                
             --                
             SET @@L_ERROR = @@ERROR                
             --                
             IF @@L_ERROR > 0                
             BEGIN                
               --                
               SELECT @l_concm_desc     = concm_desc                
               FROM   conc_code_mstr                
               WHERE  concm_id          = @l_entac_concm_id                
               AND    concm_deleted_ind = 1                
               --                
               SET @@t_errorstr='#'+@l_concm_desc+'Could not be Inserted/Edited'+@rowdelimiter+ISNULL(@@t_errorstr,'')                
               --                
               ROLLBACK TRANSACTION                
               --                
             END                
             ELSE                
             BEGIN                
               --                
               /*DELETE A FROM addresses A  WHERE                
               NOT EXISTS (SELECT entac_adr_conc_id                
                           FROM   entity_adr_conc B WITH (NOLOCK)                
                           WHERE  B.entac_adr_conc_id = A.adr_id AND B.entac_deleted_ind = 1                
                           )                
                           AND EXISTS (SELECT adr_id                
                                       FROM  #t_recordset C                
                                       WHERE C.adr_id= A.adr_id                
                                      )*/          
               --                
               SET @@l_error = @@error                
               --                
               IF @@l_error > 0                
               BEGIN                
                 --                
                 SELECT @l_concm_desc     = concm_desc                
                 FROM   conc_code_mstr    WITH (NOLOCK)                
                 WHERE  concm_id          = @l_entac_concm_id                
                 AND    concm_deleted_ind = 1                
                 --                
                 SET @@t_errorstr = '#'+@l_concm_desc+'Could not be Inserted/Edited'+@rowdelimiter+ISNULL(@@t_errorstr,'')                
                 --                
                 ROLLBACK TRANSACTION                
                 --                
               END                
               ELSE                
               BEGIN                
                 --                
                 COMMIT TRANSACTION                
                 --                
               END --END CONDITION FOR THE SECOND DELETE                
               --                
             END  --END CONDITION FOR THE FIRST DELETE                
             --                
         --                
         END  --END OF EDT                
       --                  
       END                
       ELSE IF @pa_chk_yn = 1 OR @pa_chk_yn = 2                
       BEGIN                
       --                
                         
         IF EXISTS(SELECT adrm.adr_ent_id                 
                   FROM   addresses_mak  adrm                
                   WHERE  adrm.adr_deleted_ind IN(0,4,8)                
                   AND    adrm.adr_ent_id      = @pa_ent_id                
                   AND    adr_concm_id         = @l_entac_concm_id
                  )          
         BEGIN                
         --                
           UPDATE addresses_mak                
           SET    adr_deleted_ind = 3                
           WHERE  adr_deleted_ind IN(0,4,8)                
           AND    adr_ent_id      = @pa_ent_id                
           AND    adr_concm_id    = @l_entac_concm_id                
           
           delete from #t_recordset_mak where entac_concm_id   =  @l_entac_concm_id         
         --                
         END                
                         
         IF @pa_action='INS'                
         BEGIN                
         --                
                           
           SELECT @l_addrmak_id=isnull(MAX(adrm_id),0)+1 FROM addresses_mak             
                           
           INSERT INTO addresses_mak                
           (adrm_id                
           ,adr_id                
           ,adr_ent_id                
           ,adr_concm_id                
           ,adr_concm_cd                
           ,adr_1                
           ,adr_2                
           ,adr_3                
           ,adr_city                
           ,adr_state                
           ,adr_country                
           ,adr_zip                
           ,adr_created_by                
           ,adr_created_dt                
           ,adr_lst_upd_by                
           ,adr_lst_upd_dt                
           ,adr_deleted_ind)                
           VALUES                
           (@l_addrmak_id                
           ,0 --@l_adr_id                
           ,@pa_ent_id                
           ,@l_entac_concm_id                
           ,@l_entac_concm_cd                
           ,@l_adr_1                
           ,@l_adr_2                
           ,@l_adr_3                
           ,@l_adr_city                
           ,@l_adr_state                
           ,@l_adr_country                
           ,@l_adr_zip                
           ,@pa_login_name                
           ,getdate()                
           ,@pa_login_name                
           ,getdate()                
           ,0)                
                           
                           
           EXEC pr_ins_upd_list @pa_ent_id, 'I','ADDRESSES', @pa_login_name,'*|~*','|*~|',''                 
                           
         --                
         END                
         ELSE IF @pa_action='EDT'                
         BEGIN                
         --                
           IF @pa_values = ''                
           BEGIN                
           -- 
               SET    @@C_ACCESS_CURSOR  = CURSOR FAST_FORWARD FOR                
				SELECT entac_ent_id                
					  ,entac_concm_cd                
					  ,adr_id                
					  ,entac_concm_id                
					  ,adr_1                
					  ,adr_2                
					  ,adr_3                
					  ,adr_city                
					  ,adr_state                
					  ,adr_country                
					  ,adr_zip                
				FROM   #t_recordset      
                
             OPEN @@C_ACCESS_CURSOR                
             FETCH NEXT FROM @@C_ACCESS_CURSOR INTO @@c_entac_ent_id                 
                                                   ,@@c_entac_concm_cd                
                                                   ,@@c_adr_id                
                                                   ,@@c_entac_concm_id                
                                                   ,@@c_adr_1                
                                                   ,@@c_adr_2                
                                                   ,@@c_adr_3                
                                                   ,@@c_adr_city                
                                                   ,@@c_adr_state                
                                                   ,@@c_adr_country                
                                                   ,@@adr_zip                
                             
               WHILE @@fetch_status = 0                
               BEGIN                
               --                
                 SELECT @l_adrm_id = ISNULL(MAX(adrm_id),0)+1 FROM addresses_mak                
                                  
                 INSERT INTO addresses_mak                
                 (adrm_id                
                 ,adr_id                
                 ,adr_ent_id                
                 ,adr_concm_id                
                 ,adr_concm_cd                
                 ,adr_1                
                 ,adr_2                
                 ,adr_3                
                 ,adr_city                
                 ,adr_state                
                 ,adr_country                
                 ,adr_zip                
                 ,adr_created_by                
                 ,adr_created_dt                
                 ,adr_lst_upd_by                
                 ,adr_lst_upd_dt                
                 ,adr_deleted_ind                
                 )                
     VALUES                
           (@l_adrm_id                
                 ,@@c_adr_id                
                 ,@@c_entac_ent_id                 
                 ,@@c_entac_concm_id                
                 ,@@c_entac_concm_cd                
                 ,@@c_adr_1                
                 ,@@c_adr_2                
                 ,@@c_adr_3                
                 ,@@c_adr_city                
                 ,@@c_adr_state                
                 ,@@c_adr_country                
                 ,@@adr_zip                
                 ,@pa_login_name                
                 ,GETDATE()                
                 ,@pa_login_name                
                 ,GETDATE()                
                 ,4                
                 )                
                 --                
                   FETCH NEXT FROM @@C_ACCESS_CURSOR INTO @@c_entac_ent_id                 
                                                         ,@@c_entac_concm_cd                
                                                         ,@@c_adr_id                
                                                         ,@@c_entac_concm_id                
                                                         ,@@c_adr_1                
                                                         ,@@c_adr_2                
                                                         ,@@c_adr_3                
                                                         ,@@c_adr_city                
                                                         ,@@c_adr_state                
                                                         ,@@c_adr_country                
                                                         ,@@adr_zip                
                 --                
               --                
               END                
                               
               --                
               CLOSE @@C_ACCESS_CURSOR                
               DEALLOCATE @@C_ACCESS_CURSOR      
 
                                
               EXEC pr_ins_upd_list @pa_ent_id, 'D','ADDRESSES', @pa_login_name,'*|~*','|*~|',''                             
           --                
           END                
           ELSE                 
           BEGIN                
           --                
             --check into temp table (in pa_values for particular cd changed values are same                 
             --as existing values if yes then nothing and delete those records from temp table                
             IF EXISTS(SELECT entac_ent_id                 
                       FROM #t_recordset                
                       WHERE  entac_concm_cd = @l_entac_concm_cd)                
             BEGIN                
             --                
                             
               SELECT @l_addr_oldvalue=adr_1+ISNULL(adr_2,'')+ISNULL(adr_3,'')+ISNULL(adr_city,'')+ISNULL(adr_state,'')+ISNULL(adr_country,'')+ISNULL(adr_zip,''), @l_old_adr_id=adr_id                
               FROM   #T_RECORDSET                
               WHERE  entac_concm_cd = @l_entac_concm_cd                
               --                
               IF @l_addr_oldvalue = @l_adr_1+ISNULL(@l_adr_2,'')+ISNULL(@l_adr_3,'')+ISNULL(@L_ADR_city,'')+ISNULL(@l_adr_state,'')+ISNULL(@l_adr_country,'')+ISNULL(@l_adr_zip,'')                
               BEGIN                
               --                
                 DELETE FROM #t_recordset WHERE entac_concm_cd = @l_entac_concm_cd AND entac_ent_id=@pa_ent_id                
               --                
               END  --BOTH VALUES ARE SAME                
               ELSE                
               --if no then insert into addresses_mak with deleted ind=8 and delete those records from temp table)                
               BEGIN                
               -- 
   
                   SET    @@C_ACCESS_CURSOR  = CURSOR FAST_FORWARD FOR                
					SELECT entac_ent_id                
						  ,entac_concm_cd                
						  ,adr_id                
						  ,entac_concm_id                
						  ,adr_1                
						  ,adr_2                
						  ,adr_3                
						  ,adr_city                
						  ,adr_state                
						  ,adr_country                
						  ,adr_zip                
					FROM   #t_recordset   
                    where  entac_concm_cd = @l_entac_concm_cd
        
                 OPEN @@C_ACCESS_CURSOR                
                 FETCH NEXT FROM @@C_ACCESS_CURSOR INTO @@c_entac_ent_id                 
                                                       ,@@c_entac_concm_cd                
                                                       ,@@c_adr_id                
                                                       ,@@c_entac_concm_id                
                                                       ,@@c_adr_1                
                                                       ,@@c_adr_2                
                                                       ,@@c_adr_3                
                                                       ,@@c_adr_city                
                                                       ,@@c_adr_state                
                                                       ,@@c_adr_country                
                                                       ,@@adr_zip       

        
                                              
                 WHILE @@fetch_status = 0                
                 BEGIN                
                 --                
                   SELECT @l_adrm_id = ISNULL(MAX(adrm_id),0)+1 FROM addresses_mak                
 

                
                   IF EXISTS(SELECT ENTAC.ENTAC_ENT_ID FROM ENTITY_ADR_CONC ENTAC, ADDRESSES ADDR WHERE ENTAC.ENTAC_ADR_CONC_ID = ADDR.ADR_ID AND ENTAC.ENTAC_ENT_ID = @@c_entac_ent_id AND ADDR.ADR_ID = @@c_adr_id)                                    
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
                
                   INSERT INTO addresses_mak                
                   (adrm_id                
                   ,adr_id                
                   ,adr_ent_id                
                   ,adr_concm_id                
                   ,adr_concm_cd                
                   ,adr_1                
                   ,adr_2                
                   ,adr_3                
                   ,adr_city                
                   ,adr_state                
                   ,adr_country                
                   ,adr_zip                
                   ,adr_created_by                
                   ,adr_created_dt                
                   ,adr_lst_upd_by                
                   ,adr_lst_upd_dt                
                   ,adr_deleted_ind                
                   )                
                   VALUES                
                   (@l_adrm_id                
                   ,@@c_adr_id                
                   ,@@c_entac_ent_id                 
                   ,@@c_entac_concm_id                
                   ,@@c_entac_concm_cd                
                   ,@l_adr_1                
                   ,@l_adr_2                
                   ,@l_adr_3                
                   ,@l_adr_city                
                   ,@l_adr_state                
                   ,@l_adr_country                
                   ,@l_adr_zip             
                   ,@pa_login_name                
                   ,GETDATE()                
                   ,@pa_login_name                
                   ,GETDATE()                
                   ,@L_EDT_DEL_ID                
                   )                
                   select * from addresses_mak where adr_deleted_ind = 8   and adr_ent_id =   @@c_entac_ent_id    
                   FETCH NEXT FROM @@C_ACCESS_CURSOR INTO @@c_entac_ent_id                 
                                                         ,@@c_entac_concm_cd                
                                                         ,@@c_adr_id                
                                                         ,@@c_entac_concm_id                
                                                         ,@@c_adr_1                
                                                         ,@@c_adr_2                
                                                         ,@@c_adr_3                
                                                         ,@@c_adr_city                
                                                         ,@@c_adr_state                
                                                         ,@@c_adr_country                
                                                         ,@@adr_zip                
                                                                       
                   DELETE FROM #t_recordset WHERE entac_concm_cd = @@c_entac_concm_cd AND entac_ent_id=@pa_ent_id                
                                   
           
                
                 --                
                 END                
                                               
                 --                
                   CLOSE @@C_ACCESS_CURSOR                
                   DEALLOCATE @@C_ACCESS_CURSOR                
                   EXEC pr_ins_upd_list @pa_ent_id, 'E','ADDRESSES', @pa_login_name,'*|~*','|*~|',''                 
               --                
               END                
             --                
             END                 
             ELSE                
             BEGIN                
             --                
                              
                             
                                 
               SELECT @l_addrmak_id=isnull(MAX(adrm_id),0)+1 FROM addresses_mak                
             
               INSERT INTO addresses_mak                
               (adrm_id                
               ,adr_id                
               ,adr_ent_id                
               ,adr_concm_id                
               ,adr_concm_cd                
               ,adr_1                
               ,adr_2                
               ,adr_3                
               ,adr_city                
               ,adr_state                
               ,adr_country                
               ,adr_zip                
               ,adr_created_by                
               ,adr_created_dt                
               ,adr_lst_upd_by                
               ,adr_lst_upd_dt                
               ,adr_deleted_ind)                
               VALUES           
               (@l_addrmak_id                
               ,0 --@l_adr_id                
               ,@pa_ent_id                
               ,@l_entac_concm_id                
               ,@l_entac_concm_cd                
               ,@l_adr_1                
               ,@l_adr_2                
               ,@l_adr_3                
               ,@l_adr_city                
               ,@l_adr_state                
               ,@l_adr_country                
               ,@l_adr_zip                
               ,@pa_login_name                
               ,getdate()                
               ,@pa_login_name                
               ,getdate()                
               ,0)                   
                               
               EXEC pr_ins_upd_list @pa_ent_id, 'I','ADDRESSES', @pa_login_name,'*|~*','|*~|',''                 


                 
             --                
             END                
             IF EXISTS(SELECT * FROM #t_recordset)                
             BEGIN                
             --   
                    SET    @@C_ACCESS_CURSOR  = CURSOR FAST_FORWARD FOR                
					SELECT entac_ent_id                
						  ,entac_concm_cd                
						  ,adr_id                
						  ,entac_concm_id                
						  ,adr_1                
						  ,adr_2                
						  ,adr_3                
						  ,adr_city                
						  ,adr_state                
						  ,adr_country                
						  ,adr_zip                
					FROM   #t_recordset      
        
                             
               OPEN @@C_ACCESS_CURSOR                
               FETCH NEXT FROM @@C_ACCESS_CURSOR INTO @@c_entac_ent_id                 
                                                     ,@@c_entac_concm_cd                
                                                     ,@@c_adr_id                
                                                     ,@@c_entac_concm_id                
                                                     ,@@c_adr_1                
                                                     ,@@c_adr_2                
                                                     ,@@c_adr_3                
                                                     ,@@c_adr_city                
                                                     ,@@c_adr_state                
                                                     ,@@c_adr_country                
                                                     ,@@adr_zip                
                                             
                WHILE @@fetch_status = 0                
                BEGIN                
                --                
                  SELECT @l_adrm_id = ISNULL(MAX(adrm_id),0)+1 FROM addresses_mak                
                
                  INSERT INTO addresses_mak                
                  (adrm_id                
                  ,adr_id                
                  ,adr_ent_id                
                  ,adr_concm_id                
                  ,adr_concm_cd                
                  ,adr_1                
                  ,adr_2                
                  ,adr_3                
                  ,adr_city                
                  ,adr_state                
                  ,adr_country                
                  ,adr_zip                
                  ,adr_created_by                
                 ,adr_created_dt                
                  ,adr_lst_upd_by                
                  ,adr_lst_upd_dt                
                  ,adr_deleted_ind                
                  )                
                  VALUES                
                  (@l_adrm_id                
                  ,@@c_adr_id                
                  ,@@c_entac_ent_id                 
                  ,@@c_entac_concm_id                
                  ,@@c_entac_concm_cd                
                  ,@@c_adr_1                
                  ,@@c_adr_2                
                  ,@@c_adr_3                
                  ,@@c_adr_city                
                  ,@@c_adr_state                
                  ,@@c_adr_country                
                  ,@@adr_zip                
                  ,@pa_login_name                
                  ,GETDATE()                
                  ,@pa_login_name                
                  ,GETDATE()                
                  ,4                
                  )                
                 
                                  
                  FETCH NEXT FROM @@C_ACCESS_CURSOR INTO @@c_entac_ent_id                 
                                                        ,@@c_entac_concm_cd                
                                                        ,@@c_adr_id                
                                                        ,@@c_entac_concm_id                
                                                        ,@@c_adr_1                
                                                        ,@@c_adr_2                
                                                        ,@@c_adr_3                
                                        ,@@c_adr_city                
                                                 ,@@c_adr_state                
                                                        ,@@c_adr_country                
                                                        ,@@adr_zip                
                                  
                                  
             --                
             END                
             --                
             EXEC pr_ins_upd_list @pa_ent_id, 'D','ADDRESSES', @pa_login_name,'*|~*','|*~|',''                 
             --else insert remaining records from temp table into addresses_mak with deleted_ind=4                   
           --                
           END                
                           
         --                
         END                
                         
                         
       --                
       END                
       --                
      END -- END OF FOR CURRSTRING                
     --
       
     --
    END --END OF WHILE CURRSTRING                
--    delete from  addresses_mak where adr_concm_id in (select entac_concm_id from #t_recordset_mak)  and adr_ent_id = @pa_ent_id   and adr_deleted_ind = 0        

    --                
    IF (@pa_action='APP' OR @pa_action = 'REJ')                 
    BEGIN                
    --                
                    
      WHILE @@remainingstring2 <> ''                
      BEGIN--1                
      --                
                        
        SET @@foundat = 0                
        SET @@foundat =  PATINDEX('%'+@delimeter+'%',@@remainingstring2)                
--                
        IF  @@foundat > 0                
        BEGIN                
        --                
                        
          SET @@currstring2      = SUBSTRING(@@remainingstring2, 0,@@foundat)                
          SET @@remainingstring2 = SUBSTRING(@@remainingstring2, @@foundat+@@delimeterlength,LEN(@@remainingstring2)- @@foundat+@@delimeterlength)                
                          
        --                
        END                
        ELSE                
        BEGIN                
        --                
          SET @@currstring2 = @@remainingstring2                
          SET @@remainingstring2 = ''                
        --                
        END               
        --                
        IF @@currstring2 <> ''                
        BEGIN--2                
        --                   
          IF @pa_action='APP'                
          BEGIN                
          --                
            --select all record fro addresses_mak where adrm_id=@pa_id and deleted_ind=0,4,8                
            --select old values from addresses                
            SELECT @l_deleted_ind  = adr_deleted_ind                
                  ,@l_adr_ent_id   = adr_ent_id                
                  ,@l_adr_concm_id = adr_concm_id                                  
                  ,@l_adr_concm_cd = adr_concm_cd                                 
                  ,@l_adr_id       = adr_id                
                  ,@l_adr_1        = adr_1                 
                  ,@l_adr_2        = adr_2                
                  ,@l_adr_3        = adr_3                
                  ,@l_adr_city     = adr_city                
                  ,@l_adr_state    = adr_state                
                  ,@l_adr_country  = adr_country           
                  ,@l_adr_zip      = adr_zip                
            FROM   addresses_mak                
            WHERE  adrm_id         = CONVERT(NUMERIC,@@currstring2)                  
            AND    adr_deleted_ind IN(0,4,8)                 
            
            --                                 




            SELECT @l_entac_adr_conc_id    = adr.adr_id                  
                  ,@l_adr_value_old        = adr.adr_1+isnull(adr.adr_2,'')+isnull(adr.adr_3,'')+isnull(adr.adr_city,'')+isnull(adr.adr_state,'')+isnull(adr.adr_country,'')+isnull(adr.adr_zip,'')                  
            FROM   addresses                 adr                  
            JOIN   entity_adr_conc         entac                    
            ON     entac.entac_adr_conc_id = adr.adr_id                  
            WHERE  entac_ent_id            = @l_adr_ent_id                  
            AND    entac_concm_id          = @l_adr_concm_id                  
            AND    entac_concm_cd          = @l_adr_concm_cd                  
            AND    entac_deleted_ind       = 1                  
            AND    adr_deleted_ind         = 1                  
                   
            --                
            IF @l_deleted_ind = 4                
            BEGIN                
            --                
              IF EXISTS(SELECT *                 
                        FROM   entity_adr_conc                
                        WHERE  entac_adr_conc_id =  @l_adr_id                
                        and    entac_ent_id      <> @l_adr_ent_id                
                        and    entac_deleted_ind =  1)                
              BEGIN                
              --                
                UPDATE entity_adr_conc                
                SET    entac_deleted_ind = 0                
                WHERE  entac_deleted_ind = 1                
                AND    entac_ent_id      = @l_adr_ent_id                
                AND    entac_concm_cd    = @l_adr_concm_cd                
                --                
                SET @@l_error = @@error                
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
                UPDATE entity_adr_conc                
                SET    entac_deleted_ind = 0                
                WHERE  entac_deleted_ind = 1                
                AND    entac_ent_id      = @l_adr_ent_id                
                AND    entac_concm_cd    = @l_adr_concm_cd                
                --                
                SET @@l_error = @@error                
                --                
                IF @@l_error > 0                
                BEGIN                
                --                
                  SET @@t_errorstr = convert(varchar,@@l_error)                
                  --                
                                  
                --                
                END                
                --                
                            
                --                
                SET @@l_error = @@error    
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
              UPDATE addresses_mak                
              SET    adr_deleted_ind = 5 
                    , adr_lst_upd_by = @pa_login_name
                   , adr_lst_upd_dt = getdate()                   
                                 
              WHERE  adr_deleted_ind = 4                
              AND    adrm_id         = CONVERT(NUMERIC,@@currstring2)                  
              --                
              SET @@l_error = @@error                
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
            else IF @l_deleted_ind = 8                
            BEGIN                
            --                
  print 'daasddsadsadas'

              IF EXISTS(SELECT * FROM entity_adr_conc WITH (NOLOCK)                
                        WHERE    entac_adr_conc_id  = @l_entac_adr_conc_id                
                         AND     (entac_ent_id      <> @l_adr_ent_id  OR (entac_ent_id  = @l_adr_ent_id AND entac_concm_id <> @l_adr_concm_id))              
                        AND      entac_deleted_ind  = 1)                    
              BEGIN                
              --                
  
                SELECT @l_adr_id       =bitrm_bit_location                
                FROM   bitmap_ref_mstr WITH (NOLOCK)                
                WHERE  bitrm_parent_cd ='ADR_CONC_ID'                
                AND    bitrm_child_cd  ='ADR_CONC_ID'                
                
                UPDATE bitmap_ref_mstr    WITH (ROWLOCK)                
                SET    bitrm_bit_location = bitrm_bit_location+1                
                WHERE  bitrm_parent_cd    ='ADR_CONC_ID'                
                AND    bitrm_child_cd     ='ADR_CONC_ID'                
                --                
                INSERT INTO addresses                
                (adr_id                
                ,adr_1                
                ,adr_2                
                ,adr_3                
                ,adr_city                
                ,adr_state                
                ,adr_country                
                ,adr_zip                
                ,adr_created_by                
                ,adr_created_dt                
                ,adr_lst_upd_by                
                ,adr_lst_upd_dt                
                ,adr_deleted_ind                
                )                
                VALUES                
                (@l_adr_id                
                ,@l_adr_1                
                ,@l_adr_2                
                ,@l_adr_3                
                ,@l_adr_city                
                ,@l_adr_state                
                ,@l_adr_country                
                ,@l_adr_zip                
                ,@pa_login_name                
                ,getdate()                
                ,@pa_login_name                
                ,getdate()                
                ,1                
                )                
                --                 
             

                UPDATE entity_adr_conc     WITH (ROWLOCK)                
                SET    entac_adr_conc_id = @l_adr_id
                     , entac_lst_upd_dt  = getdate()
                     , entac_lst_upd_by  = @pa_login_name
                WHERE  entac_ent_id      = @pa_ent_id                
                AND    entac_concm_id    = @l_adr_concm_id                
                AND    entac_deleted_ind = 1                
                --                
                SET @@l_error = @@error                
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
              
              print @l_entac_adr_conc_id
                          
                UPDATE addresses         WITH (ROWLOCK)                
                SET    adr_1           = @l_adr_1                
                      ,adr_2           = @l_adr_2                
                      ,adr_3           = @l_adr_3                
                      ,adr_city        = @l_adr_city                
                      ,adr_state       = @l_adr_state                            
                      ,adr_country     = @l_adr_country                
                      ,adr_zip         = @l_adr_zip                
                      ,adr_lst_upd_by  = @pa_login_name                
                      ,adr_lst_upd_dt  = getdate()                
                WHERE  adr_id          = @l_entac_adr_conc_id  
                AND    adr_deleted_ind = 1                
                --                
                SET @@l_error = @@error                
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
              UPDATE addresses_mak                
              SET    adr_deleted_ind = 9  
                   , adr_lst_upd_by = @pa_login_name
                   , adr_lst_upd_dt = getdate()                  
              WHERE  adr_deleted_ind = 8                
              AND    adrm_id         = CONVERT(NUMERIC,@@currstring2)                  
  
            --                
            END                
            ELSE IF @l_deleted_ind = 0                
            BEGIN                
            --                
              IF  EXISTS(SELECT adr_id                
                         FROM   addresses       WITH (NOLOCK)                
                         WHERE  adr_1           = @l_adr_1                
                         AND    adr_2           = @l_adr_2                
                         AND    adr_3           = @l_adr_3                
                         AND    adr_city        = @l_adr_city                
                         AND    adr_state       = @l_adr_state                
                         AND    adr_country     = @l_adr_country                
                         AND    adr_zip         = @l_adr_zip                
                    AND    adr_deleted_ind = 1)                
              BEGIN                
              --                
                SELECT @l_adr_id               = adr_id                
                FROM   addresses               WITH (NOLOCK)                
                WHERE  adr_1                   = @l_adr_1                
                AND    adr_2                   = @l_adr_2                
                AND    adr_3                   = @l_adr_3                
                AND    adr_city                = @l_adr_city                
                AND    adr_state               = @l_adr_state                
                AND    adr_country             = @l_adr_country                
                AND    adr_zip                 = @l_adr_zip                
                AND    adr_deleted_ind         = 1                
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
                SELECT adr_ent_id                
                      ,0                
                      ,adr_concm_id                
                      ,adr_concm_cd                
                      ,@l_adr_id                
                      ,@pa_login_name             
                      ,getdate() 
                      ,@pa_login_name                
                      ,getdate()                
                      ,1                
                FROM  addresses_mak                
                WHERE adrm_id = CONVERT(NUMERIC,@@currstring2)                   
                --                
                SET @@l_error = @@error                
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
               
                SELECT @l_adr_id       = bitrm_bit_location                
                FROM   bitmap_ref_mstr   WITH(NOLOCK)                
                WHERE  bitrm_parent_cd = 'ADR_CONC_ID'                
                AND    bitrm_child_cd  = 'ADR_CONC_ID'                
                
                UPDATE bitmap_ref_mstr      WITH(ROWLOCK)                
                SET    bitrm_bit_location = bitrm_bit_location+1                      WHERE  bitrm_parent_cd    = 'ADR_CONC_ID'                
                AND    bitrm_child_cd     = 'ADR_CONC_ID'                
                --                 
              SET @@l_error = @@error                
                --                
                IF @@l_error > 0                
                BEGIN                
                --                
                  SET @@t_errorstr = convert(varchar,@@l_error)                
                  --                
                                  
                --                
                END                
                --                
                INSERT INTO addresses                
                (adr_id                
                ,adr_1                
                ,adr_2                
                ,adr_3                
                ,adr_city                
                ,adr_state                
                ,adr_country                
                ,adr_zip       
                ,adr_created_by                
                ,adr_created_dt                
                ,adr_lst_upd_by                
                ,adr_lst_upd_dt                
                ,adr_deleted_ind                
                )                
                VALUES                
                (@l_adr_id                
                ,@l_adr_1                
                ,@l_adr_2                
                ,@l_adr_3                
                ,@l_adr_city                
                ,@l_adr_state                
                ,@l_adr_country                
                ,@l_adr_zip                
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
                (@l_adr_ent_id                
                ,''                
                ,@l_adr_concm_id                 
                ,@l_adr_concm_cd                
                ,@l_adr_id                
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
              END                
                
              UPDATE addresses_mak                
              SET    adr_deleted_ind = 1                    
                   , adr_lst_upd_by = @pa_login_name
                   , adr_lst_upd_dt = getdate()
              WHERE  adr_deleted_ind = 0                
              AND    adrm_id         = CONVERT(NUMERIC,@@currstring2)                  
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
            --MOVE TOT PR_APP_CLIENT                
            --EXEC pr_ins_upd_list @pa_ent_id, 'A','ADDRESSES', @pa_login_name,'*|~*','|*~|',''                
          --                
          END                
          ELSE IF @pa_action='REJ'                
          BEGIN                
          --                
            UPDATE addresses_mak                
            SET    adr_deleted_ind  = 3                
                  ,adr_lst_upd_by   = @pa_login_name                
                  ,adr_lst_upd_dt   = GETDATE()                
            WHERE  adr_deleted_ind IN(0,4,8)                
            AND    adrm_id          = CONVERT(numeric,@@currstring2)                
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
    END                
--                
END                 
    IF @PA_VALUES = ''            and @pa_action not in ('APP','REJ','INS')   and @pa_chk_yn = 0
    BEGIN                
      DELETE FROM entity_adr_conc                
      WHERE  entac_ent_id       = @pa_ent_id                 
      AND    entac_deleted_ind  = 1                
      AND    entac_concm_id     IN (SELECT entac_concm_id FROM #t_recordset)                
  
    END
    else if @pa_values <> '' and @pa_action = 'EDT' and  @pa_chk_yn in(1,2)
    begin
    --
      delete from addresses_mak where adr_concm_id in (select entac_concm_id from #t_recordset_mak) and adr_ent_id = @pa_ent_id and adr_deleted_ind = 0
    --
    end               
    --IF @pa_action not in ('APP','REJ','INS')   
    --BEGIN         
    --DELETE FROM entity_adr_conc                
    --WHERE  entac_ent_id       = @pa_ent_id                 
    --AND    entac_deleted_ind  = 1                
    --AND    entac_concm_id     IN (SELECT entac_concm_id FROM #t_recordset)                
    --END  
    -- 
    
    IF ISNULL(@@t_errorstr,'') = ''                
    BEGIN                
    --                
      SET @pa_msg = 'Addresses Successfully Inserted'+ @rowdelimiter                
    --                
    END                
    ELSE                
    BEGIN                
    --                
      SET @pa_msg = @@t_errorstr                
    --                
    END                 
--                
END  --END OF CONDITION CHECK FOR PA_ID,PA_LOGIN_NAME,PA_ACTION IS NULL OR NOT                
                
END  --END OF MAIN BEGIN

GO
