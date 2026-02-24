-- Object: PROCEDURE dbo.rpt_accageingupdateaccnodayswithdif
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_accageingupdateaccnodayswithdif    Script Date: 01/19/2002 12:15:10 ******/

/****** Object:  Stored Procedure dbo.rpt_accageingupdateaccnodayswithdif    Script Date: 01/04/1980 5:06:24 AM ******/

/* updates actnodays field with difference between report date and maximum vdt for a cltcode before report date */

CREATE proc rpt_accageingupdateaccnodayswithdif

@reportdate datetime,
@stdate datetime

as

update account.dbo.ledger  set actnodays=datediff(day,vdt,@reportdate) 
 where vdt=(select max(vdt) from account.dbo.ledger l where vdt <=  @reportdate + ' 23:59:59'
	AND vdt >= @stdate and account.dbo.ledger.cltcode=l.cltcode
	group by l.cltcode)

GO
