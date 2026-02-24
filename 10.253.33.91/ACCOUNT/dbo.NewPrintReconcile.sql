-- Object: PROCEDURE dbo.NewPrintReconcile
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.NewPrintReconcile    Script Date: 05/06/2002 3:45:35 PM ******/
/*
Control Name : Print Reconcile
Date : 03/05/2002
Wriiten By : Kalpana
*/
CREATE PROCEDURE  NewPrintReconcile  
@code varchar(10), 
@flag  varchar(1),
@startdate  datetime,
@enddate  datetime
AS
if @flag=1 
begin
	select  isnull(sum(vamt) ,0) ,drcr from ledger 
	where cltcode =    @code  and vdt >= @startdate  and vdt  <= @enddate
	group by drcr
	order  by drcr
end
if @flag=2
begin
	select   tdate=convert(varchar,l.vdt,103),   isnull(ddno,'') ddno   ,   isnull(cltcode ,'') cltcode , isnull( acname ,'') acname, l.drcr,
	Dramt=(case l.drcr when 'd' then vamt  else 0 end ),
	Cramt= (case l.drcr when  'c' then vamt else 0 end ) , 
	treldt=isnull( (select   convert(varchar, reldt , 103) from ledger1 l   
	where 
	l.vtyp =ll1.vtyp and l.vno=ll1.vno and l.booktype = ll1.booktype and l.lno=ll1.lno and l.drcr=ll1.drcr and datepart(year,reldt) <>1900  ) ,'')
	From ledger l  ,LEDGER1 LL1 
	WHERE   l.vtyp in ('2','3','5','16','17','19','20' ) and cltcode <> @code 
/* and l.booktype = ( select booktype from acmast where cltcode = @code ) */
	and l.vtyp =ll1.vtyp and l.vno=ll1.vno and l.booktype = ll1.booktype and l.lno=ll1.lno and l.drcr=ll1.drcr and 
	l.vno in (select vno from ledger l1 where cltcode =  @code  and l.vtyp=l1.vtyp and l.booktype = l1.booktype)
	and ((vdt >= @startdate and vdt <= @enddate) or ( reldt > @startdate and reldt < @enddate ))
	order by   reldt, vdt ,l.vtyp, l.vno 
end

GO
