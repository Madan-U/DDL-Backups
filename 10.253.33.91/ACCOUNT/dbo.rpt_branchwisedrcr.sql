-- Object: PROCEDURE dbo.rpt_branchwisedrcr
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_branchwisedrcr    Script Date: 01/04/1980 1:40:39 AM ******/



/****** Object:  Stored Procedure dbo.rpt_branchwisedrcr    Script Date: 11/28/2001 12:23:47 PM ******/



/*
modified by neelambari on 22 oct 2001
changed datatype for date as datetime

This gives us the total debit and credit of all branch_cd's
from the opening entry date till end date
if the selected yr is current year the nrecords till todays date are shown

*/
CREATE proc rpt_branchwisedrcr
@sortbydate varchar(12),
@statusid varchar(12),
@statusname varchar(25),
@openentrydate datetime ,
@enddate datetime
as
if @sortbydate ='vdt'
begin
if @statusid ='broker'
begin
	select 
	br.branch_cd,
	drtotal=isnull((case drcr when 'd' then sum(vamt) end),0),
	crtotal=isnull((case drcr when 'c' then sum(vamt) end),0) ,
	cltcode 
	from account.dbo.ledger l ,client1 c1 ,client2 c2,branches br
	where c1.cl_code =c2.cl_code
	and c2.party_code = l.cltcode
	and l.vdt >= @openentrydate
	and l.vdt <= @enddate+ ' 23:59:59'
	and br.short_name =c1.trader
	group by br.branch_cd ,cltcode ,l.drcr
	order by br.branch_cd ,cltcode ,l.drcr
end

if @statusid ='branch'
begin
	select 
	br.branch_cd,
	drtotal=isnull((case drcr when 'd' then sum(vamt) end),0),
	crtotal=isnull((case drcr when 'c' then sum(vamt) end),0) ,
	cltcode 
	from account.dbo.ledger l ,client1 c1 ,client2 c2,branches br
	where c1.cl_code =c2.cl_code
	and c2.party_code = l.cltcode
	and l.vdt >= @openentrydate
	and l.vdt <= @enddate+ ' 23:59:59'
	and br.short_name =c1.trader
	and br.branch_cd =@statusname
	group by br.branch_cd ,cltcode ,l.drcr
	order by br.branch_cd ,cltcode ,l.drcr
end
end

if @sortbydate ='edt'
begin
if @statusid ='broker'
begin
	select 
	br.branch_cd,
	drtotal=isnull((case drcr when 'd' then sum(vamt) end),0),
	crtotal=isnull((case drcr when 'c' then sum(vamt) end),0) ,
	cltcode 
	from account.dbo.ledger l ,client1 c1 ,client2 c2,branches br
	where c1.cl_code =c2.cl_code
	and c2.party_code = l.cltcode
	and l.edt >= @openentrydate
	and l.edt <= @enddate+ ' 23:59:59'
	and br.short_name =c1.trader
	group by br.branch_cd ,cltcode ,l.drcr
	order by br.branch_cd ,cltcode ,l.drcr
end

if @statusid ='branch'
begin
	select 
	br.branch_cd,
	drtotal=isnull((case drcr when 'd' then sum(vamt) end),0),
	crtotal=isnull((case drcr when 'c' then sum(vamt) end),0) ,
	cltcode 
	from account.dbo.ledger l ,client1 c1 ,client2 c2,branches br
	where c1.cl_code =c2.cl_code
	and c2.party_code = l.cltcode
	and l.edt >= @openentrydate
	and l.edt <= @enddate+ ' 23:59:59'
	and br.short_name =c1.trader
	and br.branch_cd =@statusname
	group by br.branch_cd ,cltcode ,l.drcr
	order by br.branch_cd ,cltcode ,l.drcr
end

end

GO
