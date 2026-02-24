-- Object: PROCEDURE dbo.rpt_settgrossexp
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_settgrossexp    Script Date: 04/27/2001 4:32:49 PM ******/

/****** Object:  Stored Procedure dbo.rpt_settgrossexp    Script Date: 3/21/01 12:50:23 PM ******/

/****** Object:  Stored Procedure dbo.rpt_settgrossexp    Script Date: 20-Mar-01 11:39:03 PM ******/






/* report : grossexposure
   file :  grossexptrdset.asp */
/* displays gross exposure of a particular client for current settlement plus today's trading*/
/* changed by mousami on 05/03/2001
     added family login 
*/
CREATE PROCEDURE rpt_settgrossexp
@statusid varchar(15),
@statusname varchar(25),
@partycode varchar(6),
@partyname varchar(21),
@settno varchar(7),
@scripcd varchar(12),
@settype varchar(3)
AS
if @statusid = 'broker' 
begin
select c1.short_name,party=rtrim(t4.party_code),t4.scrip_cd,t4.series,qty=sum(t4.tradeqty),
Amount=sum(t4.tradeqty*t4.marketrate),t4.sell_buy 
from trade4432 t4,client1 c1,client2 c2 
where c2.party_code = t4.party_code and c1.cl_code = c2.cl_code and c1.short_name like ltrim(@partyname)+'%' 
and t4.scrip_cd like ltrim(@scripcd)+'%' and t4.party_code like ltrim(@partycode)+'%'
group by c1.short_name,t4.party_code,t4.scrip_cd,t4.series,t4.sell_buy 
Union all
select c1.short_name,party=rtrim(t4.party_code),t4.scrip_cd,t4.series,qty=sum(t4.tradeqty),Amount=sum(t4.tradeqty*t4.marketrate),
t4.sell_buy from settlement t4,client1 c1,client2 c2 
where c2.party_code = t4.party_code and c1.cl_code = c2.cl_code 
and c1.short_name like ltrim(@partyname)+'%' and t4.scrip_cd like ltrim(@scripcd)+'%' 
and t4.party_code like ltrim(@partycode)+'%' 
and t4.sett_no = @settno and t4.sett_type =@settype
group by c1.short_name,t4.party_code,t4.scrip_cd,t4.series,t4.sell_buy 
order by c1.short_name,rtrim(t4.party_code),t4.scrip_cd,t4.series,t4.sell_buy
end
if @statusid = 'branch' 
begin
select c1.short_name,party=rtrim(t4.party_code),t4.scrip_cd,t4.series,qty=sum(t4.tradeqty),
Amount=sum(t4.tradeqty*t4.marketrate),t4.sell_buy 
from trade4432 t4,client1 c1,client2 c2 , branches b
where c2.party_code = t4.party_code and c1.cl_code = c2.cl_code and c1.short_name like ltrim(@partyname)+'%' 
and t4.scrip_cd like ltrim(@scripcd)+'%' and t4.party_code like ltrim(@partycode)+'%'
and b.branch_cd=@statusname and b.short_name=c1.trader
group by c1.short_name,t4.party_code,t4.scrip_cd,t4.series,t4.sell_buy 
Union all
select c1.short_name,party=rtrim(t4.party_code),t4.scrip_cd,t4.series,qty=sum(t4.tradeqty),Amount=sum(t4.tradeqty*t4.marketrate),
t4.sell_buy from settlement t4,client1 c1,client2 c2, branches b 
where c2.party_code = t4.party_code and c1.cl_code = c2.cl_code 
and c1.short_name like ltrim(@partyname)+'%' and t4.scrip_cd like ltrim(@scripcd)+'%' 
and t4.party_code like ltrim(@partycode)+'%' 
and t4.sett_no = @settno and t4.sett_type =@settype
and b.branch_cd=@statusname and b.short_name=c1.trader
group by c1.short_name,t4.party_code,t4.scrip_cd,t4.series,t4.sell_buy 
order by c1.short_name,rtrim(t4.party_code),t4.scrip_cd,t4.series,t4.sell_buy
end
if @statusid = 'trader' 
begin
select c1.short_name,party=rtrim(t4.party_code),t4.scrip_cd,t4.series,qty=sum(t4.tradeqty),
Amount=sum(t4.tradeqty*t4.marketrate),t4.sell_buy 
from trade4432 t4,client1 c1,client2 c2 
where c2.party_code = t4.party_code and c1.cl_code = c2.cl_code and c1.short_name like ltrim(@partyname)+'%' 
and t4.scrip_cd like ltrim(@scripcd)+'%' and t4.party_code like ltrim(@partycode)+'%'
and c1.trader=@statusname
group by c1.short_name,t4.party_code,t4.scrip_cd,t4.series,t4.sell_buy 
Union all
select c1.short_name,party=rtrim(t4.party_code),t4.scrip_cd,t4.series,qty=sum(t4.tradeqty),Amount=sum(t4.tradeqty*t4.marketrate),
t4.sell_buy from settlement t4,client1 c1,client2 c2 
where c2.party_code = t4.party_code and c1.cl_code = c2.cl_code 
and c1.short_name like ltrim(@partyname)+'%' and t4.scrip_cd like ltrim(@scripcd)+'%' 
and t4.party_code like ltrim(@partycode)+'%' 
and t4.sett_no = @settno and t4.sett_type =@settype
and c1.trader=@statusname
group by c1.short_name,t4.party_code,t4.scrip_cd,t4.series,t4.sell_buy 
order by c1.short_name,rtrim(t4.party_code),t4.scrip_cd,t4.series,t4.sell_buy
end
if @statusid = 'subbroker' 
begin
select c1.short_name,party=rtrim(t4.party_code),t4.scrip_cd,t4.series,qty=sum(t4.tradeqty),
Amount=sum(t4.tradeqty*t4.marketrate),t4.sell_buy 
from trade4432 t4,client1 c1,client2 c2 , subbrokers sb
where c2.party_code = t4.party_code and c1.cl_code = c2.cl_code and c1.short_name like ltrim(@partyname)+'%' 
and t4.scrip_cd like ltrim(@scripcd)+'%' and t4.party_code like ltrim(@partycode)+'%'
and sb.sub_broker=c1.sub_broker and sb.sub_broker=@statusname
group by c1.short_name,t4.party_code,t4.scrip_cd,t4.series,t4.sell_buy 
Union all
select c1.short_name,party=rtrim(t4.party_code),t4.scrip_cd,t4.series,qty=sum(t4.tradeqty),Amount=sum(t4.tradeqty*t4.marketrate),
t4.sell_buy from settlement t4,client1 c1,client2 c2 , subbrokers sb
where c2.party_code = t4.party_code and c1.cl_code = c2.cl_code 
and c1.short_name like ltrim(@partyname)+'%' and t4.scrip_cd like ltrim(@scripcd)+'%' 
and t4.party_code like ltrim(@partycode)+'%' 
and t4.sett_no = @settno and t4.sett_type =@settype
and sb.sub_broker=c1.sub_broker and sb.sub_broker=@statusname
group by c1.short_name,t4.party_code,t4.scrip_cd,t4.series,t4.sell_buy 
order by c1.short_name,rtrim(t4.party_code),t4.scrip_cd,t4.series,t4.sell_buy
end 
if @statusid = 'client'
begin
select c1.short_name,party=rtrim(t4.party_code),t4.scrip_cd,t4.series,qty=sum(t4.tradeqty),
Amount=sum(t4.tradeqty*t4.marketrate),t4.sell_buy 
from trade4432 t4,client1 c1,client2 c2 
where c2.party_code = t4.party_code and c1.cl_code = c2.cl_code 
and t4.scrip_cd like ltrim(@scripcd)+'%' and t4.party_code =@statusname
group by c1.short_name,t4.party_code,t4.scrip_cd,t4.series,t4.sell_buy 
Union all
select c1.short_name,party=rtrim(t4.party_code),t4.scrip_cd,t4.series,qty=sum(t4.tradeqty),Amount=sum(t4.tradeqty*t4.marketrate),
t4.sell_buy from settlement t4,client1 c1,client2 c2 
where c2.party_code = t4.party_code and c1.cl_code = c2.cl_code 
and t4.scrip_cd like ltrim(@scripcd)+'%' 
and t4.party_code =@statusname
and t4.sett_no = @settno and t4.sett_type =@settype
group by c1.short_name,t4.party_code,t4.scrip_cd,t4.series,t4.sell_buy 
order by c1.short_name,rtrim(t4.party_code),t4.scrip_cd,t4.series,t4.sell_buy
end 

