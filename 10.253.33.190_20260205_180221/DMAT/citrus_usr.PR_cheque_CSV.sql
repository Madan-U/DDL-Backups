-- Object: PROCEDURE citrus_usr.PR_cheque_CSV
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--SELECT * FROM DP_MSTR
--SELECT * FROM FIN_ACCOUNT_MSTR
--SELECT * FROM LEDGER4 WHERE LDG_ACCOUNT_TYPE = 'b'
--PR_cheque_CSV 'MAY 20 2009','MAY 31 2010','12345678'
CREATE Procedure [citrus_usr].[PR_cheque_CSV] (
 @PA_FROM_DT DATETIME  
,@PA_TO_DT   DATETIME  
,@PA_DP_ID   VARCHAR(16))


As 
Begin
declare --@L_FIN_ID      INT  
       @L_DPM_ID      INT 
--       , @DP_NAME VARCHAR(10)
--    
--declare @@ssql varchar(8000) 
--     
--SELECT @L_DPM_ID = DPM_ID 
--		--@DP_NAME=EXCM_CD 
--FROM DP_MSTR,EXCH_SEG_MSTR,EXCHANGE_MSTR   
--WHERE DPM_DPID = @PA_DP_ID   
--AND DPM_DELETED_IND = 1   
--AND DPM_EXCSM_ID=EXCSM_ID  
--AND EXCSM_EXCH_CD = EXCM_CD   
--AND DEFAULT_DP=DPM_EXCSM_ID   
--
--
---- SELECT @l_fin_id = fin_id from financial_yr_mstr where fin_dpm_id = @l_dpm_id and @@l_posting_dt between fin_start_dt and fin_end_dt
-- SELECT @l_fin_id = ISNULL(FIN_ID,0) FROM FINANCIAL_YR_MSTR WHERE FIN_DPM_ID = @l_dpm_id AND (@PA_FROM_DT BETWEEN convert(varchar(11),FIN_START_DT,109) AND convert(varchar(11),FIN_END_DT,109)) AND (@PA_TO_DT BETWEEN convert(varchar(11),FIN_START_DT,109) AND 
-- convert(varchar(11),FIN_END_DT,109) ) AND FIN_DELETED_IND = 1 

--set @@ssql ='select * from LEDGER ' + 'convert(varchar,'+@l_fin_id+')' + 'where LDG_VOUCHER_DT between '+@PA_FROM_DT+' and '+@PA_TO_DT+' and LDG_VOUCHER_TYPE = ''B'''

select @L_DPM_ID = dpm_id from dp_mstr where dpm_deleted_ind = 1 and DPM_DPID = @PA_DP_ID 

SELECT
convert(varchar(12), inwsr_recd_dt,109) as Vdate,
convert(varchar(12), inwsr_exec_dt,109) as Edate,
dpam_sba_no as cltcode,
inwsr_ufcharge_collected as Amount,
Case When inwsr_ufcharge_collected < 0 then 'Dr' Else 'Cr' End as Drcr,
inwsr_bankid as Bankcode,
inwsr_clibank_name as Bankname,
inwsr_cheque_no as Ddno,
inwsr_bank_branch as branchcode,
inwsr_rmks as Narration
FROM INWARD_SLIP_REG, dp_acct_mstr
where INWSR_DPM_ID = @L_DPM_ID--@PA_DP_ID
and inwsr_exec_dt between @PA_FROM_DT and @PA_TO_DT
and INWSR_DPaM_ID = dpam_id
and inwsr_PAY_MODE= 'cheque'

union

select  
convert(varchar(12),inwcr_recvd_dt,109) as Vdate,
'' as Edate,
dpam_sba_no as cltcode,
inwcr_charge_collected as Amount,
Case When inwcr_charge_collected < 0 then 'Dr' Else 'Cr' End as Drcr,
inwcr_bank_id as Bankcode,
inwcr_clibank_name as Bankname,
inwcr_cheque_no as Ddno,
inwcr_bank_branch as branchcode,
inwcr_rmks as Narration
from inw_client_reg, dp_acct_mstr
where inwcr_dmpdpid = @L_DPM_ID--@PA_DP_ID
and inwcr_recvd_dt between @PA_FROM_DT and @PA_TO_DT
and inwcr_dmpdpid = dpam_dpm_id
and INWCR_PAY_MODE = 'Cheque'

end

GO
