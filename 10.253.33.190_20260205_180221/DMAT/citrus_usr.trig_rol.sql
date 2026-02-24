-- Object: TRIGGER citrus_usr.trig_rol
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE TRIGGER trig_rol  
ON roles  
FOR INSERT,UPDATE  
AS   
  
DECLARE @l_action VARCHAR(20)  
SET @l_action = 'E'  
IF UPDATE(rol_deleted_ind) AND EXISTS(SELECT inserted.rol_id FROM inserted WHERE inserted.rol_deleted_ind=0)  
BEGIN  
--  
  SET @l_action = 'D'  
--  
END  
  
  
IF NOT EXISTS(SELECT deleted.rol_id FROM deleted)   
BEGIN  
--  
  INSERT INTO rol_hst  
  (rol_id  
  ,rol_cd  
  ,rol_desc  
  ,rol_created_by  
  ,rol_created_dt  
  ,rol_lst_upd_by  
  ,rol_lst_upd_dt  
  ,rol_deleted_ind  
  ,rol_action  
  )  
  SELECT inserted.rol_id  
        ,inserted.rol_cd  
        ,inserted.rol_desc  
        ,inserted.rol_created_by  
        ,inserted.rol_created_dt  
        ,inserted.rol_lst_upd_by  
        ,inserted.rol_lst_upd_dt  
        ,inserted.rol_deleted_ind  
        ,'I'  
  FROM  inserted  
    
--  
END  
ELSE   
BEGIN  
--  
  INSERT INTO rol_hst  
  (rol_id  
  ,rol_cd  
  ,rol_desc  
  ,rol_created_by  
  ,rol_created_dt  
  ,rol_lst_upd_by  
  ,rol_lst_upd_dt  
  ,rol_deleted_ind  
  ,rol_action  
  )  
  SELECT inserted.rol_id  
        ,inserted.rol_cd  
        ,inserted.rol_desc  
        ,inserted.rol_created_by  
        ,inserted.rol_created_dt  
        ,inserted.rol_lst_upd_by  
        ,inserted.rol_lst_upd_dt  
        ,inserted.rol_deleted_ind  
        ,@l_action  
  FROM  inserted  
    
    
  IF @l_action='D'  
  BEGIN  
  --  
    DELETE roles  
    FROM   roles           rol  
         , inserted        inserted  
    WHERE  rol.rol_id    = inserted.rol_id  
    AND    inserted.rol_deleted_ind = 0  
  --  
  END  
  
--     
END  
  
--ROLES_ACTIONS

GO
