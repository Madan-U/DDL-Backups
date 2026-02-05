-- Object: TRIGGER citrus_usr.trig_banm
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

-------------trig_banm--------------  
CREATE TRIGGER trig_banm  
ON bank_mstr  
FOR INSERT,UPDATE  
AS  
DECLARE @l_action VARCHAR(20)  
--  
SET @l_action = 'E'  
--  
IF UPDATE(banm_deleted_ind)  
BEGIN  
--  
  IF EXISTS(SELECT inserted.banm_id   
            FROM   inserted   
            WHERE  inserted.banm_deleted_ind  = 0  
           )  
  BEGIN  
  --  
    SET @l_action = 'D'  
  --    
  END    
--  
END  
--ELSE  
--BEGIN  
--  
--  SET @l_action = 'E'  
--  
--END  
--  
IF NOT EXISTS(SELECT deleted.banm_id FROM deleted)   
BEGIN--insert  
--  
  INSERT INTO banm_hst  
  ( banm_id  
  , banm_name  
  , banm_branch  
  , banm_micr  
  , banm_rmks  
  , banm_created_by  
  , banm_created_dt  
  , banm_lst_upd_by  
  , banm_lst_upd_dt  
  , banm_deleted_ind  
  , banm_action  
  )  
  SELECT inserted.banm_id  
       , inserted.banm_name  
       , inserted.banm_branch  
       , inserted.banm_micr  
       , inserted.banm_rmks  
       , inserted.banm_created_by  
       , inserted.banm_created_dt  
       , inserted.banm_lst_upd_by  
       , inserted.banm_lst_upd_dt  
       , inserted.banm_deleted_ind  
       , 'I'  
  FROM   inserted  
--    
END  
ELSE   
BEGIN--updated  
--  
  INSERT INTO banm_hst  
  ( banm_id  
  , banm_name  
  , banm_branch  
  , banm_micr  
  , banm_rmks  
  , banm_created_by  
  , banm_created_dt  
  , banm_lst_upd_by  
  , banm_lst_upd_dt  
  , banm_deleted_ind  
  , banm_action  
  )  
  SELECT inserted.banm_id  
       , inserted.banm_name  
       , inserted.banm_branch  
       , inserted.banm_micr  
       , inserted.banm_rmks  
       , inserted.banm_created_by  
       , inserted.banm_created_dt  
       , inserted.banm_lst_upd_by  
       , inserted.banm_lst_upd_dt  
       , inserted.banm_deleted_ind  
       , 'E'  
  FROM   inserted  
  --  
  IF @l_action = 'D'  
  BEGIN  
  --  
      DELETE bank_mstr  
      FROM   bank_mstr                   banm  
           , inserted                    inserted  
      WHERE  banm.banm_id              = inserted.banm_id  
      AND    inserted.banm_deleted_ind = 0  
  --  
  END  
--     
END  
-------------trig_banm---------------

GO
