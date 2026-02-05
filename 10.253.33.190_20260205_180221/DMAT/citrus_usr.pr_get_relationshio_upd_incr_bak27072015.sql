-- Object: PROCEDURE citrus_usr.pr_get_relationshio_upd_incr_bak27072015
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

create proc [citrus_usr].[pr_get_relationshio_upd_incr_bak27072015]  
as  
begin   
  
update entr set entr_re = entm_id    
from entity_relationship entr , dbo.VW_CLIENT_DETAILS ,entity_mstr  
where client_code = ENTR_SBA   
and ltrim(rtrim(region )) + '_re' = ENTM_SHORT_NAME   
and ISNULL(entr_re,0) = 0  
  
--select * into #tempdatarelationhip from dbo.VW_CLIENT_DETAILS  
--create clustered index ix_1 on #tempdatarelationhip(CLTDPID,area,region,sub_broker,branch_cd)  
update entr set ENTR_AR = entm_id    
from entity_relationship entr , dbo.VW_CLIENT_DETAILS ,entity_mstr  
where client_code = ENTR_SBA   
and ltrim(rtrim(area )) + '_ar' = ENTM_SHORT_NAME   
and ISNULL(ENTR_AR,0) = 0  
  
update entr set ENTR_BR = entm_id    
from entity_relationship entr , dbo.VW_CLIENT_DETAILS ,entity_mstr  
where client_code = ENTR_SBA   
and ltrim(rtrim(branch_cd )) + '_br' = ENTM_SHORT_NAME   
and ISNULL(ENTR_BR,0) = 0  
  
  
update entr set ENTR_DUMMY4 = entm_id    
from entity_relationship entr , dbo.VW_CLIENT_DETAILS ,entity_mstr  
where client_code = ENTR_SBA   
and ltrim(rtrim(sub_broker )) + '_sb' = ENTM_SHORT_NAME   
and ISNULL(ENTR_DUMMY4,0) = 0  
  
  
end

GO
