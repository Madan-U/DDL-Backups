-- Object: PROCEDURE dbo.rpt_openingbalbr
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE PROCEDURE  rpt_openingbalbr
@vdt varchar(12),
@partycode varchar(10)
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
	and c.costcode=l2.costcode 
	 order by vdt, l2.drcr,l.vtyp

GO
