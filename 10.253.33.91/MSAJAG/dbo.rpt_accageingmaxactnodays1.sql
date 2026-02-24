-- Object: PROCEDURE dbo.rpt_accageingmaxactnodays1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_accageingmaxactnodays1    Script Date: 01/19/2002 12:15:10 ******/

/****** Object:  Stored Procedure dbo.rpt_accageingmaxactnodays1    Script Date: 01/04/1980 5:06:24 AM ******/

CREATE PROCEDURE  rpt_accageingmaxactnodays1

@balamt money,
@cltcode varchar(10)

AS

select max(actNoDays) from account.dbo.ledger where balamt = @balamt and cltcode=@cltcode and balamt < 0

GO
