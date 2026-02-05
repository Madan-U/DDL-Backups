-- Object: FUNCTION dbo.ufn_IsLeapYear
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE FUNCTION [dbo].[ufn_IsLeapYear] ( @pDate    DATETIME )
RETURNS BIT
AS
BEGIN

    IF (YEAR( @pDate ) % 4 = 0 AND YEAR( @pDate ) % 100 != 0) OR
        YEAR( @pDate ) % 400 = 0
        RETURN 1

    RETURN 0

END

GO
