-- Object: PROCEDURE citrus_usr.PR_CLIENT_BASIC_REPORT
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--exec PR_CLIENT_BASIC_REPORT 3,'jan 01 1997','sep 01 2009','','','1','ho|*~|',''

CREATE procedure [citrus_usr].[PR_CLIENT_BASIC_REPORT]
( @pa_id numeric
, @pa_from_dt datetime
, @pa_to_dt datetime
, @pa_from_acct varchar(1000)
, @pa_to_acct varchar(1000)
, @pa_login_pr_entm_id numeric                        
, @pa_login_entm_cd_chain  varchar(8000) 
, @pa_status_desc varchar(1000)
, @pa_out varchar(8000) out)
as
begin
  


  

  declare @@l_child_entm_id numeric
  , @@dpmid NUMERIC


 select convert(datetime,accp_value,103) accp_value, accp_clisba_id , accp_accpm_prop_cd into #account_properties 
  from account_properties 
  where accp_accpm_prop_cd = 'BILL_START_DT' 
  and isnull(ltrim(rtrim(accp_value)) ,'') not in ( '','//','/  /','/  /')
  and substring(accp_value,1,2) <> '00' 



  
IF @pa_from_acct = ''                      
 BEGIN                      
  SET @pa_from_acct = '0'                      
  SET @pa_to_acct = '99999999999999999'                      
 END                      
 IF @pa_to_acct = ''                      
 BEGIN                  
   SET @pa_to_acct = @pa_from_acct                      
 END       

select @@dpmid = dpm_id from dp_mstr with(nolock) where default_dp = @pa_ID and dpm_deleted_ind =1                      


select @@l_child_entm_id    =  citrus_usr.fn_get_child(@pa_login_pr_entm_id , @pa_login_entm_cd_chain)
 
CREATE TABLE #ACLIST(dpam_id BIGINT,dpam_sba_no VARCHAR(16),dpam_sba_name VARCHAR(150),eff_from DATETIME,eff_to DATETIME)

INSERT INTO #ACLIST SELECT DPAM_ID,dpam_sba_no,dpam_sba_name,EFF_FROM,EFF_TO FROM citrus_usr.fn_acct_list(@@dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id)		


--select * from #ACLIST , #account_properties where accp_clisba_id = dpam_id and accp_value = 'sep 07 2009'
  if @pa_id = 4 
  begin
  
				select DISTINCT  DPAMm.DPAM_CRN_NO 
									, DPAMm.DPAM_SBA_NAME 
									, dpamm.DPAM_CREATED_BY 
									, CONVERT(VARCHAR,dpamm.DPAM_CREATED_DT,103) DPAM_CREATED_DT 
									, dpamm.DPAM_LST_UPD_BY 
									, CONVERT(VARCHAR,dpamm.DPAM_LST_UPD_DT,103) DPAM_LST_UPD_DT 
									, DPAM.DPAM_SBA_NO
									, STAM_DESC
									, ISNULL([citrus_usr].[fn_find_relations_nm](dpamm.DPAM_CRN_NO ,'BR'),'') BRANCH
									, isnull(batchn_created_by   ,'') Batch_generated_by   
		   from dp_acct_mstr_mak dpamm , STATUS_MSTR , dp_acct_mstr dpam left outer join batchno_nsdl_mstr on BATCHN_NO = DPAM_BATCH_NO and BATCHN_TRANS_TYPE  = 'ACCOUNT REGISTRATION'  and batchn_status <> 'C' 
						,  dp_mstr ,#account_properties , #ACLIST account  
				where accp_clisba_id = dpamm.dpam_id and account.dpam_id = dpamm.dpam_id 
				and   dpamm.dpam_dpm_id = dpm_id 
				and    dpamm.dpam_id = dpam.dpam_id
				AND   STAM_CD = dpam.DPAM_STAM_CD
				and  default_dp = dpm_excsm_id 
				and  dpm_excsm_id = @pa_id
				and  isnumeric(DPAMm.dpam_sba_no)=1  
				--and  stam_desc =@pa_status_desc
				and  accp_value between   @pa_from_dt and @pa_to_dt + ' 23:59:00'
				and  dpam.dpam_sba_no >= @pa_from_acct and dpam.dpam_sba_no <=  @pa_to_acct
				and dpamm.dpam_deleted_ind = 1
  
  end 
  else
  begin
    	select DISTINCT  DPAMm.DPAM_CRN_NO 
									, DPAMm.DPAM_SBA_NAME 
									, dpamm.DPAM_CREATED_BY 
									, CONVERT(VARCHAR,dpamm.DPAM_CREATED_DT,103) DPAM_CREATED_DT 
									, dpamm.DPAM_LST_UPD_BY 
									, CONVERT(VARCHAR,dpamm.DPAM_LST_UPD_DT,103) DPAM_LST_UPD_DT 
									, DPAM.DPAM_SBA_NO
									, STAM_DESC
									, ISNULL([citrus_usr].[fn_find_relations_nm](dpamm.DPAM_CRN_NO ,'BR'),'') BRANCH
								 , isnull(batchc_created_by   ,'') Batch_generated_by    
		 
				from dp_acct_mstr_mak dpamm , STATUS_MSTR , dp_acct_mstr dpam  left outer join batchno_cdsl_mstr on BATCHC_NO = DPAM_BATCH_NO and BATCHC_TRANS_TYPE  = 'ACCOUNT REGISTRATION'  and BATCHC_STATUS <> 'C' 
						,  dp_mstr ,#account_properties , #ACLIST account  
				where accp_clisba_id = dpamm.dpam_id and account.dpam_id = dpamm.dpam_id 
				and   dpamm.dpam_dpm_id = dpm_id 
				and    dpamm.dpam_id = dpam.dpam_id
				AND   STAM_CD = dpam.DPAM_STAM_CD
				and  default_dp = dpm_excsm_id 
				and  dpm_excsm_id = @pa_id
				and  isnumeric(DPAMm.dpam_sba_no)=1  
				--and  stam_desc =@pa_status_desc
				and  accp_value between   @pa_from_dt and @pa_to_dt + ' 23:59:00'
				and  dpam.dpam_sba_no >= @pa_from_acct and dpam.dpam_sba_no <=  @pa_to_acct
				and dpamm.dpam_deleted_ind = 1
  end
  
end

GO
