-- Object: FUNCTION citrus_usr.fn_get_errordesc
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------


create function [citrus_usr].[fn_get_errordesc](@pa_cd varchar(100)) 
returns varchar(1000)
as
begin 
return (
select top 1 trastm_desc from transaction_sub_type_mstr where TRASTM_TRATM_ID =  20 
and TRASTM_CD = @pa_cd)
end

GO
