-- Object: PROCEDURE citrus_usr.Pr_Rpt_dp_charges
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE [citrus_usr].[Pr_Rpt_dp_charges]

(
@PA_ID INTEGER,
@PA_FROMDT VARCHAR(20),
@PA_TODT VARCHAR(20),
@PA_OUT VARCHAR(8000) OUT
)
As
Begin 
declare @@dpmid int 
 
select @@dpmid = dpm_id from dp_mstr with(nolock) where default_dp = @pa_id and dpm_deleted_ind =1      

SELECT DISTINCT DPAM_SBA_NO,DPAM_SBA_NAME,CDSHM_TRATM_DESC,Convert(varchar(11),CDSHM_TRAS_DT,109)CDSHM_TRAS_DT,CDSHM_ISIN,CDSHM_QTY,CDSHM_TRANS_NO,
Isnull(CDSHM_DP_CHARGE,0) CDSHM_DP_CHARGE
FROM CDSL_HOLDING_DTLS,DP_ACCT_MSTR WHERE CDSHM_DPAM_ID=DPAM_ID
AND CONVERT(DATETIME,CDSHM_TRAS_DT,103) BETWEEN CONVERT(DATETIME,@PA_FROMDT,103) AND  CONVERT(DATETIME,@PA_TODT,103)
and  CDSHM_DPM_ID = @@dpmid
order by DPAM_SBA_NO ,CDSHM_TRAS_DT


End

GO
