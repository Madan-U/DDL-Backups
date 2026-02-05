-- Object: PROCEDURE citrus_usr.pr_rpt_freezeUnfreeze
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE procedure [citrus_usr].[pr_rpt_freezeUnfreeze]
(@pa_excsmid numeric
,@pa_frmdt datetime
,@pa_todt datetime
,@pa_type char(1)
,@pa_output varchar(1000) out
)
as
begin
--exec pr_rpt_freezeUnfreeze '3','jan 1 2000','mar 27 2012','A',''
declare @dpm_id varchar(20) 
select @dpm_id = dpm_id from dp_mstr where default_dp = @pa_excsmid and dpm_deleted_ind = 1
print @dpm_id   

select fre_id,fre_dpm_id
,case when fre_action ='F' and fre_deleted_ind =1 then 'Frreze' else 'Unfreeze' end frestatus
,isnull(dpam_sba_no,'') dpam_sba_no
,isnull(fre_isin_cd,'') fre_isin
,isnull(fre_qty,0) qty
 ,convert(varchar(11),fre_exec_dt,103) fre_exec_dt  
,fre_rmks
 ,convert(varchar(11),fre_created_dt,103) fre_created_dt  
,fre_created_by
,fre_lst_upd_by
,convert(varchar(11),fre_lst_upd_dt,103) fre_lst_upd_dt 
 
,case when FRE_FOR = '01' then 'Request by Investor' 
	  when FRE_FOR = '02' then 'Other Reasons' 
	  when FRE_FOR = '03' then 'Request by Statutory Authority' else '' end Fortype 
,case when FRE_REQ_INT_BY = 'D' then 'Susp. for Debit Only'
	  when FRE_REQ_INT_BY = 'A' then 'Susp. for All'	
	  when FRE_REQ_INT_BY = 'C' then 'Account Closure' else '' end Initiated_by
from freeze_unfreeze_dtls_mak left outer join dp_acct_mstr on dpam_id = fre_dpam_id
where fre_deleted_ind in (1,5)
and fre_dpm_id = @dpm_id
and fre_exec_dt between @pa_frmdt and @pa_todt
and fre_level like case when  isnull(@pa_type,'') = '' then '%' else @pa_type end 

end

GO
