-- Object: FUNCTION citrus_usr.DPBM_fn_add
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE function [citrus_usr].[DPBM_fn_add]
(
@s1 numeric,@s2 numeric
)returns numeric
begin
declare @s numeric
set @s = @s1  + @s2
return @s
end

GO
