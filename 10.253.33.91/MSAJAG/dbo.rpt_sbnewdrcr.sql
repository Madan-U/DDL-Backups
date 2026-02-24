-- Object: PROCEDURE dbo.rpt_sbnewdrcr
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_sbnewdrcr    Script Date: 04/27/2001 4:32:49 PM ******/

/****** Object:  Stored Procedure dbo.rpt_sbnewdrcr    Script Date: 3/21/01 12:50:23 PM ******/

/****** Object:  Stored Procedure dbo.rpt_sbnewdrcr    Script Date: 20-Mar-01 11:39:03 PM ******/


/*modified by amolika on 1st march'2001 : removed msajag.dbo. & added account.dbo. to all account tables*/
/* report: subbrokacc 
   file : sbturn.asp
*/
CREATE PROCEDURE rpt_sbnewdrcr
@statusid varchar(15),
@statusname varchar(25)
AS
 if @statusid='broker'
 begin
  select  sb.sub_broker,l.Cltcode ,Amount = ( select isnull(sum(vamt),0) from account.dbo.ledger where drcr = 'D' and cltcode = l.cltcode) 
  - (select isnull(sum(vamt),0) from account.dbo.ledger where drcr = 'C' and cltcode = l.cltcode) 
From account.dbo.Ledger l ,client1 c1,
client2 c2, subbrokers sb
  where l.cltcode=c2.party_code and c1.cl_code=c2.cl_code and sb.sub_broker=c1.sub_broker
  group by  sb.sub_broker,l.Cltcode
  ORDER BY sb.sub_broker
 end 
 if @statusid='subbroker'
 begin
  select  sb.sub_broker,l.Cltcode ,Amount = ( select isnull(sum(vamt),0) from account.dbo.ledger where drcr = 'D' and cltcode = l.cltcode) 
  - (select isnull(sum(vamt),0) from account.dbo.ledger where drcr = 'C' and cltcode = l.cltcode) 
From account.dbo.Ledger l ,client1 c1,
client2 c2, subbrokers sb
  where l.cltcode=c2.party_code and c1.cl_code=c2.cl_code and sb.sub_broker=c1.sub_broker
  and sb.sub_broker=@statusname
  group by  sb.sub_broker,l.Cltcode
  ORDER BY sb.sub_broker
 end

GO
