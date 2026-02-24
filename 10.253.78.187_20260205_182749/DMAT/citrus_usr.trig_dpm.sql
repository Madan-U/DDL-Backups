-- Object: TRIGGER citrus_usr.trig_dpm
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

-------------trig_dpm-------------      
CREATE TRIGGER trig_dpm      
ON dp_mstr      
FOR INSERT,UPDATE      
AS      
DECLARE @l_action VARCHAR(20)      
--      
IF UPDATE(dpm_deleted_ind)      
BEGIN      
--      
  IF EXISTS(SELECT inserted.dpm_id       
            FROM   inserted       
            WHERE  inserted.dpm_deleted_ind  = 0      
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
IF NOT EXISTS(SELECT deleted.dpm_id FROM deleted)       
BEGIN--insert      
--      
  INSERT INTO dpm_hst      
  ( dpm_id      
  , dpm_name      
  , dpm_dpid      
  , dpm_excsm_id    
  , dpm_short_name        
  , dpm_rmks      
  , dpm_created_by      
  , dpm_created_dt      
  , dpm_lst_upd_by      
  , dpm_lst_upd_dt      
  , dpm_deleted_ind      
  , dpm_action      
  )      
  SELECT inserted.dpm_id      
       , inserted.dpm_name      
       , inserted.dpm_dpid      
       , inserted.dpm_excsm_id    
       , inserted.dpm_short_name        
       , inserted.dpm_rmks      
       , inserted.dpm_created_by      
       , inserted.dpm_created_dt      
       , inserted.dpm_lst_upd_by      
       , inserted.dpm_lst_upd_dt      
       , inserted.dpm_deleted_ind      
       , 'I'      
  FROM   inserted      
--        
END      
ELSE       
BEGIN--updated      
--      
  INSERT INTO dpm_hst      
  ( dpm_id      
  , dpm_name      
  , dpm_dpid      
  , dpm_excsm_id    
  , dpm_short_name      
  , dpm_rmks      
  , dpm_created_by      
  , dpm_created_dt      
  , dpm_lst_upd_by      
  , dpm_lst_upd_dt      
  , dpm_deleted_ind      
  , dpm_action      
  )      
  SELECT inserted.dpm_id      
       , inserted.dpm_name      
       , inserted.dpm_dpid      
       , inserted.dpm_excsm_id    
       , inserted.dpm_short_name     
       , inserted.dpm_rmks      
       , inserted.dpm_created_by      
       , inserted.dpm_created_dt      
       , inserted.dpm_lst_upd_by      
       , inserted.dpm_lst_upd_dt      
       , inserted.dpm_deleted_ind      
       , 'E'      
  FROM   inserted      
  --      
  IF @l_action = 'D'      
  BEGIN      
  --      
    DELETE dp_mstr      
    FROM   dp_mstr                    dpm      
        ,  inserted                   inserted      
    WHERE  dpm.dpm_id               = inserted.dpm_id      
    AND    inserted.dpm_deleted_ind = 0      
  --      
  END      
--         
END      
-------------trig_dpm-------------

GO
