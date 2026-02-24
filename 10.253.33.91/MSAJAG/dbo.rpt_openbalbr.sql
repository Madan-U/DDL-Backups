-- Object: PROCEDURE dbo.rpt_openbalbr
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/* report : allpartyledger 
   file : ledgerview.asp
*/

/* calculates opening balance from opening entry till user date for a particular branch */

CREATE PROCEDURE rpt_openbalbr
@fromdt  datetime,
@cltcode varchar(10),
@finstartdt datetime,
@sortby varchar(3),
@statusname varchar(25)

AS

if @sortby='vdt' 

begin
	select drtotal=isnull((case l2.drcr when 'd' then sum(camt) end),0),
	crtotal=isnull((case l2.drcr when 'c' then sum(camt) end),0) 
	from account.dbo.ledger l , account.dbo.ledger2 l2, account.dbo.costmast c , account.dbo.category ct
	WHERE vdt >= @finstartdt  and VDT <  @fromdt  and CLTCODE= @cltcode and
	l2.vtype=l.vtyp and
	l2.vno=l.vno and
	l2.lno=l.lno and
	l2.booktype=l.booktype and ct.category='branch'
	and ct.catcode=c.catcode
	and c.costcode=l2.costcode 
	and c.costname=@statusname
	group by l2.drcr 
end 

else
begin
	select drtotal=isnull((case l2.drcr when 'd' then sum(camt) end),0),
	crtotal=isnull((case l2.drcr when 'c' then sum(camt) end),0) 
	from account.dbo.ledger  l , account.dbo.ledger2 l2, account.dbo.costmast c , account.dbo.category ct
	WHERE edt >= @finstartdt  and edt <  @fromdt  and CLTCODE= @cltcode and
	l2.vtype=l.vtyp and
	l2.vno=l.vno and
	l2.lno=l.lno and
	l2.booktype=l.booktype and ct.category='branch'
	and ct.catcode=c.catcode
	and c.costname=@statusname
	and c.costcode=l2.costcode 
	group by l2.drcr 
end

GO
