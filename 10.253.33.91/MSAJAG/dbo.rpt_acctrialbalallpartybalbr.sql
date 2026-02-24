-- Object: PROCEDURE dbo.rpt_acctrialbalallpartybalbr
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/* report : trial balance */
/* finds total debit and credit of all client accounts as on a particular date */


CREATE PROCEDURE  rpt_acctrialbalallpartybalbr


@vdt  datetime,
@openingentry datetime ,
@sortbydate varchar(3),
@statusname varchar(25)

AS

/*openning entry found */
if @sortbydate='vdt' 
begin
if @openingentry = '' 
begin
	select dramt = ( select isnull(sum(camt),0) from account.dbo.ledger l3, account.dbo.acmast a ,account.dbo.ledger2 l2, account.dbo.costmast c , account.dbo.category ct 
	where l2.drcr = 'D'  and vdt <= @vdt + ' 23:59:59' and a.cltcode=l3.cltcode and a.accat=4  and c.costcode=l2.costcode and 
	l2.vtype=l3.vtyp and
	l2.vno=l3.vno and
	l2.lno=l3.lno and
	l2.booktype=l3.booktype and a.cltcode=l3.cltcode  and c.costname=@statusname
	and ct.category='branch'
	and ct.catcode=c.catcode) ,

	cramt = (select isnull(sum(camt),0) from account.dbo.ledger l3 ,account.dbo.acmast a,account.dbo.ledger2 l2, account.dbo.costmast c , account.dbo.category ct
	where l2.drcr = 'C' and  vdt <= @vdt + ' 23:59:59'  and a.cltcode=l3.cltcode and a.accat=4  and c.costcode=l2.costcode and 
	l2.vtype=l3.vtyp and
	l2.vno=l3.vno and
	l2.lno=l3.lno and
	l2.booktype=l3.booktype and a.cltcode=l3.cltcode  and c.costname=@statusname
	and ct.category='branch'
	and ct.catcode=c.catcode) 

	From account.dbo.Ledger l  ,account.dbo.acmast a,account.dbo.ledger2 l2, account.dbo.costmast c , account.dbo.category ct
	where c.costcode=l2.costcode and 
	l2.vtype=l.vtyp and
	l2.vno=l.vno and
	l2.lno=l.lno and
	l2.booktype=l.booktype and a.cltcode=l.cltcode 
	and ct.category='branch'
	and ct.catcode=c.catcode
	and c.costname=@statusname
	group by l.drcr
	order by l.drcr
end 
else
begin
	select dramt = ( select isnull(sum(camt),0) from account.dbo.ledger l3, account.dbo.acmast a  ,  account.dbo.ledger2 l2, account.dbo.costmast c , account.dbo.category ct 
	where l2.drcr = 'D'  and vdt >= @openingentry  and vdt <= @vdt + ' 23:59:59' and a.cltcode=l3.cltcode and a.accat=4 and vtyp <> '18'  and c.costcode=l2.costcode and 
	l2.vtype=l3.vtyp and
	l2.vno=l3.vno and
	l2.lno=l3.lno and
	l2.booktype=l3.booktype and a.cltcode=l3.cltcode 
	and ct.category='branch' and c.costname=@statusname
	and ct.catcode=c.catcode) ,

	cramt = (select isnull(sum(camt),0) from account.dbo.ledger l3 ,account.dbo.acmast a, account.dbo.ledger2 l2, account.dbo.costmast c , account.dbo.category ct
	where l2.drcr = 'C' and vdt >= @openingentry and   vdt <= @vdt + ' 23:59:59'  and a.cltcode=l3.cltcode and a.accat=4  and vtyp <> '18'  and c.costcode=l2.costcode and 
	l2.vtype=l3.vtyp and
	l2.vno=l3.vno and
	l2.lno=l3.lno and
	l2.booktype=l3.booktype and a.cltcode=l3.cltcode 
	and ct.category='branch' and c.costname=@statusname
	and ct.catcode=c.catcode) 

	From account.dbo.Ledger l   ,account.dbo.acmast a,account.dbo.ledger2 l2, account.dbo.costmast c , account.dbo.category ct
	where c.costname=@statusname
	and  c.costcode=l2.costcode and 
	l2.vtype=l.vtyp and
	l2.vno=l.vno and
	l2.lno=l.lno and
	l2.booktype=l.booktype and a.cltcode=l.cltcode 
	and ct.category='branch'
	and ct.catcode=c.catcode
	group by l.drcr
	order by l.drcr
