-- Object: PROCEDURE dbo.rpt_clcodeparties
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_clcodeparties    Script Date: 01/04/1980 1:40:41 AM ******/



/****** Object:  Stored Procedure dbo.rpt_clcodeparties    Script Date: 11/28/2001 12:23:49 PM ******/




/****** Object:  Stored Procedure dbo.rpt_clcodeparties    Script Date: 2/17/01 5:19:40 PM ******/


/****** Object:  Stored Procedure dbo.rpt_clcodeparties    Script Date: 3/21/01 12:50:13 PM ******/

/****** Object:  Stored Procedure dbo.rpt_clcodeparties    Script Date: 20-Mar-01 11:38:54 PM ******/



/* report : traderledger
   file : cumbal1.asp
*/
/* shows party codes  of all accounts of a client */
/*
changed by mousami on 01/03/2001
removed hardcoding 
for sharedatabase and added hardcoding for account databse*/

/* changed by mousami on 09/02/2001 
     addd family login condition
*/

CREATE PROCEDURE rpt_clcodeparties
@clcode varchar(6),
@statusid varchar(15),
@statusname varchar(25)

AS

if @statusid='family'
begin
	select distinct party_code from client2 c2, account.dbo.ledger l,client1 c1, account.dbo.acmast a
	where c1.family=@statusname
	and c2.party_code=l.cltcode 
	and c1.cl_code=c2.cl_code
	and a.cltcode=l.cltcode
	and a.accat=4
end 
else
begin
	select distinct party_code from client2, account.dbo.ledger l,account.dbo. acmast a
	where cl_code=@clcode
	and party_code=l.cltcode 
	and a.cltcode=l.cltcode
	and a.accat=4
end

GO
