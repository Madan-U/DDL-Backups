-- Object: PROCEDURE dbo.UtilityJobsHistory
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

/*
This SP has 2 functions.
a) if @method='duration' gives the average run duration in minutes for successful jobs
b) if @method='failures' displays failures/cancels/still executing jobs
It defaults to today's date. Specify @xdate for a different date
-- Louis Nguyen
*/

CREATE PROCEDURE UtilityJobsHistory
(
@method varchar(100)='duration'
,@xdate datetime=null
)
AS
set nocount on
set transaction isolation level read uncommitted

if @method='duration' begin

select @xdate=isnull(@xdate,getdate())

/*run_duration is in HHMMSS format; drop SS*/
/*run_staus: 1 complete 2 retry*/
/*step_id: 0 is final job outcome*/
/*run_date: yyyymmdd format*/

/*today's performance*/
select a.name,minutes=avg((b.run_duration / 100)/100*60 + (b.run_duration / 100)%100)
into #today
from msdb..sysjobs as a
join msdb..sysjobhistory as b
on a.job_id=b.job_id
where run_status in ('1','2') and step_id=0 and run_date =convert(varchar,@xdate,112)
group by a.name

/*7 day average performance*/
/*populate #D with dates in yyyymmdd format*/
create table #D (run_date varchar(50))
declare @idate datetime set @idate=@xdate
while @idate>dateadd(day,-7,@xdate) begin
insert into #D
select run_date=convert(varchar,@idate,112)
select @idate=dateadd(day,-1,@idate)
end

/*Avg7Days*/
select a.name,minutes=avg((b.run_duration / 100)/100*60 + (b.run_duration / 100)%100)
into #avg7Days
from msdb..sysjobs as a
join msdb..sysjobhistory as b
on a.job_id=b.job_id
join #D as c
on b.run_date = c.run_date
where run_status in ('1','2') and step_id=0
group by a.name

/*output*/
select name=cast(a.name as varchar(35)),OneDayAvg=a.minutes,SevenDayAvg=b.minutes
from #today as a
join #avg7days as b
on a.name=b.name
order by a.name

return end


if @method='failures' begin

select @xdate=isnull(@xdate,getdate())

select status=case run_status when 0 then 'FAILED' when 3 then 'CANCELED' when 4 then 'EXECUTING' end
,name=cast(a.name as varchar(35)),step_name
,time=replace(convert(varchar,@xdate,107),' ','')+' '+right('0000'+cast(b.run_time/100 as varchar),4)
,b.message
from msdb..sysjobs as a
join msdb..sysjobhistory as b
on a.job_id=b.job_id
where run_status in ('0','3','4') and run_date=convert(varchar,@xdate,112)
order by run_status,a.name

return end

GO
