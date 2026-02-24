-- Object: PROCEDURE citrus_usr.PR_SHOW_CLIENTS_MOD
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------


create procedure [citrus_usr].[PR_SHOW_CLIENTS_MOD]
(
	@pa_id numeric,
	@pa_batchno varchar(50),
	@pa_modi_type varchar(50),
	@pa_errmsg varchar(8000) OUTPUT

)
as begin
	declare @dpam_id numeric
	
	SELECT @dpam_id  =  DPM_ID FROM DP_MSTR WHERE DEFAULT_DP = @PA_ID  AND DPM_DELETED_IND = 1 
	
	if @pa_modi_type = 'ALL'
	begin
		select distinct clic_mod_dpam_sba_no as BOID,clic_mod_action as [Modification Type]
		from client_list_modified,dp_acct_mstr
		where clic_mod_batch_no = @pa_batchno
		and clic_mod_dpam_sba_no = dpam_sba_no
		AND CLIC_MOD_DELETED_IND = 1
		and DPAM_dpm_ID = @dpam_id
	end
	else
	begin
		select distinct clic_mod_dpam_sba_no as BOID,clic_mod_action as [Modification Type]
		from client_list_modified,dp_acct_mstr
		where clic_mod_batch_no = @pa_batchno
		and clic_mod_dpam_sba_no = dpam_sba_no
		AND CLIC_MOD_DELETED_IND = 1
		and clic_mod_action = @pa_modi_type
		and DPAM_dpm_ID = @dpam_id
	end
	
end

GO
