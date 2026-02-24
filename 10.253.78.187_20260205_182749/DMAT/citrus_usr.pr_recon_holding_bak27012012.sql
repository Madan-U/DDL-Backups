-- Object: PROCEDURE citrus_usr.pr_recon_holding_bak27012012
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--exec pr_recon_holding 3,'jan 10 2011','ALL'
--exec pr_recon_holding 3,'jan 10 2011','MATCH'
--exec pr_recon_holding 3,'jan 10 2011','MISMATCH'
create  proc [citrus_usr].[pr_recon_holding_bak27012012](@pa_dpm_id numeric
, @pa_date datetime
, @pa_flag char(15)
)
as
begin 

select client,isin,sum(qty) qty  into #asontran from (
select dpam_sba_no client , dptdc_isin isin , abs(dptdc_qty) qty
from dp_trx_dtls_cdsl, dp_acct_mstr 
where convert(varchar(11),dptdc_request_dt,109) = convert(varchar(11),@pa_date,109)
and DPTDC_DPAM_ID = dpam_id
and dpam_deleted_ind = 1
and dptdc_deleted_ind = 1
union all 
select dpam_sba_no client, DEMRM_ISIN isin, abs(DEMRM_QTY) qty
from demat_request_mstr, dp_acct_mstr 
where convert(varchar(11),DEMRM_REQUEST_DT,109) = convert(varchar(11),@pa_date,109)
and DEMRM_DPAM_ID = dpam_id
and dpam_deleted_ind = 1
and demrm_deleted_ind = 1
union all 
select dpam_sba_no client, rEMRM_ISIN isin, abs(rEMRM_QTY) qty
from remat_request_mstr, dp_acct_mstr 
where convert(varchar(11),rEMRM_REQUEST_DT,109) = convert(varchar(11),@pa_date,109)
and rEMRM_DPAM_ID = dpam_id
and dpam_deleted_ind = 1
and remrm_deleted_ind = 1
union all 
select dpam_sba_no client, PLDTC_ISIN isin, abs(PLDTC_QTY) qty
from cdsl_pledge_dtls, dp_acct_mstr 
where convert(varchar(11),PLDTC_REQUEST_DT,109) = convert(varchar(11),@pa_date,109)
and PLDTC_DPAM_ID = dpam_id
and dpam_deleted_ind = 1
and PLDTC_DELETED_IND = 1 ) a 
group by client,isin




select dpam_sba_no client_hldg,DPHMCD_ISIN isin_hldg,DPHMCD_CURR_QTY qty_hldg 
into #priviousholding from dp_daily_hldg_cdsl,dp_acct_mstr 
where dpam_id = DPHMCD_DPAM_ID 
and DPHMCD_HOLDING_DT = (select top 1 DPHMCD_HOLDING_DT from dp_daily_hldg_cdsl where DPHMCD_HOLDING_DT <  @pa_date order by 1 desc)

select * from #priviousholding where isin_hldg = 'INE696C01021' and client_hldg ='1206210000000051'


update #priviousholding  set qty_hldg  = qty_hldg - qty
from #priviousholding  ,  #asontran
where client_hldg = client
and isin_hldg = isin 



select dpam_sba_no client_hldg_ason,DPHMCD_ISIN isin_hldg_ason,DPHMCD_CURR_QTY qty_hldg_ason 
into #asonholding from dp_daily_hldg_cdsl,dp_acct_mstr 
where dpam_id = DPHMCD_DPAM_ID 
and DPHMCD_HOLDING_DT = @pa_date


select a.client_hldg,a.isin_hldg , isnull(qty_hldg,0) edmat_hldg 
,isnull((select isnull(qty_hldg_ason,0) from #asonholding b where client_hldg_ason = a.client_hldg and isin_hldg_ason = a.isin_hldg),0) cdas_hldg
into #finalholding 
from #priviousholding a 






if @pa_flag ='ALL'
select * from #finalholding  

if @pa_flag ='MATCH'
select * from #finalholding where edmat_hldg = cdas_hldg

if @pa_flag ='MISMATCH'
select * from #finalholding where edmat_hldg <> cdas_hldg
--
--
select * from #asontran where isin = 'INE696C01021' and client ='1206210000000051'
select * from #priviousholding where isin_hldg = 'INE696C01021' and client_hldg ='1206210000000051'
select * from #asonholding where isin_hldg_ason = 'INE696C01021' and client_hldg_ason ='1206210000000051'






end

GO
