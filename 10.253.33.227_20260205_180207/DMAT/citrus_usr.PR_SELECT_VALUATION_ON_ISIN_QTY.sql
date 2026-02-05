-- Object: PROCEDURE citrus_usr.PR_SELECT_VALUATION_ON_ISIN_QTY
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE PR_SELECT_VALUATION_ON_ISIN_QTY
(
	@PA_ACTION VARCHAR(100),
	@PA_ISIN VARCHAR(15),
	@PA_QTY NUMERIC(20),
	@PA_VALUE VARCHAR(150),
	@PA_REF_CUR VARCHAR(5000) OUT
)
AS BEGIN
	DECLARE  @L_VAL NUMERIC (20,4)
	IF @PA_ACTION = 'CDSL'
	BEGIN
		SET @L_VAL = ''
		select top 1 @L_VAL = CLOPM_CDSL_RT  from CLOSING_PRICE_MSTR_cdsl 
		where clopm_isin_cd = @PA_ISIN  order by clopm_dt desc
		SET @L_VAL = @L_VAL * @PA_QTY
		
		SELECT @L_VAL VALUATION
	END
	IF @PA_ACTION = 'NSDL'
	BEGIN
		SET @L_VAL = ''
		select top 1 @L_VAL = CLOPM_CDSL_RT  from CLOSING_PRICE_MSTR_cdsl 
		where clopm_isin_cd = @PA_ISIN  order by clopm_dt desc
		SET @L_VAL = @L_VAL * @PA_QTY
		
		SELECT @L_VAL VALUATION
	END
END

GO
