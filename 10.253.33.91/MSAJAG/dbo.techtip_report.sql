-- Object: PROCEDURE dbo.techtip_report
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE procedure techtip_report(@sdate as varchar(11),@edate as varchar(11)) as
--declare @sdate as varchar(11)
--declare @edate as varchar(11)
select @sdate = convert(varchar(11),convert(datetime,@sdate),106)
select @edate = convert(varchar(11),convert(datetime,@edate),106)
select
tipid,
update_date = convert(varchar(11),update_time,103),
update_time = right(update_time,8),buy_sell,scrip,
range = (case when buy_sell='B' then convert(varchar,bhigh)+' - '+convert(varchar,blow) else convert(varchar,slow)+' - '+convert(varchar,shigh) end) ,
stoploss = convert(varchar,stoploss),target = convert(varchar,target),
profit_loss = convert(varchar,(case when buy_sell='B' then (((case when marketrate>0 then marketrate else current_rate end)-bhigh)*(100000/bhigh)) else ((slow-(case when marketrate>0 then marketrate else current_rate end))*(100000/slow)) end)) ,
reached_target,reached_stoploss
from 
techtips
where update_time >= @sdate and update_time <= @edate
order by update_time

GO
