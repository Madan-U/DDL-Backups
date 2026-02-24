-- Object: PROCEDURE citrus_usr.pr_recon_holding_auto
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--select * from #holdingall
--exec pr_recon_holding 3,'sep 30 2010','ALL',''
--exec pr_recon_holding 485031,'may 24 2012','MATCH',''
--exec pr_recon_holding_auto 3,'Jun 30 2016','MISMATCH',''
CREATE proc [citrus_usr].[pr_recon_holding_auto](@pa_excsm_id numeric
, @pa_date datetime
, @pa_flag char(15)
,@pa_ref_cur varchar(8000) output
)
as
begin 

declare @pa_dpm_id numeric
select @pa_dpm_id = dpm_id from dp_mstr where default_dp = dpm_excsm_id and dpm_excsm_id = @pa_excsm_id

/*charged by tushar 28062012*/
--select client,isin,sum(qty) qty  into #asontran from (
--select dpam_sba_no client , dptdc_isin isin , abs(dptdc_qty) qty
--from dp_trx_dtls_cdsl, dp_acct_mstr 
--where convert(varchar(11),dptdc_request_dt,109) = convert(varchar(11),@pa_date,109)
--and DPTDC_DPAM_ID = dpam_id
--and dpam_dpm_id = @pa_dpm_id
--and dpam_deleted_ind = 1
--and dptdc_deleted_ind = 1
--union all 
--select dpam_sba_no client, DEMRM_ISIN isin, abs(DEMRM_QTY) qty
--from demat_request_mstr, dp_acct_mstr 
--where convert(varchar(11),DEMRM_REQUEST_DT,109) = convert(varchar(11),@pa_date,109)
--and DEMRM_DPAM_ID = dpam_id
--and dpam_dpm_id = @pa_dpm_id
--and dpam_deleted_ind = 1
--and demrm_deleted_ind = 1
--union all 
--select dpam_sba_no client, rEMRM_ISIN isin, abs(rEMRM_QTY) qty
--from remat_request_mstr, dp_acct_mstr 
--where convert(varchar(11),rEMRM_REQUEST_DT,109) = convert(varchar(11),@pa_date,109)
--and rEMRM_DPAM_ID = dpam_id
--and dpam_dpm_id = @pa_dpm_id
--and dpam_deleted_ind = 1
--and remrm_deleted_ind = 1
--union all 
--select dpam_sba_no client, PLDTC_ISIN isin, abs(PLDTC_QTY) qty
--from cdsl_pledge_dtls, dp_acct_mstr 
--where convert(varchar(11),PLDTC_REQUEST_DT,109) = convert(varchar(11),@pa_date,109)
--and PLDTC_DPAM_ID = dpam_id
--and dpam_dpm_id = @pa_dpm_id
--and dpam_deleted_ind = 1
--and PLDTC_DELETED_IND = 1 
--) a 
--group by client,isin
/*charged by tushar 28062012*/

select top 0 * into #holdingall from holdingall_structure
declare @l_dt datetime 
Select top 1 @pa_date  = convert(varchar(11),DPHMC_HOLDING_DT)
from dp_hldg_mstr_cdsl with(nolock) order by DPHMC_HOLDING_DT desc

set @l_dt  = dateadd(d,-1,@pa_date)


--Select top 1 @l_dt  = dateadd(d,-1,convert(varchar(11),DPHMC_HOLDING_DT,109))
--from dp_hldg_mstr_cdsl with(nolock) order by DPHMC_HOLDING_DT desc

Truncate table TMP_RECO_MISMATCH

insert into #holdingall
exec [pr_get_holding_fix_latest] @pa_dpm_id,@l_dt,@l_dt,'0','9999999999999999',''    
--
--
--if @pa_dpm_id <> 3 
--begin 
--insert into #holdingall
--exec [pr_get_holding_fix_latest] @pa_dpm_id,@l_dt,@l_dt,'0','9999999999999999',''    
--end 
--else 
--begin
--insert into #holdingall
--select * from holdingall_bak291212 
--end 
--

 

