-- Object: FUNCTION dbo.ufn_GetAge
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE FUNCTION [dbo].[ufn_GetAge] ( @pDateOfBirth    DATETIME, 
                                     @pAsOfDate       DATETIME )
RETURNS INT
AS
BEGIN

    DECLARE @vAge         INT
    
    IF @pDateOfBirth >= @pAsOfDate
        RETURN 0

    SET @vAge = DATEDIFF(YY, @pDateOfBirth, @pAsOfDate)

    IF MONTH(@pDateOfBirth) > MONTH(@pAsOfDate) OR
      (MONTH(@pDateOfBirth) = MONTH(@pAsOfDate) AND
       DAY(@pDateOfBirth)   > DAY(@pAsOfDate))
        SET @vAge = @vAge - 1

    RETURN @vAge
END

GO
