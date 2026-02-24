-- Object: PROCEDURE dbo.rpt_isettwisebrok
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_isettwisebrok    Script Date: 04/27/2001 4:32:44 PM ******/

/****** Object:  Stored Procedure dbo.rpt_isettwisebrok    Script Date: 3/21/01 12:50:19 PM ******/

/****** Object:  Stored Procedure dbo.rpt_isettwisebrok    Script Date: 20-Mar-01 11:38:59 PM ******/

/****** Object:  Stored Procedure dbo.rpt_isettwisebrok    Script Date: 2/5/01 12:06:20 PM ******/

/****** Object:  Stored Procedure dbo.rpt_isettwisebrok    Script Date: 12/27/00 8:59:12 PM ******/

/* report : settlementwise brokerage
   file : brokreport.asp
*/
/*
  shows settlementwise brokerage for a particular party or parties for institutional trades
*/
CREATE PROCEDURE rpt_isettwisebrok
@statusid varchar(15),
@statusname varchar(25),
@partycode varchar(6),
@partyname varchar(21),
@settno varchar(7),
@settype varchar(3),
@trader varchar(15),
@pcode varchar(15)
AS
if @statusid = 'broker' 
begin
select distinct h.Party_code,c1.Short_Name,c1.Trader,Brok=sum(h.brokapplied * h.tradeqty),
DeliveryCharge = sum((h.Nbrokapp - h.Brokapplied) * h.tradeqty ) 
from isettlement h,client1 c1,client2 c2 
where h.party_code = c2.party_code and c1.cl_code = c2.cl_code 
and h.party_code like ltrim(@partycode)+'%' and c1.short_name like  ltrim(@partyname)+'%' and h.sett_no = @settno 
and h.sett_type like  ltrim(@settype)+'%' and c1.trader like  ltrim(@trader)+'%' 
and h.partipantcode  like ltrim(@pcode) + '%' 
group by h.party_code,c1.Short_Name,c1.trader 
Union all 
select distinct h.Party_code,c1.Short_Name,c1.Trader,Brok=sum(h.brokapplied * h.tradeqty),
DeliveryCharge = sum((h.Nbrokapp - h.Brokapplied) * h.tradeqty ) 
from ihistory h,client1 c1,client2 c2 
where h.party_code = c2.party_code and c1.cl_code = c2.cl_code and h.party_code like  ltrim(@partycode)+'%' 
and c1.short_name like  ltrim(@partyname)+'%' and h.sett_no = @settno and h.sett_type like  ltrim(@settype)+'%' 
and c1.trader like  ltrim(@trader)+'%'
and h.partipantcode  like ltrim(@pcode) + '%' 
group by h.party_code,c1.Short_Name,c1.trader 
order by c1.trader,h.Party_code,c1.Short_Name,h.DeliveryCharge 
end
if @statusid = 'branch' 
begin
select distinct h.Party_code,c1.Short_Name,c1.Trader,Brok=sum(h.brokapplied * h.tradeqty),
DeliveryCharge = sum((h.Nbrokapp - h.Brokapplied) * h.tradeqty ) 
from isettlement h,client1 c1,client2 c2 , branches b
where h.party_code = c2.party_code and c1.cl_code = c2.cl_code 
and h.party_code like ltrim(@partycode)+'%' and c1.short_name like  ltrim(@partyname)+'%' and h.sett_no = @settno 
and h.sett_type like  ltrim(@settype)+'%' and c1.trader like  ltrim(@trader)+'%' 
and b.branch_cd=@statusname and b.short_name=c1.trader
and h.partipantcode  like ltrim(@pcode) + '%'
group by h.party_code,c1.Short_Name,c1.trader 
Union all 
select distinct h.Party_code,c1.Short_Name,c1.Trader,Brok=sum(h.brokapplied * h.tradeqty),
DeliveryCharge = sum((h.Nbrokapp - h.Brokapplied) * h.tradeqty ) 
from ihistory h,client1 c1,client2 c2 , branches b
where h.party_code = c2.party_code and c1.cl_code = c2.cl_code and h.party_code like  ltrim(@partycode)+'%' 
and c1.short_name like  ltrim(@partyname)+'%' and h.sett_no = @settno and h.sett_type like  ltrim(@settype)+'%' 
and c1.trader like  ltrim(@trader)+'%' 
and b.branch_cd=@statusname and b.short_name=c1.trader
and h.partipantcode  like ltrim(@pcode) + '%'
group by h.party_code,c1.Short_Name,c1.trader 
order by c1.trader,h.Party_code,c1.Short_Name,h.DeliveryCharge 
end
if @statusid = 'subbroker' 
begin
select distinct h.Party_code,c1.Short_Name,c1.Trader,Brok=sum(h.brokapplied * h.tradeqty),
DeliveryCharge = sum((h.Nbrokapp - h.Brokapplied) * h.tradeqty ) 
from isettlement h,client1 c1,client2 c2 ,subbrokers sb
where h.party_code = c2.party_code and c1.cl_code = c2.cl_code 
and h.party_code like ltrim(@partycode)+'%' and c1.short_name like  ltrim(@partyname)+'%' and h.sett_no = @settno 
and h.sett_type like  ltrim(@settype)+'%' and c1.trader like  ltrim(@trader)+'%' 
and sb.sub_broker=@statusname and sb.sub_broker=c1.sub_broker
and h.partipantcode  like ltrim(@pcode) + '%'
group by h.party_code,c1.Short_Name,c1.trader 
Union all 
select distinct h.Party_code,c1.Short_Name,c1.Trader,Brok=sum(h.brokapplied * h.tradeqty),
DeliveryCharge = sum((h.Nbrokapp - h.Brokapplied) * h.tradeqty ) 
from ihistory h,client1 c1,client2 c2 ,subbrokers sb
where h.party_code = c2.party_code and c1.cl_code = c2.cl_code and h.party_code like  ltrim(@partycode)+'%' 
and c1.short_name like  ltrim(@partyname)+'%' and h.sett_no = @settno and h.sett_type like  ltrim(@settype)+'%' 
and c1.trader like  ltrim(@trader)+'%' 
and sb.sub_broker=@statusname and sb.sub_broker=c1.sub_broker
and h.partipantcode  like ltrim(@pcode) + '%'
group by h.party_code,c1.Short_Name,c1.trader 
order by c1.trader,h.Party_code,c1.Short_Name,h.DeliveryCharge 
end 
if @statusid='trader'
begin
select distinct h.Party_code,c1.Short_Name,c1.Trader,Brok=sum(h.brokapplied * h.tradeqty),
DeliveryCharge = sum((h.Nbrokapp - h.Brokapplied) * h.tradeqty ) 
from isettlement h,client1 c1,client2 c2 
where h.party_code = c2.party_code and c1.cl_code = c2.cl_code 
and h.party_code like ltrim(@partycode)+'%' and c1.short_name like  ltrim(@partyname)+'%' and h.sett_no = @settno 
and h.sett_type like  ltrim(@settype)+'%' and c1.trader =@statusname 
and h.partipantcode  like ltrim(@pcode) + '%'
group by h.party_code,c1.Short_Name,c1.trader 
Union all 
select distinct h.Party_code,c1.Short_Name,c1.Trader,Brok=sum(h.brokapplied * h.tradeqty),
DeliveryCharge = sum((h.Nbrokapp - h.Brokapplied) * h.tradeqty ) 
from ihistory h,client1 c1,client2 c2 
where h.party_code = c2.party_code and c1.cl_code = c2.cl_code and h.party_code like  ltrim(@partycode)+'%' 
and c1.short_name like  ltrim(@partyname)+'%' and h.sett_no = @settno and h.sett_type like  ltrim(@settype)+'%' 
and c1.trader =@statusname 
and h.partipantcode  like ltrim(@pcode) + '%'
group by h.party_code,c1.Short_Name,c1.trader 
order by c1.trader,h.Party_code,c1.Short_Name,h.DeliveryCharge 
end
if @statusid='client'
begin
select distinct h.Party_code,c1.Short_Name,c1.Trader,Brok=sum(h.brokapplied * h.tradeqty),
DeliveryCharge = sum((h.Nbrokapp - h.Brokapplied) * h.tradeqty ) 
from isettlement h,client1 c1,client2 c2 
where h.party_code = c2.party_code and c1.cl_code = c2.cl_code 
and h.party_code =@statusname and h.sett_no = @settno 
and h.sett_type like  ltrim(@settype)+'%' 
and h.partipantcode  like ltrim(@pcode) + '%'
group by h.party_code,c1.Short_Name,c1.trader 
Union all 
select distinct h.Party_code,c1.Short_Name,c1.Trader,Brok=sum(h.brokapplied * h.tradeqty),
DeliveryCharge = sum((h.Nbrokapp - h.Brokapplied) * h.tradeqty ) 
from ihistory h,client1 c1,client2 c2 
where h.party_code = c2.party_code and c1.cl_code = c2.cl_code and h.party_code =@statusname 
and h.sett_no = @settno and h.sett_type like  ltrim(@settype)+'%' 
and h.partipantcode  like ltrim(@pcode) + '%'
group by h.party_code,c1.Short_Name,c1.trader 
order by c1.trader,h.Party_code,c1.Short_Name,h.DeliveryCharge 
end

GO
