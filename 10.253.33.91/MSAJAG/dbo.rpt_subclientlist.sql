-- Object: PROCEDURE dbo.rpt_subclientlist
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_subclientlist    Script Date: 05/08/2002 12:35:18 PM ******/



/*
Modified by neelambari on 24 oct 2001
changed date format to date time

*/
/*
report : subbroker accounts
this query gives us the debits and credits of all partycodes for a particular subbroker
between the period for selected year
*/

CREATE proc rpt_subclientlist
@sortbydate varchar(12),
@statusid varchar(15),
@statusname varchar(25),
@stdate datetime ,
@enddate datetime ,
@username varchar(25)
as
if @sortbydate ='vdt'
begin
	select c1.cl_code , l.cltcode,c1.Long_name ,drtotal=isnull((case drcr when 'd' then sum(vamt) end),0),
	crtotal=isnull((case drcr when 'c' then sum(vamt) end),0) 
	from account.dbo.ledger l ,client1 c1,client2 c2 ,subbrokers sb
	WHERE 
	c1.cl_code =c2.cl_code
	and c2.party_code = l.cltcode
	and c1.sub_broker = sb.sub_broker
	and c1.sub_broker = @username
	and vdt >= @stdate
	and VDT <= @enddate + ' 23:59:59'
	group by l.cltcode ,c1.cl_code,c1.Long_name ,l.drcr
	order by l.cltcode,c1.cl_code ,l.drcr
end


if @sortbydate ='edt'
begin
	select c1.cl_code , l.cltcode, c1.Long_name,drtotal=isnull((case drcr when 'd' then sum(vamt) end),0),
	crtotal=isnull((case drcr when 'c' then sum(vamt) end),0) 
	from account.dbo.ledger l ,client1 c1,client2 c2 ,subbrokers sb
	WHERE 
	c1.cl_code =c2.cl_code
	and c2.party_code = l.cltcode
	and c1.sub_broker = sb.sub_broker
	and c1.sub_broker = @username
	and edt >= @stdate
	and edt <= @enddate + ' 23:59:59'
	group by l.cltcode ,c1.cl_code,c1.Long_name ,l.drcr
	order by l.cltcode,c1.cl_code ,l.drcr
end

GO
