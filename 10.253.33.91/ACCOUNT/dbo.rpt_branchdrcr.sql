-- Object: PROCEDURE dbo.rpt_branchdrcr
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_branchdrcr    Script Date: 20-Mar-01 11:43:34 PM ******/

/* report : banchacc 
   file : branchturn.asp
*/
/*displays debit and credit  and total balances of all branches */
CREATE PROCEDURE  rpt_branchdrcr
@statusid varchar(15),
@statusname varchar(25)
AS
if @statusid='broker' 
begin
select b.branch_cd,amt=sum(vamt),drcr from ledger l, msajag.dbo.client1 c1, msajag.dbo.client2 c2, msajag.dbo.branches b
where l.cltcode=c2.party_code and c1.cl_code=c2.cl_code and c1.trader=b.short_name
group by b.branch_cd,drcr
order by b.branch_cd,drcr
end
if @statusid='branch'
begin
select b.branch_cd,amt=sum(vamt),drcr from ledger l, msajag.dbo.client1 c1, msajag.dbo.client2 c2, msajag.dbo.branches b
where l.cltcode=c2.party_code and c1.cl_code=c2.cl_code and c1.trader=b.short_name
and b.branch_cd=@statusname
group by b.branch_cd,drcr
order by b.branch_cd,drcr
end

GO
