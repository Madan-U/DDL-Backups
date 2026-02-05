-- Object: PROCEDURE citrus_usr.pr_rpt_closure_letter_bk_local_10102013
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

create procedure [citrus_usr].[pr_rpt_closure_letter_bk_local_10102013]      
(@pa_id varchar(5),    
@pa_from_dt datetime,      
@pa_to_dt datetime,      
@pa_acct_no varchar(20),      
@pa_out varchar(8000)  output      
)      
as      
Begin      
    
declare @l_dpam_dpm_id int    
    
select  @l_dpam_dpm_id =  dpm_id from dp_mstr where default_dp = @pa_id    
    
select convert(datetime,accp_value,103) accp_value, accp_clisba_id , accp_accpm_prop_cd into #account_properties_close     
from account_properties where accp_accpm_prop_cd = 'ACC_CLOSE_DT'     
and accp_value not in ('','//','')     
--select * from #account_properties_close where accp_clisba_id =982404    
    
if @pa_id <> '99'    
begin    
    
if @pa_from_dt <> '' and @pa_to_dt <> ''     
begin     
 select accp_value, dpam_id,dpam_sba_no,dpam_sba_name, accp_value close_dt  ,dpm_dpid  
 from dp_acct_mstr,#account_properties_close ,dp_mstr    
 --where accp_value between   REPLACE(CONVERT(VARCHAR(11), @pa_from_dt, 106), ' ', '-') and REPLACE(CONVERT(VARCHAR(11), @pa_to_dt, 106), ' ', '-')  + ' 23:59:59'      
 where     
 --accp_value between    @pa_from_dt and  @pa_to_dt      
  dpam_deleted_ind = 1      
 and accp_clisba_id = dpam_id    
  
and dpm_id = dpam_dpm_id   
and dpam_excsm_id = dpm_excsm_id   
  and dpam_sba_no like case when @pa_acct_no <> ''  then @pa_acct_no + '%' else '%' end       
 AND   accp_value >= @pa_from_dt and  accp_value <= @pa_to_dt    
 and dpam_dpm_id = @l_dpam_dpm_id    
 --and dpam_stam_cd = '05'    
end    
else    
if @pa_from_dt = '' and @pa_to_dt = ''  and @pa_acct_no <> ''    
begin    
 select accp_value, dpam_id,dpam_sba_no,dpam_sba_name, accp_value close_dt,dpm_dpid    
 from dp_acct_mstr,#account_properties_close  ,dp_mstr   
 --where accp_value between   REPLACE(CONVERT(VARCHAR(11), @pa_from_dt, 106), ' ', '-') and REPLACE(CONVERT(VARCHAR(11), @pa_to_dt, 106), ' ', '-')  + ' 23:59:59'      
 where     
 --accp_value between    @pa_from_dt and  @pa_to_dt      
  dpam_deleted_ind = 1      
 and accp_clisba_id = dpam_id    
  
and dpm_id = dpam_dpm_id   
and dpam_excsm_id = dpm_excsm_id   
 and dpam_sba_no like case when @pa_acct_no <> ''  then @pa_acct_no + '%' else '%' end        
 and dpam_dpm_id = @l_dpam_dpm_id    
end    
    
end    
else    
begin    
if @pa_from_dt <> '' and @pa_to_dt <> ''     
begin     
 select accp_value, dpam_id,dpam_sba_no,dpam_sba_name, accp_value close_dt  ,dpm_dpid  
 from dp_acct_mstr,#account_properties_close  ,dp_mstr   
 --where accp_value between   REPLACE(CONVERT(VARCHAR(11), @pa_from_dt, 106), ' ', '-') and REPLACE(CONVERT(VARCHAR(11), @pa_to_dt, 106), ' ', '-')  + ' 23:59:59'      
 where --accp_value between  @pa_from_dt and  @pa_to_dt      
    accp_value >= @pa_from_dt and  accp_value <= @pa_to_dt    
 and dpam_deleted_ind = 1      
 and accp_clisba_id = dpam_id    
  
and dpm_id = dpam_dpm_id   
and dpam_excsm_id = dpm_excsm_id   
 --and dpam_sba_no like case when @pa_acct_no <> ''  then @pa_acct_no + '%' else '%' end       
 AND   accp_value >= @pa_from_dt and  accp_value <= @pa_to_dt    
 --and dpam_stam_cd = '05'    
end    
else    
if @pa_from_dt = '' and @pa_to_dt = ''  and @pa_acct_no <> ''    
begin    
 select accp_value, dpam_id,dpam_sba_no,dpam_sba_name, accp_value close_dt  ,dpm_dpid  
 from dp_acct_mstr,#account_properties_close    ,dp_mstr
 --where accp_value between   REPLACE(CONVERT(VARCHAR(11), @pa_from_dt, 106), ' ', '-') and REPLACE(CONVERT(VARCHAR(11), @pa_to_dt, 106), ' ', '-')  + ' 23:59:59'      
 where --accp_value between  @pa_from_dt and  @pa_to_dt      
  --  accp_value >= @pa_from_dt and  accp_value <= @pa_to_dt    
  dpam_deleted_ind = 1      
 and accp_clisba_id = dpam_id    
  
and dpm_id = dpam_dpm_id   
and dpam_excsm_id = dpm_excsm_id   
 --and dpam_sba_no like case when @pa_acct_no <> ''  then @pa_acct_no + '%' else '%' end       
 and dpam_sba_no like case when @pa_acct_no <> ''  then @pa_acct_no + '%' else '%' end      
 --AND   accp_value >= @pa_from_dt and  accp_value <= @pa_to_dt    
 --and dpam_stam_cd = '05'    
end    
end    
--    
end

GO
