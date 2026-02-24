-- Object: PROCEDURE dbo.rpt_bseledger2
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_bseledger2    Script Date: 04/27/2001 4:32:34 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseledger2    Script Date: 3/21/01 12:50:13 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseledger2    Script Date: 20-Mar-01 11:38:54 PM ******/


/*Modified by amolika on 2nd march'2001 : removed bsedb.dbo. & added account.dbo. to all accounts report*/
/* Report : Confirmation Report
   File : Tconfirmationreport.asp
   Displays the dramt, cramt for a particular client
*/
CREATE PROCEDURE rpt_bseledger2
@acname varchar(35)
AS
select convert(varchar,l.vdt,103), c2.party_code, 
vdesc,dramt=isnull((case drcr when 'd' then vamt end),0), 
cramt=isnull((case drcr when 'c' then vamt end),0), l.vamt, 
l.refno, balamt,vtyp, 
nar=isnull((select l3.narr from account.dbo.ledger3 l3 where l3.refno=left(l.refno,7)), '') 
from account.dbo.ledger l, account.dbo.vmast, client2 c2, client1 c1 
where l.acname = c1.short_Name and c1.cl_code = c2.cl_code and c2.party_code=l.cltcode and vtyp=vtype 
and l.acname =@acname
order by l.vdt

GO
