-- Object: TRIGGER citrus_usr.trig_entro
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE TRIGGER trig_entro  
ON entity_roles  
FOR INSERT,UPDATE  
AS   
  
DECLARE @l_action VARCHAR(20)  
SET @l_action = 'E'  
IF UPDATE(entro_deleted_ind) AND EXISTS(SELECT inserted.entro_logn_name FROM inserted WHERE inserted.entro_deleted_ind=0)  
BEGIN  
--  
  SET @l_action = 'D'  
--  
END  
  
IF NOT EXISTS(SELECT deleted.entro_logn_name FROM deleted)   
BEGIN  
--  
  INSERT INTO entro_hst  
  (entro_logn_name  
  ,entro_rol_id  
  ,entro_created_by  
  ,entro_created_dt  
  ,entro_lst_upd_by  
  ,entro_lst_upd_dt  
  ,entro_deleted_ind  
  ,entro_logn_from_dt  
  ,entro_action  
  )  
  SELECT inserted.entro_logn_name  
        ,inserted.entro_rol_id  
        ,inserted.entro_created_by  
        ,inserted.entro_created_dt  
        ,inserted.entro_lst_upd_by  
        ,inserted.entro_lst_upd_dt  
        ,inserted.entro_deleted_ind  
        ,inserted.entro_logn_from_dt  
        ,'I'  
  FROM  inserted  
    
--  
END  
ELSE   
BEGIN  
--  
  INSERT INTO entro_hst  
  (entro_logn_name  
  ,entro_rol_id  
  ,entro_created_by  
  ,entro_created_dt  
  ,entro_lst_upd_by  
  ,entro_lst_upd_dt  
  ,entro_deleted_ind  
  ,entro_logn_from_dt  
  ,entro_action  
  )  
  SELECT inserted.entro_logn_name  
        ,inserted.entro_rol_id  
        ,inserted.entro_created_by  
        ,inserted.entro_created_dt  
        ,inserted.entro_lst_upd_by  
        ,inserted.entro_lst_upd_dt  
        ,inserted.entro_deleted_ind  
        ,inserted.entro_logn_from_dt  
        ,@l_action  
  FROM  inserted  
    
  IF @l_action='D'  
  BEGIN  
  --  
    DELETE entity_roles  
    FROM   entity_roles            entro  
         , inserted                inserted  
    WHERE  entro.entro_logn_name = inserted.entro_logn_name  
    AND    entro.entro_rol_id    = inserted.entro_rol_id  
    AND    inserted.entro_deleted_ind = 0  
  --  
  END  
  
--     
END  
  
  
  
--LOGIN_NAMES

GO
