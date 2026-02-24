-- Object: VIEW citrus_usr.Vw_sebi_trx_data_Apr2022oct2023
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

create   view   Vw_sebi_trx_data_Apr2022oct2023

as 
 

select  cdshm_ben_AccT_no  [BO ID of Transferror],  
case when CDSHM_COUNTER_BOID  = '' then CDSHM_COUNTER_DPID else CDSHM_COUNTER_BOID end  [BO ID of Transferree], cdshm_isin  ISIN , cdshm_qty 	Qty ,  
 case when CDSHM_TRATM_TYPE_DESC = 'INTDEP-DR' then  citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,	62	,'~') else  citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,	27	,'~') end  [Reason/ Type of off – market transfer] 
,CDSHM_TRATM_TYPE_DESC [trans type]
 ,CDSHM_TRAS_DT [trx date]
 FROM CDSL_HOLDING_DTLS WHERE CDSHM_TRAS_DT BETWEEN 'Apr 01 2022' AND  'Oct 31 2023'
AND CDSHM_TRATM_CD = 2277
AND CDSHM_TRATM_TYPE_DESC IN ('OF-DR', 'INTDEP-DR' )

GO
