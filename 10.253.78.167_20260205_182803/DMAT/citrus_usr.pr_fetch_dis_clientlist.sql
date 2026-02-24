-- Object: PROCEDURE citrus_usr.pr_fetch_dis_clientlist
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

--exec [citrus_usr].[pr_fetch_dis_clientlist] 'feb 01 2013','feb 28 2013',485767
--select * from dp_mstr where dpm_excsm_id = 41
CREATE  proc [citrus_usr].[pr_fetch_dis_clientlist](@pa_from_date datetime      
,@pa_to_date datetime      
,@pa_dpm_id numeric
)      
AS        
BEGIN        
--        
      

--
--declare @l_entm_chain varchar(8000)      
--,@l_entm_id numeric      
--      
--select @pa_dpm_id = dpm_excsm_id from dp_mstr where dpm_id = @pa_dpm_id
--
--if  (select  count(1) from client_discount_scheme where CLIDS_FROM_DT between @pa_from_date and @pa_to_date      
--and clids_to_dt between @pa_from_date and @pa_to_date      
--and clids_trx_type ='AMC' and clids_dpm_id = @pa_dpm_id       
--and clids_deleted_ind = 1) = 1       
--begin        
--          
-- select  @l_entm_chain = CLIDS_ENTM_CD_CHAIN from client_discount_scheme where CLIDS_FROM_DT between @pa_from_date and @pa_to_date      
-- and clids_to_dt between @pa_from_date and @pa_to_date      
-- and clids_trx_type ='AMC' and clids_dpm_id = @pa_dpm_id       
-- and clids_deleted_ind = 1      
--      
-- select @l_entm_id = entm_id       
-- from entity_mstr       
-- where entm_short_name = citrus_usr.fn_splitval(@l_entm_chain,citrus_usr.ufn_countstring(@l_entm_chain,'|*~|'))      
--
--
--declare @l_from datetime
--,@l_to datetime
--
--select @l_from = CLIDS_FROM_DT , @l_to = CLIDS_TO_DT  from client_discount_scheme where CLIDS_FROM_DT between @pa_from_date and @pa_to_date      
-- and clids_to_dt between @pa_from_date and @pa_to_date      
-- and clids_trx_type ='AMC' and clids_dpm_id = @pa_dpm_id       
-- and clids_deleted_ind = 1   
--
--
--
--declare @l_scheme varchar(500)
--
--select @l_scheme  =  CLIDS_PROFILE_ID from client_discount_scheme 
--where CLIDS_FROM_DT between @pa_from_date and @pa_to_date      
-- and clids_to_dt between @pa_from_date and @pa_to_date      
-- and clids_trx_type ='AMC' and clids_dpm_id = @pa_dpm_id       
-- and clids_deleted_ind = 1      
--      
--      
--    --select * from enttm_entr_mapping
--    
--     
--      
--    --INSERT INTO @l_table 
--     if isnull(@l_scheme,'') = ''
--begin 
--  select  entr_sba from entity_relationship ,dp_acct_mstr
--,(select distinct convert(datetime,accp_value,103) accp_value, accp_clisba_id , accp_accpm_prop_cd 
--from account_properties 
--where accp_accpm_prop_cd = 'BILL_START_DT' 
--and accp_value not in ('','//')  
--) a 
----, client_dp_brkg 
--where entr_sba = dpam_sba_no   
--and accp_clisba_id = dpam_id 
--and (ENTR_HO= @l_entm_id       
-- or ENTR_RE= @l_entm_id       
-- or ENTR_AR= @l_entm_id       
-- or ENTR_BR = @l_entm_id       
-- or ENTR_SB = @l_entm_id       
-- or ENTR_DUMMY1 = @l_entm_id       
-- or ENTR_DUMMY3 = @l_entm_id ) 
--and isdate(accp_value)=1 
----and clidb_dpam_id = dpam_id 
----and case when isnull(@l_scheme ,'')=''  then '' else  convert(varchar,clidb_brom_id ) end = case when isnull(@l_scheme ,'')=''  then ''  else @l_scheme end 
----and @pa_to_date between clidb_eff_from_dt and isnull(clidb_eff_to_dt,'dec 31 2100')         
--and @pa_to_date between ENTR_FROM_DT and isnull(ENTR_TO_DT,'dec 31 2100')         
--and accp_value between @pa_from_date and @pa_to_date    
--and accp_value between @l_from and @l_to
--and dpam_excsm_id   = @pa_dpm_id 
--end 
--else 
--begin
-- select  entr_sba from entity_relationship ,dp_acct_mstr
--,(select distinct convert(datetime,accp_value,103) accp_value, accp_clisba_id , accp_accpm_prop_cd 
--from account_properties 
--where accp_accpm_prop_cd = 'BILL_START_DT' 
--and accp_value not in ('','//')  
--) a 
----, client_dp_brkg 
--where entr_sba = dpam_sba_no   
--and accp_clisba_id = dpam_id 
--and (ENTR_HO= @l_entm_id       
-- or ENTR_RE= @l_entm_id       
-- or ENTR_AR= @l_entm_id       
-- or ENTR_BR = @l_entm_id       
-- or ENTR_SB = @l_entm_id       
-- or ENTR_DUMMY1 = @l_entm_id       
-- or ENTR_DUMMY3 = @l_entm_id ) 
--and isdate(accp_value)=1 
--and case when isnull(@l_scheme ,'')=''  then '' else citrus_usr.fn_get_brom_id(dpam_id,@pa_to_date) end = case when isnull(@l_scheme ,'')=''  then ''  else @l_scheme end 
----and clidb_dpam_id = dpam_id 
----and case when isnull(@l_scheme ,'')=''  then '' else  convert(varchar,clidb_brom_id ) end = case when isnull(@l_scheme ,'')=''  then ''  else @l_scheme end 
----and @pa_to_date between clidb_eff_from_dt and isnull(clidb_eff_to_dt,'dec 31 2100')         
--and @pa_to_date between ENTR_FROM_DT and isnull(ENTR_TO_DT,'dec 31 2100')         
--and accp_value between @pa_from_date and @pa_to_date    
--and accp_value between @l_from and @l_to
--and dpam_excsm_id   = @pa_dpm_id 
--end 
--   
--      
--end       

