-- Object: PROCEDURE dbo.rpt_sbnewdrcrclt1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_sbnewdrcrclt1    Script Date: 01/19/2002 12:15:16 ******/

/****** Object:  Stored Procedure dbo.rpt_sbnewdrcrclt1    Script Date: 01/04/1980 5:06:27 AM ******/




/*
Modified by neelambari on 20 oct 2001
changed date format to datetime from varchar

Modified by neelambari  on 3 sept 2001
made changes for sortbydate = vdt/edt as cosen by the user
*/
/*
report : Subbroker accounts
this procedure gives us list of subbrokers , clients of each and their debit and credit totals
for selected financial year
if selected financial year is current year then the report shows records from 
the begining of current year till today's date

*/

CREATE proc rpt_sbnewdrcrclt1 
@sortbydate varchar(12),
@statusid varchar(15),
@statusname varchar(25),
@enddate  datetime
as
if @sortbydate ='vdt'
begin
if @statusid = 'broker'
begin
	select sb.sub_broker , drtotal=isnull((case drcr when 'd' then sum(vamt) end),0),
	crtotal=isnull((case drcr when 'c' then sum(vamt) end),0) ,l.cltcode
	from account.dbo.ledger l ,client1 c1 , client2 c2 ,subbrokers sb
	WHERE
	c1.cl_code =c2.cl_code
	and c2.party_code = l.cltcode
	and c1.sub_broker = sb.sub_broker
	and VDT <= @enddate + ' 23:59:59' 
	group by sb.sub_broker ,cltcode ,l.drcr
	order by sb.sub_broker ,cltcode ,l.drcr
end
if @statusid = 'subbroker'
begin
	select sb.sub_broker , drtotal=isnull((case drcr when 'd' then sum(vamt) end),0),
	crtotal=isnull((case drcr when 'c' then sum(vamt) end),0) ,l.cltcode
	from account.dbo.ledger l ,client1 c1 , client2 c2 ,subbrokers sb
	WHERE
	c1.cl_code =c2.cl_code
	and c2.party_code = l.cltcode
	and c1.sub_broker = sb.sub_broker
	and c1.sub_broker = @statusname
	and VDT <= @enddate + ' 23:59:59' 
	group by sb.sub_broker ,cltcode ,l.drcr
	order by sb.sub_broker ,cltcode ,l.drcr
end
end

/* the part below is executed if sortbydate chosen = edt */

if @sortbydate ='edt'
begin
if @statusid = 'broker'
begin
	select sb.sub_broker , drtotal=isnull((case drcr when 'd' then sum(vamt) end),0),
	crtotal=isnull((case drcr when 'c' then sum(vamt) end),0) ,l.cltcode
	from account.dbo.ledger l ,client1 c1 , client2 c2 ,subbrokers sb
	WHERE
	c1.cl_code =c2.cl_code
	and c2.party_code = l.cltcode
	and c1.sub_broker = sb.sub_broker
	and edt <= @enddate +' 23:59:59' 
	group by sb.sub_broker ,cltcode ,l.drcr
	order by sb.sub_broker ,cltcode ,l.drcr
end
if @statusid = 'subbroker'
begin
	select sb.sub_broker , drtotal=isnull((case drcr when 'd' then sum(vamt) end),0),
	crtotal=isnull((case drcr when 'c' then sum(vamt) end),0) ,l.cltcode
	from account.dbo.ledger l ,client1 c1 , client2 c2 ,subbrokers sb
	WHERE
	c1.cl_code =c2.cl_code
	and c2.party_code = l.cltcode
	and c1.sub_broker = sb.sub_broker
	and c1.sub_broker = @statusname
	and edt <= @enddate + ' 23:59:59' 
	group by sb.sub_broker ,cltcode ,l.drcr
	order by sb.sub_broker ,cltcode ,l.drcr
end
end

GO
