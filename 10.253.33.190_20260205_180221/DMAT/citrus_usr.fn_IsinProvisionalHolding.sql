-- Object: FUNCTION citrus_usr.fn_IsinProvisionalHolding
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE function [citrus_usr].[fn_IsinProvisionalHolding](
@pa_depository char(4),
@dpmid bigint,
@pa_dpamid bigint,
@pa_isincd varchar(12)) returns numeric(18,3)
as
begin
	declare @@BALQTY numeric(18,3)

	if @pa_depository  = 'NSDL'
	begin
		select @@BALQTY = sum(DPDHM_QTY)
		from DP_HLDG_MSTR_NSDL
		where DPDHM_dpam_id = @pa_dpamid  
		and DPDHM_ISIN = @pa_isincd
		and DPDHM_DPM_ID = @dpmid   
		and DPDHM_BENF_ACCT_TYP IN(10,11,20)




	end
	else
	begin
		select @@BALQTY = 0
	end

	return @@BALQTY


end

GO