select @pa_dpm_id = dpm_excsm_id from dp_mstr where dpm_id = @pa_dpm_id


select entr_sba 
,citrus_usr.fn_get_brom_id(dpam_id,convert(varchar(11),@pa_to_date,109)) brom_id, CLIDS_PROFILE_ID disc_brom_id  
into #tempdatafetch from dp_acct_mstr , entity_relationship 
, (select entm_enttm_cd , entm_id , CLIDS_PROFILE_ID , CLIDS_DPM_ID,CLIDS_FROM_DT
,CLIDS_TO_DT
from entity_mstr with (nolock),client_discount_scheme with (nolock)
where entm_short_name = citrus_usr.fn_splitval(CLIDS_ENTM_CD_CHAIN,citrus_usr.ufn_countstring(CLIDS_ENTM_CD_CHAIN,'|*~|'))
and (@pa_to_date between CLIDS_FROM_DT and CLIDS_TO_DT
or @pa_from_date between CLIDS_FROM_DT and CLIDS_TO_DT)
) a
,(

select distinct convert(datetime,accp_value,103) accp_value, accp_clisba_id , accp_accpm_prop_cd 
from account_properties with (nolock)
where accp_accpm_prop_cd = 'BILL_START_DT' 
and accp_value not in ('','//') ) acopn
where dpam_sba_no = entr_sba AND case when entm_enttm_cd ='HO' then entr_ho 
when entm_enttm_cd ='AR' then entr_ar 
when entm_enttm_cd ='re' then entr_re 
when entm_enttm_cd ='br' then entr_br 
when entm_enttm_cd ='ba' then entr_sb
end = entm_id 
--and case when isnull(CLIDS_PROFILE_ID ,'')='0' then '0' else citrus_usr.fn_get_brom_id(dpam_id,convert(varchar(11),@pa_to_date,109)) end = case when isnull(CLIDS_PROFILE_ID ,'')='0' then '0' else CLIDS_PROFILE_ID end 
and acopn.accp_clisba_id = dpam_id 
and accp_value between @pa_from_date and @pa_to_date
and accp_value between CLIDS_FROM_DT and CLIDS_TO_DT
and CLIDS_DPM_ID = dpam_excsm_id 
and dpam_excsm_id = @pa_dpm_id
        
            
        select entr_sba from #tempdatafetch  where case when disc_brom_id = '' then '' else disc_brom_id end 
		=case when disc_brom_id = '' then '' else brom_id end 
        
--        
END

GO
