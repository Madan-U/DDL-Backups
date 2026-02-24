-- Object: PROCEDURE dbo.rpt_openingbalbr1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

/* report : allpartyledger
    file : ledgerview
    finds opening balance on first day of current financial year for a party for a particular branch
*/
/* changed by  mousami on  11 feb 2002
    replaced vamt field with camt as we want to know only about a particular  branch
*/


CREATE PROCEDURE  rpt_openingbalbr1
@vdt varchar(12),
@partycode varchar(10),
@costname varchar(10)
AS
	select VDT , l.vtyp,l.vno,l.lno,l2.drcr,
	vamt=camt, balamt,Vdesc,
	 nar=isnull((case when (select l3.narr from account.dbo.ledger3 l3  where L.VTYP = L3.VTYP AND L.VNO = L3.VNO and l.booktype = l3.booktype AND l.lno = l3.naratno) is  not null
		               then (select l3.narr from account.dbo.ledger3 l3  where L.VTYP = L3.VTYP AND L.VNO = L3.VNO and l.booktype = l3.booktype  AND l.lno = l3.naratno) 
		               else (select l3.narr from account.dbo.ledger3 l3  where L.VTYP = L3.VTYP AND L.VNO = L3.VNO and l.booktype = l3.booktype and l3.naratno=0 ) 
		               end),''),
	 edt, edtdiff=datediff(d, l.edt , getdate() ) 
	 from account.dbo.ledger l, account.dbo.vmast v,  account.dbo.ledger2 l2, account.dbo.costmast c , account.dbo.category ct
	 where  vdt  like  ltrim(@vdt) + '%'  and   vtyp='18'
	 and l.cltcode = @partycode and l.vtyp=v.vtype 
	and l.vtyp=v.vtype and
	l2.vtype=l.vtyp and
	l2.vno=l.vno and
	l2.lno=l.lno and
	l2.booktype=l.booktype and ct.category='branch'
	and c.costcode=l2.costcode and c.costname = @costname
	 order by vdt, l2.drcr,l.vtyp

GO
