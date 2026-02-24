-- Object: PROCEDURE dbo.rpt_traderposclt1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_traderposclt1    Script Date: 01/19/2002 12:15:16 ******/

/****** Object:  Stored Procedure dbo.rpt_traderposclt1    Script Date: 01/04/1980 5:06:28 AM ******/



/*
modified by neelambari
madechanges for sortbydate =vdt /edt as chosen by user
*/
/*
this query  gives us the trader wise decit and credit of clients
from begining to enddate
this query is used if opening entry date is not found
*/
CREATE  PROCEDURE rpt_traderposclt1
@sortbydate varchar(12),
@enddate datetime,
@branch varchar(3)
AS
if @sortbydate ='vdt' 
begin
	select drtotal=isnull((case drcr when 'd' then sum(vamt) end),0),
	crtotal=isnull((case drcr when 'c' then sum(vamt) end),0) ,l.cltcode,trader=br.short_name
	from account.dbo.ledger l ,client1 c1 ,client2 c2 ,branches br
	WHERE  VDT <= @enddate + ' 23:59:59'
	and c1.cl_code =c2.cl_code
	and c2.party_code =l.cltcode
	and c1.trader =br.short_name
	and br.branch_cd = @branch
	group by br.short_name , l.cltcode ,drcr 
	order by  br.short_name , l.cltcode ,drcr 
end
if @sortbydate ='edt' 
begin
	select drtotal=isnull((case drcr when 'd' then sum(vamt) end),0),
	crtotal=isnull((case drcr when 'c' then sum(vamt) end),0) ,l.cltcode,trader=br.short_name
	from account.dbo.ledger l ,client1 c1 ,client2 c2 ,branches br
	WHERE  eDT <= @enddate+ ' 23:59:59'
	and c1.cl_code =c2.cl_code
	and c2.party_code =l.cltcode
	and c1.trader =br.short_name
	and br.branch_cd = @branch
	group by br.short_name , l.cltcode ,drcr 
	order by  br.short_name , l.cltcode ,drcr 
end

GO
