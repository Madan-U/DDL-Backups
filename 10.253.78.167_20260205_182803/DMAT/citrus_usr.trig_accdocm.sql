-- Object: TRIGGER citrus_usr.trig_accdocm
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

  -------------trig_accdocm-----------  
CREATE TRIGGER trig_accdocm  
ON account_document_mstr  
FOR INSERT,UPDATE  
AS  
DECLARE @l_action VARCHAR(20)  
--  
SET @l_action = 'E'  
--  
IF UPDATE(accdocm_deleted_ind)  
BEGIN  
--  
  IF EXISTS(SELECT inserted.accdocm_id   
            FROM   inserted   
            WHERE  inserted.accdocm_deleted_ind  = 0  
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
IF NOT EXISTS(SELECT deleted.accdocm_id FROM deleted)   
BEGIN--insert  
--  
  INSERT INTO accdocm_hst  
  ( accdocm_id  
  , accdocm_doc_id  
  , accdocm_clicm_id  
  , accdocm_enttm_id  
  , accdocm_excpm_id  
  , accdocm_cd  
  , accdocm_desc  
  , accdocm_rmks  
  , accdocm_mdty  
  , accdocm_acct_type  
  , accdocm_created_by  
  , accdocm_created_dt  
  , accdocm_lst_upd_by  
  , accdocm_lst_upd_dt  
  , accdocm_deleted_ind  
  , accdocm_action  
  )  
  SELECT inserted.accdocm_id  
       , inserted.accdocm_doc_id  
       , inserted.accdocm_clicm_id  
       , inserted.accdocm_enttm_id  
       , inserted.accdocm_excpm_id  
       , inserted.accdocm_cd  
       , inserted.accdocm_desc  
       , inserted.accdocm_rmks  
       , inserted.accdocm_mdty  
       , inserted.accdocm_acct_type  
       , inserted.accdocm_created_by  
       , inserted.accdocm_created_dt  
       , inserted.accdocm_lst_upd_by  
       , inserted.accdocm_lst_upd_dt  
       , inserted.accdocm_deleted_ind  
       , 'I'  
  FROM   inserted  
--    
END  
ELSE   
BEGIN--updated  
--  
  INSERT INTO accdocm_hst  
  ( accdocm_id  
  , accdocm_doc_id  
  , accdocm_clicm_id  
  , accdocm_enttm_id  
  , accdocm_excpm_id  
  , accdocm_cd  
  , accdocm_desc  
  , accdocm_rmks  
  , accdocm_mdty  
  , accdocm_acct_type  
  , accdocm_created_by  
  , accdocm_created_dt  
  , accdocm_lst_upd_by  
  , accdocm_lst_upd_dt  
  , accdocm_deleted_ind  
  , accdocm_action  
  )  
  SELECT inserted.accdocm_id  
       , inserted.accdocm_doc_id  
       , inserted.accdocm_clicm_id  
       , inserted.accdocm_enttm_id  
       , inserted.accdocm_excpm_id  
       , inserted.accdocm_cd  
       , inserted.accdocm_desc  
       , inserted.accdocm_rmks  
       , inserted.accdocm_mdty  
       , inserted.accdocm_acct_type  
       , inserted.accdocm_created_by  
       , inserted.accdocm_created_dt  
       , inserted.accdocm_lst_upd_by  
       , inserted.accdocm_lst_upd_dt  
       , inserted.accdocm_deleted_ind  
       , 'E'  
  FROM   inserted  
  --  
  IF @l_action = 'D'  
  BEGIN  
  --  
      DELETE account_document_mstr   
      FROM   account_document_mstr          accdocm  
           , inserted                       inserted  
      WHERE  accdocm.accdocm_id           = inserted.accdocm_id  
      AND    inserted.accdocm_deleted_ind = 0             
  --  
  END  
--     
END

GO
