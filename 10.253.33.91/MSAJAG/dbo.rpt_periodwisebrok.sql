-- Object: PROCEDURE dbo.rpt_periodwisebrok
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_periodwisebrok    Script Date: 04/27/2001 4:32:48 PM ******/

/****** Object:  Stored Procedure dbo.rpt_periodwisebrok    Script Date: 3/21/01 12:50:22 PM ******/

/****** Object:  Stored Procedure dbo.rpt_periodwisebrok    Script Date: 20-Mar-01 11:39:02 PM ******/





/****** Object:  Stored Procedure dbo.rpt_periodwisebrok    Script Date: 2/5/01 12:06:22 PM ******/

/****** Object:  Stored Procedure dbo.rpt_periodwisebrok    Script Date: 12/27/00 8:59:14 PM ******/


/*Changes done in the date and time passed for to and from date as asked by amolika  done on 25 may 2001*/
/* report : periodwise brokerage report
   file : brokreportdate.asp 
 */
/* displays brokerage of a client for a particular period */
/* changed by mousami on 05/03/2001 
    added family login 	
 */

CREATE PROCEDURE rpt_periodwisebrok
@statusid varchar(15),
@statusname varchar(25),
@partycode varchar(10),
@partyname varchar(21),
@fromdt varchar(11),
@todt varchar(11),
@trader varchar(15)
AS
if @statusid = 'broker' 
begin
select distinct h.Party_code,c1.short_name,c1.Trader,brok=sum(h.brokapplied * h.tradeqty),
DeliveryCharge = sum((h.Nbrokapp - h.Brokapplied) * h.tradeqty )
from history h,client1 c1,client2 c2
where h.party_code = c2.party_code and c1.cl_code = c2.cl_code and h.party_code like ltrim(@partycode)+ '%'
and c1.short_name like ltrim(@partyname)+ '%' and sauda_date >= @fromdt /*+ ' 00:00'*/ and 
sauda_date <= @todt +' 23:59'/* ' 11:59'*/ and c1.trader like ltrim(@trader) + '%' 
group by c1.short_name, h.party_code,c1.trader 
union all
select distinct h.Party_code,c1.short_name,c1.Trader,brok=sum(h.brokapplied * h.tradeqty),
DeliveryCharge = sum((h.Nbrokapp - h.Brokapplied) * h.tradeqty )
from settlement h,client1 c1,client2 c2
where h.party_code = c2.party_code and c1.cl_code = c2.cl_code and h.party_code like ltrim(@partycode)+ '%'
and c1.short_name like ltrim(@partyname)+ '%' and sauda_date >= @fromdt /*+ ' 00:00'*/ and 
sauda_date <= @todt +' 23:59'/* ' 11:59'*/ and c1.trader like ltrim(@trader) + '%' 
group by c1.short_name, h.party_code,c1.trader 
order by c1.trader,c1.short_name,h.Party_code,DeliveryCharge 
end
if @statusid = 'branch' 
begin
select distinct h.Party_code,c1.short_name,c1.Trader,brok=sum(h.brokapplied * h.tradeqty),
DeliveryCharge = sum((h.Nbrokapp - h.Brokapplied) * h.tradeqty )
from history h,client1 c1,client2 c2, branches b
where h.party_code = c2.party_code and c1.cl_code = c2.cl_code and h.party_code like ltrim(@partycode)+ '%'
and c1.short_name like ltrim(@partyname)+ '%' and sauda_date >= @fromdt  /*+ ' 00:00'*/ and 
sauda_date <= @todt  +' 23:59'/* ' 11:59'*/ and c1.trader like ltrim(@trader)+'%' 
and b.branch_cd=@statusname and b.short_name=c1.trader
group by c1.short_name, h.party_code,c1.trader 
union all
select distinct h.Party_code,c1.short_name,c1.Trader,brok=sum(h.brokapplied * h.tradeqty),
DeliveryCharge = sum((h.Nbrokapp - h.Brokapplied) * h.tradeqty )
from settlement  h,client1 c1,client2 c2, branches b
where h.party_code = c2.party_code and c1.cl_code = c2.cl_code and h.party_code like ltrim(@partycode)+ '%'
and c1.short_name like ltrim(@partyname)+ '%' and sauda_date >= @fromdt  /*+ ' 00:00'*/ and 
sauda_date <= @todt  + ' 23:59'/* ' 11:59'*/ and c1.trader like ltrim(@trader)+'%' 
and b.branch_cd=@statusname and b.short_name=c1.trader
group by c1.short_name, h.party_code,c1.trader 
order by c1.trader,c1.short_name,h.Party_code,DeliveryCharge 
end
if @statusid = 'trader' 
begin
select distinct h.Party_code,c1.short_name,c1.Trader,brok=sum(h.brokapplied * h.tradeqty),
DeliveryCharge = sum((h.Nbrokapp - h.Brokapplied) * h.tradeqty )
from history h,client1 c1,client2 c2
where h.party_code = c2.party_code and c1.cl_code = c2.cl_code and h.party_code like ltrim(@partycode)+ '%'
and c1.short_name like ltrim(@partyname)+ '%' and sauda_date >= @fromdt  /*+ ' 00:00'*/ and 
sauda_date <= @todt + ' 23:59'/* ' 11:59'*/ and c1.trader =@statusname 
group by c1.short_name, h.party_code,c1.trader 
union all
select distinct h.Party_code,c1.short_name,c1.Trader,brok=sum(h.brokapplied * h.tradeqty),
DeliveryCharge = sum((h.Nbrokapp - h.Brokapplied) * h.tradeqty )
from settlement  h,client1 c1,client2 c2
where h.party_code = c2.party_code and c1.cl_code = c2.cl_code and h.party_code like ltrim(@partycode)+ '%'
and c1.short_name like ltrim(@partyname)+ '%' and sauda_date >= @fromdt  /*+ ' 00:00' */and 
sauda_date <= @todt + ' 23:59'/* ' 11:59'*/ and c1.trader =@statusname 
group by c1.short_name, h.party_code,c1.trader 
order by c1.trader,c1.short_name,h.Party_code,DeliveryCharge 
end 
if @statusid = 'subbroker' 
begin
select distinct h.Party_code,c1.short_name,c1.Trader,brok=sum(h.brokapplied * h.tradeqty),
DeliveryCharge = sum((h.Nbrokapp - h.Brokapplied) * h.tradeqty )
from history h,client1 c1,client2 c2, subbrokers sb
where h.party_code = c2.party_code and c1.cl_code = c2.cl_code and h.party_code like ltrim(@partycode)+ '%'
and c1.short_name like ltrim(@partyname)+ '%' and sauda_date >= @fromdt /*+  ' 00:00'*/ and 
sauda_date <= @todt + ' 23:59' /* ' 11:59'*/ and c1.trader like ltrim(@trader)+'%'  and
sb.sub_broker=c1.sub_broker and sb.sub_broker=@statusname
group by c1.short_name, h.party_code,c1.trader 
union all
select distinct h.Party_code,c1.short_name,c1.Trader,brok=sum(h.brokapplied * h.tradeqty),
DeliveryCharge = sum((h.Nbrokapp - h.Brokapplied) * h.tradeqty )
from settlement h,client1 c1,client2 c2, subbrokers sb
where h.party_code = c2.party_code and c1.cl_code = c2.cl_code and h.party_code like ltrim(@partycode)+ '%'
and c1.short_name like ltrim(@partyname)+ '%' and sauda_date >= @fromdt /*+  ' 00:00'*/ and 
sauda_date <= @todt +' 23:59' /* ' 11:59'*/ and c1.trader like ltrim(@trader)+'%'  and
sb.sub_broker=c1.sub_broker and sb.sub_broker=@statusname
group by c1.short_name, h.party_code,c1.trader 
order by c1.trader,c1.short_name,h.Party_code,DeliveryCharge 
end 
if @statusid = 'client' 
begin
select distinct h.Party_code,c1.short_name,c1.Trader,brok=sum(h.brokapplied * h.tradeqty),
DeliveryCharge = sum((h.Nbrokapp - h.Brokapplied) * h.tradeqty )
from history h,client1 c1,client2 c2
where h.party_code = c2.party_code and c1.cl_code = c2.cl_code and h.party_code =@statusname
and sauda_date >= @fromdt  /*+ ' 00:00'*/ and 
sauda_date <= @todt  + ' 23:59'/* ' 11:59'*/
group by c1.short_name, h.party_code,c1.trader 
union all
select distinct h.Party_code,c1.short_name,c1.Trader,brok=sum(h.brokapplied * h.tradeqty),
DeliveryCharge = sum((h.Nbrokapp - h.Brokapplied) * h.tradeqty )
from settlement  h,client1 c1,client2 c2
where h.party_code = c2.party_code and c1.cl_code = c2.cl_code and h.party_code =@statusname
and sauda_date >= @fromdt  /*+ ' 00:00'*/ and 
sauda_date <= @todt  + ' 23:59'/* ' 11:59'*/
group by c1.short_name, h.party_code,c1.trader 
order by c1.trader,c1.short_name,h.Party_code,DeliveryCharge 
end 

