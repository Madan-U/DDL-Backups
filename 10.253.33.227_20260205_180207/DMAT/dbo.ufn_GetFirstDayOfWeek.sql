-- Object: FUNCTION dbo.ufn_GetFirstDayOfWeek
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE FUNCTION [dbo].[ufn_GetFirstDayOfWeek] ( @pInputDate    DATETIME )
RETURNS DATETIME
BEGIN

    SET @pInputDate = [dbo].[ufn_GetDateOnly] ( @pInputDate )
    RETURN DATEADD(DD, 1 - DATEPART(DW, @pInputDate), @pInputDate)

END

GO
