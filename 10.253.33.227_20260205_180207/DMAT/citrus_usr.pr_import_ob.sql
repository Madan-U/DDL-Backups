-- Object: PROCEDURE citrus_usr.pr_import_ob
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE proc [citrus_usr].[pr_import_ob]
as
begin 

truncate table  LEDGER1 

select IDENTITY(numeric,1,1) id , * into #obledger from 
 (select 3 ldg_dpm_id , 3 ldg_voucher_type , '01' ldg_book_type_cd, 0 ldg_voucher_no 
,'Apr 01 2015' ldg_voucher_dt,dpam_id ldg_account_id ,'P' ldg_account_type , OPEN_BAL*-1   ldg_amount
,'OPENING BALANCE' ldg_narration ,null ldg_bank_id, null ldg_account_no ,null ldg_instrument_no , null ldg_bank_cl_date
,0 ldg_cost_cd_id, 0 ldg_bill_brkup_id , '' ldg_trans_type ,null ldg_status ,'MIG' ldg_created_by
,GETDATE() ldg_created_dt , 'MIG' ldg_lst_upd_by
,GETDATE() ldg_lst_upd_dt 
,1 ldg_deleted_ind , 0 ldg_branch_id 
from TEMP_LED_0307 a , dp_acct_mstr
where CLTCODE = DPAM_SBA_NO--483281
and DPAM_DELETED_IND=1

union all 

select 3 ldg_dpm_id , 3 ldg_voucher_type , '01' ldg_book_type_cd, 0 ldg_voucher_no 
,'Apr 01 2015' ldg_voucher_dt,FINA_ACC_ID  ldg_account_id ,FINA_ACC_TYPE ldg_account_type , OPEN_BAL*-1   ldg_amount
,'OPENING BALANCE' ldg_narration ,null ldg_bank_id, null ldg_account_no ,null ldg_instrument_no , null ldg_bank_cl_date
,0 ldg_cost_cd_id, 0 ldg_bill_brkup_id , '' ldg_trans_type ,null ldg_status ,'MIG' ldg_created_by
,GETDATE() ldg_created_dt , 'MIG' ldg_lst_upd_by
,GETDATE() ldg_lst_upd_dt 
,1 ldg_deleted_ind , 0 ldg_branch_id 
 from TEMP_LED_0307 a , FIN_ACCOUNT_MSTR , ob_temp 
where CLTCODE = synergy 
and mkt = FINA_ACC_CODE --41
and FINA_DELETED_IND =1

) ledger


insert into  LEDGER2 
select Id
,ldg_dpm_id 
,ldg_voucher_type
,ldg_book_type_cd 
,ldg_voucher_no
,ID
,ID
,ldg_voucher_dt
,ldg_account_id 
,ldg_account_type
,ldg_amount
,ldg_narration
,ldg_bank_id 
,LDG_ACCOUNT_NO
,LDG_INSTRUMENT_NO
,LDG_BANK_CL_DATE
,LDG_COST_CD_ID
,LDG_BILL_BRKUP_ID
,LDG_TRANS_TYPE
,LDG_STATUS
,LDG_CREATED_BY
,LDG_CREATED_DT
,LDG_LST_UPD_BY
,LDG_LST_UPD_DT
,LDG_DELETED_IND
,LDG_BRANCH_ID
from #obledger



drop table #obledger
end

GO
