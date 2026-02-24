-- Object: PROCEDURE dbo.rpt_clienttrantodaysrep1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_clienttrantodaysrep1    Script Date: 04/27/2001 4:32:34 PM ******/

/****** Object:  Stored Procedure dbo.rpt_clienttrantodaysrep1    Script Date: 3/21/01 12:50:13 PM ******/

/****** Object:  Stored Procedure dbo.rpt_clienttrantodaysrep1    Script Date: 20-Mar-01 11:38:55 PM ******/





/****** Object:  Stored Procedure dbo.rpt_clienttrantodaysrep1    Script Date: 2/5/01 12:06:16 PM ******/

/****** Object:  Stored Procedure dbo.rpt_clienttrantodaysrep1    Script Date: 12/27/00 8:58:54 PM ******/

/* report : transactionreport
   file : todaysreport.asp
*/
/* displays todays trades confirmed for a particular client */
/* chagned by mousami on 07/03/2001
    added family login
*/
CREATE PROCEDURE rpt_clienttrantodaysrep1
@statusid varchar(15),
@statusname varchar(25),
@partycode varchar(10),
@partyname varchar(21),
@scripcd varchar(12),
@trader varchar(15)
AS
if @statusid = 'broker' 
begin
select c1.short_name,t4.Order_no,t4.sell_buy,t4.Scrip_cd,t4.Series,t4.tradeqty, t4.marketrate,t4.user_id,
t4.sauda_date,t4.party_code from trade4432 t4,client1 c1,client2 c2 
where c2.party_code = t4.party_code and c1.cl_code = c2.cl_code and c1.short_name like ltrim(@partyname)+'%' 
and t4.Scrip_cd like  ltrim(@scripcd)+'%' and t4.party_code like  ltrim(@partycode)+'%'  and c1.trader like ltrim(@trader)+'%'
order by t4.party_code,c1.short_name,t4.scrip_cd,t4.sell_buy,t4.sauda_date 
end
if @statusid = 'branch' 
begin
select c1.short_name,t4.Order_no,t4.sell_buy,t4.Scrip_cd,t4.Series,t4.tradeqty, t4.marketrate,t4.user_id,
t4.sauda_date,t4.party_code from trade4432 t4,client1 c1,client2 c2 , branches b
where c2.party_code = t4.party_code and c1.cl_code = c2.cl_code and c1.short_name like ltrim(@partyname)+'%' 
and t4.Scrip_cd like  ltrim(@scripcd)+'%' and t4.party_code like  ltrim(@partycode)+'%'  and c1.trader like ltrim(@trader)+'%'
and b.short_name=c1.trader and b.branch_cd=@statusname
order by t4.party_code,c1.short_name,t4.scrip_cd,t4.sell_buy,t4.sauda_date 
end
if @statusid = 'trader' 
begin
select c1.short_name,t4.Order_no,t4.sell_buy,t4.Scrip_cd,t4.Series,t4.tradeqty, t4.marketrate,t4.user_id,
t4.sauda_date,t4.party_code from trade4432 t4,client1 c1,client2 c2 
where c2.party_code = t4.party_code and c1.cl_code = c2.cl_code and c1.short_name like ltrim(@partyname)+'%' 
and t4.Scrip_cd like  ltrim(@scripcd)+'%' and t4.party_code like  ltrim(@partycode)+'%'  
and c1.trader=@statusname
order by t4.party_code,c1.short_name,t4.scrip_cd,t4.sell_buy,t4.sauda_date 
end 
if @statusid = 'subbroker' 
begin
select c1.short_name,t4.Order_no,t4.sell_buy,t4.Scrip_cd,t4.Series,t4.tradeqty, t4.marketrate,t4.user_id,
t4.sauda_date,t4.party_code from trade4432 t4,client1 c1,client2 c2, subbrokers sb 
where c2.party_code = t4.party_code and c1.cl_code = c2.cl_code and c1.short_name like ltrim(@partyname)+'%' 
and t4.Scrip_cd like  ltrim(@scripcd)+'%' and t4.party_code like  ltrim(@partycode)+'%'
and sb.sub_broker=c1.sub_broker and sb.sub_broker=@statusname 
order by t4.party_code,c1.short_name,t4.scrip_cd,t4.sell_buy,t4.sauda_date 
end 
if @statusid = 'client' 
begin
select c1.short_name,t4.Order_no,t4.sell_buy,t4.Scrip_cd,t4.Series,t4.tradeqty, t4.marketrate,t4.user_id,
t4.sauda_date,t4.party_code from trade4432 t4,client1 c1,client2 c2
where c2.party_code = t4.party_code and c1.cl_code = c2.cl_code 
and t4.Scrip_cd like  ltrim(@scripcd)+'%' and t4.party_code =@statusname
order by t4.party_code,c1.short_name,t4.scrip_cd,t4.sell_buy,t4.sauda_date 
end

if @statusid = 'family' 
begin
select c1.short_name,t4.Order_no,t4.sell_buy,t4.Scrip_cd,t4.Series,t4.tradeqty, t4.marketrate,t4.user_id,
t4.sauda_date,t4.party_code from trade4432 t4,client1 c1,client2 c2 
where c2.party_code = t4.party_code and c1.cl_code = c2.cl_code and c1.short_name like ltrim(@partyname)+'%' 
and t4.Scrip_cd like  ltrim(@scripcd)+'%' and t4.party_code like  ltrim(@partycode)+'%'  and c1.trader like ltrim(@trader)+'%'
and c1.family=@statusname
order by t4.party_code,c1.short_name,t4.scrip_cd,t4.sell_buy,t4.sauda_date 
end

GO
