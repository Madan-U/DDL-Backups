-- Object: PROCEDURE dbo.rpt_accageingminbalamt
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_accageingminbalamt    Script Date: 01/19/2002 12:15:10 ******/

/****** Object:  Stored Procedure dbo.rpt_accageingminbalamt    Script Date: 01/04/1980 5:06:24 AM ******/

CREATE PROCEDURE rpt_accageingminbalamt

@actnodays int,
@cltcode varchar(10)
AS

select min(balamt) from account.dbo.ledger where actNodays=@actnodays and cltcode=@cltcode and balamt < 0

GO
