-- Object: PROCEDURE citrus_usr.pr_chk_beforeHolDump
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--pr_chk_beforeHolDump 'Step1'
CREATE procedure [citrus_usr].[pr_chk_beforeHolDump]
(
@pa_action varchar (10)
)

as 
begin 
if @pa_action='Step1'
begin
SELECT COUNT(1) cnt,DPM_DPID ,DPHMCD_HOLDING_DT 
FROM HOLDINGALLFORVIEW,DP_MSTR 
WHERE DPM_ID = DPHMCD_DPM_ID 
GROUP BY DPM_DPID,DPHMCD_HOLDING_DT 
ORDER BY 2 
end 

if @pa_action='Step2'
begin
select * from tmp_SelectedDp where DPID not in (
select distinct dpm_dpid from dp_hldg_mstr_cdsl,dp_mstr where dphmc_holding_dt =
(select max(dphmc_holding_dt) from dp_hldg_mstr_cdsl)
and dpm_id=DPHMC_DPM_ID and default_dp=dpm_excsm_id)
end 

end

GO
