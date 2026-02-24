-- Object: PROCEDURE dbo.rpt_normaldatewisedetailofposscripcummulative
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_normaldatewisedetailofposscripcummulative    Script Date: 04/27/2001 4:32:47 PM ******/
CREATE PROCEDURE rpt_normaldatewisedetailofposscripcummulative 
@settno varchar(7),
@settype varchar(3),
@partycode varchar(10),
@scripcd varchar(12),
@series varchar(3),
@fdate varchar(11),
@tdate varchar(11)

as

select  qty = sum(tradeqty), sell_buy, sauda_date = left(convert(varchar,sauda_date,109),11) 
from detailtempsettsumExp 
where sett_no=@settno and sett_type=@settype and party_code=@partycode
and scrip_cd=@scripcd and series=@series
and sauda_date >= @fdate  
and sauda_date <= @tdate  +' 23:59:59'
group by sell_buy, left(convert(varchar,sauda_date,109),11)

GO
