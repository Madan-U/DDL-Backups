-- Object: PROCEDURE citrus_usr.PR_INS_UCC_RESPONE
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE [citrus_usr].[PR_INS_UCC_RESPONE]  
( @pa_login_name     VARCHAR(50)  
,@pa_exch  VARCHAR(25)  
,@pa_ref_cur VARCHAR(100) output  
)  
  
AS  
  
BEGIN  
 --  
 IF @pa_exch ='NSE'  
 BEGIN  
 --  
  INSERT INTO  Nse_Ucc_Response  
  (Nseur_Ucc_code  
  ,Nseur_Ucc_name  
  ,Nseur_created_by  
  ,Nseur_created_dt  
  ,Nseur_lst_upd_by  
  ,Nseur_lst_upd_dt  
  ,Nseur_deleted_ind  
  )  
  SELECT   
  TMP_Nseur_Ucc_code  
  ,TMP_Nseur_Ucc_name  
  ,@pa_login_name  
  ,getdate()  
  ,@pa_login_name  
  ,getdate()  
  ,1  
  FROM tmp_nse_Ucc_Response  
  WHERE TMP_Nseur_Status = 'S'  
  AND NOT EXISTS(SELECT Nseur_Ucc_code FROM Nse_Ucc_Response WHERE Nseur_Ucc_code = TMP_Nseur_Ucc_code)  
    
    
  UPDATE clim  
  SET    clim_stam_cd = 'ACTIVE'  
  FROM   client_mstr    clim  
        ,client_accounts  clia  
        ,tmp_nse_Ucc_Response nseur  
  WHERE  clia.clia_crn_no  = clim.clim_crn_no  
  AND    clia.clia_acct_no = nseur.TMP_Nseur_Ucc_code  
    
    
    
  UPDATE clisba  
  SET    clisba_access2 = stam_id  
  FROM   client_sub_accts clisba  
        ,tmp_nse_Ucc_Response  
        ,excsm_prod_mstr excpm  
        ,exch_seg_mstr   excsm  
        ,status_mstr     stam  
  WHERE  clisba_acct_no = TMP_Nseur_Ucc_code  
  AND    clisba_excpm_id = excpm.excpm_id  
  AND    excsm.excsm_id = excpm.excpm_excsm_id  
  AND    excsm.excsm_exch_cd = 'NSE'  
  AND    stam.stam_cd = 'ACTIVE'  
   
    
     
    
    
    
   
  select TMP_Nseur_Ucc_code ucccode ,TMP_Nseur_Ucc_name uccname from tmp_nse_Ucc_Response where TMP_Nseur_Status = 'F'  
 --  
 END  
else IF LEFT(@pa_exch,3) ='SLB'  
 BEGIN  
 --  
  INSERT INTO  slb_Ucc_Response  
  (slb_Ucc_code  
  ,slb_Ucc_name  
  ,slb_created_by  
  ,slb_created_dt  
  ,slb_lst_upd_by  
  ,slb_lst_upd_dt  
  ,slb_deleted_ind  
  )  
  SELECT   TMP_SLB_UCC_CODE
  ,TMP_SLB_UCC_NAME
  ,@pa_login_name  
  ,getdate()  
  ,@pa_login_name  
  ,getdate()  
  ,1  
  FROM tmp_slb_Ucc_Response  
  WHERE TMP_SLB_STATUS = 'S'  
  AND NOT EXISTS(SELECT SLB_UCC_CODE FROM slb_Ucc_Response WHERE SLB_UCC_CODE = TMP_SLB_UCC_CODE)  
    
    
  UPDATE clim  
  SET    clim_stam_cd = 'ACTIVE'  
  FROM   client_mstr    clim  
        ,client_accounts  clia  
        ,tmp_slb_Ucc_Response slb  
  WHERE  clia.clia_crn_no  = clim.clim_crn_no  
  AND    clia.clia_acct_no = slb.TMP_SLB_UCC_CODE  
    
    
    
  UPDATE clisba  
  SET    clisba_access2 = stam_id  
  FROM   client_sub_accts clisba  
        ,tmp_slb_Ucc_Response   slb
        ,excsm_prod_mstr excpm  
        ,exch_seg_mstr   excsm  
        ,status_mstr     stam  
  WHERE  clisba_acct_no = slb.TMP_SLB_UCC_CODE  
  AND    clisba_excpm_id = excpm.excpm_id  
  AND    excsm.excsm_id = excpm.excpm_excsm_id  
  AND    excsm.excsm_exch_cd = 'NSE'  
  AND    stam.stam_cd = 'ACTIVE'     
   
  Select TMP_SLB_UCC_CODE ucccode ,TMP_SLB_UCC_NAME uccname from tmp_slb_Ucc_Response where TMP_SLB_STATUS = 'F'  
 --  
 END 
 ELSE IF @pa_exch ='BSE'  
 BEGIN  
 --  
   
  INSERT INTO  Bse_Ucc_Response  
  ( Bseur_Ucc_code  
  ,Bseur_Ucc_name  
  ,Bseur_created_by  
  ,Bseur_created_dt  
  ,Bseur_lst_upd_by  
  ,Bseur_lst_upd_dt  
  ,Bseur_deleted_ind  
    
  )  
  SELECT   
  TMP_bseur_Ucc_code  
  ,TMP_bseur_Ucc_name  
  ,@pa_login_name  
  ,getdate()  
  ,@pa_login_name  
  ,getdate()  
  ,1  
  FROM tmp_Bse_Ucc_Response  
  WHERE TMP_Bseur_Status = 'S'  
  AND NOT EXISTS(SELECT Bseur_Ucc_code FROM Bse_Ucc_Response WHERE Bseur_Ucc_code = TMP_bseur_Ucc_code)  
    
    
    
  UPDATE clim  
  SET    clim_stam_cd = 'ACTIVE'  
  FROM   client_mstr    clim  
        ,client_accounts  clia  
        ,tmp_Bse_Ucc_Response bseur  
  WHERE  clia.clia_crn_no  = clim.clim_crn_no  
  AND    clia.clia_acct_no = bseur.TMP_Bseur_Ucc_code  
    
  
  
  UPDATE clisba  
  SET    clisba_access2 = stam_id  
  FROM   client_sub_accts clisba  
        ,tmp_Bse_Ucc_Response  
        ,excsm_prod_mstr excpm  
        ,exch_seg_mstr   excsm  
        ,status_mstr     stam  
  WHERE  clisba_acct_no = TMP_Bseur_Ucc_code  
  AND    clisba_excpm_id = excpm.excpm_id  
  AND    excsm.excsm_id = excpm.excpm_excsm_id  
  AND    excsm.excsm_exch_cd = 'BSE'  
  AND    stam.stam_cd = 'ACTIVE'  
   
    
   
  select TMP_Bseur_Ucc_code ucccode ,TMP_Bseur_Ucc_name uccname from tmp_bse_Ucc_Response where TMP_Bseur_Status = 'F'  
 --  
 END  
--  
END

GO
