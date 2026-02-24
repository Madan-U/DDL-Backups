-- Object: PROCEDURE citrus_usr.PR_RPT_CLIENTDEBITASONDATE_291211
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

--PR_RPT_CLIENTDEBITASONDATE '3','apr  1 2010','jun 13 2010',2
CREATE PROCEDURE [citrus_usr].[PR_RPT_CLIENTDEBITASONDATE_291211]
(
 @PA_DPM_ID NUMERIC
,@PA_FROMDaTe DATETIME
,@PA_TODaTe DATETIME
,@PA_FIN_ID SMALLINT
)
AS
BEGIN
CREATE TABLE #ACLIST(dpam_id BIGINT,dpam_sba_no VARCHAR(16),dpam_sba_name VARCHAR(150),eff_from DATETIME,eff_to DATETIME,acct_type varchar(2))
 
	INSERT INTO #ACLIST SELECT DPAM_ID,dpam_sba_no,dpam_sba_name,EFF_FROM,EFF_TO,'P' FROM citrus_usr.fn_acct_list(@PA_DPM_ID ,1,0)		
 
--SELECT * FROM #ACLIST WHERE dpam_sba_no='1203270000183308'
/*
SELECT  DPAM_SBA_NO,CASE WHEN SUM(LDG_AMOUNT)< 0 THEN CONVERT(VARCHAR,ABS(SUM(LDG_AMOUNT)))
ELSE CONVERT(VARCHAR,ABS(SUM(LDG_AMOUNT))) END AMOUNT   
FROM LEDGER2,#ACLIST WHERE LDG_ACCOUNT_ID=DPAM_ID
AND LDG_VOUCHER_DT >= @PA_FROMDaTe AND LDG_VOUCHER_DT <= @PA_TODaTe AND LDG_DELETED_IND=1
and dpam_sba_no='1203270000183308'
--AND  ldg_account_type = 'P' 
GROUP BY DPAM_SBA_NO
HAVING SUM(LDG_AMOUNT)>0
ORDER BY DPAM_SBA_NO*/

select dpam_sba_no,
SUM(ldg_amount) AMOUNT from ledger2 , #ACLIST account  
where ldg_dpm_id = 3  and ldg_voucher_dt >= @PA_FROMDaTe  and 
ldg_voucher_dt <= @PA_TODaTe and ISNULL(ldg_trans_type,'') <> 'O' 
and ldg_account_id = account.dpam_id  and ldg_account_type = account.acct_type 
 and isnumeric(dpam_sba_no) = 1  and (ldg_voucher_dt between eff_from and eff_to)  
--and convert(bigint,dpam_sba_no) >= 1203270000183308 and convert(bigint,dpam_sba_no) <= 1203270000183308 
and ldg_account_type = 'P' 
and ldg_deleted_ind = 1 --AND ldg_amount<0 
GROUP BY dpam_sba_no
HAVING SUM(ldg_amount) <0
order by dpam_sba_no

END

GO
