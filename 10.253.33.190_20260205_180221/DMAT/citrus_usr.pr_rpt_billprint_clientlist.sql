-- Object: PROCEDURE citrus_usr.pr_rpt_billprint_clientlist
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

create PROCEDURE [citrus_usr].[pr_rpt_billprint_clientlist]    
(    
    @pa_excsmid   int    
   ,@pa_fromdt    datetime    
   ,@pa_todt      datetime  
   ,@pa_dptype    varchar(4)  
   ,@pa_out   varchar(8000) output    
)    
    
As    
    
BEGIN  
print @pa_dptype   
--    
  DECLARE @@dpmid int   
  SELECT @@dpmid = dpm_id FROM dp_mstr WHERE default_dp = @pa_excsmid and default_dp  =  dpm_excsm_id and  dpm_deleted_ind = 1      
if @pa_dptype = 'CDSL' 
BEGIN
print 'cdsl'
      select --dpam_id  DPAMID 
      dpam_sba_no
     , DPAM_SBA_NAME  
	 ,Isnull(citrus_usr.fn_splitval(citrus_usr.fn_addr_value(dpam_crn_no,'COR_ADR1'),4),'') [CITY]  
     ,Isnull(citrus_usr.fn_splitval(citrus_usr.fn_addr_value(dpam_crn_no,'COR_ADR1'),7),'') [PINCODE]  
     from client_charges_cdsl,dp_acct_mstr where 
     CLIC_TRANS_DT between @pa_fromdt and @pa_todt   
     and CLIC_DPM_ID=@@dpmid and dpam_id=clic_dpam_id and dpam_deleted_ind=1
END
ELSE
BEGIN
print 'nsdl'
	select --dpam_id  DPAMID 
      dpam_sba_no
     , DPAM_SBA_NAME  
	 ,Isnull(citrus_usr.fn_splitval(citrus_usr.fn_addr_value(dpam_crn_no,'COR_ADR1'),4),'') [CITY]  
     ,Isnull(citrus_usr.fn_splitval(citrus_usr.fn_addr_value(dpam_crn_no,'COR_ADR1'),7),'') [PINCODE]  
     from client_charges_NSDL,dp_acct_mstr where 
     CLIC_TRANS_DT between @pa_fromdt and @pa_todt   
     and CLIC_DPM_ID=@@dpmid and dpam_id=clic_dpam_id and dpam_deleted_ind=1
END
END

GO
