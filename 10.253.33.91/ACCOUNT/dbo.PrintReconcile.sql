-- Object: PROCEDURE dbo.PrintReconcile
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.PrintReconcile    Script Date: 01/04/1980 1:40:38 AM ******/


/****** Object:  Stored Procedure dbo.PrintReconcile    Script Date: 11/28/2001 12:23:45 PM ******/
/****** Object:  Stored Procedure dbo.PrintReconcile    Script Date: 29-Sep-01 8:12:05 PM ******/
/****** Object:  Stored Procedure dbo.PrintReconcile    Script Date: 08/24/2001 6:53:38 PM ******/
/****** Object:  Stored Procedure dbo.PrintReconcile    Script Date: 08/09/2001 2:03:16 AM ******/

/****** Object:  Stored Procedure dbo.PrintReconcile    Script Date: 7/1/01 2:19:43 PM ******/
/****** Object:  Stored Procedure dbo.PrintReconcile    Script Date: 06/28/2001 5:44:45 PM ******/
/****** Object:  Stored Procedure dbo.PrintReconcile    Script Date: 20-Mar-01 11:43:34 PM ******/

CREATE PROCEDURE  PrintReconcile  
@code varchar(10)
, @flag  varchar(1)
,@tdate  datetime
AS
if @flag=1 
begin
	select  isnull(sum(vamt) ,0) ,drcr from ledger 
	where cltcode =    @code    and vdt  <= @tdate
	group by drcr
	order  by drcr
end
if @flag=2
begin
	select   tdate=convert(varchar,l.vdt,103),   isnull(ddno,'') ddno   ,   isnull(cltcode ,'') cltcode , isnull( acname ,'') acname, l.drcr,
	Dramt=(case l.drcr when 'd' then vamt  else 0 end ),
	Cramt= (case l.drcr when  'c' then vamt else 0 end ) , 
	treldt=isnull( (select   convert(varchar, reldt , 103) from ledger1 l   where /*l.refno = ll1.refno*/
			l.vtyp =ll1.vtyp and l.vno=ll1.vno and l.booktype = ll1.booktype and l.lno=ll1.lno and l.drcr=ll1.drcr and datepart(year,reldt) <>1900  ) ,'')
	From ledger l  ,LEDGER1 LL1 
	WHERE   l.vtyp in ('2','3','5','16','17','19','20' ) and cltcode <> @code and l.booktype = ( select booktype from acmast where cltcode = @code )
	/*AND SUBSTRING(LL1.REFNO,1,12)=SUBSTRING(L.REFNO,1,12)  and */
	and l.vtyp =ll1.vtyp and l.vno=ll1.vno and l.booktype = ll1.booktype and l.lno=ll1.lno and l.drcr=ll1.drcr and 
	l.vno in (select vno from ledger l1 where cltcode =  @code  and l.vtyp=l1.vtyp and l.booktype = l1.booktype)
	and  ( reldt ='1900-01-01 00:00:00.000'   or   reldt > @tdate )
	and vdt <=@tdate
	order by   l.drcr  ,  vdt  ,l.vtyp, l.vno 
end

GO
