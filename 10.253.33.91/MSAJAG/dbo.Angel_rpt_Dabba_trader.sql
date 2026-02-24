-- Object: PROCEDURE dbo.Angel_rpt_Dabba_trader
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE Proc Angel_rpt_Dabba_trader
as
/*
Exchangewise subrokerwise avegare order quantity <= 20 and order value <= 5000  
of last 30 trading days.
*/

declare @fdate as varchar(11)
select @fdate=min(start_date) from
(
select top 30 * from sett_mst where start_date<=getdate()
and sett_type='N'
order by start_date desc
) a
print @fdate

select Sub_broker=space(10),party_code,tradeqty=sum(tradeqty),Amount=sum(amount),sauda_date=convert(datetime,convert(varchar(11),sauda_date))
into #nse
from SETTLEMENT (nolock)
where sauda_date>=@fdate
and sauda_date<=getdate()
group by party_code,sauda_date

INSERT into #nse
select Sub_broker=space(10),party_code,tradeqty=sum(tradeqty),Amount=sum(amount),sauda_date=convert(datetime,convert(varchar(11),sauda_date))
from HISTORY (nolock)
where sauda_date>=@fdate
and sauda_date<=getdate()
group by party_code,convert(datetime,convert(varchar(11),sauda_date))

---------------------------------------------

update #nse set sub_broker=b.sub_broker 
from client1 b (nolock)
where #nse.party_code=b.cl_code

select sub_broker,tradeqty=sum(tradeqty),Amount=sum(Amount),nor=count(distinct sauda_date) 
into #CND1
from #nse
group by sub_broker--,convert(varchar(11),sauda_date)
having sum(tradeqty)/count(distinct sauda_date) <=20 and sum(Amount)/count(distinct sauda_date)  <=5000

select b2c_sb into #ff from mis.remisior.dbo.b2c_sb


insert into Angel_Dabba_trader
select *,Update_date=getdate()  from #cnd1 where sub_broker not in (select b2c_sb  from #ff)

GO
