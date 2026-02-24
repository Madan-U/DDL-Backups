-- Object: PROCEDURE dbo.rpt_sbnewdrcr
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_sbnewdrcr    Script Date: 20-Mar-01 11:43:35 PM ******/

/* report: subbrokacc 
   file : sbturn.asp
*/
CREATE PROCEDURE rpt_sbnewdrcr
@statusid varchar(15),
@statusname varchar(25)
AS
	if @statusid='broker'
	begin
		select  sb.sub_broker,l.Cltcode ,Amount = ( select isnull(sum(vamt),0) from ledger where drcr = 'D' and cltcode = l.cltcode) 
		- (select isnull(sum(vamt),0) from ledger where drcr = 'C' and cltcode = l.cltcode) From Ledger l , msajag.dbo.client1 c1,
		msajag.dbo.client2 c2, msajag.dbo.subbrokers sb
		where l.cltcode=c2.party_code and c1.cl_code=c2.cl_code and sb.sub_broker=c1.sub_broker
		group by  sb.sub_broker,l.Cltcode
		ORDER BY sb.sub_broker
	end 

	if @statusid='subbroker'
	begin
		select  sb.sub_broker,l.Cltcode ,Amount = ( select isnull(sum(vamt),0) from ledger where drcr = 'D' and cltcode = l.cltcode) 
		- (select isnull(sum(vamt),0) from ledger where drcr = 'C' and cltcode = l.cltcode) From Ledger l , msajag.dbo.client1 c1,
		msajag.dbo.client2 c2, msajag.dbo.subbrokers sb
		where l.cltcode=c2.party_code and c1.cl_code=c2.cl_code and sb.sub_broker=c1.sub_broker
		and sb.sub_broker=@statusname
		group by  sb.sub_broker,l.Cltcode
		ORDER BY sb.sub_broker
	end

GO
