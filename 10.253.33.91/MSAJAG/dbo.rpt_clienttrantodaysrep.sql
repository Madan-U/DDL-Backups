-- Object: PROCEDURE dbo.rpt_clienttrantodaysrep
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_clienttrantodaysrep    Script Date: 04/27/2001 4:32:34 PM ******/

/****** Object:  Stored Procedure dbo.rpt_clienttrantodaysrep    Script Date: 3/21/01 12:50:13 PM ******/

/****** Object:  Stored Procedure dbo.rpt_clienttrantodaysrep    Script Date: 20-Mar-01 11:38:55 PM ******/





/****** Object:  Stored Procedure dbo.rpt_clienttrantodaysrep    Script Date: 2/5/01 12:06:16 PM ******/

/****** Object:  Stored Procedure dbo.rpt_clienttrantodaysrep    Script Date: 12/27/00 8:58:54 PM ******/

/* report : transactionreport
   file : todaysreport.asp
*/
/* displays todays trades not confirmed for a particular client */
/* changed by mousami on 07/03/2001 
     added family login
*/

CREATE PROCEDURE rpt_clienttrantodaysrep
@statusid varchar(15),
@statusname varchar(25),
@partycode varchar(10),
@partyname varchar(21),
@scripcd varchar(12),
@trader varchar(15)
AS
if @statusid = "broker" 
begin
select c1.short_name,o.order_no,o.party_code ,o.scrip_cd,o.series,o.sell_buy,(o.qty-o.tradeqty),o.
user_id,o.EffRate,o.OrderRate,qty,tradeqty,OrderTime
from orders o,client1 c1,client2 c2
where c2.party_code = o.party_code and c1.cl_code = c2.cl_code and 
c1.short_name like ltrim(@partyname)+'%' and o.scrip_cd like  ltrim(@scripcd)+'%' and 
o.party_code like  ltrim(@partycode)+'%' and c1.trader like ltrim(@trader)+'%'
order by c1.short_name,o.scrip_cd,o.sell_buy,OrderTime 
end
if @statusid = "branch" 
begin
select c1.short_name,o.order_no,o.party_code ,o.scrip_cd,o.series,o.sell_buy,(o.qty-o.tradeqty),o.
user_id,o.EffRate,o.OrderRate,qty,tradeqty,OrderTime
from orders o,client1 c1,client2 c2, branches b 
where c2.party_code = o.party_code and c1.cl_code = c2.cl_code and 
c1.short_name like ltrim(@partyname)+'%' and o.scrip_cd like  ltrim(@scripcd)+'%' and 
o.party_code like  ltrim(@partycode)+'%' and c1.trader like ltrim(@trader)+'%'
and b.branch_cd=@statusname
and b.short_name=c1.trader
order by c1.short_name,o.scrip_cd,o.sell_buy,OrderTime 
end
if @statusid = "trader" 
begin
select c1.short_name,o.order_no,o.party_code ,o.scrip_cd,o.series,o.sell_buy,(o.qty-o.tradeqty),o.
user_id,o.EffRate,o.OrderRate,qty,tradeqty,OrderTime
from orders o,client1 c1,client2 c2
where c2.party_code = o.party_code and c1.cl_code = c2.cl_code and 
c1.short_name like ltrim(@partyname)+'%' and o.scrip_cd like  ltrim(@scripcd)+'%' and 
o.party_code like  ltrim(@partycode)+'%'  and c1.trader=@statusname
order by c1.short_name,o.scrip_cd,o.sell_buy,OrderTime 
end 
if @statusid = "subbroker" 
begin
select c1.short_name,o.order_no,o.party_code ,o.scrip_cd,o.series,o.sell_buy,(o.qty-o.tradeqty),o.
user_id,o.EffRate,o.OrderRate,qty,tradeqty,OrderTime
from orders o,client1 c1,client2 c2, subbrokers sb
where c2.party_code = o.party_code and c1.cl_code = c2.cl_code and 
c1.short_name like ltrim(@partyname)+'%' and o.scrip_cd like  ltrim(@scripcd)+'%' 
and o.party_code like  ltrim(@partycode)+'%' and sb.sub_broker=c1.sub_broker and
sb.sub_broker=@statusname
order by c1.short_name,o.scrip_cd,o.sell_buy,OrderTime 
end 
if @statusid = "client" 
begin
select c1.short_name,o.order_no,o.party_code ,o.scrip_cd,o.series,o.sell_buy,(o.qty-o.tradeqty),o.
user_id,o.EffRate,o.OrderRate,qty,tradeqty,OrderTime
from orders o,client1 c1,client2 c2
where c2.party_code = o.party_code and c1.cl_code = c2.cl_code and 
o.scrip_cd like  ltrim(@scripcd)+'%' and o.party_code =@statusname 
order by c1.short_name,o.scrip_cd,o.sell_buy,OrderTime 
end


if @statusid ='family'
begin
select c1.short_name,o.order_no,o.party_code ,o.scrip_cd,o.series,o.sell_buy,(o.qty-o.tradeqty),o.
user_id,o.EffRate,o.OrderRate,qty,tradeqty,OrderTime
from orders o,client1 c1,client2 c2
where c2.party_code = o.party_code and c1.cl_code = c2.cl_code and 
c1.short_name like ltrim(@partyname)+'%' and o.scrip_cd like  ltrim(@scripcd)+'%' and 
o.party_code like  ltrim(@partycode)+'%' and c1.trader like ltrim(@trader)+'%'
and c1.family=@statusname
order by c1.short_name,o.scrip_cd,o.sell_buy,OrderTime 
end

GO
