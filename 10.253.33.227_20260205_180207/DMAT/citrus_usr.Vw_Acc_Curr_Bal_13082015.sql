-- Object: VIEW citrus_usr.Vw_Acc_Curr_Bal_13082015
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

  
CREATE view [citrus_usr].[Vw_Acc_Curr_Bal]  
as  
select ACC_CODE  
, sum(BROK_BAL) BROK_BAL  
,sum(CURR_BAL)  CURR_BAL  
from (select dpam_bbo_code ACC_CODE, sum(clic_charge_amt) BROK_BAL, '0' CURR_BAL  from   
  dp_acct_mstr , client_charges_cdsl where clic_dpam_id = dpam_id and clic_trans_dt between citrus_usr.ufn_GetFirstDayOfMonth(getdate())  
  and dbo.ufn_GetLastDayOfMonth(GETDATE()) group by DPAM_BBO_CODE   
  union all  
  select dpam_bbo_code ,0 BROK_BAL  , sum(ldg_amount) CURR_BAL   
  from ledger2 , DP_ACCT_MSTR where LDG_ACCOUNT_ID = DPAM_ID and LDG_ACCOUNT_TYPE ='P' and LDG_DELETED_IND = 1 and DPAM_DELETED_IND = 1 group by DPAM_BBO_CODE ) balance   
group by ACC_CODE

GO
