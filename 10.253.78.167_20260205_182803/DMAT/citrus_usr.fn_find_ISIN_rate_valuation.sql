-- Object: FUNCTION citrus_usr.fn_find_ISIN_rate_valuation
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

Create function citrus_usr.fn_find_ISIN_rate_valuation
(
	@pa_trans_dt varchar(20),
	@pa_isin varchar(20),
	@pa_qty numeric
)
RETURNS varchar(8000)  
AS  
BEGIN  
	DECLARE @l_rate numeric(18,4), @l_valuation numeric(25,4), @l_COLDELIMITER char(4)
	set @l_COLDELIMITER = '|*~|'
	select top 1  @l_rate = CLOPM_CDSL_RT from CLOSING_PRICE_MSTR_cdsl 
	where CLOPM_ISIN_CD = @pa_isin --'INE002A01018' 
	and CLOPM_DT <= convert(varchar(11),convert(datetime,@pa_trans_dt,103),109) --@pa_trans_dt --'sep 22 2015'
	order by CLOPM_DT desc
	
	set @l_valuation = @l_rate * @pa_qty

	return  convert(varchar,@l_rate) + @l_COLDELIMITER + convert(varchar,@l_valuation)
end

GO
