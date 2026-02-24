-- Object: FUNCTION dbo.ufn_GetDaysInYear
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE FUNCTION [dbo].[ufn_GetDaysInYear] ( @pDate    DATETIME )
RETURNS INT
AS
BEGIN

    DECLARE @IsLeapYear        BIT

    SET @IsLeapYear = 0
    IF (YEAR( @pDate ) % 4 = 0 AND YEAR( @pDate ) % 100 != 0) OR
        YEAR( @pDate ) % 400 = 0
        SET @IsLeapYear = 1

    RETURN 365 + @IsLeapYear

END

GO
