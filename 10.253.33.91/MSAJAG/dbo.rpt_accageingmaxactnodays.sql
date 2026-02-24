-- Object: PROCEDURE dbo.rpt_accageingmaxactnodays
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_accageingmaxactnodays    Script Date: 01/19/2002 12:15:10 ******/

/****** Object:  Stored Procedure dbo.rpt_accageingmaxactnodays    Script Date: 01/04/1980 5:06:24 AM ******/

CREATE PROCEDURE rpt_accageingmaxactnodays

@maxbal money,
@cltcode varchar(12)

AS

select max(actnodays) from account.dbo.ledger where balamt = @maxbal  and cltcode=@cltcode and balamt >0

GO