end
end 
else 
begin
if @openingentry = '' 
begin
	select dramt = ( select isnull(sum(camt),0) from account.dbo.ledger l3, account.dbo.acmast a   ,account.dbo.ledger2 l2, account.dbo.costmast c , account.dbo.category ct 
	where l2.drcr = 'D'  and edt <= @vdt + ' 23:59:59' and a.cltcode=l3.cltcode and a.accat=4  and c.costcode=l2.costcode and 
	l2.vtype=l3.vtyp and
	l2.vno=l3.vno and
	l2.lno=l3.lno and
	l2.booktype=l3.booktype and a.cltcode=l3.cltcode 
	and ct.category='branch' and c.costname=@statusname
	and ct.catcode=c.catcode) ,

	cramt = (select isnull(sum(camt),0) from account.dbo.ledger l3 ,account.dbo.acmast a ,account.dbo.ledger2 l2, account.dbo.costmast c , account.dbo.category ct
	where l2.drcr = 'C' and  edt <= @vdt + ' 23:59:59'  and a.cltcode=l3.cltcode and a.accat=4  and c.costcode=l2.costcode and 
	l2.vtype=l3.vtyp and
	l2.vno=l3.vno and
	l2.lno=l3.lno and
	l2.booktype=l3.booktype and a.cltcode=l3.cltcode 
	and ct.category='branch' and c.costname=@statusname
	and ct.catcode=c.catcode) 
	From account.dbo.Ledger l, account.dbo.acmast a   ,account.dbo.ledger2 l2, account.dbo.costmast c , account.dbo.category ct 
	where c.costcode=l2.costcode and 
	l2.vtype=l.vtyp and
	l2.vno=l.vno and
	l2.lno=l.lno and
	l2.booktype=l.booktype and a.cltcode=l.cltcode 
	and ct.category='branch'
	and ct.catcode=c.catcode
	and c.costname=@statusname
	group by l.drcr
	order by l.drcr
end 
else
begin
	select dramt = ( select isnull(sum(camt),0) from account.dbo.ledger l3, account.dbo.acmast a   ,account.dbo.ledger2 l2, account.dbo.costmast c , account.dbo.category ct 
	where l2.drcr = 'D'  and edt >= @openingentry  and edt <= @vdt + ' 23:59:59' and a.cltcode=l3.cltcode and a.accat=4  and vtyp <> '18'  and  c.costcode=l2.costcode and 
	l2.vtype=l3.vtyp and
	l2.vno=l3.vno and
	l2.lno=l3.lno and
	l2.booktype=l3.booktype and a.cltcode=l3.cltcode 
	and ct.category='branch' and c.costname=@statusname
	and ct.catcode=c.catcode) ,

	cramt = (select isnull(sum(camt),0) from account.dbo.ledger l3 ,account.dbo.acmast a , account.dbo.ledger2 l2, account.dbo.costmast c , account.dbo.category ct
	where l2.drcr = 'C' and edt >= @openingentry and  edt <= @vdt + ' 23:59:59'  and a.cltcode=l3.cltcode and a.accat=4  and vtyp <> '18' and c.costcode=l2.costcode and 
	l2.vtype=l3.vtyp and
	l2.vno=l3.vno and
	l2.lno=l3.lno and
	l2.booktype=l3.booktype and a.cltcode=l3.cltcode 
	and ct.category='branch' and c.costname=@statusname
	and ct.catcode=c.catcode) 
	
	From account.dbo.Ledger l  ,account.dbo.acmast a   ,account.dbo.ledger2 l2, account.dbo.costmast c , account.dbo.category ct 
	where c.costcode=l2.costcode and 
	l2.vtype=l.vtyp and
	l2.vno=l.vno and
	l2.lno=l.lno and
	l2.booktype=l.booktype and a.cltcode=l.cltcode 
	and ct.category='branch'
	and ct.catcode=c.catcode
	and c.costname=@statusname
	group by l.drcr
	order by l.drcr
end

end

GO
