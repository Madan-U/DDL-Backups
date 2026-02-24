-- Object: PROCEDURE dbo.GET_PERIOD_DATES
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------






--EXEC GET_PERIOD_DATES_TEST '01/04/2018', '31/03/2019', 'M'

CREATE PROCEDURE [dbo].[GET_PERIOD_DATES] 
		@StartDate_date  varchar(10),
        @EndDate_date    varchar(10),
		@PERIOD_TYPE CHAR(1)
AS
DECLARE @StartDate  DATETIME,
        @EndDate    DATETIME;

		

SELECT   @StartDate = convert(varchar(10), convert(datetime, @StartDate_date, 103), 112)
SELECT   @EndDate   = convert(varchar(10), convert(datetime, @EndDate_date, 103), 112)

IF @PERIOD_TYPE = 'Q'
BEGIN
	;with rs as
	(
	   select   1 r,@StartDate s
	   union all 
	   select r+1, DATEADD(qq,1,s)  from rs where r<=datediff(qq,@StartDate,@EndDate)
	) 
	select FirstDay = convert(datetime, left(datename(mm,s),3) + '  1 ' +cast(year(s) as varchar)) into #abc from rs

	SELECT FirstDay = CONVERT(VARCHAR(10), FirstDay, 103), LastDay = CONVERT(VARCHAR(10), DATEADD(Q, 1, FirstDay) - 1, 103)  FROM #abc
END
ELSE
BEGIN
	;with rs as
	(
	   select   1 r,@StartDate s
	   union all 
	   select r+1, DATEADD(mm,1,s)  from rs where r<=datediff(mm,@StartDate,@EndDate)
	) 
	select FirstDay = convert(datetime, left(datename(mm,s),3) + '  1 ' +cast(year(s) as varchar)) into #abc1 from rs

	--SELECT FirstDay = CONVERT(VARCHAR(10), FirstDay, 103), LastDay = CONVERT(VARCHAR(10), DATEADD(Q, 1, FirstDay) - 1, 103) FROM #abc1
	SELECT FirstDay = CONVERT(VARCHAR(10), FirstDay, 103), LastDay = CONVERT(VARCHAR(10), DATEADD(M, 1, FirstDay) - 1, 103) FROM #abc1
END

GO
