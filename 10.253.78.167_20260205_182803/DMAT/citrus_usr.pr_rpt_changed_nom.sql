-- Object: PROCEDURE citrus_usr.pr_rpt_changed_nom
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

--pr_rpt_changed_nom 4,'apr 01 2008','10000004','10000004',1,'HO|*~|',''        
   
--select * from dp_holder_dtls_hst where DPHD_DPAM_SBA_NO = '10000004'    
--          
--        
CREATE procedure [citrus_usr].[pr_rpt_changed_nom](            
@pa_excsmid int,                  
@pa_date datetime,            
@pa_fromaccountno varchar(50),            
@pa_toaccountno varchar(50),                  
@pa_login_pr_entm_id numeric,                                                        
@pa_login_entm_cd_chain  varchar(8000),                                                      
@pa_output varchar(8000) output                                                        
)                  
AS                            
BEGIN                   
  set nocount on                                         
  set transaction isolation level read uncommitted                                             
  declare @@dphd_dpam_id int,@@dpmid int            
  --                
  select @@dpmid = dpm_id from dp_mstr where default_dp = @pa_excsmid and dpm_deleted_ind =1                                                    
  declare @@l_child_entm_id      numeric                                                      
  select @@l_child_entm_id    =  citrus_usr.fn_get_child(@pa_login_pr_entm_id , @pa_login_entm_cd_chain)            
  --                  
  CREATE TABLE #ACLIST(dpam_id BIGINT,dpam_sba_no VARCHAR(16),dpam_sba_name VARCHAR(150))                
  INSERT INTO #ACLIST SELECT DPAM_ID,dpam_sba_no,dpam_sba_name FROM citrus_usr.fn_acct_list(@@dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id)                  
  --            
  SELECT distinct dphd_dpam_sba_no,DPHD_NOM_FNAME,DPHD_NOM_MNAME,DPHD_NOM_LNAME,DPHD_NOM_FTHNAME,DPHD_NOM_DOB,DPHD_NOM_PAN_NO,DPHD_NOM_GENDER,dphd_lst_upd_dt                        
  FROM  #ACLIST WITH(NOLOCK),               
  dp_holder_dtls_hst WITH(NOLOCK)                               
  WHERE dphd_action = 'I'         
  AND   dphd_dpam_sba_no = dpam_sba_no        
  AND dphd_dpam_id = DPAM_ID        
  AND dpam_sba_no    between isnull(@pa_fromaccountno,'') and isnull(@pa_toaccountno,'')         
  AND isnull(DPHD_NOM_FNAME,'') <> ''     
  group by  dphd_dpam_sba_no,DPHD_NOM_FNAME,DPHD_NOM_MNAME,DPHD_NOM_LNAME,DPHD_NOM_FTHNAME,DPHD_NOM_DOB,DPHD_NOM_PAN_NO,DPHD_NOM_GENDER,dphd_lst_upd_dt    
  having max(dphd_lst_upd_dt) >= @pa_date          
 END

GO
