-- Object: PROCEDURE citrus_usr.Pr_Rpt_ZeroHolding
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--select * from account_properties
--Pr_Rpt_ZeroHolding 'cdsl',3,'N','',1,'basis point|*~|',''
--Pr_Rpt_ZeroHolding 'CDSL',3,'Y','mar 26 2010','26/03/2010','28/06/2010',1,0,'HO|*~|',''		                

CREATE Proc [citrus_usr].[Pr_Rpt_ZeroHolding]
@pa_dptype varchar(4),                  
@pa_excsmid int,                  
@pa_asondate char(1),                  
@pa_fordate datetime,       
@pa_fromdate varchar(20),       
@pa_todate varchar(20),                  
@pa_login_pr_entm_id numeric,                    
@pa_profile_id varchar(100),                    
@pa_login_entm_cd_chain  varchar(8000),  
                  
@pa_output varchar(8000) output                    
as                        
begin                        
            

set dateformat dmy 
            
declare @@dpmid int,                        
@@tmpholding_dt datetime
select @@dpmid = dpm_id from dp_mstr where default_dp = @pa_excsmid and dpm_deleted_ind =1                        
declare @@l_child_entm_id      numeric                    
select @@l_child_entm_id    =  citrus_usr.fn_get_child(@pa_login_pr_entm_id , @pa_login_entm_cd_chain)                    
CREATE TABLE #ACLIST(dpam_id BIGINT,dpam_sba_no VARCHAR(16),dpam_sba_name VARCHAR(150),eff_from DATETIME,eff_to DATETIME)
                  
                  
                
select accp_value, accp_clisba_id , accp_accpm_prop_cd,accp_deleted_ind into #account_properties from account_properties where accp_accpm_prop_cd = 'BILL_START_DT' --and isdate(accp_value) = 1                      
            
 

         
  IF @pa_dptype = 'NSDL'                        
  BEGIN    
		INSERT INTO #ACLIST SELECT DPAM_ID,dpam_sba_no,dpam_sba_name,EFF_FROM,EFF_TO 
		FROM citrus_usr.fn_acct_list(@@dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id), client_dp_brkg
		where dpam_stam_cd = 'Active' and clidb_dpam_id = dpam_id and case when @pa_profile_id = '0' then '0' else  clidb_brom_id end = case when @pa_profile_id = '0' then '0' else @pa_profile_id end 
                  
     
      IF @pa_asondate = 'Y'                        
      BEGIN                        
        select top 1 @pa_fordate = DPDHM_HOLDING_DT from DP_HLDG_MSTR_NSDL where dpdhm_deleted_ind =1   
    
		select DPAM_SBA_NAME AcctName,DPAM_sba_NO AcctNo,holding_dt=convert(varchar(11),@pa_fordate,109)                        
		from #ACLIST a 
		where not exists(select DPDHM_dpam_id from DP_HLDG_MSTR_NSDL                  
		where DPDHM_dpam_id = a.dpam_id  
		and DPDHM_HOLDING_DT = @pa_fordate 
		and DPDHM_DPM_ID = @@dpmid                        
		AND DPDHM_QTY <> 0
		)
		and (@pa_fordate between eff_from and eff_to)  
		order by DPAM_sba_NO,dpam_sba_name                    
                  
      END                        
      ELSE                        
      BEGIN

		select top 1 @@tmpholding_dt = case when DPDHM_HOLDING_DT > @pa_fordate then @pa_fordate else DPDHM_HOLDING_DT end from DP_HLDG_MSTR_NSDL where dpdhm_deleted_ind =1 


		select DPAM_SBA_NAME AcctName,DPAM_sba_NO AcctNo,holding_dt=convert(varchar(11),@@tmpholding_dt,109)                        
		from #ACLIST a 
		where dpam_id not in(select dpam_id         
		from fn_dailyholding(@@dpmid,@pa_fordate,'','','','',@pa_login_pr_entm_id,@@l_child_entm_id) d                
		where dpdhmd_qty <> 0
		)
		and (@@tmpholding_dt between eff_from and eff_to)  
		order by DPAM_sba_NO,dpam_sba_name                          
      END                        
 END                        
 ELSE                        
 BEGIN                        
                    
  IF @pa_asondate = 'Y'                        
  BEGIN
		select top 1 @pa_fordate = DPHMC_HOLDING_DT from DP_HLDG_MSTR_CDSL where dphmc_deleted_ind =1                         
	    
INSERT INTO #ACLIST 
SELECT DPAM_ID,dpam_sba_no,dpam_sba_name,EFF_FROM,EFF_TO
FROM citrus_usr.fn_acct_list(@@dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id), client_dp_brkg,#account_properties		
where dpam_stam_cd = 'Active' and clidb_dpam_id = dpam_id 
and dpam_id = accp_clisba_id
--and   isdate(accp_value) = 1
and  accp_deleted_ind=1 
AND ACCP_VALUE between convert(datetime ,@pa_fromdate ,103) and convert(datetime,@pa_todate,103)
and case when @pa_profile_id = '0' then '0' 
else  clidb_brom_id end = case when @pa_profile_id = '0' then '0' else @pa_profile_id end 


		select distinct DPAM_SBA_NAME AcctName,DPAM_sba_NO AcctNo,holding_dt=convert(varchar(11),@pa_fordate,103)                        
		from #ACLIST a 
		where not exists(select DPHMC_dpam_id from DP_HLDG_MSTR_CDSL                  
		where DPHMC_dpam_id = a.dpam_id  
		and DPHMC_HOLDING_DT = @pa_fordate 
		and DPHMC_DPM_ID = @@dpmid                        
		AND DPHMC_CURR_QTY <> 0
		)
		and (@pa_fordate between eff_from and eff_to)  
		order by DPAM_sba_NO,dpam_sba_name 
            
  END                        
  ELSE                        
  BEGIN                        

select top 1 @@tmpholding_dt = case when DPHMC_HOLDING_DT > @pa_fordate then @pa_fordate else DPHMC_HOLDING_DT end from DP_HLDG_MSTR_CDSL where dphmc_deleted_ind =1 

INSERT INTO #ACLIST SELECT DPAM_ID,dpam_sba_no,dpam_sba_name,EFF_FROM,EFF_TO 
FROM citrus_usr.fn_acct_list(@@dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id)		, client_dp_brkg,#account_properties		
where dpam_stam_cd = 'Active' 
and clidb_dpam_id = dpam_id 
and dpam_id = accp_clisba_id
--and   isdate(accp_value) = 1
AND ACCP_VALUE between convert(datetime ,@pa_fromdate ,103) and convert(datetime,@pa_todate,103)
and accp_deleted_ind=1
and case when @pa_profile_id = '0' then '0' 
else  clidb_brom_id end = case when @pa_profile_id = '0' then '0' else @pa_profile_id end 


		select distinct DPAM_SBA_NAME AcctName,DPAM_sba_NO AcctNo,holding_dt=convert(varchar(11),@@tmpholding_dt,109) 
		from #ACLIST a 
		where not exists(select DPHMCD_dpam_id from DP_DAILY_HLDG_CDSL 
		where DPHMCD_dpam_id = a.dpam_id  
		and DPHMCD_HOLDING_DT = @pa_fordate 
		and DPHMCD_DPM_ID = @@dpmid                        
		AND DPHMCD_CURR_QTY <> 0
		)
		and (@pa_fordate between eff_from and eff_to)  
		order by DPAM_sba_NO,dpam_sba_name 

  END                        
             
 END                        
 
 

      TRUNCATE TABLE #ACLIST
	  DROP TABLE #ACLIST           
                        
END

GO
