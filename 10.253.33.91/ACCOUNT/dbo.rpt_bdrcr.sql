-- Object: PROCEDURE dbo.rpt_bdrcr
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_bdrcr    Script Date: 20-Mar-01 11:43:34 PM ******/

/* report : branchacc
   file : branchturn.asp
*/
CREATE PROCEDURE rpt_bdrcr
@statusid  varchar(15),
@statusname varchar(25)
AS 

	if @statusid='broker' 
	begin
		select  b.branch_cd,l.Cltcode ,Amount = ( select isnull(sum(vamt),0) from ledger where drcr = 'D' and cltcode = l.cltcode) 
		- (select isnull(sum(vamt),0) from ledger where drcr = 'C' and cltcode = l.cltcode) From Ledger l , msajag.dbo.client1 c1,
		msajag.dbo.client2 c2, msajag.dbo.branches b
		where l.cltcode=c2.party_code and c1.cl_code=c2.cl_code and c1.trader=b.short_name 
		group by  b.branch_cd,l.Cltcode
		ORDER BY b.branch_cd
	end 
	
	if @statusid='branch' 
	begin
		select  b.branch_cd,l.Cltcode ,Amount = ( select isnull(sum(vamt),0) from ledger where drcr = 'D' and cltcode = l.cltcode) 
		- (select isnull(sum(vamt),0) from ledger where drcr = 'C' and cltcode = l.cltcode) From Ledger l , msajag.dbo.client1 c1,
		msajag.dbo.client2 c2, msajag.dbo.branches b
		where l.cltcode=c2.party_code and c1.cl_code=c2.cl_code and c1.trader=b.short_name and b.branch_cd=@statusname
		group by  b.branch_cd,l.Cltcode
		ORDER BY b.branch_cd
	end

GO
