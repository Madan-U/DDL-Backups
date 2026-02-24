-- Object: PROCEDURE dbo.rpt_datesettgrossexpp
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_datesettgrossexpp    Script Date: 04/27/2001 4:32:38 PM ******/

/*
Written by : 	Neelambari
on	: 24 april 2001
this procedure gives us the trades for settype ="W" w/o albm effect for selected settno ,date
i.e purely normal trades for settype = "W"
*/
CREATE PROCEDURE  rpt_datesettgrossexpp
@statusid varchar(15),
@statusname varchar(25),
@partycode varchar(10),
@partyname varchar(21),
@scripcd varchar(12),
@trader varchar(15),
@fdate varchar(25),
@tdate varchar(25),
@settno varchar(7),
@settype varchar(3)
AS
select c1.short_name,party=rtrim(t4.party_code),t4.scrip_cd,t4.series, qty=sum(t4.tradeqty),
Amount=sum(t4.tradeqty*t4.marketrate),t4.sell_buy 
from settlement t4,client1 c1,client2 c2 
where c2.party_code = t4.party_code 
and c1.cl_code = c2.cl_code 
and c1.short_name like ltrim( @partyname)+'%'
and t4.scrip_cd like ltrim(@scripcd)+'%'
and t4.party_code like  ltrim(@partycode)+'%' 
and t4.sauda_date > = @fdate
and t4.sauda_date <= @tdate+' 23:59:59'
and c1.trader like ltrim(@trader)+'%'
and t4.sett_type = @settype
group by c1.short_name,t4.party_code,t4.scrip_cd,t4.series,t4.sell_buy

GO
