-- Object: PROCEDURE citrus_usr.pr_ins_roles_actions
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--exec pr_ins_roles_actions

CREATE PROCEDURE [citrus_usr].[pr_ins_roles_actions]
AS
BEGIN
--
  DECLARE CR_ROLES_RECORD CURSOR FOR
  SELECT rol.rol_id             rol_id
       , rol.rol_cd             rol_cd
  FROM   roles                  rol
  WHERE  rol.rol_deleted_ind  = 1
  AND    rol.rol_id           = 1
  
  DECLARE CR_ACTIONS_RECORD CURSOR FOR
  SELECT act.act_id            act_id
       , act.act_cd            act_cd
  FROM   actions               act
  WHERE  act.act_deleted_ind = 1
  
  declare  @l_rol_id  numeric
          ,@l_rol_cd  varchar(25)
          ,@l_act_id  numeric
          ,@l_act_cd varchar(25)    

  OPEN CR_ROLES_RECORD
  FETCH NEXT FROM CR_ROLES_RECORD INTO @l_rol_id , @l_rol_cd
  
  WHILE (@@FETCH_STATUS<> -1)
  BEGIN
  --
    OPEN CR_ACTIONS_RECORD
    FETCH NEXT FROM CR_ACTIONS_RECORD INTO @l_act_id , @l_act_cd
    
    WHILE (@@FETCH_STATUS<> -1)
    BEGIN
    --
        
        INSERT INTO roles_actions
	      ( rola_rol_id
	      , rola_act_id
	      , rola_access1
	      , rola_created_by
	      , rola_created_dt
	      , rola_lst_upd_by
	      , rola_lst_upd_dt
	      , rola_deleted_ind
	      )
	      
	      select @l_rol_id
	      , @l_act_id
	      , 255
	      , USER, GETDATE(), USER, GETDATE(), 1
          where not exists(select rola_rol_id , rola_act_id from roles_actions where rola_rol_id = @l_rol_id and rola_act_id = @l_act_id  )    
        
      
       
        FETCH NEXT FROM CR_ACTIONS_RECORD INTO @l_act_id , @l_act_cd
    --
    END
    
    CLOSE CR_ACTIONS_RECORD
   
    FETCH NEXT FROM CR_ROLES_RECORD INTO @l_rol_id , @l_rol_cd
  --
  END
  
  CLOSE CR_ROLES_RECORD 
  DEALLOCATE CR_ACTIONS_RECORD
  DEALLOCATE CR_ROLES_RECORD 
--
END

GO
