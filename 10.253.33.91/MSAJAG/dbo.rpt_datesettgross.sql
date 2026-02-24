-- Object: PROCEDURE dbo.rpt_datesettgross
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_datesettgross    Script Date: 04/27/2001 4:32:38 PM ******/

/*
Written by 	: Neelambari
On		: 24 april
Gives us the gross exposure for selected settype ,settno ,tradre ,scrip partycode , partyname
bet the selected dates of selected settlement no
*/
CREATE procedure rpt_datesettgross  
@partyname  varchar(21),
@partycode varchar(10),
@scripcd varchar(10),
@trader  varchar(15),
@tdate  varchar(25),
@settno  varchar(7),
@settype  varchar(3)
as 
/*
select c1.short_name,party=rtrim(t4.party_code),t4.scrip_cd,t4.series,qty=sum(t4.tradeqty),
Amount=sum(t4.tradeqty*t4.marketrate),
t4.sell_buy from settlement t4,client1 c1,client2 c2 
where
c2.party_code = t4.party_code
and c1.cl_code = c2.cl_code 
and c1.short_name like ltrim(@partyname)+'%'
and t4.scrip_cd like ltrim(@scripcd)+'%' 
and t4.party_code like ltrim(@partycode)+'%' 
and t4.sett_no = @settno
and t4.sett_type = @settype
and c1.trader like ltrim( @trader)+'%'
and sauda_date >= @fdate
and sauda_date <= @tdate+ ' 23:59:59'
group by c1.short_name,t4.party_code,t4.scrip_cd,t4.series,t4.sell_buy  
order by c1.short_name,rtrim(t4.party_code),t4.scrip_cd,t4.series,t4.sell_buy
*/

select c1.short_name,party=rtrim(t4.party_code),t4.scrip_cd,t4.series,qty=sum(t4.tradeqty),
Amount=sum(t4.tradeqty*t4.marketrate),
t4.sell_buy , sett_type
from settlement t4,client1 c1,client2 c2 
where
c2.party_code = t4.party_code
and c1.cl_code = c2.cl_code 
and c1.short_name like '%'
and t4.scrip_cd like '%' 
and t4.party_code like ltrim(@partycode)+'%' 
and t4.sett_no = @settno
and t4.sett_type like  ltrim(@settype)+'%'
and c1.trader like ltrim(@trader)+'%'
and left(convert(varchar,sauda_date,109),11) = @tdate
group by c1.short_name,t4.party_code,t4.scrip_cd,t4.series,t4.sell_buy  ,sett_type
order by rtrim(t4.party_code),t4.scrip_cd,t4.series,sett_type

GO
