-- Object: PROCEDURE citrus_usr.Pr_dailyholding
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE PROC [citrus_usr].[Pr_dailyholding](
@dpmid int,
@pa_holdingdate datetime,
@pa_fromaccid varchar(16),                                    
@pa_toaccid varchar(16),                                    
@pa_isincd varchar(12),              
@pa_group_cd varchar(10),                     
@pa_login_pr_entm_id numeric,                                      
@pa_child_entm_id  int
) 
AS  
begin
--return 0
set nocount on
set transaction isolation level read uncommitted
		if rtrim(ltrim(@pa_group_cd)) = ''
		begin
				Select dpam_sba_no,dpam_sba_name,d.dpdhmd_dpam_id, d.dpdhmd_benf_acct_typ, d.dpdhmd_isin, DPDHMD_HOLDING_DT=@pa_holdingdate, d.dpdhmd_qty,
				d.DPDHMD_SETT_TYPE,d.DPDHMD_SETT_NO,d.DPDHMD_CC_ID,d.DPDHMD_BLK_LOCK_FLG,d.DPDHMD_BLK_LOCK_CD,d.DPDHMD_REL_DT   
				from DP_DAILY_HLDG_NSDL d with(nolock), (  
				Select dpam_sba_no,dpam_sba_name,dpdhmd_dpam_id, DPDHMD_BENF_CAT,dpdhmd_benf_acct_typ, dpdhmd_isin, DPDHMD_HOLDING_DT = max(DPDHMD_HOLDING_DT)  
				From DP_DAILY_HLDG_NSDL with(nolock),
				citrus_usr.fn_acct_list(@dpmid ,@pa_login_pr_entm_id,@pa_child_entm_id) account      
				Where DPDHMD_HOLDING_DT  <= @pa_holdingdate   
				and  Dpdhmd_benf_acct_typ not in('20','30','40') 
				and dpdhmd_dpam_id = account.dpam_id                                          
				and convert(numeric,account.dpam_sba_no) between convert(numeric,@pa_fromaccid) and convert(numeric,@pa_toaccid)                                     
				and (dpdhmd_holding_dt between eff_from and eff_to)              
				and dpdhmd_ISIN like @pa_isincd + '%'
				group by dpam_sba_no,dpam_sba_name,dpdhmd_dpam_id, DPDHMD_BENF_CAT,dpdhmd_benf_acct_typ, dpdhmd_isin   
				) d1
				Where d.DPDHMD_HOLDING_DT  <= @pa_holdingdate    
				and d.DPDHMD_HOLDING_DT = d1.DPDHMD_HOLDING_DT  
				and d.dpdhmd_dpam_id = d1.dpdhmd_dpam_id   
				and d.DPDHMD_BENF_CAT = d1.DPDHMD_BENF_CAT  
				and d.dpdhmd_benf_acct_typ = d1.dpdhmd_benf_acct_typ  
				and d.dpdhmd_isin = d1.dpdhmd_isin    
				and d.dpdhmd_dpm_id = @dpmid  
				and d.dpdhmd_benf_acct_typ not in('20','30','40')
				union
				Select dpam_sba_no,dpam_sba_name,dpdhmd_dpam_id, DPDHMD_BENF_CAT,dpdhmd_benf_acct_typ, dpdhmd_isin, DPDHMD_HOLDING_DT = @pa_holdingdate,
				DPDHMD_SETT_TYPE,DPDHMD_SETT_NO,DPDHMD_CC_ID,DPDHMD_BLK_LOCK_FLG,DPDHMD_BLK_LOCK_CD,DPDHMD_REL_DT  
				From DP_DAILY_HLDG_NSDL with(nolock)
				, citrus_usr.fn_acct_list(@dpmid ,@pa_login_pr_entm_id,@pa_child_entm_id) account  
				Where 
				dpdhmd_dpam_id = account.dpam_id                                          
				and convert(numeric,account.dpam_sba_no) between convert(numeric,@pa_fromaccid) and convert(numeric,@pa_toaccid)                                     
				and (dpdhmd_holding_dt between eff_from and eff_to)              
				and DPDHMD_HOLDING_DT  = @pa_holdingdate 
				and dpdhmd_benf_acct_typ in('20','30','40') 
				and dpdhmd_ISIN like @pa_isincd + '%'
				and dpdhmd_dpm_id = @dpmid 
		end 
		else
		begin
				Select dpam_sba_no,dpam_sba_name,d.dpdhmd_dpam_id, d.dpdhmd_benf_acct_typ, d.dpdhmd_isin, DPDHMD_HOLDING_DT=@pa_holdingdate, d.dpdhmd_qty,
				d.DPDHMD_SETT_TYPE,d.DPDHMD_SETT_NO,d.DPDHMD_CC_ID,d.DPDHMD_BLK_LOCK_FLG,d.DPDHMD_BLK_LOCK_CD,d.DPDHMD_REL_DT   
				from 
				DP_DAILY_HLDG_NSDL d with(nolock), (  
				Select dpam_sba_no,dpam_sba_name,dpdhmd_dpam_id, DPDHMD_BENF_CAT,dpdhmd_benf_acct_typ, dpdhmd_isin, DPDHMD_HOLDING_DT = max(DPDHMD_HOLDING_DT)  
				From DP_DAILY_HLDG_NSDL with(nolock)
				, citrus_usr.fn_acct_list(@dpmid ,@pa_login_pr_entm_id,@pa_child_entm_id) account      
				,account_group_mapping g with(nolock)
				Where DPDHMD_HOLDING_DT  <= @pa_holdingdate   
				and dpdhmd_benf_acct_typ not in('20','30','40') 
				and dpdhmd_dpam_id = account.dpam_id                                          
				and convert(numeric,account.dpam_sba_no) between convert(numeric,@pa_fromaccid) and convert(numeric,@pa_toaccid)                                     
				and (dpdhmd_holding_dt between eff_from and eff_to)
				and g.dpam_id = dpdhmd_dpam_id              
			    and group_cd =  @pa_group_cd                
				and dpdhmd_ISIN like @pa_isincd + '%'
				group by dpam_sba_no,dpam_sba_name,dpdhmd_dpam_id, DPDHMD_BENF_CAT,dpdhmd_benf_acct_typ, dpdhmd_isin   
				) d1
				Where d.DPDHMD_HOLDING_DT  <= @pa_holdingdate    
				and d.DPDHMD_HOLDING_DT = d1.DPDHMD_HOLDING_DT  
				and d.dpdhmd_dpam_id = d1.dpdhmd_dpam_id   
				and d.DPDHMD_BENF_CAT = d1.DPDHMD_BENF_CAT  
				and d.dpdhmd_benf_acct_typ = d1.dpdhmd_benf_acct_typ  
				and d.dpdhmd_isin = d1.dpdhmd_isin    
				and d.dpdhmd_dpm_id = @dpmid  
				and d.dpdhmd_benf_acct_typ not in('20','30','40')
				union
				Select dpam_sba_no,dpam_sba_name,dpdhmd_dpam_id, DPDHMD_BENF_CAT,dpdhmd_benf_acct_typ, dpdhmd_isin, DPDHMD_HOLDING_DT = @pa_holdingdate,
				DPDHMD_SETT_TYPE,DPDHMD_SETT_NO,DPDHMD_CC_ID,DPDHMD_BLK_LOCK_FLG,DPDHMD_BLK_LOCK_CD,DPDHMD_REL_DT  
				From account_group_mapping g with(nolock),
				DP_DAILY_HLDG_NSDL with(nolock)
				, citrus_usr.fn_acct_list(@dpmid ,@pa_login_pr_entm_id,@pa_child_entm_id) account  
				Where
			    g.dpam_id = dpdhmd_dpam_id              
			    and group_cd =  @pa_group_cd               
 				and dpdhmd_dpam_id = account.dpam_id                                          
				and convert(numeric,account.dpam_sba_no) between convert(numeric,@pa_fromaccid) and convert(numeric,@pa_toaccid)                                     
				and (dpdhmd_holding_dt between eff_from and eff_to)              
				and DPDHMD_HOLDING_DT  = @pa_holdingdate 
				and dpdhmd_benf_acct_typ in('20','30','40') 
				and dpdhmd_ISIN like @pa_isincd + '%'
				and dpdhmd_dpm_id = @dpmid 
		end 
		

end

GO
