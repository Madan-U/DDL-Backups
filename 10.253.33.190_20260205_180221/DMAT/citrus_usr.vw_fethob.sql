-- Object: VIEW citrus_usr.vw_fethob
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE view [citrus_usr].[vw_fethob]
as
select CDSHM_DPM_ID v_CDSHM_DPM_ID 
,CDSHM_DPAM_ID  v_CDSHM_DPAM_ID
,CDSHM_TRAS_DT v_CDSHM_TRAS_DT
,CDSHM_ISIN v_CDSHM_ISIN
,cdshm_qty v_cdshm_qty
,isnull((select sum(cdshm_qty) 
	from cdsl_holding_dtls a 
	where  a.cdshm_ben_acct_no = b.cdshm_ben_acct_no 
	and a.cdshm_isin = b.cdshm_isin
	and a.cdshm_tras_dt <= b.cdshm_tras_dt
	and a.cdshm_id < b.cdshm_id 
	and cdshm_tratm_cd in ('2246','2277')),0) + isnull((select dphmcd_free_qty 
											  from vw_fetchclientholding 
											  where dphmcd_dpam_id = cdshm_dpam_id 
											  and dphmcd_dpm_id = cdshm_dpm_id
											  and dphmcd_isin = cdshm_isin 
										      and dphmcd_holding_dt ='mar 31 2011'),0) v_cdshm_opn_bal
,cdshm_id v_cdshm_id 
, 0 dphmcd_free_qty
, 0 dphmcd_holding_dt
from cdsl_holding_dtls b --, vw_fetchclientholding
--where cdshm_dpam_id = dphmcd_dpam_id 
--and cdshm_isin      = dphmcd_isin
--and cdshm_tras_dt - 1   = dphmcd_holding_dt
where cdshm_tratm_cd in ('2246','2277')

GO
