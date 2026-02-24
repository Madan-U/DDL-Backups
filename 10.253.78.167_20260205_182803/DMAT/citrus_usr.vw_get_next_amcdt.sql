-- Object: VIEW citrus_usr.vw_get_next_amcdt
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------


CREATE view [citrus_usr].[vw_get_next_amcdt]
 
as
Select  dpam_sba_no AS Client_code ,dpam_bbo_code as nise_party_code , brom_desc,
CONVERT(datetime, case when isnull(accp_value,'')  = '' then substring(BOActDt,5,4)+'-'+substring(BOActDt,3,2)+'-'+substring(BOActDt,1,2)+' 00:00:00.000' 
else isnull(accp_value,'') end) [AMC Date]
,citrus_usr.Fn_get_nextamc(convert(datetime,CONVERT(datetime, case when isnull(accp_value,'')  = '' then substring(BOActDt,5,4)+'-'+substring(BOActDt,3,2)+'-'+substring(BOActDt,1,2)+' 00:00:00.000' 
else isnull(accp_value,'') end)),cham_charge_type,cham_bill_interval)[NEXT AMC DT]
From dps8_pc1, dp_Acct_mstr left outer join account_properties on accp_clisba_id = dpam_id and accp_accpm_prop_cd = 'AMC_DT' 
,  client_dp_brkg , brokerage_mstr , charge_mstr ,profile_charges
Where boid = dpam_sba_no and dpam_id = clidb_dpam_id and clidb_brom_id = brom_id 
and cham_slab_no = proc_slab_no and proc_profile_id = clidb_brom_id and proc_profile_id = brom_id 
And getdate() between clidb_eff_from_dt and clidb_eff_to_dt 
And cham_charge_type in ('F','AMCPRO')
and dpam_deleted_ind = '1' and clidb_deleteD_ind = '1' 
and brom_deleted_ind = '1' and cham_deleted_ind = '1'
and proc_deleted_ind = '1'
and dpam_sba_no like '120%'
and dpam_stam_cd = 'ACTIVE'

GO
