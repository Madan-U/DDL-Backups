-- Object: PROCEDURE dbo.rpt_detailledger
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_detailledger    Script Date: 7/8/01 3:28:40 PM ******/

/* Modified by VNS on 16-08-2001
    to change query for narration, now a single line will be returned for single/multiple narration lines per voucher.
*/

/*Modified by amolika on 1st march'2001 : removed newmsajag.dbo. & added account.dbo. to all accounts report*/
/* report :confirmation report
   file : tconfirmation.asp
   report :  traderledger
   file : allparty.asp
*/
/*displays detail ledger */
/* changed by  mousami on 26/03/2001
    added edt column to query and also a fuction which checks difference between edt and today's date
*/


CREATE PROCEDURE rpt_detailledger
@acname varchar(35)
AS
select convert(varchar,l.vdt,103), c2.party_code, vdesc,
dramt=isnull((case drcr when 'd' then vamt end),0), 
cramt=isnull((case drcr when 'c' then vamt end),0),
l.vamt, balamt,vtyp, vno,lno,drcr,
nar=isnull((case when (select l3.narr from account.dbo.ledger3 l3 where l3.vtyp=l.vtyp  and l3.vno = l.vno and l.lno = l3.naratno) is not null
		then (select l3.narr from account.dbo.ledger3 l3 where l3.vtyp=l.vtyp  and l3.vno = l.vno and l.lno = l3.naratno)
		else (select l3.narr from account.dbo.ledger3 l3 where l3.vtyp=l.vtyp  and l3.vno = l.vno)
	end),''),
/* 
nar=isnull((select l3.narr from account.dbo.ledger3 l3 where l3.vtyp=l.vtyp  and l3.vno = l.vno), '') ,l.edt, 
*/
edtdiff=datediff(d, l.edt , getdate() ) 
from account.dbo.ledger l, account.dbo.vmast, client2 c2, client1 c1 
where l.acname = c1.short_Name and c1.cl_code = c2.cl_code and 
c2.party_code=l.cltcode and vtyp=vtype 
and l.acname =@acname
order by l.vdt

GO
