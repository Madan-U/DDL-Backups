-- Object: FUNCTION citrus_usr.Fn_Toget_CitySeqno
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------



CREATE function [citrus_usr].[Fn_Toget_CitySeqno]
(
@pa_zip varchar(10)
,@pa_city varchar(110)
)
returns varchar(2)
begin
declare @l_rtn varchar(2)
Select @l_rtn=convert(char,PM_CITYREF_NO) from PIN_MSTR (NOLOCK)
--where convert(varchar,PM_PIN_CODE)=@pa_zip  and convert(varchar,PM_DISTRICT_NAME)=@pa_city
where PM_PIN_CODE=case when isnumeric(@pa_zip  ) = 1 then @pa_zip else '0' end and PM_DISTRICT_NAME=@pa_city
return isnull(@l_rtn,'')
end

GO
