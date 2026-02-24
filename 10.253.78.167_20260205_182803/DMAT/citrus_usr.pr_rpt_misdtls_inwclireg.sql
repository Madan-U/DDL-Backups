-- Object: PROCEDURE citrus_usr.pr_rpt_misdtls_inwclireg
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

/*
exec  pr_rpt_misdtls_inwclireg '3','may 30 2008','may 30 2009' 
	exec  pr_rpt_misdtls_inwclireg '3','Aug 11 2008','Aug 10 2009' 	
 
begin tran
rollback
*/
CREATE procedure [citrus_usr].[pr_rpt_misdtls_inwclireg]
(
	@pa_excsm_id numeric, 
	@pa_from_dt datetime, 
	@pa_to_dt datetime,  
	@pa_out varchar(11) out
)
as
begin
declare @l_dpm_id numeric
select @l_dpm_id = dpm_id from dp_mstr where default_dp = dpm_excsm_id and dpm_excsm_id = @pa_excsm_id and dpm_deleted_ind = 1 
select inwcr_frmno, convert(varchar(11),INWCR_RECVD_DT ,103) INWCR_RECVD_DT , inwcr_charge_collected from inw_client_reg
where not exists (select dpam_acct_no from dp_acct_mstr_mak where dpam_acct_no = inwcr_frmno and dpam_deleted_ind in (0,1))
and inwcr_created_dt between @pa_from_dt and @pa_to_dt
and inwcr_deleted_ind = 1

end

GO
