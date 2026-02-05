-- Object: TRIGGER citrus_usr.trig_concm
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE TRIGGER trig_concm    
ON conc_code_mstr    
FOR INSERT,UPDATE    
AS    
DECLARE @l_action VARCHAR(20)    
--    
SET @l_action = 'E'    
--    
IF UPDATE(concm_deleted_ind)    
BEGIN    
--    
  IF EXISTS(SELECT inserted.concm_id     
            FROM   inserted     
            WHERE  inserted.concm_deleted_ind  = 0    
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
IF NOT EXISTS(SELECT deleted.concm_id FROM deleted)     
BEGIN--insert    
--    
  INSERT INTO CONCM_HST    
  ( concm_id    
  , concm_cd    
  , concm_desc    
  , concm_cli_yn    
  , concm_rmks    
  , concm_created_by    
  , concm_created_dt    
  , concm_lst_upd_by    
  , concm_lst_upd_dt    
  , concm_deleted_ind    
  , concm_action    
  )    
  SELECT inserted.concm_id    
       , inserted.concm_cd    
       , inserted.concm_desc    
       , inserted.concm_cli_yn    
       , inserted.concm_rmks    
       , inserted.concm_created_by    
       , inserted.concm_created_dt    
       , inserted.concm_lst_upd_by    
       , inserted.concm_lst_upd_dt    
       , inserted.concm_deleted_ind    
       , 'I'    
  FROM inserted    
--      
END    
ELSE     
BEGIN--updated    
--    
  INSERT INTO CONCM_HST    
  ( concm_id    
  , concm_cd    
  , concm_desc    
  , concm_cli_yn    
  , concm_rmks    
  , concm_created_by    
  , concm_created_dt    
  , concm_lst_upd_by    
  , concm_lst_upd_dt    
  , concm_deleted_ind    
  , concm_action    
  )    
  SELECT inserted.concm_id    
       , inserted.concm_cd    
       , inserted.concm_desc    
       , inserted.concm_cli_yn    
       , inserted.concm_rmks    
       , inserted.concm_created_by    
       , inserted.concm_created_dt    
       , inserted.concm_lst_upd_by    
       , inserted.concm_lst_upd_dt    
       , inserted.concm_deleted_ind    
       , 'E'    
  FROM inserted    
  --    
  IF @l_action = 'D'    
  BEGIN    
  --    
    DELETE conc_code_mstr    
    FROM   conc_code_mstr               concm    
        ,  inserted                     inserted    
    WHERE  concm.concm_id             = inserted.concm_id    
    AND    inserted.concm_deleted_ind = 0    
  --    
  END    
--       
END    
-------------trig_concm-------------

GO
