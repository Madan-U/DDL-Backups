-- Object: PROCEDURE dbo.rpt_bsenewbdrcr
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_bsenewbdrcr    Script Date: 01/04/1980 1:40:40 AM ******/



/****** Object:  Stored Procedure dbo.rpt_bsenewbdrcr    Script Date: 11/28/2001 12:23:48 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bsenewbdrcr    Script Date: 29-Sep-01 8:12:06 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bsenewbdrcr    Script Date: 8/8/01 1:37:31 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bsenewbdrcr    Script Date: 8/7/01 6:03:51 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bsenewbdrcr    Script Date: 7/8/01 3:22:50 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bsenewbdrcr    Script Date: 2/17/01 3:34:17 PM ******/


/****** Object:  Stored Procedure dbo.rpt_bsenewbdrcr    Script Date: 20-Mar-01 11:43:35 PM ******/

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
- (select isnull(sum(vamt),0) from ledger where drcr = 'C' and cltcode = l.cltcode) From Ledger l , MSAJAG.DBO.client1 c1,
MSAJAG.DBO.client2 c2, MSAJAG.DBO.branches b
where l.cltcode=c2.party_code and c1.cl_code=c2.cl_code and c1.trader=b.short_name 
group by  b.branch_cd,l.Cltcode
ORDER BY b.branch_cd
end 
if @statusid='branch' 
begin
select  b.branch_cd,l.Cltcode ,Amount = ( select isnull(sum(vamt),0) from ledger where drcr = 'D' and cltcode = l.cltcode) 
- (select isnull(sum(vamt),0) from ledger where drcr = 'C' and cltcode = l.cltcode) From Ledger l , MSAJAG.DBO.client1 c1,
MSAJAG.DBO.client2 c2, MSAJAG.DBO.branches b
where l.cltcode=c2.party_code and c1.cl_code=c2.cl_code and c1.trader=b.short_name and b.branch_cd=@statusname
group by  b.branch_cd,l.Cltcode
ORDER BY b.branch_cd
end 
*/
CREATE PROCEDURE rpt_bsenewbdrcr 
@statusid varchar(15),
@statusname varchar(25)
AS
if @statusid='broker'
begin
select b.branch_cd,Cltcode,Amount=Sum(DAmt)-Sum(CAmt) 
from LedgerDrCrView l, bsedb.dbo.client1 c1,
bsedb.dbo.client2 c2, bsedb.dbo.branches b
where C2.Party_Code = l.CltCode and c1.cl_code=c2.cl_code and c1.trader=b.short_name 
Group By b.branch_cd,CltCode
ORDER BY B.Branch_Cd,cltcode
end
if @statusid='branch'
begin
select b.branch_cd,Cltcode,Amount=Sum(DAmt)-Sum(CAmt) 
from LedgerDrCrView l, bsedb.dbo.client1 c1,
bsedb.dbo.client2 c2, bsedb.dbo.branches b
where C2.Party_Code = l.CltCode and c1.cl_code=c2.cl_code and c1.trader=b.short_name 
and b.branch_cd=@statusname
Group By b.branch_cd,CltCode
ORDER BY B.Branch_Cd,cltcode
end

GO
