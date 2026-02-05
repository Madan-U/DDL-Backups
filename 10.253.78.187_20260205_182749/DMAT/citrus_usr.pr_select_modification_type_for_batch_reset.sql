-- Object: PROCEDURE citrus_usr.pr_select_modification_type_for_batch_reset
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------



create procedure [citrus_usr].[pr_select_modification_type_for_batch_reset]
(
	@pa_id numeric,
	@pa_action varchar(100),
	@pa_batch_no numeric,
	@pa_ref_cur varchar(8000) output
)
as begin
	DECLARE @L_DPM_ID INTEGER
	SELECT @L_DPM_ID = DPM_ID FROM DP_MSTR WHERE DEFAULT_DP = @PA_ID AND DPM_DELETED_IND = 1  
	if @pa_action = 'MODI_RESET'
	begin
		if @pa_batch_no = '0'
		begin
			set @pa_batch_no = null 
		end

		
		select distinct clic_mod_action from client_list_modified,dp_acct_mstr
		where clic_mod_batch_no = @pa_batch_no
		and DPAM_dpm_ID = @L_DPM_ID
		and clic_mod_dpam_sba_no = dpam_sba_no
	end
	
end

GO
