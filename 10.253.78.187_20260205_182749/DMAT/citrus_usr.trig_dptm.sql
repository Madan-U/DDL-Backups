-- Object: TRIGGER citrus_usr.trig_dptm
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

-------------trig_dptm-------------  
CREATE TRIGGER trig_dptm  
ON dp_type_mstr  
FOR INSERT,UPDATE  
AS  
DECLARE @l_action VARCHAR(20)  
--  
IF UPDATE(dptm_deleted_ind)  
BEGIN  
--  
  IF EXISTS(SELECT inserted.dptm_id   
            FROM   inserted   
            WHERE  inserted.dptm_deleted_ind  = 0  
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
IF NOT EXISTS(SELECT deleted.dptm_id FROM deleted)   
BEGIN--insert  
--  
  INSERT INTO dptm_hst  
  ( dptm_id  
  , dptm_cd  
  , dptm_desc  
  , dptm_rmks  
  , dptm_created_by  
  , dptm_created_dt  
  , dptm_lst_upd_by  
  , dptm_lst_upd_dt  
  , dptm_deleted_ind  
  , dptm_action  
  )  
  SELECT inserted.dptm_id  
       , inserted.dptm_cd  
       , inserted.dptm_desc  
       , inserted.dptm_rmks  
       , inserted.dptm_created_by  
       , inserted.dptm_created_dt  
       , inserted.dptm_lst_upd_by  
       , inserted.dptm_lst_upd_dt  
       , inserted.dptm_deleted_ind  
       , 'I'  
  FROM   inserted  
--    
END  
ELSE   
BEGIN--updated  
--  
  INSERT INTO dptm_hst  
  ( dptm_id  
  , dptm_cd  
  , dptm_desc  
  , dptm_rmks  
  , dptm_created_by  
  , dptm_created_dt  
  , dptm_lst_upd_by  
  , dptm_lst_upd_dt  
  , dptm_deleted_ind  
  , dptm_action  
  )  
  SELECT inserted.dptm_id  
       , inserted.dptm_cd  
       , inserted.dptm_desc  
       , inserted.dptm_rmks  
       , inserted.dptm_created_by  
       , inserted.dptm_created_dt  
       , inserted.dptm_lst_upd_by  
       , inserted.dptm_lst_upd_dt  
       , inserted.dptm_deleted_ind  
       , 'E'  
  FROM   inserted  
  --  
  IF @l_action = 'D'  
  BEGIN  
  --  
    DELETE dp_type_mstr  
    FROM   dp_type_mstr                dptm  
         , inserted                    inserted  
    WHERE  dptm.dptm_id              = inserted.dptm_id  
    AND    inserted.dptm_deleted_ind = 0  
  --  
  END  
--     
END  
-------------trig_dptm------------

GO
