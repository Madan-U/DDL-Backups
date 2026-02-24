-- Object: PROCEDURE citrus_usr.PR_rpt_Trx_Outside_angel_dis
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------


CREATE    PROC [citrus_usr].[PR_rpt_Trx_Outside_angel_dis](@pa_from_dt DATETIME, @pa_to_dt DATETIME    
,@pa_login_name varchar(100)    
)          
AS          
BEGIN  

select   
CONVERT (VARCHAR (11), dptdc_request_dt ,103)[Date] 
,''''+DPAM_SBA_NO  BOID 
,DPAM_SBA_NAME [Client Name]
, dptdc_ISIN	[ISIN]
, 	ISIN_NAME [ISIN NAME]
, ABS(dptdc_qTY )	Quantity
, DPTDC_COUNTER_DP_ID [ Counter DPID]
, 	[Counter DP Name] = (SELECT  DPM_NAME FROM DP_MSTR WHERE DPM_DPID  = LEFT (DPTDC_COUNTER_DP_ID,8))
,  ''''+	DPTDC_COUNTER_DEMAT_ACCT_NO 	[Target CMBP/Client Id]
, DPAM_BBO_CODE 	[Backoffice Code]
,cast ((dptdc_QTY * CLOPM_CDSL_RT*-1) as decimal (18,2))	Valuation	
,''[Sub Code]
from dptdc_mak
LEFT OUTER JOIN CLOSING_PRICE_MSTR_cDSL with (nolock) ON dptdc_ISIN = CLOPM_ISIN_CD 
AND ISNULL(CLOPM_DT,'01/01/1900') = 
( select top 1 CLOPM_DT from CLOSING_PRICE_MSTR_CDSL WHERE CLOPM_ISIN_CD = dptdc_ISIN and CLOPM_DT <= 'Apr 27 2021'
and CLOPM_DELETED_IND = 1  order by CLOPM_DT desc)   
, DP_ACCT_MSTR , ISIN_MSTR
WHERE dptdc_DPAM_ID = DPAM_ID 
AND dptdc_ISIN = ISIN_CD 
AND DPTDC_COUNTER_DP_ID NOT LIKE '12033200%' 
AND dptdC_trastm_cd IN ('ID','BOBO','CMBO','BOCM')
and DPTDC_SETTLEMENT_NO = '' and DPTDC_OTHER_SETTLEMENT_NO = ''
AND dptdc_request_dt = @pa_from_dt
and dptdc_deleted_ind in (1,0,-1)

end

GO
