-- Object: PROCEDURE dbo.rpt_servicetax_sett
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_servicetax_sett    Script Date: 10/19/01 3:33:31 PM ******/
CREATE procedure rpt_servicetax_sett
@branch as varchar(20),
@settyp as varchar(1),
@setno as varchar(7)
as


if @branch <> '%'

begin

select settlement.party_code,c1.short_name,c1.branch_cd,sett_type,
sum(trade_amount) as trade_amount,
sum(brokapplied*tradeqty) as brok,
sum((nbrokapp-brokapplied)*tradeqty) as delivery_chrg,
sum(service_tax + (nsertax-service_tax)) as serv,
sum(sebi_tax) as sebi_tax,
sum(turn_tax) as turn_tax,
sum(broker_chrg) as stamp,
sum(settlement.other_chrg) as other_chrg,
sett_no

from settlement,client1 c1, client2 c2

where sett_type = @settyp
and sett_no = @setno
and rtrim(ltrim(c1.branch_cd)) = @branch
and rtrim(ltrim(c1.cl_code)) = rtrim(ltrim(c2.cl_code))
and rtrim(ltrim(c2.party_code)) = rtrim(ltrim(settlement.party_code))

group by settlement.party_code,c1.short_name,c1.branch_cd,sett_type,sett_no


union all

select history.party_code,c1.short_name,c1.branch_cd,sett_type,
sum(trade_amount) as trade_amount,
sum(brokapplied*tradeqty) as brok,
sum((nbrokapp-brokapplied)*tradeqty) as delivery_chrg,
sum(service_tax + (nsertax-service_tax)) as serv,
sum(sebi_tax) as sebi_tax,
sum(turn_tax) as turn_tax,
sum(broker_chrg) as stamp,
sum(history.other_chrg) as other_chrg,
sett_no

from history,client1 c1, client2 c2

where sett_type = @settyp
and sett_no = @setno
and rtrim(ltrim(c1.branch_cd)) = @branch
and rtrim(ltrim(c1.cl_code)) = rtrim(ltrim(c2.cl_code))
and rtrim(ltrim(c2.party_code)) = rtrim(ltrim(history.party_code))

group by history.party_code,c1.short_name,c1.branch_cd,sett_type,sett_no

order by trade_amount desc


end



if @branch = '%'

begin

select settlement.party_code,c1.short_name,c1.branch_cd,sett_type,
sum(trade_amount) as trade_amount,
sum(brokapplied*tradeqty) as brok,
sum((nbrokapp-brokapplied)*tradeqty) as delivery_chrg,
sum(service_tax + (nsertax-service_tax)) as serv,
sum(sebi_tax) as sebi_tax,
sum(turn_tax) as turn_tax,
sum(broker_chrg) as stamp,
sum(settlement.other_chrg) as other_chrg,
sett_no

from settlement,client1 c1, client2 c2

where sett_type = @settyp
and sett_no = @setno
and rtrim(ltrim(c1.branch_cd)) like '%'
and rtrim(ltrim(c1.cl_code)) = rtrim(ltrim(c2.cl_code))
and rtrim(ltrim(c2.party_code)) = rtrim(ltrim(settlement.party_code))

group by settlement.party_code,c1.short_name,c1.branch_cd,sett_type,sett_no


union all

select history.party_code,c1.short_name,c1.branch_cd,sett_type,
sum(trade_amount) as trade_amount,
sum(brokapplied*tradeqty) as brok,
sum((nbrokapp-brokapplied)*tradeqty) as delivery_chrg,
sum(service_tax + (nsertax-service_tax)) as serv,
sum(sebi_tax) as sebi_tax,
sum(turn_tax) as turn_tax,
sum(broker_chrg) as stamp,
sum(history.other_chrg) as other_chrg,
sett_no

from history,client1 c1, client2 c2

where sett_type = @settyp
and rtrim(ltrim(c1.branch_cd)) like '%'
and rtrim(ltrim(c1.cl_code)) = rtrim(ltrim(c2.cl_code))
and rtrim(ltrim(c2.party_code)) = rtrim(ltrim(history.party_code))

group by history.party_code,c1.short_name,c1.branch_cd,sett_type,sett_no

order by trade_amount desc


end

GO
