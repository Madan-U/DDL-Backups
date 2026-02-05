-- Object: PROCEDURE citrus_usr.pr_ins_upd_entp
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--begin transaction --pr_ins_upd_entp '1','EDT','HO',54880,'','78|*~|1002|*~|*|~*79|*~|aaa|*~|*|~*','1|*~|11|*~|aaa|*~|*|~*1|*~|22|*~|TEST_MAK_6661|*~|*|~*',2,'*|~*','|*~|',''  --select * from entity_properties where entp_id  = 1011 order by 1 desc --select * from entity_property_dtls_mak order by 1 desc --select * from  --rollback transaction 
CREATE  PROCEDURE [citrus_usr].[pr_ins_upd_entp](@pa_id               varchar(8000)        
                               ,@pa_action            varchar(20)        
                               ,@pa_login_name        varchar(20)        
                               ,@pa_ent_id            numeric        
                               ,@pa_acct_no           varchar(20)        
                               ,@pa_values            varchar(8000)        
                               ,@pa_dtls_values       varchar(8000)        
                               ,@pa_chk_yn            numeric        
                               ,@rowdelimiter         char(4)  =  '*|~*'        
                               ,@coldelimiter         char(4)  = '|*~|'        
                               ,@pa_msg               varchar(8000) output        
                               )        
