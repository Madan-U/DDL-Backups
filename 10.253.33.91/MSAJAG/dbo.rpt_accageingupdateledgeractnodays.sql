-- Object: PROCEDURE dbo.rpt_accageingupdateledgeractnodays
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_accageingupdateledgeractnodays    Script Date: 01/19/2002 12:15:10 ******/

/****** Object:  Stored Procedure dbo.rpt_accageingupdateledgeractnodays    Script Date: 01/04/1980 5:06:24 AM ******/

/* updates  actnodays column  with nodays column  as it is from first day of year till report date */

CREATE PROCEDURE rpt_accageingupdateledgeractnodays

@stdate datetime,
@enddate datetime

AS


update account.dbo.ledger set actnodays=nodays 
where vdt>= @stdate and vdt<=@enddate + ' 23:59:59'

GO
