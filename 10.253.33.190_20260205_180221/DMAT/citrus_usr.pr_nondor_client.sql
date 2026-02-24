-- Object: PROCEDURE citrus_usr.pr_nondor_client
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE  proc pr_nondor_client
as
begin 
drop  table Client_lasttrx
drop  table nondorclient

SELECT CDSHM_BEN_ACCT_NO ,  CDSHM_DPAM_ID , isnULL(MAX(CDSHM_TRAS_DT ),'Jan 01 1900') maxtrxdt into Client_lasttrx FROM cdsl_HOLDING_DTLS   with (nolock)
WHERE --right(CDSHM_BEN_ACCT_NO,'8') = right(@PA_ACCT_NO,'8')   
CDSHM_CDAS_TRAS_TYPE not in ( '21'  ,'22')  
and CDSHM_TRATM_CD = ('2277')   --and cdshm_tras_dt>='DEC  1 2019'    

group by CDSHM_BEN_ACCT_NO ,  CDSHM_DPAM_ID 


select CDSHM_BEN_ACCT_NO ,  CDSHM_DPAM_ID , GETDATE () run_Date into nondorclient from Client_lasttrx
where  maxtrxdt between DATEADD(M,-6,GETDATE () ) AND GETDATE () 

end

GO
