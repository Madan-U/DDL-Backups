-- Object: PROCEDURE dbo.rpt_sbclientlist
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_sbclientlist    Script Date: 04/27/2001 4:32:48 PM ******/

/****** Object:  Stored Procedure dbo.rpt_sbclientlist    Script Date: 3/21/01 12:50:23 PM ******/

/****** Object:  Stored Procedure dbo.rpt_sbclientlist    Script Date: 20-Mar-01 11:39:02 PM ******/


/*Modified by amolika on 1st march'2001 : removed msajag.dbo. & added account.dbo. to all account tables*/
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
  select l.cltcode , c1.cl_code, Amount = ( select isnull(sum(vamt),0) from account.dbo.ledger where drcr = 'D' and cltcode = l.cltcode) 
  - (select isnull(sum(vamt),0) from account.dbo.ledger where drcr = 'C' and cltcode = l.cltcode) 
From account.dbo.Ledger l , client1 c1, client2 c2, subbrokers sb
  where l.cltcode=c2.party_code and c1.cl_code=c2.cl_code and c1.sub_broker=sb.sub_broker and sb.sub_broker=@subbroker
  group by  c1.cl_code,l.Cltcode
 end
 if @statusid='subbroker'
 begin
  select l.cltcode , c1.cl_code, Amount = ( select isnull(sum(vamt),0) from account.dbo.ledger where drcr = 'D' and cltcode = l.cltcode) 
  - (select isnull(sum(vamt),0) from account.dbo.ledger where drcr = 'C' and cltcode = l.cltcode) 
From account.dbo.Ledger l , client1 c1, client2 c2, subbrokers sb
  where l.cltcode=c2.party_code and c1.cl_code=c2.cl_code and c1.sub_broker=sb.sub_broker and sb.sub_broker=@statusname
  group by  c1.cl_code,l.Cltcode
 end

GO
