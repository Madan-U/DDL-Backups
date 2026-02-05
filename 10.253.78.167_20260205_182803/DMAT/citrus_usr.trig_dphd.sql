-- Object: TRIGGER citrus_usr.trig_dphd
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE TRIGGER [citrus_usr].[trig_dphd]    
ON [citrus_usr].[DP_HOLDER_DTLS]    
FOR INSERT,UPDATE    
AS    
DECLARE @l_action VARCHAR(20)    
--    
IF UPDATE(dphd_deleted_ind)    
BEGIN    
--    
  IF EXISTS(SELECT inserted.dphd_dpam_id     
            FROM   inserted     
            WHERE  inserted.dphd_deleted_ind  = 0    
           )    
  BEGIN    
  --    
    SET @l_action = 'D'    
  --      
  END      
--    
END    
--    
IF NOT EXISTS(SELECT deleted.dphd_dpam_id FROM deleted)     
BEGIN--insert    
--    
  INSERT INTO dp_holder_dtls_hst    
  (dphd_dpam_id    
  ,dphd_dpam_sba_no    
  ,dphd_sh_fname    
  ,dphd_sh_mname    
  ,dphd_sh_lname    
  ,dphd_sh_fthname    
  ,dphd_sh_dob    
  ,dphd_sh_pan_no    
  ,dphd_sh_gender    
  ,dphd_th_fname    
  ,dphd_th_mname    
  ,dphd_th_lname    
  ,dphd_th_fthname    
  ,dphd_th_dob    
  ,dphd_th_pan_no    
  ,dphd_th_gender    
  /*,dphd_poa_fname    
  ,dphd_poa_mname    
  ,dphd_poa_lname    
  ,dphd_poa_fthname    
  ,dphd_poa_dob    
  ,dphd_poa_pan_no    
  ,dphd_poa_gender  */  
  ,dphd_nom_fname    
  ,dphd_nom_mname    
  ,dphd_nom_lname    
  ,dphd_nom_fthname    
  ,dphd_nom_dob    
  ,dphd_nom_pan_no    
  ,dphd_nom_gender    
  ,dphd_gau_fname    
  ,dphd_gau_mname    
  ,dphd_gau_lname    
  ,dphd_gau_fthname    
  ,dphd_gau_dob    
  ,dphd_gau_pan_no    
  ,dphd_gau_gender    
  ,dphd_created_by    
  ,dphd_created_dt    
  ,dphd_lst_upd_by    
  ,dphd_lst_upd_dt    
  ,dphd_deleted_ind    
  ,dphd_action    
  ,dphd_fh_fthname   
,NOM_NRN_NO   
  )    
  SELECT inserted.dphd_dpam_id    
       , inserted.dphd_dpam_sba_no    
       , inserted.dphd_sh_fname    
       , inserted.dphd_sh_mname    
       , inserted.dphd_sh_lname    
       , inserted.dphd_sh_fthname    
       , inserted.dphd_sh_dob    
       , inserted.dphd_sh_pan_no    
       , inserted.dphd_sh_gender    
       , inserted.dphd_th_fname    
       , inserted.dphd_th_mname    
       , inserted.dphd_th_lname    
       , inserted.dphd_th_fthname    
       , inserted.dphd_th_dob    
       , inserted.dphd_th_pan_no    
       , inserted.dphd_th_gender    
       /*, inserted.dphd_poa_fname    
       , inserted.dphd_poa_mname    
       , inserted.dphd_poa_lname    
       , inserted.dphd_poa_fthname    
       , inserted.dphd_poa_dob    
       , inserted.dphd_poa_pan_no    
       , inserted.dphd_poa_gender  */  
  
       , inserted.dphd_nom_fname    
       , inserted.dphd_nom_mname    
       , inserted.dphd_nom_lname    
       , inserted.dphd_nom_fthname    
       , inserted.dphd_nom_dob    
       , inserted.dphd_nom_pan_no    
       , inserted.dphd_nom_gender    
       , inserted.dphd_gau_fname    
       , inserted.dphd_gau_mname    
       , inserted.dphd_gau_lname    
       , inserted.dphd_gau_fthname    
       , inserted.dphd_gau_dob    
       , inserted.dphd_gau_pan_no    
       , inserted.dphd_gau_gender    
       , inserted.dphd_created_by    
       , inserted.dphd_created_dt    
       , inserted.dphd_lst_upd_by    
       , inserted.dphd_lst_upd_dt    
       , inserted.dphd_deleted_ind    
       , 'I'    
       , inserted.dphd_fh_fthname    
