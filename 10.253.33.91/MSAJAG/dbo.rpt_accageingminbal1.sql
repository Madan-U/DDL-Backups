-- Object: PROCEDURE dbo.rpt_accageingminbal1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_accageingminbal1    Script Date: 01/19/2002 12:15:10 ******/

/****** Object:  Stored Procedure dbo.rpt_accageingminbal1    Script Date: 01/04/1980 5:06:24 AM ******/

CREATE PROCEDURE  rpt_accageingminbal1

@cltcode varchar(10),
@userdate datetime


AS

select convert(money,isnull(min(balamt),0)) from account.dbo.ledger where cltcode=@cltcode and balamt<0  and vdt<= @userdate + ' 23:59:59'

GO
