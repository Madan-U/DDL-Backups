-- Object: VIEW citrus_usr.client_dp_scheme_branchwise
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE view [citrus_usr].[client_dp_scheme_branchwise]
as
select  dpam_sba_no , brom_desc , a.entm_name1, replace(replace(entm_short_name ,'_ba',''),'_br','')  short_name
from dp_acct_mstr , client_dp_brkg, brokerage_mstr   , entity_relationship , entity_mstr a 
where clidb_dpam_id = dpam_id   
and clidb_brom_id = brom_id   
and getdate() between clidb_eff_from_dt  
and isnull(clidb_eff_to_dt,'dec 31 2900')
and getdate() between ENTR_FROM_DT and isnull(ENTR_TO_DT,'dec 31 2900')
and (ENTR_BR = a.entm_id )
and entr_sba = dpam_sba_no
union 
select  dpam_sba_no , brom_desc , a.entm_name1, replace(replace(entm_short_name ,'_ba',''),'_br','')  short_name
from dp_acct_mstr , client_dp_brkg, brokerage_mstr   , entity_relationship , entity_mstr a 
where clidb_dpam_id = dpam_id   
and clidb_brom_id = brom_id   
and getdate() between clidb_eff_from_dt  
and isnull(clidb_eff_to_dt,'dec 31 2900')
and getdate() between ENTR_FROM_DT and isnull(ENTR_TO_DT,'dec 31 2900')
and (ENTR_SB = a.entm_id )
and entr_sba = dpam_sba_no

GO