AS        
BEGIN--#001        
--        
  SET NOCOUNT ON    
  --    
  DECLARE  @remainingstring_dtvalue_row   varchar(8000)        
         , @delimeterlength_dtvalue_row   int        
         , @currstring_dtvalue_row        varchar(8000)        
         , @delimeter_dtvalue_row         char(4)      
           --@PA_ID--    
         , @currstring_id                 varchar(8000)    
         , @delimeter_id                  char(4)    
         , @delimeterlength_id            int    
         , @remainingstring_id            varchar(8000)    
         , @foundat_id                    int    
           --#t_dtls_values--    
         , @foundat_dtl_val               int     
         , @l_entpm_cd                    varchar(50)              
         , @l_entpd_cd                    varchar(50)     
         , @l_entpd_value                 varchar(50)    
           --@pa_values    
         , @remainingstring_value         varchar(8000)    
         , @currstring_value              varchar(8000)     
         , @delimeter_value               char(4)    
         , @foundat_val                   int     
         , @delimeterlength_value         int     
         , @l_entpm_value                 varchar(50)    
         , @l_entpm_desc                  varchar(50)    
         , @t_errorstr                    varchar(8000)    
         , @l_error                       int    
         , @l_entp_id                     numeric    
         , @l_entpd_id                    numeric    
         , @l_entpmak_id                  numeric     
         , @l_entdm_id                    numeric    
         , @entpm_prop_id                 numeric    
         , @entdm_id                      numeric    
         , @entpd_value                   varchar(50)    
         , @entdm_cd                      varchar(20)     
         , @@c_access_cursor              cursor    
         , @l_entpm_prop_id               numeric    
         , @l_entdm_cd                    varchar(20)    
         , @l_entdm_desc                  varchar(50)    
         , @l_action                      CHAR(4)     
         , @l_crn_no                      VARCHAR(10)    
         , @l_entp_deleted_ind            SMALLINT    
         , @l_entp_entpm_prop_id          NUMERIC    
         , @l_entp_entpm_cd               VARCHAR(20)    
         , @l_entp_value                  VARCHAR(50)    
         , @l_entp_ent_id              NUMERIC    
         , @@c_entpd                      cursor    
         , @l_entpd_entp_id               numeric    
         , @l_entpd_entdm_id              numeric    
         , @l_entpd_entdm_cd              varchar(20)    
         , @l_entpd_created_by            varchar(25)    
         , @l_entpd_created_dt            datetime    
         , @l_entp_id1          numeric     
         ,@l_entpd_deleted_ind           numeric     
         , @l_prop_id_bse                int    
         , @l_prop_id_nse                int    
         , @l_short_name                          varchar(50)    
         , @l_prop_id_nsebse                      int   
         , @l_bitrm_id varchar(8000)
   --    
   SET @l_crn_no = CONVERT(VARCHAR, @pa_ent_id)    
   --     
   IF @pa_action = 'APP' or @pa_action = 'REJ'    
   BEGIN--Temp    
   --    
     CREATE TABLE #entp_mak    
     ( entpmak_id          numeric    
     , entp_id             numeric    
     , entp_ent_id         numeric    
     , entp_acct_no        varchar(25)    
     , entp_entpm_prop_id  numeric    
     , entp_entpm_cd       varchar(20)    
   , entp_value          varchar(50)    
     , entp_created_by     VARCHAR(25)    
     , entp_created_dt     DATETIME    
     , entp_deleted_ind    smallint    
     )    
     --    
     INSERT INTO #entp_mak    
     ( entpmak_id    
     , entp_id    
     , entp_ent_id    
     , entp_acct_no    
     , entp_entpm_prop_id    
     , entp_entpm_cd    
     , entp_value    
     , entp_created_by    
     , entp_created_dt    
     , entp_deleted_ind    
     )      
     SELECT entpmak_id    
          , entp_id            
          , entp_ent_id           
          , entp_acct_no     
          , entp_entpm_prop_id    
          , entp_entpm_cd         
          , entp_value    
          , entp_created_by    
          , entp_created_dt  
          , entp_deleted_ind    
     FROM   entity_properties_mak    
     WHERE  entp_deleted_ind IN (0,4,8)    
     and    ENTP_ENT_ID = @PA_ENT_ID  
    
     union  
  
     SELECT entp_id   
          , entp_id            
          , entp_ent_id           
          , entp_acct_no     
          , entp_entpm_prop_id    
          , entp_entpm_cd         
          , entp_value    
          , entp_created_by    
          , entp_created_dt  
          , entp_deleted_ind    
     FROM   entity_properties    
     WHERE  entp_deleted_ind = 1   
     and    ENTP_ENT_ID = @PA_ENT_ID    
     and    entp_entpm_prop_id  not in   
    (SELECT entp_entpm_prop_id   
     FROM   entity_properties_mak    
     WHERE  entp_deleted_ind IN (0,4,8)    
     and    ENTP_ENT_ID = @PA_ENT_ID)  
  
     --AND    entp_created_by <> @pa_login_name    
     --    
     CREATE TABLE #entp_dtls_mak    
     (entpd_id          numeric    
     ,entpd_entp_id     numeric    
     ,entpd_entdm_id    numeric    
     ,entpd_entdm_cd    varchar(20)    
     ,entpd_value       varchar(50)    
     ,entpd_created_by  varchar(25)    
     ,entpd_created_DT  DATETIME    
     ,entpd_deleted_ind numeric    
     )    
     --    
     INSERT INTO #entp_dtls_mak    
     (entpd_id    
     ,entpd_entp_id    
     ,entpd_entdm_id    
     ,entpd_entdm_cd    
     ,entpd_value    
     ,entpd_created_by    
     ,entpd_created_dt    
     ,entpd_deleted_ind    
     )    
     SELECT entpd_id    
          , entpd_entp_id    
          , entpd_entdm_id    
          , entpd_entdm_cd    
          , entpd_value    
          , entpd_created_by    
          , entpd_created_dt    
          , entpd_deleted_ind    
     FROM   entity_property_dtls_mak    
     WHERE  entpd_deleted_ind IN(0,4,8)
     and ENTPD_ENTP_ID in (select entp_id from  #entp_mak )
     --AND    entpd_created_by  <> @pa_login_name    
         
    
    
         
  --       
  END--Temp      
  --    
  CREATE TABLE #t_dtls_values        
  (entpm_prop_id    varchar(50)        
  ,entdm_id         varchar(50)        
  ,entpd_value      varchar(50)    
  ,entdm_cd         varchar(20)    
  )    
  --    
  SET @remainingstring_dtvalue_row  = @pa_dtls_values        
  SET @delimeterlength_dtvalue_row  = LEN(@rowdelimiter)        
  SET @delimeter_dtvalue_row        = '%'+ @rowdelimiter + '%'        
  --    
  WHILE @remainingstring_dtvalue_row <> ''        
  BEGIN--rem_dtval        
  --        
    SET @foundat_dtl_val = 0        
    SET @foundat_dtl_val =  PATINDEX('%'+@delimeter_dtvalue_row+'%',@remainingstring_dtvalue_row)        
    --        
    IF @foundat_dtl_val > 0        
    BEGIN        
    --       
      SET @currstring_dtvalue_row      = SUBSTRING(@remainingstring_dtvalue_row, 0,@foundat_dtl_val)        
      SET @remainingstring_dtvalue_row = SUBSTRING(@remainingstring_dtvalue_row, @foundat_dtl_val+@delimeterlength_dtvalue_row,len(@remainingstring_dtvalue_row)-@foundat_dtl_val+@delimeterlength_dtvalue_row)        
    --        
    END        
    ELSE        
    BEGIN        
    --        
      SET @currstring_dtvalue_row      = @remainingstring_dtvalue_row        
      SET @remainingstring_dtvalue_row = ''        
    --        
    END        
    --        
    IF @currstring_dtvalue_row <> ''        
    BEGIN        
    --        
      SET @l_entpm_prop_id = CONVERT(numeric, citrus_usr.fn_splitval(@currstring_dtvalue_row,1))        
      SET @l_entdm_id      = CONVERT(numeric, citrus_usr.fn_splitval(@currstring_dtvalue_row,2))        
      SET @l_entpd_value   = citrus_usr.fn_splitval(@currstring_dtvalue_row,3)        
      --    
      SELECT @l_entdm_cd       = entdm_cd        
      FROM   entpm_dtls_mstr     WITH (NOLOCK)        
      WHERE  entdm_id          = @l_entdm_id    
      AND    entdm_deleted_ind = 1    
      --    
      INSERT INTO #t_dtls_values         
      VALUES (@l_entpm_prop_id       
             ,@l_entdm_id        
             ,@l_entpd_value    
             ,@l_entdm_cd    
             )    
      SET @l_entdm_cd = NULL           
    --        
    END      
  --        
  END --rem_dtval    
  --    
  SET @l_entpm_prop_id     = NULL     
  SET @delimeter_id        = '%'+ @rowdelimiter + '%'        
  SET @delimeterlength_id  = LEN(@rowdelimiter)        
  SET @remainingstring_id  = @pa_id    
  SET @foundat_id          = 0      
  --    
  WHILE @remainingstring_id <> ''        
  BEGIN--ID        
    --        
    SET @foundat_id = 0        
    SET @foundat_id =  PATINDEX('%'+@delimeter_id+'%',@remainingstring_id)        
    --        
    IF @foundat_id > 0        
    BEGIN        
    --        
      SET @currstring_id      = substring(@remainingstring_id, 0,@foundat_id)        
      SET @remainingstring_id = substring(@remainingstring_id, @foundat_id+@delimeterlength_id,len(@remainingstring_id)- @foundat_id+@delimeterlength_id)        
    --        
    END        
    ELSE        
    BEGIN        
    --        
      SET @currstring_id      = @remainingstring_id        
      SET @remainingstring_id = ''        
    --        
    END        
    --        
    IF @currstring_id <> ''        
    BEGIN--curr_id        
    --    
      IF @pa_action <> 'APP' AND @pa_action <> 'REJ'    
      BEGIN--not_a_r    
      --    
        IF ISNULL(@pa_values,'') <> '' AND @pa_action = 'EDT'    
        BEGIN--pa_values<>''    
        --    
          SET @delimeter_value        = '%'+ @rowdelimiter + '%'        
          SET @delimeterlength_value  = LEN(@rowdelimiter)    
          SET @remainingstring_value  = @pa_values     
          --    
          WHILE @remainingstring_value <> ''        
          BEGIN--while_rem_val        
          --        
            SET @foundat_val = 0        
            SET @foundat_val =  PATINDEX('%'+@delimeter_value+'%', @remainingstring_value)        
            --        
            IF @foundat_val > 0        
            BEGIN        
            --        
              SET @currstring_value      = substring(@remainingstring_value, 0, @foundat_val)        
              SET @remainingstring_value = substring(@remainingstring_value, @foundat_val+@delimeterlength_value, len(@remainingstring_value)-@foundat_val+@delimeterlength_value)        
            --        
            END        
            ELSE        
            BEGIN        
            --        
              SET @currstring_value      = @remainingstring_value    
              SET @remainingstring_value = ''        
            --        
            END        
            --    
            IF ISNULL(@currstring_value,'') <> ''    
            BEGIN--curr_val    
            --    
              SET @l_entpm_prop_id      = CONVERT(numeric, citrus_usr.fn_splitval(@currstring_value, 1))        
              SET @l_entpm_value        = RTRIM(LTRIM(citrus_usr.fn_splitval(@currstring_value, 2)))      
              --  
              IF exists(select entm_short_name from entity_mstr where entm_id = @pa_ent_id and entm_deleted_ind = 1  and entm_enttm_cd = 'CTD')  
															BEGIN  


																select @l_prop_id_nsebse = convert(varchar(20),entpm_prop_id) from entity_property_mstr where entpm_cd = 'EXCH_CSD'  

																if @l_entpm_prop_id  = @l_prop_id_nsebse  and   @l_entpm_value ='BSE'  
																begin  

																select @l_prop_id_bse = convert(varchar(20),entpm_prop_id) from entity_property_mstr where entpm_cd = 'CTD_CODE_BSE'  


																select @l_short_name  = entm_short_name from entity_mstr where entm_id = @pa_ent_id and entm_deleted_ind = 1    

																if exists(select bitrm_id from bitmap_ref_mstr where bitrm_values = @l_short_name and bitrm_deleted_ind = 1 )
																begin 
																--
																		select @l_bitrm_id = bitrm_id from bitmap_ref_mstr where bitrm_values = @l_short_name and bitrm_deleted_ind = 1 
																		exec pr_mak_bitrm @l_bitrm_id,'EDT',@pa_login_name,'CL',@l_prop_id_bse,'',@l_short_name  ,0,'*|~*','|*~|',''     
																--
																end
																else
																begin
																--
																		exec pr_mak_bitrm '0','INS',@pa_login_name,'CL',@l_prop_id_bse,'',@l_short_name  ,0,'*|~*','|*~|',''     
																--
																end      

																end  


																if @l_entpm_prop_id  = @l_prop_id_nsebse  and   @l_entpm_value ='NSE'  
																begin  


																select @l_prop_id_nse = convert(varchar(20),entpm_prop_id) from entity_property_mstr where entpm_cd = 'CTD_CODE_NSE'  

																select @l_short_name  = entm_short_name from entity_mstr where entm_id = @pa_ent_id and entm_deleted_ind = 1    

																if exists(select bitrm_id from bitmap_ref_mstr where bitrm_values = @l_short_name and bitrm_deleted_ind = 1 )
																begin 
																--
																		select @l_bitrm_id = bitrm_id from bitmap_ref_mstr where bitrm_values = @l_short_name and bitrm_deleted_ind = 1  
																		exec pr_mak_bitrm @l_bitrm_id,'EDT',@pa_login_name,'CL',@l_prop_id_nse,'',@l_short_name,0,'*|~*','|*~|',''     
																--
																end 
																else
																begin
																--
																		exec pr_mak_bitrm '0','INS',@pa_login_name,'CL',@l_prop_id_nse,'',@l_short_name,0,'*|~*','|*~|',''     
																--
																end 

																end  
														                
              END  
              --    
              SELECT DISTINCT @l_entpm_cd = entpm_cd    
              FROM   entity_property_mstr    
              WHERE  entpm_prop_id        = @l_entpm_prop_id     
              AND    entpm_deleted_ind    = 1      
              --    
              IF @pa_chk_yn = 0    
              BEGIN--chk_yn=0    
              --    
                IF ISNULL(@l_entpm_value,'') = ''    
                BEGIN--entpm_value=''    
                --    
                  BEGIN TRANSACTION        
                  --        
                  SELECT @l_entp_id         = entp_id        
                  FROM   entity_properties     WITH(NOLOCK)        
                  WHERE  entp_ent_id        = @pa_ent_id        
                  AND    entp_entpm_prop_id = @l_entpm_prop_id    
                  AND    entp_deleted_ind   = 1     
                  --     
                  UPDATE entity_property_dtls  WITH(ROWLOCK)       
                  SET    entpd_deleted_ind  = 0    
                       , entpd_lst_upd_by   = @pa_login_name    
                       , entpd_lst_upd_dt   = GETDATE()    
                  WHERE  entpd_entp_id      = @l_entp_id    
                  AND    entpd_deleted_ind  = 1     
                  --    
                  SET @l_error = @@ERROR        
                  --        
                  IF @l_error > 0        
                  BEGIN--roll        
                  --        
                    SELECT DISTINCT @l_entpm_desc = entpm_desc        
                    FROM   entity_property_mstr   WITH(NOLOCK)        
                    WHERE  entpm_prop_id          = @l_entpm_prop_id        
                    AND    entpm_deleted_ind      = 1        
                    --        
                    SET @t_errorstr = '#'+@l_entpm_desc + ' could not be inserted/edited'+@rowdelimiter        
                    --        
                    ROLLBACK TRANSACTION        
                  --        
                  END--roll        
                  ELSE    
                  BEGIN--com    
                  --    
                    UPDATE entity_properties   WITH(ROWLOCK)       
                    SET    entp_deleted_ind  = 0    
                         , entp_lst_upd_by   = @pa_login_name    
                         , entp_lst_upd_dt   = GETDATE()   
                    WHERE  entp_id      = @l_entp_id    
                    AND    entp_deleted_ind  = 1     
                    --    
                    SET @l_error   = @@ERROR        
                    --        
                    IF @l_error > 0        
                    BEGIN --#1        
                    --        
                      SELECT TOP 1 @l_entpm_desc = entpm_desc        
                      FROM   entity_property_mstr   WITH(NOLOCK)        
                      WHERE  entpm_prop_id          = @l_entpm_prop_id        
                      AND    entpm_deleted_ind      = 1        
                      --        
                      SET @t_errorstr = '#'+@l_entpm_desc+' could not be inserted/edited'+@rowdelimiter        
                      --        
                      ROLLBACK TRANSACTION        
                    --        
                    END  --#1        
                    ELSE        
                    BEGIN--#2        
                    --        
                      SET @t_errorstr = 'Client properties successfuly inserted/edited'+@rowdelimiter        
                      --        
                      COMMIT TRANSACTION        
                    --        
                    END  --#2    
                    --    
                    SET @l_entp_id = null        
                  --      
                  END--com      
                --    
                END--entpm_value=''    
                --    
                IF ISNULL(@l_entpm_value,'') <> ''    
                BEGIN--entpm_value<>''    
                --    
                  IF EXISTS(SELECT entp_id        
                            FROM   entity_properties  WITH(NOLOCK)        
                            WHERE  entp_ent_id        = @pa_ent_id        
                            AND    entp_entpm_prop_id = @l_entpm_prop_id)        
                  BEGIN--exist        
                  --        
                    BEGIN TRANSACTION        
                    --        
                    SELECT @l_entp_id          =  entp_id        
                    FROM   entity_properties  WITH(NOLOCK)        
                    WHERE  entp_ent_id         = @pa_ent_id        
                    AND    entp_entpm_prop_id  = @l_entpm_prop_id        
                    --        
                    UPDATE entity_properties WITH(ROWLOCK)        
                    SET    entp_value          = @l_entpm_value        
                         , entp_lst_upd_by     = @pa_login_name        
                         , entp_lst_upd_dt     = GETDATE()        
                    WHERE  entp_ent_id         = @pa_ent_id        
                    AND    entp_entpm_prop_id  = @l_entpm_prop_id        
                    AND    entp_deleted_ind    = 1        
                    --        
                    SET @l_error               = @@ERROR        
                    --        
                    IF @l_error > 0        
                    BEGIN --#1        
                    --        
                      SELECT DISTINCT @l_entpm_desc  = entpm_desc        
                      FROM   entity_property_mstr  WITH(NOLOCK)        
                      WHERE  entpm_prop_id           = @l_entpm_prop_id      
                      AND    entpm_deleted_ind       = 1        
                      --        
                      SET @t_errorstr = '#'+@l_entpm_desc+' could not be inserted/edited'+@rowdelimiter        
                      --        
           ROLLBACK TRANSACTION        
                    --        
                    END--#1        
                    ELSE        
                    BEGIN--#2        
                    --        
                      SET @t_errorstr = 'Client properties successfuly inserted/edited'+@rowdelimiter        
                      --        
                      COMMIT TRANSACTION        
                    --        
                    END--#2        
                    --    
                    SET @l_entp_id     = NULL        
                  --        
                  END --exists    
                  ELSE    
                  BEGIN--not_exist    
                  --    
                    BEGIN TRANSACTION        
                    --        
                     SELECT @l_entp_id1  = ISNULL(MAX(entp_id),0) +1 FROM  entity_properties_mak    
                    SELECT @l_entp_id  = ISNULL(MAX(entp_id),0) +1 FROM   entity_properties    
                                                          
                    IF @l_entp_id1 > @l_entp_id    
                    BEGIN    
                    --    
                      SET @l_entp_id = @l_entp_id1    
                    --    
                    END  
                    --    
                    INSERT INTO entity_properties        
                    (entp_id        
                    ,entp_ent_id        
                    ,entp_acct_no        
                    ,entp_entpm_prop_id        
                    ,entp_entpm_cd        
                    ,entp_value        
                    ,entp_created_by        
                    ,entp_created_dt        
                    ,entp_lst_upd_by        
                    ,entp_lst_upd_dt        
                    ,entp_deleted_ind        
                    )        
                    VALUES        
                    (@l_entp_id        
                    ,@pa_ent_id        
                    ,@pa_acct_no        
                    ,@l_entpm_prop_id        
                    ,@l_entpm_cd        
                    ,@l_entpm_value       
                    ,@pa_login_name        
                    ,GETDATE()        
                    ,@pa_login_name        
                    ,GETDATE()        
                    ,CASE WHEN @l_entpm_cd =  'LC' THEN 0     
                          WHEN RIGHT(@l_entpm_cd,7) =  'CUR_VAL' THEN 0  ELSE 1 end    
                    )        
                    --        
                    SET @l_entp_id = NULL        
                    --        
                    SET @l_error  = @@ERROR        
                    --        
                    IF @l_error > 0        
                    BEGIN --#1        
                    --        
                      SELECT DISTINCT @l_entpm_desc  = entpm_desc        
                      FROM   entity_property_mstr    WITH(NOLOCK)        
                      WHERE  entpm_prop_id           = @l_entpm_prop_id       
                      AND    entpm_deleted_ind       = 1        
                      --        
                      SET @t_errorstr = '#'+@l_entpm_desc +' Could Not Be Inserted/Edited'+@rowdelimiter        
                      --        
                      ROLLBACK TRANSACTION        
                    --        
                    END--#1        
                    ELSE        
                    BEGIN--#2        
                    --        
                      SET @T_ERRORSTR = 'Client Properties Successfuly Inserted/Edited'+@ROWDELIMITER        
                      --        
                      COMMIT TRANSACTION        
                    --        
                    END--#2        
                  --    
                  END--not_exist    
                --    
                END--entpm_value<>''    
              --      
              END--chk_yn=0    
              --    
              IF @PA_CHK_YN = 1 OR  @PA_CHK_YN = 2    
              BEGIN--chk_yn=1_2    
              --    
                  
                IF EXISTS(SELECT entpmak_id     
                          FROM   entity_properties_mak    
                          WHERE  entp_ent_id        = @pa_ent_id     
                          AND    entp_entpm_prop_id = @l_entpm_prop_id     
                          AND    entp_deleted_ind   IN (0,4,8))      
                BEGIN    
                --    
                  DECLARE @l_old_entp_value numeric
                  
                  SELECT @l_old_entp_value  = entp_id
                  FROM   ENTITY_PROPERTIES_MAK epm
                  WHERE  entp_ent_id        = @pa_ent_id    
                  AND    entp_entpm_prop_id = @l_entpm_prop_id     
                  AND    entp_deleted_ind   IN (0) 
                  
                  UPDATE entity_properties_mak    
                  SET    entp_deleted_ind   = 3    
                        ,entp_lst_upd_by    = @pa_login_name      
                        ,entp_lst_upd_dt    = GETDATE()    
                  WHERE  entp_ent_id        = @pa_ent_id    
                  AND    entp_entpm_prop_id = @l_entpm_prop_id     
                  AND    entp_deleted_ind   IN (0,4,8) 
                  
                  UPDATE entity_properties_mak    
                  SET    entp_deleted_ind   = 3    
                        ,entp_lst_upd_by    = @pa_login_name      
                        ,entp_lst_upd_dt    = GETDATE()    
                  WHERE  entp_ent_id        = @pa_ent_id    
                  AND    entp_entpm_prop_id = @l_entpm_prop_id     
                  AND    entp_deleted_ind   IN (0,4,8)    
                --    
                END     
                    
                IF ISNULL(@l_entpm_value,'') = ''    
                BEGIN--entpm_value=''    
                --    
                  BEGIN TRANSACTION        
                  --        
                  SELECT @l_entpmak_id    = ISNULL(MAX(entpmak_id),0)+1        
                  FROM   entity_properties_mak WITH(NOLOCK)    
                  --changed by tushar jmm 30.05.07     
                  SELECT @l_entp_id         = entp_id        
                  FROM   entity_properties   WITH(NOLOCK)        
                  WHERE  entp_ent_id        = @pa_ent_id        
                  AND    entp_entpm_prop_id = @l_entpm_prop_id    
                  AND    entp_deleted_ind   = 1    
       
                  if isnull(@l_entp_id,0) = 0    
                  begin    
                  --    
                    SELECT @l_entp_id         = entp_id        
                    FROM   entity_properties_mak   WITH(NOLOCK)        
                    WHERE  entp_ent_id     = @pa_ent_id        
                    AND    entp_entpm_prop_id = @l_entpm_prop_id    
                    AND    entp_deleted_ind   in (0,8)    
                  --    
                  end                 
                  --changed by tushar jmm 30.05.07     
                  --        
                  INSERT INTO entity_properties_mak    
                  (entpmak_id    
                  ,entp_id    
                  ,entp_ent_id    
                  ,entp_acct_no    
                  ,entp_entpm_prop_id    
                  ,entp_entpm_cd    
                  ,entp_value    
                  ,entp_created_by    
                  ,entp_created_dt    
                  ,entp_lst_upd_by    
                  ,entp_lst_upd_dt    
                  ,entp_deleted_ind    
                  )    
                  VALUES    
                  (@l_entpmak_id     
                  ,@l_entp_id        
                  ,@pa_ent_id        
                  ,@pa_acct_no        
                  ,@l_entpm_prop_id        
                  ,@l_entpm_cd        
                  ,@l_entpm_value        
                  ,@pa_login_name        
                  ,GETDATE()        
                  ,@pa_login_name        
                  ,GETDATE()        
                  ,4    
                  )        
                  --    
                  SET @l_entp_id = null        
                  --        
                  SET @l_error  = @@ERROR        
                  --        
                  IF @l_error > 0        
                  BEGIN --#1        
                  --        
                    SELECT @l_entpm_desc     = entpm_desc        
                    FROM   entity_property_mstr  with(nolock)        
                    WHERE  entpm_prop_id     = @l_entpm_prop_id        
                    AND    entpm_deleted_ind = 1        
                    --        
                    SET @t_errorstr = '#'+@l_entpm_desc+' could not be inserted/edited'+@rowdelimiter        
                    --        
                    ROLLBACK TRANSACTION        
                  --        
                  END--#1        
                  ELSE        
                  BEGIN--#2        
                  --        
                    SET @t_errorstr = 'Client properties successfuly inserted/edited'+@rowdelimiter        
                    --        
                    COMMIT TRANSACTION        
                  --        
                  END--#2        
                --    
                END--entpm_value=''    
                --    
                IF ISNULL(@l_entpm_value,'') <> ''    
                BEGIN--entpm_value<>''    
                --    
                  IF EXISTS(SELECT entp_id        
                            FROM   entity_properties with(nolock)        
                            WHERE  entp_ent_id        = @pa_ent_id        
                            AND    entp_entpm_prop_id = @l_entpm_prop_id    
                            AND    entp_deleted_ind   = 1 )        
                  BEGIN--exist        
      --        
                    BEGIN TRANSACTION        
                    --    
                    /*SELECT @l_entpmak_id        =  entpmak_id     
                    FROM   entity_properties_mak WITH(NOLOCK)        
                    WHERE  entp_ent_id          = @pa_ent_id        
                    AND    entp_entpm_prop_id   = @l_entpm_prop_id        
                    AND    entp_deleted_ind     = 0*/    
                    SELECT @l_entpmak_id = ISNULL(MAX(entpmak_id),0) + 1        
                    FROM entity_properties_mak WITH(NOLOCK)       
                    --        
    
    
    
                   --changed by tushar jmm 30.05.07     
                   SELECT @l_entp_id         = entp_id        
                   FROM   entity_properties   WITH(NOLOCK)        
                   WHERE  entp_ent_id        = @pa_ent_id        
                   AND    entp_entpm_prop_id = @l_entpm_prop_id    
                   AND    entp_deleted_ind   = 1    
        
                   if isnull(@l_entp_id,0) = 0    
                   begin    
                   --    
                     SELECT @l_entp_id         = entp_id        
                     FROM   entity_properties_mak   WITH(NOLOCK)        
                     WHERE  entp_ent_id     = @pa_ent_id        
                     AND    entp_entpm_prop_id = @l_entpm_prop_id    
                     AND    entp_deleted_ind   in (0,8)    
                   --    
                   end                 
                  --changed by tushar jmm 30.05.07    
                    INSERT INTO entity_properties_mak    
                    (entpmak_id    
                    ,entp_id    
                    ,entp_ent_id    
                    ,entp_acct_no    
                    ,entp_entpm_prop_id    
                    ,entp_entpm_cd    
                    ,entp_value    
                    ,entp_created_by    
                    ,entp_created_dt    
                    ,entp_lst_upd_by    
                    ,entp_lst_upd_dt    
                    ,entp_deleted_ind    
                    )    
                    VALUES    
                    (@l_entpmak_id     
                    ,@l_entp_id        
                    ,@pa_ent_id        
                    ,@pa_acct_no        
                    ,@l_entpm_prop_id        
                    ,@l_entpm_cd        
                    ,@l_entpm_value        
                    ,@pa_login_name        
                    ,GETDATE()        
                    ,@pa_login_name        
                    ,GETDATE()        
                    ,8    
                    )        
                    --         
                    SET @l_entp_id              = NULL        
                    SET @l_error                = @@ERROR        
                    --        
                    IF @l_error > 0        
                    BEGIN --#1        
                    --        
                      SELECT @l_entpm_desc           = entpm_desc        
                      FROM   entity_property_mstr      WITH(NOLOCK)        
                      WHERE  entpm_prop_id           = @l_entpm_prop_id        
                      AND    entpm_deleted_ind = 1        
                      --        
                      SET @t_errorstr = '#'+@l_entpm_desc+' could not be inserted/edited'+@rowdelimiter        
                      --        
                      ROLLBACK TRANSACTION        
                    --        
                    END--#1        
                    ELSE        
                    BEGIN--#2        
                    --        
                      SET @t_errorstr = 'Client properties successfuly inserted/edited'+@rowdelimiter        
                      --        
                      COMMIT TRANSACTION        
                    --        
                    END--#2        
                  --        
                  END --exists    
                  ELSE    
                  BEGIN--not_exist    
                  --    
                  BEGIN TRANSACTION        
                    --    
                    SELECT @l_entpmak_id = ISNULL(MAX(entpmak_id),0) + 1        
                    FROM entity_properties_mak WITH(NOLOCK)        
                    --        
                    SELECT @l_entp_id1  = ISNULL(MAX(entp_id),0) +1 FROM  entity_properties_mak    
                    SELECT @l_entp_id  = ISNULL(MAX(entp_id),0) +1 FROM   entity_properties    
                                                          
                    IF @l_entp_id1 > @l_entp_id    
                    BEGIN    
                    --    
                      SET @l_entp_id = @l_entp_id1    
                    --    
                    END  
                    
--                      IF EXISTS(SELECT entpmak_id     
--                          FROM   entity_properties_mak    
--                          WHERE  entp_ent_id        = @pa_ent_id     
--                          AND    entp_entpm_prop_id = @l_entpm_prop_id     
--                          )      
--						BEGIN    
--						    
--						  SET @l_entp_id = @l_old_entp_value
--						
--						end  
                         
                    INSERT INTO entity_properties_mak        
                    (entpmak_id    
                    ,entp_id        
                    ,entp_ent_id        
                    ,entp_acct_no        
                    ,entp_entpm_prop_id        
                    ,entp_entpm_cd        
                    ,entp_value        
                    ,entp_created_by        
                    ,entp_created_dt        
                    ,entp_lst_upd_by        
                    ,entp_lst_upd_dt        
                    ,entp_deleted_ind        
                    )        
                    VALUES        
                    (@l_entpmak_id    
                    ,@l_entp_id        
                    ,@pa_ent_id        
                    ,@pa_acct_no        
                    ,@l_entpm_prop_id        
                    ,@l_entpm_cd        
                    ,@l_entpm_value       
                    ,@pa_login_name        
                    ,GETDATE()        
                    ,@pa_login_name        
                    ,GETDATE()        
                    ,0    
                    )        
                    --        
                    SET @l_error  = @@ERROR        
                    --        
                    IF @l_error > 0        
                    BEGIN --#1        
                    --        
                      SELECT @l_entpm_desc           = entpm_desc        
                      FROM   entity_property_mstr      WITH(NOLOCK)        
                      WHERE  entpm_prop_id           = @l_entpm_prop_id        
                      AND    entpm_deleted_ind = 1        
                      --        
                      SET @t_errorstr = '#'+@l_entpm_desc+' Could Not Be Inserted/Edited'+@rowdelimiter        
                      --        
                      ROLLBACK TRANSACTION        
                    --        
                    END--#1        
                    ELSE        
                    BEGIN--#2        
                    --        
                      SET @t_errorstr = 'Client Properties Successfuly Inserted/Edited'+@ROWDELIMITER        
                      --        
                      COMMIT TRANSACTION        
                    --        
                    END--#2    
                    --    
                    SET @l_entpmak_id = NULL        
                  --    
                  END--not_exist    
                --    
                END--entpm_value<>''    
              --    
              END  --chk_yn=1_2    
            --      
            END--curr_val    
          --       
          END --while_rem_val    
          --    
          IF @PA_CHK_YN = 1 OR  @PA_CHK_YN = 2    
          BEGIN    
          --    
            SELECT @l_action = CASE @pa_action WHEN 'INS' THEN 'I' WHEN 'EDT' THEN 'E' WHEN 'DEL' THEN 'D' END    
            --    
            EXEC pr_ins_upd_list  @l_crn_no, @l_action,'ENTITY PROPERTIES', @pa_login_name, '*|~*', '|*~|', ''      
          --      
          END      
        --      
        END--pa_values<>''&edt    
        --    
        IF @pa_action = 'EDT' AND RTRIM(LTRIM(@pa_dtls_values)) <> ''    
        BEGIN    
        --    
          IF @pa_chk_yn = 0    
          BEGIN--chk_yn=0    
          --    
            SET @@c_access_cursor =  CURSOR fast_forward FOR        
            SELECT entpm_prop_id        
                 , entdm_id        
                 , entpd_value    
                 , entdm_cd    
            FROM   #t_dtls_values         
    
            --        
            OPEN @@c_access_cursor        
            FETCH next FROM @@c_access_cursor INTO @entpm_prop_id, @entdm_id, @entpd_value, @entdm_cd        
            --    
            WHILE @@fetch_status = 0        
            BEGIN--cur        
            --    
              SELECT @l_entp_id         = entp_id        
              FROM   entity_properties  WITH(NOLOCK)        
              WHERE  entp_ent_id        = @pa_ent_id        
              AND    entp_entpm_prop_id = @entpm_prop_id    
              AND    entp_deleted_ind   = 1     
              --     
              IF rtrim(ltrim(@entpd_value)) = ''        
              BEGIN--entpd_value=''        
              --      
                 
                BEGIN TRANSACTION        
                --    
                UPDATE entity_property_dtls WITH (ROWLOCK)    
                SET    entpd_deleted_ind = 0    
                     , entpd_lst_upd_by  = @pa_login_name    
                     , entpd_lst_upd_dt  = GETDATE()    
                WHERE  entpd_entp_id     = @l_entp_id        
                AND    entpd_entdm_id    = @entdm_id    
                AND    entpd_deleted_ind = 1    
                --        
                SET @l_error    = @@ERROR        
                --        
                IF @l_error > 0        
                BEGIN        
                --     
                  SELECT @l_entdm_desc     = entdm_desc        
                  FROM   entpm_dtls_mstr   WITH(NOLOCK)        
                  WHERE  entdm_id          = @entdm_id        
                  AND    entdm_deleted_ind = 1      
                  --    
                  SET @t_errorstr = '#'+@l_entdm_desc+' could not be inserted/edited'+@rowdelimiter        
                  --    
                  ROLLBACK TRANSACTION        
                --        
                END        
                ELSE        
                BEGIN        
                --        
                  SET @t_errorstr = 'Client properties successfully inserted/edited'+@rowdelimiter        
                  --    
                  COMMIT TRANSACTION        
                --        
                END        
                --    
                SET @l_entp_id  = null        
              --        
              END--entpd_value=''    
              ELSE        
              BEGIN--entpd_value<>''        
              --        
                IF EXISTS(SELECT *        
                          FROM   entity_property_dtls with(NOLOCK)        
                          WHERE  entpd_entp_id  = @l_entp_id        
                          AND    entpd_entdm_id = @entdm_id    
                          AND    entpd_deleted_ind = 1     
                          )        
                BEGIN --exist       
                --        
                  BEGIN TRANSACTION        
                  --        
                  UPDATE entity_property_dtls WITH(ROWLOCK)        
                  SET    entpd_value       = @entpd_value    
                        ,entpd_lst_upd_by  = @pa_login_name    
                        ,entpd_lst_upd_dt  = GETDATE()     
                  WHERE  entpd_entp_id     = @l_entp_id        
                  AND    entpd_entdm_id    = @entdm_id    
                  AND    entpd_deleted_ind = 1        
                  --        
                  SET @l_error = @@ERROR        
                  --        
                  IF @l_error > 0        
                  BEGIN        
                  --        
                    SELECT @l_entdm_desc     = entdm_desc        
                    FROM   entpm_dtls_mstr   WITH(NOLOCK)        
                    WHERE  entdm_id          = @entdm_id        
                    AND    entdm_deleted_ind = 1      
     --    
                    SET @t_errorstr = '#'+@l_entdm_desc+' could not be inserted/edited'+@rowdelimiter        
                    --    
                    ROLLBACK TRANSACTION        
                  --        
                  END        
                  ELSE        
                  BEGIN        
                  --        
                    COMMIT TRANSACTION     
                    --        
                    SET @t_errorstr = 'Client properties successfully inserted/edited'+@rowdelimiter        
                  --        
                  END        
                 --        
                END --exists        
                ELSE        
                BEGIN --not exist        
                --        
                  BEGIN TRANSACTION        
                  --    
                  INSERT INTO entity_property_dtls        
                  (entpd_entp_id        
                  ,entpd_entdm_id        
                  ,entpd_entdm_cd        
                  ,entpd_value        
                  ,entpd_created_by        
                  ,entpd_created_dt        
                  ,entpd_lst_upd_by        
                  ,entpd_lst_upd_dt        
                  ,entpd_deleted_ind)        
                  VALUES        
                  (@l_entp_id        
                  ,@entdm_id        
                  ,@entdm_cd        
                  ,@entpd_value        
                  ,@pa_login_name        
                  ,GETDATE()        
                  ,@pa_login_name        
                  ,GETDATE()        
                  ,1)        
                  --        
                  SET @l_error = @@ERROR        
                  --        
                  IF @l_error > 0        
                  BEGIN        
                  --    
                    SELECT @l_entdm_desc     = entdm_desc        
                    FROM   entpm_dtls_mstr   WITH(NOLOCK)        
                    WHERE  entdm_id          = @entdm_id        
                    AND    entdm_deleted_ind = 1      
                    --    
                    SET @t_errorstr = '#'+@l_entdm_desc+' could not be inserted/edited'+@rowdelimiter        
                    --    
                    ROLLBACK TRANSACTION       
                  --      
                  END        
                  ELSE        
                  BEGIN        
                  --        
                    COMMIT TRANSACTION        
                    --        
                    SET @t_errorstr = 'Client properties successfully inserted/edited'+@rowdelimiter        
                  --        
                  END        
                  --        
                END--not exist        
              --        
              END--@entpd_value <> ''      
              --    
              FETCH NEXT FROM @@c_access_cursor INTO @entpm_prop_id, @entdm_id, @entpd_value, @entdm_cd    
            --    
            END--cur    
            --    
            CLOSE @@c_access_cursor        
            DEALLOCATE @@c_access_cursor    
          --    
          END--chk_yn=0    
          --    
          IF @PA_CHK_YN = 1 OR  @PA_CHK_YN = 2    
          BEGIN--chk_yn=1    
          --    
            SET @@c_access_cursor =  CURSOR fast_forward FOR        
            SELECT entpm_prop_id        
                 , entdm_id        
                 , entpd_value    
                 , entdm_cd    
            FROM #t_dtls_values         
            --        
               
            OPEN @@c_access_cursor    
            --    
            FETCH next FROM @@c_access_cursor INTO @entpm_prop_id, @entdm_id, @entpd_value, @entdm_cd        
            --    
            WHILE @@fetch_status = 0        
            BEGIN--cur        
            --    
                
                
              IF exists(SELECT entp_id        
       FROM   entity_properties_MAK  WITH(NOLOCK)        
       WHERE  entp_ent_id        = @pa_ent_id        
       AND    entp_entpm_prop_id = @entpm_prop_id    
       AND    entp_deleted_ind   IN(0,8)  )  
              BEGIN    
              --    
                SELECT @l_entp_id         = entp_id        
                FROM   entity_properties_MAK  WITH(NOLOCK)        
			   WHERE  entp_ent_id        = @pa_ent_id        
			   AND    entp_entpm_prop_id = @entpm_prop_id    
			   AND    entp_deleted_ind   IN(0,8)   
              --  
              END  
              ELSE  
              BEGIN  
              --   
                SELECT @l_entp_id         = entp_id        
                FROM   entity_properties    WITH(NOLOCK)        
                WHERE  entp_ent_id        = @pa_ent_id       
                AND    entp_entpm_prop_id = @entpm_prop_id    
                AND    entp_deleted_ind   = 1    
              --    
              END    
                
                  
              IF EXISTS(SELECT entpd_id FROM entity_property_dtls_mak WHERE entpd_entp_id = @l_entp_id and entpd_entdm_id = @entdm_id)    
              BEGIN    
              --    
                UPDATE entity_property_dtls_mak    
                SET    entpd_deleted_ind = 3    
                WHERE  entpd_entp_id     = @l_entp_id     
                AND    entpd_entdm_id    = @entdm_id    
                AND    entpd_deleted_ind IN(0,4,8)    
    
              --    
              END    
    
              IF RTRIM(LTRIM(@entpd_value)) = ''        
              BEGIN--entpd_value=''        
              --        
                BEGIN TRANSACTION        
                --        
    
                SELECT @l_entpd_id     = ISNULL(MAX(entpd_id),0)+1     
                FROM entity_property_dtls_mak WITH(NOLOCK)     
    
                   
                --    
                INSERT INTO entity_property_dtls_mak    
                (entpd_id    
                ,entpd_entp_id    
                ,entpd_entdm_id    
                ,entpd_entdm_cd    
                ,entpd_value    
                ,entpd_created_by    
                ,entpd_created_dt    
                ,entpd_lst_upd_by    
                ,entpd_lst_upd_dt    
                ,entpd_deleted_ind    
                )    
                VALUES    
                (@l_entpd_id    
                ,@L_ENTP_ID        --CHANGED BY TUSHAR JMM    
                ,@entdm_id    
                ,@entdm_cd    
                ,@entpd_value     
                ,@pa_login_name        
                ,GETDATE()        
                ,@pa_login_name        
                ,GETDATE()        
                ,4    
                )        
                --        
                SET @l_error = @@ERROR        
                --        
                IF @l_error > 0        
                BEGIN        
                --        
                  SELECT @l_entdm_desc     = entdm_desc        
                  FROM   entpm_dtls_mstr   WITH(NOLOCK)        
                  WHERE  entdm_id          = @entdm_id        
                  AND    entdm_deleted_ind = 1      
                  --    
                  SET @t_errorstr = '#'+@l_entdm_desc+' could not be inserted/edited'+@rowdelimiter        
                  --    
                  ROLLBACK TRANSACTION        
                --        
                END        
                ELSE        
                BEGIN        
                --        
                  COMMIT TRANSACTION        
                  --
                  IF @PA_CHK_YN = 1 OR  @PA_CHK_YN = 2    
			      BEGIN    
					 --    
					SELECT @l_action = CASE @pa_action WHEN 'INS' THEN 'I' WHEN 'EDT' THEN 'E' WHEN 'DEL' THEN 'D' END    
					--    
					EXEC pr_ins_upd_list  @l_crn_no, @l_action,'ENTITY PROPERTIES', @pa_login_name, '*|~*', '|*~|', ''      
					 --      
					 END    
		  
        
                  SET @t_errorstr = 'Client properties successfully inserted/edited'+@rowdelimiter        
                --        
                END    
              --        
              END--entpd_value=''    
              ELSE        
              BEGIN--entpd_value<>''        
              --        
                IF exists(SELECT entpd_entp_id        
                          FROM   entity_property_dtls WITH(NOLOCK)        
                          WHERE  entpd_entp_id     = @L_ENTP_ID       
                          AND    entpd_entdm_id    = @entdm_id        
 AND    entpd_deleted_ind = 1    
                          )        
                BEGIN --exist       
                --        
                  BEGIN TRANSACTION        
                  --        
                  SELECT @l_entpd_id = ISNULL(MAX(entpd_id),0)+1     
                  FROM entity_property_dtls_mak WITH (NOLOCK)    
                  --    
                  INSERT INTO entity_property_dtls_mak    
                  (entpd_id    
                  ,entpd_entp_id    
                  ,entpd_entdm_id    
                  ,entpd_entdm_cd    
                  ,entpd_value    
                  ,entpd_created_by    
                  ,entpd_created_dt    
                  ,entpd_lst_upd_by    
                  ,entpd_lst_upd_dt    
                  ,entpd_deleted_ind    
                  )    
                  VALUES    
                  (@l_entpd_id    
                  ,@L_ENTP_ID     
                  ,@entdm_id    
                  ,@entdm_cd    
                  ,@entpd_value     
                  ,@pa_login_name        
                  ,GETDATE()        
                  ,@pa_login_name        
                  ,GETDATE()        
                  ,8    
                  )        
                  --     
                  SET @l_error = @@error        
                  --        
                  IF @l_error > 0        
                  BEGIN        
                  --        
                    SELECT @l_entdm_desc     = entdm_desc        
                    FROM   entpm_dtls_mstr   WITH(NOLOCK)        
                    WHERE  entdm_id          = @entdm_id        
                    AND    entdm_deleted_ind = 1      
                    --    
                    SET @t_errorstr = '#'+@l_entdm_desc+' could not be inserted/edited'+@rowdelimiter        
                    --    
                    ROLLBACK TRANSACTION          
                  --        
                  END        
                  ELSE        
                  BEGIN        
                  --        
                    COMMIT TRANSACTION        
                    --        
                    SET @t_errorstr = 'Client properties successfully inserted/edited'+@rowdelimiter        
                  --        
                  END        
                 --        
                END --exists        
                ELSE        
                BEGIN --not exist        
                --    
                  BEGIN TRANSACTION        
                  --    
                  SELECT @l_entpd_id = ISNULL(MAX(entpd_id),0)+1     
                  FROM entity_property_dtls_mak WITH (NOLOCK)        
                  --    
                  INSERT INTO entity_property_dtls_mak    
                  (entpd_id    
                  ,entpd_entp_id        
                  ,entpd_entdm_id        
                  ,entpd_entdm_cd        
                  ,entpd_value        
                  ,entpd_created_by        
                  ,entpd_created_dt        
                  ,entpd_lst_upd_by        
                  ,entpd_lst_upd_dt        
                  ,entpd_deleted_ind)        
                  VALUES        
                  (@l_entpd_id    
                  ,@L_ENTP_ID         
                  ,@entdm_id        
                  ,@entdm_cd        
                  ,@entpd_value        
                  ,@pa_login_name        
                  ,GETDATE()        
                  ,@pa_login_name        
                  ,GETDATE()        
                  ,0    
                  )        
                  --        
                  SET @l_error = @@ERROR        
                  --        
                  IF @l_error > 0        
                  BEGIN    
                  --    
                    SELECT @l_entdm_desc     = entdm_desc        
                    FROM   entpm_dtls_mstr   WITH(NOLOCK)        
                    WHERE  entdm_id          = @entdm_id        
                    AND    entdm_deleted_ind = 1      
                    --    
                  SET @t_errorstr = '#'+@l_entdm_desc+' could not be inserted/edited'+@rowdelimiter        
                    --    
                    ROLLBACK TRANSACTION         
                  --      
                  END        
                  ELSE        
                  BEGIN        
                  --        
                    SET @t_errorstr = 'Client properties successfully inserted/edited'+@rowdelimiter        
                    --    
                    COMMIT TRANSACTION        
                  --        
                  END        
                --        
                END--not exist        
  
  
              IF @PA_CHK_YN = 1 OR  @PA_CHK_YN = 2    
			 BEGIN    
			 --    
			SELECT @l_action = CASE @pa_action WHEN 'INS' THEN 'I' WHEN 'EDT' THEN 'E' WHEN 'DEL' THEN 'D' END    
			--    
			EXEC pr_ins_upd_list  @l_crn_no, @l_action,'ENTITY PROPERTIES', @pa_login_name, '*|~*', '|*~|', ''      
			 --      
			 END    
  
  
              --        
  
              END--@@entpd_value <> ''      
              --    
              FETCH NEXT FROM @@c_access_cursor INTO @entpm_prop_id, @entdm_id, @entpd_value, @entdm_cd    
            --    
            END--cur    
            --    
--            SELECT @l_action = CASE @pa_action WHEN 'INS' THEN 'I' WHEN 'EDT' THEN 'E' WHEN 'DEL' THEN 'D' END    
            --    
            --EXEC pr_ins_upd_list  @l_crn_no, @l_action,'CLIENT PROPERTY DETAIL MSTR', @pa_login_name, '*|~*', '|*~|', ''      
            --     
            CLOSE @@c_access_cursor        
            DEALLOCATE @@c_access_cursor    
           --    
          END--chk_yn=1    
        --    
        END    
        --    
        /*IF ISNULL(@pa_values,'') <> '' AND @pa_action = 'DEL'    
        BEGIN--del    
        --     
          SET @delimeter_value         = '%'+ @rowdelimiter + '%'        
          SET @delimeterlength_value   = len(@rowdelimiter)    
          SET @remainingstring_value   = @pa_values     
          --    
          WHILE @remainingstring_value <> ''        
          BEGIN--while_rem_val_del        
          --        
            SET @foundat_val = 0        
            SET @foundat_val =  patindex('%'+@delimeter_value+'%', @remainingstring_value)        
            --        
            IF @foundat_val > 0        
            BEGIN        
            --        
              SET @currstring_value      = substring(@remainingstring_value, 0, @foundat_val)        
              SET @remainingstring_value = substring(@remainingstring_value, @foundat_val+@delimeterlength_value, len(@remainingstring_value)-@foundat_val+@delimeterlength_value)        
            --        
            END        
            ELSE        
            BEGIN        
            --        
              SET @currstring_value       = @remainingstring_value    
              SET @remainingstring_value  = ''        
            --        
            END        
            --    
            IF ISNULL(@currstring_value,'') <> ''    
            BEGIN--curr_val_del    
            --    
              print  ''    
            --    
            END--curr_val_del    
          --    
          END--while_rem_val_del     
        --    
        END--del*/    
      --    
      END--not_a_r    
      ELSE    
      BEGIN--a_r    
      --    
        IF @pa_action = 'APP'    
        BEGIN--app    
        --    
    
              
          SELECT @l_entp_deleted_ind       = entp_deleted_ind    
                ,@l_entp_id                = entp_id    
                ,@l_entp_ent_id            = entp_ent_id     
                ,@l_entp_entpm_prop_id     = entp_entpm_prop_id    
                ,@l_entp_entpm_cd          = entp_entpm_cd    
                ,@l_entp_value             = entp_value    
          FROM   #entp_mak    
          WHERE  entpmak_id                = CONVERT(numeric, @currstring_id)    
              
    
              
          --    
          IF @l_entp_deleted_ind = 4    
          BEGIN--#4    
          --    
            IF ISNULL(@l_entp_id ,0) <> 0    
            BEGIN--<>=0    
            --    
              --BEGIN TRANSACTION    
                     --Entity Properties--    
              UPDATE entity_properties_mak   WITH (ROWLOCK)    
              SET    entp_deleted_ind      = 5    
                   , entp_lst_upd_by       = @pa_login_name    
                   , entp_lst_upd_dt       = GETDATE()    
              WHERE  entp_deleted_ind      = 4    
              AND    entpmak_id            = CONVERT(numeric, @currstring_id)    
              --    
              SET @l_error = @@ERROR    
              --    
              IF @l_error > 0    
              BEGIN    
              --    
                --SET @pa_msg = CONVERT(VARCHAR(10), @l_error)    
                --    
                --ROLLBACK TRANSACTION    
                SET @t_errorstr = CONVERT(varchar(10), @l_error)    
              --    
              END    
              -- 
              UPDATE entity_property_dtls    WITH (ROWLOCK)    
              SET   entpd_deleted_ind     = 0    
                   , entpd_lst_upd_by      = @pa_login_name    
                   , entpd_lst_upd_dt      = GETDATE()    
              WHERE  entpd_entp_id         = @l_entp_id    
              AND    entpd_deleted_ind     = 1    
 

    
              UPDATE entity_properties       WITH (ROWLOCK)    
              SET    entp_deleted_ind      = 0    
                   , entp_lst_upd_by       = @pa_login_name    
                   , entp_lst_upd_dt       = GETDATE()    
              WHERE  entp_deleted_ind      = 1    
              AND    entp_entpm_prop_id    = @l_entp_entpm_prop_id    
              AND    entp_ent_id           = @l_entp_ent_id    
              --    
              SET @l_error = @@ERROR    
              --    
              IF @l_error > 0    
              BEGIN    
              --    
                --SET @pa_msg = CONVERT(VARCHAR(10), @l_error)    
                --    
                --ROLLBACK TRANSACTION    
                SET @t_errorstr = CONVERT(varchar(10), @l_error)    
              --    
              END    
              --    
                     --Entity Property Details--    
            
              --    
              SET @l_error = @@ERROR    
              --    
              IF @l_error > 0    
              BEGIN    
              --    
                --SET @pa_msg = CONVERT(VARCHAR(10), @l_error)    
                SET @t_errorstr = CONVERT(varchar(10), @l_error)    
                --    
                --ROLLBACK TRANSACTION    
              --    
              END    
              --    
              UPDATE entity_property_dtls    WITH (ROWLOCK)    
              SET    entpd_deleted_ind     = 5    
                   , entpd_lst_upd_by      = @pa_login_name    
                   , entpd_lst_upd_dt      = GETDATE()    
              WHERE  entpd_deleted_ind     = 4    
              AND    entpd_entp_id         = @l_entp_id    
              --    
              SET @l_error = @@ERROR    
              --    
              IF @l_error > 0    
              BEGIN    
              --    
                --SET @pa_msg = CONVERT(VARCHAR(10), @l_error)    
                SET @t_errorstr = CONVERT(varchar(10), @l_error)    
                --    
                --ROLLBACK TRANSACTION    
              --    
              END    
            --    
            END--<>=0    
          --    
          END--#4    
          --    
          IF @l_entp_deleted_ind = 0    
          BEGIN--#0    
          --    
            --BEGIN TRANSACTION    
            --    
            UPDATE entity_properties_mak   WITH (ROWLOCK)       
            SET    entp_deleted_ind      = 1    
                 , entp_lst_upd_by       = @pa_login_name    
                 , entp_lst_upd_dt       = GETDATE()    
            WHERE  entp_deleted_ind      = 0    
            AND    entpmak_id            = CONVERT(NUMERIC, @currstring_id)    
            --    
            SET @l_error = @@ERROR    
            --    
            IF @l_error > 0    
            BEGIN    
            --    
              --SET @pa_msg = CONVERT(VARCHAR(10), @l_error)    
              --    
              SET @t_errorstr = CONVERT(varchar(10), @l_error)    
              --ROLLBACK TRANSACTION    
            --    
            END    
            --    
            /*SELECT @l_entp_id  = ISNULL(MAX(entp_id),0) + 1        
            FROM   entity_properties WITH(NOLOCK)*/    
    
            INSERT INTO entity_properties    
            ( entp_id    
            , entp_ent_id    
            , entp_acct_no    
            , entp_entpm_prop_id    
            , entp_entpm_cd    
            , entp_value    
            , entp_created_by    
            , entp_created_dt    
            , entp_lst_upd_by    
            , entp_lst_upd_dt    
            , entp_deleted_ind    
            )    
            SELECT entp_id        --changed by tushar jmm    
                 , entp_ent_id    
                 , entp_acct_no    
                 , entp_entpm_prop_id    
                 , entp_entpm_cd    
                 , entp_value    
                 , entp_created_by    
                 , entp_created_dt    
                 , @pa_login_name    
                 , GETDATE()    
                 , CASE WHEN entp_entpm_cd =  'LC' THEN 0     
                          WHEN RIGHT(entp_entpm_cd,7) =  'CUR_VAL' THEN 0  ELSE 1 end    
            FROM   #entp_mak    
            WHERE  entpmak_id  = CONVERT(NUMERIC, @currstring_id)    
            --    
            SET @l_error = @@ERROR    
            --    
            IF @l_error > 0    
            BEGIN    
            --    
              SET @t_errorstr = CONVERT(varchar(10), @l_error)    
              --    
              --ROLLBACK TRANSACTION    
            --    
            END    
            --move to pr_app_client    
            --EXEC pr_ins_upd_list @l_entp_ent_id,'A','ENTITY PROPERTIES',@pa_login_name,'*|~*','|*~|',''     
            --    
             
            SET @@c_entpd =  CURSOR FAST_FORWARD FOR        
            SELECT entpd_id    
                 , entpd_entp_id    
                 , entpd_entdm_id    
                 , entpd_entdm_cd    
                 , entpd_value    
                 , entpd_created_by    
                 , entpd_created_dt    
                 , entpd_deleted_ind     
            FROM   #entp_dtls_mak    
            WHERE entpd_entp_id = @l_entp_id       --CHANGED BY TUSHAR JMM    
            --    
            OPEN @@c_entpd        
            --    
            FETCH NEXT FROM @@c_entpd INTO @l_entpd_id, @l_entpd_entp_id, @l_entpd_entdm_id, @l_entpd_entdm_cd, @l_entpd_value, @l_entpd_created_by, @l_entpd_created_dt,@l_entpd_deleted_ind        
            --    
            WHILE @@fetch_status = 0        
            BEGIN--cur        
            --    
              IF @l_entpd_deleted_ind = 0 --@l_entp_id = @l_entpd_entp_id     
              BEGIN    
              --    
                UPDATE entity_property_dtls_mak   WITH (ROWLOCK)      
                SET    entpd_deleted_ind        = 1    
                     , entpd_lst_upd_by         = @pa_login_name    
                     , entpd_lst_upd_dt         = GETDATE()    
                WHERE  entpd_deleted_ind        = 0    
                AND    entpd_id                 = @l_entpd_id    
                --    
                SET @l_error = @@ERROR    
                --    
                IF @l_error > 0    
                BEGIN    
                --    
                  --SET @pa_msg = CONVERT(VARCHAR(10), @l_error)    
                    SET @t_errorstr = CONVERT(varchar(10), @l_error)    
                  --    
                  --ROLLBACK TRANSACTION    
                --    
                END    
                --    
                INSERT INTO entity_property_dtls    
                ( entpd_entp_id    
                , entpd_entdm_id    
                , entpd_entdm_cd    
                , entpd_value    
                , entpd_created_by    
                , entpd_created_dt   
                , entpd_lst_upd_by    
                , entpd_lst_upd_dt    
                , entpd_deleted_ind    
                )    
                VALUES    
                ( @l_entpd_entp_id    
                , @l_entpd_entdm_id    
                , @l_entpd_entdm_cd    
                , @l_entpd_value    
                , @l_entpd_created_by    
                , @l_entpd_created_dt    
                , @pa_login_name    
                , GETDATE()    
                , 1    
                )    
                --    
                SET @l_error = @@ERROR    
                --    
                IF @l_error > 0    
                BEGIN    
                --    
                  SET @t_errorstr = CONVERT(varchar(10), @l_error)    
                  --    
                  --ROLLBACK TRANSACTION    
                --    
                END    
                --    
                /*DELETE     
                FROM   #entp_dtls_mak    
                WHERE  entpd_entp_id = @l_entp_id*/    
                DELETE     
                FROM   #entp_dtls_mak    
                WHERE  entpd_id = @l_entpd_id    
                   
                    
              --    
              END    
              IF  @l_entpd_deleted_ind = 4     
              BEGIN    
              --    
                UPDATE entity_property_dtls_mak   WITH (ROWLOCK)      
                SET    entpd_deleted_ind        = 5    
                     , entpd_lst_upd_by         = @pa_login_name    
                     , entpd_lst_upd_dt         = GETDATE()    
                WHERE  entpd_deleted_ind        = 4    
                AND    entpd_id                 = @l_entpd_id    
                --    
                SET @l_error = @@ERROR    
                --    
                IF @l_error > 0    
                BEGIN    
                --    
                  --SET @pa_msg = CONVERT(VARCHAR(10), @l_error)    
                    SET @t_errorstr = CONVERT(varchar(10), @l_error)    
                  --    
                  --ROLLBACK TRANSACTION    
                --    
                END    
                --    
                  UPDATE entity_property_dtls    
                  SET    entpd_deleted_ind = 0    
                  WHERE  entpd_entp_id     = @l_entpd_entp_id    
                  AND    entpd_deleted_ind = 1    
                  AND    entpd_entdm_id    = @l_entpd_entdm_id                      
                      
                --    
                SET @l_error = @@ERROR    
                --    
                IF @l_error > 0    
                BEGIN    
                --    
                  SET @t_errorstr = CONVERT(varchar(10), @l_error)    
                  --    
                  --ROLLBACK TRANSACTION    
                --    
                END    
              --    
              END    
              IF  @l_entpd_deleted_ind = 8     
              BEGIN    
              --             
                UPDATE entity_property_dtls_mak   WITH (ROWLOCK)      
                SET    entpd_deleted_ind        = 9    
                     , entpd_lst_upd_by         = @pa_login_name    
                     , entpd_lst_upd_dt         = GETDATE()    
                WHERE  entpd_deleted_ind        = 8    
                AND    entpd_id                 = @l_entpd_id    
                --    
                SET @l_error = @@ERROR    
                --    
                IF @l_error > 0    
                BEGIN    
                --    
                  --SET @pa_msg = CONVERT(VARCHAR(10), @l_error)    
                    SET @t_errorstr = CONVERT(varchar(10), @l_error)    
                  --    
                  --ROLLBACK TRANSACTION    
                --    
                END    
                --    
    
                  UPDATE entity_property_dtls    
                  SET    entpd_value       = @l_entpd_value    
                        ,entpd_lst_upd_by  = @pa_login_name    
                        ,entpd_lst_upd_dt  = GETDATE()    
                  WHERE  entpd_entp_id     = @l_entpd_entp_id    
                  AND    entpd_deleted_ind = 1    
                  AND    entpd_entdm_id    = @l_entpd_entdm_id                      
                      
                --    
                SET @l_error = @@ERROR    
                --    
                IF @l_error > 0    
                BEGIN    
                --    
                  SET @t_errorstr = CONVERT(varchar(10), @l_error)    
                  --    
                  --ROLLBACK TRANSACTION    
                --    
                END    
    
              --    
              END      
    
                  
     
              FETCH NEXT FROM @@c_entpd INTO @l_entpd_id, @l_entpd_entp_id, @l_entpd_entdm_id, @l_entpd_entdm_cd, @l_entpd_value, @l_entpd_created_by, @l_entpd_created_dt ,@l_entpd_deleted_ind           
            --    
            END--cur    
            --    
            CLOSE @@c_entpd        
            DEALLOCATE @@c_entpd    
          --       
          END--0    
          IF @l_entp_deleted_ind = 8    
          BEGIN--#0    
          --    
            --BEGIN TRANSACTION    
            --    
            UPDATE entity_properties_mak   WITH (ROWLOCK)       
            SET    entp_deleted_ind      = 9    
                 , entp_lst_upd_by       = @pa_login_name    
                 , entp_lst_upd_dt       = GETDATE()    
            WHERE  entp_deleted_ind      = 8    
            AND    entpmak_id            = CONVERT(NUMERIC, @currstring_id)    
            --    
            SET @l_error = @@ERROR    
            --    
            IF @l_error > 0    
            BEGIN    
            --    
              --SET @pa_msg = CONVERT(VARCHAR(10), @l_error)    
              --    
              SET @t_errorstr = CONVERT(varchar(10), @l_error)    
              --ROLLBACK TRANSACTION    
            --    
            END    
            --    
            /*SELECT @l_entp_id  = ISNULL(MAX(entp_id),0) + 1        
            FROM   entity_properties WITH(NOLOCK)*/    
    
            UPDATE ENTP    
            SET    ENTP.entp_value = ENTPMAK.entp_value     
                 , ENTP.ENTP_LST_UPD_BY = @pa_login_name    
                 , ENTP.ENTP_LST_UPD_DT = GETDATE()    
            FROM   #entp_mak ENTPMAK    
                 , ENTITY_PROPERTIES ENTP    
            WHERE  ENTPMAK.entpmak_id  = CONVERT(NUMERIC, @currstring_id)    
            AND    ENTPMAK.ENTP_ENT_ID = ENTP.ENTP_ENT_ID    
            AND    ENTPMAK.ENTP_ENTPM_PROP_ID = ENTP.ENTP_ENTPM_PROP_ID    
            AND    ENTPMAK.ENTP_ENT_ID = @PA_ENT_ID    
     
            --    
            SET @l_error = @@ERROR    
            --    
            IF @l_error > 0    
            BEGIN    
            --    
              SET @t_errorstr = CONVERT(varchar(10), @l_error)    
              --    
              --ROLLBACK TRANSACTION    
            --    
            END    
            --move to pr_app_client    
            --EXEC pr_ins_upd_list @l_entp_ent_id,'A','ENTITY PROPERTIES',@pa_login_name,'*|~*','|*~|',''     
            --    
                
            SET @@c_entpd =  CURSOR FAST_FORWARD FOR        
            SELECT entpd_id    
                 , entpd_entp_id    
                 , entpd_entdm_id    
                 , entpd_entdm_cd    
                 , entpd_value    
                 , entpd_created_by    
                 , entpd_created_dt    
                 , entpd_deleted_ind     
            FROM   #entp_dtls_mak    
            WHERE entpd_entp_id = @l_entp_id       --CHANGED BY TUSHAR JMM    
            --    
            OPEN @@c_entpd        
            --    
            FETCH NEXT FROM @@c_entpd INTO @l_entpd_id, @l_entpd_entp_id, @l_entpd_entdm_id, @l_entpd_entdm_cd, @l_entpd_value, @l_entpd_created_by, @l_entpd_created_dt,@l_entpd_deleted_ind        
            --    
            WHILE @@fetch_status = 0        
            BEGIN--cur        
            --    
              IF @l_entpd_deleted_ind = 0 --@l_entp_id = @l_entpd_entp_id     
              BEGIN                  --    
                UPDATE entity_property_dtls_mak   WITH (ROWLOCK)      
                SET    entpd_deleted_ind        = 1    
                     , entpd_lst_upd_by         = @pa_login_name    
                     , entpd_lst_upd_dt         = GETDATE()    
                WHERE  entpd_deleted_ind        = 0    
                AND    entpd_id                 = @l_entpd_id    
                --    
                SET @l_error = @@ERROR    
                --    
                IF @l_error > 0    
                BEGIN    
                --    
                  --SET @pa_msg = CONVERT(VARCHAR(10), @l_error)    
                    SET @t_errorstr = CONVERT(varchar(10), @l_error)    
                  --    
                  --ROLLBACK TRANSACTION    
                --    
                END    
                --    
                INSERT INTO entity_property_dtls    
                ( entpd_entp_id    
                , entpd_entdm_id    
                , entpd_entdm_cd    
                , entpd_value    
                , entpd_created_by    
                , entpd_created_dt    
                , entpd_lst_upd_by    
                , entpd_lst_upd_dt    
                , entpd_deleted_ind    
                )    
                VALUES    
                ( @l_entpd_entp_id    
                , @l_entpd_entdm_id    
                , @l_entpd_entdm_cd    
                , @l_entpd_value    
                , @l_entpd_created_by    
                , @l_entpd_created_dt    
                , @pa_login_name    
                , GETDATE()    
                , 1    
                )    
                --    
                SET @l_error = @@ERROR    
                --    
                IF @l_error > 0    
                BEGIN    
                --    
                  SET @t_errorstr = CONVERT(varchar(10), @l_error)    
                  --    
                  --ROLLBACK TRANSACTION    
                --    
                END    
                --    
                /*DELETE     
                FROM   #entp_dtls_mak    
                WHERE  entpd_entp_id = @l_entp_id*/    
                DELETE     
                FROM   #entp_dtls_mak    
                WHERE  entpd_id = @l_entpd_id    
                   
                    
              --    
              END    
              IF  @l_entpd_deleted_ind = 4     
              BEGIN    
              --    
                UPDATE entity_property_dtls_mak   WITH (ROWLOCK)      
                SET    entpd_deleted_ind        = 5    
                     , entpd_lst_upd_by         = @pa_login_name    
                     , entpd_lst_upd_dt         = GETDATE()    
                WHERE  entpd_deleted_ind        = 4    
                AND    entpd_id       = @l_entpd_id    
                --    
                SET @l_error = @@ERROR    
                --    
                IF @l_error > 0    
                BEGIN    
                --    
                  --SET @pa_msg = CONVERT(VARCHAR(10), @l_error)    
                    SET @t_errorstr = CONVERT(varchar(10), @l_error)    
                  --    
                  --ROLLBACK TRANSACTION    
                --    
                END    
                --    
                  UPDATE entity_property_dtls    
                  SET    entpd_deleted_ind = 0    
                  WHERE  entpd_entp_id     = @l_entpd_entp_id    
                  AND    entpd_deleted_ind = 1    
                  AND    entpd_entdm_id    = @l_entpd_entdm_id                      
                      
                --    
                SET @l_error = @@ERROR    
                --    
                IF @l_error > 0    
                BEGIN    
                --    
                  SET @t_errorstr = CONVERT(varchar(10), @l_error)    
                  --    
                  --ROLLBACK TRANSACTION    
                --    
                END    
              --    
              END    
              IF  @l_entpd_deleted_ind = 8     
              BEGIN    
     --             
                UPDATE entity_property_dtls_mak   WITH (ROWLOCK)      
                SET    entpd_deleted_ind        = 9    
                     , entpd_lst_upd_by         = @pa_login_name    
                     , entpd_lst_upd_dt         = GETDATE()    
                WHERE  entpd_deleted_ind        = 8    
                AND    entpd_id                 = @l_entpd_id    
                --    
                SET @l_error = @@ERROR    
                --    
                IF @l_error > 0    
                BEGIN    
                --    
                  --SET @pa_msg = CONVERT(VARCHAR(10), @l_error)    
                    SET @t_errorstr = CONVERT(varchar(10), @l_error)    
                  --    
                  --ROLLBACK TRANSACTION    
                --    
                END    
                --    
    
                  UPDATE entity_property_dtls    
                  SET    entpd_value       = @l_entpd_value    
                        ,entpd_lst_upd_by  = @pa_login_name    
                        ,entpd_lst_upd_dt  = GETDATE()    
                  WHERE  entpd_entp_id     = @l_entpd_entp_id    
                  AND    entpd_deleted_ind = 1    
                  AND    entpd_entdm_id    = @l_entpd_entdm_id                      
                      
                --    
                SET @l_error = @@ERROR    
                --    
                IF @l_error > 0    
                BEGIN    
                --    
                  SET @t_errorstr = CONVERT(varchar(10), @l_error)    
                  --    
                  --ROLLBACK TRANSACTION    
                --    
                END    
    
              --    
              END      
    
                  
     
              FETCH NEXT FROM @@c_entpd INTO @l_entpd_id, @l_entpd_entp_id, @l_entpd_entdm_id, @l_entpd_entdm_cd, @l_entpd_value, @l_entpd_created_by, @l_entpd_created_dt ,@l_entpd_deleted_ind           
            --    
            END--cur    
            --    
            CLOSE @@c_entpd        
            DEALLOCATE @@c_entpd    
          --       
          END--0     
          IF @l_entp_deleted_ind = 1    
          BEGIN--#0    
          --    
            --BEGIN TRANSACTION    
            --    
            SET @@c_entpd =  CURSOR FAST_FORWARD FOR        
            SELECT entpd_id    
                 , entpd_entp_id    
                 , entpd_entdm_id    
                 , entpd_entdm_cd    
                 , entpd_value    
                 , entpd_created_by    
                 , entpd_created_dt    
                 , entpd_deleted_ind     
            FROM   #entp_dtls_mak    
            WHERE entpd_entp_id = @l_entp_id       --CHANGED BY TUSHAR JMM    
            --    
            OPEN @@c_entpd        
            --    
            FETCH NEXT FROM @@c_entpd INTO @l_entpd_id, @l_entpd_entp_id, @l_entpd_entdm_id, @l_entpd_entdm_cd, @l_entpd_value, @l_entpd_created_by, @l_entpd_created_dt,@l_entpd_deleted_ind        
            --    
            WHILE @@fetch_status = 0        
            BEGIN--cur        
            --    
              IF @l_entpd_deleted_ind = 0 --@l_entp_id = @l_entpd_entp_id     
              BEGIN    
              --    
                UPDATE entity_property_dtls_mak   WITH (ROWLOCK)      
                SET    entpd_deleted_ind        = 1    
                     , entpd_lst_upd_by         = @pa_login_name    
                     , entpd_lst_upd_dt         = GETDATE()    
                WHERE  entpd_deleted_ind        = 0    
                AND    entpd_id                 = @l_entpd_id    
                --    
                SET @l_error = @@ERROR    
                --    
                IF @l_error > 0    
                BEGIN    
                --    
                  --SET @pa_msg = CONVERT(VARCHAR(10), @l_error)    
                    SET @t_errorstr = CONVERT(varchar(10), @l_error)    
                  --    
                  --ROLLBACK TRANSACTION    
                --    
                END    
        --    
                INSERT INTO entity_property_dtls    
                ( entpd_entp_id    
                , entpd_entdm_id    
                , entpd_entdm_cd    
                , entpd_value    
                , entpd_created_by    
                , entpd_created_dt    
                , entpd_lst_upd_by    
                , entpd_lst_upd_dt    
                , entpd_deleted_ind    
                )    
                VALUES    
                ( @l_entpd_entp_id    
                , @l_entpd_entdm_id    
                , @l_entpd_entdm_cd    
                , @l_entpd_value    
                , @l_entpd_created_by    
                , @l_entpd_created_dt    
                , @pa_login_name    
                , GETDATE()    
                , 1    
                )    
                --    
                SET @l_error = @@ERROR    
                --    
                IF @l_error > 0    
                BEGIN    
                --    
                  SET @t_errorstr = CONVERT(varchar(10), @l_error)    
                  --    
                  --ROLLBACK TRANSACTION    
                --    
                END    
                --    
                /*DELETE     
                FROM   #entp_dtls_mak    
                WHERE  entpd_entp_id = @l_entp_id*/    
                DELETE     
                FROM   #entp_dtls_mak    
                WHERE  entpd_id = @l_entpd_id    
                   
                    
              --    
              END    
              IF  @l_entpd_deleted_ind = 4     
              BEGIN    
              --    
                UPDATE entity_property_dtls_mak   WITH (ROWLOCK)      
                SET    entpd_deleted_ind        = 5    
                     , entpd_lst_upd_by         = @pa_login_name    
                     , entpd_lst_upd_dt         = GETDATE()    
                WHERE  entpd_deleted_ind        = 4    
                AND    entpd_id       = @l_entpd_id    
                --    
                SET @l_error = @@ERROR    
                --    
                IF @l_error > 0    
                BEGIN    
                --    
                  --SET @pa_msg = CONVERT(VARCHAR(10), @l_error)    
                    SET @t_errorstr = CONVERT(varchar(10), @l_error)    
                  --    
                  --ROLLBACK TRANSACTION    
                --    
                END    
                --    
                  UPDATE entity_property_dtls    
                  SET    entpd_deleted_ind = 0    
                  WHERE  entpd_entp_id     = @l_entpd_entp_id    
                  AND    entpd_deleted_ind = 1    
                  AND    entpd_entdm_id    = @l_entpd_entdm_id                      
                      
                --    
                SET @l_error = @@ERROR    
                --    
                IF @l_error > 0    
                BEGIN    
                --    
                  SET @t_errorstr = CONVERT(varchar(10), @l_error)    
                  --    
                  --ROLLBACK TRANSACTION    
                --    
                END    
              --    
              END    
              IF  @l_entpd_deleted_ind = 8     
              BEGIN    
              --             
                UPDATE entity_property_dtls_mak   WITH (ROWLOCK)      
                SET    entpd_deleted_ind        = 9    
                     , entpd_lst_upd_by         = @pa_login_name    
                     , entpd_lst_upd_dt         = GETDATE()    
                WHERE  entpd_deleted_ind        = 8    
                AND    entpd_id                 = @l_entpd_id    
                --    
                SET @l_error = @@ERROR    
                --    
                IF @l_error > 0    
                BEGIN    
                --    
                  --SET @pa_msg = CONVERT(VARCHAR(10), @l_error)    
                    SET @t_errorstr = CONVERT(varchar(10), @l_error)    
                  --    
                  --ROLLBACK TRANSACTION    
                --    
                END    
       --    
    
                  UPDATE entity_property_dtls    
                  SET    entpd_value       = @l_entpd_value    
                        ,entpd_lst_upd_by  = @pa_login_name    
                        ,entpd_lst_upd_dt  = GETDATE()    
                  WHERE  entpd_entp_id     = @l_entpd_entp_id    
                  AND    entpd_deleted_ind = 1    
                  AND    entpd_entdm_id    = @l_entpd_entdm_id                      
                      
                --    
                SET @l_error = @@ERROR    
                --    
                IF @l_error > 0    
                BEGIN    
                --    
                  SET @t_errorstr = CONVERT(varchar(10), @l_error)    
                  --    
                  --ROLLBACK TRANSACTION    
                --    
                END    
    
              --    
              END      
    
                  
     
              FETCH NEXT FROM @@c_entpd INTO @l_entpd_id, @l_entpd_entp_id, @l_entpd_entdm_id, @l_entpd_entdm_cd, @l_entpd_value, @l_entpd_created_by, @l_entpd_created_dt ,@l_entpd_deleted_ind           
            --    
            END--cur    
            --    
            CLOSE @@c_entpd        
            DEALLOCATE @@c_entpd    
          --       
          END--0     
          --    
          --EXEC pr_ins_upd_list  @l_crn_no, 'A','CLIENT PROPERTY MSTR', @pa_login_name, '*|~*', '|*~|', ''      
        --    
        END--app    
      --    
      END--a_r    
    --    
    END  --curr_id        
  --      
  END--ID    
  --    
  SET @pa_msg = @t_errorstr     
--   

--EXEC pr_auto_blgl @pa_ent_id, 'ENTITY' 
--EXEC pr_auto_blgl @pa_ent_id, 'PROP' 

 
END--#001

GO
