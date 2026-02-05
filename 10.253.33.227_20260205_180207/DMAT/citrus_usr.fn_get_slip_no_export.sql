-- Object: FUNCTION citrus_usr.fn_get_slip_no_export
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE function [citrus_usr].[fn_get_slip_no_export]
(@pa_dpam_sba_no varchar(16)
,@pa_slip_no varchar(100))
returns varchar(100)
begin 

declare @l_str varchar(100)

set @l_str  =  ''

select @l_str = USES_SERIES_TYPE +  citrus_usr.FN_FORMATSTR(convert(varchar(12),(USES_SLIP_NO))
,12-len(USES_SERIES_TYPE)
,0,'L','0')
from used_slip
where ltrim(rtrim(USES_SERIES_TYPE)) + ltrim(rtrim(USES_SLIP_NO)) = @pa_slip_no
and USES_DPAM_ACCT_No = @pa_dpam_sba_no and USES_USED_DESTR ='U'
and uses_deleted_ind = 1 

if @l_str=''

select @l_str = USES_SERIES_TYPE +  citrus_usr.FN_FORMATSTR(convert(varchar(12),(USES_SLIP_NO))
,12-len(USES_SERIES_TYPE)
,0,'L','0')
from used_slip,dp_acct_mstr,dp_poa_dtls
where ltrim(rtrim(USES_SERIES_TYPE)) + ltrim(rtrim(USES_SLIP_NO)) = @pa_slip_no
and USES_DPAM_ACCT_No = dppd_master_id and USES_USED_DESTR ='U'
and uses_deleted_ind = 1  and DPPD_DPAM_ID=DPAM_ID and DPAM_SBA_NO=@pa_dpam_sba_no

return @l_str 

end

GO
