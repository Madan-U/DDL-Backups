-- Object: PROCEDURE dbo.techtip_scripreport
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE procedure techtip_scripreport(@sdate as varchar(11),@vdate as varchar(11))
 as
select
tipid,update_time = right(update_time,8),scrip,buy_sell,
tip_rate= convert(varchar,tip_rate), current_rate = convert(varchar,current_rate),
range = (case when buy_sell='B' then convert(varchar,bhigh)+' - '+convert(varchar,blow) else convert(varchar,slow)+' - '+convert(varchar,shigh) end) ,
stoploss = convert(varchar,stoploss),target = convert(varchar,target),
risk = convert(varchar,(case when buy_sell='B' then ((bhigh-stoploss)*(100000/bhigh)) else ((stoploss-slow)*(100000/slow)) end)),
reward = convert(varchar,(case when buy_sell='B' then ((target-bhigh)*(100000/bhigh)) else ((slow-target)*(100000/slow)) end)),
marketrate = convert(varchar,marketrate),
profit_loss = convert(varchar,(case when buy_sell='B' then (((case when marketrate>0 then marketrate else current_rate end)-bhigh)*(100000/bhigh)) else ((slow-(case when marketrate>0 then marketrate else current_rate end))*(100000/slow)) end)) 
from 
techtips
where update_time >= convert(datetime,convert(varchar(11),getdate()))
order by convert(datetime,update_time) desc

-- this column has been removed from display
--result = (case when buy_sell='B' then (case when (marketrate>bhigh) then '+' else '-' end) else (case when (marketrate<slow) then '+' else '-' end) end),

GO
