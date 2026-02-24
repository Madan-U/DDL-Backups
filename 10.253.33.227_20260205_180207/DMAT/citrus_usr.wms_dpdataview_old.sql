-- Object: VIEW citrus_usr.wms_dpdataview_old
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE view [citrus_usr].[wms_dpdataview_old]  
as  
   
select  ISNULL(cdshm_tratm_desc,'') td_narration,  
cdshm_trans_no td_trxno,  
cdshm_tras_dt td_curdate,  
cdshm_ben_acct_no td_ac_code,  
cdshm_isin td_isin_code,  
abs(cdshm_qty) td_qty,  
 CDSHM_COUNTER_BOID td_counterboid,CDSHM_COUNTER_DPID td_counterdpid,  
cdshm_internal_trastm td_description , -- ?  
'' td_ac_type,  
case when cdshm_qty<0 then 'D' else 'C' END td_debit_credit  
from cdsl_holding_dtls   
where cdshm_tratm_cd in('2246','2277','2201','3102','2270','2220','2262','2251','2202','2205') --'2252'  --,'4456'  '2280', -add 2205

GO
