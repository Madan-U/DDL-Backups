-- Object: FUNCTION citrus_usr.ufn_GetFirstDayOfMonth
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE FUNCTION [citrus_usr].[ufn_GetFirstDayOfMonth] ( @pInputDate    DATETIME )
RETURNS DATETIME
BEGIN

    RETURN CAST(CAST(YEAR(@pInputDate) AS VARCHAR(4)) + '/' + 
                CAST(MONTH(@pInputDate) AS VARCHAR(2)) + '/01' AS DATETIME)

END

GO
