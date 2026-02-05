-- Object: TRIGGER citrus_usr.trig_stam
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

-------------trig_stam-------------  
CREATE TRIGGER trig_stam  
ON status_mstr  
FOR INSERT,UPDATE  
AS  
DECLARE @l_action VARCHAR(20)  
--  
IF UPDATE(stam_deleted_ind)  
BEGIN  
--  
  IF EXISTS(SELECT inserted.stam_id   
            FROM   inserted   
            WHERE  inserted.stam_deleted_ind  = 0  
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
IF NOT EXISTS(SELECT deleted.stam_id FROM deleted)   
BEGIN--insert  
--  
  INSERT INTO stam_hst  
  ( stam_id  
  , stam_cd  
  , stam_desc  
  , stam_rmks  
  , stam_created_by  
  , stam_created_dt  
  , stam_lst_upd_by  
  , stam_lst_upd_dt  
  , stam_deleted_ind  
  , stam_action  
  )  
  SELECT inserted.stam_id  
       , inserted.stam_cd  
       , inserted.stam_desc  
       , inserted.stam_rmks  
       , inserted.stam_created_by  
       , inserted.stam_created_dt  
       , inserted.stam_lst_upd_by  
       , inserted.stam_lst_upd_dt  
       , inserted.stam_deleted_ind  
       , 'I'  
  FROM   inserted  
--    
END  
ELSE   
BEGIN--updated  
--  
  INSERT INTO stam_hst  
  ( stam_id  
  , stam_cd  
  , stam_desc  
  , stam_rmks  
  , stam_created_by  
  , stam_created_dt  
  , stam_lst_upd_by  
  , stam_lst_upd_dt  
  , stam_deleted_ind  
  , stam_action  
  )  
  SELECT inserted.stam_id  
       , inserted.stam_cd  
       , inserted.stam_desc  
       , inserted.stam_rmks  
       , inserted.stam_created_by  
       , inserted.stam_created_dt  
       , inserted.stam_lst_upd_by  
       , inserted.stam_lst_upd_dt  
       , inserted.stam_deleted_ind  
       , 'E'  
  FROM   inserted  
  --  
  IF @l_action = 'D'  
  BEGIN  
  --  
    DELETE status_mstr  
    FROM   status_mstr                 stam  
        ,  inserted                    inserted  
    WHERE  stam.stam_id              = inserted.stam_id  
    AND    inserted.stam_deleted_ind = 0  
  --  
  END  
--     
END  
-------------trig_stam-------------

GO
