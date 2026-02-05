-- Object: PROCEDURE citrus_usr.pr_ins_upd_scr
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--select * from screens where scr_id = 302
--select * from actions where act_scr_id = 302
--select * from roles_actions,actions where rola_act_id = act_id and act_scr_id = 302
--begin tran
--pr_ins_upd_scr '302','EDT','HO','LIAR','LIAR','74','BLANK.ASPX','B','0','READ|*~|WRITE|*~|EXPORT|*~|PRINT|*~|','1|*~|3 |*~|4 |*~|*|~*2|*~|3 |*~|4 |*~|*|~*3|*~|3 |*~|4 |*~|*|~*',	74,	0,'*|~*','|*~|',''
--rollback
CREATE  PROCEDURE [citrus_usr].[pr_ins_upd_scr](@pa_id          VARCHAR(8000)            
                               ,@pa_action      VARCHAR(20)            
                               ,@pa_login_name  VARCHAR(20)            
                               ,@pa_scr_cd      VARCHAR(20)   = ''            
                               ,@pa_scr_name    VARCHAR(100)  = ''            
                               ,@pa_parent_id   VARCHAR(100)            
                               ,@pa_scr_url     VARCHAR(1000)            
                               ,@pa_scr_dp_yn       char(1) 
                               ,@pa_chkyn       NUMERIC            
                               ,@pa_scr_actions VARCHAR(1000)            
                               ,@pa_rol_map     VARCHAR(1000)            
                               ,@pa_ord         NUMERIC            
                               ,@pa_chk_yn      INT            
                               ,@rowdelimiter   CHAR(4)       = '*|~*'            
                               ,@coldelimiter   CHAR(4)       = '|*~|'            
                               ,@pa_errmsg      VARCHAR(8000) OUTPUT            
                               )            
