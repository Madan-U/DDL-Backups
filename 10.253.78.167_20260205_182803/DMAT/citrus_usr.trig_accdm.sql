-- Object: TRIGGER citrus_usr.trig_accdm
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

-------------trig_accdm-----------  
CREATE TRIGGER trig_accdm  
ON accpm_dtls_mstr  
FOR INSERT,UPDATE  
AS  
DECLARE @l_action char(1)  
--  
SET @l_action = 'E'  
--  
IF UPDATE(accdm_deleted_ind)  
BEGIN  
--  
  IF EXISTS(SELECT inserted.accdm_id   
            FROM   inserted   
            WHERE  inserted.accdm_deleted_ind  = 0  
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
IF NOT EXISTS(SELECT deleted.accdm_id FROM deleted)   
BEGIN--insert  
--  
  INSERT INTO accdm_hst  
  (accdm_id  
  ,accdm_accpm_prop_id  
  ,accdm_cd  
  ,accdm_desc  
  ,accdm_rmks  
  ,accdm_datatype  
  ,accdm_mdty  
  ,accdm_created_by  
  ,accdm_created_dt  
  ,accdm_lst_upd_by  
  ,accdm_lst_upd_dt  
  ,accdm_deleted_ind  
  ,accdm_action   
  )  
  SELECT inserted.accdm_id  
       , inserted.accdm_accpm_prop_id  
       , inserted.accdm_cd  
       , inserted.accdm_desc  
       , inserted.accdm_rmks  
       , inserted.accdm_datatype  
       , inserted.accdm_mdty  
       , inserted.accdm_created_by  
       , inserted.accdm_created_dt  
       , inserted.accdm_lst_upd_by  
       , inserted.accdm_lst_upd_dt  
       , inserted.accdm_deleted_ind  
       , 'I'  
  FROM   inserted  
--    
END  
ELSE   
BEGIN--updated  
--  
  INSERT INTO accdm_hst  
  (accdm_id  
  ,accdm_accpm_prop_id  
  ,accdm_cd  
  ,accdm_desc  
  ,accdm_rmks  
  ,accdm_datatype  
  ,accdm_mdty  
  ,accdm_created_by  
  ,accdm_created_dt  
  ,accdm_lst_upd_by  
  ,accdm_lst_upd_dt  
  ,accdm_deleted_ind  
  ,accdm_action   
  )  
  SELECT inserted.accdm_id  
       , inserted.accdm_accpm_prop_id  
       , inserted.accdm_cd  
       , inserted.accdm_desc  
       , inserted.accdm_rmks  
       , inserted.accdm_datatype  
       , inserted.accdm_mdty  
       , inserted.accdm_created_by  
       , inserted.accdm_created_dt  
       , inserted.accdm_lst_upd_by  
       , inserted.accdm_lst_upd_dt  
       , inserted.accdm_deleted_ind  
       , 'E'  
  FROM   inserted  
  --  
  IF @l_action = 'D'  
  BEGIN  
  --  
    DELETE accpm_dtls_mstr  
    FROM   accpm_dtls_mstr              accdm  
         , inserted                     inserted  
    WHERE  accdm.accdm_id             = inserted.accdm_id  
    AND    inserted.accdm_deleted_ind = 0  
  --  
  END  
--     
END  
-------------trig_accdm-----------

GO
