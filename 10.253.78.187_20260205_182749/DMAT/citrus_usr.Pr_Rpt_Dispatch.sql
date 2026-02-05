-- Object: PROCEDURE citrus_usr.Pr_Rpt_Dispatch
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--[Pr_Rpt_Dispatch] 'CDSL',3,'May 12 2010','May 14 2010',1,'CONFIRM_RETURN','HO|*~|',''

CREATE PROC [citrus_usr].[Pr_Rpt_Dispatch]    
@pa_dptype varchar(4),    
@pa_excsmid int,    
@pa_fromdate datetime,    
@pa_todate datetime,    
@pa_login_pr_entm_id numeric  ,                      
@pa_select_mode varchar(25),
@pa_login_entm_cd_chain  varchar(8000),
@pa_output varchar(8000) output     
as    
begin    
 declare @@dpmid int    
     
 select @@dpmid = dpm_id from dp_mstr where default_dp = @pa_excsmid and dpm_deleted_ind =1    
    
    
 IF @pa_dptype ='CDSL'    
 BEGIN    
 --
   select dpam.dpam_id,dpam_sba_no
			,Report_name
			,convert(varchar,Dispatch_dt,103) Dispatch_dt 
			,Cof_recv
			,dispatch_mode
			,disp_pod_no
			from dispatch_report_cdsl disrc
			,dp_Acct_mstr dpam
			where disrc.dpam_id = dpam.dpam_id 
			and convert(datetime,Dispatch_dt,103) >= convert(datetime,@pa_fromdate,103) + ' 00:00:00' and convert(datetime,Dispatch_dt,103) <= convert(datetime,@pa_todate,103) + ' 23:59:59'
			and   deleted_ind = 1
			and   Cof_recv = case when @pa_select_mode = 'CONFIRM_RETURN' then 0 when @pa_select_mode = 'DISPATCH_AGAIN' then 2 end 
 --
 END    
 IF @pa_dptype ='NSDL'    
 BEGIN    
 --
    select dpam.dpam_id,dpam_sba_no
			,Report_name
			,convert(varchar,Dispatch_dt,103) Dispatch_dt
			,Cof_recv
			,dispatch_mode
			,disp_pod_no
			from dispatch_report_nsdl disrn
			,dp_Acct_mstr dpam
			where disrn.dpam_id = dpam.dpam_id 
			and convert(datetime,Dispatch_dt,103) >= convert(datetime,@pa_fromdate,103) + ' 00:00:00' and convert(datetime,Dispatch_dt,103) <= convert(datetime,@pa_todate,103) + ' 23:59:59'
			and   deleted_ind = 1
			and   Cof_recv = case when @pa_select_mode = 'CONFIRM_RETURN' then 0 when @pa_select_mode = 'DISPATCH_AGAIN' then 2 end 
 --  
 END    
    
    
    
end

GO
