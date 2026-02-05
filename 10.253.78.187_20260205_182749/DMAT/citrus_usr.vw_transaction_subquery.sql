-- Object: VIEW citrus_usr.vw_transaction_subquery
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------



--select * from vw_transaction_subquery where CLIC_TRANS_DT='Aug 23 2021'
CREATE view [citrus_usr].[vw_transaction_subquery]
as
select CLIC_TRANS_DT,DPAM_BBO_CODE,'' ISIN , '' ScriptCode,CLIC_CHARGE_NAME narration,CLIC_CHARGE_AMT,CLIC_CHARGE_AMT*.18 Gst
,CLIC_CHARGE_AMT+(CLIC_CHARGE_AMT*.18) Totalhead,FINA_ACC_NAME Head,CLIC_DPAM_ID as CDSHM_DPAM_ID,'' cdshm_internal_trastm
from client_charges_cdsl,dp_acct_mstr,FIN_ACCOUNT_MSTR where --CLIC_TRANS_DT='Aug 30 2021'
DPAM_ID=CLIC_DPAM_ID
and CLIC_CHARGE_NAME like '%acma%'
and CLIC_POST_TOACCT=FINA_ACC_ID

union all

SELECT CDSHM_TRAS_DT,DPAM_BBO_CODE,CDSHM_ISIN ISIN , ISIN_NAME SCRIPTCODE,CDSHM_TRATM_DESC NARRATION,CDSHM_CHARGE,CDSHM_CHARGE*.18 GST,
CDSHM_CHARGE+(CDSHM_CHARGE*.18) TOTALHEAD,FINA_ACC_NAME HEAD
,CDSHM_DPAM_ID,case when cdshm_trans_cdas_code='7' then 'PLEDGE' when cdshm_trans_cdas_code='8' then 'UNPLEDGE' else  cdshm_internal_trastm end cdshm_internal_trastm
FROM CDSL_HOLDING_DTLS,DP_ACCT_MSTR,ISIN_MSTR,FIN_ACCOUNT_MSTR WHERE --CDSHM_TRAS_DT='AUG 23 2021' AND
 DPAM_ID=CDSHM_DPAM_ID
AND ISNULL(CDSHM_CHARGE,'0')<>'0'
AND CDSHM_ISIN=ISIN_CD
AND CDSHM_POST_TOACCT=FINA_ACC_ID
--ORDER BY CDSHM_DPAM_ID

union all  -- for one day provdata which erase during next day BOD file upload

SELECT CDSHM_TRAS_DT,DPAM_BBO_CODE,CDSHM_ISIN ISIN , ISIN_NAME SCRIPTCODE,CDSHM_TRATM_DESC NARRATION,CDSHM_CHARGE,CDSHM_CHARGE*.18 GST,
CDSHM_CHARGE+(CDSHM_CHARGE*.18) TOTALHEAD,FINA_ACC_NAME HEAD
,CDSHM_DPAM_ID,case when cdshm_trans_cdas_code='7' then 'PLEDGE' when cdshm_trans_cdas_code='8' then 'UNPLEDGE' else  cdshm_internal_trastm end cdshm_internal_trastm
FROM PROVDATA1DAY_CDSL_HOLDING_DTLS,DP_ACCT_MSTR,ISIN_MSTR,FIN_ACCOUNT_MSTR WHERE --CDSHM_TRAS_DT='AUG 23 2021' AND
 DPAM_ID=CDSHM_DPAM_ID
AND ISNULL(CDSHM_CHARGE,'0')<>'0'
AND CDSHM_ISIN=ISIN_CD
AND CDSHM_POST_TOACCT=FINA_ACC_ID

GO
