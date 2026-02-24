-- Object: TRIGGER citrus_usr.trig_act
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE TRIGGER trig_act  
ON actions  
FOR INSERT,UPDATE  
AS   
  
DECLARE @l_action VARCHAR(20)  
SET @l_action = 'E'  
IF UPDATE(act_deleted_ind) AND EXISTS(SELECT inserted.act_id FROM inserted WHERE inserted.act_deleted_ind=0)  
BEGIN  
--  
  SET @l_action = 'D'  
--  
END  
  
  
IF NOT EXISTS(SELECT deleted.act_id FROM deleted)   
BEGIN  
--  
  INSERT INTO act_hst  
  (act_id  
  ,act_cd  
  ,act_scr_id  
  ,act_desc  
  ,act_created_by  
  ,act_created_dt  
  ,act_lst_upd_by  
  ,act_lst_upd_dt  
  ,act_deleted_ind  
  ,act_action  
  )  
  SELECT inserted.act_id  
        ,inserted.act_cd  
        ,inserted.act_scr_id  
        ,inserted.act_desc  
        ,inserted.act_created_by  
        ,inserted.act_created_dt  
        ,inserted.act_lst_upd_by  
        ,inserted.act_lst_upd_dt  
        ,inserted.act_deleted_ind  
        ,'I'  
  FROM  inserted  
    
--  
END  
ELSE   
BEGIN  
--  
  INSERT INTO act_hst  
  (act_id  
  ,act_cd  
  ,act_scr_id  
  ,act_desc  
  ,act_created_by  
  ,act_created_dt  
  ,act_lst_upd_by  
  ,act_lst_upd_dt  
  ,act_deleted_ind  
  ,act_action  
  )  
  SELECT inserted.act_id  
        ,inserted.act_cd  
        ,inserted.act_scr_id  
        ,inserted.act_desc  
        ,inserted.act_created_by  
        ,inserted.act_created_dt  
        ,inserted.act_lst_upd_by  
        ,inserted.act_lst_upd_dt  
        ,inserted.act_deleted_ind  
        ,@l_action  
  FROM  inserted  
    
  IF @l_action='D'  
  BEGIN  
  --  
    DELETE actions  
    FROM   actions       act  
         , inserted      inserted  
    WHERE  act.act_id  = inserted.act_id  
    AND    inserted.act_deleted_ind = 0  
  --  
  END  
  
--     
END  
  
  
--ENTITY_ROLES

GO
