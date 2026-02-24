-- Object: PROCEDURE dbo.rpt_datesettwisebrok
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_datesettwisebrok    Script Date: 04/27/2001 4:32:38 PM ******/

/*
Written by neelambari on 10 apr 2001
this query gives us the brokerage according to selected settlement  or date
*/

CREATE PROCEDURE rpt_datesettwisebrok
@statusid varchar(15),
@statusname varchar(25),
@partycode varchar(10),
@partyname varchar(21),
@settno varchar(7),
@settype varchar(3),
@trader varchar(15),
@scrip varchar(20),
@fdate varchar(22),
@tdate varchar(22)
AS
if @statusid = 'broker' 
begin
	select distinct h.Party_code,c1.Short_Name,c1.Trader,Brok=sum(h.brokapplied * h.tradeqty),
	DeliveryCharge = sum((h.Nbrokapp - h.Brokapplied) * h.tradeqty ) , h.sett_no, h.sett_type, sauda_date = left(convert(varchar, sauda_date,109),11)
	from settlement h,client1 c1,client2 c2 
	where h.party_code = c2.party_code 
	and c1.cl_code = c2.cl_code 
	and h.party_code like ltrim(@partycode)+'%'
	and c1.short_name like  ltrim(@partyname)+'%' 
	and h.sett_no like ltrim (@settno )+'%'
	and h.sett_type like  ltrim(@settype)+'%' 
	and c1.trader like  ltrim(@trader)+'%' 
	and h.scrip_cd like ltrim(@scrip)+'%'
	and h.sauda_date >= @fdate
	and sauda_date <= @tdate + ' 23:59:59' 
	group by h.party_code,c1.Short_Name,c1.trader , h.sett_no, h.sett_type , left(convert(varchar, sauda_date,109),11)
	Union all 
	select distinct h.Party_code,c1.Short_Name,c1.Trader,Brok=sum(h.brokapplied * h.tradeqty),
	DeliveryCharge = sum((h.Nbrokapp - h.Brokapplied) * h.tradeqty ) , h.sett_no, h.sett_type  ,sauda_date = left(convert(varchar, sauda_date,109),11)
	from history h,client1 c1,client2 c2 
	where h.party_code = c2.party_code 
	and c1.cl_code = c2.cl_code 
	and h.party_code like  ltrim(@partycode)+'%' 
	and c1.short_name like  ltrim(@partyname)+'%' 
	and h.sett_no like ltrim (@settno )+'%'
	and h.sett_type like  ltrim(@settype)+'%' 
	and c1.trader like  ltrim(@trader)+'%' 
	and h.scrip_cd like ltrim(@scrip)+'%'
	and h.sauda_date>= @fdate
	and h.sauda_date <= @tdate + ' 23:59:59'
	group by h.party_code,c1.Short_Name,c1.trader , h.sett_no, h.sett_type, left(convert(varchar, sauda_date,109),11)
	order by c1.trader,h.Party_code,c1.Short_Name,h.DeliveryCharge ,  left(convert(varchar, sauda_date,109),11)
end

if @statusid = 'subbroker' 
begin
	select distinct h.Party_code,c1.Short_Name,c1.Trader,Brok=sum(h.brokapplied * h.tradeqty),
	DeliveryCharge = sum((h.Nbrokapp - h.Brokapplied) * h.tradeqty ) ,sauda_date = left(convert(varchar, sauda_date,109),11)
	from settlement h,client1 c1,client2 c2 ,subbrokers sb
	where h.party_code = c2.party_code 
	and c1.cl_code = c2.cl_code 
	and h.party_code like ltrim(@partycode)+'%'
	and c1.short_name like  ltrim(@partyname)+'%' 
	and h.sett_no like ltrim (@settno )+'%'
	and h.sett_type like  ltrim(@settype)+'%' 
	and c1.trader like  ltrim(@trader)+'%' 
	and h.scrip_cd like ltrim(@scrip)+'%'
	and  h.sauda_date>= @fdate
	and h.sauda_date <= @tdate + ' 23:59:59'
	and sb.sub_broker = c1.sub_broker
	and sb.sub_broker = @statusname
	group by h.party_code,c1.Short_Name,c1.trader ,  left(convert(varchar, sauda_date,109),11)
	Union all 
	select distinct h.Party_code,c1.Short_Name,c1.Trader,Brok=sum(h.brokapplied * h.tradeqty),
	DeliveryCharge = sum((h.Nbrokapp - h.Brokapplied) * h.tradeqty ) ,sauda_date = left(convert(varchar, sauda_date,109),11)
	from history h,client1 c1,client2 c2  , subbrokers sb
	where h.party_code = c2.party_code 
	and c1.cl_code = c2.cl_code 
	and h.party_code like  ltrim(@partycode)+'%' 
	and c1.short_name like  ltrim(@partyname)+'%' 
	and h.sett_no like ltrim (@settno )+'%'
	and h.sett_type like  ltrim(@settype)+'%' 
	and c1.trader like  ltrim(@trader)+'%' 
	and h.scrip_cd like ltrim(@scrip)+'%'
	and  h.sauda_date >= @fdate
	and h.sauda_date <= @tdate + ' 23:59:59'
	and sb.sub_broker = c1.sub_broker
	and sb.sub_broker = @statusname
	group by h.party_code,c1.Short_Name,c1.trader , left(convert(varchar, sauda_date,109),11)
	order by c1.trader,h.Party_code,c1.Short_Name,h.DeliveryCharge 
