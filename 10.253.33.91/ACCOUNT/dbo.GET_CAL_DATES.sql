-- Object: PROCEDURE dbo.GET_CAL_DATES
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


CREATE PROCEDURE [dbo].[GET_CAL_DATES]
	@StartDateTime datetime,
	@EndDateTime datetime
AS

 

 
WITH DateRange(DateData) AS 
(
    SELECT @StartDateTime as Date
    UNION ALL
    SELECT DATEADD(d,1,DateData)
    FROM DateRange 
    WHERE DateData < @EndDateTime
)
SELECT DateData
FROM DateRange
OPTION (MAXRECURSION 0)

GO
