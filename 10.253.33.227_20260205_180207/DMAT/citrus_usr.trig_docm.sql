-- Object: TRIGGER citrus_usr.trig_docm
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

-------------trig_docm-------------  
CREATE TRIGGER trig_docm  
ON document_mstr  
FOR INSERT,UPDATE  
AS  
DECLARE @l_action VARCHAR(20)  
--  
IF UPDATE(docm_deleted_ind)  
BEGIN  
--  
  IF EXISTS(SELECT inserted.docm_id   
            FROM   inserted   
            WHERE  inserted.docm_deleted_ind  = 0  
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
IF NOT EXISTS(SELECT deleted.docm_id FROM deleted)   
BEGIN--insert  
--  
  INSERT INTO docm_hst  
  ( docm_id  
  , docm_doc_id  
  , docm_clicm_id  
  , docm_enttm_id  
  , docm_excpm_id  
  , docm_cd  
  , docm_desc  
  , docm_mdty  
  , docm_rmks  
  , docm_created_by  
  , docm_created_dt  
  , docm_lst_upd_by  
  , docm_lst_upd_dt  
  , docm_deleted_ind  
  , docm_action  
  )  
  SELECT inserted.docm_id  
       , inserted.docm_doc_id  
       , inserted.docm_clicm_id  
       , inserted.docm_enttm_id  
       , inserted.docm_excpm_id  
       , inserted.docm_cd  
       , inserted.docm_desc  
       , inserted.docm_mdty  
       , inserted.docm_rmks  
       , inserted.docm_created_by  
       , inserted.docm_created_dt  
       , inserted.docm_lst_upd_by  
       , inserted.docm_lst_upd_dt  
       , inserted.docm_deleted_ind  
       , 'I'  
  FROM   inserted  
--    
END  
ELSE   
BEGIN--updated  
--  
  INSERT INTO docm_hst  
  ( docm_id  
  , docm_doc_id  
  , docm_clicm_id  
  , docm_enttm_id  
  , docm_excpm_id  
  , docm_cd  
  , docm_desc  
  , docm_mdty  
  , docm_rmks  
  , docm_created_by  
  , docm_created_dt  
  , docm_lst_upd_by  
  , docm_lst_upd_dt  
  , docm_deleted_ind  
  , docm_action  
)  
  SELECT inserted.docm_id  
       , inserted.docm_doc_id  
       , inserted.docm_clicm_id  
       , inserted.docm_enttm_id  
       , inserted.docm_excpm_id  
       , inserted.docm_cd  
       , inserted.docm_desc  
       , inserted.docm_mdty  
       , inserted.docm_rmks  
       , inserted.docm_created_by  
       , inserted.docm_created_dt  
       , inserted.docm_lst_upd_by  
       , inserted.docm_lst_upd_dt  
       , inserted.docm_deleted_ind  
       , 'E'  
  FROM   inserted  
  --  
  IF @l_action = 'D'  
  BEGIN  
  --  
    DELETE document_mstr    
    FROM   document_mstr               docm  
       ,   inserted                    inserted  
    WHERE  docm.docm_id              = inserted.docm_id  
    AND    inserted.docm_deleted_ind = 0  
  --  
  END  
--     
END  
-------------trig_docm-------------

GO
