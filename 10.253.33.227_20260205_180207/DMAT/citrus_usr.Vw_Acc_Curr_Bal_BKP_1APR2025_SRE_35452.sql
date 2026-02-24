-- Object: VIEW citrus_usr.Vw_Acc_Curr_Bal_BKP_1APR2025_SRE_35452
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------










  ---Select * from Vw_Acc_Curr_Bal
  
CREATE  view [citrus_usr].[Vw_Acc_Curr_Bal_BKP_1APR2025_SRE_35452]        
as        
  
  
select PARTY_CODE,CLIENT_CODE        
,sum(CURR_BAL) Actual_amount      
, sum(BROK_BAL) Accrual_bal,'0' AS Branch_Code       
from (    
select DPAM_BBO_CODE AS PARTY_CODE, DPAM_SBA_NO CLIENT_CODE, sum(clic_charge_amt)*-1 BROK_BAL, '0' CURR_BAL  from         
  dp_acct_mstr , client_charges_cdsl where clic_dpam_id = dpam_id and clic_trans_dt between citrus_usr.ufn_GetFirstDayOfMonth(getdate())        
  and dbo.ufn_GetLastDayOfMonth(GETDATE()) group by DPAM_SBA_NO,DPAM_BBO_CODE         
  union ALL    
 select DPAM_BBO_CODE AS PARTY_CODE, DPAM_SBA_NO CLIENT_CODE, sum(clic_charge_amt)*-1 BROK_BAL, '0' CURR_BAL  from         
 dp_acct_mstr , client_charges_cdsl where clic_dpam_id = dpam_id     
  and clic_trans_dt between citrus_usr.ufn_GetFirstDayOfMonth(DATEADD(month,-1,GETDATE()))        
  and dbo.ufn_GetLastDayOfMonth(DATEADD(month,-1,GETDATE()))     
  and not exists (select ldg_account_id from ledger11 where LDG_ACCOUNT_ID=dpam_id and LDG_DELETED_IND=1 and LDG_VOUCHER_TYPE='5'    
  and LDG_VOUCHER_DT=dbo.ufn_GetLastDayOfMonth(DATEADD(month,-1,GETDATE()))    
  union all    
  select ldg_account_id from LEDGER11 where LDG_ACCOUNT_ID=dpam_id and LDG_DELETED_IND=1 and LDG_VOUCHER_TYPE='5'    
  and LDG_VOUCHER_DT=dbo.ufn_GetLastDayOfMonth(DATEADD(month,-1,GETDATE())))    
    group by DPAM_SBA_NO,DPAM_BBO_CODE     
     
    
    
  union all        
    
  select DPAM_BBO_CODE AS PARTY_CODE,DPAM_SBA_NO CLIENT_CODE,0 BROK_BAL  , sum(ldg_amount)*-1 CURR_BAL         
  from ledger11, DP_ACCT_MSTR where LDG_ACCOUNT_ID = DPAM_ID and LDG_ACCOUNT_TYPE ='P' and LDG_DELETED_IND = 1 and DPAM_DELETED_IND = 1     
  group by DPAM_SBA_NO,DPAM_BBO_CODE    )      BALANCE       
    
    
    
group by PARTY_CODE,CLIENT_CODE   
  
-----select * from dbo.ufn_GetLastDayOfMonth(DATEADD(month,-1,GETDATE())))

GO
