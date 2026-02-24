-- Object: PROCEDURE dbo.ProfitandLoss
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.ProfitandLoss    Script Date: 02/15/2002 1:47:19 PM ******/

/****** Object:  Stored Procedure dbo.ProfitandLoss    Script Date: 01/24/2002 12:11:48 PM ******/
CREATE Proc ProfitandLoss
@startdt varchar(11),
@enddt varchar(11),
@flag int,
@costcode smallint
As

if @flag = 0 
begin
	select grpname,a.grpcode,l.acname,l.cltcode ,
	openentry= 0,
	dramt = isnull((select sum(vamt) from ledger  where drcr = 'd' and cltcode = l.cltcode 
	               and vdt >= @startdt and vdt < = @enddt ),0),
	cramt = isnull((select sum(vamt) from ledger  where drcr = 'c' and cltcode = l.cltcode 
	               and vdt >= @startdt and vdt < = @enddt),0)
	from acmast a,ledger l,grpmast g
	where l.cltcode = a.cltcode and  a.grpcode = g.grpcode
	and (a.grpcode like 'N%' or a.grpcode like 'X%' )
	group by  g.grpname,a.grpcode,l.acname,l.cltcode
	order by a.grpcode,l.cltcode
end 

else if @flag = 1
begin

	select grpname,a.grpcode,l.acname,l.cltcode ,
	openentry= 0,
	dramt = isnull((select sum(camt) from ledger  ,ledger2 l2 where l2.drcr = 'd' and cltcode = l.cltcode and vtyp <> 18 
	          		and ledger.vtyp = l2.vtype and ledger.vno = l2.vno  and ledger.lno = l2.lno and ledger.booktype = l2.booktype 
	          		and costcode = @costcode and vdt >= @startdt and vdt < = @enddt ),0),

	cramt = isnull((select sum(camt) from ledger  ,ledger2 l2 where l2.drcr = 'c' and cltcode = l.cltcode and vtyp <> 18
	          		and ledger.vtyp = l2.vtype and ledger.vno = l2.vno  and ledger.lno = l2.lno and ledger.booktype = l2.booktype
	          		and costcode = @costcode and vdt >= @startdt and vdt < = @enddt ),0)

	from acmast a,ledger l,grpmast g
	where l.cltcode = a.cltcode and  a.grpcode = g.grpcode
	and (a.grpcode like 'N%' or a.grpcode like 'X%' )
	group by  g.grpname,a.grpcode,l.acname,l.cltcode
	order by a.grpcode,l.cltcode
	
end

/*
select grpname,a.grpcode,l.acname,l.cltcode ,
openentry=isnull(( select sum(case when drcr ='c' then vamt*-1 else vamt end )from ledger 
		   where cltcode = l.cltcode and vtyp = 18 
		   and vdt >= @startdt and vdt < = @enddt),0),
dramt = isnull((select sum(vamt) from ledger  where drcr = 'd' and cltcode = l.cltcode and vtyp <> 18
	 and vdt >= @startdt and vdt < = @enddt ),0),
cramt = isnull((select sum(vamt) from ledger  where drcr = 'c' and cltcode = l.cltcode and vtyp <> 18
	and vdt >= @startdt and vdt < = @enddt),0)
from acmast a,ledger l,grpmast g
where l.cltcode = a.cltcode and  a.grpcode = g.grpcode
and (a.grpcode like 'N%' or a.grpcode like 'X%' )
group by  g.grpname,a.grpcode,l.acname,l.cltcode
order by a.grpcode,l.cltcode
*/

/*
select grpname,a.grpcode,l.acname,l.cltcode ,
openentry=round(isnull(( select sum(case when drcr ='c' then vamt*-1 else vamt end )from ledger 
		   where cltcode = l.cltcode and vtyp = 18 
		   and vdt >= @startdt and vdt < = @enddt),0),2),
dramt = round(isnull((select sum(vamt) from ledger  where drcr = 'd' and cltcode = l.cltcode and vtyp <> 18
	 and vdt >= @startdt and vdt < = @enddt ),0),2),
cramt = round(isnull((select sum(vamt) from ledger  where drcr = 'c' and cltcode = l.cltcode and vtyp <> 18
	and vdt >= @startdt and vdt < = @enddt),0),2)
from acmast a,ledger l,grpmast g
where l.cltcode = a.cltcode and  a.grpcode = g.grpcode
group by  g.grpname,a.grpcode,l.acname,l.cltcode
order by a.grpcode,l.cltcode
*/

GO
