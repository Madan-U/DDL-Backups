-- Object: PROCEDURE citrus_usr.Pr_Off_Mkt
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--exec Pr_Off_Mkt 'ho','apr  1 2018','apr 30 2018','1203320000006579'

CREATE procedure Pr_Off_Mkt
(
@pa_login_names varchar(30)
,@pa_from_dt datetime
,@pa_to_dt datetime
,@pa_boid varchar(16)
)
as
begin
Select  cdshm_ben_acct_no +'|'+ convert(varchar(11),CDSHM_TRAS_DT,103) +'|'+ case when CDSHM_TRATM_CD='2246' then 'C' 
else 'D' end  +'|'+ CDSHM_ISIN +'|'+ convert(varchar,CDSHM_QTY) +'|'+ CONVERT(VARCHAR,CLOPM_CDSL_RT) +'|'+  '' +'|'+
 '' +'|' from cdsl_holding_dtls with (nolock) LEFT OUTER JOIN ISIN_MSTR WITH (NOLOCK) ON CDSHM_ISIN = ISIN_CD              
                                 LEFT OUTER JOIN CLOSING_PRICE_MSTR_CDSL WITH (NOLOCK)
                                                         ON CDSHM_ISIN = CLOPM_ISIN_CD AND ISNULL(CLOPM_DT,'01/01/1900') 
                                                         = ( SELECT TOP 1 CLOPM_DT FROM CLOSING_PRICE_MSTR_CDSL WHERE CLOPM_ISIN_CD = CDSHM_ISIN 
                                                         AND CLOPM_DT = CDSHM_TRAS_DT AND CLOPM_DELETED_IND = 1  ORDER BY CLOPM_DT DESC)   
 where CDSHM_CDAS_TRAS_TYPE=1 and CDSHM_CDAS_SUB_TRAS_TYPE
not in ('301','302','303','304','305','306','307','308','309','310','311','312','313','317')
and CDSHM_TRATM_CD in ('2212','2246','2277')
AND CDSHM_TRAS_DT BETWEEN @pa_from_dt AND @pa_to_dt
and cdshm_ben_acct_no like case when @pa_boid='' then '%' else @pa_boid end
--and citrus_usr.FN_SPLITVAL_BY(cdshm_trans_cdas_code,'25','~') in ('1','2')
end

GO
