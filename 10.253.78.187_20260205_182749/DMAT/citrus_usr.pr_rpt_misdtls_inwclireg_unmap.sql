-- Object: PROCEDURE citrus_usr.pr_rpt_misdtls_inwclireg_unmap
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

/*
exec  pr_rpt_misdtls_inwclireg '3','may 30 2008','may 30 2009' 
	exec  pr_rpt_misdtls_inwclireg '3','Aug 11 2008','Aug 10 2009' 	
 
begin tran
rollback
*/
create procedure [citrus_usr].[pr_rpt_misdtls_inwclireg_unmap]
(
	@pa_excsm_id numeric, 
	@pa_from_dt datetime, 
	@pa_to_dt datetime,
    @pa_entitywise varchar(20),  
	@pa_out varchar(11) out
)
as
begin
declare @l_dpm_id numeric
select @l_dpm_id = dpm_id from dp_mstr where default_dp = dpm_excsm_id and dpm_excsm_id = @pa_excsm_id and dpm_deleted_ind = 1 

if @pa_entitywise='HO'
begin
select inwcr_frmno, convert(varchar(11),INWCR_RECVD_DT ,103) INWCR_RECVD_DT , inwcr_charge_collected,INWCR_CREATED_BY [ENTRY_ID],entm_name1  from 
inw_client_reg,login_names,entity_mstr
where not exists (select dpam_acct_no from dp_acct_mstr_mak where dpam_acct_no = inwcr_frmno and dpam_deleted_ind in (0,1))
and inwcr_created_dt between @pa_from_dt and @pa_to_dt and entm_short_name = LOGN_SHORT_NAME and logn_name =  INWCR_CREATED_BY 
and inwcr_deleted_ind = 1
and entm_short_name='HO'
end
else
begin
select inwcr_frmno, convert(varchar(11),INWCR_RECVD_DT ,103) INWCR_RECVD_DT , inwcr_charge_collected,INWCR_CREATED_BY [ENTRY_ID],entm_name1  from 
inw_client_reg,login_names,entity_mstr
where not exists (select dpam_acct_no from dp_acct_mstr_mak where dpam_acct_no = inwcr_frmno and dpam_deleted_ind in (0,1))
and inwcr_created_dt between @pa_from_dt and @pa_to_dt and entm_short_name = LOGN_SHORT_NAME and logn_name =  INWCR_CREATED_BY 
and inwcr_deleted_ind = 1
and entm_short_name<>'HO'
end

end

GO
