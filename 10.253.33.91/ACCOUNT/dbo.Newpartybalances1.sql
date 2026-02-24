-- Object: PROCEDURE dbo.Newpartybalances1
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

/****** Object:  Stored Procedure dbo.Newpartybalances1    Script Date: 04/07/2003 11:55:55 AM ******/
/****** Object:  Stored Procedure dbo.Newpartybalances1    Script Date: 02/18/2003 10:37:39 AM ******/

CREATE Procedure Newpartybalances1
@fromparty varchar(10),
@toparty varchar(10),	
@opendate varchar(11),
@fromdt varchar(11),
@todate varchar(11),
@reporttype varchar(30),
@sessionid varchar(30),
@branchcode varchar(10)

as

declare 
@@balcur as cursor,
@@baldate as datetime,
@@enddate as datetime


set nocount on

delete   from temppartybalances1 where rtrim(sessionid) = rtrim(@sessionid)

select @@baldate = @fromdt + ' 23:59'
select @@enddate = @todate + ' 23:59'

if upper(rtrim(@reporttype)) = "PARTY"
begin
print 'I am in PARTY'
   while @@baldate <= @@enddate
   begin
	select @@baldate

	insert into temppartybalances1
	select l.cltcode,@@baldate,sum( case when upper(drcr) = 'D' then vamt else -vamt end), @sessionid
	from ledger l, acmast a where edt >= @opendate + ' 00:00' and edt <= @@baldate 
	and l.cltcode = a.cltcode and a.accat = 4 and a.cltcode >= @fromparty and a.cltcode <= @toparty
	and a.branchcode like rtrim(@branchcode) + '%'
	group by l.cltcode
	order by l.cltcode

        select @@baldate = dateadd(day,1,@@baldate)

   end
end
else if upper(rtrim(@reporttype)) = "FAMILY"
begin
print 'I am in FAMILY'
   while @@baldate <= @@enddate
   begin
	select @@baldate

	insert into temppartybalances1
	select c.family, @@baldate,sum( case when upper(drcr) = 'D' then vamt else -vamt end), @sessionid
	from ledger l, msajag.dbo.clientmaster c where edt >= @opendate + ' 00:00' and edt <= @@baldate 
	and l.cltcode = c.party_code and c.family >= @fromparty and c.family <= @toparty
	and c.Branch_cd like rtrim(@branchcode) + '%'
	group by c.family
	order by c.family

        select @@baldate = dateadd(day,1,@@baldate)

   end
end
else if upper(rtrim(@reporttype)) = "FAMILYPARTY"
begin
print 'I am in FAMILYPARTY'
   while @@baldate <= @@enddate
   begin
	select @@baldate

	insert into temppartybalances1
	select l.cltcode,@@baldate,sum( case when upper(drcr)  = 'D' then vamt else -vamt end), @sessionid
	from ledger l, msajag.dbo.clientmaster c  where edt >= @opendate + ' 00:00' and edt <= @@baldate 
	and l.cltcode = c.party_code and c.family >= @fromparty and c.family <= @toparty
	and c.Branch_cd like rtrim(@branchcode) + '%'
	group by l.cltcode
	order by l.cltcode

        select @@baldate = dateadd(day,1,@@baldate)

   end
end

GO
