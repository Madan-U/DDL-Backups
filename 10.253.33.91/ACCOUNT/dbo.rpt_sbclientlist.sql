-- Object: PROCEDURE dbo.rpt_sbclientlist
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_sbclientlist    Script Date: 20-Mar-01 11:43:35 PM ******/

/* report : subbrokacc
   file : clients.asp
*/
/* displays list of clients and their balances */
CREATE PROCEDURE rpt_sbclientlist
@statusid varchar(15),
@statusname varchar(25),
@subbroker varchar(50)
AS
	if @statusid='broker'
	begin
		select l.cltcode , c1.cl_code, Amount = ( select isnull(sum(vamt),0) from ledger where drcr = 'D' and cltcode = l.cltcode) 
		- (select isnull(sum(vamt),0) from ledger where drcr = 'C' and cltcode = l.cltcode) From Ledger l , msajag.dbo.client1 c1,
		msajag.dbo.client2 c2, msajag.dbo.subbrokers sb
		where l.cltcode=c2.party_code and c1.cl_code=c2.cl_code and c1.sub_broker=sb.sub_broker and sb.sub_broker=@subbroker
		group by  c1.cl_code,l.Cltcode
	end

	if @statusid='subbroker'
	begin
		select l.cltcode , c1.cl_code, Amount = ( select isnull(sum(vamt),0) from ledger where drcr = 'D' and cltcode = l.cltcode) 
		- (select isnull(sum(vamt),0) from ledger where drcr = 'C' and cltcode = l.cltcode) From Ledger l , msajag.dbo.client1 c1,
		msajag.dbo.client2 c2, msajag.dbo.subbrokers sb
		where l.cltcode=c2.party_code and c1.cl_code=c2.cl_code and c1.sub_broker=sb.sub_broker and sb.sub_broker=@statusname
		group by  c1.cl_code,l.Cltcode
	end

GO
