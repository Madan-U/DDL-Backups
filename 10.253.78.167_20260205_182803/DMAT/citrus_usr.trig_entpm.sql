-- Object: TRIGGER citrus_usr.trig_entpm
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

-------------trig_entpm-------------  
CREATE TRIGGER trig_entpm  
ON entity_property_mstr  
FOR INSERT,UPDATE  
AS  
DECLARE @l_action VARCHAR(20)  
--  
SET @l_action = 'E'  
--  
IF UPDATE(entpm_deleted_ind)  
BEGIN  
--  
  IF EXISTS(SELECT inserted.entpm_id   
            FROM   inserted   
            WHERE  inserted.entpm_deleted_ind  = 0  
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
IF NOT EXISTS(SELECT deleted.entpm_id FROM deleted)   
BEGIN--insert  
--  
  INSERT INTO entpm_hst  
  ( entpm_id  
  , entpm_prop_id  
  , entpm_clicm_id  
  , entpm_enttm_id  
  , entpm_excpm_id  
  , entpm_cd  
  , entpm_desc  
  , entpm_cli_yn  
  , entpm_mdty  
  , entpm_rmks  
  , entpm_datatype  
  , entpm_created_by  
  , entpm_created_dt  
  , entpm_lst_upd_by  
  , entpm_lst_upd_dt  
  , entpm_deleted_ind  
  , entpm_action  
  )  
  SELECT inserted.entpm_id  
       , inserted.entpm_prop_id  
       , inserted.entpm_clicm_id  
       , inserted.entpm_enttm_id  
       , inserted.entpm_excpm_id  
       , inserted.entpm_cd  
       , inserted.entpm_desc  
       , inserted.entpm_cli_yn  
       , inserted.entpm_mdty  
       , inserted.entpm_rmks  
       , inserted.entpm_datatype  
       , inserted.entpm_created_by  
       , inserted.entpm_created_dt  
       , inserted.entpm_lst_upd_by  
       , inserted.entpm_lst_upd_dt  
       , inserted.entpm_deleted_ind  
       , 'I'  
  FROM   inserted  
--    
END  
ELSE   
BEGIN--updated  
--  
  INSERT INTO entpm_hst  
  ( entpm_id  
  , entpm_prop_id  
  , entpm_clicm_id  
  , entpm_enttm_id  
  , entpm_excpm_id  
  , entpm_cd  
  , entpm_desc  
  , entpm_cli_yn  
  , entpm_mdty  
  , entpm_rmks  
  , entpm_datatype  
  , entpm_created_by  
  , entpm_created_dt  
  , entpm_lst_upd_by  
  , entpm_lst_upd_dt  
  , entpm_deleted_ind  
  , entpm_action  
  )  
  SELECT inserted.entpm_id  
       , inserted.entpm_prop_id  
       , inserted.entpm_clicm_id  
       , inserted.entpm_enttm_id  
       , inserted.entpm_excpm_id  
       , inserted.entpm_cd  
       , inserted.entpm_desc  
       , inserted.entpm_cli_yn  
       , inserted.entpm_mdty  
       , inserted.entpm_rmks  
       , inserted.entpm_datatype  
       , inserted.entpm_created_by  
       , inserted.entpm_created_dt  
       , inserted.entpm_lst_upd_by  
       , inserted.entpm_lst_upd_dt  
       , inserted.entpm_deleted_ind  
       , 'E'  
  FROM   inserted  
  --  
  IF @l_action = 'D'  
  BEGIN  
  --  
    DELETE entity_property_mstr  
    FROM   entity_property_mstr         entpm  
        ,  inserted                     inserted  
    WHERE  entpm.entpm_id             = inserted.entpm_id  
    AND    inserted.entpm_deleted_ind = 0  
  --  
  END  
--     
END  
-------------trig_entpm-------------

GO
