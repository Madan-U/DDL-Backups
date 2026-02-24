-- Object: PROCEDURE citrus_usr.pr_mark_missing_slip_toused
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--
--begin tran
--exec pr_mark_missing_slip_toused
--rollback
create  proc [citrus_usr].[pr_mark_missing_slip_toused]
as
begin 

select distinct dptdc_slip_no, dpam_sba_no ,dptdc_request_dt,dptdc_created_dt,dpam_dpm_id,dptdc_created_by  into #tempdata from dp_trx_dtls_cdsl with(nolock)
,dp_acct_mstr with(nolock)
where dpam_id = dptdc_dpam_id 
and not exists 
(select 1 from used_slip with(nolock)
where ltrim(rtrim(uses_slip_no)) = ltrim(rtrim(dptdc_slip_no ))
and USES_DPAM_ACCT_NO = dpam_sba_no
)
and dptdc_deleted_ind = 1 
and dpam_deleted_ind = 1

select dpam_dpm_id,dptdc_slip_no, dpam_sba_no ,dptdc_request_dt,max(dptdc_created_dt) dptdc_created_dt
,max(dptdc_created_by )dptdc_created_by   into #tempdata_final from #tempdata
group by dpam_dpm_id,dptdc_slip_no, dpam_sba_no ,dptdc_request_dt

select identity(numeric,1,1) id , * into #tmp_usedslip from #tempdata_final 

declare @l_max numeric
set @l_max = 0
select @l_max  = max(uses_id) from used_slip

--insert into used_slip
select id  + @l_max  ,dpam_dpm_id ,dpam_sba_no,dptdc_slip_no ,'1','','U',dptdc_created_by
,dptdc_created_dt,dptdc_created_by,dptdc_created_dt,1,null  
from  #tmp_usedslip 




end

GO
