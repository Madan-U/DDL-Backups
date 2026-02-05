-- Object: PROCEDURE citrus_usr.pr_fetch_mster_poaid
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--EXEC pr_fetch_mster_poaid '2205680000000089' ,''    
    
CREATE PROCEDURE [citrus_usr].[pr_fetch_mster_poaid](@pa_masterpoa_id varchar(25),@pa_error varchar(100) out)    
AS    
BEGIN    
 IF @pa_masterpoa_id <> ''    
 BEGIN    
   IF EXISTS(SELECT poam_master_id FROM poam pm WHERE poaM_master_id = @pa_masterpoa_id)    
   BEGIN     
    --SELECT @pa_error = dpm_dpid + '*|~*' + poam_name1 + '*|~*' + isnull(poam_name2,'') + '*|~*' + isnull(poam_name3,'') + '*|~*' + isnull(poam_pan_no,'')  FROM poa_mstr,dp_mstr WHERE poam_dpm_id = dpm_id AND  poaM_master_id = @pa_masterpoa_id AND poam_deleted_ind = 1   
    SELECT  @pa_error =  dpm_dpid + '*|~*' + a.DPAM_SBA_NAME + '*|~*' + isnull(poam_name2,'') + '*|~*' + isnull(poam_name3,'') + '*|~*' + ''
  FROM poam,dp_mstr,dp_acct_mstr a  WHERE a.DPAM_SBA_NO = poam_master_id
    and poaM_master_id = @pa_masterpoa_id --AND poam_deleted_ind = 1   
    and a.DPAM_DPM_ID = DPM_ID
   END     
   ELSE    
   BEGIN    
    SELECT @pa_error = 'POA ID DOES NOT EXISTS'    
   END    
 END    
 ELSE    
 BEGIN    
   SELECT @pa_error = 'POA ID DOES NOT EXISTS'    
 END    
  print  @pa_error  
END

GO
