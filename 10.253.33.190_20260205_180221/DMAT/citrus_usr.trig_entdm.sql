-- Object: TRIGGER citrus_usr.trig_entdm
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

-------------trig_entdm-------------  
CREATE TRIGGER trig_entdm  
ON entpm_dtls_mstr  
FOR INSERT,UPDATE  
AS  
DECLARE @l_action VARCHAR(20)  
--  
SET @l_action = 'E'  
--  
IF UPDATE(entdm_deleted_ind)  
BEGIN  
--  
  IF EXISTS(SELECT inserted.entdm_id   
            FROM   inserted   
            WHERE  inserted.entdm_deleted_ind  = 0  
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
IF NOT EXISTS(SELECT deleted.entdm_id FROM deleted)   
BEGIN--insert  
--  
  INSERT INTO entdm_hst  
  ( entdm_id  
  , entdm_entpm_prop_id  
  , entdm_cd  
  , entdm_desc  
  , entdm_rmks  
  , entdm_datatype  
  , entdm_created_by  
  , entdm_created_dt  
  , entdm_lst_upd_by  
  , entdm_lst_upd_dt  
  , entdm_deleted_ind  
  , entdm_action  
  , entdm_mdty  
  )  
  SELECT inserted.entdm_id  
       , inserted.entdm_entpm_prop_id  
       , inserted.entdm_cd  
       , inserted.entdm_desc  
       , inserted.entdm_rmks  
       , inserted.entdm_datatype  
       , inserted.entdm_created_by  
       , inserted.entdm_created_dt  
       , inserted.entdm_lst_upd_by  
       , inserted.entdm_lst_upd_dt  
       , inserted.entdm_deleted_ind  
       , 'I'  
       , inserted.entdm_mdty  
  FROM   inserted  
--    
END  
ELSE   
BEGIN--updated  
--  
  INSERT INTO entdm_hst  
  ( entdm_id  
  , entdm_entpm_prop_id  
  , entdm_cd  
  , entdm_desc  
  , entdm_rmks  
  , entdm_datatype  
  , entdm_created_by  
  , entdm_created_dt  
  , entdm_lst_upd_by  
  , entdm_lst_upd_dt  
  , entdm_deleted_ind  
  , entdm_action  
  , entdm_mdty  
  )  
  SELECT inserted.entdm_id  
       , inserted.entdm_entpm_prop_id  
       , inserted.entdm_cd  
       , inserted.entdm_desc  
       , inserted.entdm_rmks  
       , inserted.entdm_datatype  
       , inserted.entdm_created_by  
       , inserted.entdm_created_dt  
       , inserted.entdm_lst_upd_by  
       , inserted.entdm_lst_upd_dt  
       , inserted.entdm_deleted_ind  
       , 'E'  
       , inserted.entdm_mdty  
  FROM   inserted  
  --  
  IF @l_action = 'D'  
  BEGIN  
  --  
      DELETE entpm_dtls_mstr  
      FROM   entpm_dtls_mstr              entdm  
          ,  inserted                     inserted  
      WHERE  entdm.entdm_id             = inserted.entdm_id  
      AND    inserted.entdm_deleted_ind = 0  
  --  
  END  
--     
END  
-------------trig_entdm-------------

GO
