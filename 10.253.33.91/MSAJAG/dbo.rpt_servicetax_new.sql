-- Object: PROCEDURE dbo.rpt_servicetax_new
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_servicetax_new    Script Date: 10/19/01 3:33:31 PM ******/
CREATE procedure rpt_servicetax_new
@datefrom as varchar(20),
@dateto as varchar(20),
@branch as varchar(20)

as


if @branch <> '%'

begin

select left(convert(varchar,sauda_date,106),11) as sauda_date,sum(trade_amount) as trade_amount,
sum(brokapplied*tradeqty) as brok,sum((nbrokapp-brokapplied)*tradeqty) as delivery_chrg,
sum(service_tax + (nsertax-service_tax)) as serv,year(sauda_date),month(sauda_date),day(sauda_date),
sum(sebi_tax) as sebi_tax,sum(turn_tax) as turn_tax,sum(broker_chrg) as stamp,sum(settlement.other_chrg) as other_chrg,settlement.sett_type,settlement.sett_no
from settlement, client1 c1, client2 c2
where sauda_date >= @datefrom and sauda_date <= @dateto +' 23:59'
and rtrim(ltrim(c1.branch_cd)) = @branch
and rtrim(ltrim(c1.cl_code)) = rtrim(ltrim(c2.cl_code))
and rtrim(ltrim(c2.party_code)) = rtrim(ltrim(settlement.party_code))
group by left(convert(varchar,sauda_date,106),11),year(sauda_date),month(sauda_date),day(sauda_date),sett_type,settlement.sett_no

union all

select left(convert(varchar,sauda_date,106),11) as sauda_date,sum(trade_amount) as trade_amount,
sum(brokapplied*tradeqty) as brok,sum((nbrokapp-brokapplied)*tradeqty) as delivery_chrg,
sum(service_tax + (nsertax-service_tax)) as serv,year(sauda_date),month(sauda_date),day(sauda_date),
sum(sebi_tax) as sebi_tax,sum(turn_tax) as turn_tax,sum(broker_chrg) as stamp,sum(history.other_chrg) as other_chrg,history.sett_type,history.sett_no
from history, client1 c1, client2 c2
where sauda_date >= @datefrom and sauda_date <= @dateto +' 23:59'
and rtrim(ltrim(c1.branch_cd)) = @branch
and rtrim(ltrim(c1.cl_code)) = rtrim(ltrim(c2.cl_code))
and rtrim(ltrim(c2.party_code)) = rtrim(ltrim(history.party_code))
group by left(convert(varchar,sauda_date,106),11),year(sauda_date),month(sauda_date),day(sauda_date),sett_type,history.sett_no

order by sett_no,year(sauda_date) asc,month(sauda_date) asc,day(sauda_date) asc,sett_type

end



if @branch = '%'

begin

begin

select left(convert(varchar,sauda_date,106),11) as sauda_date,sum(trade_amount) as trade_amount,
sum(brokapplied*tradeqty) as brok,sum((nbrokapp-brokapplied)*tradeqty) as delivery_chrg,
sum(service_tax + (nsertax-service_tax)) as serv,year(sauda_date),month(sauda_date),day(sauda_date),
sum(sebi_tax) as sebi_tax,sum(turn_tax) as turn_tax,sum(broker_chrg) as stamp,sum(settlement.other_chrg) as other_chrg,settlement.sett_type,settlement.sett_no
from settlement, client1 c1, client2 c2
where sauda_date >= @datefrom and sauda_date <= @dateto +' 23:59'
and rtrim(ltrim(c1.cl_code)) = rtrim(ltrim(c2.cl_code))
and rtrim(ltrim(c2.party_code)) = rtrim(ltrim(settlement.party_code))
group by left(convert(varchar,sauda_date,106),11),year(sauda_date),month(sauda_date),day(sauda_date),sett_type,settlement.sett_no

union all

select left(convert(varchar,sauda_date,106),11) as sauda_date,sum(trade_amount) as trade_amount,
sum(brokapplied*tradeqty) as brok,sum((nbrokapp-brokapplied)*tradeqty) as delivery_chrg,
sum(service_tax + (nsertax-service_tax)) as serv,year(sauda_date),month(sauda_date),day(sauda_date),
sum(sebi_tax) as sebi_tax,sum(turn_tax) as turn_tax,sum(broker_chrg) as stamp,sum(history.other_chrg) as other_chrg,history.sett_type,history.sett_no
from history, client1 c1, client2 c2
where sauda_date >= @datefrom and sauda_date <= @dateto +' 23:59'
and rtrim(ltrim(c1.cl_code)) = rtrim(ltrim(c2.cl_code))
and rtrim(ltrim(c2.party_code)) = rtrim(ltrim(history.party_code))
group by left(convert(varchar,sauda_date,106),11),year(sauda_date),month(sauda_date),day(sauda_date),sett_type,history.sett_no
order by sett_no,year(sauda_date) asc,month(sauda_date) asc,day(sauda_date) asc,sett_type

end


end

GO
