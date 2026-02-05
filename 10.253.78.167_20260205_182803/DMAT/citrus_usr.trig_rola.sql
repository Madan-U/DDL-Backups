-- Object: TRIGGER citrus_usr.trig_rola
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE TRIGGER trig_rola  
ON roles_actions  
FOR INSERT,UPDATE  
AS   
  
DECLARE @l_action VARCHAR(20)  
SET @l_action = 'E'  
IF UPDATE(rola_deleted_ind) AND EXISTS(SELECT inserted.rola_rol_id FROM inserted WHERE inserted.rola_deleted_ind=0)  
BEGIN  
--  
  SET @l_action = 'D'  
--  
END  
  
  
IF NOT EXISTS(SELECT deleted.rola_rol_id FROM deleted)   
BEGIN  
--  
  INSERT INTO rola_hst  
  (rola_rol_id  
  ,rola_act_id  
  ,rola_access1  
  ,rola_created_by  
  ,rola_created_dt  
  ,rola_lst_upd_by  
  ,rola_lst_upd_dt  
  ,rola_deleted_ind  
  ,rola_action  
  )  
  SELECT inserted.rola_rol_id  
        ,inserted.rola_act_id  
        ,inserted.rola_access1  
        ,inserted.rola_created_by  
        ,inserted.rola_created_dt  
        ,inserted.rola_lst_upd_by  
        ,inserted.rola_lst_upd_dt  
        ,inserted.rola_deleted_ind  
        ,'I'  
  FROM  inserted  
    
--  
END  
ELSE   
BEGIN  
--  
  INSERT INTO rola_hst  
  (rola_rol_id  
  ,rola_act_id  
  ,rola_access1  
  ,rola_created_by  
  ,rola_created_dt  
  ,rola_lst_upd_by  
  ,rola_lst_upd_dt  
  ,rola_deleted_ind  
  ,rola_action  
  
  )  
  SELECT inserted.rola_rol_id  
        ,inserted.rola_act_id  
        ,inserted.rola_access1  
        ,inserted.rola_created_by  
        ,inserted.rola_created_dt  
        ,inserted.rola_lst_upd_by  
        ,inserted.rola_lst_upd_dt  
        ,inserted.rola_deleted_ind  
        ,@l_action  
  FROM  inserted  
    
  IF @l_action='D'  
  BEGIN  
  --  
    DELETE roles_actions  
    FROM   roles_actions       rola  
         , inserted            inserted  
    WHERE  rola.rola_rol_id  = inserted.rola_rol_id  
    AND    rola.rola_act_id  = inserted.rola_act_id  
    AND    inserted.rola_deleted_ind = 0  
  
  --  
  END  
  
--     
END  
  
--ROLES_COMPONENTS

GO