select dpam_sba_no client_hldg,DPHMCD_ISIN isin_hldg,DPHMCD_CURR_QTY qty_hldg 
into #priviousholding_1 from #holdingall,dp_acct_mstr 
where dpam_id = DPHMCD_DPAM_ID 
and dpam_dpm_id = @pa_dpm_id
--and DPHMC_HOLDING_DT = 
--(select top 1 DPHMC_HOLDING_DT from DP_HLDG_MSTR_CDSL
--where DPHMC_HOLDING_DT <  @pa_date order by 1 desc)



INSERT INTO #priviousholding_1
select cdshm_ben_acct_no client, cdshm_isin isin, cdshm_qty qty
from cdsl_holding_dtls
where convert(varchar(11),CDSHM_TRAS_DT,109) = convert(varchar(11),@pa_date,109)
and cdshm_dpm_id = @pa_dpm_id
and CDSHM_TRATM_CD in ('2246','2277')





SELECT client_hldg,isin_hldg,SUM(qty_hldg) qty_hldg INTO #priviousholding FROM #priviousholding_1
GROUP BY client_hldg,isin_hldg

--select * from #priviousholding where isin_hldg = 'INE894F01025' and client_hldg ='1206210000002209'

/*charged by tushar 28062012*/
--update #priviousholding  set qty_hldg  = qty_hldg - qty
--from #priviousholding  ,  #asontran
--where client_hldg = client
--and isin_hldg = isin 
/*charged by tushar 28062012*/


--select DISTINCT dpam_sba_no client_hldg_ason,DPHMCd_ISIN isin_hldg_ason,SUM(DPHMCd_CURR_QTY) qty_hldg_ason 
--into #asonholding from holdingallforview,dp_acct_mstr 
--where dpam_id = DPHMCd_DPAM_ID 
--and dpam_dpm_id = @pa_dpm_id
--and DPHMCd_HOLDING_DT = @pa_date
--GROUP BY dpam_sba_no,DPHMCd_ISIN

select DISTINCT dpam_sba_no client_hldg_ason,DPHMC_ISIN isin_hldg_ason,SUM(DPHMC_CURR_QTY) qty_hldg_ason 
into #asonholding from dp_hldg_mstr_cdsl,dp_acct_mstr 
where dpam_id = DPHMC_DPAM_ID 
and dpam_dpm_id = @pa_dpm_id
and DPHMC_HOLDING_DT = @pa_date

GROUP BY dpam_sba_no,DPHMC_ISIN


--select a.client_hldg,a.isin_hldg , isnull(qty_hldg,0) edmat_hldg 
--,isnull((select isnull(qty_hldg_ason,0) from #asonholding b 
--where client_hldg_ason = a.client_hldg and isin_hldg_ason = a.isin_hldg),0) cdas_hldg


--from #priviousholding a 


select client_hldg=isnull(a.client_hldg,client_hldg_ason),
isin_hldg=isnull(a.isin_hldg,isin_hldg_ason), 
isnull(qty_hldg,0) edmat_hldg, cdas_hldg=isnull(qty_hldg_ason,0) 
into #finalholding  
from #priviousholding a full outer join #asonholding b 
on (client_hldg_ason = a.client_hldg and isin_hldg_ason = a.isin_hldg)



delete from #finalholding where  client_hldg ='1203320009858060' and isin_hldg in ('INF732E01011','INE669C01036')


if @pa_flag ='ALL'
select * from #finalholding  

if @pa_flag ='MATCH'
select * from #finalholding where edmat_hldg = cdas_hldg

if @pa_flag ='MISMATCH'
if exists (select * from #finalholding with(nolock) where edmat_hldg <> cdas_hldg)
begin 
insert into TMP_RECO_MISMATCH
select *,@l_dt from #finalholding with(nolock) where edmat_hldg <> cdas_hldg
end 
select * from #finalholding where edmat_hldg <> cdas_hldg
--
--
--select * from #asontran where isin = 'INE894F01025' and client ='1206210000002209'
--select * from #priviousholding where isin_hldg = 'INE894F01025' and client_hldg ='1206210000002209'
--select * from #asonholding where isin_hldg_ason = 'INE894F01025' and client_hldg_ason ='1206210000002209'






end

GO
