-- Object: TRIGGER citrus_usr.trig_dpam
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--ALTER TABLE dp_acct_mstr_hst ADD dpam_subcm_cd varchar(25)  
CREATE TRIGGER trig_dpam    
ON dp_acct_mstr    
FOR INSERT,UPDATE    
AS    
DECLARE @l_action VARCHAR(20)    
--    
IF UPDATE(dpam_deleted_ind)    
BEGIN    
--    
  IF EXISTS(SELECT inserted.dpam_id    
            FROM   inserted    
            WHERE  inserted.dpam_deleted_ind  = 0    
           )    
  BEGIN    
  --    
    SET @l_action = 'D'    
  --    
  END    
--    
END    
--    
IF NOT EXISTS(SELECT deleted.dpam_id FROM deleted)    
BEGIN--insert    
--    
  INSERT INTO dp_acct_mstr_hst    
  (dpam_id    
  ,dpam_crn_no    
  ,dpam_acct_no    
  ,dpam_sba_no    
  ,dpam_excsm_id    
  ,dpam_dpm_id    
  ,dpam_enttm_cd    
  ,dpam_clicm_cd    
  ,dpam_stam_cd    
  ,dpam_created_by    
  ,dpam_created_dt    
  ,dpam_lst_upd_by    
  ,dpam_lst_upd_dt    
  ,dpam_deleted_ind    
  ,dpam_sba_name    
  ,dpam_action   
  ,dpam_subcm_cd  
  )    
  SELECT inserted.dpam_id    
       , inserted.dpam_crn_no    
       , inserted.dpam_acct_no    
       , inserted.dpam_sba_no    
       , inserted.dpam_excsm_id    
       , inserted.dpam_dpm_id    
       , inserted.dpam_enttm_cd    
       , inserted.dpam_clicm_cd    
       , inserted.dpam_stam_cd    
       , inserted.dpam_created_by    
       , inserted.dpam_created_dt    
       , inserted.dpam_lst_upd_by    
       , inserted.dpam_lst_upd_dt    
       , inserted.dpam_deleted_ind    
       , inserted.dpam_sba_name    
       , 'I'    
        , inserted.dpam_subcm_cd    
  FROM   inserted    
--    
END    
ELSE    
BEGIN--updated    
--    
  INSERT INTO dp_acct_mstr_hst    
    (dpam_id    
    ,dpam_crn_no    
    ,dpam_acct_no    
    ,dpam_sba_no    
    ,dpam_excsm_id    
    ,dpam_dpm_id    
    ,dpam_enttm_cd    
    ,dpam_clicm_cd    
    ,dpam_stam_cd    
    ,dpam_created_by    
    ,dpam_created_dt    
    ,dpam_lst_upd_by    
    ,dpam_lst_upd_dt    
    ,dpam_deleted_ind    
    ,dpam_sba_name    
    ,dpam_action   
     ,dpam_subcm_cd   
    )    
    SELECT inserted.dpam_id    
         , inserted.dpam_crn_no    
         , inserted.dpam_acct_no    
         , inserted.dpam_sba_no    
         , inserted.dpam_excsm_id    
         , inserted.dpam_dpm_id    
         , inserted.dpam_enttm_cd    
         , inserted.dpam_clicm_cd    
         , inserted.dpam_stam_cd    
         , inserted.dpam_created_by    
         , inserted.dpam_created_dt    
         , inserted.dpam_lst_upd_by    
         , inserted.dpam_lst_upd_dt    
         , inserted.dpam_deleted_ind    
         , inserted.dpam_sba_name    
         , 'E'    
         , inserted.dpam_subcm_cd    
  FROM   inserted    
  --    
  IF @l_action = 'D'    
  BEGIN    
  --    
    DELETE dpam    
    FROM   dp_acct_mstr                dpam    
        ,  inserted                    inserted    
    WHERE  dpam.dpam_id              = inserted.dpam_id    
    AND    inserted.dpam_deleted_ind = 0    
  --    
  END    
--    
END

GO
