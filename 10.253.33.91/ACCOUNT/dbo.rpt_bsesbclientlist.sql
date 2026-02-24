-- Object: PROCEDURE dbo.rpt_bsesbclientlist
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_bsesbclientlist    Script Date: 01/04/1980 1:40:40 AM ******/



/****** Object:  Stored Procedure dbo.rpt_bsesbclientlist    Script Date: 11/28/2001 12:23:48 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bsesbclientlist    Script Date: 29-Sep-01 8:12:06 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bsesbclientlist    Script Date: 8/8/01 1:37:32 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bsesbclientlist    Script Date: 8/7/01 6:03:51 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bsesbclientlist    Script Date: 7/8/01 3:22:50 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bsesbclientlist    Script Date: 2/17/01 3:34:17 PM ******/


/****** Object:  Stored Procedure dbo.rpt_bsesbclientlist    Script Date: 20-Mar-01 11:43:35 PM ******/

/* report : subbrokacc
   file : clients.asp
*/
/* displays list of clients and their balances */
CREATE PROCEDURE rpt_bsesbclientlist
@statusid varchar(15),
@statusname varchar(25),
@subbroker varchar(50)
AS
if @statusid='broker'
begin
select l.cltcode , c1.cl_code, Amount = ( select isnull(sum(vamt),0) from ledger where drcr = 'D' and cltcode = l.cltcode) 
- (select isnull(sum(vamt),0) from ledger where drcr = 'C' and cltcode = l.cltcode) 
From Ledger l , bsedb.dbo.client1 c1,
bsedb.dbo.client2 c2, bsedb.dbo.subbrokers sb
where l.cltcode=c2.party_code and c1.cl_code=c2.cl_code and c1.sub_broker=sb.sub_broker and sb.sub_broker=@subbroker
group by  c1.cl_code,l.Cltcode
end
if @statusid='subbroker'
begin
select l.cltcode , c1.cl_code, Amount = ( select isnull(sum(vamt),0) from ledger where drcr = 'D' and cltcode = l.cltcode) 
- (select isnull(sum(vamt),0) from ledger where drcr = 'C' and cltcode = l.cltcode) 
From Ledger l , bsedb.dbo.client1 c1,
bsedb.dbo.client2 c2, bsedb.dbo.subbrokers sb
where l.cltcode=c2.party_code and c1.cl_code=c2.cl_code and c1.sub_broker=sb.sub_broker and sb.sub_broker=@statusname
group by  c1.cl_code,l.Cltcode
end

GO
