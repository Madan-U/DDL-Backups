-- Object: PROCEDURE citrus_usr.pr_client_basic_info
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--select [citrus_usr].[fn_ucc_entp](144,'PAN_GIR_NO','')  
--exec pr_client_basic_info 3,'00000523','00000523','',''    
--exec pr_client_basic_info 4,'78754','78754'   
CREATE procedure [citrus_usr].[pr_client_basic_info](@pa_excsm_id numeric  
,@pa_from_no varchar(50)  
,@pa_to_no varchar(50)  
,@pa_login_pr_entm_id numeric
,@pa_login_entm_cd_chain  varchar(8000)   
--,@pa_from_dt datetime  
--,@pa_to_dt datetime  
)    
as    
begin    
    
DECLARE @@DPMID INT                     
SELECT @@DPMID = DPM_ID FROM DP_MSTR WHERE DEFAULT_DP = @pa_excsm_id AND DPM_DELETED_IND =1    
DECLARE @@L_CHILD_ENTM_ID      NUMERIC              
SELECT @@L_CHILD_ENTM_ID    =  CITRUS_USR.FN_GET_CHILD(@PA_LOGIN_PR_ENTM_ID , @PA_LOGIN_ENTM_CD_CHAIN)  
print @@DPMID
print @@L_CHILD_ENTM_ID

declare @l_dpm_dpid varchar(20)    
       ,@l_dpm_id   numeric    
select  @l_dpm_dpid  = dpm_dpid , @l_dpm_id = dpm_id from dp_mstr where dpm_excsm_id = default_dp and dpm_excsm_id = @pa_excsm_id and dpm_deleted_ind = 1    
  
if @pa_from_no <> '' and left(@l_dpm_dpid ,2 ) <> 'IN'    
set @pa_from_no = isnull(ltrim(rtrim(@l_dpm_dpid)),'')+isnull(ltrim(rtrim(@pa_from_no)),'')      
if @pa_to_no <> ''   and left(@l_dpm_dpid ,2 ) <> 'IN'  
set @pa_to_no = isnull(ltrim(rtrim(@l_dpm_dpid)),'')+isnull(ltrim(rtrim(@pa_to_no)),'')      
     
if @pa_from_no = '' and @pa_to_no = ''     
begin    
set @pa_from_no = 0    
set @pa_to_no = '999999999999999'    
end     
    
if @pa_from_no <> '' and @pa_to_no = ''     
set @pa_to_no = @pa_from_no     
    
    
print @pa_to_no     
print @pa_from_no     
    
    
    
    
    
select distinct top 1 dpam.dpam_sba_no   
 ,  dpam.dpam_sba_name   
 ,  pan_gir_no as [Pan No] --entp_value  
 ,  dpam.dpam_acct_no   
 ,  isnull(BBO_CODE,'') as [Client BBO Code]  
 ,  isnull(dphd_sh_fname,'') + '' + isnull(dphd_sh_mname,'') + '' + isnull(dphd_sh_lname,'') as [Second Holder]   
 ,  isnull(family,'') as Family  
 ,  isnull(groupcd,'') as [Group]  
 ,  isnull(br,'') as BRANCH   
 ,  isnull(brom_desc,'') as [Profile]  
 ,  isnull(BILL_START_DT,'') as [Activation Date]  
 ,  isnull(ACC_CLOSE_DT,'') as [Closure Date]  
,isnull(CLIDB_LST_UPD_DT  ,'') CLIDB_LST_UPD_DT  
,clidb_eff_from_dt
from dp_acct_mstr dpam
left outer join dp_holder_dtls   on dphd_dpam_sba_no = dpam.dpam_sba_no and    dphd_deleted_ind = 1  
left outer join (  
     select entr_sba, groupcd=max(case when entm_enttm_cd = 'groupcd' then entm_name1 else '' end),  
      family=max(case when entm_enttm_cd = 'family' then entm_name1 else '' end),  
      br=max(case when entm_enttm_cd = 'br' then entm_name1 else '' end)  
      FROM   entity_mstr      
      ,entity_relationship      
      WHERE (entm_id = entr_ho       
       OR entm_id = entr_re       
       OR entm_id = entr_ar      
       OR entm_id = entr_br      
       OR entm_id = entr_sb      
       OR entm_id = entr_dl      
       OR entm_id = entr_rm      
       OR entm_id = entr_dummy1      
       OR entm_id = entr_dummy2      
       OR entm_id = entr_dummy3      
       OR entm_id = entr_dummy4      
       OR entm_id = entr_dummy5      
       OR entm_id = entr_dummy6      
       OR entm_id = entr_dummy7      
       OR entm_id = entr_dummy8      
       OR entm_id = entr_dummy9      
       OR entm_id = entr_dummy10)      
      and isnumeric(entr_sba) = 1     
      AND entr_sba  between   convert(numeric,@pa_from_no)  and convert(numeric,@pa_to_no )
      AND entm_enttm_cd in ('groupcd','family','br')   
      group by entr_sba) m     
    on (dpam.dpam_sba_no = entr_sba) 
, (select entp_ent_id , pan_gir_no = max(case when entp_entpm_cd = 'PAN_GIR_NO' then entp_value end ) 
	,BBO_CODE  = max(case when entp_entpm_cd = 'BBO_CODE' then entp_value end ) from entity_properties  where entp_deleted_ind =1 
    group by entp_ent_id ) entp
, (select accp_clisba_id , BILL_START_DT = max(case when ACCP_ACCPM_PROP_CD = 'BILL_START_DT' then accp_value end ) 
	,ACC_CLOSE_DT  = max(case when ACCP_ACCPM_PROP_CD = 'ACC_CLOSE_DT' then accp_value end ) from account_properties  where accp_deleted_ind =1 
    group by accp_clisba_id ) accp
left outer join client_dp_brkg  on ACCP_CLISBA_ID = clidb_dpam_id  and    clidb_deleted_ind = 1  
left outer join brokerage_mstr  on clidb_brom_id = brom_id    and    brom_deleted_ind = 1  
	,CITRUS_USR.FN_ACCT_LIST(@@DPMID ,@PA_LOGIN_PR_ENTM_ID,@@L_CHILD_ENTM_ID) ACCOUNT        
where  dpam.dpam_crn_no = entp_ent_id    
and    ACCP_CLISBA_ID = dpam.DPAM_ID   
--and    entp_entpm_cd = 'PAN_GIR_NO'   
and    dpam.dpam_deleted_ind = 1   
and    dpam.dpam_dpm_id = @l_dpm_id     
--and    dpam_sba_no between @pa_from_no and @pa_to_no     
and    isnumeric(dpam.dpam_sba_no) = 1    
and    convert(numeric,dpam.dpam_sba_no) between  convert(numeric,@pa_from_no)  and convert(numeric,@pa_to_no)
AND   dpam.DPAM_ID       = ACCOUNT.DPAM_ID  
--and    dpam_lst_upd_dt between @pa_from_dt and @pa_to_dt    
order by clidb_eff_from_dt desc
end

GO
