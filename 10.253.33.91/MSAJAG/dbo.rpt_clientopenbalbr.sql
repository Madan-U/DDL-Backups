-- Object: PROCEDURE dbo.rpt_clientopenbalbr
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/*
   report :  allpartyledger
   file : ledgerview.asp
 
calculates balance till date  for a party of a branch*/

/* ch by mousami on 11 feb 2002 
     replaced vamt with camt from ledger2 as we want to calculate balance for only one branch
     at a time
*/


CREATE  procedure rpt_clientopenbalbr
@todt datetime ,
@cltcode varchar (10),
@sortby varchar(3),
@statusname varchar(25)


AS
if @sortby='vdt' 
begin
	select drtot=isnull((case l2.drcr when 'd' then sum(camt) end),0), 
	crtot=isnull((case l2.drcr when 'c' then sum(camt) end),0) 
	from account.dbo.ledger l, account.dbo.ledger2 l2, account.dbo.costmast c , account.dbo.category ct
	WHERE  VDT < @todt 
	and CLTCODE=@cltcode and 
	c.costcode=l2.costcode and 
	l2.vtype=l.vtyp and
	l2.vno=l.vno and
	l2.lno=l.lno and
	l2.booktype=l.booktype  and ct.category='branch'
	and ct.catcode=c.catcode
	and c.costname=@statusname
	group by l2.drcr 
end 
else
begin
	select drtot=isnull((case l2.drcr when 'd' then sum(vamt) end),0), 
	crtot=isnull((case l2.drcr when 'c' then sum(vamt) end),0) 
	from account.dbo.ledger l, account.dbo.ledger2 l2, account.dbo.costmast c , account.dbo.category ct
	WHERE  edt < @todt 
	and CLTCODE=@cltcode and 
	c.costcode=l2.costcode and 
	l2.vtype=l.vtyp and
	l2.vno=l.vno and
	l2.lno=l.lno and
	l2.booktype=l.booktype  and ct.category='branch'
	and ct.catcode=c.catcode
	and c.costname=@statusname
	group by l2.drcr 

end

GO
