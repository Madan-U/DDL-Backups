-- Object: PROCEDURE dbo.rpt_traderwiseclient
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_traderwiseclient    Script Date: 20-Mar-01 11:43:36 PM ******/

/* report : branchacc 
   file :  traderwiseclient.asp*/
/* displays balances of all accounts of a trader */
CREATE PROCEDURE rpt_traderwiseclient 
@statusid varchar(15),
@statusname varchar(25),
@trader varchar(15),
@branch varchar(7)
 AS
/*
if @statusid='branch'
begin
select l.cltcode , c1.cl_code, Amount = ( select isnull(sum(vamt),0) from ledger where drcr = 'D' and cltcode = l.cltcode) 
- (select isnull(sum(vamt),0) from ledger where drcr = 'C' and cltcode = l.cltcode) From Ledger l , msajag.dbo.client1 c1,
msajag.dbo.client2 c2, msajag.dbo.branches b
where l.cltcode=c2.party_code and c1.cl_code=c2.cl_code and c1.trader=b.short_name and b.branch_cd=@statusname
and c1.trader=@trader
group by  c1.cl_code,l.Cltcode
order by l.cltcode
end 
if @statusid='broker'
begin
select l.cltcode , c1.cl_code, Amount = ( select isnull(sum(vamt),0) from ledger where drcr = 'D' and cltcode = l.cltcode) 
- (select isnull(sum(vamt),0) from ledger where drcr = 'C' and cltcode = l.cltcode) From Ledger l , msajag.dbo.client1 c1,
msajag.dbo.client2 c2, msajag.dbo.branches b
where l.cltcode=c2.party_code and c1.cl_code=c2.cl_code and c1.trader=b.short_name and b.branch_cd=@branch
and c1.trader=@trader
group by  c1.cl_code,l.Cltcode
order by l.cltcode
end
*/
	if @statusid='broker'
	begin
		select CltCode,Cl_Code,Amount = sum(Pamt) - sum(Samt) from Rpt_TrdLedger
		where branch_cd = @branch  and trader = @trader
		group by CltCode,Cl_Code
		order by cltcode
	end

	if @statusid='branch'
	begin
		select CltCode,Cl_Code,Amount = sum(Pamt) - sum(Samt) from Rpt_TrdLedger
		where branch_cd = @statusname  and trader = @trader
		group by CltCode,Cl_Code
		order by cltcode
	end

GO