if @statusid = 'family' 
begin
select c1.short_name,party=rtrim(t4.party_code),t4.scrip_cd,t4.series,qty=sum(t4.tradeqty),
Amount=sum(t4.tradeqty*t4.marketrate),t4.sell_buy 
from trade4432 t4,client1 c1,client2 c2 
where c2.party_code = t4.party_code and c1.cl_code = c2.cl_code and c1.short_name like ltrim(@partyname)+'%' 
and t4.scrip_cd like ltrim(@scripcd)+'%' and t4.party_code like ltrim(@partycode)+'%'
and c1.family=@statusname
group by c1.short_name,t4.party_code,t4.scrip_cd,t4.series,t4.sell_buy 
Union all
select c1.short_name,party=rtrim(t4.party_code),t4.scrip_cd,t4.series,qty=sum(t4.tradeqty),Amount=sum(t4.tradeqty*t4.marketrate),
t4.sell_buy from settlement t4,client1 c1,client2 c2 
where c2.party_code = t4.party_code and c1.cl_code = c2.cl_code 
and c1.short_name like ltrim(@partyname)+'%' and t4.scrip_cd like ltrim(@scripcd)+'%' 
and t4.party_code like ltrim(@partycode)+'%' 
and t4.sett_no = @settno and t4.sett_type =@settype
and c1.family=@statusname
group by c1.short_name,t4.party_code,t4.scrip_cd,t4.series,t4.sell_buy 
order by c1.short_name,rtrim(t4.party_code),t4.scrip_cd,t4.series,t4.sell_buy
end

GO
