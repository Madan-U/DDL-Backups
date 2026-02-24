-- Object: PROCEDURE dbo.rpt_newbdrcr
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_newbdrcr    Script Date: 7/8/01 3:28:45 PM ******/


/****** Object:  Stored Procedure dbo.rpt_newbdrcr    Script Date: 2/17/01 5:19:51 PM ******/


/****** Object:  Stored Procedure dbo.rpt_newbdrcr    Script Date: 3/21/01 12:50:21 PM ******/

/****** Object:  Stored Procedure dbo.rpt_newbdrcr    Script Date: 20-Mar-01 11:39:01 PM ******/


/*Modified by amolika on 1st march'2001 : removed newmsajag.dbo. & added account.dbo. for all accounts tables*/

/*  report : branchaccounts
    file : branchturn.asp   
*/
/* calculates balances of branchwise all client's accounts */      
/*
old query
rpt_bdrcr
if @statusid='broker' 
begin
select  b.branch_cd,l.Cltcode ,Amount = ( select isnull(sum(vamt),0) from ledger where drcr = 'D' and cltcode = l.cltcode) 
- (select isnull(sum(vamt),0) from ledger where drcr = 'C' and cltcode = l.cltcode) From Ledger l , newmsajag.dbo.client1 c1,
msajag.dbo.client2 c2, newmsajag.dbo.branches b
where l.cltcode=c2.party_code and c1.cl_code=c2.cl_code and c1.trader=b.short_name 
group by  b.branch_cd,l.Cltcode
ORDER BY b.branch_cd
end 
if @statusid='branch' 
begin
select  b.branch_cd,l.Cltcode ,Amount = ( select isnull(sum(vamt),0) from ledger where drcr = 'D' and cltcode = l.cltcode) 
- (select isnull(sum(vamt),0) from ledger where drcr = 'C' and cltcode = l.cltcode) From Ledger l , newmsajag.dbo.client1 c1,
msajag.dbo.client2 c2, newmsajag.dbo.branches b
where l.cltcode=c2.party_code and c1.cl_code=c2.cl_code and c1.trader=b.short_name and b.branch_cd=@statusname
group by  b.branch_cd,l.Cltcode
ORDER BY b.branch_cd
end 
*/

CREATE PROCEDURE rpt_newbdrcr 
@statusid varchar(15),
@statusname varchar(25)
AS
 if @statusid='broker'
 begin
  select b.branch_cd,Cltcode,Amount=Sum(DAmt)-Sum(CAmt) from LedgerDrCrView l, client1 c1,
 client2 c2, branches b
  where C2.Party_Code = l.CltCode and c1.cl_code=c2.cl_code and c1.trader=b.short_name 
  Group By b.branch_cd,CltCode
  ORDER BY B.Branch_Cd,cltcode
 end
 if @statusid='branch'
 begin
  select b.branch_cd,Cltcode,Amount=Sum(DAmt)-Sum(CAmt) from LedgerDrCrView l, client1 c1,
  client2 c2,  branches b
  where C2.Party_Code = l.CltCode and c1.cl_code=c2.cl_code and c1.trader=b.short_name 
  and b.branch_cd=@statusname
  Group By b.branch_cd,CltCode
  ORDER BY B.Branch_Cd,cltcode
 end

GO
