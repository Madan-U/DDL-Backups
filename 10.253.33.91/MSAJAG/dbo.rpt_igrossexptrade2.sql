-- Object: PROCEDURE dbo.rpt_igrossexptrade2
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_igrossexptrade2    Script Date: 04/27/2001 4:32:43 PM ******/

/****** Object:  Stored Procedure dbo.rpt_igrossexptrade2    Script Date: 3/21/01 12:50:18 PM ******/

/****** Object:  Stored Procedure dbo.rpt_igrossexptrade2    Script Date: 20-Mar-01 11:38:59 PM ******/

/****** Object:  Stored Procedure dbo.rpt_igrossexptrade2    Script Date: 2/5/01 12:06:19 PM ******/

/****** Object:  Stored Procedure dbo.rpt_igrossexptrade2    Script Date: 12/27/00 8:59:12 PM ******/

/* institutional trading */
/* report : gross exposure report
    file : grossexptrdset.asp
    displays gross exposure of client or clients for today's date plus settlement  for institutional  trading
 */
CREATE PROCEDURE rpt_igrossexptrade2
@statusid varchar(15),
@statusname varchar(25),
@partyname varchar(21),
@settno varchar(7),
@settype varchar(3),
@scripcd varchar(12),
@partycode varchar(10),
@pcode varchar(15)
AS
if @statusid = 'broker' 
begin
select c1.short_name,party=rtrim(t4.party_code),t4.scrip_cd,t4.series, qty=sum(t4.tradeqty),
Amount=sum(t4.tradeqty*t4.marketrate),t4.sell_buy 
from trade t4,client1 c1,client2 c2 
where c2.party_code = t4.party_code and c1.cl_code = c2.cl_code 
and c1.short_name like ltrim(@partyname)+'%' and t4.scrip_cd like  ltrim(@scripcd)+'%' and 
t4.party_code like  ltrim(@partycode)+'%' 
and t4.partipantcode like ltrim(@pcode)+'%'
group by c1.short_name,t4.party_code,t4.scrip_cd,t4.series,t4.sell_buy 
Union all 
select c1.short_name,party=rtrim(t4.party_code),t4.scrip_cd,t4.series,qty=sum(t4.tradeqty),
Amount=sum(t4.tradeqty*t4.marketrate),t4.sell_buy 
from isettlement t4,client1 c1,client2 c2 
where c2.party_code = t4.party_code and c1.cl_code = c2.cl_code and c1.short_name like  ltrim(@partyname)+'%' 
and t4.scrip_cd like  ltrim(@scripcd)+'%' and t4.party_code like  ltrim(@partycode)+'%' and t4.sett_no = @settno 
and t4.sett_type =@settype 
and t4.partipantcode like ltrim(@pcode)+'%'
group by c1.short_name,t4.party_code,t4.scrip_cd,t4.series,t4.sell_buy 
order by c1.short_name,rtrim(t4.party_code),t4.scrip_cd,t4.series,t4.sell_buy
end
if @statusid = 'branch' 
begin
select c1.short_name,party=rtrim(t4.party_code),t4.scrip_cd,t4.series,qty=sum(t4.tradeqty),
Amount=sum(t4.tradeqty*t4.marketrate),t4.sell_buy 
from trade t4,client1 c1,client2 c2 , branches b
where c2.party_code = t4.party_code and c1.cl_code = c2.cl_code 
and c1.short_name like ltrim(@partyname)+'%' and t4.scrip_cd like  ltrim(@scripcd)+'%' and 
t4.party_code like  ltrim(@partycode)+'%' 
and b.branch_cd=@statusname and b.short_name=c1.trader
and t4.partipantcode like ltrim(@pcode)+'%'
group by c1.short_name,t4.party_code,t4.scrip_cd,t4.series,t4.sell_buy 
Union all 
select c1.short_name,party=rtrim(t4.party_code),t4.scrip_cd,t4.series,qty=sum(t4.tradeqty),
Amount=sum(t4.tradeqty*t4.marketrate),t4.sell_buy 
from isettlement t4,client1 c1,client2 c2 , branches b
where c2.party_code = t4.party_code and c1.cl_code = c2.cl_code and c1.short_name like  ltrim(@partyname)+'%' 
and t4.scrip_cd like  ltrim(@scripcd)+'%' and t4.party_code like  ltrim(@partycode)+'%' and t4.sett_no = @settno 
and t4.sett_type =@settype 
and b.branch_cd=@statusname and b.short_name=c1.trader
and t4.partipantcode like ltrim(@pcode)+'%'
group by c1.short_name,t4.party_code,t4.scrip_cd,t4.series,t4.sell_buy 
order by c1.short_name,rtrim(t4.party_code),t4.scrip_cd,t4.series,t4.sell_buy
end
if @statusid = 'trader' 
begin
select c1.short_name,party=rtrim(t4.party_code),t4.scrip_cd,t4.series,qty=sum(t4.tradeqty),
Amount=sum(t4.tradeqty*t4.marketrate),t4.sell_buy 
from trade t4,client1 c1,client2 c2 
where c2.party_code = t4.party_code and c1.cl_code = c2.cl_code 
and c1.short_name like ltrim(@partyname)+'%' and t4.scrip_cd like  ltrim(@scripcd)+'%' and 
t4.party_code like  ltrim(@partycode)+'%' and c1.trader=@statusname
and t4.partipantcode like ltrim(@pcode)+'%'
group by c1.short_name,t4.party_code,t4.scrip_cd,t4.series,t4.sell_buy 
Union all 
select c1.short_name,party=rtrim(t4.party_code),t4.scrip_cd,t4.series,qty=sum(t4.tradeqty),
Amount=sum(t4.tradeqty*t4.marketrate),t4.sell_buy 
from isettlement t4,client1 c1,client2 c2 
where c2.party_code = t4.party_code and c1.cl_code = c2.cl_code and c1.short_name like  ltrim(@partyname)+'%' 
and t4.scrip_cd like  ltrim(@scripcd)+'%' and t4.party_code like  ltrim(@partycode)+'%' and t4.sett_no = @settno 
and t4.sett_type =@settype and c1.trader=@statusname
and t4.partipantcode like ltrim(@pcode)+'%'
group by c1.short_name,t4.party_code,t4.scrip_cd,t4.series,t4.sell_buy 
order by c1.short_name,rtrim(t4.party_code),t4.scrip_cd,t4.series,t4.sell_buy
end 
if @statusid = 'subbroker' 
begin
select c1.short_name, party=rtrim(t4.party_code),t4.scrip_cd,t4.series,qty=sum(t4.tradeqty),
Amount=sum(t4.tradeqty*t4.marketrate),t4.sell_buy 
from trade t4,client1 c1,client2 c2 , subbrokers sb
where c2.party_code = t4.party_code and c1.cl_code = c2.cl_code 
and c1.short_name like ltrim(@partyname)+'%' and t4.scrip_cd like  ltrim(@scripcd)+'%' and 
t4.party_code like  ltrim(@partycode)+'%'  and sb.sub_broker=c1.sub_broker
and sb.sub_broker=@statusname
and t4.partipantcode like ltrim(@pcode)+'%'
group by c1.short_name,t4.party_code,t4.scrip_cd,t4.series,t4.sell_buy 
Union all 
select c1.short_name, party=rtrim(t4.party_code),t4.scrip_cd,t4.series,qty=sum(t4.tradeqty),
Amount=sum(t4.tradeqty*t4.marketrate),t4.sell_buy 
from isettlement t4,client1 c1,client2 c2 , subbrokers sb 
where c2.party_code = t4.party_code and c1.cl_code = c2.cl_code and c1.short_name like  ltrim(@partyname)+'%' 
and t4.scrip_cd like  ltrim(@scripcd)+'%' and t4.party_code like  ltrim(@partycode)+'%' and t4.sett_no = @settno 
and t4.sett_type =@settype and sb.sub_broker=c1.sub_broker
and sb.sub_broker=@statusname
and t4.partipantcode like ltrim(@pcode)+'%'
group by c1.short_name,t4.party_code,t4.scrip_cd,t4.series,t4.sell_buy 
order by c1.short_name,rtrim(t4.party_code),t4.scrip_cd,t4.series,t4.sell_buy
end 
if @statusid = 'client' 
begin
select c1.short_name, party=rtrim(t4.party_code),t4.scrip_cd,t4.series,qty=sum(t4.tradeqty),
Amount=sum(t4.tradeqty*t4.marketrate),t4.sell_buy 
from trade t4,client1 c1,client2 c2 
where c2.party_code = t4.party_code and c1.cl_code = c2.cl_code 
and t4.scrip_cd like  ltrim(@scripcd)+'%' and 
t4.party_code =  @statusname 
and t4.partipantcode like ltrim(@pcode)+'%'
group by c1.short_name,t4.party_code,t4.scrip_cd,t4.series,t4.sell_buy 
Union all 
select c1.short_name, party=rtrim(t4.party_code),t4.scrip_cd,t4.series,qty=sum(t4.tradeqty),
Amount=sum(t4.tradeqty*t4.marketrate),t4.sell_buy 
from isettlement t4,client1 c1,client2 c2 
where c2.party_code = t4.party_code and c1.cl_code = c2.cl_code 
and t4.scrip_cd like  ltrim(@scripcd)+'%' and t4.party_code = @statusname and t4.sett_no = @settno 
and t4.sett_type =@settype 
and t4.partipantcode like ltrim(@pcode)+'%'
group by c1.short_name,t4.party_code,t4.scrip_cd,t4.series,t4.sell_buy 
order by c1.short_name,rtrim(t4.party_code),t4.scrip_cd,t4.series,t4.sell_buy
end

GO
