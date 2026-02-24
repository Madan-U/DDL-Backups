-- Object: PROCEDURE dbo.rpt_sbmngtodaysreport1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_sbmngtodaysreport1    Script Date: 04/27/2001 4:32:49 PM ******/

/****** Object:  Stored Procedure dbo.rpt_sbmngtodaysreport1    Script Date: 3/21/01 12:50:23 PM ******/

/****** Object:  Stored Procedure dbo.rpt_sbmngtodaysreport1    Script Date: 20-Mar-01 11:39:02 PM ******/









/****** Object:  Stored Procedure dbo.sbmngtodaysreport1    Script Date: 09/25/00 11:13:45 AM ******/
/*  file :todays reports .asp 
    report : management info
displays list of trades that are not confirmed 
 **/

/* changed by mousami on 6th march 2001
     added family login
*/
CREATE PROCEDURE rpt_sbmngtodaysreport1
@statusid varchar(15),
@statusname varchar(25),
@partyname varchar(21),
@scripcd varchar(10),
@partycode varchar(6),
@series varchar(3)
AS

if @statusid='broker'
begin
if @series='BE' 
	begin 
		select  distinct c1.short_name,o.order_no,o.party_code ,o.scrip_cd,o.series,o.sell_buy,(o.qty-o.tradeqty),o.user_id,
		o.EffRate,o.OrderRate,o.qty,o.tradeqty,o.OrderTime
		from orders o,client1 c1,client2 c2
		where c2.party_code = o.party_code and c1.cl_code = c2.cl_code 
		and c1.short_name like ltrim(@partyname)+'%'  and o.scrip_cd like ltrim(@scripcd)+'%' and o.party_code like ltrim(@partycode)+'%'
		and (o.series ='01' or  o.series ='02' or o.series ='03' or o.series ='04' or o.series ='05')
		order by c1.short_name,o.scrip_cd,o.sell_buy,OrderTime 
	end 
else
	begin
		select  distinct c1.short_name,o.order_no,o.party_code ,o.scrip_cd,o.series,o.sell_buy,(o.qty-o.tradeqty),o.user_id,
		o.EffRate,o.OrderRate,o.qty,o.tradeqty,o.OrderTime
		from orders o,client1 c1,client2 c2
		where c2.party_code = o.party_code and c1.cl_code = c2.cl_code 
		and c1.short_name like ltrim(@partyname)+'%'  and o.scrip_cd like ltrim(@scripcd)+'%' and o.party_code like ltrim(@partycode)+'%'
		and o.series like ltrim(@series)+'%'
		order by c1.short_name,o.scrip_cd,o.sell_buy,OrderTime 
	end
end

if @statusid='branch'
begin
if @series='BE' 
	begin
		select  distinct c1.short_name,o.order_no,o.party_code ,o.scrip_cd,o.series,o.sell_buy,(o.qty-o.tradeqty),o.user_id,
		o.EffRate,o.OrderRate,o.qty,o.tradeqty,o.OrderTime
		from orders o,client1 c1,client2 c2, branches b
		where c2.party_code = o.party_code and c1.cl_code = c2.cl_code 
		and c1.short_name like ltrim(@partyname)+'%'  and o.scrip_cd like ltrim(@scripcd)+'%' and o.party_code like ltrim(@partycode)+'%'
		and (o.series ='01' or  o.series ='02' or o.series ='03' or o.series ='04' or o.series ='05')
		and b.branch_cd=@statusname and 
		b.short_name=c1.trader
		order by c1.short_name,o.scrip_cd,o.sell_buy,OrderTime 
	end
else
	begin	
		select  distinct c1.short_name,o.order_no,o.party_code ,o.scrip_cd,o.series,o.sell_buy,(o.qty-o.tradeqty),o.user_id,
		o.EffRate,o.OrderRate,o.qty,o.tradeqty,o.OrderTime
		from orders o,client1 c1,client2 c2, branches b
		where c2.party_code = o.party_code and c1.cl_code = c2.cl_code 
		and c1.short_name like ltrim(@partyname)+'%'  and o.scrip_cd like ltrim(@scripcd)+'%' and o.party_code like ltrim(@partycode)+'%'
		and o.series like ltrim(@series)+'%'
		and b.branch_cd=@statusname and 
		b.short_name=c1.trader
		order by c1.short_name,o.scrip_cd,o.sell_buy,OrderTime 
	end
end

if @statusid='subbroker'
begin
if @series='BE' 
	begin
		select  distinct c1.short_name,o.order_no,o.party_code ,o.scrip_cd,o.series,o.sell_buy,(o.qty-o.tradeqty),o.user_id,
		o.EffRate,o.OrderRate,o.qty,o.tradeqty,o.OrderTime
		from orders o,client1 c1,client2 c2, subbrokers sb
		where c2.party_code = o.party_code and c1.cl_code = c2.cl_code 
		and c1.short_name like ltrim(@partyname)+'%'  and o.scrip_cd like ltrim(@scripcd)+'%' and o.party_code like ltrim(@partycode)+'%'
		and (o.series ='01' or  o.series ='02' or o.series ='03' or o.series ='04' or o.series ='05')
		and sb.sub_broker=c1.sub_broker
		and sb.sub_broker=@statusname
		order by c1.short_name,o.scrip_cd,o.sell_buy,OrderTime 
	end
