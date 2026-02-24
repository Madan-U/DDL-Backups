-- Object: TRIGGER citrus_usr.trig_accpm
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

-------------trig_accpm-------------  
CREATE TRIGGER trig_accpm  
ON account_property_mstr  
FOR INSERT,UPDATE  
AS  
DECLARE @l_action VARCHAR(20)  
--  
SET @l_action = 'E'  
--  
IF UPDATE(accpm_deleted_ind)  
BEGIN  
--  
  IF EXISTS(SELECT inserted.accpm_id   
            FROM   inserted   
            WHERE  inserted.accpm_deleted_ind  = 0  
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
IF NOT EXISTS(SELECT deleted.accpm_id FROM deleted)   
BEGIN--insert  
--  
  INSERT INTO accpm_hst  
  ( accpm_id  
  , accpm_prop_id  
  , accpm_clicm_id  
  , accpm_enttm_id  
  , accpm_excpm_id  
  , accpm_prop_cd  
  , accpm_prop_desc  
  , accpm_prop_rmks  
  , accpm_mdty  
  , accpm_acct_type  
  , accpm_datatype  
  , accpm_created_by  
  , accpm_created_dt  
  , accpm_lst_upd_by  
  , accpm_lst_upd_dt  
  , accpm_deleted_ind  
  , accpm_action  
  )  
  SELECT inserted.accpm_id  
       , inserted.accpm_prop_id  
       , inserted.accpm_clicm_id  
       , inserted.accpm_enttm_id  
       , inserted.accpm_excpm_id  
       , inserted.accpm_prop_cd  
       , inserted.accpm_prop_desc  
       , inserted.accpm_prop_rmks  
       , inserted.accpm_mdty  
       , inserted.accpm_acct_type  
       , inserted.accpm_datatype  
       , inserted.accpm_created_by  
       , inserted.accpm_created_dt  
       , inserted.accpm_lst_upd_by  
       , inserted.accpm_lst_upd_dt  
       , inserted.accpm_deleted_ind  
       , 'I'  
  FROM   inserted  
--    
END  
ELSE   
BEGIN--updated  
--  
  INSERT INTO accpm_hst  
  ( accpm_id  
  , accpm_prop_id  
  , accpm_clicm_id  
  , accpm_enttm_id  
  , accpm_excpm_id  
  , accpm_prop_cd  
  , accpm_prop_desc  
  , accpm_prop_rmks  
  , accpm_mdty  
  , accpm_acct_type  
  , accpm_datatype  
  , accpm_created_by  
  , accpm_created_dt  
  , accpm_lst_upd_by  
  , accpm_lst_upd_dt  
  , accpm_deleted_ind  
  , accpm_action  
  )  
  SELECT inserted.accpm_id  
       , inserted.accpm_prop_id  
       , inserted.accpm_clicm_id  
       , inserted.accpm_enttm_id  
       , inserted.accpm_excpm_id  
       , inserted.accpm_prop_cd  
       , inserted.accpm_prop_desc  
       , inserted.accpm_prop_rmks  
       , inserted.accpm_mdty  
       , inserted.accpm_acct_type  
       , inserted.accpm_datatype  
       , inserted.accpm_created_by  
       , inserted.accpm_created_dt  
       , inserted.accpm_lst_upd_by  
       , inserted.accpm_lst_upd_dt  
       , inserted.accpm_deleted_ind  
       , 'E'  
 FROM    inserted  
 --  
 IF @l_action = 'D'  
 BEGIN  
 --  
     DELETE account_property_mstr    
     FROM   account_property_mstr        accpm  
          , inserted                     inserted  
     WHERE  accpm.accpm_id             = inserted.accpm_id  
     AND    inserted.accpm_deleted_ind = 0  
 --  
 END  
--     
END  
-------------trig_accpm-------------

GO
