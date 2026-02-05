-- Object: FUNCTION dbo.udf_GetLastDayOfMonth
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------



CREATE FUNCTION [dbo].[udf_GetLastDayOfMonth] 

(

    @Date DATETIME

)

RETURNS DATETIME

AS

BEGIN



    RETURN DATEADD(d, -1, DATEADD(m, DATEDIFF(m, 0, @Date) + 1, 0))



END

GO
