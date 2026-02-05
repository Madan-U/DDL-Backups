-- Object: FUNCTION citrus_usr.fn_dailyholding_HO
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE function [citrus_usr].[fn_dailyholding_HO](
@dpmid int,
@pa_holdingdate datetime,
@pa_fromaccid varchar(16),                                    
@pa_toaccid varchar(16),                                    
@pa_isincd varchar(12),              
@pa_group_cd varchar(10)
)  returns @temp  TABLE (dpam_sba_no varchar(8),dpam_sba_name varchar(150),dpdhmd_dpam_id int, dpdhmd_benf_cat varchar(20), dpdhmd_benf_acct_typ varchar(2),dpdhmd_isin varchar(12),dpdhmd_qty numeric(18,3),DPDHMD_SETT_TYPE varchar(6),DPDHMD_SETT_NO varchar(7),DPDHMD_CC_ID varchar(8),DPDHMD_BLK_LOCK_FLG char(1),DPDHMD_BLK_LOCK_CD char(2),DPDHMD_REL_DT datetime  )         
AS  
begin


	IF @pa_fromaccid = ''                                    
	BEGIN                                    
		SET @pa_fromaccid = '0'                                    
		SET @pa_toaccid = '99999999999999999'                                    
	END                                    
	IF @pa_toaccid = ''                                    
	BEGIN                                
		SET @pa_toaccid = @pa_fromaccid                                    
	END          


	       

		if rtrim(ltrim(@pa_group_cd)) = ''
		begin
				insert into @temp
				Select dpam_sba_no,dpam_sba_name,d.dpdhmd_dpam_id,d.dpdhmd_benf_cat,d.dpdhmd_benf_acct_typ, d.dpdhmd_isin,d.dpdhmd_qty,
				d.DPDHMD_SETT_TYPE,d.DPDHMD_SETT_NO,d.DPDHMD_CC_ID,d.DPDHMD_BLK_LOCK_FLG,d.DPDHMD_BLK_LOCK_CD,d.DPDHMD_REL_DT   
				from DP_DAILY_HLDG_NSDL d with(nolock), (  
				Select dpam_sba_no,dpam_sba_name,dpdhmd_dpam_id, DPDHMD_BENF_CAT,dpdhmd_benf_acct_typ, dpdhmd_isin, DPDHMD_HOLDING_DT = max(DPDHMD_HOLDING_DT)
				,DPDHMD_BLK_LOCK_FLG,DPDHMD_BLK_LOCK_CD,DPDHMD_REL_DT           
				From DP_DAILY_HLDG_NSDL with(nolock),
				dp_acct_mstr account      
				Where 
				dpdhmd_dpam_id = account.dpam_id                                          
				and DPDHMD_HOLDING_DT  <= @pa_holdingdate   
				and  Dpdhmd_benf_acct_typ not in('20','30','40') 
				and dpdhmd_ISIN like @pa_isincd + '%'
				group by dpam_sba_no,dpam_sba_name,dpdhmd_dpam_id, DPDHMD_BENF_CAT,dpdhmd_benf_acct_typ, dpdhmd_isin
				,DPDHMD_BLK_LOCK_FLG,DPDHMD_BLK_LOCK_CD,DPDHMD_REL_DT            
				) d1
				Where d.DPDHMD_HOLDING_DT  <= @pa_holdingdate    
				and d.DPDHMD_HOLDING_DT = d1.DPDHMD_HOLDING_DT  
				and d.dpdhmd_dpam_id = d1.dpdhmd_dpam_id   
				and d.DPDHMD_BENF_CAT = d1.DPDHMD_BENF_CAT  
				and d.dpdhmd_benf_acct_typ = d1.dpdhmd_benf_acct_typ  
				and d.dpdhmd_isin = d1.dpdhmd_isin    
				and d.DPDHMD_BLK_LOCK_FLG = d1.DPDHMD_BLK_LOCK_FLG      
				and d.DPDHMD_BLK_LOCK_CD = d1.DPDHMD_BLK_LOCK_CD
				and d.DPDHMD_REL_DT = d1.DPDHMD_REL_DT
				and d.dpdhmd_dpm_id = @dpmid  
				and d.dpdhmd_benf_acct_typ not in('20','30','40')
				
				insert into @temp
				Select dpam_sba_no,dpam_sba_name,dpdhmd_dpam_id, DPDHMD_BENF_CAT,dpdhmd_benf_acct_typ, dpdhmd_isin,dpdhmd_qty, 
				DPDHMD_SETT_TYPE,DPDHMD_SETT_NO,DPDHMD_CC_ID,DPDHMD_BLK_LOCK_FLG,DPDHMD_BLK_LOCK_CD,DPDHMD_REL_DT  
				From DP_DAILY_HLDG_NSDL with(nolock)
				, dp_acct_mstr account 
				Where 
				dpdhmd_dpam_id = account.dpam_id                                          
				and DPDHMD_HOLDING_DT  = @pa_holdingdate 
				and dpdhmd_benf_acct_typ in('20','30','40') 
				and dpdhmd_ISIN like @pa_isincd + '%'
				and dpdhmd_dpm_id = @dpmid 
		end 
		else
		begin
				insert into @temp
				Select dpam_sba_no,dpam_sba_name,d.dpdhmd_dpam_id,d.DPDHMD_BENF_CAT, d.dpdhmd_benf_acct_typ, d.dpdhmd_isin, d.dpdhmd_qty,
				d.DPDHMD_SETT_TYPE,d.DPDHMD_SETT_NO,d.DPDHMD_CC_ID,d.DPDHMD_BLK_LOCK_FLG,d.DPDHMD_BLK_LOCK_CD,d.DPDHMD_REL_DT   
				from 
				DP_DAILY_HLDG_NSDL d with(nolock), (  
				Select dpam_sba_no,dpam_sba_name,dpdhmd_dpam_id, DPDHMD_BENF_CAT,dpdhmd_benf_acct_typ, dpdhmd_isin, DPDHMD_HOLDING_DT = max(DPDHMD_HOLDING_DT)  
				,DPDHMD_BLK_LOCK_FLG,DPDHMD_BLK_LOCK_CD,DPDHMD_REL_DT            
				From DP_DAILY_HLDG_NSDL with(nolock)
				, dp_acct_mstr account      
				,account_group_mapping g with(nolock)
				Where dpdhmd_dpam_id = account.dpam_id                                          
				and DPDHMD_HOLDING_DT  <= @pa_holdingdate   
				and dpdhmd_benf_acct_typ not in('20','30','40') 
				and g.dpam_id = dpdhmd_dpam_id              
			    and group_cd =  @pa_group_cd                
				and dpdhmd_ISIN like @pa_isincd + '%'
				group by dpam_sba_no,dpam_sba_name,dpdhmd_dpam_id, DPDHMD_BENF_CAT,dpdhmd_benf_acct_typ, dpdhmd_isin   
				,DPDHMD_BLK_LOCK_FLG,DPDHMD_BLK_LOCK_CD,DPDHMD_REL_DT            
				) d1
				Where d.DPDHMD_HOLDING_DT  <= @pa_holdingdate    
				and d.DPDHMD_HOLDING_DT = d1.DPDHMD_HOLDING_DT  
				and d.dpdhmd_dpam_id = d1.dpdhmd_dpam_id   
				and d.DPDHMD_BENF_CAT = d1.DPDHMD_BENF_CAT  
				and d.dpdhmd_benf_acct_typ = d1.dpdhmd_benf_acct_typ  
				and d.dpdhmd_isin = d1.dpdhmd_isin    
				and d.DPDHMD_BLK_LOCK_FLG = d1.DPDHMD_BLK_LOCK_FLG      
				and d.DPDHMD_BLK_LOCK_CD = d1.DPDHMD_BLK_LOCK_CD
				and d.DPDHMD_REL_DT = d1.DPDHMD_REL_DT
				and d.dpdhmd_dpm_id = @dpmid  
				and d.dpdhmd_benf_acct_typ not in('20','30','40')
				
				insert into @temp
				Select dpam_sba_no,dpam_sba_name,dpdhmd_dpam_id, DPDHMD_BENF_CAT,dpdhmd_benf_acct_typ, dpdhmd_isin,dpdhmd_qty,
				DPDHMD_SETT_TYPE,DPDHMD_SETT_NO,DPDHMD_CC_ID,DPDHMD_BLK_LOCK_FLG,DPDHMD_BLK_LOCK_CD,DPDHMD_REL_DT  
				From account_group_mapping g with(nolock),
				DP_DAILY_HLDG_NSDL with(nolock)
				,  dp_acct_mstr account      
				Where
			    g.dpam_id = dpdhmd_dpam_id              
			    and group_cd =  @pa_group_cd               
 				and dpdhmd_dpam_id = account.dpam_id                                          
				and DPDHMD_HOLDING_DT  = @pa_holdingdate 
				and dpdhmd_benf_acct_typ in('20','30','40') 
				and dpdhmd_ISIN like @pa_isincd + '%'
				and dpdhmd_dpm_id = @dpmid 
		end 

		delete from @temp where dpdhmd_qty = 0

	return
end

GO
