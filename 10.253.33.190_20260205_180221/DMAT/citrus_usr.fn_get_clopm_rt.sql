-- Object: FUNCTION citrus_usr.fn_get_clopm_rt
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE function [citrus_usr].[fn_get_clopm_rt](@pa_isin varchar(100),@dt datetime)
returns numeric(18,3)
as
begin 

return (
select top 1 CLOPM_CDSL_RT from closing_price_mstr_cdsl where clopm_isin_cd  = @pa_isin
and clopm_dt < = @dt and isnull(CLOPM_CDSL_RT,0) <> 0 order by clopm_dt desc)

end

GO
