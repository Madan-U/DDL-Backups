-- Object: PROCEDURE citrus_usr.PR_RPT_DORMANT_CLIENTS_bak_25082015
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

-- PR_RPT_DORMANT_CLIENTS 'nsdl',4,'Dec 05 2008',6,1,'HO|*~|6|*~|',''	
-- PR_RPT_DORMANT_CLIENTS 'cdsl',4,'Dec 05 2008',6,1,'HO|*~|6|*~|',''	
  
create PROCEDURE [citrus_usr].[PR_RPT_DORMANT_CLIENTS_bak_25082015]
(  
@PA_EXCH_Type varchar(20),
@pa_excsmid int,  
@pa_till_dt datetime,  
@pa_periodinmonths int,  
@pa_login_pr_entm_id numeric,                                        
@pa_login_entm_cd_chain  varchar(8000),                                      
@pa_output varchar(8000) output                                        
)  
AS            
BEGIN   
  set nocount on                         
  set transaction isolation level read uncommitted                             
  declare @@dpmid int,  
  @@from_dt datetime  
  
  select @@dpmid = dpm_id from dp_mstr where default_dp = @pa_excsmid and dpm_deleted_ind =1                                      
  declare @@l_child_entm_id      numeric                                        
  select @@l_child_entm_id    =  citrus_usr.fn_get_child(@pa_login_pr_entm_id , @pa_login_entm_cd_chain)                                        
  set @@from_dt = DATEADD(month,(@pa_periodinmonths * -1),@pa_till_dt)                                      
  print(@@l_child_entm_id)
print(@@from_dt)
  CREATE TABLE #ACLIST(dpam_id BIGINT,dpam_sba_no VARCHAR(16),dpam_sba_name VARCHAR(150),eff_from DATETIME,eff_to DATETIME)  
  INSERT INTO #ACLIST SELECT DPAM_ID,dpam_sba_no,dpam_sba_name,EFF_FROM,EFF_TO 
  FROM citrus_usr.fn_acct_list_disdrf (@@dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id)    
  
  print('a')
  /*SELECT dpam_acct_no,dpam_sba_name,last_trn_dt = max(nsdhm_transaction_dt)                
  FROM  #ACLIST WITH(NOLOCK)              
     ,nsdl_holding_dtls WITH(NOLOCK)              
  WHERE dpam_dpm_id  = @@dpmid     
  AND (@pa_till_dt between eff_from and eff_to)                          
  AND nsdhm_transaction_dt <=  @@from_dt  
  AND NOT EXISTS(SELECT nsdhm_dpam_id from nsdl_holding_dtls WITH(NOLOCK)   
  WHERE nsdhm_dpam_id = DPAM_ID AND (nsdhm_transaction_dt BETWEEN @@from_dt and @pa_till_dt))*/

 if @PA_EXCH_Type = 'nsdl'
begin

  SELECT dpam_sba_no,dpam_sba_name,last_trn_dt = max(nsdhm_transaction_dt)                
  FROM  #ACLIST WITH(NOLOCK)              
     ,nsdl_holding_dtls WITH(NOLOCK)              
  WHERE nsdhm_dpm_id  = @@dpmid     
  AND (@pa_till_dt between eff_from and eff_to)                          
  AND nsdhm_transaction_dt <=  @@from_dt  
  AND NOT EXISTS(SELECT nsdhm_dpam_id from nsdl_holding_dtls WITH(NOLOCK)   
  WHERE nsdhm_dpam_id = DPAM_ID AND (nsdhm_transaction_dt BETWEEN @@from_dt and @pa_till_dt))  
  group by dpam_sba_no,dpam_sba_name
END 

ELSE

BEGIN 

SELECT dpam_sba_no,dpam_sba_name,last_trn_dt = max(CDSHM_TRAS_DT)                
  FROM #ACLIST WITH(NOLOCK)  
  , cdsl_holding_dtls WITH(NOLOCK)             
  WHERE cdshm_dpm_id  = @@dpmid
  and cdshm_dpam_id = DPAM_ID     
  AND (@pa_till_dt between eff_from and eff_to)                          
  AND CDSHM_TRAS_DT <=  @@from_dt  
  AND NOT EXISTS(SELECT cdshm_dpam_id from cdsl_holding_dtls WITH(NOLOCK)   
  WHERE cdshm_dpam_id = DPAM_ID AND (CDSHM_TRAS_DT BETWEEN @@from_dt and @pa_till_dt))  
  group by dpam_sba_no,dpam_sba_name

END
end

GO
