-- Object: PROCEDURE citrus_usr.pr_get_relationshio_upd_incr
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE proc [citrus_usr].[pr_get_relationshio_upd_incr]  
as  
begin  

select 
client_code, region,area,branch_cd,sub_broker,baselocation into #tempdata from dbo.VW_CLIENT_DETAILS_ForDp
--where exists (select 1 from entity_relationship with(nolock) where ENTR_SBA = client_code and (ISNULL(entr_re,0)=0 or ISNULL(ENTR_AR,0)=0 or ISNULL(ENTR_BR,0)=0))

create index ix1 on #tempdata(client_code,region,area,branch_cd,sub_broker,baselocation)
 
 
  
update entr set entr_re = entm_id    
from entity_relationship entr with(nolock), #tempdata ,entity_mstr  with(nolock)
where client_code = ENTR_SBA   
and ltrim(rtrim(region )) + '_re' = ENTM_SHORT_NAME   
and ISNULL(entr_re,0) = 0  
  
--select * into #tempdatarelationhip from dbo.VW_CLIENT_DETAILS  
--create clustered index ix_1 on #tempdatarelationhip(CLTDPID,area,region,sub_broker,branch_cd)  
update entr set ENTR_AR = entm_id    
from entity_relationship entr with(nolock), #tempdata  ,entity_mstr   with(nolock)
where client_code = ENTR_SBA   
and ltrim(rtrim(area )) + '_ar' = ENTM_SHORT_NAME   
and ISNULL(ENTR_AR,0) = 0  
  
update entr set ENTR_BR = entm_id    
from entity_relationship entr with(nolock), #tempdata  ,entity_mstr   with(nolock)
where client_code = ENTR_SBA   
and ltrim(rtrim(branch_cd )) + '_br' = ENTM_SHORT_NAME   
and ISNULL(ENTR_BR,0) = 0  
  
  
update entr set ENTR_DUMMY4 = entm_id    
from entity_relationship entr with(nolock) , #tempdata  ,entity_mstr   with(nolock)
where client_code = ENTR_SBA   
and ltrim(rtrim(sub_broker )) + '_sb' = ENTM_SHORT_NAME   
and ISNULL(ENTR_DUMMY4,0) = 0  
 
 
 update entr set ENTR_DUMMY5 = entm_id 
from  entity_relationship entr with(nolock) , #tempdata  ,entity_mstr   with(nolock)--, dp_acct_mstr
where client_code = ENTR_SBA   --and dpam_sba_no = entr_sba  and client_code = dpam_sba_no 
and ltrim(rtrim(baselocation ))  = case when entm_name1 =  'CHATTISGARH' then 'CHHATTISGARH'
when entm_name1 =  'UTTARAKHAND' then 'UTTARANCHAL'else entm_name1 end    
and entm_enttm_cd = 'BL'
and ISNULL(ENTR_DUMMY5,0) = 0   
--and dpam_stam_Cd = 'Active' 
and getdate() between entr_from_Dt and isnull (entr_to_dt , 'Dec 31 2900')
and entr_deleted_ind = '1' and entm_deleted_ind = '1' --and dpam_deleted_ind = '1'
  

delete from entity_relationship where ENTR_ACCT_NO = ''  
  
end

GO
