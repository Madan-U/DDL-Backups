-- Object: PROCEDURE citrus_usr.pr_insert_missing_slip
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------


CREATE proc [citrus_usr].[pr_insert_missing_slip](@pa_from_dt datetime,@pa_to_dt datetime)
as
begin 
--DI0010008802

select distinct dpam_dpm_id  
, dpam_sba_no
,  dptd_slip_no
, TRASTM_CD 
, SLIIM_SERIES_TYPE
,'U' flg into #usedmissed from 
(
select distinct dpam_dpm_id  
, dpam_sba_no
, replace(dptdc_slip_no,SLIIM_SERIES_TYPE,'') dptd_slip_no
, TRASTM_CD 
, SLIIM_SERIES_TYPE
,'U' flg -- into #usedmissed 
from dp_trx_dtls_cdsl 
,dp_acct_mstr 
, slip_issue_mstr 
left outer join transaction_sub_type_mstr 
on SLIIM_TRATM_ID = TRASTM_ID
where isnumeric(replace(dptdc_slip_no,SLIIM_SERIES_TYPE,'')) = 1 
and dptdc_dpam_id = dpam_id 
and dpam_sba_no = SLIIM_DPAM_ACCT_NO and dptdc_created_by <> dpam_sba_no 
and  replace(dptdc_slip_no,SLIIM_SERIES_TYPE,'') between SLIIM_SLIP_NO_FR and SLIIM_SLIP_NO_TO
--and isnull(DPTDc_BROKERBATCH_NO,'') = ''
and not exists (select 1 from used_slip where ltrim(rtrim(USES_SERIES_TYPE)) + ltrim(rtrim(USES_SLIP_NO)) 
= dptdc_slip_no and dpam_sba_no = USES_DPAM_ACCT_NO )
and DPTDc_REQUEST_DT between convert(datetime,@pa_from_dt,103)
  and convert(datetime,@pa_to_dt,103)
union

select distinct dpam_dpm_id  
, dppd_master_id
, replace(dptdc_slip_no,SLIIM_SERIES_TYPE,'') dptd_slip_no
, TRASTM_CD 
, SLIIM_SERIES_TYPE
,'U' flg 
from dp_trx_dtls_cdsl 
,dp_acct_mstr 
, slip_issue_mstr_poa
left outer join transaction_sub_type_mstr 
on SLIIM_TRATM_ID = TRASTM_ID ,DP_POA_DTLS
where isnumeric(replace(dptdc_slip_no,SLIIM_SERIES_TYPE,'')) = 1 
and dptdc_dpam_id = dpam_id and dptdc_created_by <> dpam_sba_no 
and dppd_master_id = SLIIM_DPAM_ACCT_NO and DPPD_DELETED_IND=1 and DPPD_DPAM_ID=dpam_id
and  replace(dptdc_slip_no,SLIIM_SERIES_TYPE,'') between SLIIM_SLIP_NO_FR and SLIIM_SLIP_NO_TO
--and isnull(DPTDc_BROKERBATCH_NO,'') = ''
and not exists (select 1 from used_slip where ltrim(rtrim(USES_SERIES_TYPE)) + ltrim(rtrim(USES_SLIP_NO)) 
= dptdc_slip_no and dppd_master_id = USES_DPAM_ACCT_NO )
and DPTDc_REQUEST_DT between convert(datetime,@pa_from_dt,103)
  and convert(datetime,@pa_to_dt,103)
)
U

select IDENTITy(numeric,1,1) id, *  into #usedmissed_main 
from #usedmissed

declare @l_max_uses_id numeric
select @l_max_uses_id  = max(uses_id) from used_slip 
insert into used_slip
select @l_max_uses_id   +  id , dpam_dpm_id,dpam_sba_no , dptd_slip_no,TRASTM_CD,SLIIM_SERIES_TYPE,flg , 'TMIG',GETDATE(),'TMIG',GETDATE(),1,''
from #usedmissed_main


end

GO
