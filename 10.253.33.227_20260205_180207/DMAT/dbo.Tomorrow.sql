-- Object: FUNCTION dbo.Tomorrow
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE FUNCTION [dbo].[Tomorrow] ()
RETURNS DATETIME
AS
BEGIN
   DECLARE @TodaysDate DATETIME
   SET @TodaysDate = GETDATE()
   SET @TodaysDate = DATEADD(DD, DATEDIFF(DD, 0, @TodaysDate), 0)
   RETURN DATEADD(DD, 1, @TodaysDate)
END

GO