,inserted.NOM_NRN_NO  
  FROM inserted    
--      
END    
ELSE     
BEGIN--updated    
--    
  INSERT INTO dp_holder_dtls_hst    
    (dphd_dpam_id    
    ,dphd_dpam_sba_no    
    ,dphd_sh_fname    
    ,dphd_sh_mname    
    ,dphd_sh_lname    
    ,dphd_sh_fthname    
    ,dphd_sh_dob    
    ,dphd_sh_pan_no    
    ,dphd_sh_gender    
    ,dphd_th_fname    
    ,dphd_th_mname    
    ,dphd_th_lname    
    ,dphd_th_fthname    
    ,dphd_th_dob    
    ,dphd_th_pan_no    
    ,dphd_th_gender    
    /*,dphd_poa_fname    
    ,dphd_poa_mname    
    ,dphd_poa_lname    
    ,dphd_poa_fthname    
    ,dphd_poa_dob    
    ,dphd_poa_pan_no    
    ,dphd_poa_gender  */  
    ,dphd_nom_fname    
    ,dphd_nom_mname    
    ,dphd_nom_lname    
    ,dphd_nom_fthname    
    ,dphd_nom_dob    
    ,dphd_nom_pan_no    
    ,dphd_nom_gender    
    ,dphd_gau_fname    
    ,dphd_gau_mname    
    ,dphd_gau_lname    
    ,dphd_gau_fthname    
    ,dphd_gau_dob    
    ,dphd_gau_pan_no    
    ,dphd_gau_gender    
    ,dphd_created_by    
    ,dphd_created_dt    
    ,dphd_lst_upd_by    
    ,dphd_lst_upd_dt    
    ,dphd_deleted_ind    
    ,dphd_action    
    ,dphd_fh_fthname  
,NOM_NRN_NO    
    )    
    SELECT inserted.dphd_dpam_id    
         , inserted.dphd_dpam_sba_no    
         , inserted.dphd_sh_fname    
         , inserted.dphd_sh_mname    
         , inserted.dphd_sh_lname    
         , inserted.dphd_sh_fthname    
         , inserted.dphd_sh_dob    
         , inserted.dphd_sh_pan_no    
         , inserted.dphd_sh_gender    
         , inserted.dphd_th_fname    
         , inserted.dphd_th_mname    
         , inserted.dphd_th_lname    
         , inserted.dphd_th_fthname    
         , inserted.dphd_th_dob    
         , inserted.dphd_th_pan_no    
         , inserted.dphd_th_gender    
        /* , inserted.dphd_poa_fname    
         , inserted.dphd_poa_mname    
         , inserted.dphd_poa_lname    
         , inserted.dphd_poa_fthname    
         , inserted.dphd_poa_dob    
         , inserted.dphd_poa_pan_no    
         , inserted.dphd_poa_gender  */  
         , inserted.dphd_nom_fname    
         , inserted.dphd_nom_mname    
         , inserted.dphd_nom_lname    
         , inserted.dphd_nom_fthname    
         , inserted.dphd_nom_dob    
         , inserted.dphd_nom_pan_no    
         , inserted.dphd_nom_gender    
         , inserted.dphd_gau_fname    
         , inserted.dphd_gau_mname    
         , inserted.dphd_gau_lname    
         , inserted.dphd_gau_fthname    
         , inserted.dphd_gau_dob    
         , inserted.dphd_gau_pan_no    
         , inserted.dphd_gau_gender    
         , inserted.dphd_created_by    
         , inserted.dphd_created_dt    
         , inserted.dphd_lst_upd_by    
         , inserted.dphd_lst_upd_dt    
         , inserted.dphd_deleted_ind    
         , 'E'    
         , inserted.dphd_fh_fthname    
,inserted.NOM_NRN_NO  
  FROM inserted    
  --    
  IF @l_action = 'D'    
  BEGIN    
  --    
    DELETE dphd    
    FROM   dphd_hlder_dtls             dphd     
        ,  inserted                    inserted    
    WHERE  dphd.dphd_dpam_id         = inserted.dphd_dpam_id    
    AND    inserted.dphd_deleted_ind = 0    
  --    
  END    
--       
END

GO
