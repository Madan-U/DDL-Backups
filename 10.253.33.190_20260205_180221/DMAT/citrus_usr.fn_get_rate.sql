-- Object: FUNCTION citrus_usr.fn_get_rate
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

create function [citrus_usr].[fn_get_rate](@PA_ISIN varchar(100),@pa_dt datetime)
returns numeric(18,3) 
as
begin
declare @l numeric(18,3)

select top 1 @l = CLOPM_CDSL_RT
 from closing_price_mstr_cdsl where CLOPM_ISIN_CD = @PA_ISIN AND clopm_dt <= @pa_dt order by clopm_dt desc

return @l

end

GO
