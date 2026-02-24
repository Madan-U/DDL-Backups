-- Object: FUNCTION citrus_usr.Fn_Toget_CitySeqno_bak_20042023
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------



CREATE function [citrus_usr].[Fn_Toget_CitySeqno_bak_20042023]
(
@pa_zip varchar(10)
,@pa_city varchar(110)
)
returns varchar(2)
begin
declare @l_rtn varchar(2)
Select @l_rtn=convert(char,PM_CITYREF_NO) from PIN_MSTR where convert(varchar,PM_PIN_CODE)=@pa_zip  and convert(varchar,PM_DISTRICT_NAME)=@pa_city
return isnull(@l_rtn,'')
end

GO
