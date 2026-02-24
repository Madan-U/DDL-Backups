-- Object: FUNCTION citrus_usr.GETBIT
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE function [citrus_usr].[GETBIT](@a int, @b int ) 
--Returns the value of a certain bit.
returns int
as
BEGIN
return ABS(SIGN(@a & (POWER(2,@b))))
END

GO
