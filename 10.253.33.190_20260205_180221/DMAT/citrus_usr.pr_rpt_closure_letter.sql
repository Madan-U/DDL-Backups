-- Object: PROCEDURE citrus_usr.pr_rpt_closure_letter
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------


  
CREATE procedure [citrus_usr].[pr_rpt_closure_letter]      
(@pa_id varchar(5),    
@pa_from_dt datetime,      
@pa_to_dt datetime,      
@pa_acct_no varchar(20),      
@pa_out varchar(8000)  output      
)      
as      
Begin      

--select top 2 * from bk_closur_14oct2013 
--return     
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
 select   accp_value, dpam_id,dpam_sba_no,dpam_sba_name, accp_value close_dt  ,dpm_dpid  ,DPAM_BBO_CODE
 --into tmpclosing
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
and dpam_stam_cd = '05'    
end    
else    
if @pa_from_dt = '' and @pa_to_dt = ''  and @pa_acct_no <> ''    
begin    
 select  accp_value, dpam_id,dpam_sba_no,dpam_sba_name, accp_value close_dt,dpm_dpid ,DPAM_BBO_CODE   
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
--truncate table tmpclosing
 select accp_value, dpam_id,dpam_sba_no,dpam_sba_name, accp_value close_dt  ,dpm_dpid  ,DPAM_BBO_CODE 
 --into tmpclosing
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
 and dpam_stam_cd = '05'    
end    
else    
if @pa_from_dt = '' and @pa_to_dt = ''  and @pa_acct_no <> ''    
begin    
 select   accp_value, dpam_id,dpam_sba_no,dpam_sba_name, accp_value close_dt  ,dpm_dpid  ,DPAM_BBO_CODE
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
 and dpam_stam_cd = '05'    
end    
end    
    
--truncate table tmp_rpt
--insert into tmp_rpt
--EXEC [PR_RPT_STATEMENT_FOR_TEST02052012_Onetime] 'CDSL',3,@pa_from_dt,@pa_to_dt,'Y','N','0','9999999999999999'    
--,'','','N','N',1,'HO|*~|','','','','Y',''



--declare @p19 varchar(1)
--set @p19=NULL
--exec Pr_rpt_statement_for_test02052012_closing_Onetime @pa_dptype='CDSL',@pa_excsmid=3,@pa_fromdate=@pa_from_dt,@pa_todate=@pa_to_dt 
--,@pa_fromaccid='0',@pa_toaccid='9999999999999999',@pa_bulk_printflag='N',@pa_stopbillclients_flag='N',@pa_isincd=''
--,@pa_group_cd='|*~|N',@pa_transclientsonly='N',@pa_Hldg_Yn='N',@pa_login_pr_entm_id='1',@pa_login_entm_cd_chain='HO|*~|',@pa_settm_type='',
--@pa_settm_no_fr='',@pa_settm_no_to='',@PA_WITHVALUE='Y',@pa_output=@p19 output
--select @p19


end

GO