else
	begin
		select  distinct c1.short_name,o.order_no,o.party_code ,o.scrip_cd,o.series,o.sell_buy,(o.qty-o.tradeqty),o.user_id,
		o.EffRate,o.OrderRate,o.qty,o.tradeqty,o.OrderTime
		from orders o,client1 c1,client2 c2, subbrokers sb
		where c2.party_code = o.party_code and c1.cl_code = c2.cl_code 
		and c1.short_name like ltrim(@partyname)+'%'  and o.scrip_cd like ltrim(@scripcd)+'%' and o.party_code like ltrim(@partycode)+'%'
		and o.series like ltrim(@series)+'%'
		and sb.sub_broker=c1.sub_broker
		and sb.sub_broker=@statusname
		order by c1.short_name,o.scrip_cd,o.sell_buy,OrderTime 
	end
end

if @statusid='trader'
begin
if @series='BE'
	begin
		select  distinct c1.short_name,o.order_no,o.party_code ,o.scrip_cd,o.series,o.sell_buy,(o.qty-o.tradeqty),o.user_id,
		o.EffRate,o.OrderRate,o.qty,o.tradeqty,o.OrderTime
		from orders o,client1 c1,client2 c2
		where c2.party_code = o.party_code and c1.cl_code = c2.cl_code 
		and c1.short_name like ltrim(@partyname)+'%'  and o.scrip_cd like ltrim(@scripcd)+'%' and o.party_code like ltrim(@partycode)+'%'
		and (o.series ='01' or  o.series ='02' or o.series ='03' or o.series ='04' or o.series ='05')
		and c1.trader=@statusname
		order by c1.short_name,o.scrip_cd,o.sell_buy,OrderTime 
	end
else
	begin
		select  distinct c1.short_name,o.order_no,o.party_code ,o.scrip_cd,o.series,o.sell_buy,(o.qty-o.tradeqty),o.user_id,
		o.EffRate,o.OrderRate,o.qty,o.tradeqty,o.OrderTime
		from orders o,client1 c1,client2 c2
		where c2.party_code = o.party_code and c1.cl_code = c2.cl_code 
		and c1.short_name like ltrim(@partyname)+'%'  and o.scrip_cd like ltrim(@scripcd)+'%' and o.party_code like ltrim(@partycode)+'%'
		and o.series like ltrim(@series)+'%'
		and c1.trader=@statusname
		order by c1.short_name,o.scrip_cd,o.sell_buy,OrderTime 
	end
end

if @statusid='client'
begin
if @series='BE' 
	begin
		select  distinct c1.short_name,o.order_no,o.party_code ,o.scrip_cd,o.series,o.sell_buy,(o.qty-o.tradeqty),o.user_id,
		o.EffRate,o.OrderRate,o.qty,o.tradeqty,o.OrderTime
		from orders o,client1 c1,client2 c2
		where c2.party_code = o.party_code and c1.cl_code = c2.cl_code 
		and c1.short_name like ltrim(@partyname)+'%'  and o.scrip_cd like ltrim(@scripcd)+'%' and o.party_code like ltrim(@partycode)+'%'
		and (o.series ='01' or  o.series ='02' or o.series ='03' or o.series ='04' or o.series ='05')
		and o.party_code=@statusname
		order by c1.short_name,o.scrip_cd,o.sell_buy,OrderTime 
	end
else
	begin
		select  distinct c1.short_name,o.order_no,o.party_code ,o.scrip_cd,o.series,o.sell_buy,(o.qty-o.tradeqty),o.user_id,
		o.EffRate,o.OrderRate,o.qty,o.tradeqty,o.OrderTime
		from orders o,client1 c1,client2 c2
		where c2.party_code = o.party_code and c1.cl_code = c2.cl_code 
		and c1.short_name like ltrim(@partyname)+'%'  and o.scrip_cd like ltrim(@scripcd)+'%' and o.party_code like ltrim(@partycode)+'%'
		and o.series like ltrim(@series)+'%'
		and o.party_code=@statusname
		order by c1.short_name,o.scrip_cd,o.sell_buy,OrderTime 
	end	
end


if @statusid='family'
begin
if @series='BE' 
	begin 
		select  distinct c1.short_name,o.order_no,o.party_code ,o.scrip_cd,o.series,o.sell_buy,(o.qty-o.tradeqty),o.user_id,
		o.EffRate,o.OrderRate,o.qty,o.tradeqty,o.OrderTime
		from orders o,client1 c1,client2 c2
		where c2.party_code = o.party_code and c1.cl_code = c2.cl_code 
		and c1.short_name like ltrim(@partyname)+'%'  and o.scrip_cd like ltrim(@scripcd)+'%' and o.party_code like ltrim(@partycode)+'%'
		and (o.series ='01' or  o.series ='02' or o.series ='03' or o.series ='04' or o.series ='05')
		and c1.family=@statusname
		order by c1.short_name,o.scrip_cd,o.sell_buy,OrderTime 
	end 
else
	begin
		select  distinct c1.short_name,o.order_no,o.party_code ,o.scrip_cd,o.series,o.sell_buy,(o.qty-o.tradeqty),o.user_id,
		o.EffRate,o.OrderRate,o.qty,o.tradeqty,o.OrderTime
		from orders o,client1 c1,client2 c2
		where c2.party_code = o.party_code and c1.cl_code = c2.cl_code 
		and c1.short_name like ltrim(@partyname)+'%'  and o.scrip_cd like ltrim(@scripcd)+'%' and o.party_code like ltrim(@partycode)+'%'
		and o.series like ltrim(@series)+'%'
		and c1.family=@statusname
		order by c1.short_name,o.scrip_cd,o.sell_buy,OrderTime 
	end
end

GO
