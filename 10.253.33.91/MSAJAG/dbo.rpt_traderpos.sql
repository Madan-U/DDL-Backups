-- Object: PROCEDURE dbo.rpt_traderpos
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_traderpos    Script Date: 01/19/2002 12:15:16 ******/

/****** Object:  Stored Procedure dbo.rpt_traderpos    Script Date: 01/04/1980 5:06:28 AM ******/






/****** Object:  Stored Procedure dbo.rpt_traderpos    Script Date: 09/07/2001 11:09:25 PM ******/

/****** Object:  Stored Procedure dbo.rpt_traderpos    Script Date: 3/23/01 7:59:32 PM ******/

/****** Object:  Stored Procedure dbo.rpt_traderpos    Script Date: 08/18/2001 8:24:29 PM ******/


/****** Object:  Stored Procedure dbo.rpt_traderpos    Script Date: 7/8/01 3:28:48 PM ******/


/****** Object:  Stored Procedure dbo.rpt_traderpos    Script Date: 2/17/01 5:19:55 PM ******/


/****** Object:  Stored Procedure dbo.rpt_traderpos    Script Date: 3/21/01 12:50:24 PM ******/

/****** Object:  Stored Procedure dbo.rpt_traderpos    Script Date: 20-Mar-01 11:39:04 PM ******/


/*modified by amolika on 1st march'2001 : removed msajag.dbo. & added account.dbo. for all the account tables*/
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
select  l.Cltcode,c1.cl_code, C1.TRADER ,Amount=Sum(DAmt)-Sum(CAmt) from LedgerDrCrView l , client1 c1,
client2 c2, branches b
where l.cltcode=c2.party_code and c1.cl_code=c2.cl_code and c1.trader=b.short_name and b.branch_cd=@br
group by  C1.TRADER,c1.cl_code,l.Cltcode
ORDER BY C1.TRADER,c1.cl_code

GO
