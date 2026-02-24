-- Object: PROCEDURE dbo.rpt_accageingmaxbal
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_accageingmaxbal    Script Date: 01/19/2002 12:15:10 ******/

/****** Object:  Stored Procedure dbo.rpt_accageingmaxbal    Script Date: 01/04/1980 5:06:24 AM ******/

CREATE PROCEDURE rpt_accageingmaxbal

@maxdays1 int,
@cltcode varchar(10)

AS


select max(balamt) from account.dbo.ledger where actnodays=@maxdays1 and cltcode=@cltcode and balamt >0

GO