if @statusid = 'family' 
begin
select distinct h.Party_code,c1.short_name,c1.Trader,brok=sum(h.brokapplied * h.tradeqty),
DeliveryCharge = sum((h.Nbrokapp - h.Brokapplied) * h.tradeqty )
from history h,client1 c1,client2 c2
where h.party_code = c2.party_code and c1.cl_code = c2.cl_code and h.party_code like ltrim(@partycode)+ '%'
and c1.short_name like ltrim(@partyname)+ '%' and sauda_date >= @fromdt /*+ ' 00:00'*/ and 
sauda_date <= @todt + ' 23:59'/* ' 11:59'*/ and c1.trader like ltrim(@trader) + '%' 
and c1.family=@statusname
group by c1.short_name, h.party_code,c1.trader 
union all
select distinct h.Party_code,c1.short_name,c1.Trader,brok=sum(h.brokapplied * h.tradeqty),
DeliveryCharge = sum((h.Nbrokapp - h.Brokapplied) * h.tradeqty )
from settlement h,client1 c1,client2 c2
where h.party_code = c2.party_code and c1.cl_code = c2.cl_code and h.party_code like ltrim(@partycode)+ '%'
and c1.short_name like ltrim(@partyname)+ '%' and sauda_date >= @fromdt /*+ ' 00:00'*/ and 
sauda_date <= @todt + ' 23:59'/* ' 11:59'*/ and c1.trader like ltrim(@trader) + '%' 
and c1.family=@statusname
group by c1.short_name, h.party_code,c1.trader 
order by c1.trader,c1.short_name,h.Party_code,DeliveryCharge 
end

