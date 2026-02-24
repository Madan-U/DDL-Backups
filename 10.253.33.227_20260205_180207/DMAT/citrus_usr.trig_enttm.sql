-- Object: TRIGGER citrus_usr.trig_enttm
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE TRIGGER trig_enttm      
ON citrus_usr.ENTITY_TYPE_MSTR      
FOR INSERT,UPDATE      
AS      
DECLARE @l_action VARCHAR(20)      
--      
SET @l_action = 'E'      
--      
IF UPDATE(enttm_deleted_ind)      
BEGIN      
--      
  IF EXISTS(SELECT inserted.enttm_id       
            FROM   inserted       
            WHERE  inserted.enttm_deleted_ind  = 0      
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
IF NOT EXISTS(SELECT deleted.enttm_id FROM deleted)       
BEGIN--insert      
--      
  INSERT INTO enttm_hst      
  ( enttm_id      
  , enttm_cd      
  , enttm_prefix      
  , enttm_desc      
  , enttm_cli_yn      
  , enttm_parent_cd      
  , enttm_rmks      
  , enttm_created_by      
  , enttm_created_dt      
  , enttm_lst_upd_by      
  , enttm_lst_upd_dt      
  , enttm_deleted_ind      
  , enttm_action    
  , enttm_bit      
  )      
  SELECT inserted.enttm_id      
       , inserted.enttm_cd      
       , inserted.enttm_prefix      
       , inserted.enttm_desc      
       , inserted.enttm_cli_yn      
       , inserted.enttm_parent_cd      
       , inserted.enttm_rmks      
       , inserted.enttm_created_by      
       , inserted.enttm_created_dt      
       , inserted.enttm_lst_upd_by      
       , inserted.enttm_lst_upd_dt      
       , inserted.enttm_deleted_ind      
       , 'I'    
       , inserted.enttm_bit      
  FROM   inserted      
--        
END      
ELSE       
BEGIN--updated      
--      
  INSERT INTO enttm_hst      
  ( enttm_id      
  , enttm_cd      
  , enttm_prefix      
  , enttm_desc      
  , enttm_cli_yn      
  , enttm_parent_cd      
  , enttm_rmks      
  , enttm_created_by      
  , enttm_created_dt      
  , enttm_lst_upd_by      
  , enttm_lst_upd_dt      
  , enttm_deleted_ind      
  , enttm_action    
  , enttm_bit       
  )      
  SELECT inserted.enttm_id      
       , inserted.enttm_cd      
       , inserted.enttm_prefix      
       , inserted.enttm_desc      
       , inserted.enttm_cli_yn      
       , inserted.enttm_parent_cd      
       , inserted.enttm_rmks      
       , inserted.enttm_created_by      
       , inserted.enttm_created_dt      
       , inserted.enttm_lst_upd_by      
       , inserted.enttm_lst_upd_dt      
       , inserted.enttm_deleted_ind      
       , 'E'    
       , inserted.enttm_bit        
  FROM   inserted      
  --      
  IF @l_action = 'D'      
  BEGIN      
  --      
      
    DELETE entity_type_mstr      
    FROM   entity_type_mstr            enttm      
        ,  inserted                    inserted      
    WHERE  enttm.enttm_id            = inserted.enttm_id      
    AND    inserted.enttm_deleted_ind = 0      
      
          
      
  --      
  END      
--         
END

GO
