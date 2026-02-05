-- Object: PROCEDURE citrus_usr.pr_get_transaction_dtls
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--exec pr_get_transaction_dtls 'nov 15 2018','nov 15 2018','','','','','',''
CREATE proc [citrus_usr].[pr_get_transaction_dtls] (@pa_from_date datetime
, @pa_to_date datetime
, @pa_from_boid varchar(100)
, @pa_to_boid varchar(100)
, @pa_isin varchar(1000)
, @pa_crdr varchar(100)
, @pa_trx_type varchar(100)
, @pa_bsda varchar(10))
as
begin 
SELECT cdshm_ben_acct_no boid, ltrim(rtrim(isnull(Name,'') )) + ' ' + ltrim(rtrim(isnull(MiddleName,'') )) +' ' + ltrim(rtrim(isnull(SearchName,'') ))  name , cdshm_tras_dt transdate 
, CDSHM_CDAS_TRAS_TYPE TRANSTYPE
, CDSHM_CDAS_SUB_TRAS_TYPE TRANSSUBTYPE 
, CDSHM_ISIN isin
, ISIN_NAME isinname 
, CDSHM_QTY qty
, case when CDSHM_QTY < 0 then 'DR' else 'CR' end crdr 
, CDSHM_TRATM_CD tranid 
, CDSHM_TRANS_NO tranno 
, CDSHM_SETT_NO setno
, CDSHM_SETT_TYPE  settype
, case when left(CDSHM_COUNTER_DPID ,2)='IN' and len(CDSHM_COUNTER_DPID ) = 16 then  right(CDSHM_COUNTER_DPID ,8) else CDSHM_COUNTER_BOID  end   counterboid
, CDSHM_COUNTER_CMBPID  countercmbp
, case when left(CDSHM_COUNTER_DPID ,2)='IN' then  left(CDSHM_COUNTER_DPID,8) else CDSHM_COUNTER_DPID end counterdp 
, CDSHM_TRG_SETTM_NO countersetmno
, cdshm_internal_trastm
, rate=  (select top 1 CLOPM_CDSL_RT from closing_price_mstr_cdsl where CLOPM_ISIN_CD = CDSHM_ISIN and CLOPM_DT <=CDSHM_TRAS_DT order by CLOPM_DT desc )
, Filler9 bsda 
, isnull(smart_flag ,'N') sms
, PriPhNum mobile 
,cdshm_int_ref_no
,case when CDSHM_QTY < 0 and cdshm_int_ref_no like '%easi%' then 'Upload - EASIEST'
when CDSHM_QTY < 0 and cdshm_int_ref_no not like '%easi%' then 'Upload - CDAS' else cdshm_int_ref_no end    cdshm_int_ref_no
, case when CDSHM_CDAS_TRAS_TYPE in (2,3) and (CDSHM_SETT_NO <> '' or CDSHM_TRG_SETTM_NO <> '')	then 'ON-Market'
when CDSHM_CDAS_TRAS_TYPE in (2,3) and (CDSHM_SETT_NO = '' and CDSHM_TRG_SETTM_NO = '')	then 'Off-Market' 
when CDSHM_CDAS_TRAS_TYPE in (5) then 'Inter-depository'
when CDSHM_CDAS_TRAS_TYPE in (6	) then 'Demat'
when CDSHM_CDAS_TRAS_TYPE in (7	) then 'Remat'
when CDSHM_CDAS_TRAS_TYPE in (8	) then 'Pledge'
when CDSHM_CDAS_TRAS_TYPE in (9	) then 'Unpledge' else cdshm_internal_trastm end  trxdesc 

FROM CDSL_HOLDING_DTLS  
left outer join isin_mstr on ISIN_CD = CDSHM_ISIN  
left outer join dps8_pc1 on CDSHM_BEN_ACCT_NO = boid 
WHERE CDSHM_TRAS_DT BETWEEN @pa_from_date AND @pa_to_date
AND CDSHM_TRATM_CD IN('2246','2277','2201','3102','2270','2220','2262','2251','2202','2205','2280') --'2252'  --,'4456'  '2280', -ADD 2205    
and CDSHM_CDAS_TRAS_TYPE in (2,3,4,5,6,7,8,9)
end

GO
