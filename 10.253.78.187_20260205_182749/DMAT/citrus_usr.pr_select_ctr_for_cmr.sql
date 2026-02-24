-- Object: PROCEDURE citrus_usr.pr_select_ctr_for_cmr
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------


create  procedure [citrus_usr].[pr_select_ctr_for_cmr]
(
	@pa_action varchar(100),
	@pa_value varchar(150),
	@pa_output varchar(8000) output
)
as
begin
	if @pa_action = 'BBO'
	begin
		select distinct dpam_sba_no 
		from dp_acct_mstr 
		where dpam_bbo_code = @pa_value 
		and dpam_deleted_ind = 1
	end
	if @pa_action = 'PAN'
	begin
		--select distinct dpam_sba_no 
		--from dp_acct_mstr,entity_properties 
		--where DPAM_CRN_NO = ENTP_ENT_ID 
		--and ENTP_ENTPM_CD = 'PAN_GIR_NO'
		--and dpam_deleted_ind = 1
		--and ENTP_DELETED_IND = 1
		--and dpam_bbo_code = @pa_value
		
		
		select distinct boid dpam_sba_no 
		from dps8_pc1 where upper(PANGIR) = upper(@pa_value)
		and BOAcctStatus in ( '1','2')
		
	end
	if @pa_action = 'EMAIL'
	begin
		--SELECT distinct DPAM_SBA_NO 
		--FROM   contact_channels          conc          
		--	   ,entity_adr_conc          entac
		--	   ,DP_ACCT_MSTR			
		--WHERE  entac.entac_adr_conc_id = conc.conc_id          
		--AND    entac_ent_id            = DPAM_CRN_NO       
		--AND    entac_concm_cd          = 'EMAIL1'        
		--AND    conc.conc_deleted_ind   = 1         
		--AND    entac.entac_deleted_ind = 1
		--and    DPAM_DELETED_IND = 1
		--and    conc.CONC_VALUE = @pa_value
		
		select distinct boid dpam_sba_no 
		from dps8_pc1 where upper(EMailId) = upper(@pa_value)
		and BOAcctStatus  in ( '1','2')
		
		
	end
end

GO