end


if @statusid = 'branch' 
begin
	select distinct h.Party_code,c1.Short_Name,c1.Trader,Brok=sum(h.brokapplied * h.tradeqty),
	DeliveryCharge = sum((h.Nbrokapp - h.Brokapplied) * h.tradeqty ), sauda_date = left(convert(varchar, sauda_date,109),11)
	from settlement h,client1 c1,client2 c2 ,branches br
	where h.party_code = c2.party_code 
	and c1.cl_code = c2.cl_code 
	and h.party_code like ltrim(@partycode)+'%'
	and c1.short_name like  ltrim(@partyname)+'%' 
	and h.sett_no like ltrim (@settno )+'%'
	and h.sett_type like  ltrim(@settype)+'%' 
	and c1.trader like  ltrim(@trader)+'%' 
	and h.scrip_cd like ltrim(@scrip)+'%'
	and  h.sauda_date >= @fdate
	and h.sauda_date <= @tdate + ' 23:59:59'
	and br.short_name = c1.trader
	and br.branch_cd=@statusname
	group by h.party_code,c1.Short_Name,c1.trader ,   left(convert(varchar, sauda_date,109),11)
	Union all 
	select distinct h.Party_code,c1.Short_Name,c1.Trader,Brok=sum(h.brokapplied * h.tradeqty),
	DeliveryCharge = sum((h.Nbrokapp - h.Brokapplied) * h.tradeqty ) , sauda_date = left(convert(varchar, sauda_date,109),11)
	from history h,client1 c1,client2 c2 ,branches br
	where h.party_code = c2.party_code 
	and c1.cl_code = c2.cl_code 
	and h.party_code like  ltrim(@partycode)+'%' 
	and c1.short_name like  ltrim(@partyname)+'%' 
	and h.sett_no like ltrim (@settno )+'%'
	and h.sett_type like  ltrim(@settype)+'%' 
	and c1.trader like  ltrim(@trader)+'%' 
	and h.scrip_cd like ltrim(@scrip)+'%'
	and  h.sauda_date>= @fdate
	and h.sauda_date <= @tdate + ' 23:59:59'
	and br.short_name = c1.trader
	and br.branch_cd=@statusname
	group by h.party_code,c1.Short_Name,c1.trader , left(convert(varchar, sauda_date,109),11)
	order by c1.trader,h.Party_code,c1.Short_Name,h.DeliveryCharge 
end



if @statusid = 'trader' 
begin
	select distinct h.Party_code,c1.Short_Name,c1.Trader,Brok=sum(h.brokapplied * h.tradeqty),
	DeliveryCharge = sum((h.Nbrokapp - h.Brokapplied) * h.tradeqty ) , sauda_date = left(convert(varchar, sauda_date,109),11)
	from settlement h,client1 c1,client2 c2 ,branches br 
	where h.party_code = c2.party_code 
	and c1.cl_code = c2.cl_code 
	and h.party_code like ltrim(@partycode)+'%'
	and c1.short_name like  ltrim(@partyname)+'%' 
	and h.sett_no like ltrim (@settno )+'%'
	and h.sett_type like  ltrim(@settype)+'%' 
	and c1.trader like  ltrim(@trader)+'%' 
	and h.scrip_cd like ltrim(@scrip)+'%'
	and  h.sauda_date >= @fdate
	and h.sauda_date <= @tdate + ' 23:59:59'
	and br.short_name = c1.trader
	and c1.trader = @statusname
	group by h.party_code,c1.Short_Name,c1.trader ,  left(convert(varchar, sauda_date,109),11)
	Union all 
	select distinct h.Party_code,c1.Short_Name,c1.Trader,Brok=sum(h.brokapplied * h.tradeqty),
	DeliveryCharge = sum((h.Nbrokapp - h.Brokapplied) * h.tradeqty ) , sauda_date = left(convert(varchar, sauda_date,109),11)
	from history h,client1 c1,client2 c2 ,branches br
	where h.party_code = c2.party_code 
	and c1.cl_code = c2.cl_code 
	and h.party_code like  ltrim(@partycode)+'%' 
	and c1.short_name like  ltrim(@partyname)+'%' 
	and h.sett_no like ltrim (@settno )+'%'
	and h.sett_type like  ltrim(@settype)+'%' 
	and c1.trader like  ltrim(@trader)+'%' 
	and h.scrip_cd like ltrim(@scrip)+'%'
	and  h.sauda_date >= @fdate
	and h.sauda_date <= @tdate + ' 23:59:59'
	and br.short_name = c1.trader
	and c1.trader = @statusname
	group by h.party_code,c1.Short_Name,c1.trader ,  left(convert(varchar, sauda_date,109),11)
	order by c1.trader,h.Party_code,c1.Short_Name,h.DeliveryCharge 
