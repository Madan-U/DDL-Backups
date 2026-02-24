-- Object: PROCEDURE dbo.rpt_clientperioddrcrbr
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

/*report : allpartyleder
   file : ledgerview.asp
*/


/*     calculates balance of client for this financial year including opening entry till date */
/* ch by mousami on 11 feb 2002
    replaced vamt with camt
*/


CREATE PROCEDURE rpt_clientperioddrcrbr
@fromdt datetime,
@todt datetime,
@cltcode varchar(10),
@sortby varchar(3),
@statusname varchar(25)


as
if @sortby = 'vdt' 
begin
	select drtot=isnull((case l2.drcr when 'd' then sum(camt) end),0), 
	crtot=isnull((case l2.drcr when 'c' then sum(camt) end),0) 
	from account.dbo.ledger l, account.dbo.ledger2 l2, account.dbo.costmast c , account.dbo.category ct
	WHERE (VDT >=@fromdt AND VDT <=@todt + ' 23:59:59')
	and l2.CLTCODE=@cltcode
 	and  c.costcode=l2.costcode and 
	l2.vtype=l.vtyp and
	l2.vno=l.vno and
	l2.lno=l.lno and
	l2.booktype=l.booktype and  ct.category='branch'
	and ct.catcode=c.catcode
	and c.costname=@statusname
	group by l2.drcr 
end 
else
begin
	select drtot=isnull((case l2.drcr when 'd' then sum(camt) end),0), 
	crtot=isnull((case l2.drcr when 'c' then sum(camt) end),0) 
	from account.dbo.ledger l, account.dbo.ledger2 l2, account.dbo.costmast c , account.dbo.category ct
	WHERE (edt >=@fromdt AND edt <=@todt + ' 23:59:59')
	and l2.CLTCODE=@cltcode
 	and  c.costcode=l2.costcode and 
	l2.vtype=l.vtyp and
	l2.vno=l.vno and
	l2.lno=l.lno and
	l2.booktype=l.booktype and ct.category='branch'
	and ct.catcode=c.catcode
	and c.costname=@statusname
	group by l2.drcr 
end

GO
