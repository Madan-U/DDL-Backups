-- Object: FUNCTION citrus_usr.FN_TOGETCDSLCOUNTRYSTATECODE
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------


CREATE FUNCTION FN_TOGETCDSLCOUNTRYSTATECODE
(
@PA_COUNTRY_STATE VARCHAR(100)
,@PA_VALUE VARCHAR(100)
)
Returns  varchar(100)
begin
declare @l_rtn varchar(100)
if @PA_COUNTRY_STATE='Country'
begin
Select top 1 @l_rtn=ccm_cd from cdsl_country_mstr where ccm_country_name=@PA_VALUE
end
if @PA_COUNTRY_STATE='state'
begin
Select top 1 @l_rtn=csm_state_code_iso from cdsl_state_mstr where csm_state_name=@PA_VALUE
end
return isnull(@l_rtn,'')
end

GO
