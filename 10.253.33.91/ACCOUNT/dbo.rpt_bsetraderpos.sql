-- Object: PROCEDURE dbo.rpt_bsetraderpos
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_bsetraderpos    Script Date: 01/04/1980 1:40:40 AM ******/



/****** Object:  Stored Procedure dbo.rpt_bsetraderpos    Script Date: 11/28/2001 12:23:48 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bsetraderpos    Script Date: 29-Sep-01 8:12:06 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bsetraderpos    Script Date: 8/8/01 1:37:32 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bsetraderpos    Script Date: 8/7/01 6:03:51 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bsetraderpos    Script Date: 7/8/01 3:22:50 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bsetraderpos    Script Date: 2/17/01 3:34:17 PM ******/


/****** Object:  Stored Procedure dbo.rpt_bsetraderpos    Script Date: 20-Mar-01 11:43:35 PM ******/

/* report : branchacc 
   file :   trader.asp
   displays list of traders under a particular branch  
*/
   
CREATE PROCEDURE rpt_bsetraderpos
@br varchar(15)
AS
/*
select  l.Cltcode,c1.cl_code, C1.TRADER ,Amount = ( select isnull(sum(vamt),0) from ledger where drcr = 'D' and cltcode = l.cltcode) 
- (select isnull(sum(vamt),0) from ledger where drcr = 'C' and cltcode = l.cltcode) From Ledger l , MSAJAG.DBO.client1 c1,
MSAJAG.DBO.client2 c2, MSAJAG.DBO.branches b
where l.cltcode=c2.party_code and c1.cl_code=c2.cl_code and c1.trader=b.short_name and b.branch_cd=@br
group by  C1.TRADER,c1.cl_code,l.Cltcode
ORDER BY C1.TRADER,c1.cl_code
*/
select  l.Cltcode,c1.cl_code, C1.TRADER ,Amount=Sum(DAmt)-Sum(CAmt) 
from LedgerDrCrView l , bsedb.dbo.client1 c1,
bsedb.dbo.client2 c2, bsedb.dbo.branches b
where l.cltcode=c2.party_code and c1.cl_code=c2.cl_code and c1.trader=b.short_name and b.branch_cd=@br
group by  C1.TRADER,c1.cl_code,l.Cltcode
ORDER BY C1.TRADER,c1.cl_code

GO