end

if @statusid = 'client' 
begin
	select distinct h.Party_code,c1.Short_Name,c1.Trader,Brok=sum(h.brokapplied * h.tradeqty),
	DeliveryCharge = sum((h.Nbrokapp - h.Brokapplied) * h.tradeqty ) , sauda_date = left(convert(varchar, sauda_date,109),11)
	from settlement h,client1 c1,client2 c2 
	where h.party_code = c2.party_code 
	and c1.cl_code = c2.cl_code 
	and h.party_code like ltrim(@partycode)+'%'
	and c1.short_name like  ltrim(@partyname)+'%' 
	and h.sett_no like ltrim (@settno )+'%'
	and h.sett_type like  ltrim(@settype)+'%' 
	and c1.trader like  ltrim(@trader)+'%' 
	and h.scrip_cd like ltrim(@scrip)+'%'
	and h.party_code =@statusname
	and  h.sauda_date >= @fdate
	and h.sauda_date <= @tdate + ' 23:59:59'
	group by h.party_code,c1.Short_Name,c1.trader ,   left(convert(varchar, sauda_date,109),11)
	Union all 
	select distinct h.Party_code,c1.Short_Name,c1.Trader,Brok=sum(h.brokapplied * h.tradeqty),
	DeliveryCharge = sum((h.Nbrokapp - h.Brokapplied) * h.tradeqty ) , sauda_date = left(convert(varchar, sauda_date,109),11)
	from history h,client1 c1,client2 c2 
	where h.party_code = c2.party_code 
	and c1.cl_code = c2.cl_code 
	and h.party_code like  ltrim(@partycode)+'%' 
	and c1.short_name like  ltrim(@partyname)+'%' 
	and h.sett_no like ltrim (@settno )+'%'
	and h.sett_type like  ltrim(@settype)+'%' 
	and c1.trader like  ltrim(@trader)+'%' 
	and h.scrip_cd like ltrim(@scrip)+'%'
	and h.party_code =@statusname
	and  h.sauda_date >= @fdate
	and h.sauda_date <= @tdate + ' 23:59:59'
	group by h.party_code,c1.Short_Name,c1.trader  ,   left(convert(varchar, sauda_date,109),11)
	order by c1.trader,h.Party_code,c1.Short_Name,h.DeliveryCharge 
end

if @statusid = 'family' 
begin
	select distinct h.Party_code,c1.Short_Name,c1.Trader,Brok=sum(h.brokapplied * h.tradeqty),
	DeliveryCharge = sum((h.Nbrokapp - h.Brokapplied) * h.tradeqty ) , sauda_date = left(convert(varchar, sauda_date,109),11)
	from settlement h,client1 c1,client2 c2 
	where h.party_code = c2.party_code 
	and c1.cl_code = c2.cl_code 
	and h.party_code like ltrim(@partycode)+'%'
	and c1.short_name like  ltrim(@partyname)+'%' 
	and h.sett_no like ltrim (@settno )+'%'
	and h.sett_type like  ltrim(@settype)+'%' 
	and c1.trader like  ltrim(@trader)+'%' 
	and h.scrip_cd like ltrim(@scrip)+'%'
	and c1.family =@statusname
	and  h.sauda_date>= @fdate
	and h.sauda_date <= @tdate + ' 23:59:59'
	group by h.party_code,c1.Short_Name,c1.trader ,   left(convert(varchar, sauda_date,109),11)
	Union all 
	select distinct h.Party_code,c1.Short_Name,c1.Trader,Brok=sum(h.brokapplied * h.tradeqty),
	DeliveryCharge = sum((h.Nbrokapp - h.Brokapplied) * h.tradeqty ) , sauda_date = left(convert(varchar, sauda_date,109),11)
	from history h,client1 c1,client2 c2 
	where h.party_code = c2.party_code 
	and c1.cl_code = c2.cl_code 
	and h.party_code like  ltrim(@partycode)+'%' 
	and c1.short_name like  ltrim(@partyname)+'%' 
	and h.sett_no like ltrim (@settno )+'%'
	and h.sett_type like  ltrim(@settype)+'%' 
	and c1.trader like  ltrim(@trader)+'%' 
	and h.scrip_cd like ltrim(@scrip)+'%'
	and c1.family =@statusname
	and h.sauda_date >= @fdate
	and h.sauda_date <= @tdate + ' 23:59:59'
	group by h.party_code,c1.Short_Name,c1.trader  , left(convert(varchar, sauda_date,109),11)
	order by c1.trader,h.Party_code,c1.Short_Name,h.DeliveryCharge 
end

GO
