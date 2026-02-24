-- Object: PROCEDURE citrus_usr.pr_rpt_complience
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE proc [citrus_usr].[pr_rpt_complience]
as
select entm_short_name, entm_name1, sum(isnull(noofslip,'0')) noofslip,sum(isnull(nooftrx  ,'0')) nooftrx 
,sum(isnull(crcount,0)) crcount , sum(isnull(drcount,0)) drcount
from (
select * from (
select entr_sba, entm_name1,entm_short_name from entity_relationship , entity_mstr 
where isnull(entr_br ,0) <>0  
and entr_br = entm_id 
union all 
select entr_sba, entm_name1 , entm_short_name from entity_relationship , entity_mstr 
where isnull(entr_sb ,0) <>0  
and entr_sb = entm_id 
union all 
select entr_sba, entm_name1 , entm_short_name from entity_relationship , entity_mstr 
where isnull(entr_sb ,0) = 0 and isnull(entr_br ,0) = 0    
and entr_sb = entm_id 
) a 
left outer join (select count(distinct dptdc_slip_no) noofslip ,count(dptdc_slip_no) nooftrx ,  dpam_sba_no  
  from dp_trx_dtls_cdsl 
	 , dp_acct_mstr 
  where dpam_id = dptdc_dpam_id 
  and dptdc_request_dt between 'feb 22 2012' and 'feb 22 2012' 
  and dptdc_deleted_ind = 1 
  and dpam_deleted_ind = 1 group by dpam_sba_no ) sliptrx on sliptrx.dpam_sba_no = entr_sba  
left outer join (select sum(case when cdshm_qty > 0 then 1 else 0 end) crcount,  sum(case when cdshm_qty < 0 then 1 else 0 end) drcount ,  cdshm_ben_acct_no  
  from cdsl_holding_dtls 
  where cdshm_tras_dt between 'feb 22 2012' and 'feb 22 2012' 
  and CDSHM_TRATM_CD in ('2246','2277')
  group by cdshm_ben_acct_no ) dbcr
on dbcr.cdshm_ben_acct_no = entr_sba  

left outer join (select count(1) recocount ,  client_id 
from maker_scancopy 
  where recon_flag='Y'
  group by client_id ) recoflag
  on recoflag.client_id = entr_sba  

) main 
group by entm_short_name, entm_name1
having sum(isnull(noofslip,'0')) <> 0 or sum(isnull(nooftrx  ,'0')) <> 0 
or sum(isnull(crcount,0)) <> 0 or sum(isnull(drcount,0)) <> 0 order by 1 

--
--select * from sysobjects where name like '%scan%'
--sp_helptext pr_map_scancopy_reco
--select * from maker_scancopy

GO
