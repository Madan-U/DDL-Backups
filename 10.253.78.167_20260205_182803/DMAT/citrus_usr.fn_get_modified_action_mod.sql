-- Object: FUNCTION citrus_usr.fn_get_modified_action_mod
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

create function citrus_usr.fn_get_modified_action_mod
(
	@pa_crn_no numeric,
	@pa_cd varchar(50)
)
returns varchar(8000)
as 
begin
	declare @l_value varchar(50)
		
		select @l_value = Case when @pa_cd = 'NOMINEE DEL' then 'D' else 
		(CASE WHEN exists (
		select 1 from dps8_pc6,dp_acct_mstr  where BOId = DPAM_SBA_NO and DPAM_CRN_NO = @pa_crn_no and PurposeCode6 = '06' and TypeOfTrans = '3') 
		THEN 'S' when not exists 
		(select 1 from dps8_pc6,dp_acct_mstr  where BOId = DPAM_SBA_NO and DPAM_CRN_NO = @pa_crn_no and PurposeCode6 = '06') then 'S' else 'M' END) end 
	return @l_value
end

GO
