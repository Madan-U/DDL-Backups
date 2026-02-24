-- Object: PROCEDURE dbo.rpt_detailperiodledgerbr
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

/* report : allpartyledger
    file : ledgerview.asp	
*/   
/*
   gives detail ledger for a party for a branch
*/

/* ch by mousami on 11 feb
    replaced vamt with camt
*/

CREATE PROCEDURE rpt_detailperiodledgerbr
@fromdt  datetime,
@todt   datetime,
@partycode varchar(10),
@sortby varchar(4),
@statusname varchar(25)

AS

if @sortby='vdt' 
begin
	select  left(convert(varchar,VDT,103),11), l.vtyp,l.vno,l.lno,l.drcr,
	 dramt=isnull((case l2.drcr when 'd' then camt end),0), 
	 cramt=isnull((case l2.drcr when 'c' then camt end),0), balamt,Vdesc,
	 nar=isnull((select l3.narr from account.dbo.ledger3 l3  where L.VTYP = L3.VTYP AND L.VNO = L3.VNO and l.booktype = l3.booktype AND l3.naratno=1) ,''),
 	 edt, edtdiff=datediff(d, l.edt , getdate() ) ,displayvdt = left(convert(varchar,VDT,109),11) ,bt.description ,bt.booktype
	 from account.dbo.ledger l, account.dbo.vmast v , account.dbo.booktype bt ,account.dbo.ledger2 l2, account.dbo.costmast c , account.dbo.category ct
	 where  l.vdt >= @fromdt and l.vdt<=@todt + ' 23:59:59'
	 and l2.cltcode = @partycode and l.vtyp=v.vtype 
	 and l.vtyp <> '18'
	and l.vtyp = bt.vtyp
	and l.booktype = bt.booktype
	and  c.costcode=l2.costcode and 
	l2.vtype=l.vtyp and
	l2.vno=l.vno and
	l2.lno=l.lno and
	l2.booktype=l.booktype and ct.category='branch'
	and ct.catcode=c.catcode
	and c.costname=@statusname
	 order by l.vdt, l2.drcr,l.vtyp
end
else
begin
	select left( convert(varchar,edt,103),11),l.vtyp,l.vno,l.lno,l.drcr,
	 dramt=isnull((case l2.drcr when 'd' then camt end),0), 
	 cramt=isnull((case l2.drcr when 'c' then camt end),0), balamt,Vdesc,
	nar=isnull((select l3.narr from account.dbo.ledger3 l3  where L.VTYP = L3.VTYP AND L.VNO = L3.VNO and l.booktype = l3.booktype AND l3.naratno=1) ,''),
	edt, edtdiff=datediff(d, l.edt , getdate() )  ,bt.description ,bt.booktype
	 from account.dbo. ledger l, account.dbo.vmast v , account.dbo. booktype bt ,account.dbo.ledger2 l2, account.dbo.costmast c , account.dbo.category ct
	WHERE edt >= @fromdt and edt<=@todt + ' 23:59:59'
	 and l2.CLTCODE=@partycode and l.vtyp=v.vtype 
	 and l.vtyp <> '18'
	and l.vtyp = bt.vtyp
	and l.booktype = bt.booktype
	and  c.costcode=l2.costcode and 
	l2.vtype=l.vtyp and
	l2.vno=l.vno and
	l2.lno=l.lno and
	l2.booktype=l.booktype and ct.category='branch'
	and ct.catcode=c.catcode
	and c.costname=@statusname
                  order by edt, l2.drcr,l.vtyp

end

GO
