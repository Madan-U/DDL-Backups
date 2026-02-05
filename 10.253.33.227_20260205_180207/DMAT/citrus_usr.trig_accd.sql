-- Object: TRIGGER citrus_usr.trig_accd
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------




--account_documents


CREATE  TRIGGER [citrus_usr].[trig_accd]
ON [citrus_usr].[ACCOUNT_DOCUMENTS]
FOR INSERT,UPDATE,DELETE 
AS 
IF NOT EXISTS(SELECT deleted.accd_clisba_id FROM deleted) 
BEGIN
--
  INSERT INTO accd_hst
  (accd_clisba_id
  ,accd_acct_no
  ,accd_acct_type
  ,accd_accdocm_doc_id
  ,accd_valid_yn
  ,accd_remarks
  ,accd_doc_path
  ,accd_created_by
  ,accd_created_dt
  ,accd_lst_upd_by
  ,accd_lst_upd_dt
  ,accd_deleted_ind
  ,accd_binary_image
  ,accd_action
  )
  SELECT inserted.accd_clisba_id
        ,inserted.accd_acct_no
        ,inserted.accd_acct_type
        ,inserted.accd_accdocm_doc_id
        ,inserted.accd_valid_yn
        ,inserted.accd_remarks
        ,inserted.accd_doc_path
        ,inserted.accd_created_by
        ,inserted.accd_created_dt
        ,inserted.accd_lst_upd_by
        ,inserted.accd_lst_upd_dt
        ,inserted.accd_deleted_ind
        ,inserted.accd_binary_image
        ,'I'
  FROM  inserted
  
--

END
ELSE IF NOT EXISTS(SELECT inserted.accd_clisba_id FROM inserted) 
BEGIN
--
  INSERT INTO accd_hst
  (accd_clisba_id
  ,accd_acct_no
  ,accd_acct_type
  ,accd_accdocm_doc_id
  ,accd_valid_yn
  ,accd_remarks
  ,accd_doc_path
  ,accd_created_by
  ,accd_created_dt
  ,accd_lst_upd_by
  ,accd_lst_upd_dt
  ,accd_deleted_ind
  ,accd_binary_image
  ,accd_action
  )
  SELECT deleted.accd_clisba_id
        ,deleted.accd_acct_no
        ,deleted.accd_acct_type
        ,deleted.accd_accdocm_doc_id
        ,deleted.accd_valid_yn
        ,deleted.accd_remarks
        ,deleted.accd_doc_path
        ,deleted.accd_created_by
        ,deleted.accd_created_dt
        ,deleted.accd_lst_upd_by
        ,deleted.accd_lst_upd_dt
        ,deleted.accd_deleted_ind
        ,deleted.accd_binary_image
        ,'D'
  FROM  deleted

--
END
ELSE 
BEGIN
--
  INSERT INTO accd_hst
  (accd_clisba_id
  ,accd_acct_no
  ,accd_acct_type
  ,accd_accdocm_doc_id
  ,accd_valid_yn
  ,accd_remarks
  ,accd_doc_path
  ,accd_created_by
  ,accd_created_dt
  ,accd_lst_upd_by
  ,accd_lst_upd_dt
  ,accd_deleted_ind
  ,accd_binary_image
  ,accd_action
  )
  SELECT deleted.accd_clisba_id
        ,deleted.accd_acct_no
        ,deleted.accd_acct_type
        ,deleted.accd_accdocm_doc_id
        ,deleted.accd_valid_yn
        ,deleted.accd_remarks
        ,deleted.accd_doc_path
        ,deleted.accd_created_by
        ,deleted.accd_created_dt
        ,deleted.accd_lst_upd_by
        ,deleted.accd_lst_upd_dt
        ,deleted.accd_deleted_ind
        ,deleted.accd_binary_image
        ,'E'
  FROM  deleted

--   
END


--client_documents

GO