AS            
/*********************************************************************************            
 SYSTEM         : CITRUS            
 MODULE NAME    : pr_ins_upd_scr            
 DESCRIPTION    : THIS PROCEDURE WILL CREATE NEW SCREENS            
 COPYRIGHT(C)   : MARKETPLACE TECHNOLOGIES PVT. LTD.            
 VERSION HISTORY: 1.0            
 VERS.  AUTHOR            DATE          REASON            
 -----  -------------     ------------  --------------------------------------------------            
 1.0    TUSHAR            29-june-2007  VERSION.            
-----------------------------------------------------------------------------------*/            
--            
BEGIN            
--              
  DECLARE @l_scr_id        NUMERIC            
         ,@l_ord_by        NUMERIC             
         ,@l_counter       NUMERIC            
         ,@l               NUMERIC            
         ,@l_act_id        NUMERIC            
         ,@l_act_desc      VARCHAR(50)            
         ,@l_error         NUMERIC            
         ,@l_act           VARCHAR(25)            
         ,@l_counter_rol   NUMERIC             
         ,@l_roles         NUMERIC            
         ,@l_rol           NUMERIC    
         ,@l_scr_desc      VARCHAR(50)   
         ,@l_roles_string  varchar(8000)
  DECLARE @l_actions_tab   TABLE(act_id NUMERIC, act_scr_id NUMERIC)            
  DECLARE @l_roles_actions TABLE(rola_rol_id NUMERIC, rola_act_id NUMERIC)            
                     
  SET    @l       = 1             
  SET    @l_roles = 1             
              
  INSERT INTO @l_actions_tab            
  SELECT act_id             
       , act_scr_id             
  FROM   actions            
  WHERE  act_scr_id      = convert(NUMERIC,@pa_id)            
  AND    act_deleted_ind = 1            
              
              
  INSERT INTO @l_roles_actions            
  SELECT rola_rol_id            
        ,act_id            
  FROM   roles_actions            
        ,@l_actions_tab            
  WHERE  act_id           = rola_act_id            
  AND    act_scr_id       = convert(NUMERIC,@pa_id)            
  AND    rola_deleted_ind = 1            
              
  --****changed by tushar 03.10.07    
  IF @pa_chkyn = 2    
  begin    
  --    
    set @l_scr_desc = @pa_scr_name + ' (Maker)'    
  --      
  end    
  else if @pa_chkyn = 1    
  begin    
  --    
    set @l_scr_desc = @pa_scr_name + ' (Checker)'    
  --    
  end    
  else    
  begin    
  --    
    set @l_scr_desc = @pa_scr_name     
  --    
  end     
    
                
              
  --****changed by tushar 03.10.07    
  IF @pa_action = 'INS'            
  BEGIN            
  --            
    SELECT @l_scr_id        = ISNULL(MAX(scr_id),0)+1 FROM screens       
    SELECT @l_ord_by        = scr_ord_by + 1  FROM screens WHERE scr_id = @pa_ord        
                
    BEGIN TRANSACTION            
            
    INSERT INTO screens(scr_id            
                       ,scr_cd            
                       ,scr_name            
                       ,scr_desc            
                       ,scr_parent_id            
                       ,scr_url
                       ,scr_dp            
                       ,scr_checker_yn            
                       ,scr_ord_by            
                       ,scr_created_by            
                       ,scr_created_dt            
                       ,scr_lst_upd_by            
                       ,scr_lst_upd_dt            
                       ,scr_deleted_ind            
                       )            
                 VALUES(@l_scr_id            
                       ,@pa_scr_cd            
                       ,citrus_usr.initcap(@pa_scr_name)            
                       ,citrus_usr.initcap(@l_scr_desc)            
                       ,case when @pa_parent_id = 'NULL' then null else  @pa_parent_id end            
                       ,@pa_scr_url 
                       ,case when @pa_scr_dp_yn  = 'C' then 2
                             when @pa_scr_dp_yn  = 'N' then 1
                             else 0 end 
                       ,@pa_chkyn            
                       ,@l_ord_by            
                       ,@pa_login_name            
                       ,getdate()            
                       ,@pa_login_name            
                       ,getdate()            
                       ,1            
                       )            
            
                                       
                                   
    IF @pa_scr_actions <> ''            
    BEGIN            
    --            
      SELECT @l_counter = citrus_usr.ufn_countstring(@pa_scr_actions,'|*~|')            
                  
                
      WHILE @l < @l_counter + 1            
      BEGIN            
      --            
        IF citrus_usr.fn_splitval(@pa_scr_actions,@l) <> ''            
        BEGIN            
        --            
          SET @l_act = citrus_usr.fn_splitval(@pa_scr_actions,@l)            
                      
          SELECT @l_act_desc =            
          CASE   WHEN @l_act = 'READ'            
                 THEN 'This action allows the user to read'            
                 WHEN @l_act = 'WRITE'            
                 THEN 'This action allows the user to write'            
                 WHEN @l_act = 'PRINT'            
                 THEN 'This action allows the user to print'            
                 WHEN @l_act = 'EXPORT'            
                 THEN 'This action allows the user to export' END            
                             
                     
                             
            SELECT @l_act_id        = ISNULL(MAX(act_id),0)+1 FROM actions WHERE act_deleted_ind = 1                    
            
            INSERT INTO ACTIONS(act_id            
                               ,act_cd            
                               ,act_scr_id            
                               ,act_desc            
                               ,act_created_by            
                               ,act_created_dt            
                               ,act_lst_upd_by            
                               ,act_lst_upd_dt            
                               ,act_deleted_ind            
                               )            
                         VALUES(@l_act_id            
                               ,citrus_usr.fn_splitval(@pa_scr_actions,@l)            
                               ,@l_scr_id            
                               ,@l_act_desc            
                               ,@pa_login_name            
                               ,getdate()            
                               ,@pa_login_name            
                               ,getdate()            
                               ,1            
                               )            
                                           
                                      
          SELECT @l_counter_rol = citrus_usr.ufn_countstring(@pa_rol_map,'*|~*')            
                      
          SET @l_roles = 1            
                      
          WHILE @l_roles < @l_counter_rol + 1            
          BEGIN            
          --            
          
           
                 
            IF citrus_usr.fn_splitval_row(@pa_rol_map,@l_roles ) <> ''            
            BEGIN         
            --
            
            
             
             
              SET @l_roles_string = citrus_usr.FN_SPLITVAL_ROW(@pa_rol_map,@l_roles)
                 
              SET @l_rol = CONVERT(NUMERIC,citrus_usr.fn_splitval(@l_roles_string,1))        
                 
              INSERT INTO ROLES_ACTIONS(rola_rol_id            
                                      ,rola_act_id            
                                      ,rola_access1            
                                      ,rola_created_by            
                                      ,rola_created_dt            
                                      ,rola_lst_upd_by            
                                      ,rola_lst_upd_dt            
                                      ,rola_deleted_ind             
                                      )            
                   VALUES(@l_rol            
                                      ,@l_act_id            
                                      ,CITRUS_USR.fn_get_rola_access(@l_roles_string)
                                      ,'CITRUS_USR'            
                                      ,GETDATE()            
                                      ,'CITRUS_USR'            
                                      ,GETDATE()            
                                      ,1            
                                      )            
                          
              set @l_roles = @l_roles + 1            
            --            
            END            
  --            
          END            
            
            
        --            
        END            
        SET @l = @l + 1            
      --            
      END            
    --            
    END            
                
    SET @l_error =@@ERROR            
                
    IF @l_error <> 0            
    BEGIN            
    --            
      SET @pa_errmsg = @l_error+'|*~|*|~*'            
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
  IF @pa_action = 'EDT'            
  BEGIN            
  --            
    BEGIN TRANSACTION            
                
    SELECT @l_ord_by        = scr_ord_by + 1  FROM screens WHERE scr_id = @pa_ord AND scr_deleted_ind = 1            
            
             
            
    IF @pa_parent_id = 'NULL'            
    BEGIN            
    --            
      UPDATE screens            
      SET    scr_cd          = @pa_scr_cd            
            ,scr_name        = citrus_usr.initcap(@pa_scr_name)            
            ,scr_desc        = citrus_usr.initcap(@l_scr_desc)            
            ,scr_parent_id   = null            
            ,scr_url         = @pa_scr_url             
            ,scr_dp          = case when @pa_scr_dp_yn  = 'C' then 2
                               when @pa_scr_dp_yn  = 'N' then 1
                               else 0 end 
            ,scr_checker_yn  = @pa_chkyn             
            ,scr_ord_by      = @l_ord_by            
      WHERE  scr_id          = convert(numeric,@pa_id)            
      AND    scr_deleted_ind =1             
    --            
    END            
    ELSE            
    BEGIN            
    --            
      UPDATE screens            
      SET    scr_cd          = @pa_scr_cd            
            ,scr_name        = citrus_usr.initcap(@pa_scr_name)            
            ,scr_desc        = citrus_usr.initcap(@l_scr_desc)            
            ,scr_parent_id   = @pa_parent_id             
            ,scr_dp          = case when @pa_scr_dp_yn  = 'C' then 2
                               when @pa_scr_dp_yn  = 'N' then 1
                               else 0 end 
            ,scr_url         = @pa_scr_url             
            ,scr_checker_yn  = @pa_chkyn             
            ,scr_ord_by      = @l_ord_by            
      WHERE  scr_id          = convert(numeric,@pa_id)            
      AND    scr_deleted_ind =1             
    --            
    END            
                
                
    IF @pa_scr_actions <> ''            
    BEGIN            
    --            
                  
      /*            
      UPDATE actions            
      SET    act_deleted_ind = 0            
      WHERE  act_scr_id      = @pa_id            
      AND    act_deleted_ind = 1            
      */            
                
      SELECT @l_counter = citrus_usr.ufn_countstring(@pa_scr_actions,'|*~|')            
      SET    @l = 1             
            
      WHILE @l < @l_counter + 1            
      BEGIN            
      --            
                    
        IF citrus_usr.fn_splitval(@pa_scr_actions,@l) <> ''            
        BEGIN            
        --            
          SET @l_act = citrus_usr.fn_splitval(@pa_scr_actions,@l)            
                       
          SELECT @l_act_desc =            
          CASE   WHEN @l_act = 'READ'            
                 THEN 'This action allows the user to read'            
                 WHEN @l_act = 'WRITE'            
                 THEN 'This action allows the user to write'            
                 WHEN @l_act = 'PRINT'            
                 THEN 'This action allows the user to print'            
                 WHEN @l_act = 'EXPORT'            
                 THEN 'This action allows the user to export' END            
                       
                  
         
          IF NOT EXISTS(SELECT act_id FROM ACTIONS WHERE act_scr_id = convert(numeric,@pa_id) AND act_cd = @l_act AND act_deleted_ind = 1)              
          BEGIN            
          --            
             SELECT @l_act_id        = ISNULL(MAX(act_id),0)+1 FROM actions WHERE act_deleted_ind = 1         
         
             INSERT INTO ACTIONS(act_id            
                               ,act_cd            
                               ,act_scr_id            
                               ,act_desc            
                               ,act_created_by            
                               ,act_created_dt            
                               ,act_lst_upd_by            
                               ,act_lst_upd_dt            
                               ,act_deleted_ind            
                               )            
                         VALUES(@l_act_id            
                               ,citrus_usr.fn_splitval(@pa_scr_actions,@l)            
                               ,convert(numeric,@pa_id)            
                               ,@l_act_desc            
                               ,@pa_login_name            
                               ,getdate()            
                               ,@pa_login_name            
                               ,getdate()            
                               ,1            
                  )            
           --            
           END            
           ELSE            
           BEGIN            
           --         
             SELECt @l_act_id = act_id FROM ACTIONS WHERE act_scr_id = convert(numeric,@pa_id) AND act_cd = @l_act AND act_deleted_ind = 1        
           
             DELETE FROM @l_actions_tab             
             WHERE  act_id = (SELECT act_id FROM ACTIONS WHERE act_scr_id = convert(numeric,@pa_id) AND act_cd = @l_act AND act_deleted_ind = 1)             
           --            
           END                                
                                           
                                           
             SELECT @l_counter_rol = citrus_usr.ufn_countstring(@pa_rol_map,'*|~*')            
                      
             SET @l_roles = 1            
            
             WHILE @l_roles < @l_counter_rol + 1            
             BEGIN            
             --            
               IF citrus_usr.FN_SPLITVAL_ROW(@pa_rol_map,@l_roles) <> ''            
               BEGIN            
               --
                     
                 SET @l_roles_string = citrus_usr.FN_SPLITVAL_ROW(@pa_rol_map,@l_roles)
    
                 SET @l_rol = CONVERT(NUMERIC,citrus_usr.fn_splitval(@l_roles_string,1))    
                 PRINT @l_act_id        
                 PRINT @l_rol
                 PRINT @pa_id

    
                 if not exists(select rola_rol_id from roles_actions, actions where rola_act_id = act_id AND act_id = @l_act_id and rola_rol_id = @l_rol AND act_scr_id = convert(numeric,@pa_id))                                 
                 begin         
                 --    
                    
                   INSERT INTO ROLES_ACTIONS(rola_rol_id            
                                            ,rola_act_id            
                                            ,rola_access1            
                                            ,rola_created_by            
                                            ,rola_created_dt            
                                            ,rola_lst_upd_by            
                                            ,rola_lst_upd_dt            
                                            ,rola_deleted_ind             
                                            )            
                                     VALUES(@l_rol            
                                           ,@l_act_id            
                                           ,CITRUS_USR.fn_get_rola_access(@l_roles_string)           
                                           ,'CITRUS_USR'            
                                           ,GETDATE()            
                                           ,'CITRUS_USR'            
                                           ,GETDATE()            
                                           ,1            
                                           )            
                 --        
                 END        
                 ELSE        
                 begin        
                 --
                   UPDATE rola 
                   SET rola_access1  = CITRUS_USR.fn_get_rola_access(@l_roles_string)       
                   FROM roles_actions rola, actions
                   WHERE act_id = @l_act_id and rola_rol_id = @l_rol
                                  
                   DELETE FROM @l_roles_actions            
                   WHERE  rola_rol_id = @l_rol             
        
                 --        
                 end        
        
                 SET @l_roles = @l_roles + 1            
               --            
               END            
             --            
             END            
                    
        --            
        END            
                    
        SET @l = @l + 1            
      --            
      END            
                  
      --UPDATE roles_actions SET rola_deleted_ind = 0 WHERE rola_act_id IN (SELECT l_act.rola_act_id FROM @l_roles_actions l_act,actions act WHERE act.act_id = l_act.rola_act_id and act.act_scr_id = convert(numeric,@pa_id))        
      --select * from roles_actions WHERE rola_act_id IN (SELECT l_act.rola_act_id FROM @l_roles_actions l_act,actions act WHERE act.act_id = l_act.rola_act_id and act.act_scr_id = convert(numeric,@pa_id))        
                  
      UPDATE actions SET act_deleted_ind = 0 WHERE act_id IN (SELECT act_id FROM @l_actions_tab)            
            
      --SELECT * FROM @l_roles_actions            
      /*UPDATE roles_actions             
      SET    rola_deleted_ind = 0             
      FROM   roles_actions      rola            
            ,@l_roles_actions   temp_rola            
      WHERE  rola.rola_rol_id = temp_rola.rola_rol_id            
      and    rola.rola_act_id = temp_rola.rola_act_id            
      AND    rola.rola_rol_id = */            
            
                  
    --            
    END            
    SET @l_error =@@ERROR            
    IF @l_error <> 0            
    BEGIN            
    --            
      SET @pa_errmsg = @l_error+'|*~|*|~*'            
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
  IF @pa_action = 'DEL'            
  BEGIN            
  --            
    BEGIN TRANSACTION            
                
    UPDATE actions            
    SET    act_deleted_ind = 0             
    WHERE  act_scr_id      = @pa_id            
    AND    act_deleted_ind = 1            
                
    UPDATE screens            
    SET    scr_deleted_ind = 0             
    WHERE  scr_id          = @pa_id            
    AND    scr_deleted_ind = 1            
      
                
    SET @l_error =@@ERROR            
    IF @l_error <> 0            
    BEGIN            
    --            
      SET @pa_errmsg = @l_error+'|*~|*|~*'            
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

GO
