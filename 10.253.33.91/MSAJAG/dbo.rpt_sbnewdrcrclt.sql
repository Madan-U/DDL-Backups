-- Object: PROCEDURE dbo.rpt_sbnewdrcrclt
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

/****** Object:  Stored Procedure dbo.rpt_sbnewdrcrclt    Script Date: 01/04/1980 1:40:42 AM ******/



/****** Object:  Stored Procedure dbo.rpt_sbnewdrcrclt    Script Date: 11/28/2001 12:23:50 PM ******/



/*
Modified by neelambari on 24 oct 2001
changed date format to datetime from varchar

Modified by neelambari  on 3 sept 2001
made changes for sortbydate = vdt/edt as cosen by the user
*/

/*
report : Subbroker ACCOUNTs
this procedure gives us list of subbrokers , clients of each and their debit and credit totals
for selected financial year
if selected financial year is current year then the report shows records from 
the begining of current year till today's date

*/
CREATE proc rpt_sbnewdrcrclt 
@sortbydate varchar(12),
@statusid varchar(15),
@statusname varchar(25),
@stdate datetime ,
@enddate  datetime
as

if @sortbydate = 'vdt'
begin

if @statusid = 'broker'
begin
	select sb.sub_broker , drtotal=isnull((case drcr when 'd' then sum(vamt) end),0),
	crtotal=isnull((case drcr when 'c' then sum(vamt) end),0) ,l.cltcode
	from ACCOUNT.dbo.ledger l ,client1 c1 , client2 c2 ,subbrokers sb
	WHERE
	c1.cl_code =c2.cl_code
	and c2.party_code = l.cltcode
	and c1.sub_broker = sb.sub_broker
	and vdt >= @stdate 
	and VDT <= @enddate + ' 23:59:59' 
	group by sb.sub_broker ,cltcode ,l.drcr
	order by sb.sub_broker ,cltcode ,l.drcr
end


if @statusid = 'branch'
begin
/*
commented by sirsabesan to as branch code was displayed instead of subbroker name
	select sub_broker=a.branchcode , drtotal=isnull((case drcr when 'd' then sum(vamt) end),0),
	crtotal=isnull((case drcr when 'c' then sum(vamt) end),0) ,l.cltcode
	from ACCOUNT.dbo.ledger l ,ACCOUNT.dbo.acmast a
	WHERE
	a.cltcode=l.cltcode and 
	a.branchcode =  @statusname
	and vdt >= @stdate 
	and VDT <= @enddate + ' 23:59:59' 
	group by a.branchcode ,l.cltcode ,l.drcr
	order by a.branchcode ,l.cltcode ,l.drcr
*/

	select sb.sub_broker , drtotal=isnull((case drcr when 'd' then sum(vamt) end),0),
	crtotal=isnull((case drcr when 'c' then sum(vamt) end),0) ,l.cltcode
	from account.dbo.ledger l ,account.dbo.acmast a  , client1 c1 , client2 c2 ,subbrokers sb
	WHERE
	a.cltcode=l.cltcode 
	and c1.cl_code =c2.cl_code
	and c2.party_code = l.cltcode
	and c1.sub_broker = sb.sub_broker
	and a.branchcode =  @statusname
	and vdt >= @stdate 
	and VDT <= @enddate + ' 23:59:59' 
	group by sb.sub_broker  ,l.cltcode ,l.drcr
	order by sb.sub_broker   ,l.cltcode ,l.drcr


end


if @statusid = 'subbroker'
begin
	select sb.sub_broker , drtotal=isnull((case drcr when 'd' then sum(vamt) end),0),
	crtotal=isnull((case drcr when 'c' then sum(vamt) end),0) ,l.cltcode
	from ACCOUNT.dbo.ledger l ,client1 c1 , client2 c2 ,subbrokers sb
	WHERE
	c1.cl_code =c2.cl_code
	and c2.party_code = l.cltcode
	and c1.sub_broker = sb.sub_broker
	and c1.sub_broker = @statusname
	and vdt >= @stdate 
	and VDT <= @enddate+   ' 23:59:59'
	group by sb.sub_broker ,cltcode ,l.drcr
	order by sb.sub_broker ,cltcode ,l.drcr


end

end

/*the part below is executed if sort by date = edt*/

if @sortbydate = 'edt'
begin

if @statusid = 'broker'
begin
	select sb.sub_broker , drtotal=isnull((case drcr when 'd' then sum(vamt) end),0),
	crtotal=isnull((case drcr when 'c' then sum(vamt) end),0) ,l.cltcode
	from ACCOUNT.dbo.ledger l ,client1 c1 , client2 c2 ,subbrokers sb
	WHERE
	c1.cl_code =c2.cl_code
	and c2.party_code = l.cltcode
	and c1.sub_broker = sb.sub_broker
	and edt >= @stdate 
	and edt <= @enddate +  ' 23:59:59'
	group by sb.sub_broker ,cltcode ,l.drcr
	order by sb.sub_broker ,cltcode ,l.drcr
end


if @statusid = 'branch'
begin
/*
commented by sirsabesan to as branch code was displayed instead of subbroker name
	select sub_broker=a.branchcode , drtotal=isnull((case drcr when 'd' then sum(vamt) end),0),
	crtotal=isnull((case drcr when 'c' then sum(vamt) end),0) ,l.cltcode
	from ACCOUNT.dbo.ledger l ,ACCOUNT.dbo.acmast a
	WHERE
	a.cltcode=l.cltcode and 
	a.branchcode =  @statusname
	and vdt >= @stdate 
	and VDT <= @enddate + ' 23:59:59' 
	group by a.branchcode ,l.cltcode ,l.drcr
	order by a.branchcode ,l.cltcode ,l.drcr
*/

	select sb.sub_broker , drtotal=isnull((case drcr when 'd' then sum(vamt) end),0),
	crtotal=isnull((case drcr when 'c' then sum(vamt) end),0) ,l.cltcode
	from account.dbo.ledger l ,account.dbo.acmast a  , client1 c1 , client2 c2 ,subbrokers sb
	WHERE
	a.cltcode=l.cltcode 
	and c1.cl_code =c2.cl_code
	and c2.party_code = l.cltcode
	and c1.sub_broker = sb.sub_broker
	and a.branchcode =  @statusname
	and edt >= @stdate 
	and edt <= @enddate + ' 23:59:59' 
	group by sb.sub_broker  ,l.cltcode ,l.drcr
	order by sb.sub_broker   ,l.cltcode ,l.drcr


end



if @statusid = 'subbroker'
begin
	select sb.sub_broker , drtotal=isnull((case drcr when 'd' then sum(vamt) end),0),
	crtotal=isnull((case drcr when 'c' then sum(vamt) end),0) ,l.cltcode
	from ACCOUNT.dbo.ledger l ,client1 c1 , client2 c2 ,subbrokers sb
	WHERE
	c1.cl_code =c2.cl_code
	and c2.party_code = l.cltcode
	and c1.sub_broker = sb.sub_broker
	and c1.sub_broker = @statusname
	and edt >= @stdate 
	and edt <= @enddate+ ' 23:59:59'
	group by sb.sub_broker ,cltcode ,l.drcr
	order by sb.sub_broker ,cltcode ,l.drcr
end

end

GO
