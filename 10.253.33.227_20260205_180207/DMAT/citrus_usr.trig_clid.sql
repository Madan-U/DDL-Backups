-- Object: TRIGGER citrus_usr.trig_clid
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

   CREATE TRIGGER trig_clid  
ON client_documents  
FOR INSERT,UPDATE,DELETE   
AS   
IF NOT EXISTS(SELECT deleted.clid_crn_no FROM deleted)   
BEGIN  
--  
  INSERT INTO clid_hst  
  (clid_crn_no  
  ,clid_docm_doc_id  
  ,clid_valid_yn  
  ,clid_remarks  
  ,clid_doc_path  
  ,clid_created_by  
  ,clid_created_dt  
  ,clid_lst_upd_by  
  ,clid_lst_upd_dt  
  ,clid_deleted_ind  
  ,clid_action  
  )  
  SELECT inserted.clid_crn_no  
        ,inserted.clid_docm_doc_id  
        ,inserted.clid_valid_yn  
        ,inserted.clid_remarks  
        ,inserted.clid_doc_path  
        ,inserted.clid_created_by  
        ,inserted.clid_created_dt  
        ,inserted.clid_lst_upd_by  
        ,inserted.clid_lst_upd_dt  
        ,inserted.clid_deleted_ind  
        ,'I'  
  FROM  inserted  
    
--  
  
END  
ELSE IF NOT EXISTS(SELECT inserted.clid_crn_no FROM inserted)   
BEGIN  
--  
  INSERT INTO clid_hst  
  (clid_crn_no  
  ,clid_docm_doc_id  
  ,clid_valid_yn  
  ,clid_remarks  
  ,clid_doc_path  
  ,clid_created_by  
  ,clid_created_dt  
  ,clid_lst_upd_by  
  ,clid_lst_upd_dt  
  ,clid_deleted_ind  
  ,clid_action  
  )  
  SELECT deleted.clid_crn_no  
        ,deleted.clid_docm_doc_id  
        ,deleted.clid_valid_yn  
        ,deleted.clid_remarks  
        ,deleted.clid_doc_path  
        ,deleted.clid_created_by  
        ,deleted.clid_created_dt  
        ,deleted.clid_lst_upd_by  
        ,deleted.clid_lst_upd_dt  
        ,deleted.clid_deleted_ind  
        ,'D'  
  FROM  deleted  
  
--  
END  
ELSE   
BEGIN  
--  
  INSERT INTO clid_hst  
  (clid_crn_no  
  ,clid_docm_doc_id  
  ,clid_valid_yn  
  ,clid_remarks  
  ,clid_doc_path  
  ,clid_created_by  
  ,clid_created_dt  
  ,clid_lst_upd_by  
  ,clid_lst_upd_dt  
  ,clid_deleted_ind  
  ,clid_action  
  )  
  SELECT inserted.clid_crn_no  
        ,inserted.clid_docm_doc_id  
        ,inserted.clid_valid_yn  
        ,inserted.clid_remarks  
        ,inserted.clid_doc_path  
        ,inserted.clid_created_by  
        ,inserted.clid_created_dt  
        ,inserted.clid_lst_upd_by  
        ,inserted.clid_lst_upd_dt  
        ,inserted.clid_deleted_ind  
        ,'E'  
  FROM  inserted  
  
--     
END  
  
--entity_adr_conc

GO
