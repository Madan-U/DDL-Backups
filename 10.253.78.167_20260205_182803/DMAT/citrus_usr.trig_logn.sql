-- Object: TRIGGER citrus_usr.trig_logn
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE TRIGGER trig_logn  
ON citrus_usr.LOGIN_NAMES  
FOR INSERT,UPDATE  
AS   
  
DECLARE @l_action VARCHAR(20)  
SET @l_action = 'E'  
IF UPDATE(logn_deleted_ind) AND EXISTS(SELECT inserted.logn_name FROM inserted WHERE inserted.logn_deleted_ind=0)  
BEGIN  
--  
  SET @l_action = 'D'  
--  
END  
  
  
  
IF NOT EXISTS(SELECT deleted.logn_name FROM deleted)   
BEGIN  
--  
  INSERT INTO logn_hst  
  (logn_name  
  ,logn_pswd  
  ,logn_enttm_id  
  ,logn_ent_id  
  ,logn_short_name  
  ,logn_from_dt  
  ,logn_to_dt  
  ,logn_created_by  
  ,logn_created_dt  
  ,logn_lst_upd_by  
  ,logn_lst_upd_dt  
  ,logn_deleted_ind  
  ,logn_action  
  ,logn_sbum_id  
  )  
  SELECT inserted.logn_name  
        ,inserted.logn_pswd  
        ,inserted.logn_enttm_id  
        ,inserted.logn_ent_id  
        ,inserted.logn_short_name  
        ,inserted.logn_from_dt  
        ,inserted.logn_to_dt  
        ,inserted.logn_created_by  
        ,inserted.logn_created_dt  
        ,inserted.logn_lst_upd_by  
        ,inserted.logn_lst_upd_dt  
        ,inserted.logn_deleted_ind  
        ,'I'  
        ,inserted.logn_sbum_id  
  FROM  inserted  
    
--  
END  
ELSE   
BEGIN  
--  
  INSERT INTO logn_hst  
  (logn_name  
  ,logn_pswd  
  ,logn_enttm_id  
  ,logn_ent_id  
  ,logn_short_name  
  ,logn_from_dt  
  ,logn_to_dt  
  ,logn_created_by  
  ,logn_created_dt  
  ,logn_lst_upd_by  
  ,logn_lst_upd_dt  
  ,logn_deleted_ind  
  ,logn_action  
  ,logn_sbum_id  
  )  
  SELECT inserted.logn_name  
        ,inserted.logn_pswd  
        ,inserted.logn_enttm_id  
        ,inserted.logn_ent_id  
        ,inserted.logn_short_name  
        ,inserted.logn_from_dt  
        ,inserted.logn_to_dt  
        ,inserted.logn_created_by  
        ,inserted.logn_created_dt  
        ,inserted.logn_lst_upd_by  
        ,inserted.logn_lst_upd_dt  
        ,inserted.logn_deleted_ind  
        ,@l_action  
        ,inserted.logn_sbum_id  
  FROM  inserted  
    
  IF @l_action='D'  
  BEGIN  
  --  
    DELETE login_names  
    FROM   login_names       logn  
         , inserted          inserted  
    WHERE  logn.logn_name = inserted.logn_name   
    AND    inserted.logn_deleted_ind = 0  
  --  
  END  
  
--     
END  
  
--ROLES

GO
