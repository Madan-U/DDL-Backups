-- Object: PROCEDURE dbo.rpt_detailledger
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_detailledger    Script Date: 20-Mar-01 11:43:35 PM ******/

/* report :confirmation report
   file : tconfirmation.asp
   report :  traderledger
   file : allparty.asp
*/
/*displays detail ledger */
CREATE PROCEDURE rpt_detailledger
@acname varchar(35)
AS

select convert(varchar,l.vdt,103), c2.party_code, vdesc,
dramt=isnull((case drcr when 'd' then vamt end),0), 
cramt=isnull((case drcr when 'c' then vamt end),0),
l.vamt, balamt,vtyp, vno,lno,drcr,
nar=isnull((select l3.narr from ledger3 l3 where l3.vtyp=l.vtyp  and l3.vno = l.vno and naratno = l.lno), '') 
from ledger l, vmast, msajag.dbo.client2 c2, msajag.dbo.client1 c1 
where l.acname = c1.short_Name and c1.cl_code = c2.cl_code and 
c2.party_code=l.cltcode and vtyp=vtype 
and l.acname =@acname
order by l.vdt

/*select convert(varchar,l.vdt,103), c2.party_code, vdesc,
dramt=isnull((case drcr when 'd' then vamt end),0), 
cramt=isnull((case drcr when 'c' then vamt end),0), l.vamt, l.refno, balamt,vtyp, 
nar=isnull((select l3.narr from ledger3 l3 where l3.refno=left(l.refno,7)), '') 
from ledger l, vmast, msajag.dbo.client2 c2, msajag.dbo.client1 c1 
where l.acname = c1.short_Name and c1.cl_code = c2.cl_code and 
c2.party_code=l.cltcode and vtyp=vtype 
and l.acname =@acname
order by l.vdt*/

GO