/*
CREATE PROCEDURE rpt_periodwisebrok
@statusid varchar(15),
@statusname varchar(25),
@partycode varchar(10),
@partyname varchar(21),
@fromdt varchar(11),
@todt varchar(11),
@trader varchar(15)
AS
if @statusid = 'broker' 
begin
select distinct h.Party_code,c1.short_name,c1.Trader,brok=sum(h.brokapplied * h.tradeqty),
DeliveryCharge = sum((h.Nbrokapp - h.Brokapplied) * h.tradeqty )
from history h,client1 c1,client2 c2
where h.party_code = c2.party_code and c1.cl_code = c2.cl_code and h.party_code like ltrim(@partycode)+ '%'
and c1.short_name like ltrim(@partyname)+ '%' and sauda_date >= @fromdt + ' 00:00' and 
sauda_date <= @todt + ' 11:59' and c1.trader like ltrim(@trader) + '%' 
group by c1.short_name, h.party_code,c1.trader 
union all
select distinct h.Party_code,c1.short_name,c1.Trader,brok=sum(h.brokapplied * h.tradeqty),
DeliveryCharge = sum((h.Nbrokapp - h.Brokapplied) * h.tradeqty )
from settlement h,client1 c1,client2 c2
where h.party_code = c2.party_code and c1.cl_code = c2.cl_code and h.party_code like ltrim(@partycode)+ '%'
and c1.short_name like ltrim(@partyname)+ '%' and sauda_date >= @fromdt + ' 00:00' and 
sauda_date <= @todt + ' 11:59' and c1.trader like ltrim(@trader) + '%' 
group by c1.short_name, h.party_code,c1.trader 
order by c1.trader,c1.short_name,h.Party_code,DeliveryCharge 
end
if @statusid = 'branch' 
begin
select distinct h.Party_code,c1.short_name,c1.Trader,brok=sum(h.brokapplied * h.tradeqty),
DeliveryCharge = sum((h.Nbrokapp - h.Brokapplied) * h.tradeqty )
from history h,client1 c1,client2 c2, branches b
where h.party_code = c2.party_code and c1.cl_code = c2.cl_code and h.party_code like ltrim(@partycode)+ '%'
and c1.short_name like ltrim(@partyname)+ '%' and sauda_date >= @fromdt  + ' 00:00' and 
sauda_date <= @todt  + ' 11:59' and c1.trader like ltrim(@trader)+'%' 
and b.branch_cd=@statusname and b.short_name=c1.trader
group by c1.short_name, h.party_code,c1.trader 
union all
select distinct h.Party_code,c1.short_name,c1.Trader,brok=sum(h.brokapplied * h.tradeqty),
DeliveryCharge = sum((h.Nbrokapp - h.Brokapplied) * h.tradeqty )
from settlement  h,client1 c1,client2 c2, branches b
where h.party_code = c2.party_code and c1.cl_code = c2.cl_code and h.party_code like ltrim(@partycode)+ '%'
and c1.short_name like ltrim(@partyname)+ '%' and sauda_date >= @fromdt  + ' 00:00' and 
sauda_date <= @todt  + ' 11:59' and c1.trader like ltrim(@trader)+'%' 
and b.branch_cd=@statusname and b.short_name=c1.trader
group by c1.short_name, h.party_code,c1.trader 
order by c1.trader,c1.short_name,h.Party_code,DeliveryCharge 
end
if @statusid = 'trader' 
begin
select distinct h.Party_code,c1.short_name,c1.Trader,brok=sum(h.brokapplied * h.tradeqty),
DeliveryCharge = sum((h.Nbrokapp - h.Brokapplied) * h.tradeqty )
from history h,client1 c1,client2 c2
where h.party_code = c2.party_code and c1.cl_code = c2.cl_code and h.party_code like ltrim(@partycode)+ '%'
and c1.short_name like ltrim(@partyname)+ '%' and sauda_date >= @fromdt  + ' 00:00' and 
sauda_date <= @todt + ' 11:59' and c1.trader =@statusname 
group by c1.short_name, h.party_code,c1.trader 
union all
select distinct h.Party_code,c1.short_name,c1.Trader,brok=sum(h.brokapplied * h.tradeqty),
DeliveryCharge = sum((h.Nbrokapp - h.Brokapplied) * h.tradeqty )
from settlement  h,client1 c1,client2 c2
where h.party_code = c2.party_code and c1.cl_code = c2.cl_code and h.party_code like ltrim(@partycode)+ '%'
and c1.short_name like ltrim(@partyname)+ '%' and sauda_date >= @fromdt  + ' 00:00' and 
sauda_date <= @todt + ' 11:59' and c1.trader =@statusname 
group by c1.short_name, h.party_code,c1.trader 
order by c1.trader,c1.short_name,h.Party_code,DeliveryCharge 
end 
if @statusid = 'subbroker' 
begin
select distinct h.Party_code,c1.short_name,c1.Trader,brok=sum(h.brokapplied * h.tradeqty),
DeliveryCharge = sum((h.Nbrokapp - h.Brokapplied) * h.tradeqty )
from history h,client1 c1,client2 c2, subbrokers sb
where h.party_code = c2.party_code and c1.cl_code = c2.cl_code and h.party_code like ltrim(@partycode)+ '%'
and c1.short_name like ltrim(@partyname)+ '%' and sauda_date >= @fromdt +  ' 00:00' and 
sauda_date <= @todt + ' 11:59' and c1.trader like ltrim(@trader)+'%'  and
sb.sub_broker=c1.sub_broker and sb.sub_broker=@statusname
group by c1.short_name, h.party_code,c1.trader 
union all
select distinct h.Party_code,c1.short_name,c1.Trader,brok=sum(h.brokapplied * h.tradeqty),
DeliveryCharge = sum((h.Nbrokapp - h.Brokapplied) * h.tradeqty )
from settlement h,client1 c1,client2 c2, subbrokers sb
where h.party_code = c2.party_code and c1.cl_code = c2.cl_code and h.party_code like ltrim(@partycode)+ '%'
and c1.short_name like ltrim(@partyname)+ '%' and sauda_date >= @fromdt +  ' 00:00' and 
sauda_date <= @todt + ' 11:59' and c1.trader like ltrim(@trader)+'%'  and
sb.sub_broker=c1.sub_broker and sb.sub_broker=@statusname
group by c1.short_name, h.party_code,c1.trader 
order by c1.trader,c1.short_name,h.Party_code,DeliveryCharge 
end 
if @statusid = 'client' 
begin
select distinct h.Party_code,c1.short_name,c1.Trader,brok=sum(h.brokapplied * h.tradeqty),
DeliveryCharge = sum((h.Nbrokapp - h.Brokapplied) * h.tradeqty )
from history h,client1 c1,client2 c2
where h.party_code = c2.party_code and c1.cl_code = c2.cl_code and h.party_code =@statusname
and sauda_date >= @fromdt  + ' 00:00' and 
sauda_date <= @todt  +  ' 11:59'
group by c1.short_name, h.party_code,c1.trader 
union all
select distinct h.Party_code,c1.short_name,c1.Trader,brok=sum(h.brokapplied * h.tradeqty),
DeliveryCharge = sum((h.Nbrokapp - h.Brokapplied) * h.tradeqty )
from settlement  h,client1 c1,client2 c2
where h.party_code = c2.party_code and c1.cl_code = c2.cl_code and h.party_code =@statusname
and sauda_date >= @fromdt  + ' 00:00' and 
sauda_date <= @todt  +  ' 11:59'
group by c1.short_name, h.party_code,c1.trader 
order by c1.trader,c1.short_name,h.Party_code,DeliveryCharge 
end 

if @statusid = 'family' 
begin
select distinct h.Party_code,c1.short_name,c1.Trader,brok=sum(h.brokapplied * h.tradeqty),
DeliveryCharge = sum((h.Nbrokapp - h.Brokapplied) * h.tradeqty )
from history h,client1 c1,client2 c2
where h.party_code = c2.party_code and c1.cl_code = c2.cl_code and h.party_code like ltrim(@partycode)+ '%'
and c1.short_name like ltrim(@partyname)+ '%' and sauda_date >= @fromdt + ' 00:00' and 
sauda_date <= @todt + ' 11:59' and c1.trader like ltrim(@trader) + '%' 
and c1.family=@statusname
group by c1.short_name, h.party_code,c1.trader 
union all
select distinct h.Party_code,c1.short_name,c1.Trader,brok=sum(h.brokapplied * h.tradeqty),
DeliveryCharge = sum((h.Nbrokapp - h.Brokapplied) * h.tradeqty )
from settlement h,client1 c1,client2 c2
where h.party_code = c2.party_code and c1.cl_code = c2.cl_code and h.party_code like ltrim(@partycode)+ '%'
and c1.short_name like ltrim(@partyname)+ '%' and sauda_date >= @fromdt + ' 00:00' and 
sauda_date <= @todt + ' 11:59' and c1.trader like ltrim(@trader) + '%' 
and c1.family=@statusname
group by c1.short_name, h.party_code,c1.trader 
order by c1.trader,c1.short_name,h.Party_code,DeliveryCharge 
end
*/

GO
