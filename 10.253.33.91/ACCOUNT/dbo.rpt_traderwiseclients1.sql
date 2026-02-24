-- Object: PROCEDURE dbo.rpt_traderwiseclients1
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_traderwiseclients1    Script Date: 01/04/1980 1:40:42 AM ******/



/****** Object:  Stored Procedure dbo.rpt_traderwiseclients1    Script Date: 11/28/2001 12:23:51 PM ******/



/*
modified by neelambari
made changed for sort by date = vdt/edt
*/
/*
This query gives us debit/credit balances of the clients
for a particular trader from the the begining to end date

this query is used if the opening entry date is not found
*/
CREATE procedure rpt_traderwiseclients1 
@sortbydate varchar(12),
@statusid varchar(12),
@statusname varchar(25),
@trader varchar(15),
@enddate varchar(12)
as

if @sortbydate ='vdt'
begin
	select drtotal=isnull((case drcr when 'd' then sum(vamt) end),0),
	crtotal=isnull((case drcr when 'c' then sum(vamt) end),0) ,l.cltcode ,c1.cl_code
	from account.dbo.ledger l ,client1 c1 ,client2 c2 ,branches br
	WHERE 
	c1.cl_code =c2.cl_code
	and c2.party_code = l.cltcode
	and c1.trader =br.short_name
	and c1.trader= @trader
	and VDT <= @enddate+' 23:59'
	group by cltcode ,c1.cl_code ,drcr 
	order by cltcode ,c1.cl_code ,drcr 
end
if @sortbydate ='edt'
begin
	select drtotal=isnull((case drcr when 'd' then sum(vamt) end),0),
	crtotal=isnull((case drcr when 'c' then sum(vamt) end),0) ,l.cltcode ,c1.cl_code
	from account.dbo.ledger l ,client1 c1 ,client2 c2 ,branches br
	WHERE 
	c1.cl_code =c2.cl_code
	and c2.party_code = l.cltcode
	and c1.trader =br.short_name
	and c1.trader= @trader
	and eDT <= @enddate+' 23:59'
	group by cltcode ,c1.cl_code ,drcr 
	order by cltcode ,c1.cl_code ,drcr 
end

GO
