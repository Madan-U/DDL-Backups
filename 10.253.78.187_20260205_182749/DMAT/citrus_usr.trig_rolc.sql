-- Object: TRIGGER citrus_usr.trig_rolc
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE TRIGGER trig_rolc  
ON roles_components  
FOR INSERT,UPDATE  
AS   
  
DECLARE @l_action VARCHAR(20)  
SET @l_action = 'E'  
IF UPDATE(rolc_deleted_ind) AND EXISTS(SELECT inserted.rolc_rol_id FROM inserted WHERE inserted.rolc_deleted_ind=0)  
BEGIN  
--  
  SET @l_action = 'D'  
--  
END  
  
IF NOT EXISTS(SELECT deleted.rolc_rol_id FROM deleted)   
BEGIN  
--  
  INSERT INTO rolc_hst  
  (rolc_rol_id  
  ,rolc_scr_id  
  ,rolc_comp_id  
  ,rolc_mdtry  
  ,rolc_disable  
  ,rolc_created_by  
  ,rolc_created_dt  
  ,rolc_lst_upd_by  
  ,rolc_lst_upd_dt  
  ,rolc_deleted_ind  
  ,rolc_action  
  )  
  SELECT inserted.rolc_rol_id  
        ,inserted.rolc_scr_id  
        ,inserted.rolc_comp_id  
        ,inserted.rolc_mdtry  
        ,inserted.rolc_disable  
        ,inserted.rolc_created_by  
        ,inserted.rolc_created_dt  
        ,inserted.rolc_lst_upd_by  
        ,inserted.rolc_lst_upd_dt  
        ,inserted.rolc_deleted_ind  
        ,'I'  
  FROM  inserted  
    
--  
END  
ELSE   
BEGIN  
--  
  INSERT INTO rolc_hst  
  (rolc_rol_id  
  ,rolc_scr_id  
  ,rolc_comp_id  
  ,rolc_mdtry  
  ,rolc_disable  
  ,rolc_created_by  
  ,rolc_created_dt  
  ,rolc_lst_upd_by  
  ,rolc_lst_upd_dt  
  ,rolc_deleted_ind  
  ,rolc_action  
  )  
  SELECT inserted.rolc_rol_id  
        ,inserted.rolc_scr_id  
        ,inserted.rolc_comp_id  
        ,inserted.rolc_mdtry  
        ,inserted.rolc_disable  
        ,inserted.rolc_created_by  
        ,inserted.rolc_created_dt  
        ,inserted.rolc_lst_upd_by  
        ,inserted.rolc_lst_upd_dt  
        ,inserted.rolc_deleted_ind  
        ,@l_action  
  FROM  inserted  
    
  IF @l_action='D'  
  BEGIN  
  --  
    DELETE roles_components  
    FROM   roles_components rolc, inserted  
    WHERE  rolc.rolc_rol_id     = inserted.rolc_rol_id  
    AND    rolc.rolc_scr_id     = inserted.rolc_scr_id  
    AND    rolc.rolc_comp_id    = inserted.rolc_comp_id   
    AND    inserted.rolc_deleted_ind = 0  
      
      
  --  
  END  
  
--     
END  
  
  
--screens

GO
