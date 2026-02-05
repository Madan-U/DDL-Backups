-- Object: VIEW citrus_usr.billing
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE view [citrus_usr].[billing] 
as
select  left(CONVERT(VARCHAR(8), clic_trans_dt, 112) ,6) bl_series 
,CONVERT(VARCHAR(8),citrus_usr.LastMonthDay(clic_trans_dt), 112)  bl_bill_dt
,CONVERT(VARCHAR(8),citrus_usr.[ufn_GetFirstDayOfMonth](clic_trans_dt), 112) bl_bill_from
,CONVERT(VARCHAR(8),dbo.ufn_GetLastDayOfMonth(clic_trans_dt), 112) bl_bill_to
,'Y' bl_receivable
, sum(clic_charge_amt) bl_amount
,dpam_sba_no bl_client_id
,'N' bl_pass_acc
,clic_lst_upd_by mkrid
,CONVERT(VARCHAR(8),clic_lst_upd_dt, 112) mkrdt
,CONVERT(VARCHAR(8),billc_due_date, 112)  bl_duedt 
,'N' bl_type
from client_charges_cdsl, dp_acct_mstr ,bill_cycle
where clic_dpam_id = dpam_id  and clic_dpm_id = BILLC_DPM_ID  and clic_trans_dt between BILLC_FROM_DT and BILLC_TO_DT
group by left(CONVERT(VARCHAR(8), clic_trans_dt, 112) ,6)
,CONVERT(VARCHAR(8),citrus_usr.LastMonthDay(clic_trans_dt), 112)
,CONVERT(VARCHAR(8),citrus_usr.[ufn_GetFirstDayOfMonth](clic_trans_dt), 112)
,CONVERT(VARCHAR(8),dbo.ufn_GetLastDayOfMonth(clic_trans_dt), 112)
,dpam_sba_no
,clic_lst_upd_by
,CONVERT(VARCHAR(8),clic_lst_upd_dt, 112)
,billc_due_date

GO
