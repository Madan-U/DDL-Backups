-- Object: PROCEDURE dbo.rpt_traderposclt
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_traderposclt    Script Date: 01/04/1980 1:40:42 AM ******/



/****** Object:  Stored Procedure dbo.rpt_traderposclt    Script Date: 11/28/2001 12:23:51 PM ******/



/*
modified by neelambari
made changes for sortbydate = vdt/edt according to users choice
*/
/*
this query  gives us the trader wise decit and credit of clients
from opening entry to enddate
*/
CREATE PROCEDURE rpt_traderposclt
@sortbydate varchar(12),
@openentrydate datetime ,
@enddate datetime ,
@branch varchar(3)
AS
if @sortbydate ='vdt'
begin
	select drtotal=isnull((case drcr when 'd' then sum(vamt) end),0),
	crtotal=isnull((case drcr when 'c' then sum(vamt) end),0) ,l.cltcode,trader=br.short_name
	from account.dbo.ledger l ,client1 c1 ,client2 c2 ,branches br
	WHERE l.vdt >= @openentrydate 
	and VDT <= @enddate+ ' 23:59:59'
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
	WHERE l.edt >= @openentrydate 
	and edt <= @enddate + + ' 23:59:59'
	and c1.cl_code =c2.cl_code
	and c2.party_code =l.cltcode
	and c1.trader =br.short_name
	and br.branch_cd = @branch
	group by br.short_name , l.cltcode ,drcr 
	order by  br.short_name , l.cltcode ,drcr 
end

GO
