-- Object: PROCEDURE dbo.rpt_traderpos
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_traderpos    Script Date: 20-Mar-01 11:43:36 PM ******/

/* report : branchacc 
   file :   trader.asp
   displays list of traders under a particular branch  
*/
   
CREATE PROCEDURE rpt_traderpos
@br varchar(15)
 AS
/*
select  l.Cltcode,c1.cl_code, C1.TRADER ,Amount = ( select isnull(sum(vamt),0) from ledger where drcr = 'D' and cltcode = l.cltcode) 
- (select isnull(sum(vamt),0) from ledger where drcr = 'C' and cltcode = l.cltcode) From Ledger l , msajag.dbo.client1 c1,
msajag.dbo.client2 c2, msajag.dbo.branches b
where l.cltcode=c2.party_code and c1.cl_code=c2.cl_code and c1.trader=b.short_name and b.branch_cd=@br
group by  C1.TRADER,c1.cl_code,l.Cltcode
ORDER BY C1.TRADER,c1.cl_code
*/
select  l.Cltcode,c1.cl_code, C1.TRADER ,Amount=Sum(DAmt)-Sum(CAmt) from LedgerDrCrView l , msajag.dbo.client1 c1,
msajag.dbo.client2 c2, msajag.dbo.branches b
where l.cltcode=c2.party_code and c1.cl_code=c2.cl_code and c1.trader=b.short_name and b.branch_cd=@br
group by  C1.TRADER,c1.cl_code,l.Cltcode
ORDER BY C1.TRADER,c1.cl_code

GO
