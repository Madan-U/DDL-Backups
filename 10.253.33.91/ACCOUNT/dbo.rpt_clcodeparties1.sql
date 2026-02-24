-- Object: PROCEDURE dbo.rpt_clcodeparties1
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_clcodeparties1    Script Date: 01/04/1980 1:40:41 AM ******/



/****** Object:  Stored Procedure dbo.rpt_clcodeparties1    Script Date: 11/28/2001 12:23:49 PM ******/



CREATE PROCEDURE rpt_clcodeparties1
@family varchar(10)

AS

	select distinct party_code from client2 c2, account.dbo.ledger l,client1 c1, account.dbo.acmast a
	where c1.family=@family
	and c2.party_code=l.cltcode 
	and c1.cl_code=c2.cl_code
	and a.cltcode=l.cltcode
	and a.accat=4

GO
